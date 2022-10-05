import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vuwala/loginScreens/loginScreen.dart';
import '../constant.dart';
import 'InitialData.dart';

class changePasswordScreen extends StatefulWidget {
  final emailR;
  const changePasswordScreen({Key? key, this.emailR}) : super(key: key);

  @override
  _changePasswordScreenState createState() => _changePasswordScreenState();
}

class _changePasswordScreenState extends State<changePasswordScreen> {
  var jsonData;
  TextEditingController otp = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController rePassword = TextEditingController();
  Dio dio = Dio();
  void reset() async {
    InitialData ankit = InitialData();

    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();

    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/reset_password",
        data: {
          'email': widget.emailR,
          'temp_pass': otp.text,
          'new_pass': newPassword.text,
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginScreen()));
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          _saving = false;
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void Forgot() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/forgot_password",
        data: {
          'email': widget.emailR,
        },
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
    } catch (e) {
      print(e.toString());
    }
  }

  var _saving = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/an_appbg.png"), fit: BoxFit.cover)),
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('images/an_Vuwala.png', width: MediaQuery.of(context).size.width - 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: Color(0xff69a6a8), fontSize: 30, fontFamily: 'PoppinsMedium'),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 170,
                      child: Center(
                        child: Text('Set the new password for your account so you can login and access all the features.',
                            style: TextStyle(
                              color: Color(0xff403f41),
                              fontSize: 12,
                              fontFamily: 'PoppinsMedium',
                            ),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      'Enter OTP',
                      style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                    ),
                  ),
                  Container(
                    decoration: kContainerDecoration,
                    child: TextField(
                      controller: otp,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: kOutlineInputBorder,
                        enabledBorder: kOutlineInputBorder,
                        errorBorder: kOutlineInputBorder,
                        disabledBorder: kOutlineInputBorder,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your OTP code here",
                        hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      'New Password',
                      style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                    ),
                  ),
                  Container(
                    decoration: kContainerDecoration,
                    child: TextField(
                      controller: newPassword,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: kOutlineInputBorder,
                        enabledBorder: kOutlineInputBorder,
                        errorBorder: kOutlineInputBorder,
                        disabledBorder: kOutlineInputBorder,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "New Password",
                        hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 30,
                    child: Text(
                      'Confirm New Password',
                      style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                    ),
                  ),
                  Container(
                    decoration: kContainerDecoration,
                    child: TextField(
                      controller: rePassword,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: kOutlineInputBorder,
                        enabledBorder: kOutlineInputBorder,
                        errorBorder: kOutlineInputBorder,
                        disabledBorder: kOutlineInputBorder,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Confirm New Password",
                        hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffB6B6B6)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        child: TextButton(
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff403f3f)),
                            textAlign: TextAlign.right,
                          ),
                          onPressed: () {
                            Forgot();
                          },
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: KButtonDecoration,
                        child: TextButton(
                          onPressed: () {
                            if (validate(otp: otp.text, newPass: newPassword.text, confPass: rePassword.text)) {
                              reset();
                            }
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 17, fontFamily: 'PoppinsMedium', color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate({String? otp, String? newPass, String? confPass}) {
    if (otp!.isEmpty && newPass!.isEmpty && confPass!.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (otp.isEmpty) {
      Toasty.showtoast('Please Enter Your OTP');
      return false;
    } else if (newPass!.isEmpty) {
      Toasty.showtoast('Please Enter New Password');
      return false;
    } else if (confPass!.isEmpty) {
      Toasty.showtoast('Please Re-Enter Your Password');
      return false;
    } else if (newPass.length < 8) {
      Toasty.showtoast('Password Must Contains 8 Characters');
      return false;
    } else if (newPass != confPass) {
      Toasty.showtoast('Password Must Be Same');
      return false;
    } else {
      return true;
    }
  }
}
