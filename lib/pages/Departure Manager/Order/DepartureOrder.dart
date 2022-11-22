// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureordermodel.dart';
import 'package:shipment/Model/PickupAgent/pickupchangeStatusModel.dart';

import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/component/Departure%20Manager/Select_Agent.dart';
import 'package:shipment/pages/Departure%20Manager/Order/depaturealertdiaolog.dart';
import 'package:universal_html/html.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class DepartureOrders extends StatefulWidget {
  const DepartureOrders({Key? key}) : super(key: key);

  @override
  _DepartureOrdersState createState() => _DepartureOrdersState();
}

class _DepartureOrdersState extends State<DepartureOrders>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  TabController? tabController;
  bool isProcess = false;
  var h, w;
  var index1;
  var clientname;
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
  var exMData = [];

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
    for (int i = 0; i < shipmentOrder.length; i++) {
      for (int j = i; i < shipmentOrder[i].pickupReview.length; j++) {
        pickuptype = shipmentOrder[i].pickupReview[j].pickupType;
      }

      pickupAgentId = shipmentOrder[i].pickupagentId.toString();

      log("jdhjhjkhjdf" + pickuptype.toString());
    }
    setState(() {
      isProcess = false;
    });
  }

  List<DepatureMArketData> marketPlaceOrder = [];
  List<ClientData>? clientinfo;
  getMArketPlaceList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().departureMarketOrderhistory();

    marketPlaceOrder = response.data;
    exMData = response.data;

    for (int i = 0; i < marketPlaceOrder.length; i++) {
      var status = marketPlaceOrder[i].marketStatus.toString();
      clientinfo = marketPlaceOrder[i].client;
      print("-=-=-=-=-=-=-=-=-=$status");
    }
    setState(() {});
    setState(() {
      isProcess = false;
    });

    print("jkkhkdkdkckdkck$marketPlaceOrder");
  }

  var UserId, userRole;
  var roomId = 0;
  var chatListData = [];
  var shipmentId = 0;
  void getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userDetails;
    if (prefs.getString('Shipemnt_auth_token') != null) {
      userDetails = await Providers().getshipmentProfile();
    } else if (prefs.getString('auth_token') != null) {
      userDetails = await Providers().getClientProfile();
    } else if (prefs.getString('depature_token') != null) {
      userDetails = await Providers().getDepatureProfile();
    } else if (prefs.getString('Pickup_Agent_token') != null) {
      userDetails = await Providers().getpickupAgentProfile();
    } else if (prefs.getString('Arrival_Manager_token') != null) {
      userDetails = await Providers().getArrivalManagerProfile();
    } else if (prefs.getString('receptionist_token') != null) {
      userDetails = await Providers().getReceptionisProfile();
    }

    print(userDetails.status);
    if (userDetails.status == true) {
      // sId = userDetails.data[0].id;

      setState(() {
        UserId = userDetails.data[0].id;
        userRole = userDetails.data[0].roles;
        shipmentId = userDetails.data[0].shipmentId;
      });

      print("-=-=-UserId $UserId");
      getChatList();
    }
  }

  getChatList() async {
    print("getChatList");
    var data = {
      // "userId": "9",
      // "userToRole": "1c"
      "userId": UserId.toString(),
      "userToRole": userRole.toString()
    };
    var response = await Providers().getChatList(data);
    print("-=-=-=data ${data}");
    if (response.status == true) {
      print("-=-=-=response data ${response.data}");

      // chatListData = response.data;

      // roomId = chatListData[0].roomId;

      for (int i = 0; i < response.data.length; i++) {
        chatListData
            .add({"id": response.data[i].roomId, "name": response.data[i].sid});
      }

      setState(() {});
    } else {
      roomId = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipmentList();
    getMArketPlaceList();
    getProfileDetails();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
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
                                    'orderdetails'.tr(),
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
                                                  "order".tr(),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Container(
                                                width: 200,
                                                child: Text(
                                                  "marketplaceorders".tr(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: h,
                                  width: w * 0.80,
                                  child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              booking(),
                                              orderTemplate(),
                                              orderDetails(),
                                            ],
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              mbooking(),
                                              orderMarketTemplate(),
                                              marketOrderDetails(),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          if (!Responsive.isDesktop(context))
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
                                                  "order".tr(),
                                                ),
                                              ),
                                            ),
                                            Tab(
                                              child: Container(
                                                width: 200,
                                                child: Text(
                                                  "marketplaceorders".tr(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: h,
                                  width: w,
                                  child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              // booking(),
                                              MobileVieworderTemplate()
                                              // orderTemplate(),
                                              // orderDetails(),
                                            ],
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              // mbooking(),
                                              MobileVieworderTemplate2()
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                        ])),
              ));
  }

  Widget mbooking() {
    return (Responsive.isDesktop(context))
        ? Container(
            height: 40,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
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
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("export");
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "Title",
                            "status",
                          ]
                        ];
                        for (int i = 0; i < exMData.length; i++) {
                          List row = [];
                          row.add(exMData[i].id);

                          row.add(exMData[i].bookingDate);
                          row.add(exMData[i].title);

                          row.add(exMData[i].status);

                          rows.add(row);
                        }

                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
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
            height: 40,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("export");
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "Title",
                            "status",
                          ]
                        ];
                        for (int i = 0; i < exMData.length; i++) {
                          List row = [];
                          row.add(exMData[i].id);

                          row.add(exMData[i].bookingDate);
                          row.add(exMData[i].title);

                          row.add(exMData[i].status);

                          rows.add(row);
                        }

                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height:
                              MediaQuery.of(context).size.height * (5 / 100),
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
                                onTap: () {},
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
            ));
  }

  Widget booking() {
    return Container(
        height: 40,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
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
                      List row = [];
                      row.add(exData[i].id);

                      row.add(exData[i].bookingDate);
                      row.add(exData[i].title);
                      row.add(exData[i].client.name);

                      row.add(exData[i].status);

                      rows.add(row);
                    }

                    DateTime now = DateTime.now();
                    DateTime todayDate = DateTime(now.year, now.month, now.day);

                    String fileName = "order_" +
                        getRandomString(5) +
                        "_" +
                        todayDate.toString();

                    String csv = const ListToCsvConverter().convert(rows);
                    var dataUrl = AnchorElement(
                        href: "data:text/plain;charset=utf-8,$csv")
                      ..setAttribute("download", fileName + ".csv")
                      ..click();
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
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
              ],
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
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "orderid".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                // width: MediaQuery.of(context).size.width * (20 / 100),
                width: w * 0.07,
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
                child: Text(
                  "changestatus".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.05,
                margin: EdgeInsets.only(right: 40),
                child: Text(
                  "chat".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget orderMarketTemplate() {
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
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "orderid".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,
                child: Text(
                  "bookingdate".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),

            Container(
                width: w * 0.05,
                child: Text(
                  "title".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.07,
                child: Text(
                  "clientname".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // Spacer(),
            Container(
                width: w * 0.06,
                child: Text(
                  "status".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,
                child: Text(
                  "changestatus".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.07,
                child: Text(
                  "chat".tr(),
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
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              // height: (!Responsive.isDesktop(context))
              //     ? MediaQuery.of(context).size.height * (10 / 100)
              //     : MediaQuery.of(context).size.height * (45 / 100),
              height: 100,
              width: MediaQuery.of(context).size.width * (20 / 100),
              // margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                        shipmentOrder[index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: w * 0.06,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        shipmentOrder[index].bookingDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: w * 0.06,
                    // width: MediaQuery.of(context).size.width * (20 / 100),

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
                                      stitle: shipmentOrder[index].title,
                                      sid: shipmentOrder[index].id,
                                      stype: shipmentOrder[index].bookingType,
                                      sto: shipmentOrder[index].to,
                                      sfrom: shipmentOrder[index].from,
                                      bookingitem:
                                          shipmentOrder[index].bookingItem,
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
                      width: w * 0.06,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      child: Center(
                        child: Text(
                          shipmentOrder[index].client.name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                      width: w * 0.08,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        shipmentOrder[index].status.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  GestureDetector(
                    onTap: () async {
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
                      print(itemimage);
                      print(comment);
                      print(itemimage1);
                      print(depatureimage);
                      print(depaturecomment);

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (shipmentOrder[index].pickupReview[0].pickupType ==
                          "Pick up") {
                        int trendIndex = chatListData.indexWhere(
                            (f) => f['name'] == shipmentOrder[index].id);
                        print("-=-=-trendIndex $trendIndex");
                        if (trendIndex != -1) {
                          prefs.setInt(
                              "localRoomId", chatListData[trendIndex]['id']);
                          print(
                              "-=-roomId=- ${chatListData[trendIndex]['id']}");
                        }
                      }

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
                                    tabController!.index.toString(),
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
                        width: w * 0.09,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        // margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            "updatestatus".tr(),
                            // shipmentOrder![index].status == "pickup done"
                            //     ? "Ready to Dispatch"
                            //     : shipmentOrder![index].status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "3"));
                      usersList.add(ChatUsers(shipmentOrder[index].uid, "1c"));
                      usersList.add(
                          ChatUsers(shipmentOrder[index].receptionistId, "2r"));
                      usersList.add(ChatUsers(shipmentId, "1"));
                      usersList.add(ChatUsers(
                          int.parse(shipmentOrder[index]
                              .schedule[0]
                              .destinationWarehouse),
                          "4"));
                      var pickId = shipmentOrder[index].pickupagentId;
                      pickId != null
                          ? usersList.add(ChatUsers(pickId, "5"))
                          : '';

                      print("-=-= $chatListData");

                      int trendIndex = chatListData.indexWhere(
                          (f) => f['name'] == shipmentOrder[index].id);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": shipmentOrder[index].title.toString(),
                        "firm_name": shipmentOrder[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": UserId.toString(),
                        "sid": shipmentOrder[index].id.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id": shipmentOrder[index].client.id, //other
                      };
                      print("-=-data11=- $data11");
                      print(
                          "-=-=-=shipmentOrder![index].client.id ${shipmentOrder[index].client.id}");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        width: w * 0.08,
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
                            "chat".tr(),
                            // shipmentOrder![index].status == "pickup done"
                            //     ? "Ready to Dispatch"
                            //     : shipmentOrder![index].status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget marketOrderDetails() {
    return ListView.builder(
        itemCount: marketPlaceOrder.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (context, index) {
          print("dhhfdghfghdf${marketPlaceOrder[index].marketStatus}");
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              // height: (!Responsive.isDesktop(context))
              //     ? MediaQuery.of(context).size.height * (10 / 100)
              //     : MediaQuery.of(context).size.height * (45 / 100),
              height: 80,
              width: MediaQuery.of(context).size.width * (20 / 100),
              // margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                      margin: EdgeInsets.only(left: 35),
                      child: Text(
                        marketPlaceOrder[index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: w * 0.08,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        marketPlaceOrder[index].bookingDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: w * 0.06,
                    // width: MediaQuery.of(context).size.width * (20 / 100),

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
                                child: AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: ContainerListDialog(
                                      stitle: marketPlaceOrder[index].title,
                                      sid: marketPlaceOrder[index].mid,
                                      stype: 'Market Place',
                                      sto: marketPlaceOrder[index]
                                          .pickupLocation,
                                      sfrom: marketPlaceOrder[index]
                                          .dropoffLocation,
                                      bookingitem: [],
                                      h: h,
                                      w: w),
                                ),
                              );
                            });
                      },
                      child: Text(
                        marketPlaceOrder[index].title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A494F)),
                      ),
                    ),
                  ),

                  Container(
                      width: w * 0.08,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      child: Center(
                        child: Text(
                          marketPlaceOrder[index].client[0].name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                      width: w * 0.07,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        marketPlaceOrder[index].marketStatus.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  GestureDetector(
                    onTap: () async {
                      print("--=-=-=-=-==-=${marketPlaceOrder[index].dropoff}");
                      var pid = marketPlaceOrder[index].pickupagentId;
                      var itemimage =
                          marketPlaceOrder[index].pickupItemimage.toString();

                      var comment =
                          marketPlaceOrder[index].pickupComment.toString();
                      var itemimage1 =
                          marketPlaceOrder[index].pickupItemimage1.toString();
                      var comment1 =
                          marketPlaceOrder[index].pickupComment1.toString();
                      var depatureimage =
                          marketPlaceOrder[index].departureImage.toString();
                      var depaturecomment =
                          marketPlaceOrder[index].departureComment.toString();
                      var bid = marketPlaceOrder[index].mid.toString();
                      var type = marketPlaceOrder[index].dropoff.toString();
                      var bookingdate =
                          marketPlaceOrder[index].bookingDate.toString();
                      var status =
                          marketPlaceOrder[index].marketStatus.toString();

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      if (marketPlaceOrder[index].dropoff == "Pick up") {
                        int trendIndex = chatListData.indexWhere(
                            (f) => f['id'] == marketPlaceOrder[index].id);
                        print("-=-=-trendIndex $trendIndex");
                        if (trendIndex != -1) {
                          prefs.setInt(
                              "localRoomId", chatListData[trendIndex]['id']);
                          print(
                              "-=-roomId=- ${chatListData[trendIndex]['id']}");
                        }
                      }

                      marketPlaceOrder[index].dropoff == "Pick up"
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBox1(
                                    bid,
                                    pid,
                                    type,
                                    bookingdate,
                                    status,
                                    tabController!.index.toString(),
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
                                    tabController!.index.toString(),
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                    depatureimage,
                                    depaturecomment,
                                  ));
                    },
                    child: Container(
                        width: w * 0.09,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        // margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            "updatestatus".tr(),
                            // shipmentOrder![index].status == "pickup done"
                            //     ? "Ready to Dispatch"
                            //     : shipmentOrder![index].status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),

                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "3"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].uid, "1c"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].arrivalId, "4"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].receptionistId, "2r"));
                      var pickId = marketPlaceOrder[index].pickupagentId;
                      pickId != 0 ? usersList.add(ChatUsers(pickId, "5")) : '';

                      print("-=-= $chatListData");

                      int trendIndex = chatListData.indexWhere(
                          (f) => f['id'] == marketPlaceOrder[index].id);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": marketPlaceOrder[index].title.toString(),
                        "firm_name": marketPlaceOrder[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": UserId.toString(),
                        "sid": marketPlaceOrder[index].id.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id": marketPlaceOrder[index].uid, //other
                      };
                      print("-=-data11=- $data11");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        width: w * 0.09,
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
                            "chat".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: shipmentOrder.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            width: w,
            margin: EdgeInsets.all(10),
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
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          shipmentOrder[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
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
                                child: AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: ContainerListDialog(
                                      stitle: shipmentOrder[index].title,
                                      sid: shipmentOrder[index].id,
                                      stype: shipmentOrder[index].bookingType,
                                      sto: shipmentOrder[index].to,
                                      sfrom: shipmentOrder[index].from,
                                      bookingitem:
                                          shipmentOrder[index].bookingItem,
                                      h: h,
                                      w: w),
                                ),
                              );
                            });
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 10, right: 20),
                          child: Text(shipmentOrder[index].title.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "clientname".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("changestatus".tr(),
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
                          shipmentOrder[index].client.name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () async {
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
                        print(itemimage);
                        print(comment);
                        print(itemimage1);
                        print(depatureimage);
                        print(depaturecomment);

                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (shipmentOrder[index].pickupReview[0].pickupType ==
                            "Pick up") {
                          int trendIndex = chatListData.indexWhere(
                              (f) => f['name'] == shipmentOrder[index].id);
                          print("-=-=-trendIndex $trendIndex");
                          if (trendIndex != -1) {
                            prefs.setInt(
                                "localRoomId", chatListData[trendIndex]['id']);
                            print(
                                "-=-roomId=- ${chatListData[trendIndex]['id']}");
                          }
                        }

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
                                      tabController!.index.toString(),
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
                          height: 40,
                          width: MediaQuery.of(context).size.width * (35 / 100),
                          margin: EdgeInsets.only(top: 10, right: 20),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Text("updatestatus".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          )),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(UserId, "3"));
                    usersList.add(ChatUsers(shipmentOrder[index].uid, "1c"));
                    usersList.add(
                        ChatUsers(shipmentOrder[index].receptionistId, "2r"));
                    usersList.add(ChatUsers(shipmentId, "1"));
                    usersList.add(ChatUsers(
                        int.parse(shipmentOrder[index]
                            .schedule[0]
                            .destinationWarehouse),
                        "4"));
                    var pickId = shipmentOrder[index].pickupagentId;
                    pickId != null ? usersList.add(ChatUsers(pickId, "5")) : '';

                    print("-=-= $chatListData");

                    int trendIndex = chatListData.indexWhere(
                        (f) => f['name'] == shipmentOrder[index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": shipmentOrder[index].title.toString(),
                      "firm_name": shipmentOrder[index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": shipmentOrder[index].id.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id": shipmentOrder[index].client.id, //other
                    };
                    print("-=-data11=- $data11");
                    print(
                        "-=-=-=shipmentOrder![index].client.id ${shipmentOrder[index].client.id}");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      //     MediaQuery.of(context).size.width * (12 / 100),
                      height: 40,
                      margin: EdgeInsets.only(
                          right: 10, left: 10, bottom: 20, top: 20),
                      child: Center(
                        child: Text(
                          "chat".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget MobileVieworderTemplate2() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.99,
      child: ListView.builder(
          itemCount: marketPlaceOrder.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              // height: MediaQuery.of(context).size.height * (55 / 100),
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
                            marketPlaceOrder[index].id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            width:
                                MediaQuery.of(context).size.width * (40 / 100),
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              marketPlaceOrder[index].marketStatus.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                            "bookingdate".tr(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 10, right: 20),
                          child: Text("title".tr(),
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
                            marketPlaceOrder[index].bookingDate.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
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
                                  child: AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: ContainerListDialog(
                                        stitle: marketPlaceOrder[index].title,
                                        sid: marketPlaceOrder[index].mid,
                                        stype: 'Market Place',
                                        sto: marketPlaceOrder[index]
                                            .pickupLocation,
                                        sfrom: marketPlaceOrder[index]
                                            .dropoffLocation,
                                        bookingitem: [],
                                        h: h,
                                        w: w),
                                  ),
                                );
                              });
                        },
                        child: Container(
                            width:
                                MediaQuery.of(context).size.width * (40 / 100),
                            margin: EdgeInsets.only(top: 10, right: 20),
                            child: Text(
                                marketPlaceOrder[index].title.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black))),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            "clientname".tr(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 15, right: 20),
                          child: Text("changestatus".tr(),
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
                            marketPlaceOrder[index].client[0].name.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      GestureDetector(
                        onTap: () async {
                          print(
                              "--=-=-=-=-==-=${marketPlaceOrder[index].dropoff}");
                          var pid = marketPlaceOrder[index].pickupagentId;
                          var itemimage = marketPlaceOrder[index]
                              .pickupItemimage
                              .toString();

                          var comment =
                              marketPlaceOrder[index].pickupComment.toString();
                          var itemimage1 = marketPlaceOrder[index]
                              .pickupItemimage1
                              .toString();
                          var comment1 =
                              marketPlaceOrder[index].pickupComment1.toString();
                          var depatureimage =
                              marketPlaceOrder[index].departureImage.toString();
                          var depaturecomment = marketPlaceOrder[index]
                              .departureComment
                              .toString();
                          var bid = marketPlaceOrder[index].mid.toString();
                          var type = marketPlaceOrder[index].dropoff.toString();
                          var bookingdate =
                              marketPlaceOrder[index].bookingDate.toString();
                          var status =
                              marketPlaceOrder[index].marketStatus.toString();

                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (marketPlaceOrder[index].dropoff == "Pick up") {
                            int trendIndex = chatListData.indexWhere(
                                (f) => f['id'] == marketPlaceOrder[index].id);
                            print("-=-=-trendIndex $trendIndex");
                            if (trendIndex != -1) {
                              prefs.setInt("localRoomId",
                                  chatListData[trendIndex]['id']);
                              print(
                                  "-=-roomId=- ${chatListData[trendIndex]['id']}");
                            }
                          }

                          marketPlaceOrder[index].dropoff == "Pick up"
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialogBox1(
                                        bid,
                                        pid,
                                        type,
                                        bookingdate,
                                        status,
                                        tabController!.index.toString(),
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
                                        tabController!.index.toString(),
                                        itemimage,
                                        comment,
                                        itemimage1,
                                        comment1,
                                        depatureimage,
                                        depaturecomment,
                                      ));
                        },
                        child: Container(
                            height: 40,
                            width:
                                MediaQuery.of(context).size.width * (40 / 100),
                            margin: EdgeInsets.only(top: 10, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Center(
                              child: Text("updatestatus".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            )),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "3"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].uid, "1c"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].arrivalId, "4"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].receptionistId, "2r"));
                      var pickId = marketPlaceOrder[index].pickupagentId;
                      pickId != 0 ? usersList.add(ChatUsers(pickId, "5")) : '';

                      print("-=-= $chatListData");

                      int trendIndex = chatListData.indexWhere(
                          (f) => f['id'] == marketPlaceOrder[index].id);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": marketPlaceOrder[index].title.toString(),
                        "firm_name": marketPlaceOrder[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": UserId.toString(),
                        "sid": marketPlaceOrder[index].id.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id": marketPlaceOrder[index].uid, //other
                      };
                      print("-=-data11=- $data11");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        margin: EdgeInsets.only(
                            right: 10, left: 10, bottom: 10, top: 10),
                        child: Center(
                          child: Text(
                            "chat".tr(),
                            // shipmentOrder![index].status == "pickup done"
                            //     ? "Ready to Dispatch"
                            //     : shipmentOrder![index].status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget ContainerListDialog(
      {sid, stype, sto, sfrom, stitle, h, w, List<BookingItem>? bookingitem}) {
    return Container(
      height: (Responsive.isDesktop(context)) ? h * 0.35 : h * 0.4,
      width: (Responsive.isDesktop(context)) ? w * 0.40 : w * 0.5,
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
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                sid.toString(),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: (Responsive.isDesktop(context)) ? 20 : 17,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (Responsive.isDesktop(context))
                  ? Container(
                      width: w * 0.15,
                      child: Text(
                        "Boat/ Place /Ship",
                        style: headingStyle16MB(),
                      ),
                    )
                  : Text(
                      "Boat/ Place /Ship",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
              (Responsive.isDesktop(context))
                  ? Container(
                      width: w * 0.10,
                      child: Text(
                        stype,
                        style: headingStyle16MB(),
                      ),
                    )
                  : Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (Responsive.isDesktop(context))
                    ? Container(
                        width: w * 0.15,
                        child: Text(
                          "From",
                          style: headingStyle16MB(),
                        ),
                      )
                    : Text(
                        "From",
                        style: headingStyle16MB(),
                      ),
                (Responsive.isDesktop(context))
                    ? Container(
                        width: w * 0.10,
                        child: Text(sfrom, style: headingStyle16MB()),
                      )
                    : Text(sfrom, style: headingStyle16MB())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (Responsive.isDesktop(context))
                    ? Container(
                        width: w * 0.15,
                        child: Text("To", style: headingStyle16MB()),
                      )
                    : Text("To", style: headingStyle16MB()),
                (Responsive.isDesktop(context))
                    ? Container(
                        width: w * 0.10,
                        child: Text(sto, style: headingStyle16MB()),
                      )
                    : Container(
                        width: w * 0.3,
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

class CustomDialogBoxDropOff extends StatefulWidget {
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
  CustomDialogBoxDropOff(
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

class _CustomDialogBoxDropOff extends State<CustomDialogBoxDropOff> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var onTap = 0;
  List<DepatureStatusData> changedata = [];
  TextEditingController _textFieldController = TextEditingController();
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
                            const Text('Take a picture'),
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

  List<MarketStatusData> mrkchangedata = [];
  doMarketdropoffChangeStatus() async {
    var depatureData = {
      "market_id": widget.bid.toString(),
      "market_status": "pickup item received",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeMarketDepatureStatus(depatureData);
    if (response.status == true) {
      setState(() {
        mrkchangedata = response.data;
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => profileConfirm());
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => profileConfirm(),
        //     ));
      });
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Your Comment'),
          content: Container(
            height: 200.0,
            width: 400.0,
            child: Container(
              height: 200,
              width: 100,
              child: TextField(
                maxLength: 150,
                maxLines: 6,
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter Comment",
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.black),
                  child: Center(
                      child: Text('CANCEL',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12)))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      'Add Comment',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )),
              onPressed: () {
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog3(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
            width: 550.0,
            child: Column(children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.only(left: 370)
                        : const EdgeInsets.only(left: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black)),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: widget.depatureimage != null
                      ? Container(
                          child: Image.network(
                            widget.depatureimage,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )
                      : Container(
                          child: Icon(
                            Icons.person,
                            size: 200.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )),
              (Responsive.isDesktop(context))
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 410, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )))
                  : Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
              Container(
                height: 130,
                width: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.depaturecomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.bid.toString(),
      "booking_status": "pickup item received",
      "schedule_status": "InProgress",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeDepatureStatus(depatureData);
    if (response.status == true) {
      setState(() {
        changedata = response.data;
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (BuildContext context) => profileConfirm());
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => profileConfirm()));

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

  var h, w;
  contentBox(context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Form(
      key: _formkey,
      child: Container(
        height: h * 0.9,
        width: w * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Order tracking" + "  " + widget.bid,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 10,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Container(
              height: (Responsive.isDesktop(context)) ? 120 : 157,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffE5E5E5),
              ),
              child: (Responsive.isDesktop(context))
                  ? Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 40, top: 20),
                                width: 100,
                                child: Text(
                                  "Shipped VIA",
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
                                  "Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 40, top: 20),
                                child: Text(
                                  "Booking Date",
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
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 10, top: 20),
                                    width: 100,
                                    child: Text(
                                      "shippedvis".tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: EdgeInsets.only(top: 20),
                                    child: Text(
                                      "status".tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: EdgeInsets.only(right: 10, top: 20),
                                    child: Text(
                                      "bookingdate".tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(
                                      widget.type,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                // SizedBox(
                                //   width: 110,
                                // ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(
                                      widget.status,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                // SizedBox(
                                //   width: 70,
                                // ),
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    margin: EdgeInsets.only(left: 10, top: 10),
                                    child: Text(
                                      widget.bookingdate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
            ),
            SizedBox(
              height: (Responsive.isDesktop(context)) ? 25 : 5,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
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
                                child: Image.asset(
                                    'assets/images/Group 740.png',
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
                                      widget.status == "accepted"
                                  // widget.status == "pickup item received" ||
                                  // widget.status == "Delivered to Receptionist"
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
                          Column(
                            children: [
                              widget.status == "Accepted" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done"
                                  // widget.status == "delivered to Warehouse" ||
                                  // widget.status == "pickup item received"
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 20),
                                      // margin: EdgeInsets.only(left: 10, right: 10),
                                      child: Image.asset(
                                          'assets/images/defaulticon.png',
                                          fit: BoxFit.fill),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        // print("-=-=-=-=-=-=-==-=$itemimage");
                                        // print("-=-=-=-=-=-=-==-=$comment");

                                        _displayShowImageCommentDialog3(
                                            context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(right: 20),
                                        child: Image.asset(
                                            'assets/images/Group 743.png',
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        height: h * 0.21,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                      'assets/images/Group 740.png',
                                      fit: BoxFit.fill),
                                ),
                                Container(
                                    width: 50,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "accepted".tr(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )),
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
                                        widget.status == "accepted"
                                    // widget.status == "pickup item received" ||
                                    // widget.status == "Delivered to Receptionist"
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/defaulticon.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "deliveredtodepaturewarehouse"
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "deliveredtodepaturewarehouse"
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
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
                                        widget.status ==
                                            "delivered to Warehouse" ||
                                        widget.status == "accepted" ||
                                        widget.status == "assigned to agent" ||
                                        widget.status == "going to pickup" ||
                                        widget.status == "pickup done"
                                    // widget.status == "delivered to Warehouse" ||
                                    // widget.status == "pickup item received"
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/defaulticon.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "receviedproceedforshipment"
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              // print("-=-=-=-=-=-=-==-=$itemimage");
                                              // print("-=-=-=-=-=-=-==-=$comment");

                                              _displayShowImageCommentDialog3(
                                                  context);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: Image.asset(
                                                  'assets/images/Group 743.png',
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "receviedproceedforshipment"
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                              ],
                            ),
                          ],
                        ),
                      )),
            if (Responsive.isDesktop(context))
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
                          "Accepted",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 30),
                        child: Text(
                          "Delivered to Departure Warehouse",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 5),
                        child: Text(
                          "Recevied & Proceed for Shipment",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            widget.status == "Accepted" || widget.status == "accepted"
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Stack(children: [
                      InkWell(
                        onTap: () {
                          _openCamera(context);
                        },
                        child: Container(
                          width: 90.0,
                          height: 90.0,
                          margin: (Responsive.isDesktop(context))
                              ? const EdgeInsets.only(top: 12)
                              : const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Material(
                              borderRadius: BorderRadius.circular(200),
                              elevation: 10,
                              child: imagepath == ''
                                  ? Center(child: Icon(Icons.person))
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100)),
                                      child: Container(
                                          height: 90.0,
                                          width: 90.0,
                                          child: Image.network((imagepath),
                                              fit: BoxFit.cover)))),
                        ),
                      ),
                      Positioned(
                        left: (Responsive.isDesktop(context)) ? 50 : 52,
                        top: (Responsive.isDesktop(context)) ? 5 : 0,
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
                  )
                : SizedBox(),
            widget.status == "Accepted" || widget.status == "accepted"
                ? Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.only(top: 25)
                        : const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            print("in ontap ${widget.btype}");
                            if (widget.btype.toString() == "1") {
                              if (widget.status == "Accepted" ||
                                  widget.status == "accepted" ||
                                  widget.status == "delivered to Warehouse") {
                                if (_formkey.currentState!.validate()) {
                                  if (imagepath.isEmpty) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content:
                                            Text("Please upload the image"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                  if (_textFieldController.text.isEmpty) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: Text("Please Add Comment"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                }
                                _formkey.currentState!.save();

                                doMarketdropoffChangeStatus();
                              }
                            } else {
                              if (widget.status == "Accepted" ||
                                  widget.status == "accepted") {
                                // if (onTap == 0) {
                                //   _openCamera(context);
                                // } else {
                                if (_formkey.currentState!.validate()) {
                                  if (imagepath.isEmpty) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content:
                                            Text("Please upload the image"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                  if (_textFieldController.text.isEmpty) {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: Text("Please Add Comment"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                }
                                _formkey.currentState!.save();

                                doChangeStatus();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              top: 5,
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
                                                : widget.status ==
                                                        "pickup item received"
                                                    ? Color(0xff4CAF50)
                                                    : widget.status ==
                                                            "accepted"
                                                        ? Color(0xff4CAF50)
                                                        : Colors.grey),
                            height: (Responsive.isDesktop(context)) ? 45 : 35,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (30 / 100)
                                : MediaQuery.of(context).size.width *
                                    (15 / 100),
                            child: Center(
                                child: widget.status == "Accepted"
                                    ? (Responsive.isDesktop(context))
                                        ? Text("Update Status",
                                            style:
                                                TextStyle(color: Colors.white))
                                        : Text("Update Status",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))
                                    : widget.status == "delivered to Warehouse"
                                        ? (Responsive.isDesktop(context))
                                            ? Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.white))
                                            : Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10))
                                        : (Responsive.isDesktop(context))
                                            ? Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.white))
                                            : Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _displayTextInputDialog(context);

                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 25,
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.black),
                            height: (Responsive.isDesktop(context)) ? 45 : 35,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (30 / 100)
                                : MediaQuery.of(context).size.width *
                                    (15 / 100),
                            child: Center(
                              child: (Responsive.isDesktop(context))
                                  ? Text("Add Comment",
                                      style: TextStyle(color: Colors.white))
                                  : Text("Add Comment",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ),
                      ],
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}

class profileConfirm extends StatefulWidget {
  const profileConfirm({Key? key}) : super(key: key);

  @override
  _profileConfirmtate createState() => _profileConfirmtate();
}

class _profileConfirmtate extends State<profileConfirm>
    with TickerProviderStateMixin {
  // GifController? controller1;

  // @override
  // void initState() {
  //   controller1 = GifController(vsync: this);
  //   super.initState();
  // }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox2(context),
    );
  }

  contentBox2(context) {
    return Container(
        height: (Responsive.isDesktop(context)) ? 500 : h * 0.5,
        width: (Responsive.isDesktop(context)) ? 700 : w * 1.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
                child: Image.asset(
                  "assets/images/success.gif",
                ),
                height: MediaQuery.of(context).size.height * (20 / 100),
                width: MediaQuery.of(context).size.width * (20 / 100)),
            Center(
                child: (Responsive.isDesktop(context))
                    ? Text(
                        "Status has been Updated Successfully",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                            fontSize: 30),
                      )
                    : Text(
                        "Status has been Updated Successfully",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                            fontSize: 12),
                      )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: (Responsive.isDesktop(context))
                        ? Text(
                            "Status has been Changed , Now You Can Proceed For Next Step")
                        : Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "Status has been Changed , Now You Can Proceed For Next Step",
                              style: TextStyle(fontSize: 12),
                            ),
                          ))),
            // Center(
            //     child: Align(
            //         alignment: Alignment.center,
            //         child:
            //             Text("Ask Shishank to Reset password before login"))),
            SizedBox(
              height: MediaQuery.of(context).size.height * (5 / 100),
            ),
            GestureDetector(
              onTap: () async {
                // Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xff1A494F)),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.4,
                  // color: Colors.lime,
                  child: Center(
                      child: Text(
                    "Close",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
            ),
          ],
        ));
  }
}
