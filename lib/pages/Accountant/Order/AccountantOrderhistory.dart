import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/shipmentdonebookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';

import '../../../constants.dart';

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
  int? _radioValue = 0;
  List<BookingResponse>? bookingResponse;
  TextEditingController datefilter = new TextEditingController();
  DateTime initialDate = DateTime.now();
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

  getBookingFunction() async {
    var response = await Providers().getDoneBooking();
    setState(() {
      bookingResponse = response.data;
    });
    print("ghhhhhhh" + bookingResponse.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookingFunction();
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
                            if (Responsive.isDesktop(context)) topBar()
                          ],
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
                      MobileVieworderTemplate2(),
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
                Container(
                    margin: EdgeInsets.only(top: 15, right: 10),
                    height: MediaQuery.of(context).size.height * (5 / 100),
                    // height: 100,
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          "Select Status",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )),
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
    return bookingResponse!.length == 0
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
                      'Sorry, You have not any order history yet',
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    margin: EdgeInsets.only(left: 10),
                    // width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),

                Container(
                    // width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                  "Booking Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      "Boat/ Plane / Roads",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                // Spacer(),
                Container(
                    // width: MediaQuery.of(context).size.width * (20 / 100),
                    child: Text(
                  "From",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                // Spacer(),
                Container(
                    // width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                  "To",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      "Shipment Comapny",
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
        itemCount: bookingResponse!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      bookingResponse![index].id.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 100),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      bookingResponse![index].bookingDate,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 50),
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      bookingResponse![index].bookingType,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      bookingResponse![index].from,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    // margin: EdgeInsets.only(left: 40),
                    child: Text(
                      bookingResponse![index].to,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      bookingResponse![index].title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      bookingResponse![index].status,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          );
        });
  }

  Widget orderDetails2() {
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
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "12345",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "21.08.2021",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "21.08.2021",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "USA",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "India",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "CMA CGM",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
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
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xff0FBAB8),
                    ),
                    child: Center(
                      child: Text(
                        "Deliverd",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    )),
              ),
              Container(
                  margin: EdgeInsets.only(top: 15, right: 10),
                  height: MediaQuery.of(context).size.height * (5 / 100),
                  // height: 100,
                  width: MediaQuery.of(context).size.width * (10 / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff4CAF50),
                  ),
                  child: Center(
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget orderDetails3() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 100,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "12345",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "21.08.2021",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "21.08.2021",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "USA",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "India",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              // margin: EdgeInsets.only(left: 20),
              child: Text(
            "CMA CGM",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Spacer(),
          Container(
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "Waiting Pickup",
                style: TextStyle(fontSize: 15, color: Color(0xffFF0000)),
              )),
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
                  // prefixIcon: IconButton(
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       searchfunction();
                  //     });

                  //   },
                  // ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   edit.clear();
                      //   searchDataresponse.removeLast();
                      //   // Widget build(BuildContext context)
                      //   // searchfunction();
                      //   MaterialPageRoute(
                      //       builder: (context) => bookingDesktopCard());
                      // });
                    },
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
                    (DateFormat.yMd().format(initialDate).toString()),
                    style: headingStyle12blacknormal(),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate1(context);
                      datefilter.text =
                          (DateFormat.yMd().format(initialDate).toString());
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
