//list view widger
import 'dart:math';

import 'package:agelgil_user_end/models/Models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';

class LoungesListview extends StatefulWidget {
  LatLng initialPosition;
  Lounges lounge;
  LoungesListview({this.lounge, this.initialPosition});

  @override
  _LoungesListviewState createState() => _LoungesListviewState();
}

class _LoungesListviewState extends State<LoungesListview> {
  double deliveryDistance = 0;
  double deliveryRadius = 0;
  double differenceOfRadiuses = -1;
  @override
  void initState() {
    super.initState();
    calculateDistance();
  }

  calculateDistance() {
    deliveryDistance = calculate(
        widget.lounge.latitude,
        widget.lounge.longitude,
        widget.initialPosition.latitude,
        widget.initialPosition.longitude);

    deliveryRadius = widget.lounge.deliveryRadius;
    differenceOfRadiuses = deliveryRadius - deliveryDistance;
  }

  double calculate(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  @override
  Widget build(BuildContext context) {
    return differenceOfRadiuses >= 0
        ? Container(
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
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0)),
            ),
            height: 110,
            child: Stack(
              children: [
                Positioned(
                  left: 20,
                  bottom: 0,
                  top: 0,
                  child: Row(
                    children: [
                      Container(
                        height: 80.0,
                        width: 80.0,
                        child: widget.lounge.images != ''
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.lounge.images,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.orange[700]),
                                          value: downloadProgress.progress),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                            : Center(
                                child: Icon(FontAwesomeIcons.utensils,
                                    size: 20, color: Colors.orange[500]),
                              ),
                        decoration: BoxDecoration(
                          color: Colors.orange[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500].withOpacity(0.5),
                              blurRadius: 10.0, //effect of softening the shadow
                              spreadRadius:
                                  2.5, //effecet of extending the shadow
                              offset: Offset(
                                  0.0, //horizontal
                                  5.0 //vertical
                                  ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Marquee(
                            backDuration: Duration(milliseconds: 500),
                            directionMarguee: DirectionMarguee.oneDirection,
                            child: Text(widget.lounge.name,
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                              widget.lounge.weAreOpen == true
                                  ? 'Open'
                                  : 'Closed',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: widget.lounge.weAreOpen == true
                                      ? Colors.orange[300]
                                      : Colors.grey[400],
                                  fontWeight: FontWeight.w600)),
                          Text(deliveryDistance.toInt().toString() + 'm Away',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ))
        : Container();
  }
}
