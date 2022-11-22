// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/ColorUtility.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/broadCastMessageModel.dart';

import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/clientInfo.dart';

import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/orderlist.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class dashboard_ContainerList extends StatefulWidget {
  var data;
  dashboard_ContainerList(this.data);

  @override
  _dashboard_ContainerListState createState() =>
      _dashboard_ContainerListState();
}

class _dashboard_ContainerListState extends State<dashboard_ContainerList>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = TextEditingController();
  TextEditingController edit = new TextEditingController();
  var h, w;
  late TabController tabController;
  int _selectedIndex = 1;
  Color CardColor = Color(0xffF7F6FB);
  var Iamhovering = -1;
  String? name, emailId;
  var clientid;
  late TabController tabController1;

  int? index;
  void _entering(PointerEvent details, index) {
    setState(() {
      Iamhovering = index;
    });
  }

  void _hovering(PointerEvent details, index) {
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
  List<DataResponse>? data1 = [];
  String? client, bookingId, bookingdate, scheduleId, createdAt;
  List<Client>? clientinfo;
  List<Item>? item;

  String? id;

  DateTime initialDate = DateTime.now();

  List<BroadcastUsers> usersList = [];
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();

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

  clientbookingsApi() async {
    var data = {"schedule_id": id.toString()};

    var res = await Providers().shipmentClientBooking(data);
    if (res.status == true) {
      setState(() {
        data1 = res.data;
      });
      for (int i = 0; i < data1!.length; i++) {
        clientinfo = data1![i].client;
        item = data1![i].item;
        for (int c = 0; c < clientinfo!.length; c++) {
          clientid = clientinfo![c].id.toString();
        }

        for (int j = 0; j < item!.length; j++) {
          bookingId = item![j].bookingId.toString();
          scheduleId = item![j].scheduleId.toString();
        }
        for (int l = 0; l < clientinfo!.length; l++) {}

        bookingdate = data1![i].bookingDate.toString();
      }

      print("-=-=-data1 ${bookingId!.length}");
      print("-=-=-data1 ${clientid}");
      print("-=-=-data1 ${scheduleId}");
    }
  }

  //========get messages data
  List<GetBroadcastData>? messagesData = [];
  getAllBroadcastMSGApi() async {
    print("-=-in getAllBroadcastMSGApi ${widget.data['id'].toString()}");
    var data = {"schedule_id": widget.data['id'].toString()};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenSend = prefs.getString('Shipemnt_auth_token');

    var res = await Providers().getAllBroadcastMSG(data, tokenSend);
    print("res.status-=-=-= ${res.status}");
    if (res.status == true) {
      setState(() {
        messagesData = res.data;
      });
      //print("-=-= messagesData $messagesData");
    }
  }

//========get messages data
//
  Widget container_client(index, bookingdata) {
    print(data1![index].client[0]);
    print("clientinfo $bookingdata");

    return Container(
      height: h,
      width: w * 3.0,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.red,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffFFFFFF).withOpacity(0.6),
                Color(0xffF3F3F3).withOpacity(0.36),
              ],
            ),
            // color: Colors.red,
          ),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 10, top: 10),
                      child: Icon(
                        Icons.close,
                        color: Color(0xffC4C4C4),
                      ),
                    ),
                  ),
                ),
                Container(
                  // color: Colors.green,
                  child: Row(
                    children: [
                      Container(
                        height: 75,
                        width: 82,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: data1![index]
                                    .client[0]
                                    .profileimage
                                    .toString() !=
                                ''
                            ? Image.network(
                                data1![index].client[0].profileimage.toString())
                            : Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 55),
                              child: Text(
                                data1![index].client[0].name,
                                style: headingStyle16blackw600(),
                              ),
                            ),
                            Text(
                              data1![index].client[0].email,
                              style: headingStyle12blackw500(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 55),
                          child: Text(
                            "totalorders".tr() + "${data1!.length}",
                            style: headingStyle16blackw600(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 400,
                      height: 50,
                      child: DefaultTabController(
                        initialIndex: 0,
                        length: 3,
                        child: TabBar(
                          controller: tabController,
                          labelColor: Color(0xff1A494F),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Color(0xff1A494F),
                          tabs: <Widget>[
                            Tab(
                              child: Text(
                                "clientinfo".tr(),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "itemdetails".tr(),
                              ),
                            ),
                            Tab(
                              child: Text(
                                "orderhistory".tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 350,
                  width: w * 3.0,
                  child: TabBarView(controller: tabController, children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 7),
                      child: ClientInfo(id: id.toString()),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 10, left: 7),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: (Responsive.isDesktop(context))
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(

                                              // width: 50,
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                "id".tr(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Container(
                                              // width: 50,

                                              // margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                            "bookingid".tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          // Spacer(),
                                          Container(
                                              // width: 50,

                                              // margin: EdgeInsets.only(right: 70),
                                              child: Text(
                                            "category".tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Container(
                                              // width: 50,

                                              // margin: EdgeInsets.only(right: 70),
                                              child: Text(
                                            "quantity".tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          // Spacer(),
                                          Container(
                                              // width: 50,

                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(
                                                "Quantity",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          // Spacer(),
                                        ],
                                      )
                                    : Container(
                                        height: 40,
                                        child: Scrollbar(
                                          isAlwaysShown: true,
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(

                                                        // width: 50,
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "id".tr(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    Container(
                                                        // width: 50,

                                                        // margin: EdgeInsets.only(left: 5),
                                                        child: Text(
                                                      "bookingid".tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    // Spacer(),
                                                    Container(
                                                        // width: 50,

                                                        // margin: EdgeInsets.only(right: 70),
                                                        child: Text(
                                                      "category".tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    Container(
                                                        // width: 50,

                                                        // margin: EdgeInsets.only(right: 70),
                                                        child: Text(
                                                      "quantity".tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    // Spacer(),
                                                    Container(
                                                        // width: 50,

                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        child: Text(
                                                          "Quantity",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    // Spacer(),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                              ),
                              item != null
                                  ? Container(
                                      height: 800,
                                      child: ListView.builder(
                                          itemCount: item!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var jsondata = jsonDecode(
                                                item![index].itemName);
                                            print("rrrrrrrrrrrrrr$jsondata");
                                            return Container(
                                              // width: MediaQuery.of(context)
                                              //         .size
                                              //         .width *
                                              //     (50 / 100),
                                              margin: EdgeInsets.fromLTRB(
                                                  15, 15, 15, 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color: Color(0xffFFFFFF),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        width: 150,
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          item![index]
                                                              .id
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        )),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        width: 180,
                                                        child: Text(
                                                          item![index]
                                                              .bookingId
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        )),
                                                    Container(
                                                        // color: Colors.amber,
                                                        width: 100,
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          item![index]
                                                              .category
                                                              .toString(),
                                                          // overflow: TextOverflow.ellipsis,
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        )),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 40),
                                                      child: Column(
                                                          children:
                                                              List.generate(
                                                        jsondata.length,
                                                        (index) => Container(
                                                          width: 180,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 40,
                                                                  top: 5),
                                                          child: Text(
                                                            jsondata[index]
                                                                    ['itemname']
                                                                .toString(),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          ),
                                                        ),
                                                      )),
                                                    ),
                                                    Column(
                                                        children: List.generate(
                                                      jsondata.length,
                                                      (index) => Container(
                                                        width: 80,
                                                        margin: EdgeInsets.only(
                                                            left: 50, top: 5),
                                                        child: Text(
                                                          jsondata[index]['qty']
                                                              .toString(),
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ))
                                                  ]),
                                            );
                                          }))
                                  : Padding(
                                      padding: EdgeInsets.only(top: 100),
                                      child: Text(
                                        "nomoreitems".tr(),
                                      ))
                            ],
                          ),
                        )),
                    Container(
                      child: OrderList(
                          Id: scheduleId.toString(), cid: bookingdata['cid']),
                    ),
                  ]),
                ),
              ],
            ),
          )),
    );
  }

  Widget container_clientMob(index, bookingdata) {
    print(data1![index].client[0]);
    print("clientinfo $bookingdata");

    return SingleChildScrollView(
      child: Container(
        width: w * 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Color(0xffC4C4C4),
                  ),
                ),
              ),
            ),
            Container(
              width: w * 10,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: data1![index].client[0].profileimage.toString() != ''
                        ? Image.network(
                            data1![index].client[0].profileimage.toString())
                        : Icon(Icons.person),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      children: [
                        Text(
                          data1![index].client[0].name,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data1![index].client[0].email,
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 55),
                            child: Text(
                              "totalorders".tr() + "${data1!.length}",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                              // style: headingStyle16blackw600(),
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
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 350,
                  height: 50,
                  child: DefaultTabController(
                    initialIndex: 0,
                    length: 3,
                    child: TabBar(
                      controller: tabController,
                      labelColor: Color(0xff1A494F),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xff1A494F),
                      tabs: <Widget>[
                        Tab(
                            child: Text("orderdetails".tr(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold))),
                        Tab(
                          child: Text("info".tr(),
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Tab(
                          child: Text("itemdetails".tr(),
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              height: 350,
              width: w * 0.78,
              child: TabBarView(controller: tabController, children: [
                Container(
                  child: OrderList(
                      Id: scheduleId.toString(), cid: bookingdata['cid']),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 7),
                  child: ClientInfo(id: id.toString()),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10, left: 7),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                            child: (Responsive.isDesktop(context))
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(

                                          // width: 50,
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "id".tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          // width: 50,

                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "bookingid".tr(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      // Spacer(),
                                      Container(
                                          // width: 50,

                                          // margin: EdgeInsets.only(right: 70),
                                          child: Text(
                                        "category".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      // Spacer(),
                                      Container(
                                          // width: 50,

                                          // margin: EdgeInsets.only(right: 90),
                                          child: Text(
                                        "quantity".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                      // Spacer(),
                                    ],
                                  )
                                : Container(
                                    height: 50,
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(

                                                    // width: 50,
                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "id".tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                Container(
                                                    // width: 50,

                                                    margin: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text(
                                                      "bookingid".tr(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                // Spacer(),
                                                Container(
                                                    // width: 50,

                                                    // margin: EdgeInsets.only(right: 70),
                                                    child: Text(
                                                  "category".tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                // Spacer(),
                                                Container(
                                                    // width: 50,

                                                    // margin: EdgeInsets.only(right: 90),
                                                    child: Text(
                                                  "quantity".tr(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                // Spacer(),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                          ),
                          item != null
                              ? Container(
                                  height: 800,
                                  child: ListView.builder(
                                      itemCount: item!.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     (50 / 100),
                                            margin: EdgeInsets.fromLTRB(
                                                15, 15, 15, 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Color(0xffFFFFFF),
                                            ),
                                            child: (Responsive.isDesktop(
                                                    context))
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                          width: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            item![index]
                                                                .id
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          )),
                                                      Container(
                                                          width: 50,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            item![index]
                                                                .bookingId
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          )),
                                                      Container(
                                                          // color: Colors.amber,
                                                          width: 100,
                                                          // margin: EdgeInsets.only(left: 10),
                                                          child: Text(
                                                            item![index]
                                                                .category
                                                                .toString(),
                                                            // overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12),
                                                          )),
                                                      Container(
                                                          width: 50,
                                                          // margin: EdgeInsets.only(left: 20),
                                                          child: Text(
                                                            item![index]
                                                                .quantity
                                                                .toString(),
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          )),
                                                    ],
                                                  )
                                                : Container(
                                                    height: 50,
                                                    child: Scrollbar(
                                                      isAlwaysShown: true,
                                                      child: ListView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                    width: 50,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      item![index]
                                                                          .id
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    )),
                                                                Container(
                                                                    width: 50,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                10),
                                                                    child: Text(
                                                                      item![index]
                                                                          .bookingId
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    )),
                                                                Container(
                                                                    // color: Colors.amber,
                                                                    width: 100,
                                                                    // margin: EdgeInsets.only(left: 10),
                                                                    child: Text(
                                                                      item![index]
                                                                          .category
                                                                          .toString(),
                                                                      // overflow: TextOverflow.ellipsis,
                                                                      softWrap:
                                                                          true,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    )),
                                                                Container(
                                                                    width: 50,
                                                                    // margin: EdgeInsets.only(left: 20),
                                                                    child: Text(
                                                                      item![index]
                                                                          .quantity
                                                                          .toString(),
                                                                      softWrap:
                                                                          true,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    )),
                                                              ],
                                                            ),
                                                          ]),
                                                    ),
                                                  ));
                                      }))
                              : Padding(
                                  padding: EdgeInsets.only(top: 100),
                                  child: Text("nomoreitems".tr()),
                                )
                        ],
                      ),
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      id = widget.data['id'].toString();
      print('>>>>>   $id');
      clientbookingsApi();
      getAllBroadcastMSGApi();
    });

    tabController1 = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
      print("Selected Index: " + tabController.index.toString());
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
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
                            child: Wrap(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.SHIPMENTDASHBOARD);
                                  },
                                  child: Text(
                                    'dashboard'.tr() + '>',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  'container'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  if (!Responsive.isDesktop(context))
                    Column(
                      children: [MobileViewlist()],
                    ),
                  if (Responsive.isDesktop(context))
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 500,
                              height: 50,
                              child: DefaultTabController(
                                initialIndex: 0,
                                length: 2,
                                child: TabBar(
                                  controller: tabController1,
                                  labelColor: Color(0xff1A494F),
                                  unselectedLabelColor: Colors.grey,
                                  indicatorColor: Color(0xff1A494F),
                                  tabs: <Widget>[
                                    Container(
                                      width: 200,
                                      child: Tab(
                                        child: Text(
                                          "bookings".tr(),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Tab(
                                        child: Text(
                                          "broadcastmessages".tr(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: h,
                          width: w * 0.80,
                          child:
                              TabBarView(controller: tabController1, children: [
                            Column(
                              children: [
                                orderTemplate(),
                                containerList(),
                              ],
                            ),
                            SingleChildScrollView(
                              child: broadCastMsgContainerList(),
                            ),

                            // SingleChildScrollView(child: containerList()),
                          ]),
                        ),
                      ],
                    )
                ],
              ))),
    );
  }

  //broadcast widget
  Widget broadCastMsgContainerList() {
    final _formKey = GlobalKey<FormState>();
    print(
        "messagesData!.length -=broadCastMsgContainerList ${messagesData!.length}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: data1!.length != 0
              ? GestureDetector(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        // scrollable: true,
                        title: Text(
                          'broadcastmessages'.tr(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        content: Container(
                          height:
                              MediaQuery.of(context).size.height * (50 / 100),
                          width: MediaQuery.of(context).size.width * (50 / 100),
                          child: Form(
                            key: _formKey,
                            child: ListView(
                                scrollDirection: Axis.vertical,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text("title".tr(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            )),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: TextFormField(
                                          maxLength: 25,
                                          onChanged: (value) {},
                                          controller: _textFieldController,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter title';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  new OutlineInputBorder(
                                                // borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              counterText: "",
                                              hintText: "entertitle".tr()),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                        ),
                                        child: Text("message".tr(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            )),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: TextFormField(
                                          maxLines: 5,
                                          maxLength: 250,
                                          onChanged: (value) {},
                                          controller: _textFieldController1,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter message';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  new OutlineInputBorder(
                                                // borderRadius: new BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1.2,
                                                    color: Colors.grey),
                                              ),
                                              counterText: "",
                                              hintText: "entermessage".tr()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.black),
                            height: 40,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (20 / 100)
                                : MediaQuery.of(context).size.width *
                                    (12 / 100),
                            child: TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text('cancel'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Color(0xff4CAF50)),
                            height: 40,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (20 / 100)
                                : MediaQuery.of(context).size.width *
                                    (12 / 100),
                            child: TextButton(
                              onPressed: () async {
                                // user data
                                var type1 = "Client";
                                var type2 = "Shipment";

                                if (_formKey.currentState!.validate()) {
                                  for (var i = 0; i < data1!.length; i++) {
                                    if (data1![i].status != "Cancelled") {
                                      usersList.add(BroadcastUsers(
                                          data1![i].client[0].id, type1));

                                      usersList.add(BroadcastUsers(
                                          int.parse(
                                              data1![i].departureID[0].id),
                                          type2));
                                      usersList.add(BroadcastUsers(
                                          int.parse(data1![i].arrivalID[0].id),
                                          type2));

                                      data1![i].pickupagentID != "0"
                                          ? usersList.add(BroadcastUsers(
                                              int.parse(
                                                  data1![i].pickupagentID),
                                              type2))
                                          : null;

                                      usersList.add(BroadcastUsers(
                                          data1![i].receptionistID, type1));

                                      print(
                                          "-=->>get schedule title ${data1![i].title}");
                                    }
                                  }

                                  print("-=-=usersList>> $usersList");
                                  //return;
                                  var dataPost = {
                                    "schedule_id":
                                        data1![0].scheduleId.toString(),
                                    "users": jsonEncode(usersList).toString(),
                                    "title": _textFieldController.text,
                                    "schedule_title":
                                        data1![0].title.toString(),
                                    "message": _textFieldController1.text,
                                  };

                                  print("-=-=-dataPost $dataPost");
                                  var sendMSGResponse = await Providers()
                                      .sendBroadcastMSG(dataPost);

                                  if (sendMSGResponse.status == true) {
                                    Navigator.pop(context);
                                    print("success");
                                    _textFieldController.clear();
                                    _textFieldController1.clear();

                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content:
                                            Text("Message sent successfully"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'OK');
                                              getAllBroadcastMSGApi();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    print("error");
                                  }
                                }
                              },
                              child: Text('send'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    );
                    // showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     scrollable: true,
                    //     title: Text('Broadcast message'),
                    //     content: Form(
                    //       key: _formKey,
                    //       child: Column(
                    //         children: [
                    //           TextFormField(
                    //             maxLength: 25,
                    //             onChanged: (value) {},
                    //             controller: _textFieldController,
                    //             validator: (value) {
                    //               if (value == null || value.isEmpty) {
                    //                 return 'Please enter title';
                    //               }
                    //               return null;
                    //             },
                    //             decoration: InputDecoration(
                    //                 counterText: "", hintText: "Enter title"),
                    //           ),
                    //           TextFormField(
                    //             maxLines: null,
                    //             maxLength: 250,
                    //             onChanged: (value) {},
                    //             controller: _textFieldController1,
                    //             validator: (value) {
                    //               if (value == null || value.isEmpty) {
                    //                 return 'Please enter message';
                    //               }
                    //               return null;
                    //             },
                    //             decoration: InputDecoration(
                    //                 counterText: "", hintText: "Enter message"),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'Cancel'),
                    //         child: const Text('Cancel'),
                    //       ),
                    //       TextButton(
                    //         onPressed: () async {
                    //           //user data

                    //           if (_formKey.currentState!.validate()) {
                    //             for (var i = 0; i < data1!.length; i++) {
                    //               if (data1![i].status != "Cancelled") {
                    //                 usersList.add(
                    //                     BroadcastUsers(data1![i].client[0].id));

                    //                 usersList.add(BroadcastUsers(int.parse(
                    //                     data1![i].departureID[0].id)));
                    //                 usersList.add(BroadcastUsers(
                    //                     int.parse(data1![i].arrivalID[0].id)));

                    //                 data1![i].pickupagentID != "0"
                    //                     ? usersList.add(BroadcastUsers(
                    //                         int.parse(data1![i].pickupagentID)))
                    //                     : null;

                    //                 usersList.add(BroadcastUsers(
                    //                     data1![i].receptionistID));

                    //                 print(
                    //                     "-=->>get schedule title ${data1![i].title}");
                    //               }
                    //             }

                    //             print("-=-=usersList>> $usersList");
                    //             //return;
                    //             var dataPost = {
                    //               "schedule_id":
                    //                   data1![0].scheduleId.toString(),
                    //               "users": jsonEncode(usersList).toString(),
                    //               "title": _textFieldController.text,
                    //               "schedule_title": data1![0].title.toString(),
                    //               "message": _textFieldController1.text,
                    //             };

                    //             print("-=-=-dataPost $dataPost");
                    //             var sendMSGResponse = await Providers()
                    //                 .sendBroadcastMSG(dataPost);

                    //             if (sendMSGResponse.status == true) {
                    //               Navigator.pop(context);
                    //               print("success");
                    //               _textFieldController.clear();
                    //               _textFieldController1.clear();

                    //               showDialog<String>(
                    //                 context: context,
                    //                 builder: (BuildContext context) =>
                    //                     AlertDialog(
                    //                   content:
                    //                       Text("Message sent successfully"),
                    //                   actions: <Widget>[
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context, 'OK');
                    //                         getAllBroadcastMSGApi();
                    //                       },
                    //                       child: const Text('OK'),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               );
                    //             } else {
                    //               print("error");
                    //             }
                    //           }
                    //         },
                    //         child: const Text('Send'),
                    //       ),
                    //     ],
                    //   ),
                    // );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 15,
                      top: 15,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color(0xff4CAF50)),
                    height: 45,
                    width: (!Responsive.isDesktop(context))
                        ? MediaQuery.of(context).size.width * (30 / 100)
                        : MediaQuery.of(context).size.width * (15 / 100),
                    child: Center(
                      child: Text('sendmessage'.tr(),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              : SizedBox(),
        ),
        messagesData!.length == 0
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
                          'sryyouhavenotanymessagesyet'.tr(),
                          style: headingStyle16MB(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : broadCastShipmentMessagesList(messagesData)
      ],
    );
  }

  Widget orderTemplateMob() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
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
              child: Container(
                  height: 40,
                  // height: (!Responsive.isDesktop(context))
                  //     ? MediaQuery.of(context).size.height * (10 / 100)
                  //     : MediaQuery.of(context).size.height * (45 / 100),

                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
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
                          // Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              "scheduleid".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Text(
                              "clientname".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              "Clientid".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 60),
                            child: Text(
                              "bookingdate".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(left: 120),
                            child: Text(
                              "clientinfo".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 140),
                            child: Text(
                              "status".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            )));
  }

  //broadcast widget
  Widget orderTemplate() {
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
              child: Container(
                height: 40,
                // height: (!Responsive.isDesktop(context))
                //     ? MediaQuery.of(context).size.height * (10 / 100)
                //     : MediaQuery.of(context).size.height * (45 / 100),

                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
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
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        "scheduleid".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Text(
                        "clientname".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        "Clientid".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        "bookingdate".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 120),
                      child: Text(
                        "clientinfo".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 140),
                      child: Text(
                        "status".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Container(
                    //     width: w * 0.06,
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Text(
                    //       "Chat",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
              ),
            )));
  }

  Widget containerListMob() {
    return data1!.length == 0
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
            physics: NeverScrollableScrollPhysics(),
            itemCount: data1!.length,
            //  widget.bId.length,
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
                        child: Container(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
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
                                    for (int l = 0;
                                        l < data1![index].client.length;
                                        l++)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 70),
                                        child: Text(
                                          data1![index].scheduleId.toString(),
                                          style: headingStyle16blacknormal(),
                                        ),
                                      ),
                                    for (int l = 0;
                                        l < data1![index].client.length;
                                        l++)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 110),
                                        child: Text(
                                          data1![index].client[l].name,
                                          style: headingStyle16blacknormal(),
                                        ),
                                      ),
                                    //
                                    //for (int k = 0; k < data1![index].item.length; k++)

                                    for (int l = 0;
                                        l < data1![index].client.length;
                                        l++)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 100),
                                        child: Text(
                                          data1![index].client[l].id.toString(),
                                          style: headingStyle16blacknormal(),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 80),
                                      child: Text(
                                        // data1![index].bookingDate.toString(),
                                        DateFormat("yyyy-MM-dd").format(
                                            DateTime.parse(
                                                data1![index].createdAt)),
                                        style: headingStyle16blacknormal(),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Client list",
                                            style: headingStyle16blackw400(),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              var bookingdata = {
                                                'sid': data1![index].scheduleId,
                                                for (int l = 0;
                                                    l <
                                                        data1![index]
                                                            .client
                                                            .length;
                                                    l++)
                                                  'cid':
                                                      data1![index].client[l].id
                                              };
                                              print(
                                                  "--=-=-=-=-=-====--=$bookingdata");
                                              showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Container(
                                                      width: w * 10,
                                                      child: AlertDialog(
                                                        backgroundColor:
                                                            Colors.white,
                                                        content:
                                                            container_clientMob(
                                                                index,
                                                                bookingdata),
                                                      ),
                                                    );
                                                  });
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
                                      padding: const EdgeInsets.only(
                                          left: 80, right: 20),
                                      child: Container(
                                        // height: 22,
                                        width: 86,
                                        color: Color(0xffFF3D00),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            data1![index].status.toString(),
                                            style: headingStyle12whitew500(),
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                            ],
                          ),
                        ),
                      )));
            });
  }

  Widget containerList() {
    return data1!.length == 0
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
            physics: NeverScrollableScrollPhysics(),
            itemCount: data1!.length,
            //  widget.bId.length,
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
                        child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
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
                                for (int l = 0;
                                    l < data1![index].client.length;
                                    l++)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 70),
                                    child: Text(
                                      data1![index].scheduleId.toString(),
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                for (int l = 0;
                                    l < data1![index].client.length;
                                    l++)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 110),
                                    child: Text(
                                      data1![index].client[l].name,
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                for (int l = 0;
                                    l < data1![index].client.length;
                                    l++)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: Text(
                                      data1![index].client[l].id.toString(),
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 80),
                                  child: Text(
                                    // data1![index].bookingDate.toString(),
                                    DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(
                                            data1![index].createdAt)),
                                    style: headingStyle16blacknormal(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: Row(
                                    children: [
                                      Text(
                                        "clientlist".tr(),
                                        style: headingStyle16blackw400(),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          var bookingdata = {
                                            'sid': data1![index].scheduleId,
                                            for (int l = 0;
                                                l < data1![index].client.length;
                                                l++)
                                              'cid': data1![index].client[l].id
                                          };
                                          print(
                                              "--=-=-=-=-=-====--=$bookingdata");
                                          showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  margin: EdgeInsets.only(
                                                      left: 100,
                                                      // top: 250,
                                                      top: 80),
                                                  child: AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    content: container_client(
                                                        index, bookingdata),
                                                  ),
                                                );
                                              });
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
                                  padding: const EdgeInsets.only(
                                      left: 80, right: 20),
                                  child: Container(
                                    // height: 22,
                                    width: 86,
                                    color: Color(0xffFF3D00),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        data1![index].status.toString(),
                                        style: headingStyle12whitew500(),
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      )));
            });
  }

  Widget MobileViewlist() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 500,
              height: 50,
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: TabBar(
                  controller: tabController1,
                  labelColor: Color(0xff1A494F),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Color(0xff1A494F),
                  tabs: <Widget>[
                    Container(
                      width: 200,
                      child: Tab(
                        child: Text(
                          "bookings".tr(),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Tab(
                        child: Text(
                          "broadcastmessages".tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: h,
          width: MediaQuery.of(context).size.width,
          child: TabBarView(controller: tabController1, children: [
            Column(
              children: [
                orderTemplateMob(),
                containerListMob(),
              ],
            ),
            // SingleChildScrollView(child: containerList()),
            SingleChildScrollView(
              child: broadCastMsgContainerList(),
            ),
          ]),
        ),
      ],
    );
  }
}

Widget broadCastShipmentMessagesList(mSGdata) {
  print("in list mSGdata $mSGdata");
  return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: mSGdata!.length,
      shrinkWrap: true,
      reverse: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 1.0,
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 15.0, left: 15.0),
                  width: 150.0,
                  height: 150.0,
                  child: mSGdata![index].shipmentprofile != ""
                      ? Image.network(mSGdata![index].shipmentprofile)
                      : Icon(Icons.person),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 12.0, bottom: 10.0),
                              child: Text(
                                mSGdata![index].scheduleTitle.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, size: 25),
                            color: Colors.black,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              'sendto'.tr(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          color: Colors.blueAccent,
                                        ),
                                        content: setupAlertDialoadContainer(
                                            mSGdata![index].users),
                                      ));
                            },
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: Text(
                          mSGdata![index].title.toString(),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: Text(
                                mSGdata![index].message.toString(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10.0, right: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 5.0),
                                    child: Text(mSGdata![index]
                                        .createdAt!
                                        .substring(11, 19))),
                                Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child: Text(mSGdata![index]
                                        .createdAt!
                                        .substring(0, 10))),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Widget setupAlertDialoadContainer(userListData) {
  print("userListData-=- $userListData");
  return Container(
    height: 300.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: userListData.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userListData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Color(0xffFFFFFF).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: ListTile(
                    title: Text(userListData[index].name.toString()),
                    leading: userListData[index].image != ""
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(userListData[index].image))
                        : Icon(Icons.person),
                  ),
                ),
              );
            },
          )
        : Text("datanotavailable".tr()),
  );
}

class BroadcastUsers {
  int? userID;
  String? type;

  BroadcastUsers(this.userID, this.type);

  BroadcastUsers.fromJson(Map<String, dynamic> json) {
    userID = json['userId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': userID,
      'type': type,
    };
  }
}
