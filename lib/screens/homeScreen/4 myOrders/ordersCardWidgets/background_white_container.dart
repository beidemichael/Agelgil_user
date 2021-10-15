import 'package:flutter/material.dart';
import 'package:agelgil_user_end/models/Models.dart';

class GreyContainerFront extends StatelessWidget {
  Orders orders;
  GreyContainerFront({this.orders});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 145,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: Colors.grey[50],
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
                color: orders.eatThere == true
                    ? orders.isBeingPrepared == true
                        ? Colors.red[500]
                        : Colors.grey[500]
                    : orders.isTaken == true
                        ? Colors.orange[500]
                        : Colors.grey[500],
              ),
            ),
          ),
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey[50], BlendMode.srcOut),
          child: Stack(
            children: <Widget>[
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.dstOut,
                  color: Colors.grey[100],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 20,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 20,
                  width: 11,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: orders.eatThere ? 200 : 178,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: orders.eatThere
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                  ),
          ),
        ),
        Visibility(
          visible: orders.eatThere == false,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.grey[50], BlendMode.srcOut),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 22,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.dstOut,
                    color: Colors.grey[100],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 22,
                    width: 11,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 22,
                    width: 11,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: orders.eatThere == false,
          child: Container(
            height: orders.eatThere ? 80 : 180,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
