import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivalbookingModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalDashboardModel.dart';
import 'package:shipment/Model/PickupAgent/pickupchangeStatusModel.dart';
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

class ArrivalOrderManagement extends StatefulWidget {
  const ArrivalOrderManagement({Key? key}) : super(key: key);

  @override
  _ArrivalOrderManagementState createState() => _ArrivalOrderManagementState();
}

class _ArrivalOrderManagementState extends State<ArrivalOrderManagement>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  List<ArrivalBookingData> arrd = [];
  TabController? tabController;
  bool isProcess = false;
  var id = [];
  var pendingshipent = [], progressShipment = [], completedshipment = [];
  var bookingData = [];
  var exData = [];
  var exMData = [];
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
      for (int i = 0; i < arrd.length; i++) {}
    }
    setState(() {
      isProcess = false;
    });
  }

  List<ArrivalMArketData> marketPlaceOrder = [];
  List<ClientInfo>? clientinfo;
  getMArketPlaceList() async {
    var response = await Providers().ArrivalMarketOrderhistory();

    marketPlaceOrder = response.data;
    exMData = response.data;

    for (int i = 0; i < marketPlaceOrder.length; i++) {
      clientinfo = marketPlaceOrder[i].client;
    }
    setState(() {});
    log("jkkhkdkdkckdkck$marketPlaceOrder");
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
    var data = {"userId": UserId.toString(), "userToRole": userRole.toString()};
    var response = await Providers().getChatList(data);
    print("-=-=-=data ${data}");
    if (response.status == true) {
      print("-=-=-=response data ${response.data}");

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
    getArrivalList();
    getMArketPlaceList();
    getProfileDetails();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
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
                                  'booking'.tr(),
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
                                        child: arrd.length == 0
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        // Image.asset(
                                                        //   'assets/images/applogo.png',
                                                        //   height:
                                                        //       MediaQuery.of(context).size.height * 0.10,
                                                        // ),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
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
                                                ],
                                              ),
                                      ),
                                      SingleChildScrollView(
                                        child: marketPlaceOrder.length == 0
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        // Image.asset(
                                                        //   'assets/images/applogo.png',
                                                        //   height:
                                                        //       MediaQuery.of(context).size.height * 0.10,
                                                        // ),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
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
                                                "Order",
                                              ),
                                            ),
                                          ),
                                          Tab(
                                            child: Container(
                                              width: 200,
                                              child: Text(
                                                "Market Place Orders",
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
                                        child: arrd.length == 0
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'Sorry, You have not any Bookings yet',
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  // booking(),
                                                  MobileVieworderTemplate(),
                                                ],
                                              ),
                                      ),
                                      SingleChildScrollView(
                                        child: marketPlaceOrder.length == 0
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  // mbooking(),
                                                  MobileVieworderTemplate2(),
                                                ],
                                              ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                      ])),
                )),
    );
  }

  Widget booking() {
    return (Responsive.isDesktop(context))
        ? Container(
            height: 40,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
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
              width: w * 0.07,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: w * 0.08,
              margin: EdgeInsets.only(right: 8),
              child: Text(
                "scheduletitle".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.06,
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
              width: w * 0.10,
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: w * 0.06,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "chat".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
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
            margin: EdgeInsets.all(10),
            child: Row(
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
              ],
            ));
  }

  Widget orderDetails2() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: arrd.length,
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
                    width: w * 0.05,
                    child:
                        Text(arrd[index].bookingItem[0].bookingId.toString()),
                  ),
                  // SizedBox(
                  //   width: 12,
                  // ),
                  Container(
                    width: w * 0.08,
                    child: Text(arrd[index].bookingDate.toString()),
                  ),
                  // SizedBox(
                  //   width: 12,
                  // ),
                  Container(
                    width: w * 0.06,
                    child: Text(arrd[index].title.toString()),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: w * 0.08,
                    child: Text(arrd[index].from.toString()),
                  ),
                  // SizedBox(
                  //   width: 22,
                  // ),
                  Container(
                    width: w * 0.06,
                    child: Text(arrd[index].to.toString()),
                  ),
                  // SizedBox(
                  //   width: 25,
                  // ),
                  Container(
                    width: w * 0.08,
                    child: Text(arrd[index].shipmentCompany.toString()),
                  ),
                  GestureDetector(
                    onTap: () {
                      var id = arrd[index].id.toString();
                      var type = arrd[index].bookingType.toString();
                      var bookingdate = arrd[index].bookingDate.toString();
                      var status = arrd[index].status;
                      var schedulStatus = arrd[index].status.toString();
                      var itemimage = arrd[index].pickupItemimage.toString();
                      var comment = arrd[index].pickupComment1.toString();
                      var itemimage1 = arrd[index].pickupItemimage1.toString();
                      var comment1 = arrd[index].pickupComment1.toString();
                      var depatureimage = arrd[index].departureImage.toString();
                      var depaturecomment =
                          arrd[index].departureComment.toString();
                      var arrivalimage = arrd[index].arrivalImage.toString();
                      var arrivalcomment =
                          arrd[index].arrivalComment.toString();

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
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                    depatureimage,
                                    depaturecomment,
                                    arrivalimage,
                                    arrivalcomment,
                                    tabController!.index.toString(),
                                  ))
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxArrivalDropOff(
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
                                      arrivalcomment));
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 5),
                          height:
                              MediaQuery.of(context).size.height * (7 / 100),
                          width: w * 0.14,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          // width:
                          child: Center(
                            child: Text(
                              arrd[index].status,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      // print("UserId-=- $UserId");
                      // print("arrd[index].client.id-=- ${arrd[index].client.id}");
                      // print("arrd[index].receptionistId-=- ${arrd[index].receptionistId}");
                      // print(
                      //     "arrd[index].pickupagentId-=- ${arrd[index].pickupagentId}");
                      //     print(
                      //     "arrd[index].schedule[0].sid-=- ${arrd[index].schedule[0].sid}");

                      usersList.add(ChatUsers(UserId, "4"));
                      usersList.add(ChatUsers(arrd[index].client.id, "1c"));
                      usersList
                          .add(ChatUsers(arrd[index].receptionistId, "2r"));
                      var pikId = arrd[index].pickupagentId;
                      pikId != null ? pikId : '';
                      usersList.add(ChatUsers(pikId!, "5"));
                      usersList
                          .add(ChatUsers(arrd[index].schedule[0].sid, "1"));

                      usersList.add(ChatUsers(
                          int.parse(arrd[index].schedule[0].departureWarehouse),
                          "3"));

                      print("-=-= $chatListData");

                      int trendIndex = chatListData
                          .indexWhere((f) => f['name'] == arrd[index].id);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": arrd[index].title.toString(),
                        "firm_name": arrd[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": UserId.toString(),
                        "sid": arrd[index].schedule[0].id.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id": arrd[index].client.id, //other
                      };
                      print("-=-data11=- $data11");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 5),
                          height:
                              MediaQuery.of(context).size.height * (7 / 100),
                          width: w * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          // width:
                          child: Center(
                            child: Text(
                              "chat".tr(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                ],
              ));
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
                  "title".tr(),
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
            Container(
                width: w * 0.04,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "chat".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
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

  Widget marketOrderDetails() {
    return ListView.builder(
        itemCount: marketPlaceOrder.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          print("dhhfdghfghdf${marketPlaceOrder[index].status}");
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
                      child: Text(
                        marketPlaceOrder[index].bookingDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    margin: EdgeInsets.only(left: 20),
                    width: w * 0.08,
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
                                      sid: marketPlaceOrder[index].id,
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
                      width: w * 0.10,
                      child: Center(
                        child: Text(
                          clientinfo![0].name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                      width: w * 0.08,
                      child: Text(
                        marketPlaceOrder[index].marketStatus.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  GestureDetector(
                    onTap: () {
                      var id = marketPlaceOrder[index].mid.toString();
                      var type = marketPlaceOrder[index].dropoff.toString();
                      var bookingdate =
                          marketPlaceOrder[index].bookingDate.toString();
                      var status = marketPlaceOrder[index].status;
                      var schedulStatus =
                          marketPlaceOrder[index].marketStatus.toString();
                      var itemimage =
                          marketPlaceOrder[index].pickupItemimage.toString();
                      var comment =
                          marketPlaceOrder[index].pickupComment1.toString();
                      var itemimage1 =
                          marketPlaceOrder[index].pickupItemimage1.toString();
                      var comment1 =
                          marketPlaceOrder[index].pickupComment1.toString();
                      var depatureimage =
                          marketPlaceOrder[index].departureImage.toString();
                      var depaturecomment =
                          marketPlaceOrder[index].departureComment.toString();
                      var arrivalimage =
                          marketPlaceOrder[index].arrivalImage.toString();
                      var arrivalcomment =
                          marketPlaceOrder[index].arrivalComment.toString();

                      marketPlaceOrder[index].dropoff.toString() == "Pick up"
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxx(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                    depatureimage,
                                    depaturecomment,
                                    arrivalimage,
                                    arrivalcomment,
                                    tabController!.index.toString(),
                                  ))
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxArrivalDropOff(
                                    id,
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
                                    arrivalimage,
                                    arrivalcomment,
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
                      usersList.add(ChatUsers(UserId, "4"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].client[0].id, "1c"));
                      var pikId = marketPlaceOrder[index].pickupagentId;
                      pikId != 0 ? pikId : '';
                      usersList.add(ChatUsers(pikId, "5"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));

                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].departureId, "3"));

                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].receptionistId, "2r"));

                      print("-=-= $chatListData");

                      int trendIndex = chatListData.indexWhere(
                          (f) => f['name'] == marketPlaceOrder[index].id);
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
                        "sid": marketPlaceOrder[index].sid.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id":
                            marketPlaceOrder[index].client[0].id, //other
                      };
                      print("-=-data11=- $data11");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height:
                              MediaQuery.of(context).size.height * (7 / 100),
                          width: w * 0.08,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          // width:
                          child: Center(
                            child: Text(
                              "chat".tr(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: arrd.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: MediaQuery.of(context).size.height * (78 / 100),
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
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (46 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "orderid".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (35 / 100),
                        margin: EdgeInsets.only(top: 15, right: 5),
                        child: Text(
                          "status".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (37 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          arrd[index].bookingItem[0].bookingId.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {
                        var id = arrd[index].id.toString();
                        var type = arrd[index].bookingType.toString();
                        var bookingdate = arrd[index].bookingDate.toString();
                        var status = arrd[index].status;
                        var schedulStatus = arrd[index].status.toString();
                        var itemimage = arrd[index].pickupItemimage.toString();
                        var comment = arrd[index].pickupComment1.toString();
                        var itemimage1 =
                            arrd[index].pickupItemimage1.toString();
                        var comment1 = arrd[index].pickupComment1.toString();
                        var depatureimage =
                            arrd[index].departureImage.toString();
                        var depaturecomment =
                            arrd[index].departureComment.toString();
                        var arrivalimage = arrd[index].arrivalImage.toString();
                        var arrivalcomment =
                            arrd[index].arrivalComment.toString();

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
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                      depatureimage,
                                      depaturecomment,
                                      arrivalimage,
                                      arrivalcomment,
                                      tabController!.index.toString(),
                                    ))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxArrivalDropOff(
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
                                        arrivalcomment));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(right: 5),
                            height: 40,
                            width: w * 0.43,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // width:
                            child: Center(
                              child: Text(
                                arrd[index].status,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )),
                      ),
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
                          arrd[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(arrd[index].title.toString(),
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
                          softWrap: true,
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
                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];

                    usersList.add(ChatUsers(UserId, "4"));
                    usersList.add(ChatUsers(arrd[index].client.id, "1c"));
                    usersList.add(ChatUsers(arrd[index].receptionistId, "2r"));
                    var pikId = arrd[index].pickupagentId;
                    pikId != null ? pikId : '';
                    usersList.add(ChatUsers(pikId!, "5"));
                    usersList.add(ChatUsers(arrd[index].schedule[0].sid, "1"));

                    usersList.add(ChatUsers(
                        int.parse(arrd[index].schedule[0].departureWarehouse),
                        "3"));

                    print("-=-= $chatListData");

                    int trendIndex = chatListData
                        .indexWhere((f) => f['name'] == arrd[index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": arrd[index].title.toString(),
                      "firm_name": arrd[index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": arrd[index].schedule[0].id.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id": arrd[index].client.id, //other
                    };
                    print("-=-data11=- $data11");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(
                            right: 5, left: 5, top: 10, bottom: 20),
                        height: MediaQuery.of(context).size.height * (7 / 100),
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        child: Center(
                          child: Text(
                            "chat".tr(),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: marketPlaceOrder.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: MediaQuery.of(context).size.height * (45 / 100),
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
                          marketPlaceOrder[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {
                        var id = arrd[index].id.toString();
                        var type = arrd[index].bookingType.toString();
                        var bookingdate = arrd[index].bookingDate.toString();
                        var status = arrd[index].status;
                        var schedulStatus = arrd[index].status.toString();
                        var itemimage = arrd[index].pickupItemimage.toString();
                        var comment = arrd[index].pickupComment1.toString();
                        var itemimage1 =
                            arrd[index].pickupItemimage1.toString();
                        var comment1 = arrd[index].pickupComment1.toString();
                        var depatureimage =
                            arrd[index].departureImage.toString();
                        var depaturecomment =
                            arrd[index].departureComment.toString();
                        var arrivalimage = arrd[index].arrivalImage.toString();
                        var arrivalcomment =
                            arrd[index].arrivalComment.toString();

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
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                      depatureimage,
                                      depaturecomment,
                                      arrivalimage,
                                      arrivalcomment,
                                      tabController!.index.toString(),
                                    ))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxArrivalDropOff(
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
                                        arrivalcomment));
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                            margin: EdgeInsets.only(right: 5),
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // width:
                            child: Center(
                              child: Text(
                                marketPlaceOrder[index].marketStatus.toString(),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            )),
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
                          marketPlaceOrder[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
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
                                    child: AlertDialog(
                                      backgroundColor: Colors.white,
                                      content: ContainerListDialog(
                                          stitle: marketPlaceOrder[index].title,
                                          sid: marketPlaceOrder[index].id,
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
                          child: Text(marketPlaceOrder[index].title.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        )),
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
                        width: MediaQuery.of(context).size.width * (35 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          clientinfo![0].name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {
                        var id = marketPlaceOrder[index].mid.toString();
                        var type = marketPlaceOrder[index].dropoff.toString();
                        var bookingdate =
                            marketPlaceOrder[index].bookingDate.toString();
                        var status = marketPlaceOrder[index].status;
                        var schedulStatus =
                            marketPlaceOrder[index].marketStatus.toString();
                        var itemimage =
                            marketPlaceOrder[index].pickupItemimage.toString();
                        var comment =
                            marketPlaceOrder[index].pickupComment1.toString();
                        var itemimage1 =
                            marketPlaceOrder[index].pickupItemimage1.toString();
                        var comment1 =
                            marketPlaceOrder[index].pickupComment1.toString();
                        var depatureimage =
                            marketPlaceOrder[index].departureImage.toString();
                        var depaturecomment =
                            marketPlaceOrder[index].departureComment.toString();
                        var arrivalimage =
                            marketPlaceOrder[index].arrivalImage.toString();
                        var arrivalcomment =
                            marketPlaceOrder[index].arrivalComment.toString();

                        print("itemimage---------------$itemimage");
                        print("comment---------------$comment");
                        print("itemimage1---------------$itemimage1");
                        print("comment1---------------$comment1");
                        print("depatureimage---------------$depatureimage");
                        print("depaturecomment---------------$depaturecomment");
                        print("arrivalimage---------------$arrivalimage");
                        print("arrivalcomment---------------$arrivalcomment");

                        marketPlaceOrder[index].dropoff.toString() == "Pick up"
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxx(
                                      id,
                                      type,
                                      bookingdate,
                                      status,
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                      depatureimage,
                                      depaturecomment,
                                      arrivalimage,
                                      arrivalcomment,
                                      tabController!.index.toString(),
                                    ))
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxArrivalDropOff(
                                      id,
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
                                      arrivalimage,
                                      arrivalcomment,
                                    ));
                      },
                      child: Container(
                          width: w * 0.32,
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
                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(UserId, "4"));
                    usersList.add(
                        ChatUsers(marketPlaceOrder[index].client[0].id, "1c"));
                    var pikId = marketPlaceOrder[index].pickupagentId;
                    pikId != 0 ? pikId : '';
                    usersList.add(ChatUsers(pikId, "5"));
                    usersList.add(ChatUsers(marketPlaceOrder[index].sid, "1"));

                    usersList.add(
                        ChatUsers(marketPlaceOrder[index].departureId, "3"));

                    usersList.add(ChatUsers(
                        marketPlaceOrder[index].receptionistId, "2r"));

                    print("-=-= $chatListData");

                    int trendIndex = chatListData.indexWhere(
                        (f) => f['name'] == marketPlaceOrder[index].id);
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
                      "sid": marketPlaceOrder[index].sid.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id":
                          marketPlaceOrder[index].client[0].id, //other
                    };
                    print("-=-data11=- $data11");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(
                            right: 5, left: 5, top: 10, bottom: 20),
                        height: MediaQuery.of(context).size.height * (7 / 100),
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        child: Center(
                          child: Text(
                            "chat".tr(),
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget ContainerListDialog1({h, w}) {
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
                    "boatplaceship".tr(),
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
  var btype;
  var type;
  var bookingdate;
  var status;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  var arrivalimage;
  var arrivalcomment;
  CustomDialogBoxArrivalDropOff(
    this.id,
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
    this.arrivalimage,
    this.arrivalcomment,
  );
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
  TextEditingController _textFieldController = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('addyourcomment'.tr()),
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
                      child: Text('cancel'.tr(),
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
                      'addcomment'.tr(),
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
                          height: 300,
                          width: 300,
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

  Future<void> _displayShowImageCommentDialog4(BuildContext context) async {
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
                  child: widget.arrivalimage != null
                      ? Container(
                          child: Image.network(
                            widget.arrivalimage,
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
                          height: 300,
                          width: 300,
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
                  child: Text(widget.arrivalcomment),
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
      "booking_id": widget.id.toString(),
      "booking_status": "Delivered to Receptionist",
      "schedule_status": "",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeArrivalStatus(depatureData);
    if (response.status == true) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
    }
  }

  List<MarketStatusData> mrkchangedata = [];
  domarketChangeStatus() async {
    var depatureData = {
      "market_id": widget.id.toString(),
      "market_status": "Delivered to Receptionist",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeMarketArrivalStatus(depatureData);
    if (response.status == true) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
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
              height: (Responsive.isDesktop(context)) ? 120 : 158,
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
                              widget.status == "Accepted"
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
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "delivered to Warehouse"
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
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
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
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received"
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
                                        _displayShowImageCommentDialog4(
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
                        child: ListView(
                          scrollDirection: Axis.horizontal,
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
                                    width: 90,
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
                                widget.status == "Accepted"
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
                                              width: 80,
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
                                              width: 90,
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
                                        widget.status ==
                                            "delivered to Warehouse"
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 10),
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/defaulticon.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 90,
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
                                                  EdgeInsets.only(right: 10),
                                              child: Image.asset(
                                                  'assets/images/Group 742.png',
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Container(
                                              width: 90,
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
                                        widget.status ==
                                            "delivered to Warehouse" ||
                                        widget.status == "pickup item received"
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 10),
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/defaulticon.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "deliveredtoreceptionist".tr(),
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
                                              _displayShowImageCommentDialog4(
                                                  context);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Image.asset(
                                                  'assets/images/Group 743.png',
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "deliveredtoreceptionist".tr(),
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
            widget.status == "pickup item received"
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
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                  )
                : SizedBox(),
            widget.status == "pickup item received"
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.btype.toString() == "1") {
                              if (widget.status == "pickup item received") {
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

                                domarketChangeStatus();
                                // }
                              }
                            } else {
                              if (widget.status == "pickup item received") {
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
                                                ? Colors.grey
                                                : widget.status ==
                                                        "pickup item received"
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
                                        ? Text("assigntoagent".tr(),
                                            style:
                                                TextStyle(color: Colors.white))
                                        : Text("assigntoagent".tr(),
                                            style:
                                                TextStyle(color: Colors.white))
                                    : widget.status == "going to pickup"
                                        ? (Responsive.isDesktop(context))
                                            ? Text("updatestatus".tr(),
                                                style: TextStyle(
                                                    color: Colors.black))
                                            : Text("updatestatus".tr(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10))
                                        : widget.status == "pickup done"
                                            ? (Responsive.isDesktop(context))
                                                ? Text("updatestatus".tr(),
                                                    style: TextStyle(
                                                        color: Colors.black))
                                                : Text("updatestatus".tr(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10))
                                            : widget.status ==
                                                    "delivered to Warehouse"
                                                ? (Responsive.isDesktop(
                                                        context))
                                                    ? Text("updatestatus".tr(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                    : Text("updatestatus".tr(),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10))
                                                : widget.status ==
                                                        "pickup item received"
                                                    ? (Responsive.isDesktop(
                                                            context))
                                                        ? Text(
                                                            "updatestatus".tr(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                        : Text(
                                                            "updatestatus".tr(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10))
                                                    : Text("updatestatus".tr(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _displayTextInputDialog(context);
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
                                    ? Text("addcomment".tr(),
                                        style: TextStyle(color: Colors.white))
                                    : Text("addcomment".tr(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10))),
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
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
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

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreArrivalDashboard()));
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
