import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentDashboardModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/alertdialog.dart';
import 'package:universal_html/html.dart';
import '../../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../Dashboard/PickupDashboard.dart';

//new change
class PickupAgentOrderHistory extends StatefulWidget {
  const PickupAgentOrderHistory({Key? key}) : super(key: key);

  @override
  _PickupAgentOrderHistoryState createState() =>
      _PickupAgentOrderHistoryState();
}

class _PickupAgentOrderHistoryState extends State<PickupAgentOrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  String dropdownvalue = 'Picked';
  var exData = [];
  bool isProcess = false;

  String? category;
  List<PickupDashData> pickupData = [];
  // var id = [];

  var amount;
  var items = ['Picked', 'Departed', 'Shipped', 'Waiting'];
  var item = [
    'Select Status',
    'Picker',
    'Departed',
  ];
  final TextEditingController _controllr = new TextEditingController();

  getPickupList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getpickupAgentDashboard();

    if (response.status == true) {
      setState(() {
        pickupData = response.data;
        exData = response.data;
      });
      for (int i = 0; i < pickupData.length; i++) {
        // id.add(pickupData[i].id.toString());

        // for (int j = i; j < pickupData[i].pickupReview.length; j++) {
        //   item.add(pickupData[i].pickupReview[j].pickupLocation);
        // }
      }
    }
    print("dhhjdhhdfhhfd" + item.toString());
    setState(() {
      isProcess = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPickupList();
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
                          pickupData.isEmpty
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
                                    orderDetails2(),
                                    // orderDetails2(),
                                    // orderDetails2(),
                                  ],
                                ),

                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              // booking(),
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
                            "From",
                            "To",
                            "ShipmentCompany",
                            "Status"
                          ]
                        ];
                        for (int i = 0; i < exData.length; i++) {
                          if (exData[i].status == "received by receptionist") {
                            List row = [];
                            row.add(exData[i].id);
                            // row.add(exData[i].bookingDate);
                            // row.add(exData[i].booking);
                            row.add(exData[i].bookingDate);
                            row.add(exData[i].from);
                            row.add(exData[i].to);
                            row.add(exData[i].title);
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
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();

                        //File? file; // generated somewhere
                        //final rawData = file?.readAsBytesSync();
                        // final content = "images/Background.png";
                        // final anchor = AnchorElement(
                        //     href:
                        //         "data:application/octet-stream;charset=utf-16le;base64,$content")
                        //   ..setAttribute("download", "file.txt")
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
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    //   child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text("All Orders",
                    //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    //   child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text("Select Status",
                    //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // ),
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
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         Container(
                    //           margin: EdgeInsets.only(
                    //             left: 10,
                    //           ),
                    //           child: Text(
                    //             "Export",
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
                    //     ))
                  ],
                ),
              ],
            ))
        : Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (60 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 60,
            width: MediaQuery.of(context).size.width * (80 / 100),

            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
            //   color: Color(0xffFFFFFF),
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("allorder".tr(),
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                ),

                GestureDetector(
                  onTap: () {
                    print("export");
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Booking Date",
                        "From",
                        "To",
                        "ShipmentCompany",
                        "Status"
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      if (exData[i].status == "received by receptionist") {
                        List row = [];
                        row.add(exData[i].id);
                        // row.add(exData[i].bookingDate);
                        // row.add(exData[i].booking);
                        row.add(exData[i].bookingDate);
                        row.add(exData[i].from);
                        row.add(exData[i].to);
                        row.add(exData[i].title);
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
                    //print("csv-=-= $csv");
                    // var dataUrl = AnchorElement(
                    //     href: "data:text/plain;charset=utf-8,$csv")
                    //   ..setAttribute("download", fileName + ".csv")
                    //   ..click();

                    //File? file; // generated somewhere
                    //final rawData = file?.readAsBytesSync();
                    // final content = "images/Background.png";
                    // final anchor = AnchorElement(
                    //     href:
                    //         "data:application/octet-stream;charset=utf-16le;base64,$content")
                    //   ..setAttribute("download", "file.txt")
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
            ));
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
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
              width: w * 0.08,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.08,
              // margin: EdgeInsets.only(right: 5),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     margin: EdgeInsets.only(left: 50),
          //     child: Text(
          //       "Boat/ Plane / Roads",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          Container(
              width: w * 0.05,
              // margin: EdgeInsets.only(left: 50),
              child: Text(
                "from".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.07,
              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "to".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,
              margin: EdgeInsets.only(right: 30),
              child: Text(
                "shipmentcomapny".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     // margin: EdgeInsets.only(right: 20),
          //     child: Text(
          //       "Status",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
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
        itemCount: pickupData.length,
        reverse: false,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                  width: w * 0.08,
                  child: Text(pickupData[index].id.toString()),
                ),
                Container(
                  width: w * 0.09,
                  child: Text(pickupData[index].bookingDate.toString()),
                ),
                Container(
                  width: w * 0.06,
                  child: Text(pickupData[index].from.toString()),
                ),
                Container(
                  width: w * 0.08,
                  child: Text(pickupData[index].to.toString()),
                ),
                Container(
                  width: w * 0.08,
                  child: Text(pickupData[index].shipmentCompany.toString()),
                ),
                // Container(
                //     width: w * 0.10,
                //     margin: EdgeInsets.only(left: 15),
                //     child: Text(
                //       "12345",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // Spacer(),
                // Container(
                //     width: w * 0.10,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "21.08.2021",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // Spacer(),
                // Container(
                //     width: w * 0.10,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "Boat",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // Spacer(),
                // Container(
                //     width: w * 0.10,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "USA",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // Spacer(),
                // Container(
                //     width: w * 0.10,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "India",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // // Spacer(),
                // Container(
                //     width: w * 0.06,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "CMA CGM",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),

                // Spacer(),
                // Container(
                //   // width: 130,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(5)),
                //       color: Color(0xffE5E5E5)),
                //   child: DropdownButton<String>(
                //     value: dropdownValue,
                //     icon: Icon(Icons.arrow_drop_down),
                //     iconSize: 24,
                //     elevation: 16,
                //     style: TextStyle(color: Colors.black),

                //     // underline: Container(
                //     //   height: 2,
                //     //   color: Colors.redAccent,
                //     // ),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         dropdownValue = newValue!;
                //       });
                //     },
                //     items: <String>['Picked', 'Departed', 'Shipped', 'Waiting']
                //         .map<DropdownMenuItem<String>>((String value) {
                //       return DropdownMenuItem<String>(
                //         value: dropdownValue,
                //         child: Row(children: [
                //           // IconButton(
                //           //   onPressed: () {},
                //           //   icon: Icon(Icons.home),
                //           //   // color: Colors.redAccent,
                //           // ),
                //           Container(
                //               padding: EdgeInsets.only(left: 10, right: 10),
                //               child: Text(dropdownValue)),
                //         ]),
                //       );
                //     }).toList(),
                //   ),
                // ),

                // Container(
                //   width: w * 0.08,
                //   child: DropdownButton<String>(
                //     // Initial Value
                //     value: dropdownvalue,

                //     // Down Arrow Icon
                //     icon: const Icon(Icons.keyboard_arrow_down),

                //     // Array list of items
                //     items: items.map((String items) {
                //       return DropdownMenuItem(
                //         value: items,
                //         child: Text(items),
                //       );
                //     }).toList(),
                //     // After selecting the desired option,it will
                //     // change button value to selected value
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         dropdownvalue = newValue!;
                //       });
                //     },
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    var id = pickupData[index].id.toString();
                    var itemimage =
                        pickupData[index].pickupItemimage.toString();

                    var itemimage1 =
                        pickupData[index].pickupItemimage1.toString();
                    var comment = pickupData[index].pickupComment.toString();
                    var comment1 = pickupData[index].pickupComment1.toString();
                    var type = pickupData[index].bookingType.toString();
                    var bookingdate = pickupData[index].bookingDate.toString();
                    var status = pickupData[index].status.toString();

                    print(id);
                    print(type);
                    print(bookingdate);
                    print(status);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialogBox1(
                              id,
                              type,
                              bookingdate,
                              status,
                              '',
                              itemimage,
                              comment,
                              itemimage1,
                              comment1,
                            ));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: w * 0.14,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        margin: EdgeInsets.only(right: 5),
                        child: Center(
                          child: Text(
                            pickupData[index].status.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),

                    //  Container(
                    //     margin: EdgeInsets.only(right: 5),
                    //     height: MediaQuery.of(context).size.height * (7 / 100),
                    //     // height: 100,
                    //     width: w * 0.10,
                    //     // width: MediaQuery.of(context).size.width * (10 / 100),
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       color: Color(0xff667C8A),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         pickupData[index].status.toString(),
                    //         style: TextStyle(fontSize: 12, color: Colors.white),
                    //       ),
                    //     )),
                  ),
                ),
              ],
            ),
          );
        });
    // : Container(
    //     height: 200,
    //     width: double.infinity,
    //     child: Card(
    //       shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(10))),
    //       elevation: 1,
    //       child: Container(
    //         padding: EdgeInsets.all(12),
    //         decoration: linearGradientForWhiteCard(),
    //         child: Column(
    //           children: [
    //             // Image.asset(
    //             //   'assets/images/applogo.png',
    //             //   height:
    //             //       MediaQuery.of(context).size.height * 0.10,
    //             // ),
    //             SizedBox(height: 15),
    //             Text(
    //               'Sorry, You have not any Bookings yet',
    //               style: headingStyle16MB(),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
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
              width: w * 0.10,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "12345",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "21.08.2021",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "Boat",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "USA",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "India",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.06,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "CMA CGM",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox(id));
            },
            child: Container(
                // margin: EdgeInsets.only(top: 25),
                height: MediaQuery.of(context).size.height * (5 / 100),
                // height: 100,
                width: MediaQuery.of(context).size.width * (10 / 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  // color: Color(0xff0FBAB8),
                ),
                child: Center(
                  child: Text(
                    "Waiting pickup",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                )),
          ),
          // Spacer(),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox(id));
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  // margin: EdgeInsets.only(top: 25, right: 10),
                  height: MediaQuery.of(context).size.height * (5 / 100),
                  // height: 100,
                  width: MediaQuery.of(context).size.width * (10 / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff4CAF50),
                  ),
                  child: Center(
                    child: Text(
                      "Pick up",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: pickupData.length,
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
                          pickupData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {
                        var id = pickupData[index].id.toString();
                        var itemimage =
                            pickupData[index].pickupItemimage.toString();

                        var itemimage1 =
                            pickupData[index].pickupItemimage1.toString();
                        var comment =
                            pickupData[index].pickupComment.toString();
                        var comment1 =
                            pickupData[index].pickupComment1.toString();
                        var type = pickupData[index].bookingType.toString();
                        var bookingdate =
                            pickupData[index].bookingDate.toString();
                        var status = pickupData[index].status.toString();

                        print(id);
                        print(type);
                        print(bookingdate);
                        print(status);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogBox1(
                                  id,
                                  type,
                                  bookingdate,
                                  status,
                                  '',
                                  itemimage,
                                  comment,
                                  itemimage1,
                                  comment1,
                                ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        //padding: EdgeInsets.only(left: 15),
                        child: Text(
                          pickupData[index].status.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
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
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 0, top: 15),
                        child: Text(
                          "shipmentcomapny".tr(),
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
                          pickupData[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 0, top: 10),
                        child: Text(
                          pickupData[index].shipmentCompany.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text("from".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 0, top: 15),
                        child: Text("to".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (35 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(pickupData[index].from.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Text(pickupData[index].to.toString(),
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
            height: MediaQuery.of(context).size.height * (60 / 100),
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
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) =>
                        //         CustomDialogBox(id));
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
}
