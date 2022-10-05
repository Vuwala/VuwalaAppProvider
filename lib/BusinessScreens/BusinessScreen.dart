import 'package:flutter/material.dart';
import 'BusinessInformationScreen.dart';
import 'OpenDingTimeScreen.dart';
import 'ServiceScreen.dart';

class BusinessScreen extends StatefulWidget {
  @override
  _BusinessScreenState createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> {
  List Listname = [];
  @override
  void initState() {
    Listname.add('Business Information');
    Listname.add('Service');
    Listname.add('Hours of Operation');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'My Business',
          style: TextStyle(
              fontSize: 22,
              fontFamily: 'PoppinsMedium',
              color: Color(0xff69a5a8)),
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 25.0,
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: Listname.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return WalletTile(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BusinessInformationScreen()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiceScreen()),
                      );
                    } else if (index == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpenDingTimeScreen()),
                      );
                    }
                  },
                  index: index,
                  title: Listname[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTile extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final int? index;

  WalletTile({this.onTap, this.title, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20),
        margin: EdgeInsets.only(bottom: 10),
        height: 70,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'PoppinsMedium',
                color: Color(0xff626162),
              ),
            ),
            Image.asset(
              'images/icons/an_Iconarrow-back.png',
              height: 13,
              width: 13,
            ),
          ],
        ),
      ),
    );
  }
}
