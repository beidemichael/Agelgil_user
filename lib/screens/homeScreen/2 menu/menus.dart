import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/models/cart.dart';
import 'package:agelgil_user_end/screens/homeScreen/3%20cart/cart_screen.dart';
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:agelgil_user_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'addedToCartMessage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Menus extends StatefulWidget {
  String userUid;
  String userName;
  String userPhone;
  String userSex;
  String userPic;
  List categoryItems;
  String loungeName;
  int categoryList;
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
  Menus({
    this.loungeName,
    this.categoryList,
    this.categoryItems,
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
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> with TickerProviderStateMixin {
  StreamSubscription subscription;
  bool isInternetConnected = true;

  final PageController ctrl = PageController(viewportFraction: 0.8);
  AnimationController addedToCardContoller;
  Animation addedToCardAnimation;

  List<Color> color = [
    Colors.teal[100],
    Colors.red[100],
    Colors.purple[100],
    Colors.yellow[100],
    Colors.pink[100],
    Colors.blue[100],
    Colors.green[100],
    Colors.lime[100],
    Colors.orange[100],
    Colors.brown[100],
    Colors.deepOrange[100],
  ];

  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  int currentIndex = 0;
  // for keeping track of the number page indicators like carousel
  double paddingWidth, n;

  int colorNumber = 0;

  bool cartVisibiliy = false;

  String foodName = '';

  @override
  void initState() {
    super.initState();
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

    addedToCardContoller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    addedToCardAnimation =
        Tween<double>(begin: -70, end: 20).animate(addedToCardContoller);
    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
          if (colorNumber == 10) {
            colorNumber = 0;
          }
          if (colorNumber < 10) {
            ++colorNumber;
          }
        });
      }
    });
  }

  addedToCartFunction() {
    addedToCardContoller.forward();
    Future.delayed(Duration(milliseconds: 1500), () {
      addedToCardContoller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    paddingWidth = MediaQuery.of(context).size.width - (155);
    n = widget.categoryItems.length.toDouble();
    final cart = Provider.of<Cart>(context);
    final menu = Provider.of<List<Menu>>(context) ?? [];

    if (cart.itemCount == 0) {
      cartVisibiliy = false;
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundBlur(),
          Positioned(
              //////////////////////////////////////top color changing container containing category name
              child: TopColorChangingContainerWithCategoryName(
            screenWidth,
          )),
          Positioned(
            ///////////////////////////////top carousel type page locating circles
            top: 70,
            child: TopCarouelCircles(n, paddingWidth, screenWidth),
          ),
          Positioned(
            //////////////////////////////center animated container
            // Animated Properties
            child: MiddlePageViewBuilder(menu, cart, screenWidth),
          ),
          Positioned(
            ///////////////////////////////back button and cart icon
            child: BackButtonAndCartIcon(cart, cartVisibiliy, screenWidth),
          ),
          Positioned(
            right: 0.0,
            left: 0.0,
            bottom: addedToCardAnimation.value,
            child: AddedToCartMessage(
              screenWidth: screenWidth,
              foodName: foodName,
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

  TopCarouelCircles(double n, double paddingWidth, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 85.0, left: 70),
      child: Row(
        children: <Widget>[
          Container(
            height: 10,
            width: ((paddingWidth - (7 * n)) / (n + 1)),
            // color: Colors.yellow,
          ),
          Container(
            height: 10,
            // color: Colors.blue,
            width: (((paddingWidth - (7 * n)) / (n + 1)) + 7) * n,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: n.toInt(),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: index == currentPage
                            ? Colors.grey[600]
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Container(
                      height: 10,
                      width: ((paddingWidth - (7 * n)) / (n + 1)),
                      // color: Colors.yellow,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  MiddlePageViewBuilder(List<Menu> menu, Cart cart, double screenWidth) {
    return PageView.builder(
      controller: ctrl,
      itemCount: widget.categoryList,
      itemBuilder: (context, int currentIdx) {
        // Active page

        currentIndex = currentIdx;
        bool active = currentIdx == currentPage;
        final double blur = active ? 7 : 0;
        final double offset = active ? 23 : 0;
        final double top = active ? 100 : 300;
        final double bottom = active ? 0 : 60;
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.bounceInOut,
          margin: EdgeInsets.only(top: top, bottom: bottom, right: 20),
          decoration: BoxDecoration(
            borderRadius: currentPage == currentIndex
                ? BorderRadius.circular(10)
                : BorderRadius.circular(10),
            color:
                currentPage == currentIndex ? Colors.white : Colors.grey[200],
            // image: DecorationImage(
            //   fit: BoxFit.cover,
            //   image: NetworkImage(data['img']),
            // ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[400],
                  blurRadius: blur,
                  offset: Offset(offset, offset)),
              BoxShadow(
                color: Colors.grey[600],
                blurRadius: 0.2,
              )
            ],
          ),
          child: Visibility(
            visible: currentPage == currentIndex,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0),
              child: menu == null
                  ? Center(
                      child: SpinKitCircle(
                      color: Colors.orange,
                      size: 50.0,
                    ))
                  : ListView.builder(
                      itemCount: menu.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                          value: menu[index],
                          child: menu[index].category ==
                                  widget.categoryItems[currentPage]
                              ? GestureDetector(
                                  onTap: () {
                                    addedToCartFunction();
                                    cart.addItem(
                                      menu[index].name,
                                      menu[index].name,
                                      menu[index].price,
                                    );

                                    setState(() {
                                      cartVisibiliy = true;
                                      foodName = menu[index].name;
                                    });
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[400],
                                                  blurRadius:
                                                      5.0, //effect of softening the shadow
                                                  spreadRadius:
                                                      0.1, //effecet of extending the shadow
                                                  offset: Offset(
                                                      8.0, //horizontal
                                                      10.0 //vertical
                                                      ),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),

                                            // padding: EdgeInsets.all(10),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, left: 15.0, top: 23),
                                        child: Container(
                                          height: 60.0,
                                          width: screenWidth,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius:
                                                    5.0, //effect of softening the shadow
                                                spreadRadius:
                                                    0.1, //effecet of extending the shadow
                                                offset: Offset(
                                                    8.0, //horizontal
                                                    10.0 //vertical
                                                    ),
                                              ),
                                            ],
                                            color: menu[index].isAvailable
                                                ? color[colorNumber]
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0, left: 15.0, top: 23),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            height: 60.0,
                                            width: 180.0,
                                            decoration: BoxDecoration(
                                              color: menu[index].isAvailable
                                                  ? color[colorNumber]
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Marquee(
                                                        // scrollAxis: Axis.horizontal,
                                                        // textDirection:
                                                        //     TextDirection.rtl,
                                                        // animationDuration:
                                                        //     Duration(
                                                        //         seconds: 1),
                                                        backDuration: Duration(
                                                            milliseconds: 500),
                                                        // pauseDuration: Duration(
                                                        //     milliseconds: 0),
                                                        directionMarguee:
                                                            DirectionMarguee
                                                                .oneDirection,
                                                        child: Text(
                                                          menu[index].name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17.0,
                                                              color: Colors
                                                                  .grey[600]
                                                              // fontWeight: FontWeight.w700,
                                                              // fontStyle: FontStyle.italic,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Marquee(
                                                        // scrollAxis: Axis.horizontal,
                                                        // textDirection:
                                                        //     TextDirection.rtl,
                                                        // animationDuration:
                                                        //     Duration(
                                                        //         seconds: 1),
                                                        backDuration: Duration(
                                                            milliseconds: 500),
                                                        // pauseDuration: Duration(
                                                        //     milliseconds: 0),
                                                        directionMarguee:
                                                            DirectionMarguee
                                                                .oneDirection,
                                                        child: Text(
                                                          menu[index]
                                                                  .price
                                                                  .toDouble()
                                                                  .toString() +
                                                              '0 Birr',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 17.0,
                                                            // fontWeight: FontWeight.w700,
                                                            // fontStyle: FontStyle.italic,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: menu[index].images != ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child:

                                                        // Image.network(
                                                        //   menu[index]
                                                        //       .images
                                                        //       .toString(),
                                                        //   fit: BoxFit.cover,
                                                        //   alignment:
                                                        //       Alignment.center,
                                                        // ),
                                                        CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          menu[index].images,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  downloadProgress) =>
                                                              Center(
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors.orange[
                                                                          300]),
                                                              value:
                                                                  downloadProgress
                                                                      .progress),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),

                                                    //     Image.network(
                                                    //   menu[index]
                                                    //       .images
                                                    //       .toString(),
                                                    //   fit: BoxFit.cover,
                                                    //   alignment:
                                                    //       Alignment.center,
                                                    //   loadingBuilder: (BuildContext
                                                    //           context,
                                                    //       Widget child,
                                                    //       ImageChunkEvent
                                                    //           loadingProgress) {
                                                    //     if (loadingProgress ==
                                                    //         null) return child;

                                                    //     return Center(
                                                    //       child: Container(
                                                    //         height: 30,
                                                    //         width: 30,
                                                    //         child:
                                                    //             CircularProgressIndicator(
                                                    //           backgroundColor:
                                                    //               Colors.grey[
                                                    //                   300],
                                                    //           valueColor:
                                                    //               AlwaysStoppedAnimation<
                                                    //                       Color>(
                                                    //                   Colors.orange[
                                                    //                       300]),
                                                    //           value: loadingProgress
                                                    //                       .expectedTotalBytes !=
                                                    //                   null
                                                    //               ? loadingProgress
                                                    //                       .cumulativeBytesLoaded /
                                                    //                   loadingProgress
                                                    //                       .expectedTotalBytes
                                                    //               : null,
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // ),
                                                  )
                                                : Center(
                                                    child: Image(
                                                      height: 60,
                                                      width: 60,
                                                      image: AssetImage(
                                                          "images/others/Cart.png"),
                                                      color: Color(0xffe4e4e4),
                                                    ),
                                                  ),
                                            // padding: EdgeInsets.all(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: .01,
                                ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  BackButtonAndCartIcon(Cart cart, bool cartVisibiliy, double screenWidth) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(FontAwesomeIcons.arrowLeft,
                  size: 25.0, color: Colors.grey[700]),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: Cart(),
                      child: CartScreen(
                        userUid: widget.userUid,
                        userName: widget.userName,
                        userPhone: widget.userPhone,
                        userSex:widget.userSex,
                        userPic: widget.userPic,
                        cart: cart,
                        loungeName: widget.loungeName,
                        loungeId: widget.loungeId,
                        orderConfirmed: widget.orderConfirmed,
                        loungeLatitude: widget.loungeLatitude,
                        loungeLongitude: widget.loungeLongitude,
                        controllerServiceCharge: widget.controllerServiceCharge,
                        controllerDeliveryFee: widget.controllerDeliveryFee,
                        eatThere: widget.eatThere,
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
                Future.delayed(Duration(milliseconds: 300), () {
                  cart.clear();
                });
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 3.0),
                            child: Container(
                              height: 25.0,
                              width: 25.0,
                              child: Image(
                                image: AssetImage("images/others/Cart.png"),
                                fit: BoxFit.fill,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: cartVisibiliy,
                            child: Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: Container(
                                height: 18.0,
                                width: 18.0,
                                decoration: BoxDecoration(
                                  color: Colors.orange[500].withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                child: Center(
                                  child: Text(
                                    cart.itemCount.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TopColorChangingContainerWithCategoryName(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 75.0, left: 60),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: 85,
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
          child: Center(
            child: Marquee(
              backDuration: Duration(milliseconds: 500),
              directionMarguee: DirectionMarguee.oneDirection,
              child: Text(
                widget.categoryItems[currentPage].toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    color: Colors.grey[600]
                    // fontWeight: FontWeight.w700,
                    // fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          color: color[colorNumber],
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 5.0, //effect of softening the shadow
              spreadRadius: 0.5, //effecet of extending the shadow
              offset: Offset(
                  8.0, //horizontal
                  10.0 //vertical
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    addedToCardContoller.dispose();
    super.dispose();
    subscription.cancel();
  }
}
