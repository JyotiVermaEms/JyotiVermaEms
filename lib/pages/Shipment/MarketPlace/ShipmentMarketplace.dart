import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/Shipment/getMarketplaceBookingModel.dart';
import 'package:shipment/Model/Shipment/getShipmentMarkrtPlaceModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_SubmitProposal.dart';
import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_marketplace_Shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/res_marketplaceClientInfo.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/MarketPlace/alertdialogMarketplacebooking.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

class MarketPlaceShipment extends StatefulWidget {
  const MarketPlaceShipment({Key? key}) : super(key: key);

  @override
  _MarketPlaceShipmentState createState() => _MarketPlaceShipmentState();
}

class _MarketPlaceShipmentState extends State<MarketPlaceShipment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = new TextEditingController();
  var h, w;
  static const countdownDuration = Duration(hours: 24);
  Duration duration = Duration(days: 1);
  Timer? timer;
  bool isCountdown = true;
  DateTime initialDate = DateTime.now();
  List<SMPResponse> oderHistoryData = [];
  TabController? tabController;
  bool isProcess = false;

  late StateSetter _setState;

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

  List<MarketPlace> getBooking = [];

  Future shipmentMarketPlace() async {
    print("in shipmentMarketPlace");
    var response = await Providers().getshipmentMarktPlace();
    print("in shipmentMarketPlace ${response.status}");
    if (response.status == true) {
      setState(() {
        oderHistoryData = response.data;
        log("EEEEEEEEEEE ${oderHistoryData.length}");
      });
    }
  }

  Future getMarketplaceBooking() async {
    setState(() {
      isProcess = true;
    });
    print("in getMarketplaceBooking");
    var response = await Providers().getShipmentMarketPlaceBooking();
    print("in getMarketplaceBooking ${response.status}");
    if (response.status == true) {
      setState(() {
        getBooking = response.data;
      });
    }
    setState(() {
      isProcess = false;
    });
  }

  var marketplaceid, status;

  acceptBooking() async {
    setState(() {
      isProcess = true;
    });
    var data = {"market_id": "$marketplaceid", "status": "$status"};
    var acceptBookings = await Providers().acceptmarketplacebookin(data);

    if (acceptBookings.status == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResMarketPlaceShipment()));
    }
    setState(() {
      isProcess = false;
    });
  }

  var UserId, userRole;
  var roomId = 0;
  var chatListData = [];
  void getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userDetails;
    if (prefs.getString('Shipemnt_auth_token') != null) {
      prefs.setString("mtype", 'market');
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
      setState(() {
        UserId = userDetails.data[0].id;
        userRole = userDetails.data[0].roles;
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
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (getBooking != null) {
        print("getdata");
      }
    });

    shipmentMarketPlace();
    getMarketplaceBooking();
    getProfileDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    var splitDate;

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setCountDown();
    });
  }

  void stopTimer() {
    _setState(() => timer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => duration = Duration(days: 1));
  }

  void setCountDown() {
    final reduceSecondsBy = 1;

    final seconds = duration.inSeconds - reduceSecondsBy;

    _setState(() {
      if (seconds < 0) {
        timer!.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(duration.inDays);

    final hours = strDigits(duration.inHours.remainder(24));
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: ShipmentSidebar(),
      ),
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              color: Color(0xffF7F8F9),
              child: SafeArea(
                  right: false,
                  child: ListView(
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
                            if (Responsive.isDesktop(context))
                              SizedBox(width: 5),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'marketplace'.tr(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              DefaultTabController(
                                  length: 2,
                                  initialIndex: 0,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Container(
                                          child: TabBar(
                                            unselectedLabelColor: Colors.grey,
                                            isScrollable: false,
                                            labelColor: Color(0xff1A494F),
                                            indicatorColor: Color(0xff1A494F),
                                            tabs: <Widget>[
                                              Tab(
                                                child: Text(
                                                  "marketplacerequirements"
                                                      .tr(),
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
                                        Container(
                                            height: h,
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Colors.grey,
                                                        width: 0.5))),
                                            child:
                                                TabBarView(children: <Widget>[
                                              order(hours, minutes, seconds),
                                              OrderHistory(),
                                            ]))
                                      ])),
                            ]),
                      ),
                    ],
                  ))),
    );
  }

  Widget order(h, m, s) {
    return (Responsive.isDesktop(context))
        ? ListView.builder(
            itemCount: getBooking.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                width: w,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffE5E5E5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  width: 400,
                                  child: Text(
                                    "orderid".tr(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 10, bottom: 10),
                                  width: 400,
                                  child: Text(
                                    getBooking[index].id.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 540,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "orderdetails".tr(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  width: 540,
                                  child: Text(
                                    getBooking[index].bookingDate.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                  width: 80,
                                  margin: EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    "total".tr(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  width: 80,
                                  child: Text(
                                    getBooking[index].bookingPrice.toString() +
                                        "\$",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    secondRow(index),
                    Container(
                      child: Row(
                        children: [
                          getBooking[index].itemImage.length == 0
                              ? Container(
                                  height: 150,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFFFFFF),
                                  ),
                                  margin: EdgeInsets.only(
                                      top: 10, right: 10, left: 10),
                                  child: Image.asset(
                                    'assets/images/cars.png',
                                    fit: BoxFit.cover,
                                  ))
                              : Container(
                                  height: 150,
                                  width: 350,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      aspectRatio: 2.0,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      initialPage: 2,
                                      autoPlay: true,
                                    ),
                                    items: getBooking[index]
                                        .itemImage
                                        .map<Widget>((item) => InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return imageViewDialog(
                                                        context,
                                                        item,
                                                        getBooking[index]
                                                            .itemImage);
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Center(
                                                      child: Image.network(
                                                    item,
                                                    fit: BoxFit.cover,
                                                  )),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                          Container(
                            height: 150,
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (10 / 100),
                                        margin: EdgeInsets.only(
                                            left: 40, bottom: 10),
                                        child: Text(
                                          "shipmenttype".tr() + ":",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (10 / 100),
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          getBooking[index].dropoff.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (10 / 100),
                                        margin:
                                            EdgeInsets.only(top: 5, left: 40),
                                        child: Text(
                                          "shipto".tr() + " : ",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (18 / 100),
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          getBooking[index]
                                              .dropoffLocation
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (10 / 100),
                                        margin:
                                            EdgeInsets.only(top: 15, left: 40),
                                        child: Text(
                                          "shipfrom".tr() + ":",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (18 / 100),
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          getBooking[index]
                                              .pickupLocation
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          thirdRow2(index, h, m, s),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.5, color: Color(0xffACACAC)),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffE5E5E5),
                      ),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        title: Text(
                          "description".tr(),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          getBooking[index].description.toString(),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "requirement".tr(),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              getBooking[index].needs.toString(),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            })
        : ListView.builder(
            itemCount: getBooking.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                width: w,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffE5E5E5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(
                                    "orderid".tr(),
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 10, bottom: 10),
                                  child: Text(
                                    getBooking[index].id.toString(),
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "orderdetails".tr(),
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  height: 40,
                                  width: 90,
                                  child: Text(
                                    getBooking[index].bookingDate.toString(),
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, right: 15),
                                  child: Text(
                                    "total".tr(),
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 10, right: 15),
                                  child: Text(
                                    getBooking[index].bookingPrice.toString() +
                                        "\$",
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    secondRow(index),
                    getBooking[index].itemImage.length == 0
                        ? Container(
                            height: 150,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                            ),
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 10),
                            child: Image.asset(
                              'assets/images/cars.png',
                              fit: BoxFit.cover,
                            ))
                        : Container(
                            height: 150,
                            width: 350,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 16 / 9,
                                // enlargeCenterPage: true,
                                // enableInfiniteScroll: false,
                                // initialPage: 2,
                                autoPlay: true,
                              ),
                              items: getBooking[index]
                                  .itemImage
                                  .map<Widget>((item) => InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return imageViewDialog(
                                                  context,
                                                  item,
                                                  getBooking[index].itemImage);
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Center(
                                                child: Image.network(
                                              item,
                                              fit: BoxFit.cover,
                                            )),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 40, bottom: 10),
                            child: Text(
                              "shipmenttype".tr() + ": ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              getBooking[index].dropoff.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5, left: 40),
                            child: Text(
                              "shipto".tr() + ":",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              getBooking[index].dropoffLocation.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 15, left: 40),
                            child: Text(
                              "shipfrom".tr() + ":",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 15),
                            child: Text(
                              getBooking[index].pickupLocation.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    thirdRow2(index, h, m, s),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 0.5, color: Color(0xffACACAC)),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffE5E5E5),
                      ),
                      child: ExpansionTile(
                        textColor: Colors.black,
                        title: Text(
                          "description".tr(),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          getBooking[index].description.toString(),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "requirement".tr(),
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              getBooking[index].needs.toString(),
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
  }

  Widget secondRow(index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 15, left: 15),
                  child: Text(
                    "title".tr() + " :",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    getBooking[index].title.toString(),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget thirdRow(index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            var data = getBooking[index].id.toString();
            print(data);

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResSubmitProposal(data)));
          },
          child: Container(
              height: 40,
              width: 240,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 10, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Submit your proposalllllllll",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }

  Widget OrderHistory() {
    return Container(
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: Color(0xffE5E5E5),
      child: SafeArea(
          right: false,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Row(
                children: [
                  if (!Responsive.isDesktop(context))
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                      child: Row(
                        children: [
                          Text(
                            'orderhistory'.tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (Responsive.isDesktop(context))
              Column(
                children: [
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
          ])),
    );
  }

  Widget orderDetails() {
    return oderHistoryData.length == 0
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
                    SizedBox(height: 15),
                    Text(
                      'sorryouhavenotanybookingsyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: oderHistoryData.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
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
                        width: MediaQuery.of(context).size.width * (9 / 100),
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          oderHistoryData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (16 / 100),
                        child: Text(
                          oderHistoryData[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * (18 / 100),
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
                                        itemname: oderHistoryData[index]
                                            .category[index]
                                            .categoryItem,
                                        quantity: oderHistoryData[index].items,
                                        pickupLocation: oderHistoryData[index]
                                            .pickupLocation,
                                        dropoffLocation: oderHistoryData[index]
                                            .dropoffLocation,
                                        prize:
                                            oderHistoryData[index].bookingPrice,
                                        h: h,
                                        w: w),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          oderHistoryData[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1A494F)),
                        ),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * (10 / 100),
                        margin: EdgeInsets.only(right: 20),
                        child: Text(
                          oderHistoryData[index].status == "accepted"
                              ? "offer received"
                              : oderHistoryData[index].status,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        )),
                    GestureDetector(
                      onTap: () {
                        var data11;
                        List<ChatUsers> usersList = [];
                        usersList.add(ChatUsers(UserId, "1"));
                        usersList.add(
                            ChatUsers(oderHistoryData[index].client.id, "1c"));
                        usersList.add(ChatUsers(
                            oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .receptionistId,
                            "2r"));
                        usersList.add(ChatUsers(
                            oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .departureId,
                            "3"));

                        usersList.add(ChatUsers(
                            oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .arrivalId,
                            "4"));

                        oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .pickupagentId !=
                                0
                            ? usersList.add(ChatUsers(
                                oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .pickupagentId,
                                "5"))
                            : '';

                        print("-=chatListData-= $chatListData");

                        int trendIndex = chatListData.indexWhere((f) =>
                            f['name'] ==
                            oderHistoryData[index].marketplaceBookingid[0].id);
                        print("-=-=-trendIndex $trendIndex");
                        if (trendIndex != -1) {
                          roomId = chatListData[trendIndex]['id'];
                          print("-=-=- $usersList");
                          print(
                              "-=-roomId=- ${chatListData[trendIndex]['id']}");
                        }

                        data11 = {
                          "group_name": oderHistoryData[index].title.toString(),
                          "firm_name": oderHistoryData[index].title.toString(),
                          "chat_type": "group",
                          "room_id": roomId,
                          "userList": jsonEncode(usersList),
                          "user_id": oderHistoryData[index].uid.toString(),
                          "sid": oderHistoryData[index].id.toString(),
                          'sender_type': userRole.toString(),
                          'receiver_type': '1c',
                          "sender_id": UserId.toString(),
                          "receiver_id":
                              oderHistoryData[index].client.id.toString(),
                        };
                        print("-=-=- $data11");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatViewScreen(data11),
                            ));
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 15, top: 15, bottom: 30, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green),
                          height: 45,
                          width: 140,
                          child: Center(
                            child: Text(
                              "Chat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        var id = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .id
                            .toString();
                        var type = oderHistoryData[index].dropoff.toString();
                        var bookingdate =
                            oderHistoryData[index].bookingDate.toString();
                        var status = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .status
                            .toString();
                        var itemimage = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .pickupItemimage
                            .toString();
                        var comment = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .pickupComment
                            .toString();
                        var itemimage1 = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .pickupItemimage1
                            .toString();
                        var comment1 = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .pickupComment1
                            .toString();
                        var depatureimage = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .departureImage
                            .toString();
                        var depaturecomment = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .departureComment
                            .toString();
                        var arrivalimage = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .arrivalImage
                            .toString();
                        var arrivalcomment = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .arrivalComment
                            .toString();
                        var receptionistimage = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .receptionistImage
                            .toString();
                        var receptionistcomment = oderHistoryData[index]
                            .marketplaceBookingid[0]
                            .receptionistComment
                            .toString();
                        var pickupType =
                            oderHistoryData[index].dropoff.toString();
                        print(id);

                        print(type);
                        print(bookingdate);
                        print("jsdkhkhdsjkhjkd$status");
                        oderHistoryData[index].dropoff == "Pick up"
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBoxShipmentMarket(
                                        id,
                                        type,
                                        bookingdate,
                                        status,
                                        pickupType,
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
                                    CustomDialogBoxShipmentDropOff(
                                        id,
                                        type,
                                        bookingdate,
                                        status,
                                        pickupType,
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
                          margin:
                              EdgeInsets.only(left: 10, top: 15, bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green),
                          height: 45,
                          width: 120,
                          child: Center(
                            child: Text(
                              "View Status",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                  ],
                ),
              );
            });
  }

  Widget MobileVieworderTemplate() {
    log("TTTTTTTTT ${oderHistoryData.length}");
    return oderHistoryData.length == 0
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
                    SizedBox(height: 15),
                    Text(
                      'sorryouhavenotanybookingsyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
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
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  "orderid".tr(),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  oderHistoryData[index].id.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(top: 10, right: 20),
                                child: Text(
                                    oderHistoryData[index].status == "accepted"
                                        ? "offer received"
                                        : oderHistoryData[index].status,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red))),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "bookingdate".tr(),
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  oderHistoryData[index].bookingDate.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                                  itemname: oderHistoryData[
                                                          index]
                                                      .category[index]
                                                      .categoryItem,
                                                  quantity:
                                                      oderHistoryData[index]
                                                          .items,
                                                  pickupLocation:
                                                      oderHistoryData[index]
                                                          .pickupLocation,
                                                  dropoffLocation:
                                                      oderHistoryData[index]
                                                          .dropoffLocation,
                                                  prize: oderHistoryData[index]
                                                      .bookingPrice,
                                                  h: h,
                                                  w: w),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(oderHistoryData[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                )),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            var data11;
                            List<ChatUsers> usersList = [];
                            usersList.add(ChatUsers(UserId, "1"));
                            usersList.add(ChatUsers(
                                oderHistoryData[index].client.id, "1c"));
                            usersList.add(ChatUsers(
                                oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .receptionistId,
                                "2r"));
                            usersList.add(ChatUsers(
                                oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .departureId,
                                "3"));

                            usersList.add(ChatUsers(
                                oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .arrivalId,
                                "4"));

                            oderHistoryData[index]
                                        .marketplaceBookingid[0]
                                        .pickupagentId !=
                                    0
                                ? usersList.add(ChatUsers(
                                    oderHistoryData[index]
                                        .marketplaceBookingid[0]
                                        .pickupagentId,
                                    "5"))
                                : '';

                            print("-=chatListData-= $chatListData");

                            int trendIndex = chatListData.indexWhere((f) =>
                                f['name'] ==
                                oderHistoryData[index]
                                    .marketplaceBookingid[0]
                                    .id);
                            print("-=-=-trendIndex $trendIndex");
                            if (trendIndex != -1) {
                              roomId = chatListData[trendIndex]['id'];
                              print("-=-=- $usersList");
                              print(
                                  "-=-roomId=- ${chatListData[trendIndex]['id']}");
                            }

                            data11 = {
                              "group_name":
                                  oderHistoryData[index].title.toString(),
                              "firm_name":
                                  oderHistoryData[index].title.toString(),
                              "chat_type": "group",
                              "room_id": roomId,
                              "userList": jsonEncode(usersList),
                              "user_id": oderHistoryData[index].uid.toString(),
                              "sid": oderHistoryData[index].id.toString(),
                              'sender_type': userRole.toString(),
                              'receiver_type': '1c',
                              "sender_id": UserId.toString(),
                              "receiver_id":
                                  oderHistoryData[index].client.id.toString(),
                            };
                            print("-=-=- $data11");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatViewScreen(data11),
                                ));
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 15, top: 15, bottom: 30, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.green),
                              height: 45,
                              width: 140,
                              child: Center(
                                child: Text(
                                  "chat".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            var id = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .id
                                .toString();
                            var type =
                                oderHistoryData[index].dropoff.toString();
                            var bookingdate =
                                oderHistoryData[index].bookingDate.toString();
                            var status = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .status
                                .toString();
                            var itemimage = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .pickupItemimage
                                .toString();
                            var comment = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .pickupComment
                                .toString();
                            var itemimage1 = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .pickupItemimage1
                                .toString();
                            var comment1 = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .pickupComment1
                                .toString();
                            var depatureimage = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .departureImage
                                .toString();
                            var depaturecomment = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .departureComment
                                .toString();
                            var arrivalimage = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .arrivalImage
                                .toString();
                            var arrivalcomment = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .arrivalComment
                                .toString();
                            var receptionistimage = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .receptionistImage
                                .toString();
                            var receptionistcomment = oderHistoryData[index]
                                .marketplaceBookingid[0]
                                .receptionistComment
                                .toString();
                            var pickupType =
                                oderHistoryData[index].dropoff.toString();
                            print(id);

                            print(type);
                            print(bookingdate);
                            print("jsdkhkhdsjkhjkd$status");
                            oderHistoryData[index].dropoff == "Pick up"
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialogBoxShipmentMarket(
                                            id,
                                            type,
                                            bookingdate,
                                            status,
                                            pickupType,
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
                                        CustomDialogBoxShipmentDropOff(
                                            id,
                                            type,
                                            bookingdate,
                                            status,
                                            pickupType,
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
                                  left: 10, top: 15, bottom: 30),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.green),
                              height: 45,
                              width: 120,
                              child: Center(
                                child: Text(
                                  "action".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  "Order ID",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "123456 ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomDialogBox());
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width *
                                      (40 / 100),
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color(0xff0FBAB8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Deliverd",
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white),
                                    ),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "Booking Date",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "21.08.2021",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  "Shipment Company",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                margin: EdgeInsets.only(top: 15, right: 20),
                                child: Text("from",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black))),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (15 / 100),
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
                                width: MediaQuery.of(context).size.width *
                                    (40 / 100),
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "APM-Maersk.",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                margin: EdgeInsets.only(top: 10, right: 20),
                                child: Text("USA",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                            Container(
                                width: MediaQuery.of(context).size.width *
                                    (15 / 100),
                                margin: EdgeInsets.only(top: 10, right: 20),
                                child: Text("India",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              );
            });
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
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (18 / 100),
              child: Text(
                "scheduletitle".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (14 / 100),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              child: Text(
                "chat".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (5 / 100),
              child: Text(
                "action".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget ContainerListDialog({
    itemname,
    quantity,
    pickupLocation,
    dropoffLocation,
    prize,
    h,
    w,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
      ),
      height: h * 0.35,
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
          Row(children: [
            Container(
              width: w * 0.15,
              child: Text(
                "item".tr(),
                style: headingStyle16MB(),
              ),
            ),
            Container(
              width: w * 0.15,
              child: Text(
                itemname.toString(),
                style: headingStyle16MB(),
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.only(top: 20),
          ),
          Row(
            children: [
              Container(
                width: w * 0.15,
                child: Text(
                  "quantity".tr(),
                  style: headingStyle16MB(),
                ),
              ),
              Container(
                width: w * 0.15,
                child: Text(
                  quantity,
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
                    "picuplocation".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(pickupLocation, style: headingStyle16MB()),
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
                  child:
                      Text("dropofflocation".tr(), style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(dropoffLocation, style: headingStyle16MB()),
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
                  child: Text("prize".tr(), style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(prize.toString(), style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildTime(index) {
    print("buildTime");

    var splitDate = getBooking[index].createdAt.split("T");

    DateTime dateTimeCreatedAt = DateTime.parse(splitDate[0]);
    DateTime dateTimeNow = DateTime.now();
    final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
    print('-=-=-=-=- $differenceInDays');

    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(differenceInDays);

    final hours = strDigits(duration.inHours.remainder(24));
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));

    print("in buildTime $hours $minutes $seconds");
  }

  Widget buildTime1() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text('$hours:$minutes:$seconds',
        style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget thirdRow2(index, h, m, s) {
    return (Responsive.isDesktop(context))
        ? Column(
            children: [
              InkWell(
                onTap: () {
                  var data = {
                    'id': getBooking[index].id.toString(),
                    'itemimage': getBooking[index].itemImage,
                    'clientbugdet': getBooking[index].bookingPrice.toString(),
                    'category': getBooking[index].category,
                    'description': getBooking[index].description.toString(),
                    'needs': getBooking[index].needs.toString(),
                  };
                  print("NNNNNNNNNNNNN$data");
                  print("NNNNNNNNNNNNN$data");
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.only(left: 100, top: 80),
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            content: summaryBox(data),
                          ),
                        );
                      });
                },
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        right: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        "itemsummary".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  var data = {
                    'id': getBooking[index].client[0].id.toString(),
                    'name': getBooking[index].client[0].name.toString(),
                    'lname': getBooking[index].client[0].lname.toString(),
                    'email': getBooking[index].client[0].email.toString(),
                    'phone': getBooking[index].client[0].phone.toString(),
                    'address': getBooking[index].client[0].address.toString(),
                    'country': getBooking[index].client[0].country.toString(),
                    'profileimage':
                        getBooking[index].client[0].profileimage.toString(),
                  };
                  print("NNNNNNNNNNNNN$data");
                  print("NNNNNNNNNNNNN$data");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MarketBookingClientDetails(data)),
                  );
                },
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        top: 15,
                        right: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        "clientdetails".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: getBooking[index].proposalStatus == "nonapplied"
                    ? () {
                        var data = {
                          'id': getBooking[index].id.toString(),
                          'itemimage': getBooking[index].itemImage,
                          'clientbugdet':
                              getBooking[index].bookingPrice.toString(),
                          'category': getBooking[index].category,
                          'description':
                              getBooking[index].description.toString(),
                          'needs': getBooking[index].needs.toString(),
                        };

                        print("dgyssssssssssssssss" + data.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResSubmitProposal(data)));
                      }
                    : null,
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        top: 15,
                        right: 20,
                        bottom: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        getBooking[index].proposalStatus == "nonapplied"
                            ? "submityourproposal".tr()
                            : "submitted".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ],
          )
        : Column(
            children: [
              InkWell(
                onTap: () {
                  var data = {
                    'id': getBooking[index].id.toString(),
                    'itemimage': getBooking[index].itemImage,
                    'clientbugdet': getBooking[index].bookingPrice.toString(),
                    'category': getBooking[index].category,
                    'description': getBooking[index].description.toString(),
                    'needs': getBooking[index].needs.toString(),
                  };
                  print("NNNNNNNNNNNNN$data");
                  print("NNNNNNNNNNNNN$data");
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          backgroundColor: Colors.white,
                          content: summaryBox(data),
                        );
                      });
                },
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        right: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        "itemsummary".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  var data = {
                    'id': getBooking[index].client[0].id.toString(),
                    'name': getBooking[index].client[0].name.toString(),
                    'lname': getBooking[index].client[0].lname.toString(),
                    'email': getBooking[index].client[0].email.toString(),
                    'phone': getBooking[index].client[0].phone.toString(),
                    'address': getBooking[index].client[0].address.toString(),
                    'country': getBooking[index].client[0].country.toString(),
                    'profileimage':
                        getBooking[index].client[0].profileimage.toString(),
                  };
                  print("NNNNNNNNNNNNN$data");
                  print("NNNNNNNNNNNNN$data");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MarketBookingClientDetails(data)),
                  );
                },
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        top: 15,
                        right: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        "clientdetails".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              GestureDetector(
                onTap: getBooking[index].proposalStatus == "nonapplied"
                    ? () {
                        var data = {
                          'id': getBooking[index].id.toString(),
                          'itemimage': getBooking[index].itemImage,
                          'clientbugdet':
                              getBooking[index].bookingPrice.toString(),
                          'category': getBooking[index].category,
                          'description':
                              getBooking[index].description.toString(),
                          'needs': getBooking[index].needs.toString(),
                        };

                        print("dgyssssssssssssssss" + data.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResSubmitProposal(data)));
                      }
                    : null,
                child: Container(
                    height: 40,
                    width: (Responsive.isDesktop(context))
                        ? 180
                        : MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(
                        top: 15,
                        right: 20,
                        bottom: 20,
                        left: (Responsive.isDesktop(context)) ? 0 : 20),
                    child: Center(
                      child: Text(
                        getBooking[index].proposalStatus == "nonapplied"
                            ? "submityourproposal".tr()
                            : "submitted".tr(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            ],
          );
  }

  Widget summaryBox(data) {
    return (Responsive.isDesktop(context))
        ? Container(
            height: MediaQuery.of(context).size.height * (80 / 100),
            width: (Responsive.isDesktop(context))
                ? MediaQuery.of(context).size.width * (70 / 100)
                : MediaQuery.of(context).size.width * (100 / 100),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(children: [
              Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
                      child: Text(
                        "Item Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                      )),
                ),
              ]),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: w * 0.70,
                    height: h * 0.80,
                    child: ListView.builder(
                        itemCount: data['category'].length,
                        reverse: false,
                        itemBuilder: (context, index) {
                          var jsondata =
                              data['category'][index].bookingAttribute;

                          print("ehdjhjkdhjhd$jsondata");
                          print("-=--=-=-=${jsondata.length}");
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: kDefaultPadding / 2),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    "Category :",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Container(
                                                  child: Text(
                                                    data['category'][index]
                                                            .categoryItem +
                                                        "  " +
                                                        "(" +
                                                        "Quantity :" +
                                                        data['category'][index]
                                                            .quantity
                                                            .toString() +
                                                        ")",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    "Item Name : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Row(
                                                    children: List.generate(
                                                  jsondata.length,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      jsondata[index] + ",",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    "Description : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Container(
                                                  height: 50,
                                                  width: 700,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            data['description']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Container(
                                                  width: 100,
                                                  child: Text(
                                                    "Needs  : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Container(
                                                  height: 50,
                                                  width: 700,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                          data['needs']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              child: Divider(
                                                height: 30,
                                                color: Colors.black,
                                                thickness: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ]),
          )
        : Container(
            height: MediaQuery.of(context).size.height * (80 / 100),
            width: (Responsive.isDesktop(context))
                ? MediaQuery.of(context).size.width * (70 / 100)
                : MediaQuery.of(context).size.width * (100 / 100),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(children: [
              Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
                      child: Text(
                        "itemdetails".tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 25,
                      )),
                ),
              ]),
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: w * 0.80,
                    height: h * 0.80,
                    child: ListView.builder(
                        itemCount: data['category'].length,
                        reverse: false,
                        itemBuilder: (context, index) {
                          var jsondata =
                              data['category'][index].bookingAttribute;

                          print("ehdjhjkdhjhd$jsondata");
                          print("-=--=-=-=${jsondata.length}");
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10),
                                      child: Text(
                                        "category".tr(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10),
                                      child: Container(
                                        child: Text(
                                          data['category'][index].categoryItem +
                                              "  " +
                                              "(" +
                                              "Quantity :" +
                                              data['category'][index]
                                                  .quantity
                                                  .toString() +
                                              ")",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10),
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          "itemname".tr(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10),
                                      child: Container(
                                        height: 40,
                                        child: Scrollbar(
                                          isAlwaysShown: true,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Row(
                                                    children: List.generate(
                                                  jsondata.length,
                                                  (index) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      jsondata[index] + ",",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10, bottom: 10),
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          "description".tr(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 500,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            child: Text(
                                                data['description'].toString(),
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 10, bottom: 10),
                                      child: Container(
                                        width: 100,
                                        child: Text(
                                          "needs".tr() + ':',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Container(
                                        height: 40,
                                        width: 500,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(data['needs'].toString(),
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
              ),
            ]),
          );
  }
}
