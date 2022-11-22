// ignore_for_file: prefer_const_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shipment/Element/Responsive.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/extensions.dart';

import 'package:shipment/Model/Shipment/shipmentNotificationModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';

import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/component/Res_Client/ClienSubmitReview.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Notification.dart';
// import 'package:shipment/component/Res_Shipment.dart/res_notification.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../Dashboard/PickupDashboard.dart';

class PickupNotificationScreen extends StatefulWidget {
  static const String route = '/';
  const PickupNotificationScreen({Key? key}) : super(key: key);

  @override
  _PickupNotificationScreen createState() => _PickupNotificationScreen();
}

class _PickupNotificationScreen extends State<PickupNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: PickupNotificationShow(),
        tablet: PickupNotificationShow(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: PickupSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: PickupNotificationShow(),
            ),
            // Expanded(
            //   flex: _size.width > 1340 ? 8 : 10,
            //   child: EmailScreen(),
            // ),
          ],
        ),
      ),
    );
  }
}

class PickupNotificationShow extends StatefulWidget {
  PickupNotificationShow();
  // const ClientReview({Key? key}) : super(key: key);

  @override
  _PickupNotificationShow createState() => _PickupNotificationShow();
}

class _PickupNotificationShow extends State<PickupNotificationShow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

  List? reviewData;
  bool isProcess = false;

  List<ShipmentNotificationData> notificationData = [];

  var sid, companyName;

  getSubPanelNotificationList() async {
    setState(() {
      isProcess = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var shipmentauthToken = prefs.getString('Pickup_Agent_token');
    print("Token $shipmentauthToken");
    var response =
        await Providers().getShipmentSubPanelNotification(shipmentauthToken);

    if (response.status == true) {
      setState(() {
        notificationData = response.data;
      });
    }
    setState(() {
      isProcess = false;
    });
  }

  getSubPanelClearNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var shipmentauthToken = prefs.getString('Pickup_Agent_token');
    print("Token $shipmentauthToken");
    var response = await Providers()
        .getShipmentSubPanelClearNotification(shipmentauthToken);

    if (response.status == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickupNotificationScreen()),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubPanelNotificationList();
  }

  var _lastQuitTime;

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
                      ? PickupDashboard()
                      : PrePickupAgentDashboard()));
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
          child: PickupSideBar(),
        ),
        body: isProcess == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                height: h,
                color: Color(0xffF5F6F8),
                child: SafeArea(
                    child: ListView(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          if (!Responsive.isDesktop(context))
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                          if (Responsive.isDesktop(context)) SizedBox(width: 5),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'notifications'.tr() + '>',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Text(
                                //   companyName.toString(),
                                //   style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.w500),
                                // ),
                                // Spacer(),

                                // SizedBox(
                                //   width: 700,
                                // ),

                                InkWell(
                                  onTap: () {
                                    getSubPanelClearNotificationList();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => PickupDrop(data)));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.black),
                                    height: 35,
                                    width: (Responsive.isDesktop(context))
                                        ? 110
                                        : 90,
                                    child: Center(
                                      child: Text("clearall".tr(),
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (!Responsive.isDesktop(context))
                    //   Column(
                    //     children: [topBar(), buttons()],
                    //   ),
                    if (!Responsive.isDesktop(context))
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          width: w,
                          height: h,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          child: ListView.builder(
                              itemCount: notificationData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: kDefaultPadding / 2),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(kDefaultPadding),
                                          decoration: BoxDecoration(
                                            color: kBgDarkColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: AssetImage(
                                                          "assets/images/Ellipse7.png"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          kDefaultPadding / 2),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          notificationData[
                                                                  index]
                                                              .title,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                          // style: Theme.of(context)
                                                          //     .textTheme
                                                          //     .caption!
                                                          //     .copyWith(
                                                          //       color: Colors.black,
                                                          //     ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          notificationData[
                                                                  index]
                                                              .msg,
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          // style: Theme.of(context)
                                                          //     .textTheme
                                                          //     .caption!
                                                          //     .copyWith(
                                                          //       color: Colors.black,
                                                          //     ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Text.rich(
                                                  //   TextSpan(
                                                  //     text: "jsdkjksjf",
                                                  //     style: TextStyle(
                                                  //       fontSize: 16,
                                                  //       fontWeight: FontWeight.w500,
                                                  //       color: kTextColor,
                                                  //     ),

                                                  //   ),
                                                  // ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      // Text(
                                                      //   notificationData[index]
                                                      //       .createdAt
                                                      //       .substring(0, 10),
                                                      //   style: Theme.of(context)
                                                      //       .textTheme
                                                      //       .caption!
                                                      //       .copyWith(
                                                      //         color: Colors.black,
                                                      //       ),
                                                      // ),
                                                      Text(
                                                        notificationData[index]
                                                            .createdAt
                                                            .substring(11, 19),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      Text(
                                                        notificationData[index]
                                                            .createdAt
                                                            .substring(0, 10),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      // SizedBox(height: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(height: kDefaultPadding / 2),
                                              // Text(
                                              //   chat!.body,
                                              //   maxLines: 2,
                                              //   overflow: TextOverflow.ellipsis,
                                              //   style: Theme.of(context).textTheme.caption!.copyWith(
                                              //         height: 1.5,
                                              //         color: isActive ? Colors.white70 : null,
                                              //       ),
                                              // )
                                            ],
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(5, 5),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF234395)
                                              .withOpacity(0.15),
                                        ),
                                        // if (!chat!.isChecked)
                                        //   Positioned(
                                        //     right: 8,
                                        //     top: 8,
                                        //     child: Container(
                                        //       height: 12,
                                        //       width: 12,
                                        //       decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         color: kBadgeColor,
                                        //       ),
                                        //     ).addNeumorphism(
                                        //       blurRadius: 4,
                                        //       borderRadius: 8,
                                        //       offset: Offset(2, 2),
                                        //     ),
                                        //   ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    if (Responsive.isDesktop(context))
                      Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          width: w,
                          height: h,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white),
                          child: ListView.builder(
                              itemCount: notificationData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding,
                                      vertical: kDefaultPadding / 2),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(kDefaultPadding),
                                          decoration: BoxDecoration(
                                            color: kBgDarkColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 40,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: AssetImage(
                                                          "assets/images/Ellipse7.png"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          kDefaultPadding / 2),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          notificationData[
                                                                  index]
                                                              .title,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                          // style: Theme.of(context)
                                                          //     .textTheme
                                                          //     .caption!
                                                          //     .copyWith(
                                                          //       color: Colors.black,
                                                          //     ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Text(
                                                          notificationData[
                                                                  index]
                                                              .msg,
                                                          style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.6),
                                                          ),
                                                          // style: Theme.of(context)
                                                          //     .textTheme
                                                          //     .caption!
                                                          //     .copyWith(
                                                          //       color: Colors.black,
                                                          //     ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Text.rich(
                                                  //   TextSpan(
                                                  //     text: "jsdkjksjf",
                                                  //     style: TextStyle(
                                                  //       fontSize: 16,
                                                  //       fontWeight: FontWeight.w500,
                                                  //       color: kTextColor,
                                                  //     ),

                                                  //   ),
                                                  // ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      // Text(
                                                      //   notificationData[index]
                                                      //       .createdAt
                                                      //       .substring(0, 10),
                                                      //   style: Theme.of(context)
                                                      //       .textTheme
                                                      //       .caption!
                                                      //       .copyWith(
                                                      //         color: Colors.black,
                                                      //       ),
                                                      // ),
                                                      Text(
                                                        notificationData[index]
                                                            .createdAt
                                                            .substring(11, 19),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      Text(
                                                        notificationData[index]
                                                            .createdAt
                                                            .substring(0, 10),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      ),
                                                      // SizedBox(height: 5),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(height: kDefaultPadding / 2),
                                              // Text(
                                              //   chat!.body,
                                              //   maxLines: 2,
                                              //   overflow: TextOverflow.ellipsis,
                                              //   style: Theme.of(context).textTheme.caption!.copyWith(
                                              //         height: 1.5,
                                              //         color: isActive ? Colors.white70 : null,
                                              //       ),
                                              // )
                                            ],
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(5, 5),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF234395)
                                              .withOpacity(0.15),
                                        ),
                                        // if (!chat!.isChecked)
                                        //   Positioned(
                                        //     right: 8,
                                        //     top: 8,
                                        //     child: Container(
                                        //       height: 12,
                                        //       width: 12,
                                        //       decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         color: kBadgeColor,
                                        //       ),
                                        //     ).addNeumorphism(
                                        //       blurRadius: 4,
                                        //       borderRadius: 8,
                                        //       offset: Offset(2, 2),
                                        //     ),
                                        //   ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                  ],
                ))),
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            height: 48,
            width: (Responsive.isDesktop(context))
                ? 349
                : MediaQuery.of(context).size.width * (30 / 100),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Color(0xff90A0B7),
                ),
                Text(
                  "Search",
                  style: headingStyle12greynormal(),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: (Responsive.isDesktop(context))
                ? 136
                : MediaQuery.of(context).size.width * (40 / 100),
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.teal, width: 2.0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '21.08.2021',
                    style: headingStyle12blacknormal(),
                  ),
                  Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        "images/menu-board.png",
                      ),
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget reivewList() {
  //   return ListView.builder(
  //     itemCount: showData.length,
  //     shrinkWrap: true,
  //     itemBuilder: (context, index) {
  //       return Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Align(
  //             alignment: Alignment.topCenter,
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 border: Border.all(width: 0.5, color: Colors.black),
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: Color(0xffFFFFFF),
  //               ),
  //               margin: EdgeInsets.only(left: 24, top: 15, right: 10),
  //               // height: h * 0,
  //               width: w,
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Container(
  //                           margin: EdgeInsets.only(
  //                             left: 10,
  //                             right: 10,
  //                           ),
  //                           child: showData[index].clientname[0].profileimage !=
  //                                   'null'
  //                               ? Image.network(showData[index]
  //                                   .clientname[0]
  //                                   .profileimage
  //                                   .toString())
  //                               : Icon(Icons.person),
  //                           height: 75,
  //                           width: 50),
  //                       Padding(
  //                         padding: const EdgeInsets.all(0.0),
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Container(
  //                               margin: EdgeInsets.only(top: 10, left: 10),
  //                               child: Text(
  //                                   showData[index]
  //                                       .clientname[0]
  //                                       .name
  //                                       .toString(),
  //                                   style: TextStyle(
  //                                     color: Colors.black,
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 14,
  //                                   )),
  //                             ),
  //                             Container(
  //                               margin: EdgeInsets.only(right: 10, left: 10),
  //                               child: Text(
  //                                   (DateFormat.yMMMMd('en_US')
  //                                       .format(DateTime.parse(
  //                                           showData[index].createdAt))
  //                                       .toString()),
  //                                   // DateFormat.yMMMd('en_US')
  //                                   //     .parse(showData[index].createdAt)
  //                                   //     .toString(),
  //                                   style: TextStyle(
  //                                     color: Color(0xff90A0B7),
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 10,
  //                                   )),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Spacer(),
  //                       if (Responsive.isDesktop(context))
  //                         Padding(
  //                             padding: const EdgeInsets.all(0.0),
  //                             child: RatingBarIndicator(
  //                               rating: double.parse(
  //                                   double.parse(showData[index].rating)
  //                                       .toString()),
  //                               direction: Axis.horizontal,
  //                               // allowHalfRating: true,
  //                               itemCount: 5,
  //                               itemSize: 30,
  //                               unratedColor: Colors.black.withAlpha(50),
  //                               itemBuilder: (context, index) => Container(
  //                                 margin: EdgeInsets.only(top: 15),
  //                                 child: Icon(
  //                                   Icons.star,
  //                                   color: Colors.yellowAccent,
  //                                 ),
  //                               ),
  //                             )),
  //                     ],
  //                   ),
  //                   // if (Responsive.isMobile(context))
  //                   //   Padding(
  //                   //     padding: const EdgeInsets.all(0.0),
  //                   //     child: Column(
  //                   //       crossAxisAlignment: CrossAxisAlignment.start,
  //                   //       children: [
  //                   //         Container(
  //                   //           // width: w * 0.20,
  //                   //           child: Row(
  //                   //             children: [
  //                   //               Container(
  //                   //                   margin: EdgeInsets.only(left: 10),
  //                   //                   child: Icon(
  //                   //                     Icons.star_border,
  //                   //                     size: 20,
  //                   //                   )),
  //                   //               Container(
  //                   //                   margin: EdgeInsets.only(left: 5),
  //                   //                   child: Icon(
  //                   //                     Icons.star_border,
  //                   //                     size: 20,
  //                   //                   )),
  //                   //               Container(
  //                   //                   margin: EdgeInsets.only(left: 5),
  //                   //                   child: Icon(
  //                   //                     Icons.star_border,
  //                   //                     size: 20,
  //                   //                   )),
  //                   //               Container(
  //                   //                   margin: EdgeInsets.only(left: 5),
  //                   //                   child: Icon(
  //                   //                     Icons.star_border,
  //                   //                     size: 20,
  //                   //                   )),
  //                   //               Container(
  //                   //                   margin:
  //                   //                       EdgeInsets.only(left: 5, right: 10),
  //                   //                   child: Icon(
  //                   //                     Icons.star_border,
  //                   //                     size: 20,
  //                   //                   )),
  //                   //             ],
  //                   //           ),
  //                   //         ),
  //                   //         // Container(
  //                   //         //   margin: EdgeInsets.only(right: 10, left: 10),
  //                   //         //   child: Text("4.0",
  //                   //         //       style: TextStyle(
  //                   //         //         color: Color(0xff90A0B7),
  //                   //         //         fontWeight: FontWeight.bold,
  //                   //         //         fontSize: 10,
  //                   //         //       )),
  //                   //         // ),
  //                   //       ],
  //                   //     ),
  //                   //   ),
  //                   Container(
  //                     margin: EdgeInsets.only(top: 10, left: 10),
  //                     child: Text(showData[index].comment.toString(),
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                           fontSize: 14,
  //                         )),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget buttons() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            var data = {"sid": "$sid", "companyname": "$companyName"};

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClinetSubmitReview(data)));
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xffE1B400)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                    // width: MediaQuery.of(context).size.width * 0.8,
                    // color: Colors.lime,
                    child: Center(
                        child: Text("Share Review",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 30),
                  height: 30,
                  // width: 300,
                  child: Image.asset('assets/images/arrow-right.png'),
                ),
              ],
            ),
          ),
        ),
        // GestureDetector(
        //   onTap: () {
        //     var data = {"sid": "$sid"};

        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => ClinetSubmitReview(data)));
        //   },
        //   child:
        //    Container(
        //     margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(50.0),
        //         color: Color(0xff1A494F)),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //             margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

        //             // width: MediaQuery.of(context).size.width * 0.8,
        //             // color: Colors.lime,
        //             child: Center(
        //                 child: Text("Respond",
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                     )))),
        //         Container(
        //           margin: EdgeInsets.only(top: 15, right: 10, left: 30),
        //           height: 30,
        //           // width: 300,
        //           child: Image.asset('assets/images/arrow-right.png'),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
