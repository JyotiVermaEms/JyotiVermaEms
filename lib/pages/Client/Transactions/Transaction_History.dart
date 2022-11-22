import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Client/clientListTransactionModel.dart';
import 'package:shipment/Model/Client/clientViewCardModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Client/Res_AddNewCard.dart';
import 'package:shipment/pages/Client/Transactions/AddnewCard.dart';
import '../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

import '../Dashboard/MobileDashboard.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController controller = ScrollController();
  TabController? tabController;

  DateTime? selectedDate = DateTime.now();
  var h, w;
  List<String> cardnumber = [];
  List<Data> viewcard = [];
  var index;
  bool isProcess = false;
  List<Transaction> viewtransaction = [];
  List<MktListTransactionData> viewMrktTransaction = [];
  getcard() async {
    var response = await Providers().getViewCard();
    if (response.status == true) {
      setState(() {
        viewcard = response.data;
      });
    }
  }

  getTransaction() async {
    setState(() {
      isProcess = true;
    });
    var responce = await Providers().getListTransaction();
    if (responce.status == true) {
      setState(() {
        viewtransaction = responce.data;
      });
    }
    setState(() {
      isProcess = false;
    });
  }

  getMrktTransaction() async {
    var responce = await Providers().getMarketPlaceListTransaction();
    if (responce.status == true) {
      setState(() {
        viewMrktTransaction = responce.data;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcard();
    getTransaction();
    getMrktTransaction();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
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
                                        builder: (context) => ResAddNewCard()));
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xff1A494F)),
                                  margin: EdgeInsets.only(top: 15, right: 15),
                                  height: MediaQuery.of(context).size.height *
                                      (6 / 100),
                                  // width: MediaQuery.of(context)
                                  //         .size
                                  //         .width *
                                  //     (11 / 100),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
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

                        viewcard.length != 0
                            ? Container(
                                height:
                                    (Responsive.isDesktop(context)) ? 220 : 220,
                                width: MediaQuery.of(context).size.width,

                                // height: MediaQuery.of(context).size.height * (30 / 100),
                                // width: MediaQuery.of(context).size.width * (80 / 100),

                                child: Scrollbar(
                                  child: ListView.builder(
                                      physics: PageScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: viewcard.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Stack(children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 15, right: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Color(0xff197BBD)),
                                            width: 300,
                                            height:
                                                (Responsive.isDesktop(context))
                                                    ? 200
                                                    : 220,
                                            // height:
                                            //     MediaQuery.of(context).size.height * (15 / 100),
                                            // width:
                                            //     MediaQuery.of(context).size.width * (20 / 100),
                                            child: Column(children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 5,
                                                    right: 10,
                                                    left: 15),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "cloud cash",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        "PREMIUM ACCOUNT",
                                                        style: TextStyle(
                                                          color: Colors.white24,
                                                          fontSize: 8,
                                                        ))),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: (Responsive.isDesktop(
                                                            context))
                                                        ? 50
                                                        : 40,
                                                    right: 10,
                                                    left: 15),
                                                child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        viewcard[index]
                                                                .cardNumber
                                                                .substring(
                                                                    0, 4) +
                                                            "    ****" +
                                                            "    ****    " +
                                                            viewcard[index]
                                                                .cardNumber
                                                                .substring(
                                                                    12, 16),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white))),
                                              ),
                                              Row(children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      20, 30, 15, 0),
                                                  child: Text("Card holder",
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                        fontSize: 8,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 30, 15, 0),
                                                  child: Text("Expire Date ",
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                        fontSize: 8,
                                                      )),
                                                ),
                                              ]),
                                              Row(children: [
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      20, 5, 5, 10),
                                                  child: Text(
                                                    viewcard[index].name,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 20, 10),
                                                  child: Text(
                                                      viewcard[index].expire,
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ]),
                                            ]),
                                          ),
                                          // Positioned(
                                          //     top: 70,
                                          //     left: 90,
                                          //     right: 0,
                                          //     bottom: 0,
                                          //     child: Image.asset(
                                          //       "assets/images/carddesign.png",
                                          //       scale: 2.0,
                                          //     ))
                                        ]);
                                      }),
                                ),
                              )
                            : Container(
                                height: 10,
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
                              (DateFormat.yMd()
                                  .format(selectedDate!)
                                  .toString()),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        // if (Responsive.isDesktop(context))
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 500,
                                  height: 50,
                                  child: DefaultTabController(
                                    initialIndex: 0,
                                    length: 2,
                                    child: TabBar(
                                      controller: tabController,
                                      labelColor: Color(0xff1A494F),
                                      unselectedLabelColor: Colors.grey,
                                      indicatorColor: Color(0xff1A494F),
                                      tabs: <Widget>[
                                        Container(
                                          width: 200,
                                          child: Tab(
                                            child: Text(
                                              "Order",
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Container(
                                            width: 200,
                                            child: Text(
                                              "Market Place Order",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            (Responsive.isDesktop(context))
                                ? Container(
                                    height: h,
                                    width: w * 0.80,
                                    child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                orderTemplate(),
                                                orderDetails(),
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                orderTemplate1(),
                                                marketorderDetails(),
                                              ],
                                            ),
                                          ),
                                        ]))
                                : Container(
                                    height: h * 0.6,
                                    width: w * 0.99,
                                    child: TabBarView(
                                        controller: tabController,
                                        children: [
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                MobileVieworderTemplate()
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                MobileViewmarketTemplate()
                                              ],
                                            ),
                                          ),
                                        ]),
                                  ),
                          ],
                        ),

                        // if (!Responsive.isDesktop(context))
                        //   Column(
                        //     children: [
                        //       // MobileVieworderTemplate(),
                        //       // MobileVieworderTemplate2(),
                        //     ],
                        //   ),

                        // Column(
                        //   children: [
                        //     Container(
                        //       height: h,
                        //       width: w * 0.80,
                        //       child: SingleChildScrollView(
                        //         child: viewtransaction.length == 0
                        //             ? Container(
                        //                 height: 200,
                        //                 width: double.infinity,
                        //                 child: Card(
                        //                   shape: RoundedRectangleBorder(
                        //                       borderRadius: BorderRadius.all(
                        //                           Radius.circular(10))),
                        //                   elevation: 1,
                        //                   child: Container(
                        //                     padding: EdgeInsets.all(12),
                        //                     decoration:
                        //                         linearGradientForWhiteCard(),
                        //                     child: Column(
                        //                       children: [
                        //                         // Image.asset(
                        //                         //   'assets/images/applogo.png',
                        //                         //   height:
                        //                         //       MediaQuery.of(context).size.height * 0.10,
                        //                         // ),
                        //                         SizedBox(height: 15),
                        //                         Text(
                        //                           'Sorry, You have not any Bookings yet',
                        //                           style: headingStyle16MB(),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               )
                        //             : Column(
                        //                 children: [
                        //                   orderTemplate(),
                        //                   orderDetails(),
                        //                 ],
                        //               ),
                        //       ),
                        //       // SingleChildScrollView(
                        //       //   child: Column(
                        //       //     children: [
                        //       //       marketBookingTemplate(),
                        //       //       marketBookingDetails(),
                        //       //     ],
                        //       //   ),
                        //       // ),
                        //     ),
                        //   ],
                        // ),

                        // if (!Responsive.isDesktop(context))
                        //   MobileVieworderTemplate()
                        // orderDetails()
                      ])),
                )),
    );
  }

  Widget orderTemplate() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 25, right: 15),
              // decoration: BoxDecoration(
              //     borderRadius:
              //         BorderRadius.circular(15),
              //     color: Color(0xffFFFFFF)),
              height: MediaQuery.of(context).size.height * (5 / 100),
              width: MediaQuery.of(context).size.width * (2 / 100),
              child: Image.asset('assets/images/cardPayment.png')),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "Booking ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              margin: EdgeInsets.only(left: 30),
              // width: MediaQuery.of(context).size.width * (15 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Transaction id",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          // Spacer(),
          Container(
              margin: EdgeInsets.only(left: 140),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Booking type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              margin: EdgeInsets.only(left: 100),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              margin: EdgeInsets.only(left: 80, right: 10),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderTemplate1() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 25, right: 15),
              // decoration: BoxDecoration(
              //     borderRadius:
              //         BorderRadius.circular(15),
              //     color: Color(0xffFFFFFF)),
              height: MediaQuery.of(context).size.height * (5 / 100),
              width: MediaQuery.of(context).size.width * (2 / 100),
              child: Image.asset('assets/images/cardPayment.png')),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "Market Place ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              margin: EdgeInsets.only(left: 60),
              // width: MediaQuery.of(context).size.width * (15 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Transaction id",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          // Spacer(),
          Container(
              margin: EdgeInsets.only(left: 110),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Card type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              margin: EdgeInsets.only(left: 100),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              margin: EdgeInsets.only(left: 80, right: 10),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "Total Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: viewtransaction.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 40, top: 20, right: 15),
                      // decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(15),
                      //     color: Color(0xffFFFFFF)),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: MediaQuery.of(context).size.width * (2 / 100),
                      child: Image.asset('assets/images/cardPayment.png')),
                  Container(
                    margin: EdgeInsets.fromLTRB(80, 20, 5, 0),
                    child: Text(
                      viewtransaction[index].id.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: w * 0.2,
                    margin: EdgeInsets.fromLTRB(90, 20, 5, 0),
                    child: Text(
                      viewtransaction[index].transactionId.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(85, 20, 5, 0),
                    child: Text(
                      viewtransaction[index].bookingType.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(100, 20, 0, 0),
                    child: Text(
                      viewtransaction[index]
                          .createdAt
                          .substring(0, 10)
                          .toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(100, 20, 5, 0),
                    child: Text(
                      viewtransaction[index].totalAmount.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 10),
                child: Divider(
                  height: 30,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ),
            ],
          );
        });
  }

  Widget marketorderDetails() {
    return ListView.builder(
        itemCount: viewMrktTransaction.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 40, top: 20, right: 15),
                      // decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(15),
                      //     color: Color(0xffFFFFFF)),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: MediaQuery.of(context).size.width * (2 / 100),
                      child: Image.asset('assets/images/cardPayment.png')),
                  Container(
                    margin: EdgeInsets.fromLTRB(80, 20, 5, 0),
                    child: Text(
                      viewMrktTransaction[index].mid.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    width: 270,
                    margin: EdgeInsets.fromLTRB(100, 20, 5, 0),
                    child: Text(
                      viewMrktTransaction[index].transactionId.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(90, 20, 5, 0),
                    child: Text(
                      viewMrktTransaction[index].cardType.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //   child: viewtransaction[index].cardType.toString() == 'Debit'
                  //       ? Text(
                  //           viewtransaction[index].cardType.toString(),
                  //           style: TextStyle(
                  //             color: Colors.grey,
                  //             fontSize: 16,
                  //           ),
                  //         )
                  //       : Text(
                  //           viewtransaction[index].cardType.toString(),
                  //           style: TextStyle(
                  //             color: Colors.grey,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  // ),

                  Container(
                    margin: EdgeInsets.fromLTRB(100, 20, 0, 0),
                    child: Text(
                      viewMrktTransaction[index]
                          .createdAt
                          .substring(0, 10)
                          .toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(105, 20, 5, 0),
                    child: Text(
                      viewMrktTransaction[index].totalAmount.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 40, right: 10),
                child: Divider(
                  height: 30,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ),
            ],
          );
        });
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: viewtransaction.length,
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
                          "Booking ID",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "Transaction ID",
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
                          viewtransaction[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewtransaction[index].transactionId.toString(),
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
                          "Booking Type",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Date",
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
                          viewtransaction[index].bookingType.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewtransaction[index]
                                .createdAt
                                .substring(0, 10)
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
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
                          "Total Amount",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewtransaction[index].totalAmount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget MobileViewmarketTemplate() {
    return ListView.builder(
        itemCount: viewMrktTransaction.length,
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
                          "Market Place ID",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "Transaction ID",
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
                          viewMrktTransaction[index].mid.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewMrktTransaction[index].transactionId.toString(),
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
                          "Card Type",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Date",
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
                          viewMrktTransaction[index].cardType.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewMrktTransaction[index]
                                .createdAt
                                .substring(0, 10)
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
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
                          "Total Amount",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            viewMrktTransaction[index].totalAmount.toString(),
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
