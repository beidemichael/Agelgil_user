import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/lounge_detail.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/map.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/mapWidgets/agelgil_button.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/mapWidgets/saved_button.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/my_orders_screen.dart';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:agelgil_user_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/favorite/my_saved_screen.dart';
import 'package:agelgil_user_end/screens/homeScreen/1 baseHomeScreen/update/optional_update.dart';
import 'package:vibration/vibration.dart';

class MapsContainer extends StatefulWidget {
  String userUid;

  String userName;
  String userPhone;
  String userPic;
  String userSex;

  Function location;
  Function orderConfirmed;
  List<Lounges> lounges;
  LatLng initialPosition;
  double controllerServiceCharge;
  double controllerDeliveryFee;
  int netVersion;
  String documentUid;
  double controllerSFStartsAt;
  String userMessagingToken;
  bool controllerReferralCodeLogin;
  bool controllerReferralCodeOrder;
  MapsContainer(
      {this.userUid,
      this.userName,
      this.userPhone,
      this.userPic,
      this.userSex,
      this.location,
      this.orderConfirmed,
      this.lounges,
      this.initialPosition,
      this.controllerDeliveryFee,
      this.controllerServiceCharge,
      this.netVersion,
      this.documentUid,
      this.controllerSFStartsAt,
      this.userMessagingToken,
      this.controllerReferralCodeLogin,
      this.controllerReferralCodeOrder});
  @override
  _MapsContainerState createState() => _MapsContainerState();
}

class _MapsContainerState extends State<MapsContainer> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  List<Orders> orders;
  bool cartVisibiliy = false;
  int categoryList = 0;
  List categoryItems = [];
  double distance = 0;
  double deliveryDistance = 0;
  double deliveryRadius = 0;
  String loungeId = '';
  String loungeName = '';
  String loungePic = '';
  double loungeLongitude = 0;
  double loungeLatitude = 0;
  bool eatThere = false;
  String token = '';

  GoogleMapController _controller;
  LatLng _initialPosition;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor eateriesIcon;
  BitmapDescriptor supermarketIcon;
  LatLng _lastMapPosition;
  double _zoom;
  double _bearing = 0;
  double markerPointerData;
  bool isOpen = false;

  Map<MarkerId, Marker> loungeMarkers = <MarkerId, Marker>{};
  bool positionLoading = false;
  String _mapStyle;
  bool gotData = false;

  void getToken() async {
    token = await firebaseMessaging.getToken();
    Future.delayed(Duration(milliseconds: 1500), () {
      DatabaseService()
          .newUserMessagingToken(widget.userUid, token, widget.documentUid);
    });
  }

  void getUserSub() async {
    await firebaseMessaging.subscribeToTopic('UserNotification');
  }

  @override
  void initState() {
    super.initState();
    getToken();

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, badge: true, provisional: true, sound: true));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate();
        }

        showOverlayNotification((context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                    size: const Size(40, 40),
                    child: ClipOval(
                        child: Container(
                      color: Colors.white,
                      child: Image(
                        image: AssetImage("images/others/agelgilLogo.png"),
                        height: 40.0,
                        width: 40.0,
                        // color: Colors.grey[300],
                      ),
                    ))),
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
                trailing: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      OverlaySupportEntry.of(context).dismiss();
                    }),
              ),
            ),
          );
        }, duration: Duration(milliseconds: 4000));
        //_showItemDialog(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    _initialPosition = widget.initialPosition;

    rootBundle.loadString('assets/custom_google_maps.txt').then((string) {
      _mapStyle = string;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/person.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 0.5), 'images/others/food.png')
        .then((onValue) {
      eateriesIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 0.5),
            'images/others/supermarket.png')
        .then((onValue) {
      supermarketIcon = onValue;
    });
    Future.delayed(Duration(seconds: 3), () {
      optionalUpdateActivator(context);
    });

    getUserSub();
  }

  ////////////////method for generating the over head text marker.
  Future<BitmapDescriptor> getMarkerName(
      final Color collor, String name, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = collor.withOpacity(0.5);
    final double tagWidth = 40.0;

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, size.width, tagWidth + 20),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr, textAlign: TextAlign.left);
    textPainter.text = TextSpan(
      text: name,
      style: TextStyle(
          fontSize: 30.0, fontWeight: FontWeight.w800, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(40, 10));

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  getFromDatabase(List<Lounges> lounges) async {
    //for marker symbol
    for (int i = 0; i < lounges.length; i++) {
      deliveryDistance = calculateDistance(
          lounges[i].latitude,
          lounges[i].longitude,
          _initialPosition.latitude,
          _initialPosition.longitude);

      // print(deliveryDistance);
      deliveryRadius = lounges[i].deliveryRadius;
      double differenceOfRadiuses = deliveryRadius - deliveryDistance;

      int markerNumber = 0;
      var markerIdVal = lounges[i].documentId;
      String markerIdVal2 = lounges[i].documentId + markerNumber.toString();

      final MarkerId markerId = MarkerId(markerIdVal);
      String markerIdVal4 = lounges[i].documentId +
          markerNumber.toString() +
          markerNumber.toString() +
          markerNumber.toString();

      // creating a new MARKER

      //////////////////////////Over head text(name of eatery)//////////////////////

      final Marker markerName = Marker(
          onTap: () {
            if (lounges[i].name != null) {
              setState(() {
                isOpen = lounges[i].weAreOpen;
                categoryItems = lounges[i].category;
                categoryList = lounges[i].category.length;
                loungeName = lounges[i].name;
                loungeId = lounges[i].id;
                loungePic = lounges[i].images;
                loungeLatitude = lounges[i].latitude;
                eatThere = lounges[0].eatThere;
                loungeLongitude = lounges[i].longitude;
                distance = calculateDistance(
                    lounges[i].latitude,
                    lounges[i].longitude,
                    _initialPosition.latitude,
                    _initialPosition.longitude);
              });
            }
            lounges[i].category == null
                ? loading()
                : loungeDetailActivator(context);
          },
          markerId: markerId,
          anchor: Offset(0.5, 1.1),
          position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
          icon: await getMarkerName(
              lounges[i].lounge == 'eatery' ? Colors.red : Colors.cyan,
              lounges[i].name,
              Size(lounges[i].name.length.toDouble() * 17 + 70, 150.0)));
      //////////////////////////Over head text(name of eatery)//////////////////////
      ///
      ///
      /////////////////////////////eatery symbol//////////////////////

      final Marker marker = Marker(
        markerId: MarkerId(markerIdVal2.toString()),
        position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
        icon: lounges[i].lounge == 'eatery' ? eateriesIcon : supermarketIcon,
        onTap: () {
          if (lounges[i].name != null) {
            setState(() {
              isOpen = lounges[i].weAreOpen;
              categoryItems = lounges[i].category;
              categoryList = lounges[i].category.length;
              loungeName = lounges[i].name;
              loungeId = lounges[i].id;
              loungePic = lounges[i].images;
              loungeLatitude = lounges[i].latitude;
              loungeLongitude = lounges[i].longitude;
              eatThere = lounges[0].eatThere;
              distance = calculateDistance(
                  lounges[i].latitude,
                  lounges[i].longitude,
                  _initialPosition.latitude,
                  _initialPosition.longitude);
            });
          }
          lounges[i].category == null
              ? loading()
              : loungeDetailActivator(context);
        },
      );

      /////////////////////////////eatery symbol//////////////////////

      ////////////////////////////////eatery open//////////////////////
      final Marker markerOpen = Marker(
          onTap: () {
            if (lounges[i].name != null) {
              setState(() {
                categoryItems = lounges[i].category;
                categoryList = lounges[i].category.length;
                loungeName = lounges[i].name;
                loungeId = lounges[i].id;
                loungePic = lounges[i].images;
                distance = calculateDistance(
                    lounges[i].latitude,
                    lounges[i].longitude,
                    _initialPosition.latitude,
                    _initialPosition.longitude);
              });
            }
            lounges[i].category == null
                ? loading()
                : loungeDetailActivator(context);
          },
          markerId: MarkerId(markerIdVal4.toString()),
          anchor: Offset(0.5, 9.4),
          position: LatLng(lounges[i].latitude ?? 0, lounges[i].longitude ?? 0),
          icon: await getMarkerName(
              lounges[i].weAreOpen == true ? Colors.red : Colors.grey,
              lounges[i].weAreOpen == true ? '' : '',
              Size(35, 20.0)));

      /////////////////////////////eatery open//////////////////////
      if (lounges[i].active == true
          // && lounges[i].weAreOpen == true
          ) {
        if (differenceOfRadiuses >= 0) {
          setState(() {
            // adding a new marker to map
            loungeMarkers[markerId] = markerName;
            loungeMarkers[MarkerId(markerIdVal2.toString())] = marker;
            loungeMarkers[MarkerId(markerIdVal4.toString())] = markerOpen;
          });
        } else {
          setState(() {
            loungeMarkers.remove(markerId);
            loungeMarkers.remove(MarkerId(markerIdVal2.toString()));
            loungeMarkers.remove(MarkerId(markerIdVal4.toString()));
          });
        }
      } else {
        setState(() {
          loungeMarkers.remove(markerId);
          loungeMarkers.remove(MarkerId(markerIdVal2.toString()));
          loungeMarkers.remove(MarkerId(markerIdVal4.toString()));
        });
      }
      markerNumber++;
    }
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    _zoom = position.zoom;
    _bearing = position.bearing;
  }

  void setCompass() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 0,
        target: LatLng(_lastMapPosition.latitude, _lastMapPosition.longitude),
        tilt: 60,
        zoom: _zoom)));
  }

  void _getUserLocation() async {
    setState(() {
      positionLoading = true;
    });

    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      positionLoading = false;
    });
    if (_controller != null) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(
              bearing: _bearing,
              target:
                  LatLng(_initialPosition.latitude, _initialPosition.longitude),
              tilt: 60,
              zoom: 17.00)));
    }
  }

  loungeDetailActivator(BuildContext context) {
//  Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => StreamProvider<List<Orders>>.value(
//                     value: DatabaseService(userUid: widget.userUid).orders,
//                     child: MyOrdersScreen()),
//               ));

    // LoungeDetailBlurryDialog alert = LoungeDetailBlurryDialog(
    //     widget.userName,
    //     widget.userPic,
    //     widget.userUid,
    //     widget.userPhone,
    //     categoryList,
    //     categoryItems,
    //     distance,
    //     loungeId,
    //     loungeName,
    //     loungePic,
    //     widget.orderConfirmed,
    //     loungeLatitude,
    //     loungeLongitude,
    //     widget.controllerDeliveryFee,
    //     widget.controllerServiceCharge,
    //     isOpen);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StreamProvider<List<Lounge>>.value(
            value: DatabaseService(id: loungeId).loungesIsOpen,
            child: LoungeDetailBlurryDialog(
                widget.userName,
                widget.userPic,
                widget.userUid,
                widget.userPhone,
                widget.userSex,
                categoryList,
                categoryItems,
                distance,
                loungeId,
                loungeName,
                loungePic,
                widget.orderConfirmed,
                loungeLatitude,
                loungeLongitude,
                widget.controllerDeliveryFee,
                widget.controllerServiceCharge,
                isOpen,
                eatThere,
                widget.controllerSFStartsAt,
                widget.userMessagingToken,
                widget.controllerReferralCodeLogin,
                widget.controllerReferralCodeOrder));
      },
    );
  }

  optionalUpdateActivator(BuildContext context) {
    if (widget.netVersion == 3 || widget.netVersion == 4) {
      OptionalUpdate alert = OptionalUpdate();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  loading() {}

  @override
  Widget build(BuildContext context) {
    if (gotData == false) {
      getFromDatabase(widget.lounges);
      if (widget.lounges.length > 0) {
        gotData = true;
      }
    }

    final orders = Provider.of<List<Orders>>(context) ?? [];

    if (orders.length < 1) {
      setState(() {
        cartVisibiliy = false;
      });
    } else {
      setState(() {
        cartVisibiliy = true;
      });
    }
    return Scaffold(
      body: _initialPosition == null
          ? Loading()
          : Stack(
              children: <Widget>[
                Positioned(
                    child: MapCenter(
                  loungeMarkers: loungeMarkers,
                  initialPosition: _initialPosition,
                  // updateLounges: getFromDatabase(widget.lounges),
                )),
                Positioned(
                  child: Stack(
                    children: [
                      // Positioned(
                      //     right: 20, bottom: 205, child: FavoriteButton(orders)),
                      Positioned(
                          right: 20, bottom: 175, child: AgelgilButton(orders)),
                      Positioned(
                        right: 20,
                        bottom: 215,
                        child: Visibility(
                          visible: cartVisibiliy,
                          child: Container(
                            height: 23.0,
                            width: 23.0,
                            decoration: BoxDecoration(
                              color: Colors.orange[500].withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                              child: Text(
                                orders.length.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  AgelgilButton(List<Orders> orders) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamProvider<List<Orders>>.value(
                    value: DatabaseService(userUid: widget.userUid).orders,
                    child: MyOrdersScreen()),
              ));
        },
        child: AgelgilButtonWidget());
  }

  FavoriteButton(List<Orders> orders) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamProvider<List<Orders>>.value(
                    value: DatabaseService(userUid: widget.userUid).orders,
                    child: MySavedScreen()),
              ));
        },
        child: SavedButtonWidget());
  }
}
