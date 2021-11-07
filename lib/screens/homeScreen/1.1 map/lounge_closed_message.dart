import 'package:flutter/material.dart';

class LoungeClosedMessage extends StatefulWidget {
  double opacity;
  int color;
  String foodName;
  LoungeClosedMessage({
    this.foodName,
    this.opacity,
    this.color,
  });
  @override
  _LoungeClosedMessageState createState() => _LoungeClosedMessageState();
}

class _LoungeClosedMessageState extends State<LoungeClosedMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text(
            widget.foodName + ' is closed',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 14.0,
              // fontWeight: FontWeight.w700,
              // fontStyle: FontStyle.italic,
            ),
          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey[widget.color].withOpacity(widget.opacity)),
      ),
    );
  }
}
