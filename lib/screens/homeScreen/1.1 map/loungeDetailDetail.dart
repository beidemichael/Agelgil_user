import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:marquee_widget/marquee_widget.dart';

//ignore: must_be_immutable
class LoungeDetail extends StatefulWidget {
  String loungeName;
  double distance;
  String loungePic;
  LoungeDetail({this.loungeName, this.distance, this.loungePic});
  @override
  _LoungeDetailState createState() => _LoungeDetailState();
}

class _LoungeDetailState extends State<LoungeDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            ///////////////////lounge name
            bottom: 0.0,
            right: 0.0,
            left: 0.0,
            // top: 100,
            child: Center(
              child: Container(
                height: 180.0,
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[600],
                      blurRadius: 3.0, //effect of softening the shadow
                      spreadRadius: 0.2, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          0.0 //vertical
                          ),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Positioned(
            ///////////////////lounge name
            bottom: 30.0,
            right: 0.0,
            left: 0.0,
            // top: 100,
            child: Center(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Marquee(
                        backDuration: Duration(milliseconds: 400),
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          widget.loungeName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 17.0,
                            fontWeight: FontWeight.w700,
                            // fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Text(
                        widget.distance.toInt().toString() + ' m Away',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 11.0,
                          // fontWeight: FontWeight.w700,
                          // fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            ///////////////////////////////upper container for image from database
            right: 0.0,
            left: 0.0,
            top: 15,
            child: Center(
              child: Container(
                height: 180.0,
                width: 180.0,
                child: widget.loungePic != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:
                            //  Image.network(
                            //   widget.loungePic.toString(),
                            //   fit: BoxFit.cover,
                            //   alignment: Alignment.center,
                            // ),
                            CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.loungePic,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
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
                            size: 80, color: Colors.orange[500]),
                      ),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500].withOpacity(0.5),
                      blurRadius: 10.0, //effect of softening the shadow
                      spreadRadius: 2.5, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          30.0 //vertical
                          ),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Positioned(
            ///////////////////////////////gradient infront of image for rating stars background
            right: 0.0,
            left: 0.0,
            top: 15,
            child: Center(
              child: Container(
                height: 180.0,
                width: 180.0,

                // Image.network('http://i.imgur.com/zL4Krbz.jpg')),
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      Colors.grey[600].withOpacity(0.0),
                      Colors.grey[600].withOpacity(0.0),
                      Colors.grey[600].withOpacity(0.05),
                      Colors.grey[800].withOpacity(0.3),
                      Colors.grey[800].withOpacity(0.6),
                      Colors.grey[800].withOpacity(0.8),
                      Colors.grey[800].withOpacity(0.9)
                    ],
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Positioned(
            ///////////////////////////////white background for close button
            top: 0.0,
            right: 0.0,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
