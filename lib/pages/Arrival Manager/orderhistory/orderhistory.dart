import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivalbookingModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalDashboardModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Dashboard.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/customAlertDialiog.dart';
import 'package:universal_html/html.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

import '../Arrival Dashboard/Dashboard.dart';

class ArrivalOrderHistory extends StatefulWidget {
  const ArrivalOrderHistory({Key? key}) : super(key: key);

  @override
  _ArrivalOrderHistoryState createState() => _ArrivalOrderHistoryState();
}

class _ArrivalOrderHistoryState extends State<ArrivalOrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  List<ArrivalBookingData> arrd = [];
  var id = [];
  var pendingshipent = [], progressShipment = [], completedshipment = [];
  var bookingData = [];
  var exData = [];
  bool isProcess = false;
  var h, w;
  int? _radioValue = 0;
  getArrivalList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getArrivalBookings();

    if (response.status == true) {
      setState(() {
        arrd = response.data;
        exData = response.data;
      });
      for (int i = 0; i < arrd.length; i++) {
        // id.add(arrd[i].id.toString());
        // bookingData = arrd[i].bookings;
        // arrd[i].status == "Open"
        //     ? pendingshipent.add(arrd[i].id.toString())
        //     : arrd[i].status == "closed"
        //         ? completedshipment.add(arrd[i].id.toString())
        //         : progressShipment.add(arrd[i].id.toString());
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArrivalList();
    // searchfunction1();
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
                      ? ArrivalDashboard()
                      : PreArrivalDashboard()));
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
            child: ArrivalSidebar(),
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
                                margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
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
                          arrd.isEmpty
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
                                            'Sorry, You have not any Bookings yet',
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
                                    orderDetails2(),
                                    // orderDetails3(),
                                    // orderDetails2(),
                                  ],
                                ),

                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              // booking(),
                              MobileVieworderTemplate(),
                              //MobileVieworderTemplate2(),
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
    return (Responsive.isDesktop(context))
        ? Container(
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey))),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "From",
                            "To",
                            "Shipment Company",
                            "Status"
                          ]
                        ];
                        for (int i = 0; i < exData.length; i++) {
                          if (exData[i].status == "received by receptionist") {
                            List row = [];
                            row.add(
                                exData[i].bookingItem[0].bookingId.toString());
                            // row.add(exData[i].bookingDate);
                            row.add(exData[i].bookingDate.toString());
                            row.add(exData[i].from.toString());
                            row.add(exData[i].to.toString());
                            row.add(exData[i].shipmentCompany);
                            row.add(exData[i].status.toString());
                            rows.add(row);
                          }
                        }
                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                        print("csv-=-= $csv");
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 15, right: 10),
                          height:
                              MediaQuery.of(context).size.height * (5 / 100),
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
                  ],
                ),
              ],
            ))
        : Container(
            height: 60,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("allorder".tr(),
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                InkWell(
                  onTap: () {
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Booking Date",
                        "From",
                        "To",
                        "Shipment Company",
                        "Status"
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      if (exData[i].status == "received by receptionist") {
                        List row = [];
                        row.add(exData[i].bookingItem[0].bookingId.toString());
                        // row.add(exData[i].bookingDate);
                        row.add(exData[i].bookingDate.toString());
                        row.add(exData[i].from.toString());
                        row.add(exData[i].to.toString());
                        row.add(exData[i].shipmentCompany);
                        row.add(exData[i].status.toString());
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
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      // height: 100,
                      width: MediaQuery.of(context).size.width * (30 / 100),
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
                              child: Image.asset(
                                'assets/images/Calendar.png',
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ));
  }

  Widget orderTemplate() {
    return Container(
      height: 80,
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
              width: w * 0.05,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.08,
              margin: EdgeInsets.only(right: 30),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.08,
              // margin: EdgeInsets.only(left: 50),
              child: Text(
                "from".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.05,
              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "to".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              width: w * 0.13,
              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "shipmentcomapny".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.08,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails2() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: arrd.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (BuildContext context, int index) {
          return arrd[index].status == "received by receptionist"
              ? Container(
                  // height: (!Responsive.isDesktop(context))
                  //     ? MediaQuery.of(context).size.height * (10 / 100)
                  //     : MediaQuery.of(context).size.height * (45 / 100),
                  height: 70,
                  width: MediaQuery.of(context).size.width * (80 / 100),
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: w * 0.05,
                        child: Text(
                            arrd[index].bookingItem[0].bookingId.toString()),
                      ),
                      Container(
                        width: w * 0.09,
                        child: Text(arrd[index].bookingDate.toString()),
                      ),
                      Container(
                        width: w * 0.06,
                        child: Text(arrd[index].from.toString()),
                      ),
                      Container(
                        width: w * 0.06,
                        child: Text(arrd[index].to.toString()),
                      ),
                      Container(
                        width: w * 0.08,
                        child: Text(arrd[index].shipmentCompany.toString()),
                      ),
                      GestureDetector(
                        onTap: () {
                          // var id = arrd[index].id.toString();
                          // var type = arrd[index].bookingType.toString();
                          // var bookingdate = arrd[index].bookingDate.toString();
                          // var status = arrd[index].status;
                          // var schedulStatus = arrd[index].status.toString();

                          // print(id);
                          // print(type);
                          // print(bookingdate);
                          // print(status);
                          // arrd[index].pickupReview[0].pickupType == "Pick up"
                          //     ? showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) =>
                          //             CustomDialogBoxx(
                          //                 id,
                          //                 type,
                          //                 bookingdate,
                          //                 status,
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 '',
                          //                 ''))
                          //     : showDialog(
                          //         context: context,
                          //         builder: (BuildContext context) =>
                          //             CustomDialogBoxArrivalDropOff(
                          //                 id, type, bookingdate, status));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                              margin: EdgeInsets.only(right: 5),
                              height: MediaQuery.of(context).size.height *
                                  (7 / 100),
                              width: w * 0.13,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              // width:
                              child: Center(
                                child: Text(
                                  arrd[index].status,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ))
              : Container();
        });
  }

  Widget orderDetails3() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 150,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        children: [
          Container(
              width: w * 0.15,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "12345",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.15,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "21.08.2021",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.15,

              // margin: EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: () {
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          // margin: EdgeInsets.only(
                          //     left: 100,
                          //     // top: 250,
                          //     top: 190),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            content: ContainerListDialog(h: h, w: w),
                          ),
                        );
                      });
                },
                child: Text(
                  "Vintage Journey",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )),

          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox2());
            },
            child: Container(
                height: MediaQuery.of(context).size.height * (5 / 100),
                // height: 100,
                width: w * 0.15,
                child: Text(
                  "Waiting for pick",
                  style: TextStyle(fontSize: 15, color: Color(0xff1A494F)),
                )),
          ),
          // Spacer(),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialogBox());
                },
                child: Container(
                    margin: EdgeInsets.only(top: 25, right: 10),
                    height: MediaQuery.of(context).size.height * (5 / 100),
                    // height: 100,
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xff4CAF50),
                    ),
                    child: Center(
                      child: Text(
                        "Self Drop Off",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 15, right: 10),
                  height: MediaQuery.of(context).size.height * (5 / 100),
                  // height: 100,
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      "Pick-up Order",
                      style: TextStyle(fontSize: 15, color: Color(0xffACACAC)),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: arrd.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
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
                          arrd[index].bookingItem[0].bookingId.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    InkWell(
                      onTap: () {
                        var id = arrd[index].id.toString();
                        var type = arrd[index].bookingType.toString();
                        var bookingdate = arrd[index].bookingDate.toString();
                        var status = arrd[index].status;
                        var schedulStatus = arrd[index].status.toString();

                        print(id);
                        print(type);
                        print(bookingdate);
                        print(status);
                        arrd[index].pickupReview[0].pickupType == "Pick up"
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxx(
                                        id,
                                        type,
                                        bookingdate,
                                        status,
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        '',
                                        ''))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxArrivalDropOff(
                                        id, type, bookingdate, status));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          margin: EdgeInsets.only(top: 10, right: 20),
                          child: Text(arrd[index].status,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    ),
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
                    // Container(
                    //     width: MediaQuery.of(context).size.width * (40 / 100),
                    //     margin: EdgeInsets.only(top: 10, right: 20),
                    //     child: Text("Boat/ Plane / Roads",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          arrd[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Container(
                    //     width: MediaQuery.of(context).size.width * (40 / 100),
                    //     margin: EdgeInsets.only(top: 10, right: 20),
                    //     child: Text("Boat",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "shipmentcomapny".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("from".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (15 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("to".tr(),
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
                          arrd[index].shipmentCompany.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(arrd[index].from.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (15 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(arrd[index].to.toString(),
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

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
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
                    // Container(
                    //     width: MediaQuery.of(context).size.width * (40 / 100),
                    //     margin: EdgeInsets.only(top: 10, right: 20),
                    //     child: Text("Waiting Pickup",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.red))),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBox());
                      },
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

  Widget ContainerListDialog({h, w}) {
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
            padding: const EdgeInsets.only(left: 30, top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "123456",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text(
                    "companyname".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    "apmmerck".tr(),
                    style: headingStyle16MB(),
                  ),
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
                  child: Text(
                    "Boat/ Place /Ship",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    "Boat",
                    style: headingStyle16MB(),
                  ),
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
                  child: Text(
                    "From",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.10,
                  child: Text("Usa", style: headingStyle16MB()),
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
                  child: Text("To", style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text("India", style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialogBoxArrivalDropOff extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status;
  CustomDialogBoxArrivalDropOff(
      this.id, this.type, this.bookingdate, this.status);
  @override
  _CustomDialogBoxArrivalDropOff createState() =>
      _CustomDialogBoxArrivalDropOff();
}

class _CustomDialogBoxArrivalDropOff
    extends State<CustomDialogBoxArrivalDropOff> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<ArrivalChangeStatusData> arrivalchangedata = [];
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
    }
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
      // itemList[index].imageList!.add(result2.toString());

      //-------Your response
      // print(result2);
      // });
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
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            Icon(Icons.camera),
                            SizedBox(width: 40),
                            Text('takeapicture'.tr()),
                            SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.id.toString(),
      "booking_status": "Delivered to Receptionist",
      "schedule_status": "",
      "pickup_itemimage": jsonEncode(imagepath),
    };

    print(depatureData);
    //return;

    var response = await Providers().changeArrivalStatus(depatureData);
    if (response.status == true) {
      setState(() {
        arrivalchangedata = response.data;
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
    print(widget.id);
    print(widget.type);
    print(widget.bookingdate);
    print(widget.status);
    print(widget.id);
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
                "ordertracking".tr() + "  " + widget.id,
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
                    // Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     child: Text(
                    //       "Order Recieved",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
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
                    widget.status == "Accepted"
                        ? Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          )
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
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
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          ),
                    // Container(
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Text(
                    //       "Close",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //
                    //   )),
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
                            widget.status == "delivered to Warehouse" ||
                            widget.status == "pickup item received"
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
                    // Container(
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Text(
                    //       "Close",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //
                    //   )),
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
                Spacer(),
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 5),
                    child: Text(
                      "deliveredtoreceptionist".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: 90.0,
              height: 90.0,
              margin: const EdgeInsets.only(top: 12),
              decoration: new BoxDecoration(
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
          ),
          Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (widget.status == "pickup item received") {
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
                                          ? Colors.grey
                                          : widget.status ==
                                                  "pickup item received"
                                              ? Color(0xff4CAF50)
                                              : Colors.grey),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                          child: widget.status == "Accepted"
                              ? Text("assigntoagent".tr(),
                                  style: TextStyle(color: Colors.white))
                              : widget.status == "going to pickup"
                                  ? Text("updatestatus".tr(),
                                      style: TextStyle(color: Colors.black))
                                  : widget.status == "pickup done"
                                      ? Text("updatestatus".tr(),
                                          style: TextStyle(color: Colors.black))
                                      : widget.status ==
                                              "delivered to Warehouse"
                                          ? Text("updatestatus".tr(),
                                              style: TextStyle(
                                                  color: Colors.black))
                                          : widget.status ==
                                                  "pickup item received"
                                              ? Text("updatestatus".tr(),
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : Text("updatestatus".tr(),
                                                  style: TextStyle(
                                                      color: Colors.white))),
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
