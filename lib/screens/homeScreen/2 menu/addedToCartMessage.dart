import 'package:flutter/material.dart';

class AddedToCartMessage extends StatefulWidget {
  double screenWidth;
  String foodName;
  AddedToCartMessage({this.foodName, this.screenWidth});
  @override
  _AddedToCartMessageState createState() => _AddedToCartMessageState();
}

class _AddedToCartMessageState extends State<AddedToCartMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
      child: Container(
        height: 60,
        width: widget.screenWidth,
        child: Center(
          child: Text(
            widget.foodName + ' is added to Agelgil',
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
            color: Colors.grey[500].withOpacity(0.5)),
      ),
    );
  }
}
