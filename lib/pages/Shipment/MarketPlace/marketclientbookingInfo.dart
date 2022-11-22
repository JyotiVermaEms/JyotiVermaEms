import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/extensions.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Container_Details.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/arrivalDetails.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/arrivalInfo.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/clientInfo.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/orderlist.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class MarketClientBody extends StatefulWidget {
  var data;
  MarketClientBody(this.data);

  @override
  _MarketClientBody createState() => _MarketClientBody();
}

class _MarketClientBody extends State<MarketClientBody>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  late TabController tabController;
  Color CardColor = Color(0xffF7F6FB);
  bool Iamhovering = false;
  String? id;
  List<DataResponse>? data1 = [];
  List<Client>? clientinfo;
  List<Item>? item;
  String? client, bookingId, bookingdate, scheduleId;
  int _selectedIndex = 1;
  var imageList = [];
  int _currentIndex = 0;

  void _entering(PointerEvent details, int index) {
    setState(() {
      Iamhovering = false;
    });
  }

  void _hovering(PointerEvent details, int index) {
    setState(() {
      Iamhovering = true;
    });
  }

  String? clientid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("-=-=-=-=-=-=${widget.data}");
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    // print("dsnsdgs" + widget.data['id']);
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: ShipmentSidebar(),
        ),
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
            right: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(children: [
                Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (Responsive.isDesktop(context)) SizedBox(width: 5),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                      child: Text(
                        'clientdetails'.tr(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: (Responsive.isDesktop(context))
                              ? const EdgeInsets.only(
                                  left: 30, top: 20, right: 10)
                              : const EdgeInsets.only(
                                  left: 10, top: 20, right: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                (Responsive.isDesktop(context))
                    ? SingleChildScrollView(
                        child: Row(
                          children: [
                            Column(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 50),
                                  child: widget.data['profileimage'].isNotEmpty
                                      ? Container(
                                          child: Image.network(
                                            widget.data['profileimage'],
                                            fit: BoxFit.cover,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 350,
                                          width: 350,
                                        )
                                      : Container(
                                          child: Icon(
                                            Icons.person,
                                            size: 200.0,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 350,
                                          width: 350,
                                        )),
                            ]),
                            SizedBox(
                              width: 40,
                            ),
                            Container(
                                child: Container(
                              // height: 350,
                              child: Column(
                                children: [
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Client Id",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 40,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['id'].toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "First Name",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['name'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Last Name",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['lname'],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Email ID",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['email'].toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Mobile Number",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['phone'].toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Country",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 50,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Text(
                                            widget.data['country'].toString(),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Container(
                                        width: 120,
                                        child: Text(
                                          "Address",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20,
                                      ),
                                      child: Container(
                                        height: 60,
                                        width: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              widget.data['address'].toString(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ))
                          ],
                        ),
                      )
                    : Container(
                        height: h * 0.9,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 50, right: 20),
                                child: widget.data['profileimage'].isNotEmpty
                                    ? Container(
                                        child: Image.network(
                                          widget.data['profileimage'],
                                          fit: BoxFit.cover,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 300,
                                        width: 300,
                                      )
                                    : Container(
                                        child: Icon(
                                          Icons.person,
                                          size: 200.0,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 350,
                                        width: 350,
                                      )),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "Clientid".tr(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 20, top: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  widget.data['id'].toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 120,
                                child: Text(
                                  "firstname".tr(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                              ),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 20, top: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  widget.data['name'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 120,
                                child: Text(
                                  "lastname".tr(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                              ),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 20, top: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  widget.data['lname'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 120,
                                child: Text(
                                  "email".tr(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                              ),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 20, top: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  widget.data['email'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                width: 120,
                                child: Text(
                                  "country".tr(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15,
                              ),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 20, top: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text(
                                  widget.data['country'],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ]),
            ),
          ),
        ));
  }

  Widget MobileViewlist() {
    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: MediaQuery.of(context).size.height * (50 / 100),
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
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Container Name",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Container 1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      color: Color(0xffFF3D00),
                      width: MediaQuery.of(context).size.width * (20 / 100),
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: Center(
                          child: Text("Pending",
                              style: headingStyle12whitew500())),
                    )
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Client list",
                        style: headingStyle16blackw400(),
                      ),
                      IconButton(
                        onPressed: () {
                          // showDialog(
                          //     barrierColor: Colors.transparent,
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return Container(
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(10))),
                          //         margin: EdgeInsets.only(
                          //             left: 100,
                          //             // top: 250,
                          //             top: 80),
                          //         child: AlertDialog(
                          //           backgroundColor: Colors.white,
                          //           content: Container_Client,
                          //         ),
                          //       );
                          //     });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 35,
                          color: Color(0xff1A494F),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/car.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Car",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffEFEFEF),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height: 31,
                              width: 31,
                              child: Center(
                                child: Text("3",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/box.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Boxes",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("6",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/slidervertical.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Barrel",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("12",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/Group 840.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Tv",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("6",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 45, top: 5),
                        height: 15,
                        width: 15,
                        child: ImageIcon(
                          AssetImage(
                            'assets/images/bus.png',
                          ),
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Fridge",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 15,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffEFEFEF),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: 31,
                          width: 31,
                          child: Center(
                            child: Text("12",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class Details extends StatefulWidget {
  var data;
  Details(this.data);

  @override
  _Details createState() => _Details();
}

class _Details extends State<Details> {
  var imageList = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data['itemdetail'].length; i++) {
      print("-=-=- ${widget.data['itemdetail'][i]}");
      // imageList.add(widget.data['itemdetail'][i].itemImage);
      // print("jgjkgjkjkgjkj $imageList");

      // for (int i = 0; i < widget.data['itemimage1'].length; i++) {
      //   print("in loop");

      for (int i2 = 0;
          i2 < widget.data['itemdetail'][i].itemImage.length;
          i2++) {
        imageList.add(widget.data['itemdetail'][i].itemImage[i2]);
      }
    }
    print(":imageList");
    //   print(imageList);
    // }
    // print(widget.data['itemimage1'].item);
    // for (int i = 0; i < widget.data['itemimage1'].length; i++) {
    //   print("in loop 2");
    //   // print(widget.data['itemimage1']);
    //   // imageList.add(widget.data['itemimage1'].itemImage[i]);
    //   // print(":imageList");
    //   // print(imageList);
    // }
  }

  var w, h;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    var _currentIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
      child: Column(children: [
        orderTemplate(),
        orderDetails(),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Divider(
            height: 30,
            color: Colors.black,
            thickness: 2,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
              child: Text(
                "Item Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        ),
        Expanded(
          child: Container(
              // margin: EdgeInsets.only(top: 10, bottom: 10),
              width: w * 0.75,
              height: h * 0.50,
              // color: Color(0xffE5E5E5),
              // decoration: BoxDecoration(
              //     border: Border.all(width: 0.5, color: Colors.black),
              //     borderRadius: BorderRadius.circular(10.0),
              //     color: Colors.white),
              child: ListView.builder(
                  itemCount: widget.data['itemdetail'].length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    print("+++++++++++${{
                      widget.data['itemdetail'][index].category
                    }}");
                    var jsondata =
                        jsonDecode(widget.data['itemdetail'][index].itemName);
                    print("-=--=-=-=$jsondata");
                    print("-=--=-=-=${jsondata.length}");
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: widget.data['itemdetail'][index]
                                                .itemImage.length !=
                                            0
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              autoPlay: true,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                                //print(_currentIndex);
                                              },
                                            ),
                                            items: widget
                                                .data['itemdetail'][index]
                                                .itemImage
                                                .map<Widget>((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                widget
                                                                    .data[
                                                                        'itemdetail']
                                                                        [index]
                                                                    .itemImage);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          height: 150,
                                                          width: 230,
                                                          child: Image.network(
                                                            item,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Center(
                                            child: Text(
                                            "No Image Available",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 150,
                                    width: 230,
                                  ),
                                  // Container(
                                  //     height: 100,
                                  //     width: 150,
                                  //     child: Image.asset(
                                  //       "assets/images/BMW.png",
                                  //       fit: BoxFit.cover,
                                  //     )
                                  //     // CircleAvatar(
                                  //     //   backgroundColor: Colors.transparent,
                                  //     //   backgroundImage: AssetImage(
                                  //     //       "assets/images/Ellipse7.png"),
                                  //     // ),
                                  //     ),
                                  SizedBox(width: kDefaultPadding / 2),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Category : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .caption!
                                            //     .copyWith(
                                            //       color: Colors.black,
                                            //     ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.data['itemdetail'][index]
                                                    .category +
                                                "  " +
                                                "(" +
                                                "Quantity :" +
                                                widget.data['itemdetail'][index]
                                                    .quantity
                                                    .toString() +
                                                ")",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .caption!
                                            //     .copyWith(
                                            //       color: Colors.black,
                                            //     ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Text(
                                            "Item Name : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .caption!
                                            //     .copyWith(
                                            //       color: Colors.black,
                                            //     ),
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
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                jsondata[index]['name'] + ",",
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Description : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .caption!
                                            //     .copyWith(
                                            //       color: Colors.black,
                                            //     ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Container(
                                            height: 50,
                                            width: 800,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget
                                                      .data['itemdetail'][index]
                                                      .description
                                                      .toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)
                                                  // style: Theme.of(context)
                                                  //     .textTheme
                                                  //     .caption!
                                                  //     .copyWith(
                                                  //       color: Colors.black,
                                                  //     ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                  // Text.rich(
                                  //   TextSpan(
                                  //     text: "jsdkjksjf",
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w500,
                                  //       color: kTextColor,
                                  //     ),

                                  //   ),
                                  // ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(0, 10),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(11, 19),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(0, 10),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // SizedBox(height: 5),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(height: kDefaultPadding / 2),
                              // Text(
                              //   chat!.body,
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: Theme.of(context).textTheme.caption!.copyWith(
                              //         height: 1.5,
                              //         color: isActive ? Colors.white70 : null,
                              //       ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        ),
        // SingleChildScrollView(
        //   child: Row(
        //     children: [
        //       Column(children: [
        //         Padding(
        //           padding: const EdgeInsets.only(left: 20),
        //           child: Container(
        //             child: imageList.isNotEmpty
        //                 ? CarouselSlider(
        //                     options: CarouselOptions(
        //                       enableInfiniteScroll: false,
        //                       autoPlay: true,
        //                       onPageChanged: (index, reason) {
        //                         setState(() {
        //                           _currentIndex = index;
        //                         });
        //                         //print(_currentIndex);
        //                       },
        //                     ),
        //                     items: imageList
        //                         .map((item) => InkWell(
        //                               onTap: () {
        //                                 showDialog(
        //                                   context: context,
        //                                   builder: (BuildContext context) {
        //                                     return imageViewDialog(
        //                                         context, item);
        //                                   },
        //                                 );
        //                               },
        //                               child: Image.network(
        //                                 item,
        //                                 fit: BoxFit.cover,
        //                               ),
        //                             ))
        //                         .toList(),
        //                   )
        //                 : Center(
        //                     child: Text(
        //                     "No Image Available",
        //                     style: TextStyle(
        //                         color: Colors.black,
        //                         fontSize: 16,
        //                         fontWeight: FontWeight.bold),
        //                   )),
        //             decoration: BoxDecoration(
        //                 color: Colors.white,
        //                 borderRadius: BorderRadius.circular(15)),
        //             height: 350,
        //             width: 500,
        //           ),
        //         ),
        //         // Row(children: [
        //         //   Padding(
        //         //     padding: const EdgeInsets.only(top: 20),
        //         //     child: Container(
        //         //       width: 120,
        //         //       child: Text(
        //         //         "Total Amount",
        //         //         style: TextStyle(color: Colors.black),
        //         //       ),
        //         //     ),
        //         //   ),
        //         //   Padding(
        //         //     padding: const EdgeInsets.only(
        //         //       top: 10,
        //         //     ),
        //         //     child: Container(
        //         //       height: 50,
        //         //       width: 200,
        //         //       decoration: BoxDecoration(
        //         //           color: Colors.white,
        //         //           borderRadius: BorderRadius.circular(15)),
        //         //       child: Center(
        //         //         child: Text(
        //         //           widget.data['totalamount'].toString(),
        //         //           style: TextStyle(color: Colors.black),
        //         //         ),
        //         //       ),
        //         //     ),
        //         //   ),
        //         // ]),
        //       ]),
        //       SizedBox(
        //         width: 40,
        //       ),
        //       Container(
        //           child: Container(
        //         // height: 350,
        //         child: Column(
        //           children: [
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Order Type",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickuptype'],
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Pickup Location",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickuplocation'],
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Pickup Date",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickupdate'].toString(),
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Pickup Time",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickuptime'].toString(),
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Pickup Distance",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickupdistance'].toString(),
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Pickup Estimate",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['pickupestimate'].toString(),
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //             // Row(
        //             //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             //     children: [
        //             //       Padding(
        //             //         padding: const EdgeInsets.only(top: 10),
        //             //         child: Container(
        //             //           width: 120,
        //             //           child: Text(
        //             //             "Transaction Id",
        //             //             style: TextStyle(color: Colors.black),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //       Padding(
        //             //         padding: const EdgeInsets.only(
        //             //           top: 10,
        //             //         ),
        //             //         child: Container(
        //             //           height: 40,
        //             //           width: 120,
        //             //           decoration: BoxDecoration(
        //             //               color: Colors.white,
        //             //               borderRadius: BorderRadius.circular(15)),
        //             //           child: Center(
        //             //             child: Text(
        //             //               widget.data['transactionid'].toString(),
        //             //               style: TextStyle(color: Colors.black),
        //             //             ),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //       Padding(
        //             //         padding: const EdgeInsets.only(top: 10, left: 10),
        //             //         child: Container(
        //             //           width: 120,
        //             //           child: Text(
        //             //             "Total Amount",
        //             //             style: TextStyle(color: Colors.black),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //       Padding(
        //             //         padding: const EdgeInsets.only(
        //             //           top: 10,
        //             //         ),
        //             //         child: Container(
        //             //           height: 40,
        //             //           width: 120,
        //             //           decoration: BoxDecoration(
        //             //               color: Colors.white,
        //             //               borderRadius: BorderRadius.circular(15)),
        //             //           child: Center(
        //             //             child: Text(
        //             //               widget.data['totalamount'].toString(),
        //             //               style: TextStyle(color: Colors.black),
        //             //             ),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //     ]),
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(top: 10),
        //                 child: Container(
        //                   width: 120,
        //                   child: Text(
        //                     "Transaction Id",
        //                     style: TextStyle(color: Colors.black),
        //                   ),
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(
        //                   top: 10,
        //                 ),
        //                 child: Container(
        //                   height: 50,
        //                   width: 400,
        //                   decoration: BoxDecoration(
        //                       color: Colors.white,
        //                       borderRadius: BorderRadius.circular(15)),
        //                   child: Center(
        //                     child: Text(
        //                       widget.data['transactionid'].toString(),
        //                       style: TextStyle(color: Colors.black),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ]),
        //           ],
        //         ),
        //       ))
        //     ],
        //   ),
        // )
      ]),
    );
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 55,
      width: MediaQuery.of(context).size.width * (95 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 80,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Arrival Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                "Company",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: 90,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          // Container(
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //   "Shipment Comapny",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          // Spacer(),
          // Container(
          //     width: 100,
          //     margin: EdgeInsets.only(right: 20),
          //     child: Text(
          //       "Company",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 80,
            width: MediaQuery.of(context).size.width * (98 / 100),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF).withOpacity(0.5),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 80,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.data['id'].toString(),
                      //{widget.data['id']}.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.data['bookingdate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.data['arrivaldate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.data['title'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 20),
                    child: Text(
                      widget.data['type'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                      widget.data['shipcmpany'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                // Container(
                //     width: 80,
                //     // margin: EdgeInsets.only(right: 30),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
                // Spacer(),
                // Container(
                //     margin: EdgeInsets.only(left: 30),
                //     child: Text(
                //       "CMA CGM",
                //       // style: TextStyle(fontWeight: FontWeight.bold),
                //     )),

                // Container(
                //     width: 100,
                //     margin: EdgeInsets.only(right: 20),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
              ],
            ),
          );
        });
  }
}
