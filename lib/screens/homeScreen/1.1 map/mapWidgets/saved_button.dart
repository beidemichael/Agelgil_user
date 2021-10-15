import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SavedButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
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
            child: Icon(FontAwesomeIcons.solidSave,
                size: 26, color: Colors.grey[300]),
          ),
        ),
      ],
    );
  }
}
