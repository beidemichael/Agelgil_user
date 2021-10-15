import 'dart:ui';
import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/models/cart.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.1%20map/loungeDetailDetail.dart';
import 'package:agelgil_user_end/screens/homeScreen/2%20menu/menus.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:agelgil_user_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:async';
import 'package:provider/provider.dart';

import 'lounge_closed_message.dart';

//ignore: must_be_immutable
class LoungeDetailBlurryDialog extends StatefulWidget {
  String userName;
  String userPic;
  String userUid;
  String userPhone;
  String userSex;
  double controllerServiceCharge;
  double controllerDeliveryFee;

  int categoryList = 0;
  List categoryItems = [];
  double distance = 0;
  String loungeId = '';
  String loungeName = '';
  String loungePic = '';
  Function orderConfirmed;
  double loungeLongitude;
  double loungeLatitude;
  bool isOpen;
  bool eatThere;
  double controllerSFStartsAt;
  String userMessagingToken;
  bool controllerReferralCodeLogin;
  bool controllerReferralCodeOrder;

  LoungeDetailBlurryDialog(
    this.userName,
    this.userPic,
    this.userUid,
    this.userPhone,
    this.userSex,
    this.categoryList,
    this.categoryItems,
    this.distance,
    this.loungeId,
    this.loungeName,
    this.loungePic,
    this.orderConfirmed,
    this.loungeLatitude,
    this.loungeLongitude,
    this.controllerDeliveryFee,
    this.controllerServiceCharge,
    this.isOpen,
    this.eatThere,
    this.controllerSFStartsAt,
    this.userMessagingToken,
    this.controllerReferralCodeLogin,
    this.controllerReferralCodeOrder,
  );

  @override
  _LoungeDetailBlurryDialogState createState() =>
      _LoungeDetailBlurryDialogState();
}

class _LoungeDetailBlurryDialogState extends State<LoungeDetailBlurryDialog>
    with TickerProviderStateMixin {
  AnimationController loungeIsClosedContoller;
  Animation loungeIsClosedAnimation;
  bool isOpen = false;
  bool eatThere = false;
  String loungeMessagingToken = '';

  loungeIsClosed() {
    loungeIsClosedContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      loungeIsClosedContoller.reverse();
    });
  }

  @override
  void initState() {
    super.initState();

    loungeIsClosedContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    loungeIsClosedAnimation =
        Tween<double>(begin: -70, end: 20).animate(loungeIsClosedContoller);
    // Set state when page changes
  }

  @override
  Widget build(BuildContext context) {
    final lounge = Provider.of<List<Lounge>>(context) ?? [];
    if (lounge != null) {
      if (lounge.isNotEmpty) {
        isOpen = lounge[0].weAreOpen;
        eatThere = lounge[0].eatThere;
        loungeMessagingToken = lounge[0].loungeMessagingToken;
      }
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: GestureDetector(
          onTap: () {
            if (isOpen == true) {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MultiProvider(
                          providers: [
                            StreamProvider<List<Menu>>.value(
                              value:
                                  DatabaseService(menuId: widget.loungeId).menu,
                            ),
                            ChangeNotifierProvider.value(
                              value: Cart(),
                            )
                          ],
                          child: Menus(
                            loungeId: widget.loungeId,
                            categoryItems: widget.categoryItems,
                            loungeName: widget.loungeName,
                            categoryList: widget.categoryList,
                            userUid: widget.userUid,
                            userName: widget.userName,
                            userPhone: widget.userPhone,
                            userSex:widget.userSex,
                            userPic: widget.userPic,
                            orderConfirmed: widget.orderConfirmed,
                            loungeLatitude: widget.loungeLatitude,
                            loungeLongitude: widget.loungeLongitude,
                            controllerDeliveryFee: widget.controllerDeliveryFee,
                            controllerServiceCharge:
                                widget.controllerServiceCharge,
                            eatThere: eatThere,
                            controllerSFStartsAt: widget.controllerSFStartsAt,
                            loungeMessagingToken: loungeMessagingToken,
                            userMessagingToken: widget.userMessagingToken,
                            controllerReferralCodeLogin:
                                widget.controllerReferralCodeLogin,
                            controllerReferralCodeOrder:
                                widget.controllerReferralCodeOrder,
                          ),
                        )),
              );
            } else {
              loungeIsClosed();
            }
          },
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 380.0,
                  width: 150.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 200.0,
                        width: 150.0,
                        decoration: BoxDecoration(
                          color: isOpen == false
                              ? Colors.grey[300]
                              : Colors.orange[100],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[600],
                              blurRadius: 3.0, //effect of softening the shadow
                              spreadRadius:
                                  0.2, //effecet of extending the shadow
                              offset: Offset(
                                  0.0, //horizontal
                                  0.0 //vertical
                                  ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              isOpen == false
                                  ? Text(
                                      'Closed',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w700,
                                        // fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : Text(
                                      'Open',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w700,
                                        // fontStyle: FontStyle.italic,
                                      ),
                                    ),
                              Container(height: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: 300.0,
                  width: 200,
                  //color: Colors.blue,
                  child: Stack(
                    children: <Widget>[
                      LoungeDetail(
                        loungeName: widget.loungeName,
                        distance: widget.distance,
                        loungePic: widget.loungePic,
                      ),
                      Positioned(
                        ///////////////////////////////convex effect for close button
                        top: 0.0,
                        right: 0.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              FontAwesomeIcons.times,
                              size: 18.0,
                              color: Colors.grey,
                            ),
                            decoration: ConcaveDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                colors: [
                                  Colors.white,
                                  Colors.grey[700],
                                ],
                                depression: 4.0),
                          ),
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
                  foodName: widget.loungeName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    loungeIsClosedContoller.dispose();
    super.dispose();
  }
}
