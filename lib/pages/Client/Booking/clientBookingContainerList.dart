import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/Shipment/broadCastMessageModel.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Client/Booking/tab2clientbookingdetails.dart';
import '../../../Element/LinearGradient copy.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;

class ClientViewDetailsBody extends StatefulWidget {
  var data;
  ClientViewDetailsBody(this.data);

  @override
  _ClientViewDetailsBodyState createState() => _ClientViewDetailsBodyState();
}

class _ClientViewDetailsBodyState extends State<ClientViewDetailsBody>
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
        for (int j = 0; j < item!.length; j++) {
          bookingId = item![j].bookingId.toString();
          scheduleId = item![j].scheduleId.toString();
        }
        for (int l = 0; l < clientinfo!.length; l++) {}

        bookingdate = data1![i].bookingDate.toString();
      }
    }
  }

  //========get messages data
  List<GetBroadcastData>? messagesData = [];
  getAllBroadcastMSGApi() async {
    print("-=-in getAllBroadcastMSGApi ${widget.data['schedule_id']}");
    // return;
    var data = {"schedule_id": widget.data['schedule_id'].toString()};

    var tokenSend = '';

    var res = await Providers().getAllUserBroadcastMSG(data);
    print("res.status-=-=-= ${res.status}");
    if (res.status == true) {
      setState(() {
        messagesData = res.data;
      });
      print("-=-= messagesData ${messagesData!.length}");
    }
  }
//========get messages data

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("HKFJHJHJHFJHJFH${widget.data}");

    // print('>>>>>   $id');
    // clientbookingsApi();
    // imageList.add(widget.data['profileimage']);

    tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
      print("Selected Index: " + tabController.index.toString());
    });
    getAllBroadcastMSGApi();
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
        child: SideBar(),
      ),
      body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: Padding(
                padding: (Responsive.isDesktop(context))
                    ? const EdgeInsets.symmetric(horizontal: kDefaultPadding)
                    : const EdgeInsets.symmetric(horizontal: 5),
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
                        child: (Responsive.isDesktop(context))
                            ? Text(
                                'Dashboard > Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'Dashboard > Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                        // Spacer(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 600,
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
                              Container(
                                width: 200,
                                child: Tab(
                                  child: Text("Booking Details",
                                      style: TextStyle(
                                          fontSize:
                                              (Responsive.isDesktop(context))
                                                  ? 14
                                                  : 10)),
                                ),
                              ),
                              Container(
                                width: 200,
                                child: Tab(
                                  child: Text("Pickup / Dropoff Details",
                                      style: TextStyle(
                                          fontSize:
                                              (Responsive.isDesktop(context))
                                                  ? 14
                                                  : 10)),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  width: 200,
                                  child: Text("Receptionist Info",
                                      style: TextStyle(
                                          fontSize:
                                              (Responsive.isDesktop(context))
                                                  ? 14
                                                  : 10)),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  width: 200,
                                  child: Text("Broadcast Messages",
                                      style: TextStyle(
                                          fontSize:
                                              (Responsive.isDesktop(context))
                                                  ? 14
                                                  : 9)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                      // height: h * 0.78,
                      // width: w * 0.78,
                      // width: double.infinity,
                      child: TabBarView(controller: tabController, children: [
                    Container(
                      child: BookingDetails(data),
                    ),
                    Container(
                      child: PickuDropoffDetails(data),
                    ),
                    (Responsive.isDesktop(context))
                        ? SingleChildScrollView(
                            child: Row(
                              children: [
                                Column(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 50),
                                      child:
                                          widget.data['profileimage'].isNotEmpty
                                              ? Container(
                                                  child: Image.network(
                                                    widget.data['profileimage'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
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
                                                          BorderRadius.circular(
                                                              15)),
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
                                          padding:
                                              const EdgeInsets.only(top: 40),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "Receptionist Id",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "First Name",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "Last Name",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "Email Id",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                widget.data['email'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "Associate Company Name",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                widget.data['company']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 120,
                                            child: Text(
                                              "Country",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                                                widget.data['country']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
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
                            height: h * 0.8,
                            child: ListView(
                              children: [
                                Column(children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 20),
                                      child:
                                          widget.data['profileimage'].isNotEmpty
                                              ? Container(
                                                  child: Image.network(
                                                    widget.data['profileimage'],
                                                    fit: BoxFit.cover,
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
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
                                                          BorderRadius.circular(
                                                              15)),
                                                  height: 310,
                                                  width: w * 0.8,
                                                )),
                                ]),
                                SizedBox(
                                  width: 40,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  // height: 350,
                                  child: Column(
                                    children: [
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "Receptionist Id",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 40,
                                          ),
                                          child: Container(
                                            height: h * 0.07,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['id'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "First Name",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Container(
                                            height: h * 0.07,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['name'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "Last Name",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Container(
                                            height: h * 0.07,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['lname'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "Email Id",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Container(
                                            height: h * 0.07,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['email'],
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "Associate Company Name",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Container(
                                            height: h * 0.09,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['company']
                                                    .toString(),
                                                softWrap: true,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: Container(
                                            width: 105,
                                            child: Text(
                                              "Country",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Container(
                                            height: h * 0.09,
                                            width: w * 0.54,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                              child: Text(
                                                widget.data['country']
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                    messagesData!.isEmpty
                        ? Container(
                            height: 80,
                            //width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              elevation: 1,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: linearGradientForWhiteCard(),
                                child: Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Text(
                                      'Sorry, You have not any Messages yet',
                                      style: headingStyle16MB(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : (Responsive.isDesktop(context))
                            ? SingleChildScrollView(
                                child: broadCastMessagesList(messagesData))
                            : SingleChildScrollView(
                                child:
                                    mobilebroadCastMessagesList(messagesData))
                  ])),
                ]),
              ))),
    );
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

class BookingDetails extends StatefulWidget {
  var data;
  BookingDetails(this.data);

  @override
  _BookingDetails createState() => _BookingDetails();
}

class _BookingDetails extends State<BookingDetails> {
  var imageList = [];
  var showitemname = [];
  var itemList;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data['itemdetail'].length; i++) {
      print("-=-=-=-=-=${widget.data['itemdetail'][i].quantity.toString()} ");
      print("-=-=-=-=-=${widget.data['itemdetail'][i].itemName.toString()} ");
    }
  }

  var w, h;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    var _currentIndex = 0;
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
      child: (Responsive.isDesktop(context))
          ? Column(children: [
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
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 5),
                    child: Text(
                      "Item Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
              ),
              Expanded(
                child: Container(
                    // margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: w * 0.80,
                    height: h * 0.55,
                    child: ListView.builder(
                        itemCount: widget.data['itemdetail'].length,
                        reverse: false,
                        itemBuilder: (context, index) {
                          var jsondata =
                              widget.data['itemdetail'][index].itemName;
                          print("ehdjhjkdhjhd$jsondata");
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
                                          child: widget
                                                      .data['itemdetail'][index]
                                                      .itemImage
                                                      .length !=
                                                  0
                                              ? CarouselSlider(
                                                  options: CarouselOptions(
                                                    enableInfiniteScroll: false,
                                                    autoPlay: true,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      setState(() {
                                                        _currentIndex = index;
                                                      });
                                                      print(_currentIndex);
                                                    },
                                                  ),
                                                  items:
                                                      widget
                                                          .data['itemdetail']
                                                              [index]
                                                          .itemImage
                                                          .map<Widget>(
                                                              (item) => InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          print(
                                                                              "in dialog client $_currentIndex");
                                                                          return imageViewDialog(
                                                                              context,
                                                                              _currentIndex,
                                                                              widget.data['itemdetail'][index].itemImage);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            230,
                                                                        child: Image
                                                                            .network(
                                                                          item,
                                                                          fit: BoxFit
                                                                              .cover,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 150,
                                          width: 230,
                                        ),
                                        SizedBox(width: kDefaultPadding / 2),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "Category : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  widget
                                                          .data['itemdetail']
                                                              [index]
                                                          .category +
                                                      ",",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
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
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Row(
                                                    children: List.generate(
                                                  jsondata.length,
                                                  (index) => Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        jsondata[index]
                                                                .itemname +
                                                            ",",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 7, 10, 7),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                            color: Color(
                                                                0xffEFEFEF)),
                                                        child: Text(
                                                          jsondata[index].qty,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                )),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  "Description : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Container(
                                                  height: 80,
                                                  width: 600,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                          widget
                                                              .data[
                                                                  'itemdetail']
                                                                  [index]
                                                              .description
                                                              .toString(),
                                                          softWrap: true,
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
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [],
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
            ])
          : SingleChildScrollView(
              child: Container(
                height: h * 0.9,
                child: Column(children: [
                  ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          height: h * 0.15,
                          width: MediaQuery.of(context).size.width * (98 / 100),
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFFFFFF).withOpacity(0.5),
                          ),
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(children: [
                                        Container(
                                            width: 80,
                                            margin: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              "ID",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 80,
                                            margin: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              widget.data['id'].toString(),
                                              //{widget.data['id']}.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: 100,
                                            // margin: EdgeInsets.only(right: 70),
                                            child: Text(
                                              "Booking Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              widget.data['bookingdate']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                            ),
                                            width: 100,
                                            // margin: EdgeInsets.only(right: 70),
                                            child: Text(
                                              "Arrival Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                            ),
                                            child: Text(
                                              widget.data['arrivaldate']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                            ),
                                            child: Text(
                                              "Title",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(
                                              top: 10,
                                              left: 20,
                                            ),
                                            child: Text(
                                              widget.data['title'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "Type",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 100,
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              widget.data['type'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            width: 120,
                                            margin: EdgeInsets.only(
                                                right: 16, top: 10),
                                            child: Text(
                                              "Company",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Container(
                                            width: 120,
                                            margin: EdgeInsets.only(
                                                right: 15, top: 10),
                                            child: Text(
                                              widget.data['shipcmpany']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            )),
                                      ]),
                                      Column(children: [
                                        Container(
                                            width: 120,
                                            margin: EdgeInsets.only(
                                                left: 20, top: 10),
                                            child: Text(
                                              "Action",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        InkWell(
                                          onTap: () {
                                            var id =
                                                widget.data['id'].toString();
                                            var type =
                                                widget.data['type'].toString();
                                            var bookingdate = widget
                                                .data['bookingdate']
                                                .toString();
                                            var status = widget
                                                .data['bookingStatus']
                                                .toString();
                                            var itemimage = widget
                                                .data['itemimage']
                                                .toString();
                                            var comment = widget.data['comment']
                                                .toString();
                                            var itemimage1 = widget
                                                .data['itemimage1']
                                                .toString();
                                            var comment1 = widget
                                                .data['comment1']
                                                .toString();
                                            var depatureimage = widget
                                                .data['depatureimage']
                                                .toString();
                                            var depaturecomment = widget
                                                .data['depaturecomment']
                                                .toString();
                                            var arrivalimage = widget
                                                .data['arrivalimage']
                                                .toString();
                                            var arrivalcomment = widget
                                                .data['arrivalcomment']
                                                .toString();
                                            var receptionistimage = widget
                                                .data['receptionistimage']
                                                .toString();
                                            var receptionistcomment = widget
                                                .data['receptionistcomment']
                                                .toString();
                                            var pickupType = widget
                                                .data['pickuptype']
                                                .toString();

                                            print(id);

                                            print(type);
                                            print(bookingdate);
                                            print(status);
                                            print(widget.data['pickuptype']);

                                            widget.data['pickuptype'] ==
                                                    "Pick up"
                                                ? showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialogBoxClient(
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
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialogBoxClientDropOff(
                                                            id,
                                                            type,
                                                            bookingdate,
                                                            status,
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
                                              height: 40,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              // width:
                                              margin: EdgeInsets.only(
                                                  right: 15, top: 10),
                                              child: Center(
                                                child: Text(
                                                  "View Path",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              )),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }),
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
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 5),
                        child: Text(
                          "Item Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        width: w * 0.90,
                        height: h * 0.40,
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: widget.data['itemdetail'].length,
                              // reverse: false,
                              itemBuilder: (context, index) {
                                var jsondata =
                                    widget.data['itemdetail'][index].itemName;
                                print("ehdjhjkdhjhd$jsondata");
                                print("-=--=-=-=${jsondata.length}");
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          child: widget
                                                      .data['itemdetail'][index]
                                                      .itemImage
                                                      .length !=
                                                  0
                                              ? CarouselSlider(
                                                  options: CarouselOptions(
                                                    enableInfiniteScroll: false,
                                                    autoPlay: true,
                                                    onPageChanged:
                                                        (index, reason) {
                                                      setState(() {
                                                        _currentIndex = index;
                                                      });
                                                      print(_currentIndex);
                                                    },
                                                  ),
                                                  items: widget
                                                      .data['itemdetail'][index]
                                                      .itemImage
                                                      .map<Widget>(
                                                          (item) => InkWell(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      print(
                                                                          "in dialog client $_currentIndex");
                                                                      return imageViewDialog(
                                                                          context,
                                                                          _currentIndex,
                                                                          widget
                                                                              .data['itemdetail'][index]
                                                                              .itemImage);
                                                                    },
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                  // margin:
                                                                  //     EdgeInsets.only(
                                                                  //   top:
                                                                  //       10,
                                                                  // ),
                                                                  height: 350,
                                                                  width: w * 2,
                                                                  child: Image
                                                                      .network(
                                                                    item,
                                                                    fit: BoxFit
                                                                        .cover,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          height: 300,
                                          width: 300,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                ),
                                                child: Text(
                                                  "Category : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  widget
                                                          .data['itemdetail']
                                                              [index]
                                                          .category +
                                                      ",",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20, top: 10),
                                                child: Text(
                                                  "Item Name : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Container(
                                                  height: 40,
                                                  width: w * 0.6,
                                                  child: Scrollbar(
                                                    isAlwaysShown: true,
                                                    child: ListView(
                                                        addRepaintBoundaries:
                                                            true,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        children: [
                                                          Row(
                                                              children:
                                                                  List.generate(
                                                            jsondata.length,
                                                            (index) => Row(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Text(
                                                                      jsondata[index]
                                                                              .itemname +
                                                                          ",",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              7,
                                                                              10,
                                                                              7),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0),
                                                                          color:
                                                                              Color(0xffEFEFEF)),
                                                                      child:
                                                                          Text(
                                                                        jsondata[index]
                                                                            .qty,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          )),
                                                        ]),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 20,
                                                ),
                                                child: Text(
                                                  "Description : ",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                ),
                                                child: Container(
                                                  height: h * 0.1,
                                                  width: w * 0.6,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child: Text(
                                                          widget
                                                              .data[
                                                                  'itemdetail']
                                                                  [index]
                                                              .description
                                                              .toString(),
                                                          softWrap: true,
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )),
                  ),
                ]),
              ),
            ),
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
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                "Action",
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

                InkWell(
                  onTap: () {
                    var id = widget.data['id'].toString();
                    var type = widget.data['type'].toString();
                    var bookingdate = widget.data['bookingdate'].toString();
                    var status = widget.data['bookingStatus'].toString();
                    var itemimage = widget.data['itemimage'].toString();
                    var comment = widget.data['comment'].toString();
                    var itemimage1 = widget.data['itemimage1'].toString();
                    var comment1 = widget.data['comment1'].toString();
                    var depatureimage = widget.data['depatureimage'].toString();
                    var depaturecomment =
                        widget.data['depaturecomment'].toString();
                    var arrivalimage = widget.data['arrivalimage'].toString();
                    var arrivalcomment =
                        widget.data['arrivalcomment'].toString();
                    var receptionistimage =
                        widget.data['receptionistimage'].toString();
                    var receptionistcomment =
                        widget.data['receptionistcomment'].toString();
                    var pickupType = widget.data['pickuptype'].toString();

                    print(id);

                    print(type);
                    print(bookingdate);
                    print(status);
                    print(widget.data['pickuptype']);

                    widget.data['pickuptype'] == "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxClient(
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
                                CustomDialogBoxClientDropOff(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
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
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      margin: EdgeInsets.only(right: 15),
                      child: Center(
                        child: Text(
                          "View Path",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      )),
                ),

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
                    print("-=--jsondata=-=-=$jsondata");
                    print("-=--=-jsondata=-=${jsondata.length}");
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
                                                            print("in dialog");
                                                            print(
                                                                "widget.data itemdetail ${widget.data['itemdetail'][index].itemImage.length}");
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
                                              left: 5, top: 10),
                                          child: Container(
                                            height: 50,
                                            width: 800,
                                            child: Center(
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

class CustomDialogBoxClient extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status, pickupType;
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
  CustomDialogBoxClient(
    this.id,
    this.type,
    this.bookingdate,
    this.status,
    this.pickupType,
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
  _CustomDialogBoxClient createState() => _CustomDialogBoxClient();
}

class _CustomDialogBoxClient extends State<CustomDialogBoxClient> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<ArrivalChangeStatusData> arrivalchangedata = [];
  Image? image;
  String getImage = '';

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

  get http => null;

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
      request.files.add(http.MultipartFile(
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
            width: w * 0.5,
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
    return Container(
      height: h * 0.9,
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
            // SizedBox(
            //   width: 290,
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
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
                // color: Colors.amber
              ),
              child: (Responsive.isDesktop(context))
                  ? Column(
                      children: [
                        (Responsive.isDesktop(context))
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 40, top: 20),
                                      width: 100,
                                      child: Text(
                                        "Shipped VIA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      width: 150,
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "Status",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(right: 40, top: 20),
                                      child: Text(
                                        "Booking Date",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 10, top: 20),
                                      width: 100,
                                      child: Text(
                                        "shippedvis".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "status".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin:
                                          EdgeInsets.only(right: 10, top: 20),
                                      child: Text(
                                        "bookingdate".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                        (Responsive.isDesktop(context))
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(left: 40, top: 10),
                                      child: Text(
                                        widget.type,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  // SizedBox(
                                  //   width: 110,
                                  // ),
                                  Container(
                                      width: 150,
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        widget.status,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  // SizedBox(
                                  //   width: 70,
                                  // ),
                                  Container(
                                      width: 100,
                                      margin:
                                          EdgeInsets.only(right: 40, top: 10),
                                      child: Text(
                                        widget.bookingdate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                        widget.type,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  // SizedBox(
                                  //   width: 110,
                                  // ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                        widget.status,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  // SizedBox(
                                  //   width: 70,
                                  // ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      margin:
                                          EdgeInsets.only(left: 10, top: 10),
                                      child: Text(
                                        widget.bookingdate,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              )
                      ],
                    )
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      Column(
                        children: [
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 40, top: 20),
                                        width: 100,
                                        child: Text(
                                          "Shipped VIA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 20),
                                        child: Text(
                                          "Booking Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 20),
                                        width: 100,
                                        child: Text(
                                          "shippedvis".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "status".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(right: 10, top: 20),
                                        child: Text(
                                          "bookingdate".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 40, top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
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
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
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
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                        ],
                      ),
                    ])),
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
                                    margin: EdgeInsets.only(left: 20),
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
                            widget.status == "Confirmed" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "accepted"
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent"
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup"
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
                                      _displayShowImageCommentDialog1(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
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
                            widget.status == "Confirmed" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "accepted"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
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
                              child: Divider(
                            color: Color(0xff4CAF50),
                            height: 36,
                          )),
                        ),
                        Column(
                          children: [
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse"
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
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
                              child: Divider(
                            color: Color(0xff4CAF50),
                            height: 36,
                          )),
                        ),
                        Column(
                          children: [
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status == "Delivered to Receptionist"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
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
                      height: h * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              widget.status == "Confirmed"
                                  ? Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(left: 20),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      ),
                                      Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "accepted".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ])
                                  : Column(children: [
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
                                            "accepted".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ])
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
                          widget.status == "Confirmed" ||
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
                                        "assigntoagent".tr(),
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
                                        "assigntoagent".tr(),
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ]),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent"
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
                                              "goingtopickup".tr(),
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
                                            "goingtopickup".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ]),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup"
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
                                              "pickupdone".tr(),
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
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "pickupdone".tr(),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "accepted"
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
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
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
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "delivered to Warehouse"
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
                                              "receviedproceedforshipment".tr(),
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

                                            _displayShowImageCommentDialog3(
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
                                              "receviedproceedforshipment".tr(),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
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
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered to Receptionist",
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
                                              "Delivered to Receptionist",
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
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
                    )),
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
                        "Delivered to Departure Warehouse",
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
        ],
      ),
    );
  }
}

class CustomDialogBoxClientDropOff extends StatefulWidget {
  var id;

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
  CustomDialogBoxClientDropOff(
    this.id,
    this.type,
    this.bookingdate,
    this.status,
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
  _CustomDialogBoxClientDropOff createState() =>
      _CustomDialogBoxClientDropOff();
}

class _CustomDialogBoxClientDropOff
    extends State<CustomDialogBoxClientDropOff> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<ArrivalChangeStatusData> arrivalchangedata = [];
  Image? image;
  String getImage = '';

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
            width: w * 0.5,
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
    return Container(
      height: h * 0.9,
      width: (Responsive.isDesktop(context)) ? w * 0.7 : w * 0.9,
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
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
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
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      Column(
                        children: [
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 40, top: 20),
                                        width: 100,
                                        child: Text(
                                          "Shipped VIA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 20),
                                        child: Text(
                                          "Booking Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 20),
                                        width: 100,
                                        child: Text(
                                          "shippedvis".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "status".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(right: 10, top: 20),
                                        child: Text(
                                          "bookingdate".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 40, top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
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
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
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
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                        ],
                      ),
                    ])),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15),
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
                                    margin: EdgeInsets.only(left: 20),
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
                            // Container(
                            //     margin: EdgeInsets.only(left: 10),
                            //     child: Text(
                            //       "Order Recieved",
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     )),
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "accepted"
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
                            // Container(
                            //     // margin: EdgeInsets.only(right: 30),
                            //     child: Text(
                            //   "Delivered to warehouse",
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // )),
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
                                    widget.status == "Confirmed" ||
                                    // widget.status == "assigned to agent" ||
                                    // widget.status == "going to pickup" ||
                                    // widget.status == "pickup done" ||
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
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog3(context);
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
                            // Container(
                            //     margin: EdgeInsets.only(right: 10),
                            //     child: Text(
                            //       "Close",
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //
                            //   )),
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status == "Delivered to Receptionist"
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
                      height: h * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              widget.status == "Confirmed"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(left: 20),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "accepted".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
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
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "accepted".tr(),
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
                                      widget.status == "Confirmed" ||
                                      widget.status == "accepted"
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
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                                      widget.status == "accepted" ||
                                      widget.status == "Confirmed" ||
                                      // widget.status == "assigned to agent" ||
                                      // widget.status == "going to pickup" ||
                                      // widget.status == "pickup done" ||
                                      widget.status == "delivered to Warehouse"
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
                                              "receviedproceedforshipment".tr(),
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
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "receviedproceedforshipment".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                              // Container(
                              //     margin: EdgeInsets.only(right: 10),
                              //     child: Text(
                              //       "Close",
                              //       style: TextStyle(fontWeight: FontWeight.bold),
                              //
                              //   )),
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
                                      widget.status == "Confirmed" ||
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
                                              "Delivered to Receptionist",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _displayShowImageCommentDialog4(
                                            context);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Delivered to Receptionist",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
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
                                      widget.status == "Confirmed" ||
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
                      // margin: EdgeInsets.only(right: 30),
                      child: Text(
                        "Delivered to Departure Warehouse",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Recevied & Proceed for Shipment",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Delivered to Receptionist",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
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
        ],
      ),
    );
  }
}

Widget broadCastMessagesList(mSGdata) {
  print("in list mSGdata $mSGdata");
  return Column(
    children: List.generate(mSGdata.length, (index) {
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
                    Container(
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
    }),
  );
}

Widget mobilebroadCastMessagesList(mSGdata) {
  print("in list mSGdata $mSGdata");
  return Column(
    children: List.generate(mSGdata.length, (index) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 1.0,
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 15.0, left: 15.0),
                width: 50.0,
                height: 50.0,
                child: mSGdata![index].shipmentprofile != ""
                    ? Image.network(mSGdata![index].shipmentprofile)
                    : Icon(Icons.person),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 12.0, bottom: 10.0),
                      child: Text(
                        mSGdata![index].scheduleTitle.toString(),
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Text(
                        mSGdata![index].title.toString(),
                        style: TextStyle(
                            fontSize: 10.0,
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
                            height: 50,
                            margin: EdgeInsets.only(right: 10.0),
                            child: SingleChildScrollView(
                              child: Text(
                                mSGdata![index].message.toString(),
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
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
                                  child: Text(
                                    mSGdata![index]
                                        .createdAt!
                                        .substring(11, 19),
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    mSGdata![index].createdAt!.substring(0, 10),
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  )),
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
    }),
  );
}
