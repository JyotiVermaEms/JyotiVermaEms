import 'package:flutter/material.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentBookingMode.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import '../../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<Orders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  List<PickupBookingData> pbData = [];

  getBookings() async {
    var response = await Providers().getpickupBookings();
    setState(() {
      pbData = response.data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookings();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: PickupSideBar(),
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
                          'Booking',
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
                      orderTemplate(),
                      orderDetails2(),
                      // orderDetails3(),
                      // orderDetails2(),
                    ],
                  ),

                if (!Responsive.isDesktop(context))
                  Column(
                    children: [
                      MobileVieworderTemplate(),
                      MobileVieworderTemplate(),
                      MobileVieworderTemplate(),
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
                      child: Text("All Orders",
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

                Container(
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

                // Spacer(),
                Container(
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
                            "Print",
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
        children: [
          Container(
              width: w * 0.15,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Order ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.15,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Order Receive Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.15,
              child: Text(
                "Schedule Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     margin: EdgeInsets.only(left: 50),
          //     child: Text(
          //       "From",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //       "To",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //       "Shipment Comapny",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          Container(
              width: w * 0.15,
              child: Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.15,
              child: Text(
                "Pickup Review",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails2() {
    return ListView.builder(
        itemCount: pbData.length,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 80,
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
                      pbData[index].id.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                // Spacer(),
                Container(
                    width: w * 0.15,

                    // margin: EdgeInsets.only(left: 20),
                    child: Text(
                      pbData[index].bookingDate.substring(0, 10),
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
                        pbData[index].title.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
                // Spacer(),
                // Container(
                //     width: w * 0.10,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       "USA",
                //       style: TextStyle(fontWeight: FontWeight.bold),
                //     )),
                // // Spacer(),
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
                GestureDetector(
                  onTap: () {
                    var id;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialogBox());
                  },
                  child: Container(
                      // margin: EdgeInsets.only(top: 25),
                      // height: 100,
                      width: w * 0.15,
                      child: Text(
                        pbData[index].status.toString(),
                        style:
                            TextStyle(fontSize: 15, color: Color(0xffC2CFE0)),
                      )),
                ),
                // Spacer(),
                GestureDetector(
                  onTap: () {
                    var id;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialogBox());
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
          // Spacer(),
          // Container(
          //     width: w * 0.10,

          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //       "USA",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // // Spacer(),
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
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox());
            },
            child: Container(
                width: w * 0.15,
                child: Text(
                  "Waiting pickup",
                  style: TextStyle(fontSize: 15, color: Colors.red),
                )),
          ),
          // Spacer(),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox());
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
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Waiting Pickup",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red))),
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
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Pickup Review",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(left: 20, top: 10, right: 15),
                        padding: EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xff4CAF50),
                        ),
                        child: Center(
                          child: Text("pickup.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )),
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
                        //         CustomDialogBox());
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
                    "Company Name",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    "APM Merck",
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
