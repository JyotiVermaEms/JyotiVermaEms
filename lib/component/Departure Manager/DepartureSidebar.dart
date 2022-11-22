import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/ChatScreen.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Order.dart';
import 'package:shipment/component/Departure%20Manager/Profile.dart';
import 'package:shipment/component/Departure%20Manager/Res_orderhistory.dart';
import 'package:shipment/component/Departure%20Manager/Settings.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Departure%20Manager/Chat/DepartureChat.dart';
import 'package:shipment/pages/Departure%20Manager/Login/LoginScreen.dart';
import 'package:shipment/pages/Departure%20Manager/Notification/departureNotification.dart';
import 'package:shipment/pages/Splash.dart';

class DepartureSidebar extends StatefulWidget {
  // DepartureSidebar({h}) ;

  @override
  _DepartureSidebarState createState() => _DepartureSidebarState();
}

class _DepartureSidebarState extends State<DepartureSidebar> {
  var h, w;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  int _selectedIndex = 0;
  double _animatedHeight = 0.0;
  var name, email, mobileNumber, languages, country, lname, profileimage;
  Future getProfile() async {
    var response = await Providers().getDepatureProfile();
    log("get profile data" + jsonEncode(response));
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileimage = response.data[0].profileimage;
      });

      log("REPONSE" + jsonEncode(response.data));
    }

    // id =   response.user[universityList.indexOf(name)].id
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              blurRadius: 10,
              color: Colors.black,
              spreadRadius: 4,
            ),
          ],
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.DEPATUREPROFILE);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xffFFFFFF),
                  ),
                  height: 97,
                  width: 373,
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
                                    ? Center(child: Icon(Icons.person))
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
                                    margin: EdgeInsets.only(top: 22, right: 5),
                                    child: Text(name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 22),
                                    child: Text(lname,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  ),
                                ]),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(email,
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
                  )),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.DEPATUREDASHBOARD);
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
                Navigator.pushNamed(context, Routes.DEPATUREORDER);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xffFFFFFF)),
                height: MediaQuery.of(context).size.height * (5 / 100),
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
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.DEPATUREORDERHISTORY);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xffFFFFFF)),
                height: MediaQuery.of(context).size.height * (5 / 100),
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
                            'orderhistory'.tr(),
                            style: TextStyle(
                                color: Color(0xff1A494F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => Profile()));
                          },
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
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),

            //=======
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.DEPATURENOTIFICATION);

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => DepartureNotificationScreen()));
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
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Profile()));
                      },
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

            //=======

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.DEPATURESETTING);

                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => DepSettings()));
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
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Profile()));
                      },
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                  (Route<dynamic> route) => false,
                );
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
                      onTap: () {
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Profile()));
                      },
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
        ));
  }
}
