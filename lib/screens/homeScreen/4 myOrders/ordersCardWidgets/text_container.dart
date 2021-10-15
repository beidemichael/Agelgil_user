import 'package:agelgil_user_end/models/Models.dart';
import 'package:agelgil_user_end/screens/homeScreen/4%20myOrders/trackOrder/routeContainer.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:time_formatter/time_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:agelgil_user_end/screens/homeScreen/4 myOrders/ordersCardWidgets/sucessful.dart';
import 'package:agelgil_user_end/screens/homeScreen/4 myOrders/ordersCardWidgets/failed.dart';

import 'package:agelgil_user_end/service/database.dart';

class TextsAndContent extends StatefulWidget {
  Orders orders;
  DateTime now;
  bool loading;
  TextsAndContent({this.orders, this.now, this.loading});
  @override
  _TextsAndContentState createState() => _TextsAndContentState();
}

class _TextsAndContentState extends State<TextsAndContent> {
  // checkQRcode() async {
  //   var cameraScanResult = await scanner.scan();

  //   if (cameraScanResult == widget.orders.loungeOrderNumber) {
  //     DatabaseService(id: widget.orders.documentId).updateOrderByUser();
  //     deliverySuccessful(context);
  //   } else {
  //     deliveryFailed(context);
  //   }
  // }

  deliverySuccessful(BuildContext context) {
    CorrectBlurDialog alert = CorrectBlurDialog();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  deliveryFailed(BuildContext context) {
    IncorrectBlurDialog alert = IncorrectBlurDialog();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                height: 48,
                width: MediaQuery.of(context).size.width,
                // color: Colors.green[200],
                child: Center(
                  child: Marquee(
                    backDuration: Duration(milliseconds: 500),
                    directionMarguee: DirectionMarguee.oneDirection,
                    child: Text(widget.orders.loungeName.toString(),
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        // color: Colors.yellow[200],
                        child: Center(
                          child: Icon(FontAwesomeIcons.hotel,
                              size: 10.0, color: Colors.grey[200]),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 22,
                            width: 30,
                            decoration: BoxDecoration(
                                // color: Colors.red[50],
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                        children: List.generate(
                                          (3).floor(),
                                          (index) => Container(
                                            height: 1,
                                            width: 5,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween);
                                  },
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 7.0),
                            child: Center(
                              child: Icon(FontAwesomeIcons.conciergeBell,
                                  size: 7.0, color: Colors.grey[200]),
                            ),
                          ),
                          Container(
                            height: 22,
                            width: 30,
                            decoration: BoxDecoration(
                                // color: Colors.red[50],
                                ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Flex(
                                        children: List.generate(
                                          (3).floor(),
                                          (index) => Container(
                                            height: 1,
                                            width: 5,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                        direction: Axis.horizontal,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween);
                                  },
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 22,
                        width: 22,
                        // color: Colors.yellow[200],
                        child: Center(
                          child: Icon(FontAwesomeIcons.houseUser,
                              size: 10.0, color: Colors.grey[200]),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 22,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Delivery status',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w400)),
                        Text(
                            widget.orders.eatThere
                                ? !widget.orders.isBeingPrepared
                                    ? 'Waiting...'
                                    : 'Being prepared'
                                : widget.orders.isTaken
                                    ? 'Picked up'
                                    : !widget.orders.isBeingPrepared
                                        ? 'Waiting...'
                                        : 'Being prepared',
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 55,
                // color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300)),
                        Marquee(
                          backDuration: Duration(milliseconds: 400),
                          directionMarguee: DirectionMarguee.oneDirection,
                          child: Text(widget.orders.userName,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Phone',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w300)),
                        Text(widget.orders.userPhone,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 178,
              // color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Orderd items',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.quantity.length.toString(),
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Subtotal',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.subTotal.toString() + '0 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Service charge',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.serviceCharge.toString() + '0 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Delivery fee ',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.deliveryFee.toString() + '0 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Tip',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.grey[500],
                            )),
                        Text(widget.orders.tip.toString() + '.00 Birr',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Total',
                            style: TextStyle(
                              fontSize: 28.0,
                              color: Colors.grey[700],
                            )),
                        Text(
                            (widget.orders.subTotal +
                                        widget.orders.deliveryFee +
                                        widget.orders.tip +
                                        widget.orders.serviceCharge)
                                    .toString() +
                                '0 Birr',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            widget.orders.eatThere == false
                ? SizedBox(height: 22.0)
                : SizedBox(height: 0.0),
            widget.orders.eatThere == false
                ? SizedBox(height: 7.0)
                : SizedBox(height: 0.0),
            Stack(
              children: [
                Visibility(
                  visible: widget.orders.eatThere == false,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      child: BarcodeWidget(
                        barcode: Barcode.qrCode(),
                        data: widget.orders.orderCode,
                        color: Colors.grey[800],
                        drawText: false,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 0,
                  child: Visibility(
                    visible: !widget.orders.eatThere,
                    child: GestureDetector(
                      onTap: () {
                        launch("tel://${widget.orders.carrierPhone}");
                      },
                      child: Visibility(
                        visible: widget.orders.isTaken,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.phone,
                                size: 25.0, color: Colors.orange[500]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 0,
                  child: Visibility(
                    visible: !widget.orders.eatThere,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapRoute(
                                lat: widget.orders.loungeLatitude,
                                long: widget.orders.loungeLongitude,
                                deslat: widget.orders.latitude,
                                deslong: widget.orders.longitude,
                                carrierLat: widget.orders.carrierLatitude,
                                carrierLong: widget.orders.carrierLongitude,
                              ),
                            ));
                      },
                      child: Visibility(
                        visible: widget.orders.isTaken,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[200],
                          ),
                          child: Center(
                            child: Icon(FontAwesomeIcons.route,
                                size: 25.0, color: Colors.orange[500]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: widget.loading == true
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: SpinKitThreeBounce(
                              color: Colors.orange,
                              size: 10.0,
                            ),
                          ),
                        ],
                      ))
                  : Text(
                      convertTimeStampp(
                              widget.orders.created.millisecondsSinceEpoch)
                          .toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ],
    );
  }

  String convertTimeStampp(timeStamp) {
//Pass the epoch server time and the it will format it for you

    String formatted = formatTime(timeStamp).toString();
    return formatted;
  }

  String formatTime(int timestamp) {
    /// The number of milliseconds that have passed since the timestamp
    int difference = widget.now.millisecondsSinceEpoch - timestamp;
    String result;

    if (difference < 60000) {
      result = countSeconds(difference);
    } else if (difference < 3600000) {
      result = countMinutes(difference);
    } else if (difference < 86400000) {
      result = countHours(difference);
    } else if (difference < 604800000) {
      result = countDays(difference);
    } else if (difference / 1000 < 2419200) {
      result = countWeeks(difference);
    } else if (difference / 1000 < 31536000) {
      result = countMonths(difference);
    } else
      result = countYears(difference);

    return !result.startsWith("J") ? result + ' ago' : result;
  }

  /// Converts the time difference to a number of seconds.
  /// This function truncates to the lowest second.
  ///   returns ("Just now" OR "X seconds")
  String countSeconds(int difference) {
    int count = (difference / 1000).truncate();
    return count > 1 ? count.toString() + ' seconds' : 'Just now';
  }

  /// Converts the time difference to a number of minutes.
  /// This function truncates to the lowest minute.
  ///   returns ("1 minute" OR "X minutes")
  String countMinutes(int difference) {
    int count = (difference / 60000).truncate();
    return count.toString() + (count > 1 ? ' minutes' : ' minute');
  }

  /// Converts the time difference to a number of hours.
  /// This function truncates to the lowest hour.
  ///   returns ("1 hour" OR "X hours")
  String countHours(int difference) {
    int count = (difference / 3600000).truncate();
    return count.toString() + (count > 1 ? ' hours' : ' hour');
  }

  /// Converts the time difference to a number of days.
  /// This function truncates to the lowest day.
  ///   returns ("1 day" OR "X days")
  String countDays(int difference) {
    int count = (difference / 86400000).truncate();
    return count.toString() + (count > 1 ? ' days' : ' day');
  }

  /// Converts the time difference to a number of weeks.
  /// This function truncates to the lowest week.
  ///   returns ("1 week" OR "X weeks" OR "1 month")
  String countWeeks(int difference) {
    int count = (difference / 604800000).truncate();
    if (count > 3) {
      return '1 month';
    }
    return count.toString() + (count > 1 ? ' weeks' : ' week');
  }

  /// Converts the time difference to a number of months.
  /// This function rounds to the nearest month.
  ///   returns ("1 month" OR "X months" OR "1 year")
  String countMonths(int difference) {
    int count = (difference / 2628003000).round();
    count = count > 0 ? count : 1;
    if (count > 12) {
      return '1 year';
    }
    return count.toString() + (count > 1 ? ' months' : ' month');
  }

  /// Converts the time difference to a number of years.
  /// This function truncates to the lowest year.
  ///   returns ("1 year" OR "X years")
  String countYears(int difference) {
    int count = (difference / 31536000000).truncate();
    return count.toString() + (count > 1 ? ' years' : ' year');
  }

//   String convertTimeStamp(timeStamp) {
// //Pass the epoch server time and the it will format it for you
//     String formatted = formatTime(timeStamp).toString();
//     return formatted;
//   }
}
