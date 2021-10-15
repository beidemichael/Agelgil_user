import 'dart:math';

import 'package:flutter/material.dart';

class CompassButtonWidget extends StatefulWidget {
  AnimationController animationController;
  double bearing = 0;
  CompassButtonWidget({this.bearing, this.animationController});
  @override
  _CompassButtonWidgetState createState() => _CompassButtonWidgetState();
}

class _CompassButtonWidgetState extends State<CompassButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[600],
            blurRadius: 2.0, //effect of softening the shadow
            spreadRadius: 0.5, //effecet of extending the shadow
            offset: Offset(
                0.0, //horizontal
                0.0 //vertical
                ),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(60.0),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: widget.animationController,
          child: Container(
            // color: Colors.red,
            height: 25.0,
            child: Image(
              image: AssetImage("images/others/north.png"),
              fit: BoxFit.fill,
            ),
          ),
          builder: (BuildContext context, Widget _widget) {
            return new Transform.rotate(
              angle: -widget.bearing * (pi / 180),
              child: _widget,
            );
          },
        ),
      ),
    );
  }
}
