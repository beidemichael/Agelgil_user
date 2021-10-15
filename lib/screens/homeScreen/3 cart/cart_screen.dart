import 'dart:async';
import 'dart:ui';

import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/models/cart.dart';
import 'package:agelgil_user_end/screens/homeScreen/3%20cart/cartWidgets/Your%20agelgil%20is%20empty.dart';
import 'package:agelgil_user_end/screens/homeScreen/3%20cart/cartBottomSheet/cart_popup.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:agelgil_user_end/shared/internet_connection.dart';
import 'package:agelgil_user_end/shared/orange_button.dart';
import 'package:agelgil_user_end/shared/red_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class CartScreen extends StatefulWidget {
  String userUid;
  String userName;
  String userPhone;
  String userSex;
  String userPic;
  Cart cart;
  String loungeName;
  String loungeId;
  Function orderConfirmed;
  double loungeLongitude;
  double loungeLatitude;
  double controllerServiceCharge;
  double controllerDeliveryFee;
  bool eatThere;
  double controllerSFStartsAt;
  String loungeMessagingToken;
  String userMessagingToken;
  bool controllerReferralCodeLogin;
  bool controllerReferralCodeOrder;
  CartScreen({
    this.cart,
    this.loungeName,
    this.userUid,
    this.userName,
    this.userPhone,
    this.userSex,
    this.userPic,
    this.loungeId,
    this.orderConfirmed,
    this.loungeLatitude,
    this.loungeLongitude,
    this.controllerDeliveryFee,
    this.controllerServiceCharge,
    this.eatThere,
    this.controllerSFStartsAt,
    this.loungeMessagingToken,
    this.userMessagingToken,
    this.controllerReferralCodeLogin,
    this.controllerReferralCodeOrder,
  });

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final DatabaseService _data = DatabaseService();
  final geo = Geoflutterfire();
  AnimationController addedToCardContoller;
  Animation addedToCardAnimation;
  AnimationController checkOutController;
  Animation checkOutAnimation;
  bool checkOutBool = false;
  double serivceCharge = 0;
  double totaltotal = 0;
  bool isInternetConnected = true;

  final GlobalKey<AnimatedListState> _key = GlobalKey();
  List<Cart3Items> cart3Items = [];

  String userIdString = '';

  Cart cart;
  DateTime created;
  StreamSubscription subscription;
  String orderNumber;
  String loungeOrderNumber;
  double serviceCharge = 0.0;

  @override
  void initState() {
    super.initState();

    addedToCardContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    addedToCardAnimation =
        Tween<double>(begin: -70, end: 50).animate(addedToCardContoller);

    checkOutController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    checkOutAnimation =
        Tween<double>(begin: -180, end: -30).animate(checkOutController);

    cart3items();
    total();
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

  chekOutFunction() {
    if (checkOutBool == false) {
      checkOutController.forward();
      setState(() {
        checkOutBool = true;
      });
    } else {
      checkOutController.reverse();
      setState(() {
        checkOutBool = false;
      });
    }
  }

  Widget _builderItem(Cart3Items item, Animation animation, int i) {
    return SizeTransition(
        sizeFactor: animation,
        child: Stack(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        blurRadius: 1.0, //effect of softening the shadow
                        spreadRadius: 0.5, //effecet of extending the shadow
                        offset: Offset(
                            0.0, //horizontal
                            1.0 //vertical
                            ),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: 30,
                          ),
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 50.0,
                                  //color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '   ',
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              item.foodPriceL.toString() +
                                                  '0 Birr',
                                              style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: 20.0),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Total',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                )),
                                            // SizedBox(
                                            //   width: 100,
                                            // ),
                                            Text(
                                              (item.foodPriceL *
                                                          item.foodQuantityL)
                                                      .toString() +
                                                  '0 Birr',
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.grey[500]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 0.0, 100.0, 8.0),
                                  child: Marquee(
                                    backDuration: Duration(milliseconds: 400),
                                    directionMarguee:
                                        DirectionMarguee.oneDirection,
                                    child: Text(
                                      item.foodNameL.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 60.0,
                            //color: Colors.red,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(FontAwesomeIcons.timesCircle,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            Positioned(
              right: 28,
              top: -6,
              child: Container(
                height: 60.0,
                //color: Colors.red,
                child: InkWell(
                  onTap: () {
                    removeItem(i);
                    setState(() {
                      item.foodPriceL = 0;
                    });
                  },
                  child: Icon(
                    FontAwesomeIcons.timesCircle,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 11.5,
              left: 29,
              child: Container(
                width: 28,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[100],
                      blurRadius: 1.0, //effect of softening the shadow
                      spreadRadius: 0.5, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          1.0 //vertical
                          ),
                    ),
                  ],
                  color: Colors.grey[100].withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 23),
                    child: Text(
                      item.foodQuantityL.toString(),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 11.5,
              left: 29,
              child: Container(
                height: 63,
                width: 28,
                // color: Colors.blue.withOpacity(0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          item.foodQuantityL = item.foodQuantityL + 1;
                        });
                      },
                      child: Container(
                        height: 25,
                        width: 28,
                        // color: Colors.red,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (item.foodQuantityL > 1)
                            item.foodQuantityL = item.foodQuantityL - 1;
                        });
                      },
                      child: Container(
                        height: 29,
                        width: 28,
                        // color: Colors.red,
                        child: Icon(
                          FontAwesomeIcons.minus,
                          color: Colors.grey[500],
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void removeItem(int i) {
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _builderItem(cart3Items.removeAt(i), animation, i);
    };
    _key.currentState.removeItem(i, builder);
  }

  addedToCartFunction() {
    addedToCardContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      addedToCardContoller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (total() > widget.controllerSFStartsAt) {
      setState(() {
        serviceCharge = widget.controllerServiceCharge;
      });
    } else {
      serviceCharge = 0.0;
    }
    void whencheckoutClicked() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: StreamProvider<List<Adress>>.value(
                  value: DatabaseService(userUid: widget.userUid).adress,
                  child: CartPopup(
                    foodName: foodNameFunction(),
                    foodPrice: foodPriceFunction(),
                    loungeName: widget.loungeName,
                    foodQuantity: foodQuantityFunction(),
                    subTotal: total(),
                    totalPrice: double.parse(
                        ((total() * (serviceCharge)) + total())
                            .toStringAsFixed(1)),
                    userName: widget.userName,
                    userPhone: widget.userPhone,
                    userSex: widget.userSex,
                    userPic: widget.userPic,
                    userUid: widget.userUid,
                    loungeId: widget.loungeId,
                    orderConfirmed: widget.orderConfirmed,
                    serviceCharge: double.parse(
                        ((total() * (serviceCharge))).toStringAsFixed(1)),
                    loungeLatitude: widget.loungeLatitude,
                    loungeLongitude: widget.loungeLongitude,
                    controllerDeliveryFee: widget.controllerDeliveryFee,
                    controllerServiceCharge: serviceCharge,
                    controllerSFStartsAt: widget.controllerSFStartsAt,
                    loungeMessagingToken: widget.loungeMessagingToken,
                    userMessagingToken: widget.userMessagingToken,
                    controllerReferralCodeLogin:
                        widget.controllerReferralCodeLogin,
                    controllerReferralCodeOrder:
                        widget.controllerReferralCodeOrder,
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
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
          SafeArea(
            ///////////////////////////cart item cards
            child: Padding(
              padding: const EdgeInsets.only(top: 52.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: cart3Items.length != 0
                        ? AnimatedList(
                            key: _key,
                            initialItemCount: cart3Items.length,
                            itemBuilder: (context, i, animation) {
                              return _builderItem(cart3Items[i], animation, i);
                            },
                          )
                        : Center(
                            child: Text('Your Agelgil is empty.',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.w600)),
                          ),
                  ),
                  Container(
                    height: 150,
                    // color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: checkOutAnimation.value,
            child: Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10,
              ),
              child: Container(
                height: 320.0,
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
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    // bottomRight: Radius.circular(30.0),
                    // bottomLeft: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Subtotal',
                              style: TextStyle(
                                fontSize: 28.0,
                                color: Colors.grey[700],
                              )),
                          Text((total().toString()) + '0 Birr',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      ////////////////////////ckeckout buttom
                      onTap: () async {
                        if (cart3Items.length != 0) {
                          if (widget.eatThere == true) {
                            chekOutFunction();
                          } else {
                            foodPriceFunction();
                            foodNameFunction();
                            foodQuantityFunction();
                            whencheckoutClicked();
                          }
                        } else {
                          addedToCartFunction();
                        }
                      },
                      child: Visibility(
                          visible: !checkOutBool,
                          child: OrangeButton(text: 'CHECKOUT')),
                    ),
                    SizedBox(height: 40.0),
                    InkWell(
                      ////////////////////////ckeckout buttom
                      onTap: () async {
                        if (cart3Items.length != 0) {
                          foodPriceFunction();
                          foodNameFunction();
                          foodQuantityFunction();
                          whencheckoutClicked();
                        } else {
                          addedToCartFunction();
                        }
                      },
                      child: OrangeButton(text: 'DELIVERY'),
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      ////////////////////////ckeckout buttom
                      onTap: () async {
                        if (cart3Items.length != 0) {
                          orderNumber = randomString(25).toString();
                          loungeOrderNumber = randomString(25).toString();
                          foodPriceFunction();
                          foodNameFunction();
                          foodQuantityFunction();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          widget.orderConfirmed(widget.userUid, orderNumber);
                          DateTime startDate = await NTP.now();
                          created = startDate;

                          GeoFirePoint myLocation = geo.point(
                              latitude: widget.loungeLatitude,
                              longitude: widget.loungeLongitude);

                          await _data.updateOrderDataForEatThere(
                              foodNameFunction().toList(),
                              foodPriceFunction().toList(),
                              foodQuantityFunction().toList(),
                              total(),
                              widget.loungeName,
                              false,
                              false,
                              widget.userName,
                              widget.userPhone,
                              widget.userSex,
                              widget.userUid,
                              widget.userPic,
                              widget.loungeId,
                              0.0,
                              0.0,
                              " ",
                              created,
                              orderNumber,
                              loungeOrderNumber,
                              0.0,
                              0,
                              0,
                              0.0,
                              myLocation,
                              widget.loungeMessagingToken,
                              widget.userMessagingToken);
                        } else {
                          addedToCartFunction();
                        }
                      },
                      child: RedButton(text: 'EAT THERE'),
                    ),
                  ],
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
          Positioned(
              right: 0.0,
              left: 0.0,
              top: addedToCardAnimation.value,
              child: AgelgilEmpty()),
        ],
      ),
    );
  }

  total() {
    double totalPrice = 0;
    cart3Items.forEach((element) {
      totalPrice = totalPrice + (element.foodPriceL * element.foodQuantityL);
    });

    return totalPrice;
  }

  foodNameFunction() {
    List foodName = [];
    cart3Items.forEach((e) => foodName.add(e.foodNameL));
    return foodName;
  }

  foodPriceFunction() {
    List foodPrice = [];
    cart3Items.forEach((e) => foodPrice.add((e.foodPriceL)));
    return foodPrice;
  }

  foodQuantityFunction() {
    List foodQuantity = [];

    cart3Items.forEach((e) => foodQuantity.add(e.foodQuantityL));
    return foodQuantity;
  }

  cart3items() {
    widget.cart.items.entries.forEach((e) => cart3Items.add(Cart3Items(
        foodNameL: e.value.name,
        foodPriceL: e.value.price,
        foodQuantityL: e.value.quantity)));
  }

  @override
  void dispose() {
    addedToCardContoller.dispose();
    super.dispose();
    subscription.cancel();
  }
}
