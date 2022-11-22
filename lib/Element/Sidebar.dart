import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/ResMarketbookingshow.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/notificationdashboard.dart';
import 'package:shipment/component/Res_Client/Res_Client_Profile.dart';
import 'package:shipment/component/Res_Client/res_ClientOrderHistory.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Splash.dart';
import 'package:easy_localization/easy_localization.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  var h, w;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  bool isProcess = false;

  File? _image;
  Image? image;
  String? imagePath;
  // List<ClientNotificationData> notificationData = [];
  int? count;

  var name, email, mobileNumber, languages, country, lname, profileimage;
  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getClientProfile();
    log("get profile data" + jsonEncode(response));
    if (response.status == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.getString('auth_token');
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

  _imgFromGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  void _showPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              await _imgFromGallery(context);
                              setState(() {});
                            },
                            child: Icon(Icons.camera)),
                        SizedBox(width: 5),
                        Text('Take a picture'),
                        SizedBox(width: 50),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  String imagepath = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // height: h,
        // width: exp ? w * 0.2 : w * 0.1,
        color: Color(0xffFFFFFF),
        child: exp
            ? Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.CLIENTPROFILEROUTE);
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
                                  imagepath != ''
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            child: imagepath != ''
                                                ? Image.network((imagepath),
                                                    fit: BoxFit.cover)
                                                : Icon(Icons.person,
                                                    color: Colors.black,
                                                    size: 60
                                                    // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                                    ),
                                          ))
                                      : ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Container(
                                            height: 100,
                                            width: 100,

                                            // color: Colors.red,
                                            child: profileimage != ''
                                                ? Image.network(profileimage,
                                                    fit: BoxFit.cover)
                                                : Icon(
                                                    Icons.person,
                                                    color: Colors.black,
                                                    size: 30,
                                                    // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                                  ),
                                          )),
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
                                                            Colors.white),
                                                  ),
                                                ),
                                              )
                                            : name != null
                                                ? Text(name.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ))
                                                : Text("")),
                                    Container(
                                      margin: EdgeInsets.only(top: 15, left: 5),
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
                      Navigator.pushNamed(context, Routes.CLIENTDASHBOARDROUTE);
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
                    onTap: () {},
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

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Color(0xffE5E5E5)),
                    height: MediaQuery.of(context).size.height * (15 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              var index;
                              Navigator.pushNamed(
                                  context, Routes.CLIENTMARKETPLACEROUTE);
                            },
                            child: Row(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 35, top: 5),
                                  child: Text(
                                    'createmarketplace'.tr(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              var index;
                              Navigator.pushNamed(context,
                                  Routes.CLIENTMARKETPLACEBOOKINGROUTE);
                            },
                            child: Row(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 35, top: 5),
                                  child: Text(
                                    'marketplaceproposals'.tr(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          GestureDetector(
                            onTap: () {
                              var index;
                              Navigator.pushNamed(context,
                                  Routes.CLIENTMARKETPLACEBOOKINSHOWGROUTE);
                            },
                            child: Row(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: EdgeInsets.only(left: 35, top: 5),
                                  child: Text(
                                    'marketplacebooking'.tr(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.CLIENTBOOKINGROUTE);
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
                              'booking'.tr(),
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
                          context, Routes.CLIENTORDERHISTORYROUTE);
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
                              'orderhistory'.tr(),
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
                          context, Routes.CLIENTTRANSACTIONROUTE);
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
                                  'assets/images/transicon.png',
                                ),
                                size: 10,
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'transaction'.tr(),
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
                          context, Routes.CLIENTNOTIFICATIONROUTE);
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

                            //     : Container()
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
                      Navigator.pushNamed(context, Routes.CLIENTSETTINGROUTE);
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Color(0xffE5E5E5)),
                    height: MediaQuery.of(context).size.height * (5 / 100),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: GestureDetector(
                      onTap: () {
                        var index;
                        Navigator.pushNamed(
                            context, Routes.CLIENTSUBUSERSROUTE);
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
                  // logOut(),
                  InkWell(
                    onTap: () async {
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();

                      // prefs.remove("companyName");

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
      ),
    );
  }

  Widget logOut() {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.remove("companyName");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreenClient()),
          (Route<dynamic> route) => false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10, bottom: 20),
        // height: adduser == 0 ? h * 0.30 : h * 0.10,
        width: w,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.black),
                  // borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff1A494F)),
              child: Center(
                child: Icon(Icons.logout, color: Colors.white),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Log out",
                    style: TextStyle(
                        color: Color(0xff1A494F),
                        fontSize: 18,
                        fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}
