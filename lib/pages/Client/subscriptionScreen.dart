import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/subscriptionlistModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Chhose%20Screen/ClientScreen.dart';
import 'package:shipment/pages/Chhose%20Screen/ShipmentScreen.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';

import 'package:shipment/pages/Shipment/LoginSignUp/SignupShipmentfirst.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatefulWidget {
  var planid;
  SubscriptionScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntenetData;
  bool isProcess = false;
  List<subscriptionData> subscriptiondata = [];
  List<Description> description = [];
  String? name;
  var _texts = [];
  var _lastQuitTime;

  // List<String> _texts = [
  //   "Email Opportunity",
  //   "Live Schedules",
  //   "Notification",
  //   "Chat Functioality",
  //   "Market Place",
  //   "Shipment Status",
  //   "Advertisement",
  //   "User Invitations",
  //   "Teaming Partner Collaboration"
  // ];
  bool _isChecked = true;
  // var isLogin, isLoginShipment;
  @override
  void initState() {
    getStatus();

    // getLocalStorage();
  }

  bool initialPosition = true;
  getStatus() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getSubscriptionList();

    if (response.status == true) {
      setState(() {
        subscriptiondata = response.data;
      });
      for (int i = 0; i < subscriptiondata.length; i++)
        name = subscriptiondata[i].name.toString();

      setState(() {
        isProcess = false;
      });
    }
  }

  var h, w;
  int _toggleValue = 0;

  late List<bool> isSelected;
  late StateSetter _setState;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text('you want to Close Plan Activity'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignupScreenfirst()));
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

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Background.png"),
              fit: BoxFit.cover)),
      child: (!Responsive.isDesktop(context))
          ? WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: isProcess == true
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: SingleChildScrollView(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      top: 40,
                                      left: 15,
                                    ),
                                    child: Text("Shipment",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 40,
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 15, bottom: 25),
                                    child: Text("Choose Your Plan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ))),
                                if (!Responsive.isDesktop(context))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(255, 217, 231, 236),
                                    ),
                                    height: h * 0.99,
                                    width: w * 3,

                                    // margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: subscriptiondata.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.white,
                                                    ),
                                                    height: h * 0.99,
                                                    width: w * 0.9,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (10 / 100),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (10 / 100),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/shipSignup.gif",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            subscriptiondata[
                                                                    index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.only(top: 5),
                                                                child: Text(
                                                                  String.fromCharCodes(
                                                                          new Runes(
                                                                              '\u0024')) +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .price,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                width: 100,
                                                                child: Text(
                                                                  " for " +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .duration +
                                                                      " Days",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (subscriptiondata[
                                                                        index]
                                                                    .id ==
                                                                1) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .CLIENTLOGINROUTE);
                                                            } else {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.getString(
                                                                  'u_id');
                                                              print(
                                                                  "kjkjkjkjkk${prefs.getString('u_id')}");
                                                              launchUrl(
                                                                Uri.parse(
                                                                    "$mobilepaymentURL?order_id=${subscriptiondata[index].id}&uid=${prefs.getString('u_id')}&type=subscription"),
                                                                mode: LaunchMode
                                                                    .inAppWebView,
                                                                webViewConfiguration:
                                                                    const WebViewConfiguration(),
                                                              );
                                                              setState(() {});
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .CLIENTLOGINROUTE);
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 20,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                color: Colors
                                                                    .green),
                                                            height: 40,
                                                            width: 140,
                                                            child: Center(
                                                              child: Text(
                                                                  "Start Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 2,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  left: 10),
                                                          height: h * 0.5,
                                                          width: w * 0.9,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: subscriptiondata[
                                                                          index]
                                                                      .description
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    print("hjhjhdjhwjd" +
                                                                        subscriptiondata[index]
                                                                            .description[index1]
                                                                            .feature
                                                                            .toString());
                                                                    return CheckboxListTile(
                                                                      title: Text(subscriptiondata[
                                                                              index]
                                                                          .description[
                                                                              index1]
                                                                          .feature),
                                                                      value:
                                                                          _isChecked,
                                                                      onChanged:
                                                                          (val) {
                                                                        // setState(() {
                                                                        //   _isChecked = val!;
                                                                        // });
                                                                      },
                                                                    );
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                if (Responsive.isDesktop(context))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(255, 217, 231, 236),
                                    ),
                                    height: h * 1.2,
                                    margin: EdgeInsets.fromLTRB(60, 20, 60, 10),
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(40, 0, 40, 10),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: subscriptiondata.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.white,
                                                    ),
                                                    height: h * 1.1,
                                                    width: w * 0.2,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (10 / 100),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (10 / 100),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/shipSignup.gif",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            subscriptiondata[
                                                                    index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.only(top: 5),
                                                                child: Text(
                                                                  String.fromCharCodes(
                                                                          new Runes(
                                                                              '\u0024')) +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .price,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                width: 100,
                                                                child: Text(
                                                                  " for " +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .duration +
                                                                      " Days",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (subscriptiondata[
                                                                        index]
                                                                    .id ==
                                                                1) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .SHIPMENTDASHBOARD);
                                                            } else {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.getString(
                                                                  'u_id');
                                                              print(
                                                                  "kjkjkjkjkk${prefs.getString('u_id')}");
                                                              launchUrl(
                                                                Uri.parse(
                                                                    "$paymentURL?order_id=${subscriptiondata[index].id}&uid=${prefs.getString('u_id')}&type=subscription"),
                                                                mode: LaunchMode
                                                                    .inAppWebView,
                                                                webOnlyWindowName:
                                                                    "_self",
                                                                webViewConfiguration:
                                                                    const WebViewConfiguration(),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20,
                                                                    bottom: 20),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                color: Colors
                                                                    .green),
                                                            height: 40,
                                                            width: 140,
                                                            child: Center(
                                                              child: Text(
                                                                  "Start Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 2,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 10),
                                                          height: h * 0.7,
                                                          width: w * 0.2,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: subscriptiondata[
                                                                          index]
                                                                      .description
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    print("hjhjhdjhwjd" +
                                                                        subscriptiondata[index]
                                                                            .description[index1]
                                                                            .feature
                                                                            .toString());
                                                                    return CheckboxListTile(
                                                                      title: Text(subscriptiondata[
                                                                              index]
                                                                          .description[
                                                                              index1]
                                                                          .feature),
                                                                      value:
                                                                          _isChecked,
                                                                      onChanged:
                                                                          (val) {
                                                                        // setState(() {
                                                                        //   _isChecked = val!;
                                                                        // });
                                                                      },
                                                                    );
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
            )
          : WillPopScope(
              onWillPop: () async {
                if (_lastQuitTime == null ||
                    DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
                  print('Press again Back Button exit');
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => Dashboard()));
                  Navigator.pushNamed(context, Routes.CLIENTLOGINROUTE);
                  return false;
                } else {
                  // SystemNavigator.pop();

                  return false;
                }
              },
              child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: isProcess == true
                      ? Center(child: CircularProgressIndicator())
                      : Center(
                          child: SingleChildScrollView(
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                      top: 40,
                                      left: 15,
                                    ),
                                    child: Text("Shipment",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          color: Colors.white,
                                          fontSize: 40,
                                        ))),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: 5, left: 15, bottom: 25),
                                    child: Text("Choose Your Plan",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ))),
                                if (!Responsive.isDesktop(context))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(255, 217, 231, 236),
                                    ),
                                    height: h * 0.99,
                                    width: w * 3,

                                    // margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: subscriptiondata.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.white,
                                                    ),
                                                    height: h * 0.99,
                                                    width: w * 0.9,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (10 / 100),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (10 / 100),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/shipSignup.gif",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            subscriptiondata[
                                                                    index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.only(top: 5),
                                                                child: Text(
                                                                  String.fromCharCodes(
                                                                          new Runes(
                                                                              '\u0024')) +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .price,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                width: 100,
                                                                child: Text(
                                                                  " for " +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .duration +
                                                                      " Days",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (subscriptiondata[
                                                                        index]
                                                                    .id ==
                                                                1) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .CLIENTLOGINROUTE);
                                                            } else {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.getString(
                                                                  'u_id');
                                                              print(
                                                                  "kjkjkjkjkk${prefs.getString('u_id')}");
                                                              launchUrl(
                                                                Uri.parse(
                                                                    "$mobilepaymentURL?order_id=${subscriptiondata[index].id}&uid=${prefs.getString('u_id')}&type=subscription"),
                                                                mode: LaunchMode
                                                                    .inAppWebView,
                                                                webViewConfiguration:
                                                                    const WebViewConfiguration(),
                                                              );
                                                              setState(() {});
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .CLIENTLOGINROUTE);
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 20,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                color: Colors
                                                                    .green),
                                                            height: 40,
                                                            width: 140,
                                                            child: Center(
                                                              child: Text(
                                                                  "Start Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 2,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5,
                                                                  left: 10),
                                                          height: h * 0.5,
                                                          width: w * 0.9,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: subscriptiondata[
                                                                          index]
                                                                      .description
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    print("hjhjhdjhwjd" +
                                                                        subscriptiondata[index]
                                                                            .description[index1]
                                                                            .feature
                                                                            .toString());
                                                                    return CheckboxListTile(
                                                                      title: Text(subscriptiondata[
                                                                              index]
                                                                          .description[
                                                                              index1]
                                                                          .feature),
                                                                      value:
                                                                          _isChecked,
                                                                      onChanged:
                                                                          (val) {
                                                                        // setState(() {
                                                                        //   _isChecked = val!;
                                                                        // });
                                                                      },
                                                                    );
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                                if (Responsive.isDesktop(context))
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color.fromARGB(255, 217, 231, 236),
                                    ),
                                    height: h * 1.2,
                                    margin: EdgeInsets.fromLTRB(60, 20, 60, 10),
                                    child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(40, 0, 40, 10),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: subscriptiondata.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SingleChildScrollView(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.white,
                                                    ),
                                                    height: h * 1.1,
                                                    width: w * 0.2,
                                                    child: Column(
                                                      // mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              (10 / 100),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              (10 / 100),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 3,
                                                            ),
                                                            image:
                                                                DecorationImage(
                                                              image: AssetImage(
                                                                "assets/images/shipSignup.gif",
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                          child: Text(
                                                            subscriptiondata[
                                                                    index]
                                                                .name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // margin: EdgeInsets.only(top: 5),
                                                                child: Text(
                                                                  String.fromCharCodes(
                                                                          new Runes(
                                                                              '\u0024')) +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .price,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        22,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 5),
                                                                width: 100,
                                                                child: Text(
                                                                  " for " +
                                                                      subscriptiondata[
                                                                              index]
                                                                          .duration +
                                                                      " Days",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                        InkWell(
                                                          onTap: () async {
                                                            if (subscriptiondata[
                                                                        index]
                                                                    .id ==
                                                                1) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  Routes
                                                                      .SHIPMENTDASHBOARD);
                                                            } else {
                                                              SharedPreferences
                                                                  prefs =
                                                                  await SharedPreferences
                                                                      .getInstance();
                                                              prefs.getString(
                                                                  'u_id');
                                                                     prefs.setString(
                                                                  'p_id',subscriptiondata[index].id.toString());
                                                              print(
                                                                  "kjkjkjkjkk${prefs.getString('u_id')}");
                                                              launchUrl(
                                                                Uri.parse(
                                                                    "$paymentURL?order_id=${subscriptiondata[index].id}&uid=${prefs.getString('u_id')}&type=subscription"),
                                                                mode: LaunchMode
                                                                    .inAppWebView,
                                                                webOnlyWindowName:
                                                                    "_self",
                                                                webViewConfiguration:
                                                                    const WebViewConfiguration(),
                                                              );
                                                            }
                                                          },
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 20,
                                                                    bottom: 20),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                color: Colors
                                                                    .green),
                                                            height: 40,
                                                            width: 140,
                                                            child: Center(
                                                              child: Text(
                                                                  "Start Now",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                          thickness: 2,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 10),
                                                          height: h * 0.7,
                                                          width: w * 0.2,
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: subscriptiondata[
                                                                          index]
                                                                      .description
                                                                      .length,
                                                                  shrinkWrap:
                                                                      true,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index1) {
                                                                    print("hjhjhdjhwjd" +
                                                                        subscriptiondata[index]
                                                                            .description[index1]
                                                                            .feature
                                                                            .toString());
                                                                    return CheckboxListTile(
                                                                      title: Text(subscriptiondata[
                                                                              index]
                                                                          .description[
                                                                              index1]
                                                                          .feature),
                                                                      value:
                                                                          _isChecked,
                                                                      onChanged:
                                                                          (val) {
                                                                        // setState(() {
                                                                        //   _isChecked = val!;
                                                                        // });
                                                                      },
                                                                    );
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
            ),
    );
  }
}
