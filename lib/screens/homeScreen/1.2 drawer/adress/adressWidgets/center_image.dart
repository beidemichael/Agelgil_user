import 'package:flutter/material.dart';
class CenterImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
                  child: Image(
                    color:Colors.orange[400],
                      image: AssetImage("images/others/position.png"),
                      height: 40,
                      width: 40,
                    ),
                );
  }
}