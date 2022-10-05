import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../CachedImageContainer.dart';
import '../constant.dart';

class PaymentHistoryScreen extends StatefulWidget {
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  var jsonData;
  var historydata = [];
  var data;
  var token;

  var total = 0.00;
  getToken00() async {
    token = await getToken();
  }

  Dio dio = Dio();
  History() async {
    setState(() {});
    print(token);
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_my_transaction",
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
          print(jsonData);
          print("dksfghdsjkh");

          setState(() {
            historydata = jsonData['data'];
          });
          print(historydata.length);
          for (int i = 0; i < historydata.length; i++) {
            total += historydata[i]["amount"];
          }
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

  an() async {
    await getToken00();
    await History();
  }

  @override
  void initState() {
    an();
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
          'Payment History',
          style: TextStyle(fontSize: 22, fontFamily: 'PoppinsMedium', color: Color(0xff69a5a8)),
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
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xff599a9a),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    height: 100.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Total Balance',
                          style: TextStyle(fontSize: 20, fontFamily: 'PoppinsRegular', color: Colors.white),
                        ),
                        Text(
                          '\$$total',
                          style: TextStyle(fontSize: 20, fontFamily: 'PoppinsRegular', color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All History',
                          style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff888888)),
                        ),
                        Text(
                          'Date',
                          style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff888888)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: historydata.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: 70,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CachedImageContainer(
                                            image: '$baseurl/${historydata[index]["profile_pic"] ?? ' fkdlb'}',
                                            width: 45,
                                            height: 45,
                                            topCorner: 6,
                                            bottomCorner: 6,
                                            fit: BoxFit.fitWidth,
                                            placeholder: 'images/Group 62509.png',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${historydata[index]["first_name"]} ${historydata[index]["last_name"]}',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'PoppinsMedium',
                                                    color: Color(0xff626162),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'order id: ${historydata[index]["transaction_id"]}',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'PoppinsRegular',
                                                        color: Color(0xff626162),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '\$${historydata[index]["amount"]}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'PoppinsMedium',
                                              color: Color(0xff626162),
                                            ),
                                          ),
                                          Text(
                                            '${historydata[index]["created_at"].toString().split(" ")[0]}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'PoppinsRegular',
                                              color: Color(0xff626162),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
