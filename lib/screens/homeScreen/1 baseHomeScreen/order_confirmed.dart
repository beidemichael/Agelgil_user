import 'dart:ui';

import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderConfirmedBlurDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderComfirmed = Provider.of<List<ConfirmOrder>>(context) ?? [];
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: Stack(
            children: [
              Container(
                width: 250.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: [
                              orderComfirmed == null
                                  ? Container(
                                      
                                      height: 200,
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                      child: Center(
                                          child: SpinKitCircle(
                                        color: Colors.orange,
                                        size: 50.0,
                                      )),
                                    ):orderComfirmed.length == 0
                                  ? Container(
                                      
                                      height: 200,
                                      decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30.0),
                                      topLeft: Radius.circular(30.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                      child: Center(
                                          child: SpinKitCircle(
                                        color: Colors.orange,
                                        size: 50.0,
                                      )),
                                    )
                                  : orderComfirmed.length == 0
                                      ? Container(
                                          color: Colors.white,
                                          height: 200,
                                          child: Center(
                                              child: SpinKitCircle(
                                            color: Colors.orange,
                                            size: 50.0,
                                          )),
                                        )
                                      : Container(
                                          height: 200,
                                          // color: Colors.red,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 2.0),
                                              child: Text(
                                                "Your order has been placed.",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.grey[700],
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                        ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 65,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(30.0),
                                      bottomLeft: Radius.circular(30.0),
                                    ),
                                    color: Colors.orange,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w100),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      /////////////////////////////// close button
                      top: 0.0,
                      right: 0.0,
                      child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          )),
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
            ],
          ),
        ),
      ),
    );
  }
}
