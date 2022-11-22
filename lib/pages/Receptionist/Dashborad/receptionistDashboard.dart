import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';

import 'package:shipment/Model/DepatureWareHouseManager/depaturesearchtitlesssModel.dart';

import 'package:shipment/Model/PickupAgent/pickupAgentDashboardModel.dart';
import 'package:shipment/Model/PickupAgent/pickupdashboardSearchStatusModel.dart';
import 'package:shipment/Model/Receptionist/getReceptionistSearchModel.dart';
import 'package:shipment/Model/Receptionist/getReceptionistorderstatsmodel.dart';
import 'package:shipment/Model/Receptionist/receptionistBookingModel.dart';
import 'package:shipment/Model/imageModel.dart';

import 'package:shipment/Provider/Provider.dart';

import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page.dart';

import 'package:shipment/pages/Receptionist/Dashborad/alertdialog.dart';
import 'package:shipment/pages/Receptionist/Notification/notification.dart';

import '../../../constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;

class ReceptionistDashboard extends StatefulWidget {
  const ReceptionistDashboard({Key? key}) : super(key: key);

  @override
  _ReceptionistDashboard createState() => _ReceptionistDashboard();
}

class _ReceptionistDashboard extends State<ReceptionistDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  late AnimationController _controller;
  TextEditingController edit = new TextEditingController();

  var totalOrder, assignOrder, deliverdepature, deliverArrival, completeOrder;

  List<ReceptionistSearchData> searchDataresponse = [];

  List<ReceptionistBookingData> bookingData = [];
  bool isProcess = false;
  var id = [];
  var title = [];
  var item = [];
  var bookingdate = [];
  var arrivaldate = [];
  var bookingtype = [];
  var shipcompany = [];
  var itemImage = [];
  var Imagelist;
  int? count;

  bool Iamhovering = false;
  bool Iamhovering1 = false;
  bool Iamhovering2 = false;
  bool Iamhovering3 = false;
  bool Iamhovering4 = false;
  bool Iamhovering5 = false;
  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];
  String _value = " ";
  bool selected = true;
  List<receptStatsdData>? respstatsDta;
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

    final response = await Providers().searchReceptionistStatus(searchData);
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  searchfunction1() async {
    var searchData = {"title": "", "stats": filter.toString()};

    final response = await Providers().searchReceptionistStatus(searchData);
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
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('receptionist_token');
    print("Token $authToken");
    var response =
        await Providers().getClientSubPanelNotificationCount(authToken);

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
  }

  getStatus() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getReceptionistdashboardStatus();

    if (response.status == true) {
      setState(() {
        respstatsDta = response.data;
      });
      for (int i = 0; i < respstatsDta!.length; i++) {
        totalOrder = respstatsDta![i].totalOrders.toString();
        assignOrder = respstatsDta![i].assignOrders.toString();
        deliverdepature = respstatsDta![i].deliverToDeparture.toString();
        deliverArrival = respstatsDta![i].deliverToArrival.toString();
        completeOrder = respstatsDta![i].completedOrders.toString();
      }
      print(respstatsDta);
    } else {
      setState(() {});
      totalOrder = 0;
      assignOrder = 0;
      deliverdepature = 0;
      deliverArrival = 0;
      completeOrder = 0;
    }
    setState(() {
      isProcess = false;
    });
  }

  Future getBooking() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getReceptionistBooking();
    if (response.status == true) {
      setState(() {
        bookingData = response.data;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    // id =   response.user[universityList.indexOf(name)].id
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
    getBooking();

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
                  'Select Status',
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
                  'Schedule Shipment'.tr(),
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
                    searchDataresponse = [];
                    edit.clear();
                    searchDataresponse.removeLast();
                    // Widget build(BuildContext context)
                    // searchfunction();
                    MaterialPageRoute(builder: (context) => shipmentList());
                  });
                },
              ),
              hintText: "Search Here".tr(),
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
        width: w * 0.19,
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
                hint: Text("Choose Language"),
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
                      builder: (context) =>
                          const ReceptionistNotificationScreen()),
                );
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 5),
                    child: Icon(
                      Icons.notifications,
                      size: 38,
                    ),
                  ),
                  count != null
                      ? Positioned(
                          top: 4,
                          left: 20,
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
        margin: EdgeInsets.only(bottom: 10, top: 3, left: 25),
        height: 48,
        width: w * 0.48,
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
                    searchDataresponse = [];
                    edit.clear();
                    searchDataresponse.removeLast();
                    // Widget build(BuildContext context)
                    // searchfunction();
                    MaterialPageRoute(builder: (context) => shipmentList());
                  });
                },
              ),
              hintText: "Search Here".tr(),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black,fontSize:12),
            autofocus: true,
            onChanged: (val) {
              // title = val;
            },
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10, left: 10),
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              DropdownButton<String>(
                hint: Text("Choose Language"),
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
    ]);
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
    return (!Responsive.isDesktop(context))
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                key: _scaffoldKey,
                drawer: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: ReceptionSidebar(),
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
                                  Container(
                                    margin: (Responsive.isDesktop(context))
                                        ? EdgeInsets.fromLTRB(5, 5, 5, 0)
                                        : EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      'dashboard'.tr(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (Responsive.isDesktop(context)) topBar(),
                                  if (!Responsive.isDesktop(context))
                                    Container(
                                      child: Text(
                                        // 'Dashboard',
                                        "",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  if (!Responsive.isDesktop(context))
                                    SizedBox(
                                      width: w * 0.35,
                                    ),
                                  if (!Responsive.isDesktop(context))
                                    Container(
                                        // color: Colors.amber,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ReceptionistNotificationScreen()),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Icon(
                                                    Icons.notifications,
                                                    size: 27,
                                                  ),
                                                ),
                                                count != null
                                                    ? Positioned(
                                                        top: 7,
                                                        left: 18,
                                                        right: 0,
                                                        child: Icon(
                                                            Icons
                                                                .fiber_manual_record,
                                                            color: Colors.red,
                                                            size: 12),
                                                      )
                                                    : Container()
                                              ],
                                            )))
                                ],
                              ),
                            ),
                            if (!Responsive.isDesktop(context))
                              Column(
                                children: [
                                  mobiletopBar(),
                                  Container(
                                    margin: EdgeInsets.only(left: 25),
                                    height: h * 0.25,
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
                                        left: 20, top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Booking List".tr(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
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
                                                        "Select Status".tr()),
                                                    value: filter,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    // underline: Container(
                                                    //   height: 2,
                                                    //   color: Colors.black,
                                                    // ),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        filter = newValue!;
                                                      });
                                                      if (filter == "All") {
                                                        searchDataresponse = [];
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
                                                      'received by receptionist',
                                                      'pickup item received',
                                                      'delivered to Warehouse',
                                                      'assigned to agent',
                                                      'Accepted',
                                                      'Confirmed',
                                                      'Cancelled'
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
                                              "Booking List".tr(),
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
                                                        "Select Status".tr()),
                                                    value: filter,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    // underline: Container(
                                                    //   height: 2,
                                                    //   color: Colors.black,
                                                    // ),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        filter = newValue!;
                                                      });
                                                      if (filter == "All") {
                                                        searchDataresponse = [];
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
                                                      'received by receptionist',
                                                      'pickup item received',
                                                      'delivered to Warehouse',
                                                      'assigned to agent',
                                                      'Accepted',
                                                      'Confirmed',
                                                      'Cancelled'
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
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: ReceptionSidebar(),
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
                              Container(
                                margin: (Responsive.isDesktop(context))
                                    ? EdgeInsets.fromLTRB(5, 5, 5, 0)
                                    : EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'dashboard'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (Responsive.isDesktop(context)) topBar(),
                              if (!Responsive.isDesktop(context))
                                Container(
                                  child: Text(
                                    // 'Dashboard',
                                    "",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              if (!Responsive.isDesktop(context))
                                SizedBox(
                                  width: w * 0.26,
                                ),
                              if (!Responsive.isDesktop(context))
                                Container(
                                    // color: Colors.amber,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ReceptionistNotificationScreen()),
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 5, bottom: 5),
                                              child: Icon(
                                                Icons.notifications,
                                                size: 27,
                                              ),
                                            ),
                                            count != null
                                                ? Positioned(
                                                    top: 7,
                                                    left: 18,
                                                    right: 0,
                                                    child: Icon(
                                                        Icons
                                                            .fiber_manual_record,
                                                        color: Colors.red,
                                                        size: 12),
                                                  )
                                                : Container()
                                          ],
                                        )))
                            ],
                          ),
                        ),
                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              mobiletopBar(),
                              Container(
                                margin: EdgeInsets.only(left: 25),
                                height: h * 0.25,
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
                                    const EdgeInsets.only(left: 20, top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Booking List".tr(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
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
                                                hint:
                                                    Text("Select Status".tr()),
                                                value: filter,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                // underline: Container(
                                                //   height: 2,
                                                //   color: Colors.black,
                                                // ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    filter = newValue!;
                                                  });
                                                  if (filter == "All") {
                                                    searchDataresponse = [];
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
                                                  'received by receptionist',
                                                  'pickup item received',
                                                  'delivered to Warehouse',
                                                  'assigned to agent',
                                                  'Accepted',
                                                  'Confirmed',
                                                  'Cancelled'
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
                                          "Booking List".tr(),
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
                                                hint:
                                                    Text("Select Status".tr()),
                                                value: filter,
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                // underline: Container(
                                                //   height: 2,
                                                //   color: Colors.black,
                                                // ),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    filter = newValue!;
                                                  });
                                                  if (filter == "All") {
                                                    searchDataresponse = [];
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
                                                  'received by receptionist',
                                                  'pickup item received',
                                                  'delivered to Warehouse',
                                                  'assigned to agent',
                                                  'Accepted',
                                                  'Confirmed',
                                                  'Cancelled'
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
                  ));
  }

  Widget totalShipment() {
    return Padding(
      padding: (Responsive.isDesktop(context))
          ? const EdgeInsets.all(32.0)
          : const EdgeInsets.only(right: 10.0),
      child: Container(
        height: (Responsive.isDesktop(context))
            ? 168
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
                  child: (Responsive.isDesktop(context))
                      ? Text(
                          "totalorders".tr(),
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                          // style: headingStyleinter14blackw500(),
                        )
                      : Text(
                          "totalorders".tr(),
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          // style: headingStyleinter14blackw500(),
                        )),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "orders".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 21 : 17),
                    // style: headingStyleinter14blackw500(),
                  ),
                  totalOrder != null
                      ? Text(
                          (totalOrder.toString()),
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
      ),
    );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 170
          : MediaQuery.of(context).size.height * (10 / 100),
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
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: Text(
                "orderstatus".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
                // style: headingStyleinter14blackw500(),
              ),
            ),
          ),

          Padding(
            padding: (Responsive.isDesktop(context))
                ? const EdgeInsets.only(top: 10, left: 20, right: 20)
                : const EdgeInsets.only(top: 10, left: 8, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : w * 0.3,
                  child: Text(
                    "assigntoagent".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
                Padding(
                  padding: (Responsive.isDesktop(context))
                      ? EdgeInsets.only(left: 35)
                      : EdgeInsets.only(left: 10),
                  child: Text(
                    assignOrder.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: (Responsive.isDesktop(context))
                ? const EdgeInsets.only(left: 20)
                : const EdgeInsets.only(left: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : w * 0.3,
                  child: Text(
                    "deliveredtodepature".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
                Padding(
                  padding: (Responsive.isDesktop(context))
                      ? const EdgeInsets.only(left: 50)
                      : const EdgeInsets.only(left: 38),
                  child: Text(
                    deliverdepature.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: (Responsive.isDesktop(context)) ? 200 : w * 0.3,
                  child: Text(
                    "deliveredtoarrival".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
                Padding(
                  padding: (Responsive.isDesktop(context))
                      ? const EdgeInsets.only(left: 50)
                      : const EdgeInsets.only(left: 35),
                  child: Text(
                    deliverArrival.toString(),
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
          : MediaQuery.of(context).size.height * (50 / 100),
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
              padding: (Responsive.isDesktop(context))
                  ? const EdgeInsets.all(16.0)
                  : const EdgeInsets.all(9.0),
              child: Text("totalcompletedorder".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 18,
                      fontWeight: FontWeight.bold)
                  // style: headingStyleinter14blackw500(),
                  ),
            ),
          ),
          // Text(
          //   "Clients",
          //   style: TextStyle(fontSize: 21),
          //   // style: headingStyleinter14blackw500(),
          // ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "completedorde".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  completeOrder.toString(),
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

  Widget orderTemplate() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * (76 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
        // color: Colors.red
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "scheduletitle".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
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
              width: MediaQuery.of(context).size.width * (15 / 100),
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

  Widget shipmentList2() {
    return bookingData != null
        ? Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: ListView.builder(
                itemCount: searchDataresponse.length == 0
                    ? bookingData.length
                    : searchDataresponse.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * (75 / 100),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),
                    child: InkWell(
                      onTap: () {
                        print(">>>>>>>>" +
                            bookingData[index].item.length.toString());
                        //return;
                        var data1 = {
                          "id": bookingData[index].id,
                          for (int i = 0;
                              i < bookingData[index].item.length;
                              i++)
                            'itemimage1': bookingData[index].item[i].itemImage,
                          for (int i = 0;
                              i < bookingData[index].item.length;
                              i++)
                            'itemdetail': bookingData[index].item,

                          'transactionid':
                              bookingData[index].transactionId.toString(),
                          'totalamount':
                              bookingData[index].totalAmount.toString(),
                          'pickuptype': bookingData[index]
                              .pickupReview[0]
                              .pickupType
                              .toString(),
                          'pickuplocation': bookingData[index]
                              .pickupReview[0]
                              .pickupLocation
                              .toString(),
                          'pickupdate': bookingData[index]
                              .pickupReview[0]
                              .pickupDate
                              .toString(),
                          'pickuptime': bookingData[index]
                              .pickupReview[0]
                              .pickupTime
                              .toString(),
                          'pickupdistance': bookingData[index]
                              .pickupReview[0]
                              .pickupDistance
                              .toString(),
                          'pickupestimate': bookingData[index]
                              .pickupReview[0]
                              .pickupEstimate
                              .toString(),
                          'name': bookingData[index].arrival[0].name.toString(),
                          'lname':
                              bookingData[index].arrival[0].lname.toString(),
                          'email':
                              bookingData[index].arrival[0].email.toString(),
                          'Id': bookingData[index].arrival[0].id.toString(),
                          'profileimage': bookingData[index]
                              .arrival[0]
                              .profileimage
                              .toString(),
                          'phone':
                              bookingData[index].arrival[0].phone.toString(),
                          'address':
                              bookingData[index].arrival[0].address.toString(),
                          'country':
                              bookingData[index].arrival[0].country.toString(),
                          'status':
                              bookingData[index].arrival[0].status.toString(),
                          'company': bookingData[index]
                              .arrival[0]
                              .companyname
                              .toString(),
                          // 'id': arrd[index].id.toString(),
                          'title': bookingData[index].title.toString(),
                          'bookingdate':
                              bookingData[index].bookingDate.toString(),
                          'arrivaldate':
                              bookingData[index].arrivalDate.toString(),
                          'type': bookingData[index].bookingType.toString(),
                          'schedule_id': bookingData[index].scheduleId,
                          'shipcmpany':
                              bookingData[index].shipmentCompany.toString()
                        };
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReceptionistDetail(data1
                                    //  Id: id.toString(),
                                    )));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                margin: EdgeInsets.only(left: 30),
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? bookingData[index].id.toString()
                                      : searchDataresponse[index].id.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // Spacer(),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),

                                // margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  (DateFormat('yyy-MM-dd')
                                      .format(DateTime.parse(
                                    searchDataresponse.length == 0
                                        ? bookingData[index]
                                            .bookingDate
                                            .toString()
                                        : searchDataresponse[index]
                                            .bookingDate
                                            .toString(),
                                  ))),
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                )),

                            Container(
                              width: MediaQuery.of(context).size.width *
                                  (20 / 100),
                              child: InkWell(
                                onTap: () {
                                  log(bookingData[index].shipmentCompany);
                                  log(bookingData[index].id.toString());
                                  log(bookingData[index].to.toString());
                                  log(bookingData[index].from.toString());

                                  log(bookingData[index].bookingType);

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
                                                dialogid: bookingData[index].id,
                                                dailogbookingtype:
                                                    bookingData[index]
                                                        .bookingType,
                                                dailogfrom:
                                                    bookingData[index].from,
                                                dialogto: bookingData[index].to,
                                                dailogshipmentCompany:
                                                    bookingData[index]
                                                        .shipmentCompany),
                                          ),
                                        );
                                      });
                                },
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? bookingData[index].title.toString()
                                      : searchDataresponse[index]
                                          .title
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xff1A494F)),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        var id =
                                            bookingData[index].id.toString();
                                        var type = bookingData[index]
                                            .bookingType
                                            .toString();
                                        var bookingdate = bookingData[index]
                                            .bookingDate
                                            .toString();
                                        var status = bookingData[index].status;
                                        var itemimage = bookingData[index]
                                            .pickupItemimage
                                            .toString();
                                        var comment = bookingData[index]
                                            .pickupComment
                                            .toString();
                                        var itemimage1 = bookingData[index]
                                            .pickupItemimage1
                                            .toString();
                                        var comment1 = bookingData[index]
                                            .pickupComment1
                                            .toString();
                                        var depatureimage = bookingData[index]
                                            .departureImage
                                            .toString();
                                        var depaturecomment = bookingData[index]
                                            .departureComment
                                            .toString();
                                        var arrivalimage = bookingData[index]
                                            .arrivalImage
                                            .toString();
                                        var arrivalcomment = bookingData[index]
                                            .arrivalComment
                                            .toString();
                                        var receptionistimage =
                                            bookingData[index]
                                                .receptionistImage
                                                .toString();
                                        var receptionistcomment =
                                            bookingData[index]
                                                .receptionistComment
                                                .toString();

                                        var schedulStatus = bookingData[index]
                                            .status
                                            .toString();
                                        bookingData[index]
                                                    .pickupReview[0]
                                                    .pickupType ==
                                                "Pick up"
                                            ? showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialogBoxReceptionist(
                                                        id,
                                                        type,
                                                        bookingdate,
                                                        status,
                                                        bookingData[index]
                                                            .pickupReview[0]
                                                            .pickupType
                                                            .toString(),
                                                        '',
                                                        itemimage,
                                                        comment,
                                                        itemimage1,
                                                        comment1,
                                                        depatureimage,
                                                        depaturecomment,
                                                        arrivalimage,
                                                        arrivalcomment,
                                                        receptionistimage,
                                                        receptionistcomment))
                                            : showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    CustomDialogBoxDropOff(
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
                                                        arrivalcomment,
                                                        receptionistimage,
                                                        receptionistcomment));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              right: 5, bottom: 2),
                                          height: MediaQuery.of(context).size.height *
                                              (3.59 / 100),
                                          width: w * 0.13,
                                          decoration: BoxDecoration(
                                              color: searchDataresponse.length >
                                                      0
                                                  ? searchDataresponse[index]
                                                              .status ==
                                                          "going to pickup"
                                                      ? Color(0xffFF3D00)
                                                      : searchDataresponse[index]
                                                                  .status ==
                                                              "delivered to Warehouse"
                                                          ? Colors.blue
                                                          : searchDataresponse[index]
                                                                      .status ==
                                                                  "assigned to agent"
                                                              ? Colors.green
                                                              : searchDataresponse[index].status ==
                                                                      "received by receptionist"
                                                                  ? Colors
                                                                      .purple
                                                                  : searchDataresponse[index].status ==
                                                                          "pickup item received"
                                                                      ? Colors
                                                                          .pink
                                                                      : Colors
                                                                          .orangeAccent
                                                  : bookingData[index].status ==
                                                          "going to pickup"
                                                      ? Color(0xffFF3D00)
                                                      : bookingData[index].status ==
                                                              "delivered to Warehouse"
                                                          ? Colors.blue
                                                          : bookingData[index]
                                                                      .status ==
                                                                  "assigned to agent"
                                                              ? Colors.green
                                                              : bookingData[index].status == "received by receptionist"
                                                                  ? Colors.purple
                                                                  : bookingData[index].status == "pickup item received"
                                                                      ? Colors.pink
                                                                      : Colors.orangeAccent,
                                              borderRadius: BorderRadius.all(Radius.circular(20))),
                                          // width:
                                          child: Center(
                                            child: Text(
                                              searchDataresponse.length == 0
                                                  ? bookingData[index].status
                                                  : searchDataresponse[index]
                                                      .status,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ),
                  );
                }),
          )
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

  Widget ContainerListDialog(
      {String? dailogbookingtype,
      int? dialogid,
      String? dailogfrom,
      String? dialogto,
      String? dailogshipmentCompany}) {
    print("object $dailogbookingtype");
    return Container(
      height: h * 0.45,
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
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text(
                    "Booking Id",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    dialogid.toString(),
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
                    "Company Name",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    dailogshipmentCompany.toString(),
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
                    // bookingtype.toString(),
                    "Booking Type",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    // viewbooking![index].bookingType,
                    dailogbookingtype.toString(),
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
                  child: Text(dailogfrom.toString(), style: headingStyle16MB()),
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
                  child: Text(dialogto.toString(), style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return bookingData.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? bookingData.length
                : searchDataresponse.length,
            shrinkWrap: true,

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
                      onTap: () {},
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
                                            bookingData[index].id.toString()),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Text(
                                            searchDataresponse.length == 0
                                                ? bookingData[index]
                                                    .title
                                                    .toString()
                                                : searchDataresponse[index]
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
                                          bookingData[index]
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
                                    child: Text(bookingData[index].from +
                                        ' ' +
                                        "to".tr() +
                                        ' ' +
                                        bookingData[index].to),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                var id = bookingData[index].id.toString();
                                var type =
                                    bookingData[index].bookingType.toString();
                                var bookingdate =
                                    bookingData[index].bookingDate.toString();
                                var status = bookingData[index].status;
                                var itemimage = bookingData[index]
                                    .pickupItemimage
                                    .toString();
                                var comment =
                                    bookingData[index].pickupComment.toString();
                                var itemimage1 = bookingData[index]
                                    .pickupItemimage1
                                    .toString();
                                var comment1 = bookingData[index]
                                    .pickupComment1
                                    .toString();
                                var depatureimage = bookingData[index]
                                    .departureImage
                                    .toString();
                                var depaturecomment = bookingData[index]
                                    .departureComment
                                    .toString();
                                var arrivalimage =
                                    bookingData[index].arrivalImage.toString();
                                var arrivalcomment = bookingData[index]
                                    .arrivalComment
                                    .toString();
                                var receptionistimage = bookingData[index]
                                    .receptionistImage
                                    .toString();
                                var receptionistcomment = bookingData[index]
                                    .receptionistComment
                                    .toString();

                                var schedulStatus =
                                    bookingData[index].status.toString();
                                bookingData[index].pickupReview[0].pickupType ==
                                        "Pick up"
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialogBoxReceptionist(
                                                id,
                                                type,
                                                bookingdate,
                                                status,
                                                bookingData[index]
                                                    .pickupReview[0]
                                                    .pickupType
                                                    .toString(),
                                                '',
                                                itemimage,
                                                comment,
                                                itemimage1,
                                                comment1,
                                                depatureimage,
                                                depaturecomment,
                                                arrivalimage,
                                                arrivalcomment,
                                                receptionistimage,
                                                receptionistcomment))
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CustomDialogBoxDropOff(
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
                                                arrivalcomment,
                                                receptionistimage,
                                                receptionistcomment));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 12, right: 10),
                                child: Container(
                                  height: 27,
                                  width: MediaQuery.of(context).size.width,
                                  color: searchDataresponse.length > 0
                                      ? searchDataresponse[index].status ==
                                              "going to pickup"
                                          ? Color(0xffFF3D00)
                                          : searchDataresponse[index].status ==
                                                  "delivered to Warehouse"
                                              ? Colors.blue
                                              : searchDataresponse[index]
                                                          .status ==
                                                      "assigned to agent"
                                                  ? Colors.green
                                                  : searchDataresponse[index]
                                                              .status ==
                                                          "received by receptionist"
                                                      ? Colors.purple
                                                      : searchDataresponse[
                                                                      index]
                                                                  .status ==
                                                              "pickup item received"
                                                          ? Colors.pink
                                                          : Colors.orangeAccent
                                      : bookingData[index].status ==
                                              "going to pickup"
                                          ? Color(0xffFF3D00)
                                          : bookingData[index].status ==
                                                  "delivered to Warehouse"
                                              ? Colors.blue
                                              : bookingData[index].status ==
                                                      "assigned to agent"
                                                  ? Colors.green
                                                  : bookingData[index].status ==
                                                          "received by receptionist"
                                                      ? Colors.purple
                                                      : bookingData[index]
                                                                  .status ==
                                                              "pickup item received"
                                                          ? Colors.pink
                                                          : Colors.orangeAccent,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? bookingData[index].status ==
                                                  "assigned to agent"
                                              ? "assigned to me"
                                              : bookingData[index].status
                                          : searchDataresponse[index].status ==
                                                  "assigned to agent"
                                              ? "assigned to me"
                                              : searchDataresponse[index]
                                                  .status,
                                      overflow: TextOverflow.ellipsis,
                                      style: headingStyle12whitew500(),
                                    ),
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

//======dialog
class CustomDialogBoxReceptionist extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status;
  var pickupType;
  var btype;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  var arrivalimage;
  var arrivalcomment;
  var receptionistimage;
  var receptionistcomment;

  CustomDialogBoxReceptionist(
    this.id,
    this.type,
    this.bookingdate,
    this.status,
    this.pickupType,
    this.btype,
    this.itemimage,
    this.comment,
    this.itemimage1,
    this.comment1,
    this.depatureimage,
    this.depaturecomment,
    this.arrivalimage,
    this.arrivalcomment,
    this.receptionistimage,
    this.receptionistcomment,
  );
  @override
  _CustomDialogBoxReceptionist createState() => _CustomDialogBoxReceptionist();
}

class _CustomDialogBoxReceptionist extends State<CustomDialogBoxReceptionist> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<ArrivalChangeStatusData> arrivalchangedata = [];
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Image? image;
  String getImage = '';
  TextEditingController _textFieldController = TextEditingController();

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
                            Text('Take a picture'),
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

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.id.toString(),
      "booking_status": "received by receptionist",
      "receptionist_image": jsonEncode(imagepath),
      "comment": _textFieldController.text
      // "booking_id": widget.id.toString(),
      // "booking_status": "received by receptionist",
    };

    print(depatureData);
    //return;

    var response = await Providers().changeReceptionistStatus(depatureData);
    if (response.status == true) {
      setState(() {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => profileConfirm(),
        //     ));
        showDialog(
            context: context,
            builder: (BuildContext context) => profileConfirm());
      });
    }
  }

  doMrktChangeStatus() async {
    var depatureData = {
      "market_id": widget.id.toString(),
      "market_status": "received by receptionist",
      "receptionist_image": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response =
        await Providers().changeMarketReceptionistStatus(depatureData);
    if (response.status == true) {
      setState(() {
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

  Future<void> _displayShowImageCommentDialog1(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        print("first face-----${widget.itemimage}");
        print("first face commet-----${widget.comment}");
        print("second google-----${widget.itemimage1}");
        print("second google comment-----${widget.comment1}");
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
                  child: widget.itemimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.itemimage),
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
                  child: Text(widget.comment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog2(BuildContext context) async {
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
                  child: widget.itemimage1 != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.itemimage1),
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
                  child: Text(widget.comment1),
                )),
              ),
            ]),
          ),
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
                            jsonDecode(widget.depatureimage),
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
                            jsonDecode(widget.arrivalimage),
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
                  child: Text(widget.arrivalcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog5(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 500.0 : 350,
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
                  child: widget.receptionistimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.receptionistimage),
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
                  child: Text(widget.receptionistcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
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
        height: (Responsive.isDesktop(context)) ? h * 0.9 : h * 1.9,
        width: w * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Order tracking" + "  " + widget.id,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              (Responsive.isDesktop(context))
                  ? SizedBox(
                      width: 290,
                    )
                  : SizedBox(
                      width: w * 0.12,
                    ),
              (Responsive.isDesktop(context))
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 370),
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
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
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
            ]),
            Container(
              height: (Responsive.isDesktop(context)) ? 120 : 157,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffE5E5E5),
                // color: Colors.amber
              ),
              child: Column(
                children: [
                  (Responsive.isDesktop(context))
                      ? Row(
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
                            Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 40, top: 20),
                                child: Text(
                                  "Booking Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10, top: 20),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  "Shipped VIA",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // Spacer(),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(right: 10, top: 20),
                                child: Text(
                                  "Booking Date",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                  (Responsive.isDesktop(context))
                      ? Row(
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
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  widget.type,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 110,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.status,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(right: 10, top: 10),
                                child: Text(
                                  widget.bookingdate,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: (Responsive.isDesktop(context))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            widget.status == "Confirmed"
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
                                    widget.status == "accepted" ||
                                    widget.status == "Confirmed"
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
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "Confirmed"
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
                                  ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                              // margin: EdgeInsets.only(right: 10),
                              // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Divider(
                            color: Color(0xff4CAF50),
                            height: 36,
                          )),
                        ),
                        Column(
                          children: [
                            widget.status == "Accepted" ||
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,

                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog1(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      // margin: EdgeInsets.only(left: 10, right: 10),
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
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog2(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      // margin: EdgeInsets.only(left: 10, right: 10),
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
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog3(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      // margin: EdgeInsets.only(left: 10, right: 10),
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
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog4(context);
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
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status ==
                                        "Delivered to Receptionist" ||
                                    widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog5(context);
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
                      height: h * 0.22,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              Column(children: [
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
                                      "Accepted",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ]),
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
                                  ? Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      ),
                                      // Spacer(),
                                      Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Assign to Agent",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ])
                                  : Column(children: [
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
                                            "Assign to Agent",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ]),
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
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "Assign To Agent"
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
                                              "Going to Pickup",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(children: [
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
                                            "Going to Pickup",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ]),
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
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Pickup done",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog1(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(left: 20),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Pickup done",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered Tto Departure Warehouse",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog2(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered Tto Departure Warehouse",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "Assign To Agent"
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
                                              "Received & Proceed for Shipment ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog3(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Received & Proceed for Shipment ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
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
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received"
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
                                              "Delivered to Receptionist ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // print("-=-=-=-=-=-=-==-=$itemimage");
                                            // print("-=-=-=-=-=-=-==-=$comment");

                                            _displayShowImageCommentDialog4(
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
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered to Receptionist ",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                            ],
                          ),
                          Column(
                            children: [
                              widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received" ||
                                      widget.status ==
                                          "Delivered to Receptionist"
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
                                              "Received by Receptionist",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // print("-=-=-=-=-=-=-==-=$itemimage");
                                            // print("-=-=-=-=-=-=-==-=$comment");

                                            _displayShowImageCommentDialog5(
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
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Received by Receptionist",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            if (Responsive.isDesktop(context))
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "Accepted",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "Assign to Agent",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "Going to Pickup",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          "Pickup Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 30),
                        child: Text(
                          "Delivered to Depature Warehouse",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 5),
                        child: Text(
                          "Recevied & Proceed for Shipment",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 5),
                        child: Text(
                          "Delivered to Receptionist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: 100,
                        // margin: EdgeInsets.only(right: 5),
                        child: Text(
                          "Received by Receptionist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            widget.status == "Delivered to Receptionist"
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
                              ? const EdgeInsets.only(top: 10)
                              : const EdgeInsets.only(top: 5),
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
                        left: (Responsive.isDesktop(context)) ? 50 : 60,
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
            widget.status == "Delivered to Receptionist"
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            print(widget.status);
                            if (widget.btype.toString() == "1") {
                              if (widget.status ==
                                  "Delivered to Receptionist") {
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

                                doMrktChangeStatus();
                              }
                            } else {
                              if (widget.status ==
                                  "Delivered to Receptionist") {
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
                                                ? Colors.grey
                                                : widget.status ==
                                                        "pickup item received"
                                                    ? Colors.grey
                                                    : widget.status ==
                                                            "Delivered to Receptionist"
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
                                        ? Text("Assign To Agent",
                                            style:
                                                TextStyle(color: Colors.white))
                                        : Text("Assign To Agent",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))
                                    : widget.status == "going to pickup"
                                        ? (Responsive.isDesktop(context))
                                            ? Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black))
                                            : Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10))
                                        : widget.status == "pickup done"
                                            ? (Responsive.isDesktop(context))
                                                ? Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black))
                                                : Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10))
                                            : widget.status ==
                                                    "delivered to Warehouse"
                                                ? (Responsive.isDesktop(
                                                        context))
                                                    ? Text("Update Status",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                    : Text("Update Status",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10))
                                                : widget.status ==
                                                        "pickup item received"
                                                    ? (Responsive.isDesktop(
                                                            context))
                                                        ? Text("Update Status",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                        : Text("Update Status",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10))
                                                    : widget.status ==
                                                            "Delivered to Receptionist"
                                                        ? (Responsive.isDesktop(
                                                                context))
                                                            ? Text(
                                                                "Update Status",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white))
                                                            : Text(
                                                                "Update Status",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10))
                                                        : (Responsive.isDesktop(context))
                                                            ? Text("Update Status", style: TextStyle(color: Colors.white))
                                                            : Text("Update Status", style: TextStyle(color: Colors.white, fontSize: 10))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _displayTextInputDialog(context);
                            // Navigator.pop(context);
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

class CustomDialogBoxDropOff extends StatefulWidget {
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
  var receptionistimage;
  var receptionistcomment;
  CustomDialogBoxDropOff(
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
    this.receptionistimage,
    this.receptionistcomment,
  );
  @override
  _CustomDialogBoxDropOff createState() => _CustomDialogBoxDropOff();
}

class _CustomDialogBoxDropOff extends State<CustomDialogBoxDropOff> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<ArrivalChangeStatusData> arrivalchangedata = [];
  TextEditingController _textFieldController = TextEditingController();
  Image? image;
  String getImage = '';
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                            Text('Take a picture'),
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

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.id.toString(),
      "booking_status": "received by receptionist",
      "schedule_status": "",
      "receptionist_image": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeReceptionistStatus(depatureData);
    if (response.status == true) {
      // setState(() {
      //   arrivalchangedata = response.data;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());

      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PreReceptionistDashboard(),
      //       ));
      // });
    }
  }

  doMrktChangeStatus() async {
    var depatureData = {
      "market_id": widget.id.toString(),
      "market_status": "received by receptionist",
      "receptionist_image": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response =
        await Providers().changeMarketReceptionistStatus(depatureData);
    if (response.status == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
      // setState(() {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => profileConfirm(),
      //       ));
      // });
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

    print(imagepath.toString());
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
                            jsonDecode(widget.depatureimage),
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
                            jsonDecode(widget.arrivalimage),
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
                  child: Text(widget.arrivalcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog5(BuildContext context) async {
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
                  child: widget.receptionistimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.receptionistimage),
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
                  child: Text(widget.receptionistcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
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
        height: h * 0.99,
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
                    "Order tracking" + "  " + widget.id,
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
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                                    ),
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
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received" ||
                                      widget.status ==
                                          "Delivered to Receptionist"
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 20),
                                      child: Image.asset(
                                          'assets/images/defaulticon.png',
                                          fit: BoxFit.fill),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _displayShowImageCommentDialog5(
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
                        height: h * 0.18,
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
                                            "delivered to Warehouse"
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
                                              _displayShowImageCommentDialog3(
                                                  context);
                                            },
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              margin:
                                                  EdgeInsets.only(right: 20),
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
                                                  EdgeInsets.only(right: 20),
                                              child: Image.asset(
                                                  'assets/images/Group 742.png',
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
                                            "delivered to Warehouse" ||
                                        widget.status ==
                                            "pickup item received" ||
                                        widget.status ==
                                            "Delivered to Receptionist"
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                                'assets/images/defaulticon.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "receivedbyreceptionist".tr(),
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
                                              _displayShowImageCommentDialog5(
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
                                                "receivedbyreceptionist".tr(),
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
                        child: Text(
                          "Delivered to Depature Warehouse",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Container(
                        width: 100,
                        child: Text(
                          "Recevied & Proceed for Shipment",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Container(
                        width: 100,
                        child: Text(
                          "Delivered to Receptionist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Spacer(),
                    Container(
                        width: 100,
                        child: Text(
                          "Received by Receptionist",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            widget.status == "Delivered to Receptionist"
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                        left: (Responsive.isDesktop(context)) ? 50 : 54,
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
            widget.status == "Delivered to Receptionist"
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.btype.toString() == "1") {
                              if (widget.status ==
                                  "Delivered to Receptionist") {
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

                                doMrktChangeStatus();
                              }
                            } else {
                              if (widget.status ==
                                  "Delivered to Receptionist") {
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
                              top: 15,
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
                                                    : widget.status ==
                                                            "Delivered to Receptionist"
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
                                        ? Text("Assign To Agent",
                                            style:
                                                TextStyle(color: Colors.white))
                                        : Text("Assign To Agent",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))
                                    : widget.status == "going to pickup"
                                        ? (Responsive.isDesktop(context))
                                            ? Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black))
                                            : Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10))
                                        : widget.status == "pickup done"
                                            ? (Responsive.isDesktop(context))
                                                ? Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black))
                                                : Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10))
                                            : widget.status ==
                                                    "delivered to Warehouse"
                                                ? (Responsive.isDesktop(
                                                        context))
                                                    ? Text("Update Status",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                    : Text("Update Status",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10))
                                                : widget.status ==
                                                        "pickup item received"
                                                    ? (Responsive.isDesktop(
                                                            context))
                                                        ? Text("Update Status",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))
                                                        : Text("Update Status",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10))
                                                    : Text("Update Status",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _displayTextInputDialog(context);
                            // Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 25,
                              top: 15,
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
                        )
                      ],
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
