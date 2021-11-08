//base homw screen
import 'dart:async';
import 'dart:math';
import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/models/cart.dart';
import 'package:agelgil_user_end/screens/homeScreen/1%20baseHomeScreen/pre_order_confirmed.dart';
import 'package:agelgil_user_end/screens/homeScreen/1%20baseHomeScreen/set_name/forced_name.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/alertWindow/location_ask.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/lounge_closed_message.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/lounge_detail.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/mapsContainer.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/drawer_content.dart';
import 'package:agelgil_user_end/screens/homeScreen/2%20menu/menus.dart';
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agelgil_user_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lounge_listview/lounge_listview.dart';
import 'update/forced_update.dart';

class BaseHomeScreen extends StatefulWidget {
  LatLng initialPosition;
  BaseHomeScreen({this.initialPosition});
  @override
  _BaseHomeScreenState createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen>
    with TickerProviderStateMixin {
  AnimationController drawerContoller;
  Animation drawerAnimation;
  AnimationController loungeIsClosedContoller;
  Animation loungeIsClosedAnimation;
  String userUid = '';
  String userName = '';
  String userSex = '';
  String userPhone = '';
  String userPic = '';
  String documentId = '';
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  MediaQueryData queryData;
  bool drawerIcon = false;
  double controllerServiceCharge = 0;
  double controllerDeliveryFee = 0;
  int controllerVersion = 0;
  double controllerSFStartsAt = 0.0;
  bool controllerReferralCodeLogin = false;
  bool controllerReferralCodeOrder = false;
  bool controllerPhoneCustomerSupport = false;
  String userMessagingToken = '';
/////
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
  bool isOpen = false;

/////
  int netVersion;
  /////////////////////////// App version
  int appVersion = 20;
  //////////////////////////  App version

  @override
  void initState() {
    super.initState();

    drawerContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });
    drawerAnimation = Tween<double>(begin: 0, end: 90).animate(drawerContoller);

    loungeIsClosedContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    loungeIsClosedAnimation =
        Tween<double>(begin: -70, end: 20).animate(loungeIsClosedContoller);
  }

  loungeIsClosed() {
    loungeIsClosedContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      loungeIsClosedContoller.reverse();
    });
  }

  drawerState() {
    if (drawerIcon == false) {
      drawerContoller.forward();
      drawerIcon = true;
    } else {
      drawerContoller.reverse();
      drawerIcon = false;
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  loading() {}

  orderConfirmed(String userUidconfirm, String orderNumber) {
    PreOrderConfirmed alert = PreOrderConfirmed(
        userUidconfirm: userUidconfirm, orderNumber: orderNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<List<UserInfo>>(context);
    final controllerInfo = Provider.of<List<Controller>>(context);
    final loungess = Provider.of<List<Lounges>>(context) ?? [];
    List<Lounges> lounges = loungess;

    if (userInfo != null) {
      if (userInfo.isNotEmpty) {
        userName = userInfo[0].userName;
        userSex = userInfo[0].userSex;
        userPhone = userInfo[0].userPhone;
        userPic = userInfo[0].userPic;
        userUid = userInfo[0].userUid;
        documentId = userInfo[0].documentId;
        userMessagingToken = userInfo[0].userMessagingToken;
      }
    }
    if (controllerInfo != null) {
      if (controllerInfo.isNotEmpty) {
        controllerServiceCharge = controllerInfo[0].serviceCharge;
        controllerDeliveryFee = controllerInfo[0].deliveryFee;
        controllerVersion = controllerInfo[0].version;
        controllerSFStartsAt = controllerInfo[0].sFStartsAt;
        controllerReferralCodeLogin = controllerInfo[0].referralCodeLogin;
        controllerReferralCodeOrder = controllerInfo[0].referralCodeOrder;
        controllerPhoneCustomerSupport = controllerInfo[0].phoneCustomerSupport;
      }
    }
    netVersion = controllerVersion - appVersion;

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes, exit',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Stack(
        children: [
          Scaffold(
            key: _scaffoldState,
            drawer: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: MultiProvider(
                providers: [
                  StreamProvider<List<Adress>>.value(
                    value: DatabaseService(userUid: userUid).adress,
                  ),
                  StreamProvider<List<CustomerService>>.value(
                    value: DatabaseService().customerService,
                  ),
                ],
                child: DrawerContent(
                  documentId: documentId,
                  userUid: userUid,
                  userName: userName,
                  userPhone: userPhone,
                  userPic: userPic,
                  drawerState: drawerState,
                  controllerPhoneCustomerSupport:
                      controllerPhoneCustomerSupport,
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                ExpandableBottomSheet(
                  persistentHeader: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: 1.0, //effect of softening the shadow
                          spreadRadius: 0.1, //effecet of extending the shadow
                          offset: Offset(
                              0.0, //horizontal
                              -2.0 //vertical
                              ),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        height: 8,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0),
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0)),
                        ),
                      ),
                    ),
                  ),
                  expandableContent: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    color: Colors.white,
                    child: loungess.isNotEmpty
                        ? ListView.builder(
                            itemCount: loungess.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 20, right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isOpen = loungess[index].weAreOpen;
                                      categoryItems = loungess[index].category;
                                      categoryList =
                                          loungess[index].category.length;
                                      loungeName = loungess[index].name;
                                      loungeId = loungess[index].id;
                                      loungePic = loungess[index].images;
                                      loungeLatitude = loungess[index].latitude;
                                      eatThere = lounges[index].eatThere;
                                      loungeLongitude =
                                          loungess[index].longitude;
                                      distance = calculateDistance(
                                          loungess[index].latitude,
                                          lounges[index].longitude,
                                          widget.initialPosition.latitude,
                                          widget.initialPosition.longitude);
                                      lounges[index].category == null
                                          ? loading()
                                          : lounges[index].weAreOpen == true
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          MultiProvider(
                                                            providers: [
                                                              StreamProvider<
                                                                  List<
                                                                      Menu>>.value(
                                                                value: DatabaseService(
                                                                        menuId:
                                                                            loungeId)
                                                                    .menu,
                                                              ),
                                                              ChangeNotifierProvider
                                                                  .value(
                                                                value: Cart(),
                                                              ),
                                                              StreamProvider<
                                                                  List<
                                                                      Lounge>>.value(
                                                                value: DatabaseService(
                                                                        id: loungeId)
                                                                    .loungesIsOpen,
                                                              )
                                                            ],
                                                            child: Menus(
                                                              loungeId:
                                                                  loungeId,
                                                              categoryItems:
                                                                  categoryItems,
                                                              loungeName:
                                                                  loungeName,
                                                              categoryList:
                                                                  categoryList,
                                                              userUid: userUid,
                                                              userName:
                                                                  userName,
                                                              userPhone:
                                                                  userPhone,
                                                              userSex: userSex,
                                                              userPic: userPic,
                                                              orderConfirmed:
                                                                  orderConfirmed,
                                                              loungeLatitude:
                                                                  loungeLatitude,
                                                              loungeLongitude:
                                                                  loungeLongitude,
                                                              controllerDeliveryFee:
                                                                  controllerDeliveryFee,
                                                              controllerServiceCharge:
                                                                  controllerServiceCharge,
                                                              eatThere:
                                                                  eatThere,
                                                              controllerSFStartsAt:
                                                                  controllerSFStartsAt,
                                                              loungeMessagingToken:
                                                                  loungess[
                                                                          index]
                                                                      .loungeMessagingToken,
                                                              userMessagingToken:
                                                                  userMessagingToken,
                                                              controllerReferralCodeLogin:
                                                                  controllerReferralCodeLogin,
                                                              controllerReferralCodeOrder:
                                                                  controllerReferralCodeOrder,
                                                            ),
                                                          )),
                                                )
                                              : loungeIsClosed();
                                    });
                                  },
                                  child: loungess[index].active == true
                                      ? LoungesListview(
                                          lounge: loungess[index],
                                          initialPosition:
                                              widget.initialPosition,
                                        )
                                      : Container(),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Text(
                                "No Kushnas",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                  ),
                  background: Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: MultiProvider(
                            providers: [
                              StreamProvider<List<Orders>>.value(
                                value: DatabaseService(userUid: userUid).orders,
                              ),
                            ],
                            child: lounges == null
                                ? Loading
                                : MapsContainer(
                                    userUid: userUid,
                                    userName: userName,
                                    userPhone: userPhone,
                                    userPic: userPic,
                                    userSex: userSex,
                                    controllerDeliveryFee:
                                        controllerDeliveryFee,
                                    controllerServiceCharge:
                                        controllerServiceCharge,
                                    orderConfirmed: orderConfirmed,
                                    lounges: lounges,
                                    initialPosition: widget.initialPosition,
                                    netVersion: netVersion,
                                    documentUid: documentId,
                                    controllerSFStartsAt: controllerSFStartsAt,
                                    userMessagingToken: userMessagingToken,
                                    controllerReferralCodeLogin:
                                        controllerReferralCodeLogin,
                                    controllerReferralCodeOrder:
                                        controllerReferralCodeOrder,
                                  ),
                          ),
                        ),
                        Positioned(top: 50, left: -16, child: DrawerButton()),
                        Visibility(
                          visible: netVersion > 4,
                          child: ForcedUpdate(),
                        ),
                        Visibility(
                          visible: userSex == '' && userName != '',
                          child: ForcedName(
                            userUid: userUid,
                            userName: userName,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  left: 0.0,
                  bottom: loungeIsClosedAnimation.value,
                  child: LoungeClosedMessage(
                      foodName: loungeName, opacity: 0.7, color: 600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DrawerButton() {
    return GestureDetector(
      onTap: () {
        _scaffoldState.currentState.openDrawer();
      },
      child: Container(
        height: 55,
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: drawerAnimation.value * (pi / 180),
              child: Icon(Icons.menu, color: Colors.orange, size: 30),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 2.0, //effect of softening the shadow
              spreadRadius: 0.1, //effecet of extending the shadow
              offset: Offset(
                  4.0, //horizontal
                  10.0 //vertical
                  ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
