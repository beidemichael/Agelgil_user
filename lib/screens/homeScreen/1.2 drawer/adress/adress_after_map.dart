import 'dart:ui';

import 'package:agelgil_user_end/service/database.dart';
import 'package:flutter/material.dart';

class AdressAddBlurDialog extends StatelessWidget {
  double latitude;
  double longitude;
  String userUid;
  AdressAddBlurDialog({this.latitude, this.longitude, this.userUid});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String newName;
  String newInformation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 340,
            decoration: BoxDecoration(
              color: Colors.grey[100].withOpacity(0.9),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Name can\'t be empty' : null,
                            onChanged: (val) {
                              newName = (val);
                            },
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500
                                // decorationColor: Colors.white,
                                ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),

                              //Label Text/////////////////////////////////////////////////////////

                              focusColor: Colors.orange[900],
                              labelText: 'Adress Name',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                  color: Colors.grey[400]),
                              /* hintStyle: TextStyle(
                                                        color: Colors.orange[900]
                                                        ) */
                              ///////////////////////////////////////////////

                              //when it's not selected////////////////////////////
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[400])),
                              ////////////////////////////////

                              ///when textfield is selected//////////////////////////
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.orange[200])),
                              ////////////////////////////////////////
                            ),
                          ),
                          SizedBox(height: 40),
                          TextFormField(
                            validator: (val) => val.isEmpty
                                ? 'You can instead add house number'
                                : null,
                         
                            onChanged: (val) {
                              newInformation = (val);
                            },
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500
                                // decorationColor: Colors.white,
                                ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),

                              //Label Text/////////////////////////////////////////////////////////

                              focusColor: Colors.orange[900],
                              hintText: 'Block 24, Floor 67, Room 673',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18.0,
                                  color: Colors.grey[400]),
                              /* hintStyle: TextStyle(
                                                        color: Colors.orange[900]
                                                        ) */
                              ///////////////////////////////////////////////

                              //when it's not selected////////////////////////////
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.grey[400])),
                              ////////////////////////////////

                              ///when textfield is selected//////////////////////////
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide:
                                      BorderSide(color: Colors.orange[200])),
                              ////////////////////////////////////////
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          DatabaseService().addAdress(
                            latitude,
                            longitude,
                            userUid,
                            newName,
                            newInformation,
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                         
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width - 50,
                          height: 50,
                          child: Center(
                            child: Text('Add',
                                style: TextStyle(
                                    fontSize: 21.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100)),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.orange[400],
                              borderRadius: BorderRadius.circular(35.0))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
