import 'dart:async';

import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/my_orders_card.dart';
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:agelgil_user_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MySavedScreen extends StatefulWidget {
  @override
  _MySavedScreenState createState() => _MySavedScreenState();
}

class _MySavedScreenState extends State<MySavedScreen> {
  StreamSubscription subscription;
  bool isInternetConnected = true;
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
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Orders>>(context) ?? [];
    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Stack(
            children: [
              Container(
                  // color: Colors.green,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: orders == null
                        ? Center(
                            child: SpinKitCircle(
                            color: Colors.orange,
                            size: 50.0,
                          ))
                        : Container(
                            child: orders.length == 0
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('No orders saved yet.',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(height: 20),
                                        Text('You can save one ',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w400)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('from ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.w400)),
                                            Text('\"My orders\"',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(' screen.',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey[500],
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      return MyOrdersCard(
                                        orders: orders[index],
                                      );

                                      // }
                                    }),
                          ),
                  )),
              SafeArea(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 5.0, //effect of softening the shadow
                        spreadRadius: 0.5, //effecet of extending the shadow
                        offset: Offset(
                            0.0, //horizontal
                            4.0 //vertical
                            ),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(FontAwesomeIcons.arrowLeft,
                                  size: 25.0, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        // color: Colors.blue[200],
                        child: Center(
                          child: Text('My favorites',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
