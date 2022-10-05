import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:images_picker/images_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vuwala/BusinessScreens/BusinessScreen.dart';

import '../constant.dart';

class BusinessInformationScreen extends StatefulWidget {
  @override
  _BusinessInformationScreenState createState() => _BusinessInformationScreenState();
}

class _BusinessInformationScreenState extends State<BusinessInformationScreen> {
  @override
  void initState() {
    _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocation();
    getToken1();
    super.initState();
  }

  var token;

  getToken1() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  TextEditingController businessName = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController information = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController url = TextEditingController();

  Dio dio = Dio();

  void businnesssProfile() async {
    FormData formData = FormData.fromMap({
      'user_type': '2',
      'business_name': businessName.text,
      'business_address': locationController.text,
      'email': email.text,
      'phone_number': contactNumber.text,
      'business_information': information.text,
      'business_endtime': DateFormat("HH:mm:ss").format(DateFormat.jm().parse(endTime.text)),
      'business_starttime': DateFormat("HH:mm:ss").format(DateFormat.jm().parse(startTime.text)),
      'business_url': url.text,
    });
    for (var i = 0; i < imagePathList.length; i++) {
      var fileName = imagePathList[i].toString().split('/').last;
      formData.files.addAll([
        MapEntry("image_url[]", await MultipartFile.fromFileSync("${imagePathList[i]}", filename: fileName)),
      ]);
    }
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/edit_profile",
        data: formData,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BusinessScreen()));
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        setState(() {
          _saving = false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        _saving = false;
      });
      Toasty.showtoast(e.toString());
      print(e.toString());
    }
  }

  var _saving = false;
  @override
  Widget build(BuildContext context) {
    final maxlines = 5;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Business Information',
          style: TextStyle(fontSize: 22, fontFamily: 'PoppinsMedium', color: Color(0xff69a5a8)),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                'images/icons/an_Icon ionic-ios-arrow-round-back.png',
                height: 25.0,
                width: 25.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        height: 20,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Add image',
                          style: TextStyle(fontSize: 12, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                      ),
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pickImage();
                                });
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10),
                                color: Colors.grey,
                                dashPattern: [4, 4],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.grey.shade600, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imagesan.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    child: Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            child: Image.file(
                                              imagesan[index],
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          Positioned(
                                            top: -9,
                                            right: -9,
                                            child: GestureDetector(
                                              child: Image.asset('images/icons/an_close.png', height: 20, width: 20),
                                              onTap: () {
                                                setState(() {
                                                  imagesan.remove(imagesan[index]);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Business Name',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.5,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: businessName,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Business Name",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Business Address',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.5,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: locationController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    // getCurrentAddress();
                                    // getCurrentLocation();
                                    // getLocation();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => GoogleMapsScreeen()),
                                    // );
                                  },
                                  icon: Icon(
                                    Icons.my_location,
                                    size: 25.0,
                                  ),
                                ),
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(top: 13),
                                hintText: "Business Address",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Contact Number',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              controller: contactNumber,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Contact Number",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Email Address',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: email,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Email Address",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Business url',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: url,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Business url",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Information',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: maxlines * 24.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: information,
                              keyboardType: TextInputType.multiline,
                              maxLines: maxlines,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Information",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start time',
                                  style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    onTap: () async {
                                      var time1 = await showTimePicker(
                                        builder: (context, child) => Theme(
                                          data: ThemeData().copyWith(colorScheme: ColorScheme.highContrastLight(primary: kPrimaryColor, onPrimary: Colors.white, onSurface: Colors.black)),
                                          child: child!,
                                        ),
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      startTime.text = time1!.format(context);
                                    },
                                    readOnly: true,
                                    controller: startTime,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorBorder: kOutlineInputBorder,
                                      contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                      hintText: "Start time",
                                      hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'End time',
                                  style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    onTap: () async {
                                      var time1 = await showTimePicker(
                                        builder: (context, child) => Theme(
                                          data: ThemeData().copyWith(colorScheme: ColorScheme.highContrastLight(primary: kPrimaryColor, onPrimary: Colors.white, onSurface: Colors.black)),
                                          child: child!,
                                        ),
                                        initialTime: TimeOfDay.now(),
                                        context: context,
                                      );
                                      endTime.text = time1!.format(context);
                                    },
                                    readOnly: true,
                                    controller: endTime,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      errorBorder: kOutlineInputBorder,
                                      contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15,
                                      ),
                                      hintText: "End time",
                                      hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          businnesssProfile();
                        },
                        child: Container(
                          height: 55.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xff599a9a),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 20, fontFamily: 'PoppinsRegular', color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  List images1 = [];
  List pathList = [];

  var imagesan = [];
  List imagePathList = [];
  Future pickImage() async {
    print("=========");
    List<Media>? res = await ImagesPicker.pick(
      count: 100,
      pickType: PickType.image,
    );
    if (res != null) {
      print(res.map((e) => e.path).toList());
      for (var i in res) {
        print(i.path);
        setState(() {
          pathList.add(i.path.split('/').last);
          imagesan.add(File(i.path));
          imagePathList.add(i.path);
        });
      }
    }
  }

  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    setState(() {
      latlong = new LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: latlong!, zoom: 10.0);
      if (_controller != null) _controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      _markers.add(Marker(
          markerId: MarkerId("a"),
          draggable: true,
          position: latlong!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onDragEnd: (_currentlatLng) {
            latlong = _currentlatLng;
          }));
    });
  }
}
