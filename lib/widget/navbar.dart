import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/pages/monitoring.dart';
import 'package:my_app/pages/home.dart';
import 'package:my_app/pages/about.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int pageIndex = 0;

  final pages = [
    HomePage(),
    ReportPage(),
    //AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 0;
                  });
                },
                icon: pageIndex == 0
                    ? Icon(
                        Icons.home,
                        color: Theme.of(context).focusColor,
                        size: 32,
                      )
                    : Icon(
                        Icons.home_outlined,
                        color: Theme.of(context).unselectedWidgetColor,
                        size: 32,
                      ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                enableFeedback: false,
                onPressed: () {
                  setState(() {
                    pageIndex = 1;
                  });
                },
                icon: pageIndex == 1
                    ? Icon(
                        Icons.pie_chart,
                        color: Theme.of(context).focusColor,
                        size: 32,
                      )
                    : Icon(
                        Icons.pie_chart_outline,
                        color: Theme.of(context).unselectedWidgetColor,
                        size: 32,
                      ),
              ),
            ],
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     IconButton(
          //       enableFeedback: false,
          //       onPressed: () {
          //         setState(() {
          //           pageIndex = 2;
          //         });
          //       },
          //       icon: pageIndex == 2
          //           ? Icon(
          //               Icons.payments,
          //               color: Theme.of(context).focusColor,
          //               size: 32,
          //             )
          //           : Icon(
          //               Icons.payments_outlined,
          //               color: Theme.of(context).unselectedWidgetColor,
          //               size: 32,
          //             ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
