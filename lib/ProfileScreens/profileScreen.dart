import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vuwala/BusinessScreens/BusinessScreen.dart';
import 'package:vuwala/ProfileScreens/profileInformation.dart';
import 'package:vuwala/WalletSceens/walletScreen.dart';
import 'package:vuwala/loginScreens/InitialData.dart';
import 'package:vuwala/loginScreens/loginScreen.dart';
import '../CachedImageContainer.dart';
import '../constant.dart';
import 'changePassword.dart';

class profileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  List Listname = [];
  var token;

  @override
  void initState() {
    Listname.add('My Business');
    Listname.add('My Profile');
    Listname.add('My Wallet');
    Listname.add('Change Password');
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken11();
    await editProfile();
  }

  getToken11() async {
    token = await getToken();
  }

  FutureOr onGoBack(dynamic value) {
    editProfile();
    setState(() {});
  }

  var deviceID;
  var jsonData;
  var user_token;

  Dio dio = Dio();

  void logout() async {
    InitialData ankit = InitialData();

    await ankit.getDeviceToken();
    await ankit.getDeviceTypeId();
    await ankit.getDeviceTypeId();
    setState(() {
      deviceID = ankit.deviceID;
    });

    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/logout",
        options: Options(
          headers: {"authorization": 'Bearer $token'},
        ),
        data: {
          'device_id': deviceID.toString(),
        },
      );

      if (response.statusCode == 200) {
        final box = GetStorage();
        box.remove('userToken');
        box.erase();
        await clearPrefData(key: 'user_token');
        await clearPrefData(key: 'device_id');

        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => loginScreen()));
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  var data, profileData;
  String? firstname, lastname, email1, profile;
  editProfile() async {
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/edit_profile",
        data: {
          'user_type': 1,
        },
        options: Options(
          headers: {"authorization": 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());

          firstname = jsonData['data']['first_name'];
          lastname = jsonData['data']['last_name'];
          email1 = jsonData['data']['email'];
          profile = jsonData['data']['profile_pic'];
        });

        if (jsonData['status'] == 1) {}
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 50.0,
                    child: Text(
                      'Profile',
                      style: TextStyle(fontSize: 22, fontFamily: 'PoppinsRegular', color: Color(0xff69a5a8)),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      // border: Border.all(color: Colors.grey.),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 80.0,
                    width: MediaQuery.of(context).size.width - 40,
                    child: Row(
                      children: [
                        profile == null || profile == "null" || profile == ""
                            ? Image.asset(
                                'images/Group 62509.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              )
                            : CachedImageContainer(
                                image: '$baseurl/${profile ?? ''}',
                                width: 80,
                                height: 80,
                                topCorner: 6,
                                bottomCorner: 6,
                                fit: BoxFit.cover,
                                placeholder: 'images/Group 62509.png',
                              ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${firstname ?? ''} ${lastname ?? ''}',
                                style: TextStyle(fontSize: 17, fontFamily: 'PoppinsBold', color: Color(0xff393938)),
                              ),
                              Text(
                                '${email1 ?? ''}',
                                style: TextStyle(fontSize: 13, fontFamily: 'PoppinsRegular', color: Color(0xff959594)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 17),
                    child: ListView.builder(
                      itemCount: Listname.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return HomeTile(
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BusinessScreen()),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => profileInformation()),
                              ).then((onGoBack));
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => walletScreen()),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => changePassword()),
                              );
                            }
                          },
                          index: index,
                          title: Listname[index],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                logout();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                child: Container(
                  height: 45.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xffd64343),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Tab(
                        icon: Image.asset(
                          "images/icons/an_Icon feather-log-out.png",
                          height: 20.0,
                          width: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        ' Logout',
                        style: TextStyle(fontSize: 17, fontFamily: 'PoppinsRegular', color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final int? index;

  HomeTile({this.onTap, this.title, this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 2.0,
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: 45,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'PoppinsRegular',
                    color: Color(0xff262526),
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                'images/icons/an_Iconarrow-back.png',
                height: 13,
                width: 13,
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
