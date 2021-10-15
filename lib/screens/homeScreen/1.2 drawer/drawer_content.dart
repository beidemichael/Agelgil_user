import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/adress/adressAlert/adress_list_dialog.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2%20drawer/logout/are_you_sure_you_want_to_logout.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';
import 'edit_Name_popup.dart';
import 'dart:core';
import 'package:url_launcher/url_launcher.dart';
import 'package:agelgil_user_end/screens/homeScreen/1.2 drawer/customer service/customer_service_dialog.dart';

class DrawerContent extends StatefulWidget {
  String userUid;
  String userName;
  String userPhone;
  String userPic;
  String documentId;
  bool controllerPhoneCustomerSupport;

  Function drawerState;
  DrawerContent({
    this.userUid,
    this.userName,
    this.userPhone,
    this.userPic,
    this.drawerState,
    this.documentId,
    this.controllerPhoneCustomerSupport,
  });
  @override
  _DrawerStateContent createState() => _DrawerStateContent();
}

class _DrawerStateContent extends State<DrawerContent> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.drawerState();
  }

  @override
  void initState() {
    super.initState();
    widget.drawerState();
  }

  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'agelgilfood@gmail.com',
    // queryParameters: {
    //   'subject': 'Example Subject & Symbols are allowed!'
    // }
  );

  adressList(
    BuildContext context,
    List<Adress> adress,
  ) {
    AdressListBlurDialog alert = AdressListBlurDialog(
      adress: adress,
      userUid: widget.userUid,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  customerServiceFunction(
    BuildContext context,
    List<CustomerService> customerService,
  ) {
    CustomerServiceBlurDialog alert =
        CustomerServiceBlurDialog(customerService: customerService);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  logOut(BuildContext context) {
    LogOutBlurDialog alert = LogOutBlurDialog();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    void whenProfileUpDateTapped() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: EditNameSettingPopup(
                      name: widget.userName, documentId: widget.documentId),
                ),
              ),
            );
          });
    }

    queryData = MediaQuery.of(context);
    final adress = Provider.of<List<Adress>>(context) ?? [];
    final customerService = Provider.of<List<CustomerService>>(context) ?? [];

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              whenProfileUpDateTapped();
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.orange[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 2.0, //effect of softening the shadow
                    spreadRadius: 1, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        7.0 //vertical
                        ),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Marquee(
                      backDuration: Duration(milliseconds: 500),
                      directionMarguee: DirectionMarguee.oneDirection,
                      child: Text(widget.userName,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 5.0),
                    Text(widget.userPhone,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.orange[500],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
                logOut(context);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[700],
                      blurRadius: 2.0, //effect of softening the shadow
                      spreadRadius: 1, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          7.0 //vertical
                          ),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.0),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[400],
                      ),
                      child: Icon(FontAwesomeIcons.signOutAlt,
                          size: 15.0, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 20.0),
                    Text('Logout',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();

              adressList(
                context,
                adress,
              );
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 2.0, //effect of softening the shadow
                    spreadRadius: 1, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        7.0 //vertical
                        ),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[400],
                    ),
                    child: Icon(FontAwesomeIcons.mapMarkedAlt,
                        size: 13.0, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 20.0),
                  Text('Address',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () {
              launch(_emailLaunchUri.toString());
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 2.0, //effect of softening the shadow
                    spreadRadius: 1, //effecet of extending the shadow
                    offset: Offset(
                        0.0, //horizontal
                        7.0 //vertical
                        ),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 20.0),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey[400],
                    ),
                    child: Icon(FontAwesomeIcons.solidEnvelope,
                        size: 13.0, color: Colors.grey[600]),
                  ),
                  SizedBox(width: 20.0),
                  Text('Feedback',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Visibility(
            visible: widget.controllerPhoneCustomerSupport,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();

                customerServiceFunction(
                  context,
                  customerService,
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[700],
                      blurRadius: 2.0, //effect of softening the shadow
                      spreadRadius: 1, //effecet of extending the shadow
                      offset: Offset(
                          0.0, //horizontal
                          7.0 //vertical
                          ),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.0),
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.grey[400],
                      ),
                      child: Icon(FontAwesomeIcons.phone,
                          size: 13.0, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 20.0),
                    Text('Customer Service',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
