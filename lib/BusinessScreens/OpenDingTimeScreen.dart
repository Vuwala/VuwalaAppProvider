import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:vuwala/utils/TimePikerScreen.dart';

import '../constant.dart';

String? selectedTime;
String? selectedTimeText;
List listname = [
  "9:30 Am",
  "9:50 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
  "9:30 Am",
];

class OpenDingTimeScreen extends StatefulWidget {
  @override
  _OpenDingTimeScreenState createState() => _OpenDingTimeScreenState();
}

class _OpenDingTimeScreenState extends State<OpenDingTimeScreen> {
  @override
  void dispose() {
    selectedTime = null;
    super.dispose();
  }

  getAllData() async {
    await getToken0();
    await getBusinessId1();
    New();
  }

  var token;

  getToken0() async {
    token = await getToken();
  }

  var jsonData;
  var data;

  Dio dio = Dio();

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  var businessId;
  var businessID;
  List booking = [];
  getBusinessId1() async {
    final box = GetStorage();
    businessId = await box.read('businessId');
    setState(() {
      businessID = businessId;
    });
  }

  bool _loading = false;

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
        print(response);
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

  @override
  Widget build(BuildContext context) {
    var mediaQueryData = MediaQuery.of(context);
    final double mWidth = mediaQueryData.size.width;
    final double mHeight = mediaQueryData.size.height;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Hours of Operation',
          style: TextStyle(fontSize: 22, fontFamily: 'PoppinsRegular', color: Color(0xff69a5a8)),
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
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 10, color: Color(0xFFf6f6f8))]),
        child: SfCalendar(
          timeSlotViewSettings: TimeSlotViewSettings(
            timeIntervalHeight: 100,
            timeIntervalWidth: 150,
          ),
          view: CalendarView.week,
          dataSource: getDataSource(),
          monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
      ),
    );
  }

  _DataSource getDataSource() {
    final List<Appointment> appointments = <Appointment>[];

    for (var i in booking) {
      if (i["book_date"].toString().isNotEmpty) {
        print(i["book_date"]);
        var dateTime = DateTime.parse(i["book_date"]);
        var endDateTime = DateTime.parse(i["book_date"]);
        appointments.add(Appointment(
          startTime: dateTime,
          endTime: endDateTime.add(Duration(minutes: 60)),
          subject: i["service_name"],
          notes: i["service_name"],
          location: "",
          color: Colors.red,
        ));
      }
    }
    return _DataSource(appointments);
  }

  Future showDialogTime(BuildContext context) async {
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.1),
      context: context,
      pageBuilder: (_, __, ___) {
        return _SystemPadding(
          child: TimePicker(),
        );
      },
    );
  }

  int selectedIndex = 1;
  Container MyChips(String text, int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: 30.0,
          width: MediaQuery.of(context).size.width * 0.2777,
          decoration: BoxDecoration(shape: BoxShape.rectangle, color: index == selectedIndex ? Colors.grey : Colors.white, borderRadius: BorderRadius.circular(20.0), border: Border.all(color: Colors.grey, width: 1)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: index == selectedIndex ? Colors.white : Colors.grey,
                // height: 0.9,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container Divider() {
    return Container(
      height: 1.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget? child;

  _SystemPadding({
    Key? key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(padding: mediaQuery.viewInsets, duration: const Duration(milliseconds: 300), child: child);
  }
}
