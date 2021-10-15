import 'package:flutter/material.dart';
class PlaceYourAdressAtTheCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 110,
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
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  "Place your adress at the center",
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
  }
}