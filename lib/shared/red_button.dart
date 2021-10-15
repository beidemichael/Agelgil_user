import 'package:flutter/material.dart';

class RedButton extends StatefulWidget {
  String text;
  RedButton({this.text});
  @override
  _RedButtonState createState() => _RedButtonState();
}

class _RedButtonState extends State<RedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red[900],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              2.0, //horizontal
              0.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.red[800],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              -0.0, //horizontal
              5.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.red[800],
            blurRadius: 5.0, //effect of softening the shadow
            spreadRadius: 0.1, //effecet of extending the shadow
            offset: Offset(
              2.0, //horizontal
              0.0, //vertical
            ),
          ),
          BoxShadow(
            color: Colors.red[100],
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
              Colors.red[500],
              Colors.red[400],
              Colors.red[400],
              Colors.red[400],
              Colors.red[400],
              Colors.red[400],
              Colors.red[400],
              Colors.red[400],
              Colors.red[500],
            ]),
        borderRadius: BorderRadius.circular(35.0),
      ),
      child: Center(
        child: Text(widget.text,
            style: TextStyle(
                fontSize: 21.0,
                color: Colors.white,
                fontWeight: FontWeight.w100)),
      ),
    );
  }
}
