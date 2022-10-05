import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import 'InitialData.dart';
import 'emailVerificationScreen.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var deviceToken;
  var deviceType;
  var deviceID;
  var longitude;
  var lattitude;
  var jsonData;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  Dio dio = Dio();
  InitialData ankit = InitialData();
  signupUser() async {
    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      _saving = true;
      deviceToken = ankit.deviceToken;
      deviceID = ankit.deviceID;
      deviceType = ankit.deviceType;
      longitude = ankit.longitude;
      lattitude = ankit.latitude;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/register",
        data: {
          'first_name': firstName.text,
          'last_name': lastName.text,
          'email': email.text,
          'password': password.text,
          'device_id': deviceID ?? '',
          'device_token': deviceToken ?? '',
          'device_type': deviceType ?? '',
          'user_type': 2,
          'lattitude': '0.00',
          'longitude': '0.00',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => emailVerification(
                    emailv: jsonData['data']['email'],
                  )));
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
      setState(() {
        _saving = false;
      });
    }
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void toggle1() {
    setState(() {
      obscureText1 = !obscureText1;
    });
  }

  bool obscureText = true;
  bool obscureText1 = true;
  var _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/an_appbg.png"), fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 90.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset('images/an_Vuwala.png', width: MediaQuery.of(context).size.width - 25),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Color(0xff69a6a8), fontSize: 30, fontFamily: 'PoppinsMedium'),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Sign up to get Started',
                            style: TextStyle(color: Color(0xff403f41), fontSize: 12, fontFamily: 'PoppinsMedium'),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text('First Name', style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F))),
                        SizedBox(height: 4.0),
                        Container(
                          decoration: kContainerDecoration,
                          child: TextField(
                            controller: firstName,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: kOutlineInputBorder,
                              enabledBorder: kOutlineInputBorder,
                              errorBorder: kOutlineInputBorder,
                              disabledBorder: kOutlineInputBorder,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "First Name",
                              hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Last Name',
                          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                          decoration: kContainerDecoration,
                          child: TextField(
                            controller: lastName,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: kOutlineInputBorder,
                              enabledBorder: kOutlineInputBorder,
                              errorBorder: kOutlineInputBorder,
                              disabledBorder: kOutlineInputBorder,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Last Name",
                              hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                          decoration: kContainerDecoration,
                          child: TextField(
                            controller: email,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: kOutlineInputBorder,
                              enabledBorder: kOutlineInputBorder,
                              errorBorder: kOutlineInputBorder,
                              disabledBorder: kOutlineInputBorder,
                              contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Email",
                              hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'password',
                          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                            decoration: kContainerDecoration,
                            child: TextField(
                              controller: password,
                              obscureText: obscureText,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                suffix: GestureDetector(
                                  child: SizedBox(
                                    height: 22,
                                    child: Text(
                                      'view',
                                      style: TextStyle(fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                                    ),
                                  ),
                                  onTap: () {
                                    toggle();
                                  },
                                ),
                                border: InputBorder.none,
                                focusedBorder: kOutlineInputBorder,
                                enabledBorder: kOutlineInputBorder,
                                errorBorder: kOutlineInputBorder,
                                disabledBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                                hintText: "password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                              ),
                            )),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Confirm password',
                          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                        SizedBox(height: 4.0),
                        Container(
                            decoration: kContainerDecoration,
                            child: TextField(
                              controller: confirmPassword,
                              obscureText: obscureText1,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                suffix: GestureDetector(
                                  child: SizedBox(
                                    height: 22,
                                    child: Text(
                                      'view',
                                      style: TextStyle(fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                                    ),
                                  ),
                                  onTap: () {
                                    toggle1();
                                  },
                                ),
                                border: InputBorder.none,
                                focusedBorder: kOutlineInputBorder,
                                enabledBorder: kOutlineInputBorder,
                                errorBorder: kOutlineInputBorder,
                                disabledBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                                hintText: "Confirm password",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                              ),
                            )),
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xffD8B65C),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              signupUser();
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 17, fontFamily: 'PoppinsMedium', color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: Platform.isAndroid ? true : false,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'PoppinsMedium',
                                    color: Color(0xff2F2F2F),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => loginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xffffffff)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate({String? firstName, String? lastName, String? email, String? password, String? confirmPassword}) {
    if (firstName!.isEmpty && lastName!.isEmpty && email!.isEmpty && password!.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (firstName.isEmpty) {
      Toasty.showtoast('Please Enter Your First Name');
      return false;
    } else if (lastName!.isEmpty) {
      Toasty.showtoast('Please Enter Your Last Name');
      return false;
    } else if (email!.isEmpty) {
      Toasty.showtoast('Please Enter Your Email Address');
      return false;
    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      Toasty.showtoast('Please Enter Valid Email Address');
      return false;
    } else if (password!.isEmpty) {
      Toasty.showtoast('Please Enter Your Password');
      return false;
    } else if (password.length < 8) {
      Toasty.showtoast('Password Must Contains 8 Characters');
      return false;
    } else if (password != confirmPassword) {
      Toasty.showtoast('Password Must Be Same');
      return false;
    } else {
      return true;
    }
  }
}
