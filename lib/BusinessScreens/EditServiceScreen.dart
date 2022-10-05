import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:vuwala/BusinessScreens/ServiceScreen.dart';
import 'package:vuwala/CachedImageContainer.dart';
import '../constant.dart';

class EditServiceScreen extends StatefulWidget {
  final serviceName;
  final price;
  final Id;
  final category;
  final cName;

  const EditServiceScreen({
    Key? key,
    this.serviceName,
    this.price,
    this.Id,
    this.category,
    this.cName,
  }) : super(key: key);

  @override
  _EditServiceScreenState createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  List<Asset> images = [];
  List? allImages, pickedImages = [];
  List serviceImages = [];
  List editImages = [];

  Future<void> loadAssets() async {
    List<Asset> resultList;
    resultList = await MultiImagePicker.pickImages(
      maxImages: 300,
    );
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
    print(resultList);
  }

  String? _selectedLocation;

  var name;
  var price;
  var serviceid;
  var category;
  var image1;
  var Cname;

  getData() {
    setState(() {
      _saving = false;
      name = widget.serviceName.toString();
      category = widget.category.toString();
      Cname = widget.cName.toString();
      price = widget.price;
      serviceid = widget.Id;

      serviceName = TextEditingController(text: name);
      servicePrice = TextEditingController(text: price);
      categoryId = TextEditingController(text: category);
      categoryName = TextEditingController(text: category);
    });
  }

  var token;

  getToken000() async {
    token = await getToken();
  }

  var jsonData;
  var data;
  TextEditingController serviceName = TextEditingController();
  TextEditingController servicePrice = TextEditingController();
  TextEditingController categoryId = TextEditingController();
  TextEditingController categoryName = TextEditingController();

  Dio dio = Dio();

  void EditServiceProfile() async {
    FormData formData = FormData.fromMap({
      'service_name': serviceName.text,
      'service_price': servicePrice.text,
      'category_id': widget.category,
      'service_id': serviceid,
    });

    for (var file in images) {
      print('file.identifier');

      formData.files.addAll([
        MapEntry("service_image[]", await MultipartFile.fromFile(file.identifier!, filename: "utsav")),
      ]);
    }

    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/update_service",
        data: formData,
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
        });
        if (jsonData['status'] == 1) {
          setState(() {
            _saving = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ServiceScreen()));
          Toasty.showtoast(jsonData['message']);
        }
        if (jsonData['status'] == 0) {
          setState(() {
            _saving = false;
          });
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
      print(e.response);
      print(e.message);
    }
  }

  getService() async {
    FormData formData = FormData.fromMap({
      'service_id': serviceid,
    });
    try {
      setState(() {
        _saving = true;
      });
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/update_service",
        data: formData,
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
            _saving = false;
            serviceImages = jsonData['data']['service_image'];
          });
          for (var i in serviceImages) {
            imagesan.add(i['service_image']);
          }
        }
        if (jsonData['status'] == 0) {
          _saving = false;
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      setState(() {
        _saving = false;
      });
      print(e.response);
      print(e.message);
    }
  }

  void deleteImage(String imageId) async {
    FormData formData = FormData.fromMap({
      'id': imageId,
      'remove_type': 2,
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/remove_image",
        data: formData,
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
          getService();
        }
        if (jsonData['status'] == 0) {
          Toasty.showtoast(jsonData['message']);
        }
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.response);
      print(e.message);
    }
  }

  @override
  void initState() {
    ankit();
    super.initState();
  }

  ankit() async {
    await getData();
    await getToken000();
    await getService();
    await listCategory();
  }

  List category1 = [];
  listCategory() async {
    setState(() {
      _saving = true;
    });
    try {
      var response = await dio.post(
        "http://159.223.181.226/vuwala/api/list_category",
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
            category1 = jsonData['data'];

            _saving = false;
          });
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
      print(e.response);
      print(e.message);
    }
  }

  var _saving = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Edit Service',
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
      body: ModalProgressHUD(
        opacity: 0,
        inAsyncCall: _saving,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 130,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        height: 20,
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Add image',
                          style: TextStyle(fontSize: 12, fontFamily: 'PoppinsMedium', color: Color(0xff9F9F9F)),
                        ),
                      ),
                      Container(
                        height: 120,
                        width: double.infinity,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pickImage();
                                });
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(10),
                                color: Colors.grey,
                                dashPattern: [4, 4],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add, color: Colors.grey.shade600, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: imagesan.length,
                                itemBuilder: (context, index) {
                                  print(imagesan[index]);
                                  return Container(
                                    padding: EdgeInsets.all(9),
                                    margin: EdgeInsets.only(right: 0),
                                    height: 120,
                                    width: 120,
                                    // color: Colors.red,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          child: imagesan.isNotEmpty
                                              ? CachedImageContainer(
                                                  image: 'http://159.223.181.226/vuwala/${imagesan[index]}',
                                                  width: 120,
                                                  height: 120,
                                                  topCorner: 4,
                                                  bottomCorner: 0,
                                                  fit: BoxFit.fitWidth,
                                                  placeholder: 'images/Group 62509.png',
                                                )
                                              : Image.file(
                                                  imagesan[index],
                                                  height: 100,
                                                  width: 100,
                                                  fit: BoxFit.cover,
                                                ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        Positioned(
                                          top: -9,
                                          right: -9,
                                          child: GestureDetector(
                                            child: Image.asset('images/icons/an_close.png', height: 20, width: 20),
                                            onTap: () {
                                              setState(() {
                                                imagesan.remove(imagesan[index]);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: serviceName,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Name",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Price',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade400,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: servicePrice,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorBorder: kOutlineInputBorder,
                                contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                hintText: "Price",
                                hintStyle: TextStyle(fontSize: 15, fontFamily: 'PoppinsMedium', color: Color(0xffcfcfcf)),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Add Category',
                            style: TextStyle(fontSize: 12, fontFamily: 'PoppinsRegular', color: Color(0xff828282)),
                          ),
                          SizedBox(height: 4),
                          Container(
                            height: 45.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  hint: Text('Select Category'),
                                  elevation: 0,
                                  isExpanded: true,
                                  icon: Image.asset(
                                    'images/icons/an_down_arrow.png',
                                    height: 15.0,
                                    width: 15.0,
                                  ),
                                  // hint: Text('Please choose a location'), // Not necessary for Option 1
                                  value: _selectedLocation,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedLocation = newValue as String?;
                                    });
                                  },
                                  items: category1.map(
                                    (location) {
                                      return DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Text(location['category_name']),
                                        ),
                                        value: location['category_id'],
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                // SizedBox(height: Platform.isIOS ? 250.0 : 110.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          EditServiceProfile();
                        },
                        child: Container(
                          height: 55.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0xff599a9a),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(fontSize: 20, fontFamily: 'PoppinsRegular', color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  List images1 = [];
  List pathList = [];

  var imagesan = [];
  List imagePathList = [];
  Future pickImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 100,
      pickType: PickType.image,
    );
    if (res != null) {
      print(res.map((e) => e.path).toList());
      for (var i in res) {
        print(i.path);
        setState(() {
          pathList.add(i.path.split('/').last);
          imagesan.add(File(i.path));
          imagePathList.add(i.path);
        });
      }
    }
  }
}
