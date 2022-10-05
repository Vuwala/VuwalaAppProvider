import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vuwala/BusinessScreens/OpenDingTimeScreen.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            height: 340,
            width: MediaQuery.of(context).size.width - 40,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox.expand(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Add Time',
                        style: TextStyle(
                          fontSize: 19.0,
                          color: Color(0xFF7286A1),
                          fontFamily: 'PoppinsRegular',
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Container(
                      height: 230,
                      child: CupertinoDatePicker(
                        initialDateTime: _dateTime,
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: (dateTime) {
                          setState(() {
                            _dateTime = dateTime;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Text("Cancel",
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: Color(0xFF7286A1),
                                  fontFamily: 'PoppinsRegular',
                                  decoration: TextDecoration.none,
                                )),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            child: Text(
                              "ok",
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 20.0,
                                color: Color(0xFF7286A1),
                                fontFamily: 'PoppinsRegular',
                              ),
                            ),
                            onTap: () {
                              final DateFormat formatter = DateFormat('h:mma');

                              final String formatted =
                                  formatter.format(_dateTime);

                              var df = DateFormat("h:mma");
                              var dt = df.parse(formatted);
                              selectedTime = DateFormat('HH:mm a').format(dt);

                              listname.add(selectedTime.toString());
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
