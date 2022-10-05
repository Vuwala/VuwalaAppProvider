import 'dart:io';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'HomeScreenView.dart';
import 'ProfileScreens/profileScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    setIsFirst();
    super.initState();
  }

  Future setIsFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirst', false);
  }

  int _selectedIndex = 0;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: Image.asset('images/icons/an_home.png', height: 23),
        label: 'Home',
        activeIcon: Image.asset('images/icons/an_home-1.png', height: 23),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('images/icons/an_user (5).png', height: 23),
        label: 'profile',
        activeIcon: Image.asset('images/icons/an_user (-1.png', height: 23),
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        _onItemTapped(index);
      },
      children: <Widget>[
        HomeScreenView(),
        profileScreen(),
      ],
    );
  }

  List<Widget> pagelist = <Widget>[
    HomeScreenView(),
    profileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Vibration.vibrate(duration: 50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              offset: Offset(4, 4),
              color: Colors.grey.shade400,
              blurRadius: 15.0,
            ),
          ],
        ),
        height: Platform.isAndroid ? MediaQuery.of(context).size.height * 0.075 : MediaQuery.of(context).size.height * 0.08898,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: buildBottomNavBarItems(),
          currentIndex: _selectedIndex,
          unselectedItemColor: Color(0xff626162),
          selectedItemColor: Color(0xff626162),
          selectedLabelStyle: TextStyle(
            fontSize: 10,
            fontFamily: 'PoppinsRegular',
            color: Color(0xff626162),
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10,
            fontFamily: 'PoppinsRegular',
            color: Color(0xff626162),
          ),
          onTap: _onItemTapped,
        ),
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        ),
        child: pagelist[_selectedIndex],
      ),
    );
  }
}
