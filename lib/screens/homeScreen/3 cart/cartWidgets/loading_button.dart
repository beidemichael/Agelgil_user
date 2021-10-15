import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingButton extends StatefulWidget {

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.orange[900],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              2.0, //horizontal
              0.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.orange[800],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              -0.0, //horizontal
              5.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.orange[800],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              2.0, //horizontal
              0.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.orange[100],
            blurRadius: 10.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              -2.0, //horizontal
              -4.0, //vertical
            ),
          ),
        ],
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange[500],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[400],
              Colors.orange[500],
            ]),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Center(
        child: Center(
          child: SpinKitCircle(color: Colors.white,
          size: 30.0,)
        ),
      ),
    );
  }
}
