import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Accountant/accountantUpdateProfileModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturesearchtitlesssModel.dart';
import 'package:shipment/Model/PickupAgent/pickDashboardStausModel.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentDashboardModel.dart';
import 'package:shipment/Model/PickupAgent/pickupdashboardSearchStatusModel.dart';

import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/ContainerList.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';

import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/Notification/notification.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class PickupDashboard extends StatefulWidget {
  const PickupDashboard({Key? key}) : super(key: key);

  @override
  _PickupDashboardState createState() => _PickupDashboardState();
}

class _PickupDashboardState extends State<PickupDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  late AnimationController _controller;
  TextEditingController edit = new TextEditingController();

  var pickOrders, goingtopickup, comptorders, pickupdone, pendingorder;
  List<PickupDashData> pickupData = [];
  List<SearchD> searchDataresponse = [];
  List<PickupSearchStatusData> searchStatus = [];
  var id = [];
  var title = [];
  var item = [];
  var bookingdate = [];
  var arrivaldate = [];
  var bookingtype = [];
  var shipcompany = [];
  var itemImage = [];
  var Imagelist;
  bool isProcess = false;

  int? count;

  bool Iamhovering = false;
  bool Iamhovering1 = false;
  bool Iamhovering2 = false;
  bool Iamhovering3 = false;
  bool Iamhovering4 = false;
  bool Iamhovering5 = false;
  String _value = " ";
  bool selected = true;
  List<pickstatusData>? pstDta;
  String filter = 'All';
  String? scheduleId, pickupStatus;

  void _entering(PointerEvent details, int index) {
    setState(() {
      Iamhovering = false;
    });
  }

  void _entering1(PointerEvent details) {
    setState(() {
      Iamhovering1 = false;
    });
  }

  void _entering2(PointerEvent details) {
    setState(() {
      Iamhovering2 = false;
    });
  }

  void _entering3(PointerEvent details) {
    setState(() {
      Iamhovering3 = false;
    });
  }

  void _entering4(PointerEvent details) {
    setState(() {
      Iamhovering4 = false;
    });
  }

  void _entering5(PointerEvent details) {
    setState(() {
      Iamhovering5 = false;
    });
  }

  void _hovering(PointerEvent details, int index) {
    setState(() {
      Iamhovering = true;
    });
  }

  void _hovering1(PointerEvent details) {
    setState(() {
      Iamhovering1 = true;
    });
  }

  void _hovering2(PointerEvent details) {
    setState(() {
      Iamhovering2 = true;
    });
  }

  void _hovering3(PointerEvent details) {
    setState(() {
      Iamhovering3 = true;
    });
  }

  void _hovering4(PointerEvent details) {
    setState(() {
      Iamhovering4 = true;
    });
  }

  void _hovering5(PointerEvent details) {
    setState(() {
      Iamhovering5 = true;
    });
  }

  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];

  Widget _buildLoadingTwo() {
    return Stack(alignment: Alignment.center, children: [
      Image.network(
        'https://cdn.jsdelivr.net/gh/xdd666t/MyData@master/pic/flutter/blog/20211101162946.png',
        height: 50,
        width: 50,
      ),
      RotationTransition(
        alignment: Alignment.center,
        turns: _controller,
        child: Image.network(
          'https://cdn.jsdelivr.net/gh/xdd666t/MyData@master/pic/flutter/blog/20211101173708.png',
          height: 80,
          width: 80,
        ),
      ),
    ]);
  }

  searchfunction() async {
    var searchData = {
      "title": edit.text == null ? "" : edit.text.toString(),
      "stats": ""
    };

    final response = await Providers().searchPickupAgentStatus(searchData);
    if (response.status == true) {
      setState(() {
        searchStatus = response.data;
        MaterialPageRoute(builder: (context) => shipmentList2());
      });
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('ok'.tr()),
            ),
          ],
        ),
      );
    }
  }

  searchfunction1() async {
    var agentme = filter;
    if (agentme == "assigned to me") {
      agentme = "assigned to agent";
      print("-=-=-====$agentme");
    }

    var searchData = {"title": "", "stats": agentme.toString()};

    final response = await Providers().searchPickupAgentStatus(searchData);
    if (response.status == true) {
      setState(() {
        searchStatus = response.data;
        MaterialPageRoute(builder: (context) => shipmentList2());
      });
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: Text('ok'.tr()),
            ),
          ],
        ),
      );
    }
  }

  getStatus() async {
    var response = await Providers().getpickupdashboardStatus();
    print("-=-= status ${response.status}");
    if (response.status == true) {
      setState(() {
        pstDta = response.data;
      });
      //print(pstDta!.length);
      for (int i = 0; i < pstDta!.length; i++) {
        print("-=-=-=");
        print(pstDta![i]);
        pendingorder = pstDta![i].assignOrders.toString();
        pickOrders = pstDta![i].pickupOrders.toString();
        goingtopickup = pstDta![i].goingToPickup.toString();
        comptorders = pstDta![i].completedOrders.toString();
        pickupdone = pstDta![i].pickupDone.toString();
      }
      print("pstDta");
      print(pstDta);
    } else {
      setState(() {});
      pickOrders = 0;
      goingtopickup = 0;
      comptorders = 0;
      pickupdone = 0;
      pendingorder = 0;
    }
  }

  getPickupList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getpickupAgentDashboard();

    if (response.status == true) {
      setState(() {
        pickupData = response.data;
      });
      for (int i = 0; i < pickupData.length; i++) {
        scheduleId = pickupData[i].scheduleId;
        pickupStatus = pickupData[i].status;
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
    getNotificationCount();
    getStatus();
    getPickupList();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text('Do you want to exit App'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return (Responsive.isDesktop(context))
        ? Scaffold(
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
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              if (!Responsive.isDesktop(context))
                                IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                              if (!Responsive.isDesktop(context))
                                mobiletopBar(),
                              if (Responsive.isDesktop(context)) topBar(),
                              // SizedBox(width: 5),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(20, 10, 5, 0),
                              //   child: Text(
                              //     '',
                              //     style: TextStyle(
                              //         color: Colors.black,
                              //         fontSize: 22,
                              //         fontWeight: FontWeight.bold),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              Container(
                                height: 200,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    totalShipment(),
                                    usedMode(),
                                    estimateCharges()
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      "bookinglist".tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.teal,
                                                      width: 2.0)))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          DropdownButton<String>(
                                            hint: Text("selectstatus".tr()),
                                            value: filter,
                                            icon: Icon(Icons.arrow_drop_down),
                                            iconSize: 30,
                                            elevation: 16,
                                            style:
                                                TextStyle(color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                filter = newValue!;
                                              });
                                              if (filter == 'all'.tr()) {
                                                searchStatus = [];
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        shipmentList());
                                              } else {
                                                searchfunction1();
                                              }
                                            },
                                            items: <String>[
                                              'All',
                                              'going to pickup',
                                              'pickup done',
                                              'delivered to Warehouse',
                                              'assigned to me',
                                              'received by receptionist',
                                              'pickup item received',
                                              'Delivered to Receptionist'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // topBar()
                                  ],
                                ),
                              ),
                              mobileViewlist()
                            ],
                          ),
                        if (Responsive.isDesktop(context))
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  totalShipment(),
                                  usedMode(),
                                  estimateCharges(),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "bookinglist".tr(),
                                          style: headingStyle22blackw600(),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                          color: Colors.teal,
                                                          width: 2.0)))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              DropdownButton<String>(
                                                hint: Text("selectstatus".tr()),
                                                value: filter,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    filter = newValue!;
                                                  });
                                                  if (filter == 'all'.tr()) {
                                                    searchStatus = [];
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            shipmentList());
                                                  } else {
                                                    searchfunction1();
                                                  }
                                                },
                                                items: <String>[
                                                  'All',
                                                  'going to pickup',
                                                  'pickup done',
                                                  'delivered to Warehouse',
                                                  'assigned to me',
                                                  'received by receptionist',
                                                  'pickup item received',
                                                  'Delivered to Receptionist'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // topBar()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              shipmentList2()
                            ],
                          ),
                      ]),
                    ),
                  ))
        : WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                key: _scaffoldKey,
                drawer: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: PickupSideBar(),
                ),
                body: isProcess == true
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding:
                            EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                        color: Color(0xffE5E5E5),
                        child: SafeArea(
                          right: false,
                          child: ListView(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  if (!Responsive.isDesktop(context))
                                    IconButton(
                                      icon: Icon(Icons.menu),
                                      onPressed: () {
                                        _scaffoldKey.currentState!.openDrawer();
                                      },
                                    ),
                                  Container(
                                    margin: (Responsive.isDesktop(context))
                                        ? EdgeInsets.fromLTRB(20, 10, 5, 0)
                                        : EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    child: Text(
                                      'dashboard'.tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(width: 165),
                                  Container(
                                      // color: Colors.amber,
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PickupNotificationScreen()),
                                            );
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 5,
                                                ),
                                                child: Icon(
                                                  Icons.notifications,
                                                  size: 27,
                                                ),
                                              ),
                                              count != null
                                                  ? Positioned(
                                                      top: 10,
                                                      left: 11,
                                                      right: 0,
                                                      child: Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          color: Colors.red,
                                                          size: 12),
                                                    )
                                                  : Container()
                                            ],
                                          ))),
                                  // mobiletopBar(),

                                  if (Responsive.isDesktop(context)) topBar(),
                                  SizedBox(width: 5),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 10, 5, 0),
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!Responsive.isDesktop(context))
                              Column(
                                children: [
                                  mobiletopBar(),
                                  Container(
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        totalShipment(),
                                        usedMode(),
                                        estimateCharges()
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 15),
                                    child: Row(
                                      children: [
                                        Text(
                                          "bookinglist".tr(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                          color: Colors.teal,
                                                          width: 2.0)))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              DropdownButton<String>(
                                                hint: Text("selectstatus".tr()),
                                                value: filter,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    filter = newValue!;
                                                  });
                                                  if (filter == 'all'.tr()) {
                                                    searchStatus = [];
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            shipmentList());
                                                  } else {
                                                    searchfunction1();
                                                  }
                                                },
                                                items: <String>[
                                                  'All',
                                                  'going to pickup',
                                                  'pickup done',
                                                  'delivered to Warehouse',
                                                  'assigned to me',
                                                  'received by receptionist',
                                                  'pickup item received',
                                                  'Delivered to Receptionist'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // topBar()
                                      ],
                                    ),
                                  ),
                                  mobileViewlist()
                                ],
                              ),
                            if (Responsive.isDesktop(context))
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      totalShipment(),
                                      usedMode(),
                                      estimateCharges(),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "bookinglist".tr(),
                                              style: headingStyle22blackw600(),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.teal,
                                                              width: 2.0)))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  DropdownButton<String>(
                                                    hint: Text(
                                                        "selectstatus".tr()),
                                                    value: filter,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        filter = newValue!;
                                                      });
                                                      if (filter ==
                                                          'all'.tr()) {
                                                        searchStatus = [];
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                shipmentList());
                                                      } else {
                                                        searchfunction1();
                                                      }
                                                    },
                                                    items: <String>[
                                                      'All',
                                                      'going to pickup',
                                                      'pickup done',
                                                      'delivered to Warehouse',
                                                      'assigned to me',
                                                      'received by receptionist',
                                                      'pickup item received',
                                                      'Delivered to Receptionist'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // topBar()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  shipmentList2()
                                ],
                              ),
                          ]),
                        ),
                      )),
          );
  }

  Widget totalShipment() {
    return Padding(
      padding: (Responsive.isDesktop(context))
          ? EdgeInsets.all(32.0)
          : EdgeInsets.only(right: 20, left: 10),
      child: Container(
        height: (Responsive.isDesktop(context))
            ? 168
            : MediaQuery.of(context).size.height * (21 / 100),
        width: (Responsive.isDesktop(context))
            ? 300
            : MediaQuery.of(context).size.height * (28 / 100),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "totalpickupoders".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                      fontWeight: FontWeight.bold),
                  // style: headingStyleinter14blackw500(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "pickuporders".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 21 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                  Text(
                    (pickOrders.toString()),
                    style: (Responsive.isDesktop(context))
                        ? headingStyleinter40blackw500()
                        : headingStyleinter14blackw500(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 170
          : MediaQuery.of(context).size.height * (20 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (28 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: Text(
                "pickuporderstatus".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
                // style: headingStyleinter14blackw500(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              left: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : null,
                  child: Text(
                    "goingtopickuporders".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    goingtopickup.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : null,
                  child: Text(
                    "pickupdoneorders".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    pickupdone.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : null,
                  child: Text(
                    "pendingorders".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    pendingorder.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget estimateCharges() {
    return Container(
      margin: EdgeInsets.only(left: 25),
      height: (Responsive.isDesktop(context))
          ? 168
          : MediaQuery.of(context).size.height * (20 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (28 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("totalcompletedorder".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "completedorde".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  comptorders.toString(),
                  style: (Responsive.isDesktop(context))
                      ? headingStyleinter40blackw500()
                      : headingStyleinter14blackw500(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shipmentList2() {
    return pickupData.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchStatus.length == 0
                ? pickupData.length
                : searchStatus.length,
            shrinkWrap: true,
            reverse: false,
            itemBuilder: (context, index) {
              // print("index $index");
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: MouseRegion(
                  onEnter: (val) {
                    _entering(val, index);
                  },
                  onHover: (value) {
                    _hovering(value, index);
                  },
                  onExit: (val) {
                    _entering(val, -1);
                  },
                  child: Card(
                    color: Iamhovering == index
                        ? Color(0xffFFFFFF).withOpacity(1)
                        : Color(0xffFFFFFF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        print("-=-==--= ${pickupData[index].booking}");
                        var data1 = {
                          //  'bookinglength': pickupData[index].bookings,
                          for (int i = 0;
                              i < pickupData[index].booking.length;
                              i++)
                            for (int j = 0;
                                j <
                                    pickupData[index]
                                        .booking[i]
                                        .itemImage
                                        .length;
                                j++)
                              'itemimage1':
                                  pickupData[index].booking[i].itemImage,
                          for (int i = 0;
                              i < pickupData[index].booking.length;
                              i++)
                            'itemimage': pickupData[index]
                                .booking[i]
                                .itemImage
                                .toString(),
                          'transactionid':
                              pickupData[index].transactionId.toString(),
                          'totalamount':
                              pickupData[index].totalAmount.toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuptype': pickupData[index]
                                .pickupReview[i]
                                .pickupType
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuplocation': pickupData[index]
                                .pickupReview[i]
                                .pickupLocation
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupdate': pickupData[index]
                                .pickupReview[i]
                                .pickupDate
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuptime': pickupData[index]
                                .pickupReview[i]
                                .pickupTime
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupdistance': pickupData[index]
                                .pickupReview[i]
                                .pickupDistance
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupestimate': pickupData[index]
                                .pickupReview[i]
                                .pickupEstimate
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'name': pickupData[index]
                                .clientInfoData[i]
                                .name
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'lname': pickupData[index]
                                .clientInfoData[i]
                                .lname
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'email': pickupData[index]
                                .clientInfoData[i]
                                .email
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'phone': pickupData[index]
                                .clientInfoData[i]
                                .phone
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'address': pickupData[index]
                                .clientInfoData[i]
                                .address
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'country': pickupData[index]
                                .clientInfoData[i]
                                .country
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'clientStatus': pickupData[index]
                                .clientInfoData[i]
                                .status
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'clientid': pickupData[index]
                                .clientInfoData[i]
                                .id
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'profileimage': pickupData[index]
                                .clientInfoData[i]
                                .profileimage
                                .toString(),
                          'itemdetail': pickupData[index].booking,

                          'id': pickupData[index].id.toString(),
                          'title': pickupData[index].title.toString(),
                          'bookingdate':
                              pickupData[index].bookingDate.toString(),
                          'arrivaldate':
                              pickupData[index].arrivalDate.toString(),
                          'type': pickupData[index].bookingType.toString(),
                          'shipcmpany':
                              pickupData[index].shipmentCompany.toString(),
                          'status': pickupData[index].status.toString(),
                          'pickupitemimage':
                              pickupData[index].pickupItemimage.toString(),
                          'pickupcomment':
                              pickupData[index].pickupComment.toString(),
                          'pickupcomment1':
                              pickupData[index].pickupComment1.toString(),
                          'schedule_id': pickupData[index].scheduleId,
                          'pickupitemimage1':
                              pickupData[index].pickupItemimage1.toString(),
                        };
                        print("===========fhhjfhjdghghg" + data1.toString());

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContainerList(data1)));
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  tileMode: TileMode.clamp,
                                  colors: [
                                    Color(0xffFFCC00),
                                    Color(0xffFFDE17),
                                  ],
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width: 50,
                                child: Text(pickupData[index].id.toString()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 150,
                                  child: Text(searchStatus.length == 0
                                      ? pickupData[index].title.toString()
                                      : searchStatus[index].title.toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 80,
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 80,
                                      child: Text(pickupData[index]
                                          .bookingType
                                          .toString()),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_drop_down_rounded,
                                        size: 35,
                                        color: Iamhovering == index
                                            ? Color(0xff1A494F)
                                            : Color(0xffE5E5E5)),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                width: 200,
                                child: Text(pickupData[index].from +
                                    ' ' +
                                    "to".tr() +
                                    ' ' +
                                    pickupData[index].to),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 10),
                              child: Container(
                                height: 27,
                                width: 180,
                                color: searchStatus.length > 0
                                    ? searchStatus[index].status ==
                                            "going to pickup"
                                        ? Color(0xffFF3D00)
                                        : searchStatus[index].status ==
                                                "delivered to Warehouse"
                                            ? Colors.blue
                                            : searchStatus[index].status ==
                                                    "assigned to agent"
                                                ? Colors.green
                                                : searchStatus[index].status ==
                                                        "received by receptionist"
                                                    ? Colors.blue
                                                    : searchStatus[index]
                                                                .status ==
                                                            " pickup item received"
                                                        ? Colors.pink
                                                        : Colors.orangeAccent
                                    : pickupData[index].status ==
                                            "going to pickup"
                                        ? Color(0xffFF3D00)
                                        : pickupData[index].status ==
                                                "delivered to Warehouse"
                                            ? Colors.blue
                                            : pickupData[index].status ==
                                                    "assigned to agent"
                                                ? Colors.green
                                                : pickupData[index].status ==
                                                        "received by receptionist"
                                                    ? Colors.blue
                                                    : pickupData[index]
                                                                .status ==
                                                            "pickup item received"
                                                        ? Colors.pink
                                                        : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchStatus.length == 0
                                        ? pickupData[index].status ==
                                                "assigned to agent"
                                            ? "assigned to me"
                                            : pickupData[index].status
                                        : searchStatus[index].status ==
                                                "assigned to agent"
                                            ? "assigned to me"
                                            : searchStatus[index].status,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle12whitew500(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container(
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
                      'Sorry, You have not Schedule any Shipment yet',
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('Pickup_Agent_token');
    print("Token $authToken");
    var response =
        await Providers().getShipmentSubPanelNotificationCount(authToken);

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
  }

  Widget topBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(bottom: 0, top: 3, left: 30),
        height: 48,
        width: 400,
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
              searchfunction();
            },
            controller: edit,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    searchfunction();
                  });
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    shipmentList2();
                    searchStatus = [];
                    edit.clear();
                    searchStatus.removeLast();
                    // Widget build(BuildContext context)
                    // searchfunction();
                    MaterialPageRoute(builder: (context) => shipmentList());
                  });
                },
              ),
              hintText: "searchhere".tr(),
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
      SizedBox(
        width: w * 0.29,
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text("chooselanguage".tr()),
                value: dropdownvalue,
                dropdownColor: Colors.white,
                focusColor: Colors.white,
                // Down Arrow Icon

                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                  if (dropdownvalue == "English") {
                    context.locale = Locale("en", "US");
                  } else if (dropdownvalue == "French") {
                    context.locale = Locale("fr", "FR");
                  } else if (dropdownvalue == "Spanish") {
                    context.locale = Locale("es", "US");
                  }
                },
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      Container(
          // color: Colors.amber,
          child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PickupNotificationScreen()),
                );
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 5),
                    child: Icon(
                      Icons.notifications,
                      size: 38,
                    ),
                  ),
                  count != null
                      ? Positioned(
                          top: 10,
                          left: 25,
                          right: 0,
                          child: Icon(Icons.fiber_manual_record,
                              color: Colors.red, size: 12),
                        )
                      : Container()
                ],
              )))
    ]);
  }

  Widget mobiletopBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        margin: EdgeInsets.only(
          bottom: 10,
          top: 10,
          left: 10,
        ),
        height: 48,
        width: w * 0.50,
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
            right: 0,
          ),
          child: TextFormField(
            onFieldSubmitted: (value) {
              searchfunction();
            },
            controller: edit,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    searchfunction();
                  });
                },
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    shipmentList2();
                    searchStatus = [];
                    edit.clear();
                    searchStatus.removeLast();
                    // Widget build(BuildContext context)
                    // searchfunction();
                    MaterialPageRoute(builder: (context) => shipmentList());
                  });
                },
              ),
              hintText: "searchhere".tr(),
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
      SizedBox(
        width: w * 0.02,
      ),

      Container(
        margin: EdgeInsets.only(),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text("chooselanguage".tr()),
                value: dropdownvalue,
                dropdownColor: Colors.white,
                focusColor: Colors.white,
                // Down Arrow Icon

                icon: Icon(Icons.arrow_drop_down),
                iconSize: 30,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                  if (dropdownvalue == "English") {
                    context.locale = Locale("en", "US");
                  } else if (dropdownvalue == "French") {
                    context.locale = Locale("fr", "FR");
                  } else if (dropdownvalue == "Spanish") {
                    context.locale = Locale("es", "US");
                  }
                },
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      // Container(
      //     // color: Colors.amber,
      //     child: GestureDetector(
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => const PickupNotificationScreen()),
      //           );
      //         },
      //         child: Stack(
      //           children: [
      //             Container(
      //               margin: EdgeInsets.only(
      //                 top: 5,
      //                 bottom: 5,
      //               ),
      //               child: Icon(
      //                 Icons.notifications,
      //                 size: 27,
      //               ),
      //             ),
      //             count != null
      //                 ? Positioned(
      //                     top: 10,
      //                     left: 11,
      //                     right: 0,
      //                     child: Icon(Icons.fiber_manual_record,
      //                         color: Colors.red, size: 12),
      //                   )
      //                 : Container()
      //           ],
      //         )
      //         )
      //         )
    ]);
  }

  Widget ContainerListDialog({required int index, pickupData}) {
    return Container(
      height: h * 0.42,
      width: w * 0.38,
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
            padding: const EdgeInsets.only(left: 30, top: 10, bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Availability",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: pickupData[index].available.length,
              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3 / 1,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: (5 / 1)),
              itemBuilder: (context, index1) {
                return Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        height: 15,
                        width: 15,
                        child: Image.network(
                            "${pickupData[index].available[index1].icon}")),
                    // Spacer(),
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        child: Text(pickupData[index]
                            .available[index1]
                            .category
                            .toString())),
                    // Spacer(),
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        // decoration: BoxDecoration(
                        //     borderRadius:
                        //         BorderRadius.circular(50.0),
                        //     color: Color(0xffEFEFEF)),
                        child: Text(pickupData[index]
                            .available[index1]
                            .available
                            .toString())),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget shipmentList() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            "Shipment List",
            style: (Responsive.isDesktop(context))
                ? headingStyleinter40blackw500()
                : headingStyleinter14blackw500(),
          ),
        ),
        (Responsive.isDesktop(context))
            ? SizedBox(
                width: 30,
              )
            : Spacer(),
        Container(
          margin: EdgeInsets.only(right: 15),
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.teal, width: 2.0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'selectstatus'.tr(),
                  style: headingStyle14blackw400(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        "images/setting-3.png",
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
      ],
    );
  }

  Widget scheduleStatus() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff1A494F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.teal, width: 2.0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'scheduleshipment'.tr(),
                  style: headingStyleinter14whitew500(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        "images/Vector1.png",
                      ),
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          (Responsive.isDesktop(context))
              ? SizedBox(
                  width: 30,
                )
              : Spacer(),
          ElevatedButton(
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
                  '21.08.2021',
                  style: headingStyle12blackw500(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
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
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return pickupData.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchStatus.length == 0
                ? pickupData.length
                : searchStatus.length,
            shrinkWrap: true,
            reverse: true,
            // scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: MouseRegion(
                  onEnter: (val) {
                    _entering(val, index);
                  },
                  onHover: (value) {
                    _hovering(value, index);
                  },
                  onExit: (val) {
                    _entering(val, -1);
                  },
                  child: Card(
                    color: Iamhovering == index
                        ? Color(0xffFFFFFF).withOpacity(1)
                        : Color(0xffFFFFFF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        print("-=-==--= ${pickupData[index].booking}");
                        var data1 = {
                          //  'bookinglength': pickupData[index].bookings,
                          for (int i = 0;
                              i < pickupData[index].booking.length;
                              i++)
                            for (int j = 0;
                                j <
                                    pickupData[index]
                                        .booking[i]
                                        .itemImage
                                        .length;
                                j++)
                              'itemimage1':
                                  pickupData[index].booking[i].itemImage,
                          for (int i = 0;
                              i < pickupData[index].booking.length;
                              i++)
                            'itemimage': pickupData[index]
                                .booking[i]
                                .itemImage
                                .toString(),
                          'transactionid':
                              pickupData[index].transactionId.toString(),
                          'totalamount':
                              pickupData[index].totalAmount.toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuptype': pickupData[index]
                                .pickupReview[i]
                                .pickupType
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuplocation': pickupData[index]
                                .pickupReview[i]
                                .pickupLocation
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupdate': pickupData[index]
                                .pickupReview[i]
                                .pickupDate
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickuptime': pickupData[index]
                                .pickupReview[i]
                                .pickupTime
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupdistance': pickupData[index]
                                .pickupReview[i]
                                .pickupDistance
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].pickupReview.length;
                              i++)
                            'pickupestimate': pickupData[index]
                                .pickupReview[i]
                                .pickupEstimate
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'name': pickupData[index]
                                .clientInfoData[i]
                                .name
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'lname': pickupData[index]
                                .clientInfoData[i]
                                .lname
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'email': pickupData[index]
                                .clientInfoData[i]
                                .email
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'phone': pickupData[index]
                                .clientInfoData[i]
                                .phone
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'address': pickupData[index]
                                .clientInfoData[i]
                                .address
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'country': pickupData[index]
                                .clientInfoData[i]
                                .country
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'clientStatus': pickupData[index]
                                .clientInfoData[i]
                                .status
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'clientid': pickupData[index]
                                .clientInfoData[i]
                                .id
                                .toString(),
                          for (int i = 0;
                              i < pickupData[index].clientInfoData.length;
                              i++)
                            'profileimage': pickupData[index]
                                .clientInfoData[i]
                                .profileimage
                                .toString(),
                          'itemdetail': pickupData[index].booking,

                          'id': pickupData[index].id.toString(),
                          'title': pickupData[index].title.toString(),
                          'bookingdate':
                              pickupData[index].bookingDate.toString(),
                          'arrivaldate':
                              pickupData[index].arrivalDate.toString(),
                          'type': pickupData[index].bookingType.toString(),
                          'shipcmpany':
                              pickupData[index].shipmentCompany.toString(),
                          'status': pickupData[index].status.toString(),
                          'pickupitemimage':
                              pickupData[index].pickupItemimage.toString(),
                          'pickupcomment':
                              pickupData[index].pickupComment.toString(),
                          'pickupcomment1':
                              pickupData[index].pickupComment1.toString(),
                          'schedule_id': pickupData[index].scheduleId,
                          'pickupitemimage1':
                              pickupData[index].pickupItemimage1.toString(),
                        };
                        print("===========fhhjfhjdghghg" + data1.toString());

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContainerList(data1)));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => ResDashboardPickup(data1)));
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 15, bottom: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          tileMode: TileMode.clamp,
                                          colors: [
                                            Color(0xffFFCC00),
                                            Color(0xffFFDE17),
                                          ],
                                        )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width: 50,
                                        child: Text(
                                            pickupData[index].id.toString()),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(searchStatus.length == 0
                                            ? pickupData[index].title.toString()
                                            : searchStatus[index]
                                                .title
                                                .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        child: Text(
                                          pickupData[index]
                                              .bookingType
                                              .toString(),
                                          style: headingStyle16blackw400(),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                            Icons.arrow_drop_down_rounded,
                                            size: 35,
                                            color: Iamhovering == index
                                                ? Color(0xff1A494F)
                                                : Color(0xffE5E5E5)),
                                      )
                                    ],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(pickupData[index].from +
                                        ' ' +
                                        "to".tr() +
                                        ' ' +
                                        pickupData[index].to),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 12, right: 10),
                              child: Container(
                                height: 27,
                                width: MediaQuery.of(context).size.width,
                                color: searchStatus.length > 0
                                    ? searchStatus[index].status ==
                                            "going to pickup"
                                        ? Color(0xffFF3D00)
                                        : searchStatus[index].status ==
                                                "delivered to Warehouse"
                                            ? Colors.blue
                                            : searchStatus[index].status ==
                                                    "assigned to agent"
                                                ? Colors.green
                                                : searchStatus[index].status ==
                                                        "received by receptionist"
                                                    ? Colors.blue
                                                    : searchStatus[index]
                                                                .status ==
                                                            " pickup item received"
                                                        ? Colors.pink
                                                        : Colors.orangeAccent
                                    : pickupData[index].status ==
                                            "going to pickup"
                                        ? Color(0xffFF3D00)
                                        : pickupData[index].status ==
                                                "delivered to Warehouse"
                                            ? Colors.blue
                                            : pickupData[index].status ==
                                                    "assigned to agent"
                                                ? Colors.green
                                                : pickupData[index].status ==
                                                        "received by receptionist"
                                                    ? Colors.blue
                                                    : pickupData[index]
                                                                .status ==
                                                            "pickup item received"
                                                        ? Colors.pink
                                                        : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchStatus.length == 0
                                        ? pickupData[index].status ==
                                                "assigned to agent"
                                            ? "assigned to me"
                                            : pickupData[index].status
                                        : searchStatus[index].status ==
                                                "assigned to agent"
                                            ? "assigned to me"
                                            : searchStatus[index].status,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle12whitew500(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container(
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
                    SizedBox(height: 15),
                    Text(
                      'sorryouhavenotscheduleanyshipmentyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
