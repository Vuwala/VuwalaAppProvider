import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

TextEditingController locationController = TextEditingController();

class GoogleMapsScreeen extends StatefulWidget {
  @override
  _GoogleMapsScreeenState createState() => _GoogleMapsScreeenState();
}

class _GoogleMapsScreeenState extends State<GoogleMapsScreeen> {
  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          (latlong != null)
              ? GoogleMap(
                  initialCameraPosition: _cameraPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = (controller);
                    _controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
                  },
                  markers: _markers,
                )
              : Container(),
          Positioned(
            top: 50.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(1.0, 5.0), blurRadius: 10, spreadRadius: 3)],
              ),
              child: TextField(
                cursorColor: Colors.black,
                controller: locationController,
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 20, top: 0),
                    width: 10,
                    height: 10,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                  ),
                  hintText: "pick up",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 12.0),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  LatLng? latlong = null;
  CameraPosition? _cameraPosition;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  TextEditingController locationController = TextEditingController();

  Future getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission != PermissionStatus.granted) {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission != PermissionStatus.granted) getLocation();
      return;
    }
    getLocation();
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latlong = new LatLng(position.latitude, position.longitude);
      _cameraPosition = CameraPosition(target: latlong!, zoom: 10.0);
      if (_controller != null) _controller!.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
      _markers.add(Marker(
          markerId: MarkerId("a"),
          draggable: true,
          position: latlong!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          onDragEnd: (_currentlatLng) {
            latlong = _currentlatLng;
          }));
    });
  }
}
