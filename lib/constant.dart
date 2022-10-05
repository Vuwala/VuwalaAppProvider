import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Toasty {
  static showtoast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.5),
    );
  }
}

var baseurl = "http://159.223.181.226/vuwala/";

final kContainerDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      offset: Offset(2, 2),
      color: Colors.grey.shade400,
      blurRadius: 3.0,
    ),
  ],
);
const kAnimationDuration = Duration(milliseconds: 200);
final KButtonDecoration = BoxDecoration(
  shape: BoxShape.rectangle,
  color: Color(0xffD8B65C),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.shade400,
      blurRadius: 3.0,
    ),
  ],
);

final kOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade100),
  borderRadius: BorderRadius.circular(10),
);

final kBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(4),
  boxShadow: [BoxShadow(blurRadius: 04, color: Colors.grey.shade400)],
);

final kDropdownDeco = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  filled: true,
  fillColor: Colors.white,
  focusedBorder: kOutlineInputBorder,
  enabledBorder: kOutlineInputBorder,
  errorBorder: kOutlineInputBorder,
  focusedErrorBorder: kOutlineInputBorder,
  // labelStyle: kTextFieldStyle,
);
final kButtonStyleWhitSmall = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);

final kButtonStyleGreySmall = TextStyle(
  fontSize: 12.0,
  color: Colors.grey,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);
final kDarkGreenSmallest = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
  fontFamily: 'regular',
  decoration: TextDecoration.none,
);
final kTextTitle1 = TextStyle(
  fontSize: 19.0,
  color: Color(0xFF7286A1),
  fontFamily: 'PoppinsMedium',
  decoration: TextDecoration.none,
);
const kPrimaryColor = Color(0xff0059A5);
Future setPrefData({String? key, String? value}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key!, value!);
}

Future getPrefData({String? key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.getString(key!);
  return data;
}

Future clearPrefData({String? key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = await prefs.remove(key!);
  return data;
}

Future<void> keepLogedIn() async {
  SharedPreferences login = await SharedPreferences.getInstance();
  login.setBool("isLoggedIn", true);
}

var Token;

getToken() async {
  final box = GetStorage();
  Token = await box.read('userToken');
  return Token;
}

var businnessId;
getBusinessId() async {
  final box = GetStorage();
  Token = await box.read('business_id');
  return Token;
}

var userId;
getUserId() async {
  SharedPreferences userId1 = await SharedPreferences.getInstance();
  userId = userId1.getString('user_id');
  return userId;
}
