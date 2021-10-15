
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/adress/adressWidgets/add_buton.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/adress/adressWidgets/center_image.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/adress/adressWidgets/place_your_adress_at_the_center.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/ordersCardWidgets/back.dart';
import 'package:agelgil_user_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'adress_after_map.dart';

class AdressMap extends StatefulWidget {
  String userUid;
  AdressMap({this.userUid});
  @override
  _AdressMapState createState() => _AdressMapState();
}

class _AdressMapState extends State<AdressMap> {
  GoogleMapController _controller;
  static LatLng _initialPosition;
  Map<MarkerId, Circle> circleA = <MarkerId, Circle>{};
  LatLng _lastMapPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  
  void _getUserLocation() async {
    Position position = await 
        getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print(_initialPosition);
    });
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: 0,
              target: LatLng(position.latitude, position.longitude),
              tilt: 0,
              zoom: 19.00)));
    }
  }

  afterAdress(BuildContext context,  double latitude,
      double longitude) {
    AdressAddBlurDialog alert = AdressAddBlurDialog(
      userUid:widget.userUid,latitude: latitude,longitude: longitude,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _initialPosition == null
              ? Loading()
              : GoogleMap(
                  mapType: MapType.hybrid,
                  tiltGesturesEnabled: false,
                  onCameraMove: _onCameraMove,
                  initialCameraPosition: CameraPosition(
                    tilt: 0,
                    bearing: 0,
                    target: _initialPosition,
                    zoom: 19,
                  ),
                  circles: Set<Circle>.of(circleA.values),
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    setState(() {
                      circleA[MarkerId('a')] = Circle(
                          circleId: CircleId("A"),
                          center: LatLng(_initialPosition.latitude,
                              _initialPosition.longitude),
                          radius: 30,
                          fillColor: Colors.orange[100].withOpacity(0.4),
                          strokeColor: Colors.transparent,
                          strokeWidth: 0);
                    });
                  },
                ),
          Center(
            child: _initialPosition == null
                ? Container()
                : CenterImage()
          ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Back()
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: PlaceYourAdressAtTheCenter()
          ),
          Positioned(
            bottom: 30,
            right: 10,
            child: GestureDetector(
              onTap: () {
                afterAdress(context, _lastMapPosition.latitude,
                    _lastMapPosition.longitude);
              },
              child:AddButton()
            ),
          )
        ],
      ),
    );
  }
}
