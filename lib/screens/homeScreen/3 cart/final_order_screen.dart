import 'dart:async';

import 'package:agelgil_user_end/screens/homeScreen/3%20cart/cartWidgets/loading_button.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/ordersCardWidgets/back.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:agelgil_user_end/shared/internet_connection.dart';
import 'package:agelgil_user_end/shared/loading.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agelgil_user_end/shared/orange_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ntp/ntp.dart';

class FinalOrderScreen extends StatefulWidget {
  List foodName = [];
  List foodPrice = [];
  List foodQuantity = [];
  double totalPrice = 0;
  double subTotal = 0;
  String loungeName = '';

  String userName;
  String userPhone;
  String userSex;
  String userUid;
  String userPic;
  String loungeId;
  Function orderConfirmed;
  double serviceCharge;

  double longitude;
  double latitude;
  String information;

  String orderNumber;
  String loungeOrderNumber;

  double loungeLongitude;
  double loungeLatitude;

  double controllerServiceCharge;
  double controllerDeliveryFee;
  double controllerSFStartsAt;
  String loungeMessagingToken;
  String userMessagingToken;
  bool controllerReferralCodeLogin;
  bool controllerReferralCodeOrder;

  FinalOrderScreen(
      {this.subTotal,
      this.foodName,
      this.foodPrice,
      this.foodQuantity,
      this.information,
      this.latitude,
      this.longitude,
      this.loungeId,
      this.loungeName,
      this.loungeOrderNumber,
      this.orderConfirmed,
      this.orderNumber,
      this.serviceCharge,
      this.totalPrice,
      this.userName,
      this.userPhone,
      this.userSex,
      this.userPic,
      this.userUid,
      this.loungeLatitude,
      this.loungeLongitude,
      this.controllerDeliveryFee,
      this.controllerServiceCharge,
      this.controllerSFStartsAt,
      this.loungeMessagingToken,
      this.userMessagingToken,
      this.controllerReferralCodeLogin,
      this.controllerReferralCodeOrder});
  @override
  _FinalOrderScreenState createState() => _FinalOrderScreenState();
}

class _FinalOrderScreenState extends State<FinalOrderScreen> {
  final DatabaseService _data = DatabaseService();
  DateTime _myTime;
  DateTime _ntpTime;
  DateTime created;
  String referralCode = "";
  double distance = 0;
  double tip = 0;
  final geo = Geoflutterfire();
  bool isInternetConnected = true;
  StreamSubscription subscription;

  // Object for PolylinePoints
  PolylinePoints polylinePoints;
// List of coordinates to join
  List<LatLng> polylineCoordinates = [];
// Map storing polylines created by connecting
// two points
  Map<PolylineId, Polyline> polylines = {};
  String googleAPIKey = "AIzaSyByQibVskdRB0VCOHIkyLrdunhuC8vDYNA";
  TravelMode travelModeOption = TravelMode.walking;
  bool polyLineFinishedCalculating = true;
  bool dateFinishedCalculating = true;
  @override
  void initState() {
    super.initState();
    _createDate();
    _createPolylines();

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

  _createDate() async {
    DateTime startDate = await NTP.now();
    created = startDate;
    print(created);
    setState(() {
      dateFinishedCalculating = false;
    });
  }

  _createPolylines() async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey, // Google Maps API Key
      PointLatLng(widget.loungeLatitude, widget.loungeLongitude),
      PointLatLng(widget.latitude, widget.longitude),
      travelMode: travelModeOption,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      distance = distance +
          calculateDistance(
              polylineCoordinates[i].latitude,
              polylineCoordinates[i].longitude,
              polylineCoordinates[i + 1].latitude,
              polylineCoordinates[i + 1].longitude);
    }
    setState(() {
      polyLineFinishedCalculating = false;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    double dataDistance = 0;
    dataDistance = distance;

    if (dataDistance < 0.5) {
      dataDistance = 0.5;
    }
    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          SafeArea(
            ////////////////////back button
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 14.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(FontAwesomeIcons.arrowLeft,
                    size: 25.0, color: Colors.grey[700]),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                height: widget.controllerReferralCodeOrder == true ? 470 : 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[600],
                      blurRadius: 1.0, //effect of softening the shadow
                      spreadRadius: 0.5, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          1.0 //vertical
                          ),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('No Service charge if Subtotal is less than:',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[400],
                                )),
                            Text(
                                widget.controllerSFStartsAt.toString() +
                                    '0 Birr',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tip(Optional)',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
                                )),
                            Container(
                              width: 70.0,
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() {
                                    tip = double.parse(val);
                                  });
                                },
                                keyboardType: TextInputType.phone,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500
                                    // decorationColor: Colors.white,
                                    ),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20),

                                  //Label Text/////////////////////////////////////////////////////////
                                  labelText: '0.00',
                                  // labelText: Texts.PHONE_NUMBER_LOGIN,
                                  focusColor: Colors.orange[900],
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 15.0,
                                      color: Colors.grey[800]),
                                  /* hintStyle: TextStyle(
                                      color: Colors.orange[900]
                                      ) */
                                  ///////////////////////////////////////////////

                                  //when it's not selected////////////////////////////
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey[400])),
                                  ////////////////////////////////

                                  ///when textfield is selected//////////////////////////
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30.0)),
                                      borderSide: BorderSide(
                                          color: Colors.orange[200])),
                                  ////////////////////////////////////////
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Subtotal',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
                                )),
                            Text(widget.subTotal.toString() + '0 Birr',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                'Service charge(' +
                                    (widget.controllerServiceCharge * 100)
                                        .toInt()
                                        .toString() +
                                    '%)',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
                                )),
                            Text(widget.serviceCharge.toString() + '0 Birr',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                                'Delivery fee(' +
                                    widget.controllerDeliveryFee
                                        .toInt()
                                        .toString() +
                                    'Birr/Km) ',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
                                )),
                            Text(
                                (dataDistance * widget.controllerDeliveryFee)
                                        .toInt()
                                        .toString() +
                                    '.00 Birr',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tip',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey[500],
                                )),
                            Text(tip.toInt().toString() + '.00 Birr',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[500],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Total',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  color: Colors.grey[700],
                                )),
                            Text(
                                (widget.totalPrice +
                                            ((dataDistance *
                                                    widget
                                                        .controllerDeliveryFee)
                                                .toInt()) +
                                            (tip))
                                        .toStringAsFixed(1) +
                                    '0 Birr',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Visibility(
                        visible: widget.controllerReferralCodeOrder,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            onChanged: (val) {
                              setState(() {
                                referralCode = val;
                              });
                            },
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500

                                // decorationColor: Colors.white,
                                ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 0),

                              //Label Text/////////////////////////////////////////////////////////
                              hintText: 'Referral code (optional)',
                              focusColor: Colors.orange[900],
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 15.0,
                                  color: Colors.grey[800]),
                              // labelText: Texts.PHONE_NUMBER_LOGIN,

                              /* hintStyle: TextStyle(
                            color: Colors.orange[900]
                            ) */
                              ///////////////////////////////////////////////

                              //when it's not selected////////////////////////////
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[400])),
                              ////////////////////////////////

                              ///when textfield is selected//////////////////////////
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.orange[400])),

                              ////////////////////////////////////////
                              ///
                              ///
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red[400])),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red[400])),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: widget.controllerReferralCodeOrder,
                          child: SizedBox(height: 20.0)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: InkWell(
                          ////////////////////////ckeckout buttom
                          onTap: () async {
                            if (tip == null) {
                              tip = 0;
                            }
                            if (polyLineFinishedCalculating == false &&
                                dateFinishedCalculating == false) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              widget.orderConfirmed(
                                  widget.userUid, widget.orderNumber);
                              GeoFirePoint myLocation = geo.point(
                                  latitude: widget.loungeLatitude,
                                  longitude: widget.loungeLongitude);

                              await _data.updateOrderData(
                                widget.foodName.toList(),
                                widget.foodPrice.toList(),
                                widget.foodQuantity.toList(),
                                widget.subTotal,
                                widget.loungeName,
                                false,
                                false,
                                widget.userName,
                                widget.userPhone,
                                widget.userSex,
                                widget.userUid,
                                widget.userPic,
                                widget.loungeId,
                                widget.longitude,
                                widget.latitude,
                                widget.information,
                                created,
                                widget.orderNumber,
                                widget.loungeOrderNumber,
                                widget.serviceCharge,
                                (dataDistance * widget.controllerDeliveryFee)
                                    .toInt(),
                                tip,
                                distance,
                                myLocation,
                                widget.loungeMessagingToken,
                                widget.userMessagingToken,
                                referralCode,
                              );
                            }
                          },
                          child: polyLineFinishedCalculating
                              ? LoadingButton()
                              : dateFinishedCalculating
                                  ? LoadingButton()
                                  : OrangeButton(text: 'ORDER'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          ///////////////////////internet///////////////////////
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Visibility(
                visible: !isInternetConnected, child: InternetConnectivity()),
          ),
          /////////////////////////////////////////////////////////
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
