import 'dart:ui';
import 'package:flutter/material.dart';

class NoEateriesDialog extends StatefulWidget {
  @override
  _NoEateriesDialogState createState() => _NoEateriesDialogState();
}

class _NoEateriesDialogState extends State<NoEateriesDialog> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          color: Colors.black.withOpacity(.4),
          child: Center(
            child: Stack(
              children: [
                Container(
                  width: 250.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "No Eateries",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.grey[900],
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 4.0,
                          ),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  // color: Colors.red,
                                  height: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Text(
                                        "Looks like there are no registered or active eateries near you.",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      visible = false;
                                    });
                                  },
                                  child: Container(
                                    height: 65,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(30.0),
                                        bottomLeft: Radius.circular(30.0),
                                      ),
                                      color: Colors.orange,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                   
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
