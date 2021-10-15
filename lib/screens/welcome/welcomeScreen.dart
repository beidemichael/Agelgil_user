
import 'package:agelgil_user_end/shared/background_blur.dart';
import 'package:agelgil_user_end/shared/orange_button.dart';
import 'package:agelgil_user_end/wrapper.dart';

import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController ctrl = PageController(viewportFraction: 1);

  int currentPage = 0;
  Image welcome1 = Image.asset("images/others/welcome1.png");
  Image welcome2 = Image.asset("images/others/welcome2.png");
  Image welcome3 = Image.asset("images/others/welcome3.png");

  @override
  void initState() {
    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        BackgroundBlur(),
        SafeArea(
            child: PageView(
          controller: ctrl,
          children: [
            ///////////////////////////container 1
            Container(
              // color: Colors.red,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.height / 2,
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Container()),
                            Expanded(
                              flex: 13,
                              child: Image(
                                image: welcome1.image,
                                width: MediaQuery.of(context).size.width * 0.7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Text(
                        'Browse the menu and order directly from the applicaton',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  /////////////////////////preparing second image for display
                  Positioned(
                    top: -700,
                    child: Image(
                      image: welcome2.image,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  /////////////////////////preparing thired image for display
                  Positioned(
                    top: -700,
                    child: Image(
                      image: welcome3.image,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),

            ///////////////////////////container 2
            Container(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.height / 2,
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                              flex: 13,
                              child: Image(
                                image: welcome2.image,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Text(
                        'From local eateries',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  /////////////////////////preparing third image for display
                  Positioned(
                    top: -700,
                    child: Image(
                      image: welcome3.image,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  /////////////////////////preparing first image for display
                  Positioned(
                    top: -10000,
                    child: Image(
                      image: welcome1.image,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
            ///////////////////////////container 3
            Container(
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.height / 2,
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                              flex: 13,
                              child: Image(
                                image: welcome3.image,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20),
                      child: Text(
                        'Delivered to your door.',
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              // Navigator.of(context).pop();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => Wrapper()));
                            },
                            child: OrangeButton(
                              text: 'GET STARTED',
                            )),
                      ],
                    ),
                  ),
                  /////////////////////////preparing second image for display
                  Positioned(
                    top: -700,
                    child: Image(
                      image: welcome2.image,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),

        //////////////////bottom page indicator three dots
        Positioned(
          right: 0.0,
          left: 0.0,
          bottom: 20,
          child: Center(
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 10,
                      //  color: Colors.blue,
                      width: 144,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 10,
                                width: 30,
                                // color: Colors.yellow,
                              ),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[500],
                                      blurRadius:
                                          0.5, //effect of softening the shadow
                                      spreadRadius:
                                          0.5, //effecet of extending the shadow
                                      offset: Offset(
                                          0.0, //horizontal
                                          0.0 //vertical
                                          ),
                                    ),
                                  ],
                                  color: index == currentPage
                                      ? Colors.grey[600]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
