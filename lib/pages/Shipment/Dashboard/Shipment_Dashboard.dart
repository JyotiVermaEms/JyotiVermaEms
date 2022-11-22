import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/getShipmentStatsMode.dart';
import 'package:shipment/Model/Shipment/shipmentSchedulModel.dart';
import 'package:shipment/Model/Shipment/shipmentSearchModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/ResContainer_List.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_BroadCastMessage.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Notification.dart';
import 'package:shipment/component/Res_Shipment.dart/Review/ResReviewList.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/Dashboard/broadCastMessageScreen.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ShipmentDashboard extends StatefulWidget {
  const ShipmentDashboard({Key? key}) : super(key: key);

  @override
  _ShipmentDashboardState createState() => _ShipmentDashboardState();
}

class _ShipmentDashboardState extends State<ShipmentDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = TextEditingController();
  TextEditingController edit = new TextEditingController();
  var h, w;

  List<SearchData> searchDataresponse = [];

  var tShip, pShip, cShip, inShip, totalclient, packshipment;
  var id = [];
  String filter = 'All';
  int? count;

  var Iamhovering = -1;
  bool selected = true;
  List<Schedule>? scheduleData;
  List<StatsData>? stDta;
  var dropdown;
  bool isProcess = false;
  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];

  var date, planid;

  void _entering(
    PointerEvent details,
    index,
  ) {
    setState(() {
      Iamhovering = index;
    });
  }

  var statusList = [
    1,
    2,
    3,
    4,
    5,
  ];

  void _hovering(
    PointerEvent details,
    index,
  ) {
    setState(() {
      Iamhovering = index;
    });
  }

  var pendingshipent = [], progressShipment = [], completedshipment = [];

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

  getStatus() async {
    var response = await Providers().getShipmentStatus();

    if (response.status == true) {
      setState(() {
        stDta = response.data;
      });
      for (int i = 0; i < stDta!.length; i++) {
        tShip = stDta![i].totalSchedules;
        pShip = stDta![i].openSchedules;
        cShip = stDta![i].closedSchedules;
        inShip = stDta![i].inprogressSchedules;
        totalclient = stDta![i].totalClient;
        packshipment = stDta![i].packedSchedules;
      }
      print(stDta);
    } else {
      print("-=-=-=");
      setState(() {
        tShip = 0;
        pShip = 0;
        cShip = 0;
        inShip = 0;
        totalclient = 0;
        packshipment = 0;
      });
    }
  }

  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentProfile();

    if (response.status == true) {
      setState(() {
        date = response.data[0].expireDate;
        planid = response.data[0].planId;
      });
      // var expiredate = int.parse(date) - 3;
      // print("object$expiredate");

      final now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      // final expirationDate = DateFormat('yyyy-MM-dd').parse(date);
      final expirationDate = DateTime(2022, 06, 26);
      final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
      final String formatted1 = formatter.format(expirationDate);
      var firstDate = expirationDate.subtract(const Duration(days: 3));
      var secondDate = expirationDate.subtract(const Duration(days: 2));
      var ThirdDate = expirationDate.subtract(const Duration(days: 1));
      print("first date${firstDate.compareTo(now) == 0}");
      print("second date$secondDate");
      print("thired date$ThirdDate");
      if (firstDate.compareTo(now) == 0) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Scription will be expired "),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN2);
                },
                child: const Text('Reneval'),
              ),
            ],
          ),
        );
      } else {
        if (secondDate == now) {
          print("secondDate show here");
        } else if (ThirdDate == now) {
          print("third date show here");
        }
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  getShipmentList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getschedules();

    if (response.status == true) {
      setState(() {
        scheduleData = response.schedule;
      });
      for (int i = 0; i < scheduleData!.length; i++) {
        id.add(scheduleData![i].id.toString());
        scheduleData![i].status == "Open"
            ? pendingshipent.add(scheduleData![i].id.toString())
            : scheduleData![i].status == "closed"
                ? completedshipment.add(scheduleData![i].id.toString())
                : progressShipment.add(scheduleData![i].id.toString());
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  Widget ContainerListDialog({required int index, scheduleData}) {
    return Container(
      height: h * 0.55,
      width: w * 0.55,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SingleChildScrollView(
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
                  "availability".tr(),
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
                itemCount: scheduleData[index].itemType.length,
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 2 / 1,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: (5 / 1)),
                itemBuilder: (context, index1) {
                  var jsondata =
                      jsonDecode(scheduleData[index].itemType[index1].itemType);
                  print("jsondata>>>>$jsondata");
                  return Container(
                    height: h * 0.2,
                    child: Scrollbar(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Row(
                              children: List.generate(
                            jsondata.length,
                            (index) => Row(children: [
                              Container(
                                width: 180,
                                margin: EdgeInsets.only(left: 10, top: 5),
                                child: Text(
                                  jsondata[index]['c_name'].toString() + ":",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(left: 10, top: 5),
                                child: Text(
                                  jsondata[index]['name'].toString(),
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffEFEFEF)),
                                child: Text(
                                  jsondata[index]['item_quantity'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ]),
                          )),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget ContainerListDialog1({required int index, scheduleData}) {
    return Container(
      height: h * 0.55,
      width: w * 0.8,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
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
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "availability".tr(),
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
            height: h * 0.4,
            width: w * 0.7,
            child: GridView.builder(
                itemCount: scheduleData[index].itemType.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 2 / 1,
                    crossAxisSpacing: 1.0,
                    childAspectRatio: (3 / 1)),
                itemBuilder: (context, index1) {
                  var jsondata =
                      jsonDecode(scheduleData[index].itemType[index1].itemType);
                  print("jsondata>>>>$jsondata");
                  return Container(
                    height: h * 0.3,
                    width: w * 0.7,
                    child: Scrollbar(
                      child: ListView(
                          addRepaintBoundaries: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            Row(
                                children: List.generate(
                              jsondata.length,
                              (index) => Row(children: [
                                Container(
                                  width: 80,
                                  margin: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    jsondata[index]['c_name'].toString() + ":",
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 80,
                                  margin: EdgeInsets.only(left: 5, top: 5),
                                  child: Text(
                                    jsondata[index]['name'].toString(),
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color(0xffEFEFEF)),
                                  child: Text(
                                    jsondata[index]['item_quantity']
                                            .toString() +
                                        " ,",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                          ]),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipmentList();
    getStatus();
    getProfile();
    getNotificationcount();
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

  var _lastQuitTime;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return (!Responsive.isDesktop(context))
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              key: _scaffoldKey,
              drawer: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: ShipmentSidebar(),
              ),
              body: isProcess == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding:
                          EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                      color: Color(0xffE5E5E5),
                      child: SafeArea(
                          right: false,
                          child: ListView(
                            children: [
                              (Responsive.isDesktop(context))
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: Row(
                                        children: [
                                          if (!Responsive.isDesktop(context))
                                            IconButton(
                                              icon: Icon(Icons.menu),
                                              onPressed: () {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                            ),
                                          if (Responsive.isDesktop(context))
                                            topBar(),
                                          SizedBox(width: 5),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 5, 0),
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
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        children: [
                                          if (!Responsive.isDesktop(context))
                                            IconButton(
                                              icon: Icon(Icons.menu),
                                              onPressed: () {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                            ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Text(
                                              'Dashboard',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          topBar(),
                                        ],
                                      ),
                                    ),
                              if (!Responsive.isDesktop(context))
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10,
                                              top: 5,
                                              right: 10,
                                              left: 10),
                                          height: 48,
                                          width: w * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // set border color
                                                width: 2.0), // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0)), // set rounded corner radius
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
                                                      edit.clear();
                                                      searchDataresponse
                                                          .removeLast();

                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              shipmentList());
                                                    });
                                                  },
                                                ),
                                                hintText: "Search Here",
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: Colors.black),
                                              autofocus: true,
                                              onChanged: (val) {
                                                // title = val;
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, right: 8),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                DropdownButton<String>(
                                                  hint: Text(
                                                      "chooselanguage".tr()),
                                                  value: dropdownvalue,
                                                  dropdownColor: Colors.white,
                                                  focusColor: Colors.white,
                                                  // Down Arrow Icon

                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownvalue = newValue!;
                                                    });
                                                    if (dropdownvalue ==
                                                        "English") {
                                                      context.locale =
                                                          Locale("fr", "FR");
                                                    } else if (dropdownvalue ==
                                                        "French") {
                                                      context.locale =
                                                          Locale("fr", "US");
                                                    } else if (dropdownvalue ==
                                                        "Spanish") {
                                                      context.locale =
                                                          Locale("es", "US");
                                                    }
                                                  },
                                                  items:
                                                      items.map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 200,
                                      child: Scrollbar(
                                        isAlwaysShown: true,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            totalShipment(),
                                            usedMode(),
                                            estimateCharges()
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "shipmentlist".tr(),
                                                      style:
                                                          headingStyle22blackw600(),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
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
                                                                      color: Colors
                                                                          .teal,
                                                                      width:
                                                                          2.0)))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          DropdownButton<
                                                              String>(
                                                            hint: Text(
                                                                "selectstatus"
                                                                    .tr()),
                                                            value: filter,
                                                            icon: Icon(Icons
                                                                .arrow_drop_down),
                                                            iconSize: 30,
                                                            elevation: 16,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                filter =
                                                                    newValue!;
                                                              });
                                                              if (filter ==
                                                                  'All') {
                                                                searchDataresponse =
                                                                    [];

                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            shipmentList());
                                                              } else {
                                                                searchfunction1();
                                                              }
                                                            },
                                                            items: <String>[
                                                              'All',
                                                              'Open',
                                                              // 'Not Approved',
                                                              'InProgress',
                                                              'Packed',
                                                              'Closed'
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
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
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "shipmentlist".tr(),
                                                style:
                                                    headingStyle22blackw600(),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
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
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          filter = newValue!;
                                                        });
                                                        if (filter == 'All') {
                                                          searchDataresponse =
                                                              [];

                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  shipmentList());
                                                        } else {
                                                          searchfunction1();
                                                        }
                                                      },
                                                      items: <String>[
                                                        'All',
                                                        'Open',
                                                        // 'Not Approved',
                                                        'InProgress',
                                                        'Packed',
                                                        'Closed'
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Color(
                                                                  0xff1A494F)),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .teal,
                                                                  width: 2.0)))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const ResScheduleShipment()));
                                                        },
                                                        child: Text(
                                                          'scheduleshipment'
                                                              .tr(),
                                                          style:
                                                              headingStyleinter14whitew500(),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
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
                                                SizedBox(
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    shipmentList2()
                                  ],
                                )
                            ],
                          ))),
            ),
          )
        : WillPopScope(
            onWillPop: () async {
              return false;
              // if (_lastQuitTime == null ||
              //     DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
              //   print('Press again Back Button exit');
              //   Navigator.pop(context);
              //   return false;
              // }
            },
            child: Scaffold(
              key: _scaffoldKey,
              drawer: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: ShipmentSidebar(),
              ),
              body: isProcess == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding:
                          EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                      color: Color(0xffE5E5E5),
                      child: SafeArea(
                          right: false,
                          child: ListView(
                            children: [
                              (Responsive.isDesktop(context))
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: Row(
                                        children: [
                                          if (!Responsive.isDesktop(context))
                                            IconButton(
                                              icon: Icon(Icons.menu),
                                              onPressed: () {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                            ),
                                          if (Responsive.isDesktop(context))
                                            topBar(),
                                          SizedBox(width: 5),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 5, 0),
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
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Row(
                                        children: [
                                          if (!Responsive.isDesktop(context))
                                            IconButton(
                                              icon: Icon(Icons.menu),
                                              onPressed: () {
                                                _scaffoldKey.currentState!
                                                    .openDrawer();
                                              },
                                            ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 5, 0),
                                            child: Text(
                                              'Dashboard',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          topBar(),
                                        ],
                                      ),
                                    ),
                              if (!Responsive.isDesktop(context))
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10,
                                              top: 5,
                                              right: 10,
                                              left: 10),
                                          height: 48,
                                          width: w * 0.5,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // set border color
                                                width: 2.0), // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0)), // set rounded corner radius
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
                                                      edit.clear();
                                                      searchDataresponse
                                                          .removeLast();

                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              shipmentList());
                                                    });
                                                  },
                                                ),
                                                hintText: "Search Here",
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: Colors.black),
                                              autofocus: true,
                                              onChanged: (val) {
                                                // title = val;
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, right: 8),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                DropdownButton<String>(
                                                  hint: Text(
                                                      "chooselanguage".tr()),
                                                  value: dropdownvalue,
                                                  dropdownColor: Colors.white,
                                                  focusColor: Colors.white,
                                                  // Down Arrow Icon

                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownvalue = newValue!;
                                                    });
                                                    if (dropdownvalue ==
                                                        "English") {
                                                      context.locale =
                                                          Locale("en", "US");
                                                    } else if (dropdownvalue ==
                                                        "French") {
                                                      context.locale =
                                                          Locale("fr", "FR");
                                                    } else if (dropdownvalue ==
                                                        "Spanish") {
                                                      context.locale =
                                                          Locale("es", "US");
                                                    }
                                                  },
                                                  items:
                                                      items.map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 200,
                                      child: Scrollbar(
                                        isAlwaysShown: true,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            totalShipment(),
                                            usedMode(),
                                            estimateCharges()
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "shipmentlist".tr(),
                                                      style:
                                                          headingStyle22blackw600(),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
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
                                                                      color: Colors
                                                                          .teal,
                                                                      width:
                                                                          2.0)))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          DropdownButton<
                                                              String>(
                                                            hint: Text(
                                                                "selectstatus"
                                                                    .tr()),
                                                            value: filter,
                                                            icon: Icon(Icons
                                                                .arrow_drop_down),
                                                            iconSize: 30,
                                                            elevation: 16,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                filter =
                                                                    newValue!;
                                                              });
                                                              if (filter ==
                                                                  'All') {
                                                                searchDataresponse =
                                                                    [];

                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            shipmentList());
                                                              } else {
                                                                searchfunction1();
                                                              }
                                                            },
                                                            items: <String>[
                                                              'All',
                                                              'Open',
                                                              // 'Not Approved',
                                                              'InProgress',
                                                              'Packed',
                                                              'Closed'
                                                            ].map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
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
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "shipmentlist".tr(),
                                                style:
                                                    headingStyle22blackw600(),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
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
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 30,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          filter = newValue!;
                                                        });
                                                        if (filter == 'All') {
                                                          searchDataresponse =
                                                              [];

                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  shipmentList());
                                                        } else {
                                                          searchfunction1();
                                                        }
                                                      },
                                                      items: <String>[
                                                        'All',
                                                        'Open',
                                                        // 'Not Approved',
                                                        'InProgress',
                                                        'Packed',
                                                        'Closed'
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all(
                                                              Color(
                                                                  0xff1A494F)),
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .teal,
                                                                  width: 2.0)))),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const ResScheduleShipment()));
                                                        },
                                                        child: Text(
                                                          'scheduleshipment'
                                                              .tr(),
                                                          style:
                                                              headingStyleinter14whitew500(),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
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
                                                SizedBox(
                                                  width: 30,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    shipmentList2()
                                  ],
                                )
                            ],
                          ))),
            ),
          );
  }

  getNotificationcount() async {
    var response = await Providers().getShipmentNotificationCount();

    if (response.status == true) {
      setState(() {
        count = response.data;
      });

      print(response.data);
    }
  }

  searchfunction() async {
    var searchData = {
      "title": edit.text == null ? "" : edit.text.toString(),
      "stats": ""
    };

    final response = await Providers().searchShipment(searchData);
    if (response.status == true) {
      setState(() {
        searchDataresponse = response.data;
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
    var searchData = {"title": "", "stats": filter.toString()};

    final response = await Providers().searchShipment(searchData);
    if (response.status == true) {
      setState(() {
        searchDataresponse = response.data;
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

  Widget topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (Responsive.isDesktop(context))
          Container(
            margin: (Responsive.isDesktop(context))
                ? EdgeInsets.only(bottom: 0, top: 3, left: 30, right: 40)
                : EdgeInsets.only(
                    left: 5,
                  ),
            height: 48,
            width: (Responsive.isDesktop(context)) ? 400 : w * 0.5,
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
                        edit.clear();
                        searchDataresponse.removeLast();

                        MaterialPageRoute(builder: (context) => shipmentList());
                      });
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
        if (Responsive.isDesktop(context))
          SizedBox(
            width: w * 0.24,
          ),
        (Responsive.isDesktop(context))
            ? Container(
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
              )
            : (Responsive.isDesktop(context))
                ? SizedBox(
                    width: w * 0.24,
                  )
                : SizedBox(
                    width: w * 0.24,
                  ),
        (Responsive.isDesktop(context))
            ? Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ShipmentNotificationScreen()),
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
                              top: 5,
                              left: 25,
                              right: 0,
                              child: Icon(Icons.fiber_manual_record,
                                  color: Colors.red, size: 12),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            : Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ShipmentNotificationScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 75),
                        child: Icon(
                          Icons.notifications,
                          size: 27,
                        ),
                      ),
                      count != null
                          ? Positioned(
                              top: 5,
                              left: 85,
                              right: 0,
                              child: Icon(Icons.fiber_manual_record,
                                  color: Colors.red, size: 12),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Widget totalShipment() {
    return Container(
      margin: (Responsive.isDesktop(context))
          ? EdgeInsets.only(left: 20, right: 15)
          : EdgeInsets.only(left: 5, right: 15),
      height: (Responsive.isDesktop(context))
          ? 180
          : MediaQuery.of(context).size.height * (16 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (30 / 100),
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
                "totalshipment".tr(),
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
                  "shipments".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17),
                  // style: headingStyleinter14blackw500(),
                ),
                tShip != null
                    ? Text(
                        (tShip.toString()),
                        style: (Responsive.isDesktop(context))
                            ? headingStyleinter40blackw500()
                            : headingStyleinter14blackw500(),
                      )
                    : Text(""),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 180
          : MediaQuery.of(context).size.height * (21 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (30 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          // for (int i = 0; i < scheduleData!.length; i++)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 16),
              child: Text(
                "shipmentstatus".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
                // style: headingStyleinter14blackw500(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "pendingshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  pShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "inprogresshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  inShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                  // style: headingStyleinter14blackw500(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "completedshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  cShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                  // style: headingStyleinter14blackw500(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "packedshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  packshipment.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                  // style: headingStyleinter14blackw500(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget estimateCharges() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 10),
      height: (Responsive.isDesktop(context))
          ? 200
          : MediaQuery.of(context).size.height * (21 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (30 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("totalclients".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                      fontWeight: FontWeight.bold)
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
                  "clients".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  totalclient.toString(),
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

  Widget shipmentList() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            "shipmentlist".tr(),
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
                // topBar()
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
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResScheduleShipment()));
            },
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
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return scheduleData != null
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? scheduleData!.length
                : searchDataresponse.length,
            shrinkWrap: true,
            reverse: true,
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
                        var data = {
                          "id": id[index],
                        };

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResContainerList(data
                                    // Id: id.toString(),
                                    )));
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
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Text(
                                          searchDataresponse.length == 0
                                              ? scheduleData![index]
                                                  .title
                                                  .toString()
                                              : searchDataresponse[index]
                                                  .title
                                                  .toString(),
                                          style: headingStyle16blackw400(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: Text(
                                        // "Container list",
                                        searchDataresponse.length == 0
                                            ? scheduleData![index]
                                                .shipmentType
                                                .toString()
                                            : searchDataresponse[index]
                                                .shipmentType
                                                .toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            barrierColor: Colors.transparent,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: ContainerListDialog1(
                                                  scheduleData:
                                                      searchDataresponse
                                                                  .length ==
                                                              0
                                                          ? scheduleData
                                                          : searchDataresponse,
                                                  index: index,
                                                ),
                                              );
                                            });
                                      },
                                      icon: Icon(Icons.arrow_drop_down_rounded,
                                          size: 35,
                                          color: Iamhovering == index
                                              ? Color(0xff1A494F)
                                              : Color(0xffE5E5E5)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData![index].from +
                                            " To " +
                                            scheduleData![index].to
                                        : searchDataresponse[index].from +
                                            " To " +
                                            searchDataresponse[index].to,
                                    style: headingStyle16blackw400(),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  width: 100,
                                  color: searchDataresponse.length > 0
                                      ? searchDataresponse[index].status ==
                                              "Closed"
                                          ? Color(0xffFF3D00)
                                          : searchDataresponse[index].status ==
                                                  "Packed"
                                              ? Colors.blue
                                              : searchDataresponse[index]
                                                          .status ==
                                                      "Open"
                                                  ? Colors.green
                                                  : searchDataresponse[index]
                                                              .status ==
                                                          "InProgress"
                                                      ? Colors.orangeAccent
                                                      : Colors.orangeAccent
                                      : scheduleData![index].status == "Closed"
                                          ? Color(0xffFF3D00)
                                          : scheduleData![index].status ==
                                                  "Packed"
                                              ? Colors.blue
                                              : scheduleData![index].status ==
                                                      "Open"
                                                  ? Colors.green
                                                  : scheduleData![index]
                                                              .status ==
                                                          "InProgress"
                                                      ? Colors.orangeAccent
                                                      : Colors.orangeAccent,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? scheduleData![index].status
                                          : searchDataresponse[index].status,
                                      overflow: TextOverflow.ellipsis,
                                      style: headingStyle12whitew500(),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Color(0xffC4C4C4),
                                  ),
                                ),
                              ],
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
                      'sorryouhavenotscheduleanyshipmentyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget shipmentList2() {
    return scheduleData != null
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? scheduleData!.length
                : searchDataresponse.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
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
                        var data = {
                          "id": id[index],
                        };
                        print("-=-=-=-=-=-=$data");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResContainerList(data
                                    // Id: id.toString(),
                                    )));
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
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData![index].title.toString()
                                        : searchDataresponse[index]
                                            .title
                                            .toString(),
                                    style: headingStyle16blackw400(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 180,
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 120,
                                      child: Text(
                                        // "Container list",
                                        searchDataresponse.length == 0
                                            ? scheduleData![index]
                                                .shipmentType
                                                .toString()
                                            : searchDataresponse[index]
                                                .shipmentType
                                                .toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin: EdgeInsets.only(
                                                  left: 100,
                                                  // top: 250,
                                                  top: 190),
                                              child: AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: ContainerListDialog(
                                                  scheduleData:
                                                      searchDataresponse
                                                                  .length ==
                                                              0
                                                          ? scheduleData
                                                          : searchDataresponse,
                                                  index: index,
                                                ),
                                              ),
                                            );
                                          });
                                    },
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
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                width: 200,
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData![index].from +
                                          " To " +
                                          scheduleData![index].to
                                      : searchDataresponse[index].from +
                                          " To " +
                                          searchDataresponse[index].to,
                                  style: headingStyle16blackw400(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                height: 30,
                                width: 100,
                                color: searchDataresponse.length > 0
                                    ? searchDataresponse[index].status ==
                                            "Closed"
                                        ? Color(0xffFF3D00)
                                        : searchDataresponse[index].status ==
                                                "Packed"
                                            ? Colors.blue
                                            : searchDataresponse[index]
                                                        .status ==
                                                    "Open"
                                                ? Colors.green
                                                : searchDataresponse[index]
                                                            .status ==
                                                        "InProgress"
                                                    ? Colors.orangeAccent
                                                    : Colors.orangeAccent
                                    : scheduleData![index].status == "Closed"
                                        ? Color(0xffFF3D00)
                                        : scheduleData![index].status ==
                                                "Packed"
                                            ? Colors.blue
                                            : scheduleData![index].status ==
                                                    "Open"
                                                ? Colors.green
                                                : scheduleData![index].status ==
                                                        "InProgress"
                                                    ? Colors.orangeAccent
                                                    : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData![index].status
                                        : searchDataresponse[index].status,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle12whitew500(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                child: Icon(
                                  Icons.more_vert,
                                  color: Color(0xffC4C4C4),
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
