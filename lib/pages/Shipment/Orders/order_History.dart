// import 'dart:html';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:shipment/Model/Shipment/ShipmentOrderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';

import 'package:shipment/Model/Shipment/shipmentdonebookingModel.dart';
import 'package:shipment/Provider/Provider.dart';

import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';

import '../../../constants.dart';
// import 'package:universal_html/html.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  List<ShipmentOrder>? shipmentOrder;
  int? _radioValue = 0;
  bool isprocess = false;
  int? Id;
  List<BookingResponse>? bookingResponse;
  TextEditingController datefilter = new TextEditingController();
  DateTime initialDate = DateTime.now();
  var exData = [];
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;
      });
    builder:
    (context, child) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 100,
              width: 100,
              child: child,
            ),
          ),
        ],
      );
    };
  }

  getShipmentList() async {
    setState(() {
      isprocess = true;
    });
    var response = await Providers().shipmentActiveOrder();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('client_Id', Id.toString());

    setState(() {
      shipmentOrder = response.data;
      exData = response.data;
    });

    setState(() {
      isprocess = false;
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
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: ShipmentSidebar(),
        ),
        body: isprocess == true
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
                              child: Row(
                                children: [
                                  Text(
                                    'Order History',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Spacer(),
                                  // if (Responsive.isDesktop(context)) topBar()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        shipmentOrder!.isEmpty
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
                                  // booking(),
                                  orderTemplate(),
                                  orderDetails(),
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
              ));
  }

  Widget booking() {
    return Container(
        // height: (!Responsive.isDesktop(context))
        //     ? MediaQuery.of(context).size.height * (60 / 100)
        //     : MediaQuery.of(context).size.height * (45 / 100),
        height: 80,
        width: (Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (80 / 100)
            : MediaQuery.of(context).size.width,
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
                      child: Text("All Orders",
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                ),

                Spacer(),

                InkWell(
                  onTap: () {
                    print("export");
                    List<List> rows = <List>[
                      ["Order ID", "Title", "Type", "To", "From", "Status"]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      if (exData[i].status == "received by receptionist") {
                        print("-=-=-=-=-=-=-${exData[i].status}");
                        List row = [];
                        row.add(exData[i].id);
                        // row.add(exData[i].bookingDate);
                        row.add(exData[i].title);
                        row.add(exData[i].bookingType);
                        row.add(exData[i].to);
                        row.add(exData[i].from);
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
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      // height: 100,
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (10 / 100)
                          : 100,
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
                              "Export",
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
    return shipmentOrder!.length == 0
        ? Container(
            height: 200,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
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
        : Container(
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
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * (20 / 100),
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (20 / 100),

                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      "Booking Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),

                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (24 / 100),
                    child: Text(
                      "Schedule Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: shipmentOrder!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return shipmentOrder![index].status == "received by receptionist"
              ? Container(
                  // height: (!Responsive.isDesktop(context))
                  //     ? MediaQuery.of(context).size.height * (10 / 100)
                  //     : MediaQuery.of(context).size.height * (45 / 100),
                  height: 80,
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),

                  child: Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (18 / 100),
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            shipmentOrder![index].id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: MediaQuery.of(context).size.width * (22 / 100),

                          // margin: EdgeInsets.only(left: 20),
                          child: Text(
                            shipmentOrder![index].bookingDate.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),

                      Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),

                        // margin: EdgeInsets.only(left: 20),
                        child:
                            // Row(
                            //   children: [
                            InkWell(
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
                                          stitle: shipmentOrder![index].title,
                                          sid: shipmentOrder![index].id,
                                          stype:
                                              shipmentOrder![index].bookingType,
                                          sto: shipmentOrder![index].to,
                                          sfrom: shipmentOrder![index].from,
                                          bookingitem:
                                              shipmentOrder![index].bookingItem,
                                          h: h,
                                          w: w),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            shipmentOrder![index].title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A494F)),
                          ),
                        ),
                      ),
                      // Spacer(),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green),
                          height: 40,
                          width: MediaQuery.of(context).size.width * (14 / 100),
                          margin: EdgeInsets.only(right: 20),
                          child: Center(
                            child: Text(
                              shipmentOrder![index].status.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ],
                  ),
                )
              : Container();
        });
  }

  Widget ContainerListDialog1(
      {sid, stype, sto, sfrom, stitle, h, w, bookingitem}) {
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            // child: Row(
            //   children: [
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         "Title",
            //         style: headingStyle16MB(),
            //       ),
            //     ),
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         stitle,
            //         style: headingStyle16MB(),
            //       ),
            //     )
            //   ],
            // ),
          ),
          Row(
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
                    "From",
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
                  child: Text("To", style: headingStyle16MB()),
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

  Widget ContainerListDialog(
      {sid, stype, sto, sfrom, stitle, h, w, bookingitem}) {
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            // child: Row(
            //   children: [
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         "Title",
            //         style: headingStyle16MB(),
            //       ),
            //     ),
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         stitle,
            //         style: headingStyle16MB(),
            //       ),
            //     )
            //   ],
            // ),
          ),
          Row(
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
                    "From",
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
                  child: Text("To", style: headingStyle16MB()),
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

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: shipmentOrder!.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * (30 / 100),
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
                          shipmentOrder![index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green),
                        height: 40,
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.only(left: 10),
                        child: Center(
                          child: Text(
                            shipmentOrder![index].status.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
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
                  ],
                ),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          shipmentOrder![index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      "Schedule Title",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    )),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 7),

                  // margin: EdgeInsets.only(left: 20),
                  child:
                      // Row(
                      //   children: [
                      InkWell(
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
                                content: ContainerListDialog(
                                    stitle: shipmentOrder![index].title,
                                    sid: shipmentOrder![index].id,
                                    stype: shipmentOrder![index].bookingType,
                                    sto: shipmentOrder![index].to,
                                    sfrom: shipmentOrder![index].from,
                                    bookingitem:
                                        shipmentOrder![index].bookingItem,
                                    h: h,
                                    w: w),
                              ),
                            );
                          });
                    },
                    child: Text(
                      shipmentOrder![index].title.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A494F)),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
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
                  hintText: "Search Here",
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
