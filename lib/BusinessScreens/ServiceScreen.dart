import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../CachedImageContainer.dart';
import '../constant.dart';
import 'AddNewServiceScreen.dart';
import 'EditServiceScreen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List service = [];
  List images = [];
  List category = [];
  @override
  void initState() {
    Service1();
    ankit();
    super.initState();
  }

  ankit() async {
    await getToken00();
    await Service1();
  }

  var token;
  var categoryId;
  var categoryName;
  getToken00() async {
    token = await getToken();
  }

  FutureOr onGoBack(dynamic value) {
    Service1();
    setState(() {});
  }

  var jsonData;
  var data;
  var bId;
  Dio dio = Dio();

  Service1() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_my_service",
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
          _saving = false;
          jsonData = jsonDecode(response.toString());
        });
        if (jsonData['status'] == 1) {
          service = jsonData['data'];
          setState(() {
            bId = service[0]['business_id'];
          });
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

  var deleteId;
  void delete(var id) async {
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/delete_service",
        data: {'service_id': id},
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
          Navigator.of(context)
              .pushReplacement(
                  MaterialPageRoute(builder: (context) => ServiceScreen()))
              .then((onGoBack));
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
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

  bool _saving = false;
  @override
  Widget build(BuildContext context) {
    print(jsonData);
    showAlertDialog(BuildContext context) {
      Widget cancelButton = TextButton(
        child: Text("Cancel", style: TextStyle(color: kPrimaryColor)),
        onPressed: () {
          Navigator.pop(context, false);
        },
      );
      Widget deleteButton = TextButton(
        child: Text("Delete", style: TextStyle(color: Colors.red)),
        onPressed: () {
          print(deleteId);
          delete(deleteId);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Service"),
        content: Text("Are you sure you want to delete?"),
        actions: [
          cancelButton,
          deleteButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Service',
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
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewServiceScreen()),
                          );
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            height: 55.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xff599a9a),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Add A New Service',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'PoppinsRegular',
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      service != null
                          ? service.length != 0
                              ? ListView.builder(
                                  itemCount: service.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    print(service[index]['service_image']);
                                    return GestureDetector(
                                      onTap: () {
                                        print('on tap');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditServiceScreen(
                                              serviceName: service[index]
                                                  ['service_name'],
                                              price: service[index]
                                                  ['service_price'],
                                              Id: service[index]['service_id'],
                                              category: service[index]
                                                  ['category_id'],
                                              cName: service[index]
                                                  ['category_name'],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade400,
                                                blurRadius: 1.0,
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.only(top: 20.0),
                                          height: 220.0,
                                          child: Column(
                                            children: [
                                              service[index]['service_image'] ==
                                                          null ||
                                                      service[index][
                                                              'service_image'] ==
                                                          "null" ||
                                                      service[index][
                                                              'service_image'] ==
                                                          ""
                                                  ? Image.asset(
                                                      'images/Group 62509.png',
                                                      height: 150,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : CachedImageContainer(
                                                      image:
                                                          'http://159.223.181.226/vuwala/${service[index]['service_image']}',
                                                      width: double.infinity,
                                                      height: 150,
                                                      topCorner: 4,
                                                      bottomCorner: 0,
                                                      fit: BoxFit.fitWidth,
                                                      placeholder:
                                                          'images/Group 62509.png',
                                                    ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                    top: 10.0),
                                                child: Row(
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
                                                                service[index][
                                                                    'category_name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
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
                                                                '\$${service[index]['service_price']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                service[index][
                                                                    'service_name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
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
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    deleteId = service[
                                                                            index]
                                                                        [
                                                                        'service_id'];
                                                                  });
                                                                  showAlertDialog(
                                                                      context);
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25.0,
                                                                  width: 60.0,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4.0),
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.red)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Tab(
                                                                        icon: Image
                                                                            .asset(
                                                                          "images/icons/an_delete.png",
                                                                          height:
                                                                              13.0,
                                                                          width:
                                                                              15.0,
                                                                          // color: Colors.red,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        ' Delete',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            fontFamily:
                                                                                'PoppinsMedium',
                                                                            color:
                                                                                Colors.red),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container()
                          : Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text('No Data Found'),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
