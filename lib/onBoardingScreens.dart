import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'animations/pageTransitionanimations.dart';
import 'constant.dart';
import 'loginScreens/loginScreen.dart';

class onboardingScreens extends StatefulWidget {
  @override
  _onboardingScreensState createState() => _onboardingScreensState();
}

class _onboardingScreensState extends State<onboardingScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<String> bgimages = [
    "images/an_onBoarding1.png",
    "images/an_onBoarding2.png",
    "images/an_onBoarding3.png",
    "images/an_onBoading4.png",
  ];
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Vuwala",
      "bodytext":
          "Vuwala allows you to create the best version of YOU from the palm of your hand!",
      "bgimage": "images/an_onBoarding1.png",
      "vimage": "images/an_Vuwala.png",
    },
    {
      "text": "Find Your Perfect Provider",
      "bodytext":
          "Use our search feature to find providers based on type and location.",
      "bgimage": "images/an_onBoarding2.png",
      "vimage": "images/an_Vuwala.png",
    },
    {
      "text": "Easily Book!",
      "bodytext":
          "Easily book and manage appointments with the click of a button!",
      "bgimage": "images/an_onBoarding3.png",
      "vimage": "images/an_Vuwala.png",
    },
    {
      "text": "Gain Rewards!",
      "bodytext":
          "Earn vuwala points for every appointment booked, redeemable at select providers!",
      "bgimage": "images/an_onBoading4.png",
      "vimage": "images/an_Vuwala.png",
    },
  ];
  PageController _pageController =
      PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            child: PageView.builder(
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: splashData.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("${splashData[itemIndex]['bgimage']}"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            // flex: 11,
                            child: Column(
                              children: [
                                splashData[itemIndex]['vimage'] != null
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.30,
                                        child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Image.asset(
                                                "${splashData[itemIndex]['vimage']}",
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    25)))
                                    : Container(),
                              ],
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                    child: Text(
                                        "${splashData[itemIndex]['text']}",
                                        style: TextStyle(
                                            fontFamily: 'AdobeGurmukhiBold',
                                            fontSize: 25,
                                            wordSpacing: 1,
                                            letterSpacing: 1,
                                            color: Colors.white),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Text(
                                        "${splashData[itemIndex]['bodytext']}",
                                        style: TextStyle(
                                            fontFamily: 'AdobeGurmukhiMedium',
                                            fontSize: 17,
                                            wordSpacing: 1,
                                            letterSpacing: 1,
                                            color: Colors.white70),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 30.0),
              child: TextButton(
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'AdobeGurmukhiMedium',
                    fontSize: 18,
                    wordSpacing: 1,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                    decorationThickness: 1,
                  ),
                  textAlign: TextAlign.right,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    SlideLeftRoute(page: loginScreen()),
                  );
                },
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: (25),
                  backgroundColor: Color(0xffD8B65C),
                  child: IconButton(
                    icon: Image.asset('images/icons/an_left-arrow.png'),
                    padding: EdgeInsets.all(14.0),
                    onPressed: () {
                      if (currentPage == splashData.length - 1) {
                        Navigator.pushReplacement(
                          context,
                          SlideLeftRoute(page: loginScreen()),
                        );
                      } else {
                        _pageController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeOutCubic);
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.green,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      splashData.length,
                      (index) => buildDot(index: index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Color(0xffD8B65C) : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  rotationTransition(BuildContext context) {
    Navigator.of(context).push(
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return HomeScreen();
    }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return RotationTransition(
        turns: animation,
        child: SlideTransition(
          position: animation.drive(
              Tween(begin: Offset(1, 0), end: Offset(0, 0))
                  .chain(CurveTween(curve: Curves.easeInCubic))),
          child: child,
        ),
      );
    }));
  }
}
