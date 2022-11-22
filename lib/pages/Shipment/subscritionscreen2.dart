// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class SubscriptionScreen2 extends StatefulWidget {
  SubscriptionScreen2({
    Key? key,
  }) : super(key: key);

  @override
  _SubscriptionScreen2State createState() => _SubscriptionScreen2State();
}

class _SubscriptionScreen2State extends State<SubscriptionScreen2> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic>? paymentIntenetData;
  bool isProcess = false;
  List<subscriptionData> subscriptiondata = [];
  String? name;

  List<String> _texts = [
    "Email Opportunity",
    "Live Schedules",
    "Notification",
    "Chat Functioality",
    "Market Place",
    "Shipment Status",
    "Advertisement",
    "User Invitations",
    "Teaming Partner Collaboration"
  ];
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


  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Background.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: isProcess == true
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Column(
                    
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
                            margin:
                                EdgeInsets.only(top: 5, left: 15, bottom: 25),
                            child: Text("Choose Your Plan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ))),
                        SizedBox(
                          height: h * 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(255, 217, 231, 236),
                            ),
                            height: h * 2,
                            width: w * 0.85,
                            margin: EdgeInsets.fromLTRB(60, 20, 60, 0),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(40, 40, 40, 20),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subscriptiondata.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          subscriptiondata[index].name !=
                                                  "Free Plan"
                                              ? Center(
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      color: Colors.white,
                                                    ),
                                                    height: h * 1.99,
                                                    width: w * 0.25,
                                                    child: Column(
                                                    
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
                                                        Expanded(
                                                          child: Divider(
                                                            color: Colors.grey,
                                                            thickness: 2,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 10,
                                                                  left: 10),
                                                          height: h * 2.0,
                                                          width: w * 0.2,
                                                          child: ListView(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            children: _texts
                                                                .map((text) =>
                                                                    CheckboxListTile(
                                                                      title: Text(
                                                                          text),
                                                                      value:
                                                                          _isChecked,
                                                                      onChanged:
                                                                          (val) {
                                                                       
                                                                      },
                                                                    ))
                                                                .toList(),
                                                          ),
                                                        ),
                                                        Spacer()
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
