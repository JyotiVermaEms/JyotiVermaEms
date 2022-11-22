import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Transaction/Res_Shipment_addCard.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ShipmentTransaction extends StatefulWidget {
  const ShipmentTransaction({Key? key}) : super(key: key);

  @override
  _ShipmentTransactionState createState() => _ShipmentTransactionState();
}

class _ShipmentTransactionState extends State<ShipmentTransaction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;

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
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                        child: Text(
                          'Transactions',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                // if (Responsive.isDesktop(context))

                // if (Responsive.isMobile(context))

                // if (Responsive.isTablet(context))
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 20, 5, 0),
                      child: Text(
                        'Save Cards',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResAddCardShipment()));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Color(0xff1A494F)),
                          margin: EdgeInsets.only(top: 15, right: 15),
                          height:
                              MediaQuery.of(context).size.height * (6 / 100),
                          // width: MediaQuery.of(context)
                          //         .size
                          //         .width *
                          //     (11 / 100),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Add New Card",
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
                  height: MediaQuery.of(context).size.height * (30 / 100),
                  width: MediaQuery.of(context).size.width * (80 / 100),
                  child: CupertinoScrollbar(
                    child: ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 15,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                              margin:
                                  EdgeInsets.only(left: 15, top: 15, right: 15),
                              // decoration: BoxDecoration(
                              //     borderRadius:
                              //         BorderRadius.circular(15),
                              //     color: Color(0xffFFFFFF)),
                              // height:
                              //     MediaQuery.of(context).size.height *
                              //         (15 / 100),
                              // width:
                              //     MediaQuery.of(context).size.width *
                              //         (20 / 100),
                              child: Image.asset('assets/images/card (1).png',
                                  fit: BoxFit.cover, width: 300));
                        }),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 5, 0),
                    child: Text(
                      'Last Transactions',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 20, 5, 0),
                    child: Text(
                      'October 30, 2017',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                if (Responsive.isDesktop(context))
                  Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.only(left: 15, top: 20, right: 15),
                              // decoration: BoxDecoration(
                              //     borderRadius:
                              //         BorderRadius.circular(15),
                              //     color: Color(0xffFFFFFF)),
                              height: MediaQuery.of(context).size.height *
                                  (5 / 100),
                              width:
                                  MediaQuery.of(context).size.width * (2 / 100),
                              child:
                                  Image.asset('assets/images/cardPayment.png')),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 5, 0),
                            child: Text(
                              'Order #12456 Payment',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'Debit card',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'October 30, 2017',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: Text(
                              '-667.00',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          height: 30,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              margin:
                                  EdgeInsets.only(left: 15, top: 20, right: 15),
                              // decoration: BoxDecoration(
                              //     borderRadius:
                              //         BorderRadius.circular(15),
                              //     color: Color(0xffFFFFFF)),
                              height: MediaQuery.of(context).size.height *
                                  (5 / 100),
                              width:
                                  MediaQuery.of(context).size.width * (2 / 100),
                              child:
                                  Image.asset('assets/images/cardPayment.png')),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 20, 5, 0),
                            child: Text(
                              'Order #12456 Payment',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'Debit card',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text(
                              'October 30, 2017',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                            child: Text(
                              '-667.00',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(
                          height: 30,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),

                if (!Responsive.isDesktop(context)) MobileVieworderTemplate()
              ])),
        ));
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: 2,
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
                          "Card",
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
                        child: Text("Debit Card",
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
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Amount",
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
                          "Oct 30, 2017",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("-667.00",
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
