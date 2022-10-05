import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vuwala/HomeScreen.dart';
import 'package:vuwala/constant.dart';
import 'package:vuwala/loginScreens/loginScreen.dart';

import 'onBoardingScreens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var isFirst;
  var token;

  @override
  void initState() {
    ankit();
    super.initState();
  }

  final box = GetStorage();

  ankit() async {
    await getIsFirst();
    await getToken();
    await startTime();
  }

  Future getIsFirst() async {
    print(box.read('quote'));
    print(box.read('userToken'));
    var getBool = await box.read('quote');
    token = await box.read('userToken');
    setState(() {
      isFirst = getBool;
    });
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    print("TokenAnkit");
    print(Token);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => isFirst == null || isFirst == true
              ? onboardingScreens()
              : token == null || token == 'null' || token == ''
                  ? loginScreen()
                  : HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/an_bg.png"), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset('images/an_Vuwala.png',
                        width: MediaQuery.of(context).size.width - 25))),
            Center(
                child: Container(
                    width: 350,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Text(
                            'CREATING THE BEST YOU FROM THE PALM OF YOUR HAND',
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 13,
                                wordSpacing: 1,
                                letterSpacing: 1,
                                color: Colors.grey),
                            textAlign: TextAlign.center)))),
            SizedBox(height: 15),
            Container(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Image(image: AssetImage('images/an_Group 62486.png'))),
            Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: Image.asset("images/an_splashbottom.png",
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.30))
          ],
        ),
      ),
    );
  }
}
