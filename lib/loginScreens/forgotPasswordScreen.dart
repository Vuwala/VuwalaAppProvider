import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constant.dart';
import 'ChangePasswordScreen.dart';
import 'InitialData.dart';

class forgotPasswordScreen extends StatefulWidget {
  var emailv;

  @override
  _forgotPasswordScreenState createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  var jsonData;

  TextEditingController email = TextEditingController();

  Dio dio = Dio();
  void Forgot() async {
    InitialData ankit = InitialData();
    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/forgot_password",
        data: {
          'email': email.text,
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
              builder: (context) => changePasswordScreen(
                    emailR: email.text,
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
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/an_appbg.png"), fit: BoxFit.cover)),
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Color(0xff403f41),
            ),
          ),
        ),
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
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset('images/an_Vuwala.png',
                            width: MediaQuery.of(context).size.width - 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Color(0xff69a6a8),
                            fontSize: 30,
                            fontFamily: 'PoppinsMedium'),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 170,
                      child: Center(
                        child: Text(
                            'Please enter your email address, you will receive a code to create a new password via Email.',
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
                      'Email',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'PoppinsMedium',
                          color: Color(0xff9F9F9F)),
                    ),
                  ),
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
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Email",
                        hintStyle: TextStyle(
                            fontSize: 15,
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xffB6B6B6)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: KButtonDecoration,
                      child: TextButton(
                        onPressed: () {
                          if (validate(
                            email: email.text,
                          )) Forgot();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'PoppinsMedium',
                              color: Colors.white),
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

  bool validate({String? email}) {
    if (email!.isEmpty) {
      Toasty.showtoast('Please Enter Your Register Email');
      return false;
    } else {
      return true;
    }
  }
}
