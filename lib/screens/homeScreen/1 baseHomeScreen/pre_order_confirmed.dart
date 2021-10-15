import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/1%20baseHomeScreen/order_confirmed.dart';
import 'package:agelgil_user_end/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//ignore: must_be_immutable
class PreOrderConfirmed extends StatelessWidget {
  String userUidconfirm;
  String orderNumber;
  PreOrderConfirmed({this.orderNumber, this.userUidconfirm});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ConfirmOrder>>.value(
      value: DatabaseService(
              userUid: userUidconfirm,
              orderNumber: orderNumber)
          .confirmOrder,
      child: OrderConfirmedBlurDialog(),
    );
  }
}
