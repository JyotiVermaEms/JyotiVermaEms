import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';

import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/Receptionist/receptionistBookingModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/pages/Receptionist/Bookings/bookingalertdialog.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page.dart';
import 'package:shipment/pages/Receptionist/Dashborad/receptionistDashboard.dart';
import 'package:shipment/pages/Receptionist/Notification/notification.dart';
// import 'package:universal_html/html.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:http/http.dart' as http;

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  List<ReceptionistBookingData> bookingData = [];
  bool isProcess = false;

  var exData = [];
  int? count;

  Future getBooking() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getReceptionistBooking();
    if (response.status == true) {
      setState(() {
        bookingData = response.data;
        exData = response.data;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });
    // id =   response.user[universityList.indexOf(name)].id
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBooking();
    getNotificationCount();
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('receptionist_token');
    print("Token $authToken");
    var response =
        await Providers().getClientSubPanelNotificationCount(authToken);

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
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
                      ? ReceptionistDashboard()
                      : PreReceptionistDashboard()));
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
            child: ReceptionSidebar(),
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

                              // SizedBox(
                              //   width: 580,
                              // ),
                              // Container(
                              //   margin: EdgeInsets.only(right: 30),
                              //   // color: Colors.amber,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //       Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 const ReceptionistNotificationScreen()),
                              //       );
                              //     },
                              //     child: Stack(
                              //       children: [
                              //         Container(
                              //           margin: EdgeInsets.only(
                              //               left: 10, top: 5, bottom: 5),
                              //           child: Icon(
                              //             Icons.notifications,
                              //             size: 38,
                              //           ),
                              //         ),
                              //         count != null
                              //             ? Positioned(
                              //                 top: 10,
                              //                 left: 25,
                              //                 right: 0,
                              //                 child: Icon(Icons.fiber_manual_record,
                              //                     color: Colors.red, size: 12),
                              //               )
                              //             : Container()
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        if (Responsive.isDesktop(context))
                          bookingData.length == 0
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
                          bookingData.length == 0
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
                                  children: [MobileVieworderTemplate()],
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
                    // Container(
                    //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    //   child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text("All Orders",
                    //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // ),
                    // // Container(
                    // //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    // //   child: Align(
                    // //       alignment: Alignment.topLeft,
                    // //       child: Text("Select Status",
                    // //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // // ),
                    // // Container(
                    // //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    // //   child: Align(
                    // //       alignment: Alignment.topLeft,
                    // //       child: Text("Draft (0)",
                    // //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // // ),
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

                    InkWell(
                      onTap: () {
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Title",
                            "Type",
                            "Shipment Company",
                            "From",
                            "To",
                            "Status"
                          ]
                        ];
                        for (int i = 0; i < exData.length; i++) {
                          if (exData[i].status == "received by receptionist") {
                            List row = [];
                            row.add(exData[i].id);
                            // row.add(exData[i].bookingDate);
                            row.add(exData[i].title);
                            row.add(exData[i].bookingType);
                            row.add(exData[i].shipmentCompany);
                            row.add(exData[i].from);
                            row.add(exData[i].to);
                            row.add(exData[i].status);
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
                        // var dataUrl = AnchorElement(
                        //     href: "data:text/plain;charset=utf-8,$csv")
                        //   ..setAttribute("download", fileName + ".csv")
                        //   ..click();
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
                              Container(
                                height: 25,
                                width: 25,
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Image.asset(
                                  'assets/images/Calendar.png',
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
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                // Container(
                //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                //   child: Align(
                //       alignment: Alignment.topLeft,
                //       child: Text("All Orders",
                //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                // ),
                // // Container(
                // //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                // //   child: Align(
                // //       alignment: Alignment.topLeft,
                // //       child: Text("Select Status",
                // //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                // // ),
                // // Container(
                // //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                // //   child: Align(
                // //       alignment: Alignment.topLeft,
                // //       child: Text("Draft (0)",
                // //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                // // ),
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

                InkWell(
                  onTap: () {
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Title",
                        "Type",
                        "Shipment Company",
                        "From",
                        "To",
                        "Status"
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      if (exData[i].status == "received by receptionist") {
                        List row = [];
                        row.add(exData[i].id);
                        // row.add(exData[i].bookingDate);
                        row.add(exData[i].title);
                        row.add(exData[i].bookingType);
                        row.add(exData[i].shipmentCompany);
                        row.add(exData[i].from);
                        row.add(exData[i].to);
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
                    print("csv-=-= $csv");
                    // var dataUrl = AnchorElement(
                    //     href: "data:text/plain;charset=utf-8,$csv")
                    //   ..setAttribute("download", fileName + ".csv")
                    //   ..click();
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      // height: 100,
                      width: MediaQuery.of(context).size.width * (35 / 100),
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
                          Container(
                            height: 25,
                            width: 25,
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Image.asset(
                              'assets/images/Calendar.png',
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
      width: MediaQuery.of(context).size.width * (76 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
        // color: Colors.red
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     margin: EdgeInsets.only(left: 50),
          //     child: Text(
          //       "Boat/ Plane / Roads",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // // Spacer(),
          // Container(
          //     margin: EdgeInsets.only(left: 50),
          //     child: Text(
          //       "From",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          // Container(
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //   "To",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "scheduletitle".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: ListView.builder(
          itemCount: bookingData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return bookingData[index].status == "received by receptionist"
                ? Container(
                    height: 98,
                    width: MediaQuery.of(context).size.width * (75 / 100),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),

                    // Container(
                    //   // height: (!Responsive.isDesktop(context))
                    //   //     ? MediaQuery.of(context).size.height * (10 / 100)
                    //   //     : MediaQuery.of(context).size.height * (45 / 100),
                    //   // height: 80,

                    //   // width: MediaQuery.of(context).size.width * (70 / 100),
                    //   // // width: MediaQuery.of(context).size.width * (10 / 100),
                    //   // margin: EdgeInsets.all(15),
                    //   height: 80,
                    //   width: MediaQuery.of(context).size.width * (75 / 100),
                    //   margin: EdgeInsets.all(15),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   color: Color(0xffFFFFFF),
                    // ),

                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (20 / 100),
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                bookingData[index].id.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          // Spacer(),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (20 / 100),

                              // margin: EdgeInsets.only(left: 20),
                              child: Text(
                                (DateFormat('yyy-MM-dd').format(DateTime.parse(
                                    bookingData[index]
                                        .bookingDate
                                        .toString()))),
                                style: TextStyle(fontWeight: FontWeight.normal),
                              )),

                          Container(
                            width:
                                MediaQuery.of(context).size.width * (20 / 100),
                            child: InkWell(
                              onTap: () {
                                log(bookingData[index].shipmentCompany);
                                log(bookingData[index].id.toString());
                                log(bookingData[index].to.toString());
                                log(bookingData[index].from.toString());

                                log(bookingData[index].bookingType);

                                showDialog(
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: AlertDialog(
                                          backgroundColor: Colors.white,
                                          content: ContainerListDialog(
                                              dialogid: bookingData[index].id,
                                              dailogbookingtype:
                                                  bookingData[index]
                                                      .bookingType,
                                              dailogfrom:
                                                  bookingData[index].from,
                                              dialogto: bookingData[index].to,
                                              dailogshipmentCompany:
                                                  bookingData[index]
                                                      .shipmentCompany),
                                        ),
                                      );
                                    });
                              },
                              child: Text(
                                bookingData[index].title.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xff1A494F)),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                // onTap: () {
                                //   print(">>>>>>>>" +
                                //       bookingData[index].item.length.toString());
                                //   //return;
                                //   var data1 = {
                                //     "id": bookingData[index].id,
                                //     for (int i = 0;
                                //         i < bookingData[index].item.length;
                                //         i++)
                                //       'itemimage1':
                                //           bookingData[index].item[i].itemImage,
                                //     for (int i = 0;
                                //         i < bookingData[index].item.length;
                                //         i++)
                                //       'itemdetail': bookingData[index].item,
                                //     //  'itemdetail': bookingData[index].item[0].description

                                //     // 'itemimage': bookingData[index]
                                //     //     .bookings[0]
                                //     //     .booking[0]
                                //     //     .itemImage,
                                //     'transactionid':
                                //         bookingData[index].transactionId.toString(),
                                //     'totalamount':
                                //         bookingData[index].totalAmount.toString(),
                                //     'pickuptype': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupType
                                //         .toString(),
                                //     'pickuplocation': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupLocation
                                //         .toString(),
                                //     'pickupdate': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupDate
                                //         .toString(),
                                //     'pickuptime': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupTime
                                //         .toString(),
                                //     'pickupdistance': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupDistance
                                //         .toString(),
                                //     'pickupestimate': bookingData[index]
                                //         .pickupReview[0]
                                //         .pickupEstimate
                                //         .toString(),
                                //     'name':
                                //         bookingData[index].arrival[0].name.toString(),
                                //     'email': bookingData[index]
                                //         .arrival[0]
                                //         .email
                                //         .toString(),
                                //     'phone': bookingData[index]
                                //         .arrival[0]
                                //         .phone
                                //         .toString(),
                                //     'address': bookingData[index]
                                //         .arrival[0]
                                //         .address
                                //         .toString(),
                                //     // 'id': arrd[index].id.toString(),
                                //     'title': bookingData[index].title.toString(),
                                //     'bookingdate':
                                //         bookingData[index].bookingDate.toString(),
                                //     'arrivaldate':
                                //         bookingData[index].arrivalDate.toString(),
                                //     'type': bookingData[index].bookingType.toString(),
                                //     'shipcmpany':
                                //         bookingData[index].shipmentCompany.toString()
                                //   };
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               ReceptionistDetail(data1
                                //                   //  Id: id.toString(),
                                //                   )));
                                // },
                                // //   child: Container(
                                //       margin: EdgeInsets.only(right: 5),
                                //       height: MediaQuery.of(context).size.height *
                                //           (4.59 / 100),
                                //       width: w * 0.13,
                                //       decoration: BoxDecoration(
                                //           color: Colors.amber,
                                //           borderRadius: BorderRadius.all(
                                //               Radius.circular(20))),
                                //       // width:
                                //       child: Center(
                                //         child: Text(
                                //           "View Details",
                                //           style: TextStyle(
                                //               fontSize: 12, color: Colors.white),
                                //         ),
                                //       )),
                                // ),
                                // SizedBox(
                                //   height: 7,
                                // ),
                                // InkWell(
                                onTap: () {
                                  var id = bookingData[index].id.toString();
                                  var type =
                                      bookingData[index].bookingType.toString();
                                  var bookingdate =
                                      bookingData[index].bookingDate.toString();
                                  var status = bookingData[index].status;
                                  var itemimage = bookingData[index]
                                      .pickupItemimage
                                      .toString();
                                  var comment = bookingData[index]
                                      .pickupComment
                                      .toString();
                                  var itemimage1 = bookingData[index]
                                      .pickupItemimage1
                                      .toString();
                                  var comment1 = bookingData[index]
                                      .pickupComment1
                                      .toString();
                                  var depatureimage = bookingData[index]
                                      .departureImage
                                      .toString();
                                  var depaturecomment = bookingData[index]
                                      .departureComment
                                      .toString();
                                  var arrivalimage = bookingData[index]
                                      .arrivalImage
                                      .toString();
                                  var arrivalcomment = bookingData[index]
                                      .arrivalComment
                                      .toString();
                                  var receptionistimage = bookingData[index]
                                      .receptionistImage
                                      .toString();
                                  var receptionistcomment = bookingData[index]
                                      .receptionistComment
                                      .toString();
                                  var schedulStatus =
                                      bookingData[index].status.toString();
                                  bookingData[index]
                                              .pickupReview[0]
                                              .pickupType ==
                                          "Pick up"
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialogBoxReceptionist(
                                                  id,
                                                  type,
                                                  bookingdate,
                                                  status,
                                                  bookingData[index]
                                                      .pickupReview[0]
                                                      .pickupType
                                                      .toString(),
                                                  '',
                                                  itemimage,
                                                  comment,
                                                  itemimage1,
                                                  comment1,
                                                  depatureimage,
                                                  depaturecomment,
                                                  arrivalimage,
                                                  arrivalcomment,
                                                  receptionistimage,
                                                  receptionistcomment))
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CustomDialogBoxDropOff(
                                                  id,
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
                                                  arrivalimage,
                                                  arrivalcomment,
                                                  receptionistimage,
                                                  receptionistcomment));
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.only(right: 5, bottom: 2),
                                    height: MediaQuery.of(context).size.height *
                                        (4.59 / 100),
                                    width: w * 0.13,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    // width:
                                    child: Center(
                                      child: Text(
                                        bookingData[index].status,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                          )
                        ]),
                  )
                : Container();
          }),
    );
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: bookingData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return bookingData[index].status == "received by receptionist"
              ? Container(
                  // height: (!Responsive.isDesktop(context))
                  //     ? MediaQuery.of(context).size.height * (10 / 100)
                  //     : MediaQuery.of(context).size.height * (45 / 100),
                  height: MediaQuery.of(context).size.height * (27 / 100),
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
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 15),
                              child: Text(
                                "orderid".tr(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
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
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                bookingData[index].id.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          InkWell(
                            onTap: () {
                              var id = bookingData[index].id.toString();
                              var type =
                                  bookingData[index].bookingType.toString();
                              var bookingdate =
                                  bookingData[index].bookingDate.toString();
                              var status = bookingData[index].status;
                              var itemimage =
                                  bookingData[index].pickupItemimage.toString();
                              var comment =
                                  bookingData[index].pickupComment.toString();
                              var itemimage1 = bookingData[index]
                                  .pickupItemimage1
                                  .toString();
                              var comment1 =
                                  bookingData[index].pickupComment1.toString();
                              var depatureimage =
                                  bookingData[index].departureImage.toString();
                              var depaturecomment = bookingData[index]
                                  .departureComment
                                  .toString();
                              var arrivalimage =
                                  bookingData[index].arrivalImage.toString();
                              var arrivalcomment =
                                  bookingData[index].arrivalComment.toString();
                              var receptionistimage = bookingData[index]
                                  .receptionistImage
                                  .toString();
                              var receptionistcomment = bookingData[index]
                                  .receptionistComment
                                  .toString();
                              var schedulStatus =
                                  bookingData[index].status.toString();
                              bookingData[index].pickupReview[0].pickupType ==
                                      "Pick up"
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialogBoxReceptionist(
                                              id,
                                              type,
                                              bookingdate,
                                              status,
                                              bookingData[index]
                                                  .pickupReview[0]
                                                  .pickupType
                                                  .toString(),
                                              '',
                                              itemimage,
                                              comment,
                                              itemimage1,
                                              comment1,
                                              depatureimage,
                                              depaturecomment,
                                              arrivalimage,
                                              arrivalcomment,
                                              receptionistimage,
                                              receptionistcomment))
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CustomDialogBoxDropOff(
                                              id,
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
                                              arrivalimage,
                                              arrivalcomment,
                                              receptionistimage,
                                              receptionistcomment));
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(top: 10, right: 20),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(bookingData[index].status,
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
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                "bookingdate".tr(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(top: 10, right: 20),
                              child: Text("scheduletitle".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                (DateFormat('yyy-MM-dd').format(DateTime.parse(
                                    bookingData[index]
                                        .bookingDate
                                        .toString()))),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          InkWell(
                            onTap: () {
                              log(bookingData[index].shipmentCompany);
                              log(bookingData[index].id.toString());
                              log(bookingData[index].to.toString());
                              log(bookingData[index].from.toString());

                              log(bookingData[index].bookingType);

                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: AlertDialog(
                                        backgroundColor: Colors.white,
                                        content: ContainerListDialog(
                                            dialogid: bookingData[index].id,
                                            dailogbookingtype:
                                                bookingData[index].bookingType,
                                            dailogfrom: bookingData[index].from,
                                            dialogto: bookingData[index].to,
                                            dailogshipmentCompany:
                                                bookingData[index]
                                                    .shipmentCompany),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(top: 10, right: 20),
                                child: Text(bookingData[index].title.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }

  Widget ContainerListDialog(
      {String? dailogbookingtype,
      int? dialogid,
      String? dailogfrom,
      String? dialogto,
      String? dailogshipmentCompany}) {
    print("object $dailogbookingtype");
    return Container(
      height: h * 0.45,
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
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    "bookingid".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    dialogid.toString(),
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
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    "companyname".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    dailogshipmentCompany.toString(),
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
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    // bookingtype.toString(),
                    "bookingtype".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    // viewbooking![index].bookingType,
                    dailogbookingtype.toString(),
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
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text(
                    "from".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.10 : w * 0.3,
                  child: Text(dailogfrom.toString(), style: headingStyle16MB()),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.3,
                  child: Text("to".tr(), style: headingStyle16MB()),
                ),
                Container(
                  width: (Responsive.isDesktop(context)) ? w * 0.10 : w * 0.3,
                  child: Text(dialogto.toString(), style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//======dialog
class CustomDialogBoxReceptionist1 extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status, pickupType;
  CustomDialogBoxReceptionist1(
      this.id, this.type, this.bookingdate, this.status, this.pickupType);
  @override
  _CustomDialogBoxReceptionist createState() => _CustomDialogBoxReceptionist();
}

class _CustomDialogBoxReceptionist extends State<CustomDialogBoxReceptionist1> {
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
      "booking_status": "received by receptionist",
    };

    print(depatureData);
    //return;

    var response = await Providers().changeReceptionistStatus(depatureData);
    if (response.status == true) {
      setState(() {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => profileConfirm(),
            ));
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
      height: 900,
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
            height: (Responsive.isDesktop(context)) ? 100 : 150,
            margin: (Responsive.isDesktop(context))
                ? EdgeInsets.all(15)
                : EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffE5E5E5),
              // color: Colors.amber
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 40, top: 20),
                        width: (Responsive.isDesktop(context))
                            ? 100
                            : MediaQuery.of(context).size.width * 0.2,
                        child: Text(
                          "shippedvis".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: (Responsive.isDesktop(context))
                            ? 150
                            : MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "status".tr(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: (Responsive.isDesktop(context))
                            ? 100
                            : MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.only(right: 10, top: 20),
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
                        width: (Responsive.isDesktop(context))
                            ? 100
                            : MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.only(left: 40, top: 10),
                        child: Text(
                          widget.type,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 110,
                    // ),
                    Container(
                        width: (Responsive.isDesktop(context))
                            ? 150
                            : MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.status,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: (Responsive.isDesktop(context))
                            ? 100
                            : MediaQuery.of(context).size.width * 0.2,
                        margin: EdgeInsets.only(right: 10, top: 10),
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: (Responsive.isDesktop(context))
                ? Row(
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
                                  widget.status == "Confirmed"
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/defaulticon.png',
                                      fit: BoxFit.fill),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/Group 742.png',
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
                      widget.pickupType == "Pick up"
                          ? Column(
                              children: [
                                widget.status == "Accepted" ||
                                        widget.status == "Confirmed" ||
                                        widget.status == "assigned to agent" ||
                                        widget.status == "going to pickup" ||
                                        widget.status == "pickup done" ||
                                        widget.status ==
                                            "pickup item received" ||
                                        widget.status ==
                                            "delivered to Warehouse"
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                              ],
                            )
                          : SizedBox(),
                      widget.pickupType == "Pick up"
                          ? Expanded(
                              child: Container(
                                  // margin: EdgeInsets.only(right: 10),
                                  // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Divider(
                                color: Color(0xff4CAF50),
                                height: 36,
                              )),
                            )
                          : SizedBox(),
                      widget.pickupType == "Pick up"
                          ? Column(
                              children: [
                                widget.status == "Accepted" ||
                                        widget.status == "Confirmed" ||
                                        widget.status == "assigned to agent" ||
                                        widget.status == "going to pickup" ||
                                        widget.status == "pickup done" ||
                                        widget.status ==
                                            "delivered to Warehouse" ||
                                        widget.status == "pickup item received"
                                    ? Container(
                                        height: 50,
                                        width: 50,

                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                              ],
                            )
                          : SizedBox(),
                      widget.pickupType == "Pick up"
                          ? Expanded(
                              child: Container(
                                  // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Divider(
                                color: Color(0xff4CAF50),
                                height: 36,
                              )),
                            )
                          : SizedBox(),
                      widget.pickupType == "Pick up"
                          ? Column(
                              children: [
                                widget.status == "Accepted" ||
                                        widget.status == "Confirmed" ||
                                        widget.status == "assigned to agent" ||
                                        widget.status == "going to pickup" ||
                                        widget.status == "pickup done" ||
                                        widget.status ==
                                            "delivered to Warehouse" ||
                                        widget.status == "pickup item received"
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                              ],
                            )
                          : SizedBox(),
                      widget.pickupType == "Pick up"
                          ? Expanded(
                              child: Container(
                                  // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Divider(
                                color: Color(0xff4CAF50),
                                height: 36,
                              )),
                            )
                          : SizedBox(),
                      Column(
                        children: [
                          widget.status == "Accepted" ||
                                  widget.status == "Confirmed" ||
                                  widget.status == "assigned to agent" ||
                                  widget.status == "going to pickup" ||
                                  widget.status == "pickup done" ||
                                  widget.status == "delivered to Warehouse" ||
                                  widget.status == "pickup item received"
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/defaulticon.png',
                                      fit: BoxFit.fill),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/Group 742.png',
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
                                  widget.status == "Confirmed" ||
                                  widget.status == "assigned to agent" ||
                                  widget.status == "going to pickup" ||
                                  widget.status == "pickup done" ||
                                  widget.status == "delivered to Warehouse" ||
                                  widget.status == "pickup item received"
                              ? Container(
                                  height: 50,
                                  width: 50,
                                  // margin: EdgeInsets.only(right: 20),
                                  // margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/defaulticon.png',
                                      fit: BoxFit.fill),
                                )
                              : Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(right: 20),
                                  child: Image.asset(
                                      'assets/images/Group 743.png',
                                      fit: BoxFit.fill),
                                ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
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
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/Group 742.png',
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
                        widget.pickupType == "Pick up"
                            ? Column(
                                children: [
                                  widget.status == "Accepted" ||
                                          widget.status == "Confirmed" ||
                                          widget.status ==
                                              "assigned to agent" ||
                                          widget.status == "going to pickup" ||
                                          widget.status == "pickup done" ||
                                          widget.status ==
                                              "pickup item received" ||
                                          widget.status ==
                                              "delivered to Warehouse"
                                      ? Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/Group 742.png',
                                              fit: BoxFit.fill),
                                        ),
                                ],
                              )
                            : SizedBox(),
                        widget.pickupType == "Pick up"
                            ? Expanded(
                                child: Container(
                                    // margin: EdgeInsets.only(right: 10),
                                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                    child: Divider(
                                  color: Color(0xff4CAF50),
                                  height: 36,
                                )),
                              )
                            : SizedBox(),
                        widget.pickupType == "Pick up"
                            ? Column(
                                children: [
                                  widget.status == "Accepted" ||
                                          widget.status == "Confirmed" ||
                                          widget.status ==
                                              "assigned to agent" ||
                                          widget.status == "going to pickup" ||
                                          widget.status == "pickup done" ||
                                          widget.status ==
                                              "delivered to Warehouse" ||
                                          widget.status ==
                                              "pickup item received"
                                      ? Container(
                                          height: 50,
                                          width: 50,

                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/Group 742.png',
                                              fit: BoxFit.fill),
                                        ),
                                ],
                              )
                            : SizedBox(),
                        widget.pickupType == "Pick up"
                            ? Expanded(
                                child: Container(
                                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                    child: Divider(
                                  color: Color(0xff4CAF50),
                                  height: 36,
                                )),
                              )
                            : SizedBox(),
                        widget.pickupType == "Pick up"
                            ? Column(
                                children: [
                                  widget.status == "Accepted" ||
                                          widget.status == "Confirmed" ||
                                          widget.status ==
                                              "assigned to agent" ||
                                          widget.status == "going to pickup" ||
                                          widget.status == "pickup done" ||
                                          widget.status ==
                                              "delivered to Warehouse" ||
                                          widget.status ==
                                              "pickup item received"
                                      ? Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        )
                                      : Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/Group 742.png',
                                              fit: BoxFit.fill),
                                        ),
                                ],
                              )
                            : SizedBox(),
                        widget.pickupType == "Pick up"
                            ? Expanded(
                                child: Container(
                                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                    child: Divider(
                                  color: Color(0xff4CAF50),
                                  height: 36,
                                )),
                              )
                            : SizedBox(),
                        Column(
                          children: [
                            widget.status == "Accepted" ||
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/Group 742.png',
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 20),
                                    child: Image.asset(
                                        'assets/images/Group 743.png',
                                        fit: BoxFit.fill),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: (Responsive.isDesktop(context))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "Accepted",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Assign to Agent",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Going to Pickup",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Pickup Done",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 30),
                          child: Text(
                            "Delivered to Depature Warehouse",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 5),
                          child: Text(
                            "Recevied & Proceed for Shipment",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 5),
                          child: Text(
                            "Delivered to Receptionist",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                : Container(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "accepted".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              "assigntoagent".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              "goingtopickup".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              "pickupdone".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width: 100,
                            // margin: EdgeInsets.only(right: 30),
                            child: Text(
                              "deliveredtodepaturewarehouse".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width: 100,
                            // margin: EdgeInsets.only(right: 5),
                            child: Text(
                              "receviedproceedforshipment".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: 90.0,
              height: 90.0,
              margin: const EdgeInsets.only(top: 10),
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
                      print(widget.status);
                      if (widget.status == "Delivered to Receptionist") {
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
                                              ? Colors.grey
                                              : widget.status ==
                                                      "Delivered to Receptionist"
                                                  ? Color(0xff4CAF50)
                                                  : Colors.grey),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                          child: widget.status == "Accepted"
                              ? Text("Assign To Agent",
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
                                              : widget.status ==
                                                      "Delivered to Receptionist"
                                                  ? Text("updatestatus".tr(),
                                                      style: TextStyle(
                                                          color: Colors.black))
                                                  : Text("updatestatus".tr(),
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
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
