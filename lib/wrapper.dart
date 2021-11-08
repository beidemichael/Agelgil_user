import 'dart:async';

import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/1%20baseHomeScreen/base_home_screen.dart';
import 'package:agelgil_user_end/screens/signin/signIn.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:agelgil_user_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:agelgil_user_end/shared/loading.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isInternetConnected = true;
  StreamSubscription subscription;
  bool loading = true;
  LatLng myLocation;
  final geo = Geoflutterfire();
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isInternetConnected = true;
        });
      } else {
        setState(() {
          isInternetConnected = false;
        });
      }
    });
  }

  void _getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    myLocation = LatLng(_locationData.latitude, _locationData.longitude);

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserAuth>(context);
    return Scaffold(
      body: Stack(
        children: [
          myLocation == null
              ? Loading()
              : Container(
                  child: user == null
                      ? SignIn()
                      : MultiProvider(
                          providers: [
                            StreamProvider<List<UserInfo>>.value(
                              value:
                                  DatabaseService(userUid: user.uid).userInfo,
                            ),
                            StreamProvider<List<Controller>>.value(
                              value: DatabaseService().controllerInfo,
                            ),
                            StreamProvider<List<Lounges>>.value(
                              value: DatabaseService(
                                      latitude: myLocation.latitude,
                                      longitude: myLocation.longitude)
                                  .lounges,
                            )
                          ],
                          child: loading == true
                              ? Loading()
                              : BaseHomeScreen(
                                  initialPosition: myLocation,
                                ),
                        ),
                ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Visibility(
                visible: !isInternetConnected, child: InternetConnectivity()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
