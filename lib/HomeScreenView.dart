import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vibration/vibration.dart';

import 'CachedImageContainer.dart';
import 'constant.dart';

class HomeScreenView extends StatefulWidget {
  @override
  _HomeScreenViewState createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView>
    with TickerProviderStateMixin {
  var userToken, ticketPicture;
  List booking = [];
  List booking1 = [];
  List booking2 = [];
  TabController? _controller;
  bool get indexIsChanging => _indexIsChangingCount != 0;
  int _indexIsChangingCount = 0;
  bool _loading = false;
  int ticketStatus = 1;

  List<Widget> list = [
    Tab(child: AppText(text: 'New')),
    Tab(child: AppText(text: 'Ongoing')),
    Tab(child: AppText(text: 'Completed')),
  ];

  @override
  void initState() {
    ankit();
    super.initState();
    _controller =
        TabController(length: list.length, vsync: this, initialIndex: 0);
    _controller!.addListener(() {
      setState(() {});
      if (_controller!.index == 0) {
        setState(() {
          ticketStatus = 1;
        });
        New();
      } else if (_controller!.index == 1) {
        setState(() {
          ticketStatus = 2;
        });
        Ongoing();
      } else {
        setState(() {
          ticketStatus = 3;
        });
        Completed();
      }
    });
  }

  ankit() async {
    await getToken00();
    await getBusinessId1();
    await New();
    await Ongoing();
    await Completed();
  }

  var businessId;
  var businessID;
  getBusinessId1() async {
    final box = GetStorage();
    businessId = await box.read('businessId');
    setState(() {
      businessID = businessId;
    });
  }

  var token;
  getToken00() async {
    token = await getToken();
  }

  var jsonData;
  var data;

  Dio dio = Dio();

  New() async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_booking_for_provider",
        data: {'booking_status': 0, 'business_id': businessID},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
          _loading = false;
        });
        if (jsonData['status'] == 1) {
          setState(() {
            booking = jsonData['data'];

            _loading = false;
          });
        }
        if (jsonData['status'] == 0) {
          _loading = false;
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Ongoing() async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_booking_for_provider",
        data: {'booking_status': 5, 'business_id': businessID},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
            booking1 = jsonData['data'];
          });
        }
        if (jsonData['status'] == 0) {
          _loading = false;
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Completed() async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_booking_for_provider",
        data: {'booking_status': 7, 'business_id': businessID},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
            booking2 = jsonData['data'];
          });
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _loading = false;
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

  var bookId;
  void Accept(var bookingId) async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/update_booking_status",
        data: {
          'booking_status': 1,
          'business_id': businessID,
          'booking_id': bookingId,
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
            _controller!.animateTo(1);
          });
        }
        if (jsonData['status'] == 0) {
          _loading = false;
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void Complete(var bookingId) async {
    setState(() {
      _loading = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/update_booking_status",
        data: {
          'booking_status': 7,
          'business_id': businessID,
          'booking_id': bookingId
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        _loading = false;

        setState(() {
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
            _controller!.animateTo(2);
          });
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _loading = false;
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

  void Reject(var bookingId) async {
    _loading = true;
    setState(() {
      print('bookingId');
      print(bookingId);
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/update_booking_status",
        data: {
          'booking_status': 2,
          'business_id': businessID,
          'booking_id': bookingId
        },
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(response);
        setState(() {
          _loading = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _loading = false;
          });
          New();
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _loading = false;
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

  double fontsize = 16;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: _loading,
          color: Colors.transparent,
          progressIndicator: Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))),
          child: Column(
            children: [
              SizedBox(
                height: 75.0,
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
                height: 35,
                child: Container(
                  child: TabBar(
                    controller: _controller,
                    onTap: (index) {
                      Vibration.vibrate(duration: 50);
                    },
                    indicatorWeight: 3,
                    indicatorColor: Color(0xFF599a9b),
                    labelColor: Color(0xFF5a9c9c),
                    unselectedLabelColor: Color(0xff868686),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5D1911),
                      fontFamily: 'PoppinsMedium',
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF5D1911),
                      fontFamily: 'PoppinsMedium',
                    ),
                    tabs: list,
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    booking.length != 0
                        ? ListView.builder(
                            itemCount: booking.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomPaint(
                                          size: Size(
                                              300.0,
                                              (100.0 * 0.5833333333333334)
                                                  .toDouble()),
                                          painter: RPSCustomPainter(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 5.0,
                                                right: 80.0,
                                                bottom: 5.0),
                                            child: Text(
                                              booking[index]['book_f_date'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  booking[index]['profile_pic'] ==
                                                              null ||
                                                          booking[index][
                                                                  'profile_pic'] ==
                                                              "null" ||
                                                          booking[index][
                                                                  'profile_pic'] ==
                                                              ""
                                                      ? Image.asset(
                                                          'images/Group 62509.png',
                                                          height: 60,
                                                          width: 60,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedImageContainer(
                                                          image:
                                                              '$baseurl/${booking[index]['profile_pic'] ?? ' fkdlb'}',
                                                          width: 60,
                                                          height: 60,
                                                          topCorner: 6,
                                                          bottomCorner: 6,
                                                          fit: BoxFit.fitWidth,
                                                          placeholder:
                                                              'images/Group 62509.png',
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${booking[index]['user_first_name'] ?? ''}${booking[index]['user_last_name'] ?? ''}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'PoppinsBold',
                                                              color: Color(
                                                                  0xff393938)),
                                                        ),
                                                        Text(
                                                          booking[index][
                                                                  'user_email'] ??
                                                              '',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              color: Color(
                                                                  0xff959594)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Order Id: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              '\#${booking[index]['br_id'] ?? ''}'
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              '\$${booking[index]['service_price'] ?? ''}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsBold',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Service: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              booking[index][
                                                                      'service_name'] ??
                                                                  ''.toString() ??
                                                                  '',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: () {
                                                      Reject(bookId =
                                                          booking[index]
                                                              ['booking_id']);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.50 -
                                                              35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1)),
                                                      child: Center(
                                                        child: Text(
                                                          'Reject',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              color: Color(
                                                                  0xff8fbdbf)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Accept(bookId =
                                                          booking[index]
                                                              ['booking_id']);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.50 -
                                                              35,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1),
                                                          color: Color(
                                                              0xff599a9a)),
                                                      child: Center(
                                                        child: Text(
                                                          'Accept',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text('No Data Found'),
                          ),
                    booking1.length != 0
                        ? ListView.builder(
                            itemCount: booking1.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 2.0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomPaint(
                                          size: Size(
                                              300.0,
                                              (100.0 * 0.5833333333333334)
                                                  .toDouble()),
                                          painter: RPSCustomPainter(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                top: 5.0,
                                                right: 80.0,
                                                bottom: 5.0),
                                            child: Text(
                                              booking1[index]['book_f_date'] ??
                                                  '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 15.0),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  booking1[index]['profile_pic'] ==
                                                              null ||
                                                          booking1[index][
                                                                  'profile_pic'] ==
                                                              "null" ||
                                                          booking1[index][
                                                                  'profile_pic'] ==
                                                              ""
                                                      ? Image.asset(
                                                          'images/Group 62509.png',
                                                          height: 60,
                                                          width: 60,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : CachedImageContainer(
                                                          image:
                                                              '$baseurl/${booking1[index]['profile_pic'] ?? ' fkdlb'}',
                                                          width: 60,
                                                          height: 60,
                                                          topCorner: 6,
                                                          bottomCorner: 6,
                                                          fit: BoxFit.fitWidth,
                                                          placeholder:
                                                              'images/Group 62509.png',
                                                        ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${booking1[index]['user_first_name'] ?? ''}${booking1[index]['user_last_name'] ?? ''}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily:
                                                                  'PoppinsBold',
                                                              color: Color(
                                                                  0xff393938)),
                                                        ),
                                                        Text(
                                                          booking1[index][
                                                                  'user_email'] ??
                                                              '',
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              color: Color(
                                                                  0xff959594)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Order Id: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              '\#${booking1[index]['br_id'] ?? ''}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Spacer(),
                                                            Text(
                                                              '\$${booking1[index]['service_price'] ?? ''}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsBold',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Service: ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            Text(
                                                              "${booking1[index]['service_name'] ?? ''}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      fontsize,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Color(
                                                                      0xff272627)),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            65,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1)),
                                                    child: Material(
                                                      color: Color(0xff599a9a),
                                                      child: Ink(
                                                        child: InkWell(
                                                          onTap: () {
                                                            Complete(bookId =
                                                                booking1[index][
                                                                    'booking_id']);
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Completed',
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text('No Data Found'),
                          ),
                    booking2.length != 0
                        ? ListView.builder(
                            itemCount: booking2.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade400,
                                          blurRadius: 1.0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            booking2[index]['profile_pic'] ==
                                                        null ||
                                                    booking2[index]
                                                            ['profile_pic'] ==
                                                        "null" ||
                                                    booking2[index]
                                                            ['profile_pic'] ==
                                                        ""
                                                ? Image.asset(
                                                    'images/Group 62509.png',
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedImageContainer(
                                                    image:
                                                        '$baseurl/${booking2[index]['profile_pic'] ?? ' fkdlb'}',
                                                    width: 60,
                                                    height: 60,
                                                    topCorner: 6,
                                                    bottomCorner: 6,
                                                    fit: BoxFit.fitWidth,
                                                    placeholder:
                                                        'images/Group 62509.png',
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${booking2[index]['user_first_name'] ?? ''}${booking2[index]['user_last_name'] ?? ''}',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily:
                                                            'PoppinsBold',
                                                        color:
                                                            Color(0xff393938)),
                                                  ),
                                                  Text(
                                                    booking2[index]
                                                            ['user_email'] ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        color:
                                                            Color(0xff959594)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Order Id: ",
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            color: Color(
                                                                0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        '\#${booking2[index]['br_id'] ?? ''}',
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            color: Color(
                                                                0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        '\$${booking2[index]['service_price'] ?? ''}',
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            fontFamily:
                                                                'PoppinsBold',
                                                            color: Color(
                                                                0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Service: ",
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            color: Color(
                                                                0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        booking2[index][
                                                                'service_name'] ??
                                                            ''.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                            fontSize: fontsize,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            color: Color(
                                                                0xff272627)),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              height: 20,
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.50 -
                                                  35,
                                              child: Text(
                                                booking2[index]
                                                        ['book_f_date'] ??
                                                    '',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'PoppinsMedium',
                                                    color: Color(0xff272627)),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text('No Data Found'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? color;
  AppText({this.text, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(color: color, fontFamily: 'Poppins', fontSize: fontSize),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Color(0xff599a9a)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(size.width * 1.1, size.height);
    path_0.lineTo(size.width * 0.8341500, size.height);
    path_0.lineTo(size.width * 0.77, size.height * 0.4981714);
    path_0.lineTo(size.width * 0.8328667, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width * 0.0008417, size.height);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
