import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Order/Order.dart';
import 'package:shipment/component/Pickup%20Agent/Order/inprogressorderList.dart';
import 'package:shipment/component/Pickup%20Agent/PickupAgentSettings.dart';
import 'package:shipment/component/Pickup%20Agent/Profile/Profile.dart';
import 'package:shipment/component/Pickup%20Agent/Res_pickupAgentOrderhistory.dart';
import 'package:shipment/component/Pickup%20Agent/pickup_message.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Pickup%20Agent/LoginScreen.dart';
import 'package:shipment/pages/Pickup%20Agent/Notification/notification.dart';
import 'package:shipment/pages/Splash.dart';

class PickupSideBar extends StatefulWidget {
  const PickupSideBar({Key? key}) : super(key: key);

  @override
  _PickupSideBarState createState() => _PickupSideBarState();
}

class _PickupSideBarState extends State<PickupSideBar> {
  var h, w;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  int _selectedIndex = 0;
  double _animatedHeight = 0.0;
  bool isProcess = false;

  var name, email, mobileNumber, languages, country, lname, profileimage;
  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getpickupAgentProfile();
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
    setState(() {
      isProcess = false;
    });

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
        // height: h,
        // width: exp ? w * 0.2 : w * 0.1,
        color: Color(0xffFFFFFF),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Routes.PICKUPAGENTPROFILE);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PickupAgentProfile()));
              },
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xffFFFFFF)),
                  // height: MediaQuery.of(context).size.height * 0.12,
                  height: 97,
                  width: 373,
                  // width: MediaQuery.of(context).size.width * 0.9,
                  // color: Colors.lime,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 25),
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
                                                          Colors.white),
                                                ),
                                              ),
                                            )
                                          : Text(name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              )),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 25, left: 5),
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
                                                          Colors.white),
                                                ),
                                              ),
                                            )
                                          : Text(lname,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              )),
                                    ),
                                  ],
                                ),
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
                                                      Colors.white),
                                            ),
                                          ),
                                        )
                                      : Text(email,
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
                Navigator.pushNamed(context, Routes.PICKUPAGENTDASHBOARD);
               
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
                Navigator.pushNamed(context, Routes.PICKUPAGENTORDER);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => inprogressOrderList()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Color(0xffFFFFFF)),
                height: MediaQuery.of(context).size.height * (4 / 100),
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
                        'order'.tr(),
                        style: TextStyle(
                            color: Color(0xff1A494F),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => inprogressOrderList()));
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
                Navigator.pushNamed(context, Routes.PICKUPAGENTORDERHISTORY);
               
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
                        margin: EdgeInsets.only(left: 10, top: 5),
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

            
            Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),

            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.PICKUPAGENTNOTIFICATION);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PickupNotificationScreen()));
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
           
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.PICKUPAGENTSETTING);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => PickupagentSettings()));
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
