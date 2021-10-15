import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/adress/adress_map.dart';
import 'package:agelgil_user_end/screens/homeScreen/3%20cart/final_order_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:timeago/timeago.dart' as timeago;

class CartPopup extends StatefulWidget {
  List foodName = [];
  List foodPrice = [];
  List foodQuantity = [];
  double totalPrice = 0;
  String loungeName = '';
  double subTotal = 0;

  String userName;
  String userPhone;
  String userSex;
  String userUid;
  String userPic;
  String loungeId;
  Function orderConfirmed;
  double serviceCharge;

  double loungeLongitude;
  double loungeLatitude;
  double controllerServiceCharge;
  double controllerDeliveryFee;
  double controllerSFStartsAt;
  String loungeMessagingToken;
  String userMessagingToken;
  bool controllerReferralCodeLogin;
  bool controllerReferralCodeOrder;

  CartPopup({
    this.foodName,
    this.foodPrice,
    this.foodQuantity,
    this.totalPrice,
    this.loungeName,
    this.userName,
    this.userPhone,
    this.userSex,
    this.userPic,
    this.userUid,
    this.loungeId,
    this.orderConfirmed,
    this.serviceCharge,
    this.subTotal,
    this.loungeLatitude,
    this.loungeLongitude,
    this.controllerDeliveryFee,
    this.controllerServiceCharge,
    this.controllerSFStartsAt,
    this.loungeMessagingToken,
    this.userMessagingToken,
    this.controllerReferralCodeLogin,
    this.controllerReferralCodeOrder,
  });
  @override
  _CartPopupState createState() => _CartPopupState();
}

class _CartPopupState extends State<CartPopup> {
  String userUid;
  double longitude;
  double latitude;
  String information;
  String name;
  String documentId;

  String orderNumber;
  String loungeOrderNumber;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final adress = Provider.of<List<Adress>>(context) ?? [];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: ListView(
        children: <Widget>[
          Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Choose delivery address",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.56,
                        //  height: 400,

                        child: adress.length != 0
                            ? ListView.builder(
                                itemCount: adress.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 13, right: 13),
                                    child: InkWell(
                                      onTap: () async {
                                        //  created =  timeago.format(firestoreTimestamp.());
                                        orderNumber =
                                            randomString(25).toString();
                                        loungeOrderNumber =
                                            randomString(25).toString();
                                        Navigator.of(context).pop();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => FinalOrderScreen(
                                                    subTotal: widget.subTotal,
                                                    foodName: widget.foodName,
                                                    foodPrice: widget.foodPrice,
                                                    foodQuantity:
                                                        widget.foodQuantity,
                                                    information: adress[index]
                                                        .information,
                                                    latitude:
                                                        adress[index].latitude,
                                                    longitude:
                                                        adress[index].longitude,
                                                    loungeId: widget.loungeId,
                                                    loungeName:
                                                        widget.loungeName,
                                                    loungeOrderNumber:
                                                        loungeOrderNumber,
                                                    orderConfirmed:
                                                        widget.orderConfirmed,
                                                    orderNumber: orderNumber,
                                                    serviceCharge:
                                                        widget.serviceCharge,
                                                    totalPrice:
                                                        widget.totalPrice,
                                                    userName: widget.userName,
                                                    userPhone: widget.userPhone,
                                                    userSex: widget.userSex,
                                                    userPic: widget.userPic,
                                                    userUid: widget.userUid,
                                                    loungeLatitude:
                                                        widget.loungeLatitude,
                                                    loungeLongitude:
                                                        widget.loungeLongitude,
                                                    controllerDeliveryFee: widget
                                                        .controllerDeliveryFee,
                                                    controllerServiceCharge: widget
                                                        .controllerServiceCharge,
                                                    controllerSFStartsAt: widget
                                                        .controllerSFStartsAt,
                                                    loungeMessagingToken: widget
                                                        .loungeMessagingToken,
                                                    userMessagingToken: widget
                                                        .userMessagingToken,
                                                    controllerReferralCodeLogin:
                                                        widget
                                                            .controllerReferralCodeLogin,
                                                    controllerReferralCodeOrder:
                                                        widget
                                                            .controllerReferralCodeOrder,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        height: 44,
                                        // color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0.0, 8.0, 0.0),
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              height: 35,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey[400],
                                                    blurRadius:
                                                        2.0, //effect of softening the shadow
                                                    spreadRadius:
                                                        0.1, //effecet of extending the shadow
                                                    offset: Offset(
                                                        0.0, //horizontal
                                                        3.0 //vertical
                                                        ),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey[400],
                                                    blurRadius:
                                                        1.0, //effect of softening the shadow
                                                    spreadRadius:
                                                        0.1, //effecet of extending the shadow
                                                    offset: Offset(
                                                        0.0, //horizontal
                                                        -1.0 //vertical
                                                        ),
                                                  ),
                                                ],
                                                color: Colors.orange[100],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Center(
                                                child: Marquee(
                                                  backDuration: Duration(
                                                      milliseconds: 500),
                                                  directionMarguee:
                                                      DirectionMarguee
                                                          .oneDirection,
                                                  child: Text(
                                                    adress[index].name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18.0,
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height:
                                        (MediaQuery.of(context).size.height *
                                                0.56 /
                                                2) -
                                            (4 + 45),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 13.0),
                                    child: Text('You have no saved address.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[500],
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AdressMap(
                                  userUid: widget.userUid,
                                )),
                      );
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      child:
                          Icon(Icons.add, color: Colors.orange[500], size: 40),
                      decoration: BoxDecoration(
                        color: Colors.orange[200],
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
