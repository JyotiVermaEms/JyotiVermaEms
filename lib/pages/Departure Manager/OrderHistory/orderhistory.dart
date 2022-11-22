// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureordermodel.dart';

import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/component/Departure%20Manager/Select_Agent.dart';
import 'package:shipment/pages/Departure%20Manager/Order/DepartureOrder.dart';
import 'package:shipment/pages/Departure%20Manager/Order/depaturealertdiaolog.dart';

import '../../../component/Departure Manager/Dashboard/Dashboard.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class DepartureOrderHistory extends StatefulWidget {
  const DepartureOrderHistory({Key? key}) : super(key: key);

  @override
  _DepartureOrderHistoryState createState() => _DepartureOrderHistoryState();
}

class _DepartureOrderHistoryState extends State<DepartureOrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var _lastQuitTime;
  var index1;
  var clientname;
  bool isProcess = false;
  String? bookingid,
      bookingdate,
      status1,
      title1,
      type,
      from1,
      to1,
      orderId,
      pickuptype,
      pickupAgentId;
  var exData = [];

  int? Id;
  List<DepatureOrder> shipmentOrder = [];
  getShipmentList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().departureOrderhistory();
    setState(() {
      shipmentOrder = response.data;
      exData = response.data;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('client_Id', Id.toString());

    setState(() {
      isProcess = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipmentList();
  }

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
              context, MaterialPageRoute(builder: (context) => Dashboard()));
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
            child: DepartureSidebar(),
          ),
          body: isProcess == true
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                  color: Color(0xffE5E5E5),
                  child: SafeArea(
                      right: false,
                      child: ListView(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
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
                                margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                                child: Text(
                                  'orderhistory'.tr(),
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
                          shipmentOrder.length == 0
                              ? Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    elevation: 1,
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: linearGradientForWhiteCard(),
                                      child: Column(
                                        children: [
                                          // Image.asset(
                                          //   'assets/images/applogo.png',
                                          //   height:
                                          //       MediaQuery.of(context).size.height * 0.10,
                                          // ),
                                          SizedBox(height: 15),
                                          Text(
                                            'sorryouhavenotanybookingsyet'.tr(),
                                            style: headingStyle16MB(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    booking(),
                                    orderTemplate(),
                                    orderDetails(),
                                    // orderDetails2(),
                                    // orderDetails3(),
                                    // orderDetails(),
                                  ],
                                ),

                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              MobileVieworderTemplate(),
                            ],
                          ),

                        // workingFlow(),

                        // if (Responsive.isMobile(context))
                        //   Column(
                        //     children: [
                        //       booking(),
                        //       // workingFlow(),
                        //     ],
                        //   ),
                        // if (Responsive.isTablet(context))
                        //   Column(
                        //     children: [
                        //       booking(),
                        //       // workingFlow(),
                        //     ],
                        //   ),
                      ])),
                )),
    );
  }

  Widget booking() {
    return Container(
        // height: (!Responsive.isDesktop(context))
        //     ? MediaQuery.of(context).size.height * (60 / 100)
        //     : MediaQuery.of(context).size.height * (45 / 100),
        height: 80,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10.0),
        //   color: Color(0xffFFFFFF),
        // ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("allorder".tr(),
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                ),
                // Container(
                //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                //   child: Align(
                //       alignment: Alignment.topLeft,
                //       child: Text("Select Status",
                //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                // ),
                // Container(
                //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                //   child: Align(
                //       alignment: Alignment.topLeft,
                //       child: Text("Draft (0)",
                //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                // ),
                // Container(
                //     margin: EdgeInsets.only(top: 15, right: 10),
                //     height: MediaQuery.of(context).size.height * (5 / 100),
                //     // height: 100,
                //     width: MediaQuery.of(context).size.width * (10 / 100),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10.0),
                //       color: Color(0xffFFFFFF),
                //     ),
                //     child: Center(
                //       child: Container(
                //         margin: EdgeInsets.only(
                //           left: 10,
                //         ),
                //         child: Text(
                //           "Select Status",
                //           style: TextStyle(fontSize: 15),
                //         ),
                //       ),
                //     )),
                Spacer(),

                GestureDetector(
                  onTap: () {
                    print("export");
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Booking Date",
                        "Schedule Title",
                        "Client Name",
                        "status",
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      if (exData[i].status == "received by receptionist") {
                        List row = [];
                        row.add(exData[i].id);
                        // row.add(exData[i].bookingDate);
                        // row.add(exData[i].booking);
                        row.add(exData[i].bookingDate);
                        row.add(exData[i].title);
                        row.add(exData[i].client.name);

                        row.add(exData[i].status);

                        rows.add(row);
                      }
                    }
                    DateTime now = DateTime.now();
                    DateTime todayDate = DateTime(now.year, now.month, now.day);

                    String fileName = "order_" +
                        getRandomString(5) +
                        "_" +
                        todayDate.toString();

                    String csv = const ListToCsvConverter().convert(rows);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 15, right: 10),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      // height: 100,
                      width: MediaQuery.of(context).size.width * (10 / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              "export".tr(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // _selectDate(context);
                            },
                            child: Container(
                              height: 25,
                              width: 25,
                              margin: EdgeInsets.only(
                                right: 10,
                              ),
                              child: Image.asset(
                                'assets/images/Calendar.png',
                              ),
                            ),
                          )
                        ],
                      )),
                ),

                // Spacer(),
                // Container(
                //     margin: EdgeInsets.only(top: 15, right: 10),
                //     height: MediaQuery.of(context).size.height * (5 / 100),
                //     // height: 100,
                //     width: MediaQuery.of(context).size.width * (10 / 100),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(10.0),
                //       color: Color(0xffFFFFFF),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         Container(
                //           margin: EdgeInsets.only(
                //             left: 10,
                //           ),
                //           child: Text(
                //             "Print",
                //             style: TextStyle(fontSize: 15),
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: () {
                //             // _selectDate(context);
                //           },
                //           child: Container(
                //             height: 25,
                //             width: 25,
                //             margin: EdgeInsets.only(
                //               right: 10,
                //             ),
                //             child: Image.asset(
                //               'assets/images/Calendar.png',
                //             ),
                //           ),
                //         )
                //       ],
                //     )),
                // Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(5.0),
                //         color: Color(0xff1A494F)),
                //     margin: EdgeInsets.only(top: 15, right: 15),
                //     height: MediaQuery.of(context).size.height * (5 / 100),
                //     // width: MediaQuery.of(context)
                //     //         .size
                //     //         .width *
                //     //     (11 / 100),
                //     child: Row(
                //       children: [
                //         Container(
                //           margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                //           child: Text(
                //             "Add Booking",
                //             style: headingStylewhite14(),
                //           ),
                //         ),
                //         Container(
                //           margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                //           child: Icon(
                //             Icons.add_box,
                //             color: Colors.white,
                //             size: 20,
                //           ),
                //         )
                //       ],
                //     )),
              ],
            ),
            Row(
              children: [],
            ),
          ],
        ));
  }

  Widget orderTemplate() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        height: h * 0.06,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: w * 0.04,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "orderid".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                // width: MediaQuery.of(context).size.width * (20 / 100),
                width: w * 0.08,
                // margin: EdgeInsets.only(right: 30),
                child: Text(
                  "bookingdate".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),

            Container(
                width: w * 0.08,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                child: Text(
                  "scheduletitle".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.07,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                // margin: EdgeInsets.only(left: 15),
                child: Text(
                  "clientname".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // Spacer(),
            Container(
                width: w * 0.05,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "status".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "changestatus".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: shipmentOrder.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (context, index) {
          return shipmentOrder[index].status == "received by receptionist"
              ? Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width * (20 / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: w * 0.04,
                            margin: EdgeInsets.only(left: 35),
                            child: Text(
                              shipmentOrder[index].id.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            width: w * 0.08,
                            child: Text(
                              shipmentOrder[index].bookingDate.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                          width: w * 0.08,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // margin: EdgeInsets.only(
                                      //     left: 100,
                                      //     // top: 250,
                                      //     top: 190),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: ContainerListDialog(
                                            stitle: shipmentOrder[index].title,
                                            sid: shipmentOrder[index].id,
                                            stype: shipmentOrder[index]
                                                .bookingType,
                                            sto: shipmentOrder[index].to,
                                            sfrom: shipmentOrder[index].from,
                                            bookingitem: shipmentOrder[index]
                                                .bookingItem,
                                            h: h,
                                            w: w),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              shipmentOrder[index].title.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A494F)),
                            ),
                          ),
                        ),
                        Container(
                            width: w * 0.05,
                            child: Center(
                              child: Text(
                                shipmentOrder[index].client.name.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                        Container(
                            width: w * 0.07,
                            child: Text(
                              shipmentOrder[index].status.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        GestureDetector(
                          onTap: () {
                            var pid = shipmentOrder[index].pickupagentId;

                            var itemimage =
                                shipmentOrder[index].pickupItemimage.toString();

                            var comment =
                                shipmentOrder[index].pickupComment.toString();
                            var itemimage1 = shipmentOrder[index]
                                .pickupItemimage1
                                .toString();
                            var comment1 =
                                shipmentOrder[index].pickupComment1.toString();
                            var depatureimage =
                                shipmentOrder[index].departureImage.toString();
                            var depaturecomment = shipmentOrder[index]
                                .departureComment
                                .toString();
                            var bid = shipmentOrder[index].id.toString();
                            var type =
                                shipmentOrder[index].bookingType.toString();
                            var bookingdate =
                                shipmentOrder[index].bookingDate.toString();
                            var status = shipmentOrder[index].status.toString();

                            print(shipmentOrder[index]
                                .pickupReview[0]
                                .pickupType);
                            print(bid);
                            print(type);
                            print(bookingdate);
                            print(status);
                            shipmentOrder[index].pickupReview[0].pickupType ==
                                    "Pick up"
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialogBox1(
                                          bid,
                                          pid,
                                          type,
                                          bookingdate,
                                          status,
                                          '',
                                          itemimage,
                                          comment,
                                          itemimage1,
                                          comment1,
                                          depatureimage,
                                          depaturecomment,
                                        ))
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialogBoxDropOff(
                                          bid,
                                          pid,
                                          type,
                                          bookingdate,
                                          status,
                                          '',
                                          itemimage,
                                          comment,
                                          itemimage1,
                                          comment1,
                                          depatureimage,
                                          depaturecomment,
                                        ));
                          },
                          child: Container(
                              width: w * 0.12,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              // width:
                              //     MediaQuery.of(context).size.width * (12 / 100),
                              height: 40,
                              margin: EdgeInsets.only(right: 20),
                              child: Center(
                                child: Text(
                                  "updatestatus".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.white),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              : Container();
        });
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: shipmentOrder.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * (50 / 100),
            width: w,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "orderid".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "status".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          shipmentOrder[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(shipmentOrder[index].status.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "bookingdate".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 0, top: 10),
                        child: Text(
                          shipmentOrder[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Text("scheduletitle".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(shipmentOrder[index].title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Text("clientname".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(shipmentOrder[index].client.name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Text("changestatus".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    GestureDetector(
                      onTap: () {
                        var pid = shipmentOrder[index].pickupagentId;

                        var itemimage =
                            shipmentOrder[index].pickupItemimage.toString();

                        var comment =
                            shipmentOrder[index].pickupComment.toString();
                        var itemimage1 =
                            shipmentOrder[index].pickupItemimage1.toString();
                        var comment1 =
                            shipmentOrder[index].pickupComment1.toString();
                        var depatureimage =
                            shipmentOrder[index].departureImage.toString();
                        var depaturecomment =
                            shipmentOrder[index].departureComment.toString();
                        var bid = shipmentOrder[index].id.toString();
                        var type = shipmentOrder[index].bookingType.toString();
                        var bookingdate =
                            shipmentOrder[index].bookingDate.toString();
                        var status = shipmentOrder[index].status.toString();

                        print(shipmentOrder[index].pickupReview[0].pickupType);
                        print(bid);
                        print(type);
                        print(bookingdate);
                        print(status);
                        shipmentOrder[index].pickupReview[0].pickupType ==
                                "Pick up"
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBox1(
                                      bid,
                                      pid,
                                      type,
                                      bookingdate,
                                      status,
                                      '',
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                      depatureimage,
                                      depaturecomment,
                                    ))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxDropOff(
                                      bid,
                                      pid,
                                      type,
                                      bookingdate,
                                      status,
                                      '',
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                      depatureimage,
                                      depaturecomment,
                                    ));
                      },
                      child: Container(
                          width: w * 0.35,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 40,
                          margin: EdgeInsets.only(right: 20, top: 20),
                          child: Center(
                            child: Text(
                              "updatestatus".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * (40 / 100),
            width: w,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Order ID",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "123456 ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(left: 15, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xff0FBAB8),
                          ),
                          child: Center(
                            child: Text(
                              "Deliverd",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
                Container(
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Booking Date",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Boat/ Plane / Roads",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "21.08.2021",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Boat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Shipment Company",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("from",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("to",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "APM-Maersk.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("USA",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("India",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget ContainerListDialog(
      {sid, stype, sto, sfrom, stitle, h, w, List<BookingItem>? bookingitem}) {
    return Container(
      height: h * 0.35,
      width: w * 0.40,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Icon(
                  Icons.close,
                  color: Color(0xffC4C4C4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                sid.toString(),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: w * 0.15,
                child: Text(
                  "boatplaceship".tr(),
                  style: headingStyle16MB(),
                ),
              ),
              Container(
                width: w * 0.15,
                child: Text(
                  stype,
                  style: headingStyle16MB(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text(
                    "from".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(sfrom, style: headingStyle16MB()),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text("to".tr(), style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(sto, style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 3),
            height: 48,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, // set border color
                  width: 2.0), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  // searchfunction();
                },
                // controller: edit,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  hintText: "searchhere".tr(),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (val) {
                  // title = val;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDialogBoxDropOff1 extends StatefulWidget {
  var bid;
  var pid;
  var type;
  var bookingdate;
  var status;
  var btype;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  CustomDialogBoxDropOff1(
    this.bid,
    this.pid,
    this.type,
    this.bookingdate,
    this.status,
    this.btype,
    this.itemimage,
    this.comment,
    this.itemimage1,
    this.comment1,
    this.depatureimage,
    this.depaturecomment,
  );
  @override
  _CustomDialogBoxDropOff createState() => _CustomDialogBoxDropOff();
}

class _CustomDialogBoxDropOff extends State<CustomDialogBoxDropOff1> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<DepatureStatusData> changedata = [];
  Image? image;
  String getImage = '';

  String imagepath = '';
  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedEmail,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updatedLName,
      updateLanguauge;
  var amount;
  var email, mobileNumber, languages, country, lname, username, aboutMe;
  Future getProfile() async {
    var response = await Providers().getpickupAgentProfile();
    // log("get profile data" + jsonEncode(response));
    if (response.status == true) {
      setState(() {
        aboutMe = response.data[0].about_me;
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
        username = response.data[0].username;
      });

      // log("REPONSE" + jsonEncode(response.data));
    }

    // id =   response.user[universityList.indexOf(name)].id
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLName == null ? "$lname" : "$updatedLName",
      "email": "$email",
      "phone": updatedNumber == null ? mobileNumber : updatedNumber,
      "country": updatedCountry == null ? "$country" : "$updatedCountry",
      "address": " ",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge"
    };
    var response = await Providers().updatepickupAgentProfile(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        aboutMe = response.data[0].aboutMe;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
      });

      // log("REPONSE" + jsonEncode(response.data));

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                var id, pid, type, bookingdate, status;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomDialogBox1(id, pid, type,
                            bookingdate, status, '', '', '', '', '', '', '')));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // id =   response.user[universityList.indexOf(name)].id
  }

  void chooseFileUsingFilePicker(BuildContext context) async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
        withReadStream:
            true, // this will return PlatformFile object with read stream
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      // setState(() async {
      objFile = result.files.single;
      print("objFILE  $objFile");

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
      );
      //-----add other fields if needed
      // request.fields["id"] = "abc";

      //-----add selected file with request
      request.files.add(new http.MultipartFile(
          "file", objFile!.readStream!, objFile!.size,
          filename: objFile!.name));

      //-------Send request
      var resp = await request.send();
      print("resp  >>>>>>>>>>>>>>..$resp");

      //------Read response
      var result2 = await resp.stream.bytesToString();

      getImage = result2;
      var temp3 = ImageModel.fromJson(json.decode(result2));
      print("--=---=-= $result2");
      // temp2!.add(temp3);
      print("object  ${json.encode(temp3)}");
      setState(() {
        imagepath = temp3.data[0].image;
        buttonstatus = "Update Status";
        onTap = 1;
        // updateProfileApi();
      });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");
    }
  }

  void _openCamera(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        chooseFileUsingFilePicker(context);
                        setState(() {});
                      },
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(Icons.camera),
                            const SizedBox(width: 40),
                            Text('takeapicture'.tr()),
                            const SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.bid.toString(),
      "booking_status": "pickup item received",
      "schedule_status": "InProgress",
      "pickup_itemimage": jsonEncode(imagepath),
    };

    print(depatureData);
    //return;

    var response = await Providers().changeDepatureStatus(depatureData);
    if (response.status == true) {
      setState(() {
        changedata = response.data;
        Navigator.pop(context);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => profileConfirm(),
        //     ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateProfileApi();
    // getProfile();
    print(widget.bid);
    print(widget.type);
    print(widget.bookingdate);
    print(widget.status);
    print(widget.bid);
    print(imagepath.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      height: 600,
      width: 900,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "ordertracking".tr() + "  " + widget.bid,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffE5E5E5),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 40, top: 20),
                        width: 100,
                        child: Text(
                          "shippedvis".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "status".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 40, top: 20),
                        child: Text(
                          "bookingdate".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 40, top: 10),
                        child: Text(
                          widget.type,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 110,
                    // ),
                    Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.status,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 40, top: 10),
                        child: Text(
                          widget.bookingdate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(left: 20),
                      child: Image.asset('assets/images/Group 740.png',
                          fit: BoxFit.fill),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.status == "Accepted" ||
                            widget.status == "pickup item received" ||
                            widget.status == "received by receptionist"
                        ? Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.status == "Accepted" ||
                            widget.status == "assigned to agent" ||
                            widget.status == "going to pickup" ||
                            widget.status == "pickup done" ||
                            widget.status == "delivered to Warehouse"
                        ? Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 20),
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 20),
                            child: Image.asset('assets/images/Group 743.png',
                                fit: BoxFit.fill),
                          ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "accepted".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      "deliveredtodepaturewarehouse".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 5),
                    child: Text(
                      "receviedproceedforshipment".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(children: [
              Container(
                width: 90.0,
                height: 90.0,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Material(
                    borderRadius: BorderRadius.circular(200),
                    elevation: 10,
                    child: imagepath == ''
                        ? Center(child: Icon(Icons.person))
                        : ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
                            child: Container(
                                height: 90.0,
                                width: 90.0,
                                child: Image.network((imagepath),
                                    fit: BoxFit.cover)))),
              ),
              Positioned(
                left: 50,
                top: 5,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      imagepath = "";
                      onTap = 0;
                      print('removes $imagepath');
                    });
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                ),
              )
            ]),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.status == "Accepted") {
                        if (onTap == 0) {
                          _openCamera(context);
                        } else {
                          doChangeStatus();
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 15,
                        top: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: widget.status == "Accepted"
                              ? Color(0xff4CAF50)
                              : widget.status == "going to pickup"
                                  ? Colors.grey
                                  : widget.status == "pickup done"
                                      ? Colors.grey
                                      : widget.status ==
                                              "delivered to Warehouse"
                                          ? Color(0xff4CAF50)
                                          : Colors.grey),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                          child: widget.status == "Accepted"
                              ? Text("updatestatus".tr(),
                                  style: TextStyle(color: Colors.black))
                              : widget.status == "delivered to Warehouse"
                                  ? Text("updatestatus".tr(),
                                      style: TextStyle(color: Colors.white))
                                  : Text("updatestatus".tr(),
                                      style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 25,
                        top: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.black),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                        child: Text("close".tr(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
