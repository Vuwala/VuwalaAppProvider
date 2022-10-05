import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import 'InitialData.dart';
import 'loginScreen.dart';

class emailVerification extends StatefulWidget {
  final emailv;
  const emailVerification({Key? key, this.emailv}) : super(key: key);

  @override
  _emailVerificationState createState() => _emailVerificationState();
}

class _emailVerificationState extends State<emailVerification> {
  var jsonData;
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();

  Dio dio = Dio();

  void emailVerify() async {
    InitialData ankit = InitialData();

    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/email_verified",
        data: {
          'email': widget.emailv,
          'e_otp': otp.text,
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
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        setState(() {
          _saving = false;
        });
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
    }
  }

  void Otp() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/generate_email_otp",
        data: {
          'email': widget.emailv,
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
          Toasty.showtoast(jsonData['message']);
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
          child: Padding(
            padding: EdgeInsets.only(left: 40.0, right: 40.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                  ),
                  SizedBox(
                    height: 100.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Image.asset('images/an_Vuwala.png', width: MediaQuery.of(context).size.width - 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Email Verification',
                        style: TextStyle(color: Color(0xff69a6a8), fontSize: 30, fontFamily: 'PoppinsMedium'),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 170,
                      child: Center(
                        child: Text('we have sent your an SMS with a code to ${widget.emailv}',
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
                    height: 20.0,
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
                    height: 70.0,
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
                            Otp();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Color(0xffD8B65C),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(4, 4),
                            color: Colors.grey.shade400,
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (validate(
                            otp: otp.text,
                          )) emailVerify();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 17, fontFamily: 'PoppinsMedium', color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate({String? otp}) {
    if (otp!.isEmpty) {
      Toasty.showtoast('Please Enter Your OTP');
      return false;
    } else {
      return true;
    }
  }
}
