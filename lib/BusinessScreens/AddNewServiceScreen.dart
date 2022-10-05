import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';

class AddNewServiceScreen extends StatefulWidget {
  @override
  _AddNewServiceScreenState createState() => _AddNewServiceScreenState();
}

class _AddNewServiceScreenState extends State<AddNewServiceScreen> {
  List category = [];

  String? _selectedLocation;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    await getToken1();
    await getBusinessId1();
    await listCategory();
  }

  var token;

  getToken1() async {
    token = await getToken();
  }

  var businessId;
  var businessID;
  getBusinessId1() async {
    final box = GetStorage();
    businessId = await box.read('businessId');
    setState(() {
      businessID = businessId;
    });
  }

  var jsonData;
  var data;
  TextEditingController serviceName = TextEditingController();
  TextEditingController servicePrice = TextEditingController();

  Dio dio = Dio();

  addService() async {
    setState(() {
      _saving = true;
    });
    FormData formData = FormData.fromMap({
      'service_name': serviceName.text,
      'service_price': servicePrice.text,
      'category_id': _selectedLocation,
      'business_id': businessID,
    });
    for (var i = 0; i < imagePathList.length; i++) {
      print(imagePathList[i]);
      var fileName = imagePathList[i].toString().split('/').last;
      print('$fileName');
      formData.files.addAll([
        MapEntry("service_image[]", await MultipartFile.fromFileSync("${imagePathList[i]}", filename: fileName)),
      ]);
    }

    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/add_service",
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
          _saving = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
          });
          Navigator.of(context).pop();
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response);
      print(e.message);
    }
  }

  listCategory() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_category",
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
            category = jsonData['data'];
            _saving = false;
          });
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
      print(e.response);
      print(e.message);
    }
  }

  var _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Add A New Service',
          style: TextStyle(fontSize: 22, fontFamily: 'PoppinsRegular', color: Color(0xff69a5a8)),
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
        opacity: 0,
        inAsyncCall: _saving,
        child: SafeArea(
            child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
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
                                        // overflow: Overflow.visible,
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
                            'Name',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'PoppinsRegular',
                              color: Color(0xff828282),
                            ),
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
                              controller: serviceName,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Name",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Price',
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
                              controller: servicePrice,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Price",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'Medium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add Category',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 45.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  hint: Text('Select Category'),
                                  elevation: 0,
                                  isExpanded: true,
                                  icon: Image.asset(
                                    'images/icons/an_down_arrow.png',
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                  // hint: Text('Please choose a location'), // Not necessary for Option 1
                                  value: _selectedLocation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedLocation = newValue as String?;

                                      print('_selectedLocation');
                                      print("Ankit $_selectedLocation");
                                    });
                                  },
                                  items: category.map(
                                    (location) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(location['category_name']),
                                        ),
                                        value: location['category_id'].toString(),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
              child: GestureDetector(
                onTap: () {
                  addService();
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
            ),
          ],
        )),
      ),
    );
  }

  List images1 = [];
  List pathList = [];

  var imagesan = [];
  List imagePathList = [];
  Future pickImage() async {
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
}
