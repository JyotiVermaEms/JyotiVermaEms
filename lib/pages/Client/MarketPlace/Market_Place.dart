// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_BookingOverView.dart';
import 'package:shipment/pages/Client/Dashboard/MobileDashboard.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class MarketPlace extends StatefulWidget {
  const MarketPlace({Key? key}) : super(key: key);

  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var _lastQuitTime;
  var h, w;
  int? _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (_lastQuitTime == null ||
            DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
          print('Press again Back Button exit');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (!Responsive.isDesktop(context))
                      ? MobileDashboard()
                      : DashboardHome()));
          return false;
        } else {
          // SystemNavigator.pop();

          return false;
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: SideBar(),
          ),
          body: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffE5E5E5),
            child: SafeArea(
                right: false,
                child: ListView(children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        if (!Responsive.isDesktop(context))
                          IconButton(
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                          ),
                        // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                          child: Text(
                            'marketplace'.tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    Column(
                      children: [
                        booking(),
                        workingFlow(),
                      ],
                    ),
                  if (Responsive.isMobile(context))
                    Column(
                      children: [booking(), mobileworkingFlow()],
                    ),
                  if (Responsive.isTablet(context))
                    Column(
                      children: [
                        booking(),
                        workingFlow(),
                      ],
                    ),
                ])),
          )),
    );
  }

  Widget booking() {
    return Container(
        height: (!Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.height * (60 / 100)
            : MediaQuery.of(context).size.height * (45 / 100),
        // height: 100,
        width: (Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (80 / 100)
            : MediaQuery.of(context).size.width * (95 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "booking".tr(),
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResBookingOverView()));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff1A494F)),
                      margin: EdgeInsets.only(top: 15, right: 15),
                      height: MediaQuery.of(context).size.height * (6 / 100),
                      // width: MediaQuery.of(context)
                      //         .size
                      //         .width *
                      //     (11 / 100),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "createbooking".tr(),
                              style: headingStylewhite14(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Icon(
                              Icons.add_box,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, right: 50, left: 50),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      "createanewprojecttodaytostartpromotingyourservices".tr(),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A494F)))),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResBookingOverView()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 15, bottom: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.black),
                    height: 45,
                    width: (Responsive.isDesktop(context)) ? 300 : 250,
                    child: Center(
                      child: Text("createyourbooking".tr(),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 20,
                      width: 20,
                      child: Icon(Icons.arrow_right, color: Colors.white)),
                ],
              ),
            ),
          ],
        ));
  }

  Widget workingFlow() {
    return Container(
        height: MediaQuery.of(context).size.height * (65 / 100),
        // height: 100,
        width: (Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (80 / 100)
            : MediaQuery.of(context).size.width * (95 / 100),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, right: 10, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "howbookingmarketplaceworks".tr(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * (7 / 100),
              // width: MediaQuery.of(context).size.width * (7 / 100),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Row(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * (15 / 100),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height:
                              MediaQuery.of(context).size.height * (15 / 100),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/Get_an_order.png",
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "getanorder".tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 35),
                          // width: MediaQuery.of(context).size.width * (10 / 100),
                          child: Text(
                              "youcanstartcommunicatingviashipmentmessages"
                                  .tr()),
                        )
                      ],
                    )),
                Spacer(),
                Container(
                    height: MediaQuery.of(context).size.height * (15 / 100),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height:
                                MediaQuery.of(context).size.height * (15 / 100),
                            width:
                                MediaQuery.of(context).size.width * (10 / 100),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/requirement.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 35),
                          child: Text(
                            "2. Wait for requirements",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 35),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          child: Text("thehours".tr()),
                        )
                      ],
                    )),
                Spacer(),
                Container(
                    height: MediaQuery.of(context).size.height * (15 / 100),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          height:
                              MediaQuery.of(context).size.height * (15 / 100),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/dead_line.png",
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 35),
                            child: Text(
                              "senworkbydeadline".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 35),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          child: Text("theclockyourequirements".tr()),
                        )
                      ],
                    )),
                Spacer(),
                Container(
                    height: MediaQuery.of(context).size.height * (15 / 100),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          height:
                              MediaQuery.of(context).size.height * (15 / 100),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/get_paid.png",
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 35),
                            child: Text(
                              "getpaid".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 35),
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          child: Text(
                            "completerevisioyoureceiv".tr(),
                          ),
                        )
                      ],
                    )),
              ],
            )
          ],
        ));
  }

  Widget mobileworkingFlow() {
    return Container(
        height: MediaQuery.of(context).size.height * (50 / 100),
        // height: 100,
        width: MediaQuery.of(context).size.width * (95 / 100),
        margin: EdgeInsets.fromLTRB(15, 15, 15, 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 15, right: 10, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "howbookingmarketplaceworks".tr(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              // height: MediaQuery.of(context).size.height * (7 / 100),
              // width: MediaQuery.of(context).size.width * (7 / 100),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              height: h * 0.38,
              child: Scrollbar(
                isAlwaysShown: true,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    (10 / 100),
                                width: MediaQuery.of(context).size.width *
                                    (10 / 100),
                                margin: EdgeInsets.only(top: 0, left: 50),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/Get_an_order.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "getanorder".tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0, left: 35),
                              // width: MediaQuery.of(context).size.width * (10 / 100),
                              child: Text(
                                  "youcanstartcommunicatingviashipmentmessages"
                                      .tr()),
                            )
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 0, left: 50),
                                height: MediaQuery.of(context).size.height *
                                    (10 / 100),
                                width: MediaQuery.of(context).size.width *
                                    (10 / 100),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/images/requirement.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 35),
                              child: Text(
                                "2. Wait for requirements",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0, left: 35),
                              // width:
                              //     MediaQuery.of(context).size.width * (10 / 100),
                              child: Text("thehours".tr()),
                            )
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: 0, left: 5),
                              height: MediaQuery.of(context).size.height *
                                  (10 / 100),
                              width: MediaQuery.of(context).size.width *
                                  (10 / 100),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/dead_line.png",
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 0, left: 35),
                                child: Text(
                                  "senworkbydeadline".tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0, left: 35),
                              // width:
                              //     MediaQuery.of(context).size.width * (10 / 100),
                              child: Text("theclockyourequirements".tr()),
                            )
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 0, left: 5),
                              height: MediaQuery.of(context).size.height *
                                  (10 / 100),
                              width: MediaQuery.of(context).size.width *
                                  (10 / 100),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/get_paid.png",
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 0, left: 35),
                                child: Text(
                                  "getpaid".tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 0, left: 35),
                              child: Text(
                                "completerevisioyoureceiv".tr(),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
