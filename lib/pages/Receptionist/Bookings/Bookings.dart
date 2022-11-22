import 'dart:convert';
import 'dart:developer';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';

import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/ArrivalManager/arrivalChangestatusModel.dart';
import 'package:shipment/Model/Receptionist/receptionistBookingModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/pages/Receptionist/Bookings/bookingalertdialog.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page.dart';
import 'package:shipment/pages/Receptionist/Dashborad/receptionistDashboard.dart';
import 'package:shipment/pages/Receptionist/Notification/notification.dart';
import 'package:universal_html/html.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:universal_html/html.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:http/http.dart' as http;

class Bookings extends StatefulWidget {
  const Bookings({Key? key}) : super(key: key);

  @override
  _BookingsState createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  List<ReceptionistBookingData> bookingData = [];
  TabController? tabController;
  bool isProcess = false;

  var exData = [];
  var exMData = [];
  int? count;

  Future getBooking() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getReceptionistBooking();
    if (response.status == true) {
      setState(() {
        bookingData = response.data;
        exData = response.data;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });
    // id =   response.user[universityList.indexOf(name)].id
  }

  List<ReceptionistMArketData> marketPlaceOrder = [];

  getMArketPlaceList() async {
    var response = await Providers().receptionistMarketOrderhistory();

    marketPlaceOrder = response.data;
    exMData = response.data;

    // for (int i = 0; i < marketPlaceOrder.length; i++) {
    //   clientinfo = marketPlaceOrder[i].client;
    // }
    setState(() {});
    print("jkkhkdkdkckdkck$marketPlaceOrder");
  }

  var UserId, userRole;
  var roomId = 0;
  var chatListData = [];
  var shipmentId = 0;
  void getProfileDetails() async {
    print("in getProfileDetails");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userDetails;
    if (prefs.getString('Shipemnt_auth_token') != null) {
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
      // sId = userDetails.data[0].id;

      setState(() {
        UserId = userDetails.data[0].id;
        userRole = userDetails.data[0].roles;
        // shipmentId = userDetails.data[0].shipmentId;
      });

      print("-=-=-UserId $UserId");
      getChatList();
    }
  }

  getChatList() async {
    print("getChatList");
    var data = {
      // "userId": "9",
      // "userToRole": "1c"
      "userId": UserId.toString(),
      "userToRole": userRole.toString()
    };
    var response = await Providers().getChatList(data);
    print("-=-=-=data ${data}");
    if (response.status == true) {
      print("-=-=-=response data ${response.data}");

      // chatListData = response.data;

      // roomId = chatListData[0].roomId;

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
    // TODO: implement initState
    super.initState();
    getBooking();
    getMArketPlaceList();
    getNotificationCount();
    getProfileDetails();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('receptionist_token');
    print("Token $authToken");
    var response =
        await Providers().getClientSubPanelNotificationCount(authToken);

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
  }

  var _lastQuitTime;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (_lastQuitTime == null ||
            DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
          print('Press again Back Button exit');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (!Responsive.isDesktop(context))
                      ? ReceptionistDashboard()
                      : PreReceptionistDashboard()));
          return false;
        } else {
          // SystemNavigator.pop();

          return false;
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: ReceptionSidebar(),
          ),
          body: isProcess == true
              ? Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                  color: Color(0xffE5E5E5),
                  child: SafeArea(
                      right: false,
                      child: ListView(children: [
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
                              // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                                child: Text(
                                  'booking'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
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
                                        controller: tabController,
                                        labelColor: Color(0xff1A494F),
                                        unselectedLabelColor: Colors.grey,
                                        indicatorColor: Color(0xff1A494F),
                                        tabs: <Widget>[
                                          Container(
                                            width: 200,
                                            child: Tab(
                                              child: Text(
                                                "order".tr(),
                                              ),
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
                                  ),
                                ),
                              ),
                              Container(
                                height: h,
                                width: w * 0.80,
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      SingleChildScrollView(
                                        child: bookingData.isEmpty
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  booking(),
                                                  orderTemplate(),
                                                  orderDetails(),
                                                ],
                                              ),
                                      ),
                                      SingleChildScrollView(
                                        child: marketPlaceOrder.isEmpty
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  mbooking(),
                                                  orderMarketTemplate(),
                                                  marketOrderDetails(),
                                                ],
                                              ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        if (!Responsive.isDesktop(context))
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
                                        controller: tabController,
                                        labelColor: Color(0xff1A494F),
                                        unselectedLabelColor: Colors.grey,
                                        indicatorColor: Color(0xff1A494F),
                                        tabs: <Widget>[
                                          Container(
                                            width: 200,
                                            child: Tab(
                                              child: Text(
                                                "order".tr(),
                                              ),
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
                                  ),
                                ),
                              ),
                              Container(
                                height: h,
                                width: w,
                                child: TabBarView(
                                    controller: tabController,
                                    children: [
                                      SingleChildScrollView(
                                        child: bookingData.isEmpty
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        // Image.asset(
                                                        //   'assets/images/applogo.png',
                                                        //   height:
                                                        //       MediaQuery.of(context).size.height * 0.10,
                                                        // ),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  MobileVieworderTemplate(),
                                                ],
                                              ),
                                      ),
                                      SingleChildScrollView(
                                        child: marketPlaceOrder.isEmpty
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  elevation: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(12),
                                                    decoration:
                                                        linearGradientForWhiteCard(),
                                                    child: Column(
                                                      children: [
                                                        // Image.asset(
                                                        //   'assets/images/applogo.png',
                                                        //   height:
                                                        //       MediaQuery.of(context).size.height * 0.10,
                                                        // ),
                                                        SizedBox(height: 15),
                                                        Text(
                                                          'sorryouhavenotanybookingsyet'
                                                              .tr(),
                                                          style:
                                                              headingStyle16MB(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  MobileVieworderTemplate2(),
                                                ],
                                              ),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                      ])),
                )),
    );
  }

  Widget orderMarketTemplate() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        height: h * 0.06,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: w * 0.03,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "orderid".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                // width: MediaQuery.of(context).size.width * (20 / 100),
                width: w * 0.075,
                // margin: EdgeInsets.only(right: 30),
                child: Text(
                  "bookingdate".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.06,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                child: Text(
                  "title".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.05,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "status".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.10,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "changestatus".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,

                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "chat".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget marketOrderDetails() {
    return ListView.builder(
        itemCount: marketPlaceOrder.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (context, index) {
          print("dhhfdghfghdf${marketPlaceOrder[index].status}");
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              // height: (!Responsive.isDesktop(context))
              //     ? MediaQuery.of(context).size.height * (10 / 100)
              //     : MediaQuery.of(context).size.height * (45 / 100),
              height: 80,
              width: MediaQuery.of(context).size.width * (20 / 100),
              // margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w * 0.04,
                      // width: MediaQuery.of(context).size.width * (20 / 100),
                      margin: EdgeInsets.only(left: 35),
                      child: Text(
                        marketPlaceOrder[index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: w * 0.08,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        marketPlaceOrder[index].bookingDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: w * 0.08,
                    // width: MediaQuery.of(context).size.width * (20 / 100),

                    // margin: EdgeInsets.only(left: 20),
                    child:
                        // Row(
                        //   children: [
                        InkWell(
                      onTap: () {},
                      child: Text(
                        marketPlaceOrder[index].title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A494F)),
                      ),
                    ),
                  ),

                  Container(
                      width: w * 0.07,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      child: Center(
                        child: Text(
                          marketPlaceOrder[index].marketStatus.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),

                  GestureDetector(
                    onTap: () {
                      var id = marketPlaceOrder[index].mid.toString();
                      var type = marketPlaceOrder[index].dropoff.toString();
                      var bookingdate =
                          marketPlaceOrder[index].bookingDate.toString();
                      var status = marketPlaceOrder[index].marketStatus;
                      var itemimage =
                          marketPlaceOrder[index].pickupItemimage.toString();
                      var comment =
                          marketPlaceOrder[index].pickupComment.toString();
                      var itemimage1 =
                          marketPlaceOrder[index].pickupItemimage1.toString();
                      var comment1 =
                          marketPlaceOrder[index].pickupComment1.toString();
                      var depatureimage =
                          marketPlaceOrder[index].departureImage.toString();
                      var depaturecomment =
                          marketPlaceOrder[index].departureComment.toString();
                      var arrivalimage =
                          marketPlaceOrder[index].arrivalImage.toString();
                      var arrivalcomment =
                          marketPlaceOrder[index].arrivalComment.toString();
                      var receptionistimage =
                          marketPlaceOrder[index].receptionistImage.toString();
                      var receptionistcomment = marketPlaceOrder[index]
                          .receptionistComment
                          .toString();
                      marketPlaceOrder[index].dropoff == "Pick up"
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxReceptionist(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
                                    bookingData[index]
                                        .pickupReview[0]
                                        .pickupType
                                        .toString(),
                                    tabController!.index.toString(),
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                    depatureimage,
                                    depaturecomment,
                                    arrivalimage,
                                    arrivalcomment,
                                    receptionistimage,
                                    receptionistcomment,
                                  ))
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxDropOff(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
                                    tabController!.index.toString(),
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                    depatureimage,
                                    depaturecomment,
                                    arrivalimage,
                                    arrivalcomment,
                                    receptionistimage,
                                    receptionistcomment,
                                  ));

                      // var pid = marketPlaceOrder[index].pickupagentId;
                      // var bid = marketPlaceOrder[index].id.toString();
                      // var type = 'Pick up';
                      // var bookingdate =
                      //     marketPlaceOrder[index].bookingDate.toString();
                      // var status = marketPlaceOrder[index].status.toString();
                      // print(
                      //     "jshfjhjfhjhfjhfjhjdfhjhdfjhjh${marketPlaceOrder[index].pickupagentId}");

                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) => CustomDialogBox1(
                      //         bid,
                      //         pid,
                      //         type,
                      //         bookingdate,
                      //         status,
                      //         tabController!.index.toString()));
                    },
                    child: Container(
                        width: w * 0.12,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            "updatestatus".tr(),
                            // shipmentOrder![index].status == "pickup done"
                            //     ? "Ready to Dispatch"
                            //     : shipmentOrder![index].status,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "2r"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].arrivalId, "4"));

                      marketPlaceOrder[index].pickupagentId != 0
                          ? usersList.add(ChatUsers(
                              marketPlaceOrder[index].pickupagentId, "5"))
                          : '';
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));

                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].departureId, "3"));

                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].uid, "1c"));

                      print("-=-= $chatListData");

                      int trendIndex = chatListData.indexWhere(
                          (f) => f['name'] == marketPlaceOrder[index].id);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": marketPlaceOrder[index].title.toString(),
                        "firm_name": marketPlaceOrder[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": UserId.toString(),
                        "sid": marketPlaceOrder[index].id.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id":
                            marketPlaceOrder[index].sid.toString(), //other
                      };
                      print("-=-data11=- $data11");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(right: 5, bottom: 2),
                        height: MediaQuery.of(context).size.height * (5 / 100),
                        width: w * 0.13,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        child: Center(
                          child: Text(
                            'chat'.tr(),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget booking() {
    return (Responsive.isDesktop(context))
        ? Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (60 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 40,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
            //   color: Color(0xffFFFFFF),
            // ),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Title",
                            "Type",
                            "Shipment Company",
                            "From",
                            "To",
                            "Status"
                          ]
                        ];
                        for (int i = 0; i < exData.length; i++) {
                          List row = [];
                          row.add(exData[i].id);
                          // row.add(exData[i].bookingDate);
                          row.add(exData[i].title);
                          row.add(exData[i].bookingType);
                          row.add(exData[i].shipmentCompany);
                          row.add(exData[i].from);
                          row.add(exData[i].to);
                          row.add(exData[i].status);
                          rows.add(row);
                        }

                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                        print("csv-=-= $csv");
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height:
                              MediaQuery.of(context).size.height * (5 / 100),
                          // height: 100,
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  "export".tr(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                margin: EdgeInsets.only(
                                  right: 10,
                                ),
                                child: Image.asset(
                                  'assets/images/Calendar.png',
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (60 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 40,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
            //   color: Color(0xffFFFFFF),
            // ),
            child: Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: () {
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Title",
                        "Type",
                        "Shipment Company",
                        "From",
                        "To",
                        "Status"
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      List row = [];
                      row.add(exData[i].id);
                      // row.add(exData[i].bookingDate);
                      row.add(exData[i].title);
                      row.add(exData[i].bookingType);
                      row.add(exData[i].shipmentCompany);
                      row.add(exData[i].from);
                      row.add(exData[i].to);
                      row.add(exData[i].status);
                      rows.add(row);
                    }

                    DateTime now = DateTime.now();
                    DateTime todayDate = DateTime(now.year, now.month, now.day);

                    String fileName = "order_" +
                        getRandomString(5) +
                        "_" +
                        todayDate.toString();

                    String csv = const ListToCsvConverter().convert(rows);
                    print("csv-=-= $csv");
                    var dataUrl = AnchorElement(
                        href: "data:text/plain;charset=utf-8,$csv")
                      ..setAttribute("download", fileName + ".csv")
                      ..click();
                  },
                  child: Container(
                      //  margin: EdgeInsets.only(right: 10),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      // height: 100,
                      width: MediaQuery.of(context).size.width * (35 / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 10,
                            ),
                            child: Text(
                              "export".tr(),
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Container(
                            height: 25,
                            width: 25,
                            margin: EdgeInsets.only(
                              right: 10,
                            ),
                            child: Image.asset(
                              'assets/images/Calendar.png',
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          );
  }

  Widget mbooking() {
    return (Responsive.isDesktop(context))
        ? Container(
            height: 40,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    //   child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text("All Orders",
                    //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("export");
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "Title",
                            "status",
                          ]
                        ];
                        for (int i = 0; i < exMData.length; i++) {
                          List row = [];
                          row.add(exMData[i].id);

                          row.add(exMData[i].bookingDate);
                          row.add(exMData[i].title);

                          row.add(exMData[i].status);

                          rows.add(row);
                        }

                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                        var dataUrl = AnchorElement(
                            href: "data:text/plain;charset=utf-8,$csv")
                          ..setAttribute("download", fileName + ".csv")
                          ..click();
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          height:
                              MediaQuery.of(context).size.height * (5 / 100),
                          // height: 100,
                          width: MediaQuery.of(context).size.width * (10 / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  "export".tr(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // _selectDate(context);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  margin: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: Image.asset(
                                    'assets/images/Calendar.png',
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                    //   child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text("All Orders",
                    //           style: TextStyle(fontSize: 14, color: Colors.grey))),
                    // ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("export");
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "Title",
                            "status",
                          ]
                        ];
                        for (int i = 0; i < exMData.length; i++) {
                          List row = [];
                          row.add(exMData[i].id);

                          row.add(exMData[i].bookingDate);
                          row.add(exMData[i].title);

                          row.add(exMData[i].status);

                          rows.add(row);
                        }

                        DateTime now = DateTime.now();
                        DateTime todayDate =
                            DateTime(now.year, now.month, now.day);

                        String fileName = "order_" +
                            getRandomString(5) +
                            "_" +
                            todayDate.toString();

                        String csv = const ListToCsvConverter().convert(rows);
                      },
                      child: Container(
                          height:
                              MediaQuery.of(context).size.height * (5 / 100),
                          // height: 100,
                          width: MediaQuery.of(context).size.width * (35 / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffFFFFFF),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 10,
                                ),
                                child: Text(
                                  "export".tr(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // _selectDate(context);
                                },
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  margin: EdgeInsets.only(
                                    right: 10,
                                  ),
                                  child: Image.asset(
                                    'assets/images/Calendar.png',
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              ],
            ));
  }

  Widget orderTemplate() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * (76 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
        // color: Colors.red
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 30),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "scheduletitle".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: ListView.builder(
          itemCount: bookingData.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: 144,
              width: MediaQuery.of(context).size.width * (75 / 100),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(left: 30),
                        child: Text(
                          bookingData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),

                        // margin: EdgeInsets.only(left: 20),
                        child: Text(
                          (DateFormat('yyy-MM-dd').format(DateTime.parse(
                              bookingData[index].bookingDate.toString()))),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        )),

                    Container(
                      width: MediaQuery.of(context).size.width * (20 / 100),
                      child: InkWell(
                        onTap: () {
                          log(bookingData[index].shipmentCompany);
                          log(bookingData[index].id.toString());
                          log(bookingData[index].to.toString());
                          log(bookingData[index].from.toString());

                          log(bookingData[index].bookingType);

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
                                        dialogid: bookingData[index].id,
                                        dailogbookingtype:
                                            bookingData[index].bookingType,
                                        dailogfrom: bookingData[index].from,
                                        dialogto: bookingData[index].to,
                                        dailogshipmentCompany:
                                            bookingData[index].shipmentCompany),
                                  ),
                                );
                              });
                        },
                        child: Text(
                          bookingData[index].title.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xff1A494F)),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(">>>>>>>>" +
                                    bookingData[index].item.length.toString());
                                //return;
                                var data1 = {
                                  "id": bookingData[index].id,
                                  for (int i = 0;
                                      i < bookingData[index].item.length;
                                      i++)
                                    'itemimage1':
                                        bookingData[index].item[i].itemImage,
                                  for (int i = 0;
                                      i < bookingData[index].item.length;
                                      i++)
                                    'itemdetail': bookingData[index].item,

                                  'transactionid': bookingData[index]
                                      .transactionId
                                      .toString(),
                                  'totalamount':
                                      bookingData[index].totalAmount.toString(),
                                  'pickuptype': bookingData[index]
                                      .pickupReview[0]
                                      .pickupType
                                      .toString(),
                                  'pickuplocation': bookingData[index]
                                      .pickupReview[0]
                                      .pickupLocation
                                      .toString(),
                                  'pickupdate': bookingData[index]
                                      .pickupReview[0]
                                      .pickupDate
                                      .toString(),
                                  'pickuptime': bookingData[index]
                                      .pickupReview[0]
                                      .pickupTime
                                      .toString(),
                                  'pickupdistance': bookingData[index]
                                      .pickupReview[0]
                                      .pickupDistance
                                      .toString(),
                                  'pickupestimate': bookingData[index]
                                      .pickupReview[0]
                                      .pickupEstimate
                                      .toString(),
                                  'name': bookingData[index]
                                      .arrival[0]
                                      .name
                                      .toString(),
                                  'lname': bookingData[index]
                                      .arrival[0]
                                      .lname
                                      .toString(),
                                  'email': bookingData[index]
                                      .arrival[0]
                                      .email
                                      .toString(),
                                  'Id': bookingData[index]
                                      .arrival[0]
                                      .id
                                      .toString(),
                                  'profileimage': bookingData[index]
                                      .arrival[0]
                                      .profileimage
                                      .toString(),
                                  'phone': bookingData[index]
                                      .arrival[0]
                                      .phone
                                      .toString(),
                                  'address': bookingData[index]
                                      .arrival[0]
                                      .address
                                      .toString(),
                                  'country': bookingData[index]
                                      .arrival[0]
                                      .country
                                      .toString(),
                                  'status': bookingData[index]
                                      .arrival[0]
                                      .status
                                      .toString(),
                                  'company': bookingData[index]
                                      .arrival[0]
                                      .companyname
                                      .toString(),
                                  // 'id': arrd[index].id.toString(),
                                  'title': bookingData[index].title.toString(),
                                  'bookingdate':
                                      bookingData[index].bookingDate.toString(),
                                  'arrivaldate':
                                      bookingData[index].arrivalDate.toString(),
                                  'type':
                                      bookingData[index].bookingType.toString(),
                                  'shipcmpany': bookingData[index]
                                      .shipmentCompany
                                      .toString(),
                                  'schedule_id':
                                      bookingData[index].scheduleId.toString()
                                };
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ReceptionistDetail(data1
                                                //  Id: id.toString(),
                                                )));
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  height: MediaQuery.of(context).size.height *
                                      (4.59 / 100),
                                  width: w * 0.13,
                                  decoration: const BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      "viewdetails".tr(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            bookingData[index].status == "Cancelled"
                                ? Container(
                                    margin:
                                        EdgeInsets.only(right: 5, bottom: 2),
                                    height: MediaQuery.of(context).size.height *
                                        (4.59 / 100),
                                    width: w * 0.13,
                                    decoration: const BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    // width:
                                    child: Center(
                                      child: Text(
                                        bookingData[index].status,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ))
                                : InkWell(
                                    onTap: () {
                                      var id = bookingData[index].id.toString();
                                      var type = bookingData[index]
                                          .bookingType
                                          .toString();
                                      var bookingdate = bookingData[index]
                                          .bookingDate
                                          .toString();
                                      var status = bookingData[index].status;
                                      var itemimage = bookingData[index]
                                          .pickupItemimage
                                          .toString();
                                      var comment = bookingData[index]
                                          .pickupComment
                                          .toString();
                                      var itemimage1 = bookingData[index]
                                          .pickupItemimage1
                                          .toString();
                                      var comment1 = bookingData[index]
                                          .pickupComment1
                                          .toString();
                                      var depatureimage = bookingData[index]
                                          .departureImage
                                          .toString();
                                      var depaturecomment = bookingData[index]
                                          .departureComment
                                          .toString();
                                      var arrivalimage = bookingData[index]
                                          .arrivalImage
                                          .toString();
                                      var arrivalcomment = bookingData[index]
                                          .arrivalComment
                                          .toString();
                                      var receptionistimage = bookingData[index]
                                          .receptionistImage
                                          .toString();
                                      var receptionistcomment =
                                          bookingData[index]
                                              .receptionistComment
                                              .toString();
                                      var schedulStatus =
                                          bookingData[index].status.toString();
                                      bookingData[index]
                                                  .pickupReview[0]
                                                  .pickupType ==
                                              "Pick up"
                                          ? showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  CustomDialogBoxReceptionist(
                                                      id,
                                                      type,
                                                      bookingdate,
                                                      status,
                                                      bookingData[index]
                                                          .pickupReview[0]
                                                          .pickupType
                                                          .toString(),
                                                      '',
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
                                                  CustomDialogBoxDropOff(
                                                      id,
                                                      type,
                                                      bookingdate,
                                                      status,
                                                      '',
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
                                            right: 5, bottom: 2),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (4.59 / 100),
                                        width: w * 0.13,
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        // width:
                                        child: Center(
                                          child: Text(
                                            bookingData[index].status,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                            const SizedBox(
                              height: 7,
                            ),
                            bookingData[index].status == "Cancelled"
                                ? Container(
                                    margin:
                                        EdgeInsets.only(right: 5, bottom: 2),
                                    height: MediaQuery.of(context).size.height *
                                        (4.59 / 100),
                                    width: w * 0.13,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    // width:
                                    child: Center(
                                      child: Text(
                                        'chat'.tr(),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ))
                                : InkWell(
                                    onTap: () {
                                      var data11;
                                      List<ChatUsers> usersList = [];
                                      usersList.add(ChatUsers(UserId, "2r"));
                                      usersList.add(ChatUsers(
                                          bookingData[index].arrival[0].id,
                                          "4"));
                                      usersList.add(ChatUsers(
                                          bookingData[index].departure[0].id,
                                          "3"));

                                      usersList.add(ChatUsers(
                                          bookingData[index].uid, "1c"));
                                      bookingData[index].pickupagentId != null
                                          ? usersList.add(ChatUsers(
                                              bookingData[index].pickupagentId,
                                              "5"))
                                          : '';
                                      usersList.add(ChatUsers(
                                          bookingData[index]
                                              .arrival[0]
                                              .shipmentId,
                                          "1"));

                                      print("-=-= $chatListData");

                                      int trendIndex = chatListData.indexWhere(
                                          (f) =>
                                              f['name'] ==
                                              bookingData[index].id);
                                      print("-=-=-trendIndex $trendIndex");
                                      if (trendIndex != -1) {
                                        roomId = chatListData[trendIndex]['id'];
                                        print("-=-=- $usersList");
                                        print(
                                            "-=-roomId=- ${chatListData[trendIndex]['id']}");
                                      }

                                      data11 = {
                                        "group_name":
                                            bookingData[index].title.toString(),
                                        "firm_name":
                                            bookingData[index].title.toString(),
                                        "chat_type": "group",
                                        "room_id": roomId,
                                        "userList": jsonEncode(usersList),
                                        "user_id": UserId.toString(),
                                        "sid": bookingData[index].id.toString(),
                                        'sender_type': userRole.toString(),
                                        'receiver_type': '1c', //shipment
                                        "sender_id": UserId.toString(), //me
                                        "receiver_id": bookingData[index]
                                            .arrival[0]
                                            .id, //other
                                      };
                                      print("-=-data11=- $data11");
                                      //return;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ChatViewScreen(data11),
                                          ));
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            right: 5, bottom: 2),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                (4.59 / 100),
                                        width: w * 0.13,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        // width:
                                        child: Center(
                                          child: Text(
                                            'chat'.tr(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                          ],
                        ),
                      ),
                    )
                  ]),
            );
          }),
    );
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: bookingData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * (35 / 100),
            width: w,
            margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "orderid".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "bookingdate".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          bookingData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            (DateFormat('yyy-MM-dd').format(DateTime.parse(
                                bookingData[index].bookingDate.toString()))),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "scheduletitle".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    InkWell(
                      onTap: () {
                        log(bookingData[index].shipmentCompany);
                        log(bookingData[index].id.toString());
                        log(bookingData[index].to.toString());
                        log(bookingData[index].from.toString());

                        log(bookingData[index].bookingType);

                        showDialog(
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: ContainerListDialog(
                                      dialogid: bookingData[index].id,
                                      dailogbookingtype:
                                          bookingData[index].bookingType,
                                      dailogfrom: bookingData[index].from,
                                      dialogto: bookingData[index].to,
                                      dailogshipmentCompany:
                                          bookingData[index].shipmentCompany),
                                ),
                              );
                            });
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            bookingData[index].title.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    print(
                        ">>>>>>>>" + bookingData[index].item.length.toString());
                    //return;
                    var data1 = {
                      "id": bookingData[index].id,
                      for (int i = 0; i < bookingData[index].item.length; i++)
                        'itemimage1': bookingData[index].item[i].itemImage,
                      for (int i = 0; i < bookingData[index].item.length; i++)
                        'itemdetail': bookingData[index].item,

                      'transactionid':
                          bookingData[index].transactionId.toString(),
                      'totalamount': bookingData[index].totalAmount.toString(),
                      'pickuptype': bookingData[index]
                          .pickupReview[0]
                          .pickupType
                          .toString(),
                      'pickuplocation': bookingData[index]
                          .pickupReview[0]
                          .pickupLocation
                          .toString(),
                      'pickupdate': bookingData[index]
                          .pickupReview[0]
                          .pickupDate
                          .toString(),
                      'pickuptime': bookingData[index]
                          .pickupReview[0]
                          .pickupTime
                          .toString(),
                      'pickupdistance': bookingData[index]
                          .pickupReview[0]
                          .pickupDistance
                          .toString(),
                      'pickupestimate': bookingData[index]
                          .pickupReview[0]
                          .pickupEstimate
                          .toString(),
                      'name': bookingData[index].arrival[0].name.toString(),
                      'lname': bookingData[index].arrival[0].lname.toString(),
                      'email': bookingData[index].arrival[0].email.toString(),
                      'Id': bookingData[index].arrival[0].id.toString(),
                      'profileimage':
                          bookingData[index].arrival[0].profileimage.toString(),
                      'phone': bookingData[index].arrival[0].phone.toString(),
                      'address':
                          bookingData[index].arrival[0].address.toString(),
                      'country':
                          bookingData[index].arrival[0].country.toString(),
                      'status': bookingData[index].arrival[0].status.toString(),
                      'company':
                          bookingData[index].arrival[0].companyname.toString(),
                      // 'id': arrd[index].id.toString(),
                      'title': bookingData[index].title.toString(),
                      'bookingdate': bookingData[index].bookingDate.toString(),
                      'arrivaldate': bookingData[index].arrivalDate.toString(),
                      'type': bookingData[index].bookingType.toString(),
                      'shipcmpany':
                          bookingData[index].shipmentCompany.toString(),
                      'schedule_id': bookingData[index].scheduleId.toString()
                    };
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceptionistDetail(data1
                                //  Id: id.toString(),
                                )));
                  },
                  child: Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      height: MediaQuery.of(context).size.height * (4.59 / 100),
                      width: w,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Text(
                          "viewdetails".tr(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 7,
                ),
                bookingData[index].status == "Cancelled"
                    ? Container(
                        margin: EdgeInsets.only(right: 10, bottom: 2, left: 10),
                        height:
                            MediaQuery.of(context).size.height * (4.59 / 100),
                        width: w,
                        decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        child: Center(
                          child: Text(
                            bookingData[index].status,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                          ),
                        ))
                    : InkWell(
                        onTap: () {
                          var id = bookingData[index].id.toString();
                          var type = bookingData[index].bookingType.toString();
                          var bookingdate =
                              bookingData[index].bookingDate.toString();
                          var status = bookingData[index].status;
                          var itemimage =
                              bookingData[index].pickupItemimage.toString();
                          var comment =
                              bookingData[index].pickupComment.toString();
                          var itemimage1 =
                              bookingData[index].pickupItemimage1.toString();
                          var comment1 =
                              bookingData[index].pickupComment1.toString();
                          var depatureimage =
                              bookingData[index].departureImage.toString();
                          var depaturecomment =
                              bookingData[index].departureComment.toString();
                          var arrivalimage =
                              bookingData[index].arrivalImage.toString();
                          var arrivalcomment =
                              bookingData[index].arrivalComment.toString();
                          var receptionistimage =
                              bookingData[index].receptionistImage.toString();
                          var receptionistcomment =
                              bookingData[index].receptionistComment.toString();
                          var schedulStatus =
                              bookingData[index].status.toString();
                          bookingData[index].pickupReview[0].pickupType ==
                                  "Pick up"
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialogBoxReceptionist(
                                          id,
                                          type,
                                          bookingdate,
                                          status,
                                          bookingData[index]
                                              .pickupReview[0]
                                              .pickupType
                                              .toString(),
                                          '',
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
                                      CustomDialogBoxDropOff(
                                          id,
                                          type,
                                          bookingdate,
                                          status,
                                          '',
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
                                EdgeInsets.only(right: 10, bottom: 2, left: 10),
                            height: MediaQuery.of(context).size.height *
                                (4.59 / 100),
                            width: w,
                            decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // width:
                            child: Center(
                              child: Text(
                                bookingData[index].status,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )),
                      ),
                const SizedBox(
                  height: 7,
                ),
                bookingData[index].status == "Cancelled"
                    ? Container(
                        margin: EdgeInsets.only(right: 10, bottom: 2, left: 10),
                        height:
                            MediaQuery.of(context).size.height * (4.59 / 100),
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        child: Center(
                          child: Text(
                            'chat'.tr(),
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ))
                    : InkWell(
                        onTap: () {
                          var data11;
                          List<ChatUsers> usersList = [];
                          usersList.add(ChatUsers(UserId, "2r"));
                          usersList.add(
                              ChatUsers(bookingData[index].arrival[0].id, "4"));
                          usersList.add(ChatUsers(
                              bookingData[index].departure[0].id, "3"));

                          usersList
                              .add(ChatUsers(bookingData[index].uid, "1c"));
                          bookingData[index].pickupagentId != null
                              ? usersList.add(ChatUsers(
                                  bookingData[index].pickupagentId, "5"))
                              : '';
                          usersList.add(ChatUsers(
                              bookingData[index].arrival[0].shipmentId, "1"));

                          print("-=-= $chatListData");

                          int trendIndex = chatListData.indexWhere(
                              (f) => f['name'] == bookingData[index].id);
                          print("-=-=-trendIndex $trendIndex");
                          if (trendIndex != -1) {
                            roomId = chatListData[trendIndex]['id'];
                            print("-=-=- $usersList");
                            print(
                                "-=-roomId=- ${chatListData[trendIndex]['id']}");
                          }

                          data11 = {
                            "group_name": bookingData[index].title.toString(),
                            "firm_name": bookingData[index].title.toString(),
                            "chat_type": "group",
                            "room_id": roomId,
                            "userList": jsonEncode(usersList),
                            "user_id": UserId.toString(),
                            "sid": bookingData[index].id.toString(),
                            'sender_type': userRole.toString(),
                            'receiver_type': '1c', //shipment
                            "sender_id": UserId.toString(), //me
                            "receiver_id":
                                bookingData[index].arrival[0].id, //other
                          };
                          print("-=-data11=- $data11");
                          //return;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatViewScreen(data11),
                              ));
                        },
                        child: Container(
                            margin:
                                EdgeInsets.only(right: 10, bottom: 2, left: 10),
                            height: MediaQuery.of(context).size.height *
                                (4.59 / 100),
                            width: w,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            // width:
                            child: Center(
                              child: Text(
                                'chat'.tr(),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            )),
                      ),
              ],
            ),
          );
        });
  }

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        itemCount: marketPlaceOrder.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
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
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "orderid".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
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
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          marketPlaceOrder[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          marketPlaceOrder[index].marketStatus.toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "bookingdate".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("title".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          marketPlaceOrder[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(marketPlaceOrder[index].title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    var id = marketPlaceOrder[index].mid.toString();
                    var type = marketPlaceOrder[index].dropoff.toString();
                    var bookingdate =
                        marketPlaceOrder[index].bookingDate.toString();
                    var status = marketPlaceOrder[index].marketStatus;
                    var itemimage =
                        marketPlaceOrder[index].pickupItemimage.toString();
                    var comment =
                        marketPlaceOrder[index].pickupComment.toString();
                    var itemimage1 =
                        marketPlaceOrder[index].pickupItemimage1.toString();
                    var comment1 =
                        marketPlaceOrder[index].pickupComment1.toString();
                    var depatureimage =
                        marketPlaceOrder[index].departureImage.toString();
                    var depaturecomment =
                        marketPlaceOrder[index].departureComment.toString();
                    var arrivalimage =
                        marketPlaceOrder[index].arrivalImage.toString();
                    var arrivalcomment =
                        marketPlaceOrder[index].arrivalComment.toString();
                    var receptionistimage =
                        marketPlaceOrder[index].receptionistImage.toString();
                    var receptionistcomment =
                        marketPlaceOrder[index].receptionistComment.toString();
                    marketPlaceOrder[index].dropoff == "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxReceptionist(
                                  id,
                                  type,
                                  bookingdate,
                                  status,
                                  bookingData[index]
                                      .pickupReview[0]
                                      .pickupType
                                      .toString(),
                                  tabController!.index.toString(),
                                  itemimage,
                                  comment,
                                  itemimage1,
                                  comment1,
                                  depatureimage,
                                  depaturecomment,
                                  arrivalimage,
                                  arrivalcomment,
                                  receptionistimage,
                                  receptionistcomment,
                                ))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxDropOff(
                                  id,
                                  type,
                                  bookingdate,
                                  status,
                                  tabController!.index.toString(),
                                  itemimage,
                                  comment,
                                  itemimage1,
                                  comment1,
                                  depatureimage,
                                  depaturecomment,
                                  arrivalimage,
                                  arrivalcomment,
                                  receptionistimage,
                                  receptionistcomment,
                                ));
                  },
                  child: Container(
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      //     MediaQuery.of(context).size.width * (12 / 100),
                      height: 40,
                      margin: EdgeInsets.only(
                          right: 10, left: 10, bottom: 10, top: 10),
                      child: Center(
                        child: Text(
                          "updatestatus".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      )),
                ),
                InkWell(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(UserId, "2r"));
                    usersList
                        .add(ChatUsers(marketPlaceOrder[index].arrivalId, "4"));

                    marketPlaceOrder[index].pickupagentId != 0
                        ? usersList.add(ChatUsers(
                            marketPlaceOrder[index].pickupagentId, "5"))
                        : '';
                    usersList.add(ChatUsers(marketPlaceOrder[index].sid, "1"));

                    usersList.add(
                        ChatUsers(marketPlaceOrder[index].departureId, "3"));

                    usersList.add(ChatUsers(marketPlaceOrder[index].uid, "1c"));

                    print("-=-= $chatListData");

                    int trendIndex = chatListData.indexWhere(
                        (f) => f['name'] == marketPlaceOrder[index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": marketPlaceOrder[index].title.toString(),
                      "firm_name": marketPlaceOrder[index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": marketPlaceOrder[index].id.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id":
                          marketPlaceOrder[index].sid.toString(), //other
                    };
                    print("-=-data11=- $data11");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10, bottom: 2),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      child: Center(
                        child: Text(
                          'chat'.tr(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget ContainerListDialog(
      {String? dailogbookingtype,
      int? dialogid,
      String? dailogfrom,
      String? dialogto,
      String? dailogshipmentCompany}) {
    print("object $dailogbookingtype");
    return Container(
      height: h * 0.45,
      width: w * 0.40,
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text(
                    "bookingid".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    dialogid.toString(),
                    style: headingStyle16MB(),
                  ),
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
                  child: Text(
                    "companyname".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    dailogshipmentCompany.toString(),
                    style: headingStyle16MB(),
                  ),
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
                  child: Text(
                    // bookingtype.toString(),
                    "bookingtype".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.15,
                  child: Text(
                    // viewbooking![index].bookingType,
                    dailogbookingtype.toString(),
                    style: headingStyle16MB(),
                  ),
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
                  child: Text(
                    "from".tr(),
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(dailogfrom.toString(), style: headingStyle16MB()),
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
                  child: Text("to".tr(), style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(dialogto.toString(), style: headingStyle16MB()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//======dialog
// class CustomDialogBoxReceptionist extends StatefulWidget {
//   var id;

//   var type;
//   var bookingdate;
//   var status, pickupType;
//   CustomDialogBoxReceptionist(
//       this.id, this.type, this.bookingdate, this.status, this.pickupType);
//   @override
//   _CustomDialogBoxReceptionist createState() => _CustomDialogBoxReceptionist();
// }

// class _CustomDialogBoxReceptionist extends State<CustomDialogBoxReceptionist> {
//   // List image = [];
//   PlatformFile? objFile = null;
//   var name, profileImage;
//   var buttonstatus = "Assign to Agent";
//   var onTap = 0;
//   List<ArrivalChangeStatusData> arrivalchangedata = [];
//   Image? image;
//   String getImage = '';

//   String imagepath = '';
//   var updatedNumber,
//       updatedProfile,
//       updatedName,
//       updatedLastName,
//       updatedEmail,
//       updatedPhone,
//       updatedCountry,
//       updatedAddress,
//       updatedAboutMe,
//       updatedLName,
//       updateLanguauge;
//   var amount;
//   var email, mobileNumber, languages, country, lname, username, aboutMe;

//   void chooseFileUsingFilePicker(BuildContext context) async {
//     //-----pick file by file picker,

//     var result = await FilePicker.platform.pickFiles(
//         withReadStream:
//             true, // this will return PlatformFile object with read stream
//         type: FileType.custom,
//         allowedExtensions: ['jpg', 'jpeg', 'png']);
//     if (result != null) {
//       // setState(() async {
//       objFile = result.files.single;
//       print("objFILE  $objFile");

//       final request = http.MultipartRequest(
//         "POST",
//         Uri.parse("http://44.194.48.17/api/imageUrl"),
//       );
//       //-----add other fields if needed
//       // request.fields["id"] = "abc";

//       //-----add selected file with request
//       request.files.add(new http.MultipartFile(
//           "file", objFile!.readStream!, objFile!.size,
//           filename: objFile!.name));

//       //-------Send request
//       var resp = await request.send();
//       print("resp  >>>>>>>>>>>>>>..$resp");

//       //------Read response
//       var result2 = await resp.stream.bytesToString();

//       getImage = result2;
//       var temp3 = ImageModel.fromJson(json.decode(result2));
//       print("--=---=-= $result2");
//       // temp2!.add(temp3);
//       print("object  ${json.encode(temp3)}");
//       setState(() {
//         imagepath = temp3.data[0].image;
//         buttonstatus = "Update Status";
//         onTap = 1;
//         // updateProfileApi();
//       });
//       print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");
//       // itemList[index].imageList!.add(result2.toString());

//       //-------Your response
//       // print(result2);
//       // });
//     }
//   }

//   void _openCamera(context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => AlertDialog(
//               content: SingleChildScrollView(
//                 child: ListBody(
//                   children: <Widget>[
//                     Container(child: image != null ? image : null),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                         chooseFileUsingFilePicker(context);
//                         setState(() {});
//                       },
//                       child: Center(
//                         child: Row(
//                           // ignore: prefer_const_literals_to_create_immutables
//                           children: <Widget>[
//                             Icon(Icons.camera),
//                             SizedBox(width: 40),
//                             Text('Take a picture'),
//                             SizedBox(width: 50),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//   }

//   doChangeStatus() async {
//     var depatureData = {
//       "booking_id": widget.id.toString(),
//       "booking_status": "received by receptionist",
//     };

//     print(depatureData);
//     //return;

//     var response = await Providers().changeReceptionistStatus(depatureData);
//     if (response.status == true) {
//       setState(() {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => profileConfirm(),
//             ));
//       });
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // updateProfileApi();
//     // getProfile();
//     print(widget.id);
//     print(widget.type);
//     print(widget.bookingdate);
//     print(widget.status);
//     print(widget.id);
//     print(imagepath.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: contentBox(context),
//     );
//   }

//   contentBox(context) {
//     return Container(
//       height: 900,
//       width: 900,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(5.0),
//         color: Color(0xffFFFFFF),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 "Order tracking" + "  " + widget.id,
//                 style: TextStyle(
//                   decoration: TextDecoration.none,
//                   fontSize: 20,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: 100,
//             margin: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10.0),
//               color: Color(0xffE5E5E5),
//               // color: Colors.amber
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         margin: EdgeInsets.only(left: 40, top: 20),
//                         width: 100,
//                         child: Text(
//                           "Shipped VIA",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     Container(
//                         width: 150,
//                         margin: EdgeInsets.only(top: 20),
//                         child: Text(
//                           "Status",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     Container(
//                         width: 100,
//                         margin: EdgeInsets.only(right: 40, top: 20),
//                         child: Text(
//                           "Booking Date",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                   ],
//                 ),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         width: 100,
//                         margin: EdgeInsets.only(left: 40, top: 10),
//                         child: Text(
//                           widget.type,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     // SizedBox(
//                     //   width: 110,
//                     // ),
//                     Container(
//                         width: 150,
//                         margin: EdgeInsets.only(top: 10),
//                         child: Text(
//                           widget.status,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                     // SizedBox(
//                     //   width: 70,
//                     // ),
//                     Container(
//                         width: 100,
//                         margin: EdgeInsets.only(right: 40, top: 10),
//                         child: Text(
//                           widget.bookingdate,
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       height: 50,
//                       width: 50,
//                       margin: EdgeInsets.only(left: 20),
//                       child: Image.asset('assets/images/Group 740.png',
//                           fit: BoxFit.fill),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                       // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                       child: Divider(
//                     color: Color(0xff4CAF50),
//                     height: 36,
//                   )),
//                 ),
//                 Column(
//                   children: [
//                     widget.status == "Accepted" || widget.status == "Confirmed"
//                         ? Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/defaulticon.png',
//                                 fit: BoxFit.fill),
//                           )
//                         : Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/Group 742.png',
//                                 fit: BoxFit.fill),
//                           )
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                       // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                       child: Divider(
//                     color: Color(0xff4CAF50),
//                     height: 36,
//                   )),
//                 ),
//                 widget.pickupType == "Pick up"
//                     ? Column(
//                         children: [
//                           widget.status == "Accepted" ||
//                                   widget.status == "Confirmed" ||
//                                   widget.status == "assigned to agent" ||
//                                   widget.status == "going to pickup" ||
//                                   widget.status == "pickup done" ||
//                                   widget.status == "pickup item received" ||
//                                   widget.status == "delivered to Warehouse"
//                               ? Container(
//                                   height: 50,
//                                   width: 50,
//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/defaulticon.png',
//                                       fit: BoxFit.fill),
//                                 )
//                               : Container(
//                                   height: 50,
//                                   width: 50,
//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/Group 742.png',
//                                       fit: BoxFit.fill),
//                                 ),
//                         ],
//                       )
//                     : SizedBox(),
//                 widget.pickupType == "Pick up"
//                     ? Expanded(
//                         child: Container(
//                             // margin: EdgeInsets.only(right: 10),
//                             // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                             child: Divider(
//                           color: Color(0xff4CAF50),
//                           height: 36,
//                         )),
//                       )
//                     : SizedBox(),
//                 widget.pickupType == "Pick up"
//                     ? Column(
//                         children: [
//                           widget.status == "Accepted" ||
//                                   widget.status == "Confirmed" ||
//                                   widget.status == "assigned to agent" ||
//                                   widget.status == "going to pickup" ||
//                                   widget.status == "pickup done" ||
//                                   widget.status == "delivered to Warehouse" ||
//                                   widget.status == "pickup item received"
//                               ? Container(
//                                   height: 50,
//                                   width: 50,

//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/defaulticon.png',
//                                       fit: BoxFit.fill),
//                                 )
//                               : Container(
//                                   height: 50,
//                                   width: 50,
//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/Group 742.png',
//                                       fit: BoxFit.fill),
//                                 ),
//                         ],
//                       )
//                     : SizedBox(),
//                 widget.pickupType == "Pick up"
//                     ? Expanded(
//                         child: Container(
//                             // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                             child: Divider(
//                           color: Color(0xff4CAF50),
//                           height: 36,
//                         )),
//                       )
//                     : SizedBox(),
//                 widget.pickupType == "Pick up"
//                     ? Column(
//                         children: [
//                           widget.status == "Accepted" ||
//                                   widget.status == "Confirmed" ||
//                                   widget.status == "assigned to agent" ||
//                                   widget.status == "going to pickup" ||
//                                   widget.status == "pickup done" ||
//                                   widget.status == "delivered to Warehouse" ||
//                                   widget.status == "pickup item received"
//                               ? Container(
//                                   height: 50,
//                                   width: 50,
//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/defaulticon.png',
//                                       fit: BoxFit.fill),
//                                 )
//                               : Container(
//                                   height: 50,
//                                   width: 50,
//                                   // margin: EdgeInsets.only(left: 10, right: 10),
//                                   child: Image.asset(
//                                       'assets/images/Group 742.png',
//                                       fit: BoxFit.fill),
//                                 ),
//                         ],
//                       )
//                     : SizedBox(),
//                 widget.pickupType == "Pick up"
//                     ? Expanded(
//                         child: Container(
//                             // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                             child: Divider(
//                           color: Color(0xff4CAF50),
//                           height: 36,
//                         )),
//                       )
//                     : SizedBox(),
//                 Column(
//                   children: [
//                     widget.status == "Accepted" ||
//                             widget.status == "Confirmed" ||
//                             widget.status == "assigned to agent" ||
//                             widget.status == "going to pickup" ||
//                             widget.status == "pickup done" ||
//                             widget.status == "delivered to Warehouse"
//                         ? Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/defaulticon.png',
//                                 fit: BoxFit.fill),
//                           )
//                         : Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/Group 742.png',
//                                 fit: BoxFit.fill),
//                           ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                       // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                       child: Divider(
//                     color: Color(0xff4CAF50),
//                     height: 36,
//                   )),
//                 ),
//                 Column(
//                   children: [
//                     widget.status == "Accepted" ||
//                             widget.status == "Confirmed" ||
//                             widget.status == "assigned to agent" ||
//                             widget.status == "going to pickup" ||
//                             widget.status == "pickup done" ||
//                             widget.status == "delivered to Warehouse" ||
//                             widget.status == "pickup item received"
//                         ? Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/defaulticon.png',
//                                 fit: BoxFit.fill),
//                           )
//                         : Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/Group 742.png',
//                                 fit: BoxFit.fill),
//                           ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Container(
//                       // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//                       child: Divider(
//                     color: Color(0xff4CAF50),
//                     height: 36,
//                   )),
//                 ),
//                 Column(
//                   children: [
//                     widget.status == "Accepted" ||
//                             widget.status == "Confirmed" ||
//                             widget.status == "assigned to agent" ||
//                             widget.status == "going to pickup" ||
//                             widget.status == "pickup done" ||
//                             widget.status == "delivered to Warehouse" ||
//                             widget.status == "pickup item received" ||
//                             widget.status == "Delivered to Receptionist"
//                         ? Container(
//                             height: 50,
//                             width: 50,
//                             // margin: EdgeInsets.only(right: 20),
//                             // margin: EdgeInsets.only(left: 10, right: 10),
//                             child: Image.asset('assets/images/defaulticon.png',
//                                 fit: BoxFit.fill),
//                           )
//                         : Container(
//                             height: 50,
//                             width: 50,
//                             margin: EdgeInsets.only(right: 20),
//                             child: Image.asset('assets/images/Group 743.png',
//                                 fit: BoxFit.fill),
//                           ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(left: 10),
//                     child: Text(
//                       "Accepted",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(right: 10),
//                     child: Text(
//                       "Assign to Agent",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(right: 10),
//                     child: Text(
//                       "Going to Pickup",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(right: 10),
//                     child: Text(
//                       "Pickup Done",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(right: 30),
//                     child: Text(
//                       "Delivered to Depature Warehouse",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(right: 5),
//                     child: Text(
//                       "Recevied & Proceed for Shipment",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(right: 5),
//                     child: Text(
//                       "Delivered to Receptionist",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//                 // Spacer(),
//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(right: 5),
//                     child: Text(
//                       "Received by Receptionist",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     )),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10),
//             child: Container(
//               width: 90.0,
//               height: 90.0,
//               margin: const EdgeInsets.only(top: 10),
//               decoration: new BoxDecoration(
//                 borderRadius: BorderRadius.circular(200),
//               ),
//               child: Material(
//                   borderRadius: BorderRadius.circular(200),
//                   elevation: 10,
//                   child: imagepath == ''
//                       ? Center(child: Icon(Icons.person))
//                       : ClipRRect(
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(100)),
//                           child: Container(
//                               height: 90.0,
//                               width: 90.0,
//                               child: Image.network((imagepath),
//                                   fit: BoxFit.cover)))),
//             ),
//           ),
//           Padding(
//               padding: const EdgeInsets.only(top: 25),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       print(widget.status);
//                       if (widget.status == "Delivered to Receptionist") {
//                         if (onTap == 0) {
//                           _openCamera(context);
//                         } else {
//                           doChangeStatus();
//                         }
//                       }
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         left: 15,
//                         top: 15,
//                       ),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(25.0),
//                           color: widget.status == "Accepted"
//                               ? Color(0xff4CAF50)
//                               : widget.status == "going to pickup"
//                                   ? Colors.grey
//                                   : widget.status == "pickup done"
//                                       ? Colors.grey
//                                       : widget.status ==
//                                               "delivered to Warehouse"
//                                           ? Colors.grey
//                                           : widget.status ==
//                                                   "pickup item received"
//                                               ? Colors.grey
//                                               : widget.status ==
//                                                       "Delivered to Receptionist"
//                                                   ? Color(0xff4CAF50)
//                                                   : Colors.grey),
//                       height: 45,
//                       width: (!Responsive.isDesktop(context))
//                           ? MediaQuery.of(context).size.width * (30 / 100)
//                           : MediaQuery.of(context).size.width * (15 / 100),
//                       child: Center(
//                           child: widget.status == "Accepted"
//                               ? Text("Assign To Agent",
//                                   style: TextStyle(color: Colors.white))
//                               : widget.status == "going to pickup"
//                                   ? Text("Update Status",
//                                       style: TextStyle(color: Colors.black))
//                                   : widget.status == "pickup done"
//                                       ? Text("Update Status",
//                                           style: TextStyle(color: Colors.black))
//                                       : widget.status ==
//                                               "delivered to Warehouse"
//                                           ? Text("Update Status",
//                                               style: TextStyle(
//                                                   color: Colors.black))
//                                           : widget.status ==
//                                                   "pickup item received"
//                                               ? Text("Update Status",
//                                                   style: TextStyle(
//                                                       color: Colors.white))
//                                               : widget.status ==
//                                                       "Delivered to Receptionist"
//                                                   ? Text("Update Status",
//                                                       style: TextStyle(
//                                                           color: Colors.white))
//                                                   : Text("Update Status",
//                                                       style: TextStyle(
//                                                           color:
//                                                               Colors.white))),
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(
//                         left: 25,
//                         top: 15,
//                       ),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(25.0),
//                           color: Colors.black),
//                       height: 45,
//                       width: (!Responsive.isDesktop(context))
//                           ? MediaQuery.of(context).size.width * (30 / 100)
//                           : MediaQuery.of(context).size.width * (15 / 100),
//                       child: Center(
//                         child: Text("Close",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ),
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }
