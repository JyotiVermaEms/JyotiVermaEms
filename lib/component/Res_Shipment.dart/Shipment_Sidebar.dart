import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Model/Shipment/getShipmentConfirmOrderModel.dart';
import 'package:shipment/Model/Shipment/shipmentNotificationModel.dart';

import 'package:shipment/Provider/Provider.dart';

import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_marketplace_Shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_ChatScreen_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Notification.dart';

import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Profile.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Settings.dart';
import 'package:shipment/component/Res_Shipment.dart/Transaction/Res_Shipment_Transactin.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_Order.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_OrderRecieved.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_orderHistory.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';
import 'package:shipment/pages/Splash.dart';

class ShipmentSidebar extends StatefulWidget {
  @override
  _ShipmentSidebarState createState() => _ShipmentSidebarState();
}

class _ShipmentSidebarState extends State<ShipmentSidebar> {
  var h, w;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  int _selectedIndex = 0;
  double _animatedHeight = 0.0;
  List<ConfirmOrder>? brdata;
  String? bookingId;
  bool isProcess = false;

  int? count;
  int? id;
  var name,
      email,
      mobileNumber,
      languages,
      country,
      profileimage,
      about_me,
      lname;
  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentProfile();
    if (response.status == true) {
      setState(() {
        about_me = response.data[0].about_me;
        name = response.data[0].name;
        lname = response.data[0].lname;
        //print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileimage = response.data[0].profileimage;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });
  }

  getCnfirmbookings() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentconfirmBookings();
    setState(() {
      brdata = response.data;
    });
    for (int i = 0; i < brdata!.length; i++) {
      bookingId = brdata![i].id.toString();
    }

    log("djjjjjjjjjjjjjj" + brdata!.length.toString());
    setState(() {
      isProcess = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    getCnfirmbookings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffFFFFFF),
      child: exp
          ? Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SHIPMENTPROFILE);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 65.0,
                          height: 65.0,
                          margin: EdgeInsets.only(top: 12),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(200),
                            elevation: 10,
                            child: Stack(
                              children: [
                                profileimage == ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child:
                                            Center(child: Icon(Icons.person)),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            child: Image.network((profileimage),
                                                fit: BoxFit.cover)))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: isProcess == true
                                          ? Container(
                                              height: 10,
                                              width: 10,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Color(0xffFFFFFF)),
                                                ),
                                              ),
                                            )
                                          : name != null
                                              ? Text(name.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ))
                                              : Text("")),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, top: 15),
                                    child: isProcess == true
                                        ? Container(
                                            height: 10,
                                            width: 10,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3.0,
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Color(0xffFFFFFF)),
                                              ),
                                            ),
                                          )
                                        : lname != null
                                            ? Text(lname.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ))
                                            : Text(""),
                                  ),
                                ]),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: isProcess == true
                                      ? Container(
                                          height: 10,
                                          width: 10,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Color(0xffFFFFFF)),
                                            ),
                                          ),
                                        )
                                      : Text(email.toString(),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/dashboard.png',
                              ),
                              size: 10,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'dashboard'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SHIPMENTORDERROUTE);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (4 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color(0xffEEEEEE)),
                                height: 15,
                                width: 15,
                                child: ImageIcon(
                                  AssetImage(
                                    'assets/images/shipmentlistingicon.png',
                                  ),
                                  size: 10,
                                )),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                'orders'.tr(),
                                style: TextStyle(
                                    color: Color(0xff1A494F),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 15,
                                width: 15,
                                child: Image.asset(
                                  'assets/images/arrow-right.png',
                                  color: Color(0xff1A494F),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: Color(0xffE5E5E5)),
                  height: MediaQuery.of(context).size.height * (10 / 100),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            var index;
                            Navigator.pushNamed(
                                context, Routes.SHIPMENTBOOKINGREQUESTROUTE);
                          },
                          child: Row(children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 30, top: 10),
                                child: Text(
                                  'bookingrequest'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            brdata != null
                                ? Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.blue[500],
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Center(
                                        child: Text(
                                          brdata!.length.toString(),
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ))
                                : Container()
                          ]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.SHIPMENTORDERHISTORYROUTE);
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, top: 10),
                              child: Text(
                                'orderhistory'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.SHIPMENTMARKETPLACEROUTE);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/shipmentlistingicon.png',
                              ),
                              size: 10,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'marketplace'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.SHIPMENTSCHEDULESHIPMENTROUTE);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/shipmentlistingicon.png',
                              ),
                              size: 10,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'scheduleshipment'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.SHIPMENTNOTIFICATIONROUTE);
                  },
                  child: Container(
                    // margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/dashboard.png',
                              ),
                              size: 10,
                            )),
                        Row(children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'notifications'.tr(),
                              style: TextStyle(
                                  color: Color(0xff1A494F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ]),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 36,
                )),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.SHIPMENTSETTINGROUTE);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/dashboard.png',
                              ),
                              size: 10,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'settings'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: Color(0xffE5E5E5)),
                  height: MediaQuery.of(context).size.height * (5 / 100),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: GestureDetector(
                    onTap: () {
                      var index;
                      Navigator.pushNamed(context, Routes.SHIPMENTSUBUSERSROUTE);
                    },
                    child: Row(children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 40, top: 5),
                          child: Text(
                            'subuser'.tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("companyName");

                    prefs.remove("Shipemnt_auth_token");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xffFFFFFF)),
                    height: MediaQuery.of(context).size.height * (8 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xffEEEEEE)),
                            height: 15,
                            width: 15,
                            child: ImageIcon(
                              AssetImage(
                                'assets/images/dashboard.png',
                              ),
                              size: 10,
                            )),
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'logout'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 15,
                            width: 15,
                            child: Image.asset(
                              'assets/images/arrow-right.png',
                              color: Color(0xff1A494F),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      top: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffEEEEEE)),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/dashboard.png',
                      ),
                      size: 10,
                    )),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffEEEEEE)),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/shipmentlistingicon.png',
                      ),
                      size: 10,
                    )),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffEEEEEE)),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/transicon.png',
                      ),
                      size: 10,
                    )),
                Container(
                    margin: EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffEEEEEE)),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/dashboard.png',
                      ),
                      size: 10,
                    )),
              ],
            ),
    );
  }
}
