import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LocationButtonWidget extends StatelessWidget {
  bool positionLoading;
  LocationButtonWidget({this.positionLoading});
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
      child: positionLoading == true
          ? Center(
              child: SpinKitCircle(
              color: Colors.orange,
              size: 20.0,
            ))
          : Center(
              child: Container(
                height: 22.0,
                width: 22.0,
                child: Image(
                  image: AssetImage("images/others/position.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
    );
  }
}
