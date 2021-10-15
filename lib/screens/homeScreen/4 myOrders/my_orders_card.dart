import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/order_list_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:agelgil_user_end/shared/loading.dart';
import 'ordersCardWidgets/are_you_sure_you_want_to_cancel.dart';
import 'ordersCardWidgets/background_white_container.dart';
import 'ordersCardWidgets/hyphen_devider.dart';
import 'ordersCardWidgets/shadow_container.dart';
import 'ordersCardWidgets/text_container.dart';
import 'package:ntp/ntp.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyOrdersCard extends StatefulWidget {
  Orders orders;
  MyOrdersCard({this.orders});
  @override
  _MyOrdersCardState createState() => _MyOrdersCardState();
}

class _MyOrdersCardState extends State<MyOrdersCard> {
  DateTime now;
  bool loading = true;
  void initState() {
    super.initState();
    timeNow();
  }

  timeNow() async {
    now = await NTP.now();
    setState(() {
      loading = false;
    });
  }

  _orderList(BuildContext context) {
    OrderListBlurryDialog alert = OrderListBlurryDialog(widget.orders);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  areYouSureYouWantToCancel(BuildContext context, String documentId) {
    CancelOrderBlurDialog alert = CancelOrderBlurDialog(
      documentId: documentId,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  visibilityBool() {
    if (loading == false) {
      if (now.millisecondsSinceEpoch -
              widget.orders.created.millisecondsSinceEpoch <
          120000) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _orderList(context);
      },
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            areYouSureYouWantToCancel(
                                context, widget.orders.documentId);
                          },
                          child: Visibility(
                            visible: visibilityBool(),
                            // !widget.orders.isTaken,
                            child: CancelOrder(),
                          ),
                        ),
                        RedContainerBackShadow(
                          orders: widget.orders,
                        ),
                        GreyContainerFront(
                          orders: widget.orders,
                        ),
                        TextsAndContent(
                          orders: widget.orders,
                          now: now,
                          loading: loading,
                        ),
                        HyphenDevider(
                          orders: widget.orders,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  CancelOrder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            widget.orders.eatThere
                ? Container(color: Colors.transparent, height: 335)
                : Container(color: Colors.transparent, height: 517),
            Container(
              width: 150,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 5.0,
                    spreadRadius: 0.1,
                    offset: Offset(0.0, 3.0),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text('Cancel order',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
