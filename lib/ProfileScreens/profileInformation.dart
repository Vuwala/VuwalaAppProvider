import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../CachedImageContainer.dart';
import '../constant.dart';

class profileInformation extends StatefulWidget {
  @override
  _profileInformationState createState() => _profileInformationState();
}

class _profileInformationState extends State<profileInformation> {
  String fileName = '';
  String? setDate;
  DateTime selectedDate = DateTime.now();
  File? image;

  _imgFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      image = File(pickedImage!.path);
      if (image != null) {
        fileName = image!.path.split('/').last;
      }
    });
  }

  bool boolOption = false;

  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken1111();
    await getProfile();
  }

  var token;

  getToken1111() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();

  Dio dio = Dio();

  void editProfile() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/edit_profile",
        options: Options(
          headers: {"authorization": 'Bearer $token'},
        ),
        data: image == null
            ? data = FormData.fromMap({
                'user_type': 1,
                'first_name': firstName.text,
                'last_name': lastName.text,
                'email': email.text,
                'phone_number': phoneNo.text,
              })
            : data = FormData.fromMap({
                'user_type': 1,
                'first_name': firstName.text,
                'last_name': lastName.text,
                'email': email.text,
                'phone_number': phoneNo.text,
                'profile_pic': image == null ? '' : await MultipartFile.fromFile(image!.path, filename: fileName),
              }),
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
          Navigator.of(context).pop();
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
      setState(() {
        _saving = false;
      });
    }
  }

  var profile_pic;
  getProfile() async {
    setState(() {
      _saving = true;
    });
    print(token);
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/edit_profile",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'user_type': 1,
        },
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          _saving = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          firstName = TextEditingController(text: jsonData['data']['first_name']);
          lastName = TextEditingController(text: jsonData['data']['last_name']);
          email = TextEditingController(text: jsonData['data']['email']);
          phoneNo = TextEditingController(text: jsonData['data']['phone_number']);
          setState(() {
            _saving = false;
            profile_pic = jsonData['data']['profile_pic'];
          });
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
      setState(() {
        _saving = false;
      });
    }
  }

  bool _saving = false;
  var baseurl = "http://159.223.181.226/vuwala/";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          boolOption ? 'Edit Profile' : 'My Profile',
          style: TextStyle(fontSize: 22, fontFamily: 'PoppinsRegular', color: Color(0xff69a5a8)),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  boolOption = true;
                });
              },
              child: boolOption == false
                  ? Image(
                      image: AssetImage('images/icons/an_pencil.png'),
                      height: 20,
                      width: 20,
                    )
                  : Container(),
            ),
          ),
        ],
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
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height - 80,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 112,
                          width: 112,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(shape: BoxShape.circle),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.26,
                                  child: Container(
                                    height: 132,
                                    width: 132,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: image != null
                                        ? CircleAvatar(
                                            radius: 56,
                                            backgroundColor: Colors.white,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.file(
                                                image!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : profile_pic == null || profile_pic == 'null' || profile_pic == ''
                                            ? CircleAvatar(
                                                radius: 64,
                                                backgroundColor: Colors.white,
                                                backgroundImage: AssetImage('images/Group 62509.png'),
                                              )
                                            : CachedImageContainer(
                                                image: '$baseurl$profile_pic',
                                                height: 100,
                                                width: 100,
                                                bottomCorner: 60,
                                                topCorner: 60,
                                                fit: BoxFit.cover,
                                                placeholder: 'images/Group 62509.png',
                                              ),
                                  ),
                                ),
                              ),
                              boolOption == true
                                  ? GestureDetector(
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.asset('images/icons/an_cam.png', height: 40),
                                        ),
                                      ),
                                      onTap: () {
                                        _imgFromGallery();
                                      },
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'First Name',
                            style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff828282)),
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
                              controller: firstName,
                              readOnly: boolOption ? false : true,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Marjolaine",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xff3f3e3e)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Last Name',
                            style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff828282)),
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
                              controller: lastName,
                              readOnly: boolOption ? false : true,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Purdy",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xff3f3e3e)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff828282)),
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
                              readOnly: boolOption ? false : true,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "marjalainePurdy201@gmail.com",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xff3f3e3e)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Phone Number',
                            style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff828282)),
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
                              controller: phoneNo,
                              readOnly: boolOption ? false : true,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "+34 12345678790",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xff3f3e3e)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Visibility(
                        visible: boolOption ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                              margin: EdgeInsets.only(bottom: 30.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xff599a9a),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 2.0)],
                              ),
                              child: TextButton(
                                  onPressed: () {
                                    editProfile();
                                  },
                                  child: Text('Save', style: TextStyle(fontSize: 18, fontFamily: 'PoppinsMedium', color: Colors.white)))),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('jsonData', jsonData));
  }
}
