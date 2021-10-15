import 'package:agelgil_user_end/models/Models.dart';
import 'package:flutter/material.dart';

class HyphenDevider extends StatelessWidget {
  Orders orders;
  HyphenDevider({this.orders});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11.0),
        child: Column(
          children: [
            Container(
              height: 145,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Flex(
                          children: List.generate(
                            (MediaQuery.of(context).size.width / 10).floor(),
                            (index) => Container(
                              height: 1,
                              width: 5,
                              color: Colors.grey[500],
                            ),
                          ),
                          direction: Axis.horizontal,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween);
                    },
                  )),
                ],
              ),
            ),
            Container(
              height: 178,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Visibility(
              visible: orders.eatThere == false,
              child: Container(
                height: 22,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                            children: List.generate(
                              (MediaQuery.of(context).size.width / 10).floor(),
                              (index) => Container(
                                height: 1,
                                width: 5,
                                color: Colors.grey[500],
                              ),
                            ),
                            direction: Axis.horizontal,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween);
                      },
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
