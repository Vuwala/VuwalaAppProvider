import 'dart:convert';
import 'dart:io';
import 'package:animations/animations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vuwala/animations/pageTransitionanimations.dart';
import 'package:vuwala/constant.dart';
import '../HomeScreen.dart';
import '../constant.dart';
import 'GoogleSignIn.dart';
import 'InitialData.dart';
import 'SignUpScreen.dart';
import 'forgotPasswordScreen.dart';

class loginScreen extends StatefulWidget {
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool obscureText = true;
  String? deviceToken;
  int? deviceType;
  var deviceID;
  var longitude;
  var attitude;
  var jsonData;
  var user_token;
  int? type;
  bool _saving = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Dio dio = Dio();
  InitialData ankit = InitialData();

  void login() async {
    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      _saving = true;
      deviceToken = ankit.deviceToken;
      deviceID = ankit.deviceID;
      deviceType = ankit.deviceType;
      longitude = ankit.longitude;
      attitude = ankit.latitude;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/login",
        data: {
          'email': email.text,
          'password': password.text,
          'device_id': deviceID ?? '',
          'device_token': deviceToken ?? '',
          'device_type': deviceType ?? '',
          'user_type': 2,
          'lattitude': attitude ?? '0.00',
          'longitude': longitude ?? '0.00',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await setUserData();
          setState(() {
            _saving = false;
          });
          print(jsonData['data']['user_token']);
          print("loginData");
          print(jsonData);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
          setState(() {
            _saving = false;
          });
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

  final box = GetStorage();
  Future setUserData() async {
    await setPrefData(key: 'user_token', value: jsonData['data']['user_token'].toString());
    Token = await getToken();
    await setPrefData(key: 'device_id', value: deviceID.toString());
    await setPrefData(key: 'business_id', value: jsonData['data']['business_id'].toString());
    box.write('userToken', jsonData['data']['user_token'].toString());
    box.write('businessId', jsonData['data']['business_id'].toString());
  }

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  Future setisFirst() async {
    box.write('quote', false);
  }

  var isFirst;
  getisFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? boolValue = prefs.getBool('isFirst');
    setState(() {
      isFirst = boolValue;
    });
  }

  @override
  void initState() {
    setisFirst();
    super.initState();
  }

  void loginByThirdParty({
    String? fgName,
    String? fgEmail,
    String? thirdPartyID,
    String? profilePic,
    String? loginType,
  }) async {
    InitialData ankit = InitialData();

    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    setState(() {
      deviceToken = ankit.deviceToken;
      deviceID = ankit.deviceID;
      deviceType = ankit.deviceType;
      longitude = ankit.longitude;
      attitude = ankit.longitude;
    });
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/login_by_thirdparty",
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }),
        data: {
          'email': fgEmail ?? '',
          'thirdparty_id': thirdPartyID,
          'first_name': fgName,
          'login_type': loginType,
          'user_type': 2,
          'device_type': deviceType,
          'device_token': deviceToken,
          'device_id': deviceID,
          'lattitude': 0.00,
          'longitude': 0.00,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          await setUserData();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        } else {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        setState(() {
          _saving = false;
        });
        Toasty.showtoast('Something Went Wrong');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var userData;
  Future<void> socialFBLogin() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      userData = await FacebookAuth.instance.getUserData();

      var fgName = userData['name'];
      var fgEmail = userData['email'];
      var thirdPartyID = userData['id'];
      var profilePhotoUrl = userData['picture']['data']['url'];

      if (thirdPartyID != null || thirdPartyID != '') {
        loginByThirdParty(fgName: fgName, fgEmail: fgEmail, thirdPartyID: thirdPartyID, loginType: '1', profilePic: profilePhotoUrl);
      }
    } else {}
  }

  Future appleSignIn() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    return credential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("images/an_appbg.png"), fit: BoxFit.cover)),
          child: ModalProgressHUD(
            inAsyncCall: _saving,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 90.0,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset('images/an_Vuwala.png', width: MediaQuery.of(context).size.width - 25),
                                  ))),
                          SizedBox(height: 8.0),
                          Container(
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(color: Color(0xff69a6a8), fontSize: 30, fontFamily: 'PoppinsMedium'),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Please Login to continue',
                              style: TextStyle(color: Color(0xff403f41), fontSize: 12, fontFamily: 'PoppinsMedium'),
                            ),
                          ),
                          SizedBox(height: 10.0),
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
                          SizedBox(height: 15.0),
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
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                                textAlign: TextAlign.right,
                              ),
                              onPressed: () {
                                print('onpress');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => forgotPasswordScreen()),
                                );
                              },
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: KButtonDecoration,
                              child: TextButton(
                                onPressed: () async {
                                  if (validate(email: email.text, password: password.text)) {
                                    login();
                                  }
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18, fontFamily: 'PoppinsMedium', color: Colors.white),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              socialFBLogin();
                              print('Connect with Facebook');
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: kContainerDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: Image(
                                      image: AssetImage('images/icons/an_facebook.png'),
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 140,
                                    child: Center(
                                      child: Text(
                                        'Connect with Facebook',
                                        style: TextStyle(fontSize: 16, fontFamily: 'PoppinsMedium', color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              signInWithGoogle().then((result) {
                                if (result != null) {
                                  loginByThirdParty(
                                    fgName: fgName,
                                    fgEmail: fgEmail,
                                    thirdPartyID: thirdPartyID,
                                    loginType: '2',
                                  );
                                }
                              });
                              print('Connect with Google');
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 10),
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: kContainerDecoration,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 15.0),
                                    child: Image(
                                      image: AssetImage('images/icons/an_google.png'),
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width - 140,
                                    child: Center(
                                      child: Text(
                                        'Connect with Google',
                                        style: TextStyle(fontSize: 16, fontFamily: 'PoppinsMedium', color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: Platform.isIOS ? true : false,
                            child: GestureDetector(
                              onTap: () {
                                appleSignIn().then((credential) => {
                                      loginByThirdParty(loginType: '3', thirdPartyID: credential.userIdentifier, profilePic: 'profilePic', fgEmail: credential.email == null ? credential.userIdentifier.substring(0, 8) + '@gmail.com' : credential.email, fgName: credential.givenName == null ? 'user@' + credential.userIdentifier.substring(0, 4) : credential.givenName),
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 10),
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                decoration: kContainerDecoration,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 15.0),
                                      child: Image(
                                        image: AssetImage('images/icons/an_apple-logo.png'),
                                        height: 25,
                                        width: 25,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 140,
                                      child: Center(
                                        child: Text(
                                          'Connect with Apple',
                                          style: TextStyle(fontSize: 16, fontFamily: 'PoppinsMedium', color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: TextStyle(fontSize: 14, fontFamily: 'PoppinsMedium', color: Color(0xff2F2F2F)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        page: SignUpScreen(),
                                      ));
                                },
                                child: Text(' Sign up', style: TextStyle(fontSize: 14, fontFamily: 'PoppinsBold', color: Colors.black)),
                              ),
                            ],
                          ),
                        ],
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

  bool validate({String? email, String? password}) {
    _saving = false;
    if (email!.isEmpty && password!.isEmpty) {
      Toasty.showtoast('Please Enter Your Credentials');
      return false;
    } else if (email.isEmpty) {
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
    } else {
      return true;
    }
  }
}
