import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/PickupAgent/pickupAgentDashboardModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Pickup%20Agent/alertdialog.dart';
import 'package:universal_html/html.dart';
import '../../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:easy_localization/easy_localization.dart';

import '../Dashboard/PickupDashboard.dart';

class inprogressOrders extends StatefulWidget {
  const inprogressOrders({Key? key}) : super(key: key);

  @override
  _inprogressOrdersState createState() => _inprogressOrdersState();
}

class _inprogressOrdersState extends State<inprogressOrders>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  String dropdownvalue = 'Picked';
  var exData = [];
  var exMData = [];
  bool isProcess = false;

  String? category;
  List<PickupDashData> pickupData = [];
  // var id = [];

  var amount;
  var items = ['Picked', 'Departed', 'Shipped', 'Waiting'];
  var item = [
    'Select Status',
    'Picker',
    'Departed',
  ];
  final TextEditingController _controllr = new TextEditingController();
  TabController? tabController;

  getPickupList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getpickupAgentDashboard();

    if (response.status == true) {
      setState(() {
        pickupData = response.data;
        exData = response.data;
      });
      for (int i = 0; i < pickupData.length; i++) {
        // id.add(pickupData[i].id.toString());

        // for (int j = i; j < pickupData[i].pickupReview.length; j++) {
        //   item.add(pickupData[i].pickupReview[j].pickupLocation);
        // }
      }
    }

    print("dhhjdhhdfhhfd" + item.toString());
    setState(() {
      isProcess = false;
    });
  }

  List<PickupAgentMArketData> marketPlaceOrder = [];
  getMArketPlaceList() async {
    var response = await Providers().pickupAgentMarketOrderhistory();

    if (response.status == true) {
      setState(() {
        marketPlaceOrder = response.data;
        exData = response.data;
      });
      for (int i = 0; i < pickupData.length; i++) {}
    }
    print("dhhjdhhdfhhfd" + marketPlaceOrder.toString());
  }

  var UserId, userRole;
  var roomId = 0;
  var chatListData = [];
  var shipmentId = 0;
  void getProfileDetails() async {
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
        shipmentId = userDetails.data[0].shipmentId;
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
    getPickupList();
    getMArketPlaceList();
    getProfileDetails();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
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
                      ? PickupDashboard()
                      : PrePickupAgentDashboard()));
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
            child: PickupSideBar(),
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
                                        child: pickupData.isEmpty
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
                                                  booking(),
                                                  orderTemplate(),
                                                  orderDetails2(),
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
                                                "Order",
                                              ),
                                            ),
                                          ),
                                          Tab(
                                            child: Container(
                                              width: 200,
                                              child: Text(
                                                "Market Place Orders",
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
                                        child: pickupData.isEmpty
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
                                                  MobileVieworderTemplate()
                                                  // orderTemplate(),
                                                  // orderDetails2(),
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
                                                  MobileViewmarketorder(),
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
                width: w * 0.08,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  "orderid".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                // width: MediaQuery.of(context).size.width * (20 / 100),
                width: w * 0.12,
                // margin: EdgeInsets.only(right: 30),
                child: Text(
                  "bookingdate".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),

            Container(
                width: w * 0.09,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                child: Text(
                  "title".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.10,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                // margin: EdgeInsets.only(left: 15),
                child: Text(
                  "clientname".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // Spacer(),
            Container(
                width: w * 0.08,
                margin: EdgeInsets.only(right: 50),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "status".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "changestatus".tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.08,
                margin: EdgeInsets.only(right: 40),
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
                      width: w * 0.09,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        marketPlaceOrder[index].bookingDate.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: w * 0.06,
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
                          marketPlaceOrder[index].client[0].name.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                      width: w * 0.09,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        marketPlaceOrder[index].marketStatus.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  InkWell(
                    onTap: () {
                      var id = marketPlaceOrder[index].mid.toString();

                      var type = 'Pick up';
                      var itemimage =
                          marketPlaceOrder[index].pickupItemimage.toString();

                      var itemimage1 =
                          marketPlaceOrder[index].pickupItemimage1.toString();
                      var comment =
                          marketPlaceOrder[index].pickupComment.toString();
                      var comment1 =
                          marketPlaceOrder[index].pickupComment1.toString();
                      var bookingdate =
                          marketPlaceOrder[index].bookingDate.toString();
                      var status =
                          marketPlaceOrder[index].marketStatus.toString();

                      print(id);

                      print(type);
                      print(bookingdate);
                      print(status);

                      if (marketPlaceOrder[index].pickupagentId != "" &&
                          status == "assigned to agent" &&
                          marketPlaceOrder[index].pickupAccept == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            var bookingReason = '';
                            var bookingStatus = '';

                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to accept/reject booking?"),
                              actions: [
                                InkWell(
                                  child: const Text("Reject          "),
                                  onTap: () {
                                    bookingStatus = '0';
                                    Navigator.of(context).pop();
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          StatefulBuilder(
                                        builder:
                                            (BuildContext context, setState) {
                                          return AlertDialog(
                                            scrollable: true,
                                            content: StatefulBuilder(
                                              builder: (BuildContext context,
                                                  setState) {
                                                return acceptRejectMarketContainer(
                                                    id,
                                                    bookingReason,
                                                    bookingStatus);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                                InkWell(
                                  child: const Text("        Accept "),
                                  onTap: () async {
                                    // Navigator.of(context).pop();
                                    bookingStatus = '1';
                                    var updateApiData = {
                                      "market_id": id.toString(),
                                      "status": bookingStatus.toString(),
                                      "reason": 'NA',
                                    };
                                    //print("updateApiData $updateApiData");
                                    var response = await Providers()
                                        .pickupAgentAcceptRejectMArket(
                                            updateApiData);
                                    if (response.status == true) {
                                      getMArketPlaceList();
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: const Text(
                                              "status change successfully"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);

                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CustomDialogBox1(
                                                          id,
                                                          type,
                                                          bookingdate,
                                                          status,
                                                          tabController!.index
                                                              .toString(),
                                                          itemimage,
                                                          comment,
                                                          itemimage1,
                                                          comment1,
                                                        ));
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogBox1(
                                  id,
                                  type,
                                  bookingdate,
                                  status,
                                  tabController!.index.toString(),
                                  itemimage,
                                  comment,
                                  itemimage1,
                                  comment1,
                                ));
                      }
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
                            "Update Status",
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
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "5"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].client[0].id, "1c"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].departureId, "3"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].arrivalId, "4"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].receptionistId, "2r"));
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
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id":
                            marketPlaceOrder[index].client[0].id, //other
                      };
                      print("-=-data11=- $data11");
                      print(
                          "-=-=-=shipmentOrder![index].client.id ${marketPlaceOrder[index].client[0].id}");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        width: w * 0.07,
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
                            "Chat",
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
                ],
              ),
            ),
          );
        });
  }

  Widget booking() {
    return (Responsive.isDesktop(context))
        ? Container(
            height: 40,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        print("export");
                        List<List> rows = <List>[
                          [
                            "Order ID",
                            "Booking Date",
                            "From",
                            "To",
                            "ShipmentCompany",
                            "Status"
                          ]
                        ];
                        for (int i = 0; i < exData.length; i++) {
                          List row = [];
                          row.add(exData[i].id);
                          // row.add(exData[i].bookingDate);
                          // row.add(exData[i].booking);
                          row.add(exData[i].bookingDate);
                          row.add(exData[i].from);
                          row.add(exData[i].to);
                          row.add(exData[i].title);
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
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    print("export");
                    List<List> rows = <List>[
                      [
                        "Order ID",
                        "Booking Date",
                        "From",
                        "To",
                        "ShipmentCompany",
                        "Status"
                      ]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      List row = [];
                      row.add(exData[i].id);
                      // row.add(exData[i].bookingDate);
                      // row.add(exData[i].booking);
                      row.add(exData[i].bookingDate);
                      row.add(exData[i].from);
                      row.add(exData[i].to);
                      row.add(exData[i].title);
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
                    var dataUrl = AnchorElement(
                        href: "data:text/plain;charset=utf-8,$csv")
                      ..setAttribute("download", fileName + ".csv")
                      ..click();
                  },
                  child: Container(
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
            ));
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 80,
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
              width: w * 0.045,
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "orderid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.070,
              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "bookingdate".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: w * 0.08,
          //     margin: EdgeInsets.only(left: 50),
          //     child: Text(
          //       "Boat/ Plane / Roads",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          Container(
              width: w * 0.03,
              // margin: EdgeInsets.only(right: 18),
              child: Text(
                "from".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.03,
              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "to".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.08,
              margin: EdgeInsets.only(right: 20),
              child: Text(
                "shipmentcomapny".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              margin: EdgeInsets.only(right: 8),
              width: w * 0.08,
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: w * 0.08,
              // margin: EdgeInsets.only(right: 40),
              child: Text(
                "chat".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails2() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: pickupData.length,
        reverse: false,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 70,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: w * 0.06,
                  child: Text(pickupData[index].id.toString()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(pickupData[index].bookingDate.toString()),
                ),
                Container(
                  width: w * 0.06,
                  child: Text(pickupData[index].from.toString()),
                ),
                Container(
                  width: w * 0.08,
                  child: Text(pickupData[index].to.toString()),
                ),
                Container(
                  width: w * 0.08,
                  child: Text(pickupData[index].shipmentCompany.toString()),
                ),
                GestureDetector(
                  onTap: () {
                    var id = pickupData[index].id.toString();
                    var itemimage =
                        pickupData[index].pickupItemimage.toString();

                    var itemimage1 =
                        pickupData[index].pickupItemimage1.toString();
                    var comment = pickupData[index].pickupComment.toString();
                    var comment1 = pickupData[index].pickupComment1.toString();
                    var type = pickupData[index].bookingType.toString();
                    var bookingdate = pickupData[index].bookingDate.toString();
                    var status = pickupData[index].status.toString();

                    print(id);
                    print(type);
                    print(bookingdate);
                    print(status);
                    print(
                        "=-=->>pickupData[index].pickupagentId ${pickupData[index].pickupagentId}");

                    if (pickupData[index].pickupagentId != "" &&
                        status == "assigned to agent" &&
                        pickupData[index].pickupAccept == 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          var bookingReason = '';
                          var bookingStatus = '';

                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you want to accept/reject booking?"),
                            actions: [
                              InkWell(
                                child: const Text("Reject          "),
                                onTap: () {
                                  bookingStatus = '0';
                                  Navigator.of(context).pop();
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        StatefulBuilder(
                                      builder:
                                          (BuildContext context, setState) {
                                        return AlertDialog(
                                          scrollable: true,
                                          content: StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                              return acceptRejectContainer(id,
                                                  bookingReason, bookingStatus);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              InkWell(
                                child: const Text("        Accept "),
                                onTap: () async {
                                  // Navigator.of(context).pop();
                                  bookingStatus = '1';
                                  var updateApiData = {
                                    "booking_id": id.toString(),
                                    "status": bookingStatus.toString(),
                                    "reason": 'NA',
                                  };
                                  //print("updateApiData $updateApiData");
                                  var response = await Providers()
                                      .pickupAgentAcceptReject(updateApiData);
                                  if (response.status == true) {
                                    getPickupList();
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        content: const Text(
                                            "status change successfully"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CustomDialogBox1(
                                                            id,
                                                            type,
                                                            bookingdate,
                                                            status,
                                                            '',
                                                            itemimage,
                                                            comment,
                                                            itemimage1,
                                                            comment1,
                                                          ));
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialogBox1(
                                id,
                                type,
                                bookingdate,
                                status,
                                '',
                                itemimage,
                                comment,
                                itemimage1,
                                comment1,
                              ));
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: w * 0.14,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        // margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            pickupData[index].status.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    var data11;
                    print("-=-= $chatListData");
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(UserId, "5"));
                    usersList.add(ChatUsers(
                        pickupData[index].clientInfoData[0].id, "1c"));
                    usersList.add(
                        ChatUsers(int.parse(pickupData[index].arrival), "4"));
                    usersList.add(
                        ChatUsers(int.parse(pickupData[index].departure), "3"));
                    usersList
                        .add(ChatUsers(pickupData[index].receptionistId, "2r"));
                    usersList.add(ChatUsers(pickupData[index].shipmentId, "1"));

                    print("-=-= $chatListData");

                    int trendIndex = chatListData
                        .indexWhere((f) => f['name'] == pickupData[index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": pickupData[index].title.toString(),
                      "firm_name": pickupData[index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": pickupData[index].scheduleId.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id":
                          pickupData[index].clientInfoData[0].id, //other
                    };
                    print("-=-data11=- $data11");
                    print(
                        "-=-=-=shipmentOrder![index].client.id ${pickupData[index].clientInfoData[0].id}");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      width: w * 0.09,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      //     MediaQuery.of(context).size.width * (12 / 100),
                      height: 40,
                      margin: EdgeInsets.only(right: 20),
                      child: Center(
                        child: Text(
                          "Chat",
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
              ],
            ),
          );
        });
  }

  Widget acceptRejectMarketContainer(id, bookingReason, bookingStatus) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("pleasenterreason".tr()),
          const SizedBox(
            height: 18,
          ),
          TextFormField(
            maxLength: 250,
            onChanged: (val) {
              bookingReason = val;
            },
            style: const TextStyle(color: Colors.black54, fontSize: 17),
            decoration: InputDecoration(
                labelText: "enterreason".tr(),
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                counterText: "",
                fillColor: const Color(0xffF5F6FA),
                filled: true,
                enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: "enterreason".tr(),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
          ),
          GestureDetector(
            onTap: () async {
              print("booking-=-= $id");
              //return;

              if (bookingReason.length <= 0) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("pleasenterreason".tr()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              // return;
              var updateApiData = {
                "market_id": id.toString(),
                "status": bookingStatus.toString(),
                "reason": bookingReason.toString(),
              };

              var response = await Providers()
                  .pickupAgentAcceptRejectMArket(updateApiData);
              if (response.status == true) {
                setState(() {
                  Navigator.pop(context);
                });
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("statuschangesuccessfully".tr()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getMArketPlaceList();
                        },
                        child: Text('ok'.tr()),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width * (20 / 100),
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue),
                  height: 35,
                  // width: 300,
                  child: Center(
                    child:
                        Text('reject', style: TextStyle(color: Colors.white)),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget acceptRejectContainer(id, bookingReason, bookingStatus) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("pleasenterreason".tr()),
          const SizedBox(
            height: 18,
          ),
          TextFormField(
            maxLength: 250,
            onChanged: (val) {
              bookingReason = val;
            },
            style: const TextStyle(color: Colors.black54, fontSize: 17),
            decoration: InputDecoration(
                labelText: "enterreason".tr(),
                labelStyle: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                ),
                counterText: "",
                fillColor: const Color(0xffF5F6FA),
                filled: true,
                enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: "enterreason".tr(),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
          ),
          GestureDetector(
            onTap: () async {
              print("booking-=-= $id");
              //return;

              if (bookingReason.length <= 0) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("pleasenterreason".tr()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('ok'.tr()),
                      ),
                    ],
                  ),
                );
                return;
              }

              // return;
              var updateApiData = {
                "booking_id": id.toString(),
                "status": bookingStatus.toString(),
                "reason": bookingReason.toString(),
              };

              var response =
                  await Providers().pickupAgentAcceptReject(updateApiData);
              if (response.status == true) {
                setState(() {
                  Navigator.pop(context);
                });
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("status change successfully"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          getPickupList();
                        },
                        child: Text('ok'.tr()),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Container(
                width: MediaQuery.of(context).size.width * (20 / 100),
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue),
                  height: 35,
                  // width: 300,
                  child: Center(
                    child: Text('reject'.tr(),
                        style: TextStyle(color: Colors.white)),
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget orderDetails3() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 150,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        children: [
          Container(
              width: w * 0.10,
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "12345",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "21.08.2021",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "Boat",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "USA",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.10,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "India",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: w * 0.06,

              // margin: EdgeInsets.only(left: 20),
              child: Text(
                "CMA CGM",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox(id));
            },
            child: Container(
                // margin: EdgeInsets.only(top: 25),
                height: MediaQuery.of(context).size.height * (5 / 100),
                // height: 100,
                width: MediaQuery.of(context).size.width * (10 / 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  // color: Color(0xff0FBAB8),
                ),
                child: Center(
                  child: Text(
                    "Waiting pickup",
                    style: TextStyle(fontSize: 15, color: Colors.red),
                  ),
                )),
          ),
          // Spacer(),
          GestureDetector(
            onTap: () {
              // showDialog(
              //     context: context,
              //     builder: (BuildContext context) => CustomDialogBox(id));
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                  // margin: EdgeInsets.only(top: 25, right: 10),
                  height: MediaQuery.of(context).size.height * (5 / 100),
                  // height: 100,
                  width: MediaQuery.of(context).size.width * (10 / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff4CAF50),
                  ),
                  child: Center(
                    child: Text(
                      "Pick up",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        primary: false,
        physics: BouncingScrollPhysics(),
        itemCount: pickupData.length,
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
                          pickupData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    GestureDetector(
                      onTap: () {
                        var id = pickupData[index].id.toString();
                        var itemimage =
                            pickupData[index].pickupItemimage.toString();

                        var itemimage1 =
                            pickupData[index].pickupItemimage1.toString();
                        var comment =
                            pickupData[index].pickupComment.toString();
                        var comment1 =
                            pickupData[index].pickupComment1.toString();
                        var type = pickupData[index].bookingType.toString();
                        var bookingdate =
                            pickupData[index].bookingDate.toString();
                        var status = pickupData[index].status.toString();

                        print(id);
                        print(type);
                        print(bookingdate);
                        print(status);
                        print(
                            "=-=->>pickupData[index].pickupagentId ${pickupData[index].pickupagentId}");

                        if (pickupData[index].pickupagentId != "" &&
                            status == "assigned to agent" &&
                            pickupData[index].pickupAccept == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var bookingReason = '';
                              var bookingStatus = '';

                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to accept/reject booking?"),
                                actions: [
                                  InkWell(
                                    child: const Text("Reject          "),
                                    onTap: () {
                                      bookingStatus = '0';
                                      Navigator.of(context).pop();
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            StatefulBuilder(
                                          builder:
                                              (BuildContext context, setState) {
                                            return AlertDialog(
                                              scrollable: true,
                                              content: StatefulBuilder(
                                                builder: (BuildContext context,
                                                    setState) {
                                                  return acceptRejectContainer(
                                                      id,
                                                      bookingReason,
                                                      bookingStatus);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    child: const Text("        Accept "),
                                    onTap: () async {
                                      // Navigator.of(context).pop();
                                      bookingStatus = '1';
                                      var updateApiData = {
                                        "booking_id": id.toString(),
                                        "status": bookingStatus.toString(),
                                        "reason": 'NA',
                                      };
                                      //print("updateApiData $updateApiData");
                                      var response = await Providers()
                                          .pickupAgentAcceptReject(
                                              updateApiData);
                                      if (response.status == true) {
                                        getPickupList();
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content: const Text(
                                                "status change successfully"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);

                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          CustomDialogBox1(
                                                            id,
                                                            type,
                                                            bookingdate,
                                                            status,
                                                            '',
                                                            itemimage,
                                                            comment,
                                                            itemimage1,
                                                            comment1,
                                                          ));
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBox1(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
                                    '',
                                    itemimage,
                                    comment,
                                    itemimage1,
                                    comment1,
                                  ));
                        }
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: const EdgeInsets.only(top: 10, right: 20),
                          decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(pickupData[index].status.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
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
                        child: Text("Shipment Company",
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
                          pickupData[index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(
                            pickupData[index].shipmentCompany.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, left: 15),
                        child: Text("from".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("to".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(
                          top: 10,
                          left: 15,
                        ),
                        child: Text(pickupData[index].from.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(pickupData[index].to.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "chat".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(UserId, "5"));
                    usersList.add(ChatUsers(
                        pickupData[index].clientInfoData[0].id, "1c"));
                    usersList.add(
                        ChatUsers(int.parse(pickupData[index].arrival), "4"));
                    usersList.add(
                        ChatUsers(int.parse(pickupData[index].departure), "3"));
                    usersList
                        .add(ChatUsers(pickupData[index].receptionistId, "2r"));
                    usersList.add(ChatUsers(pickupData[index].shipmentId, "1"));

                    print("-=-= $chatListData");

                    int trendIndex = chatListData
                        .indexWhere((f) => f['name'] == pickupData[index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": pickupData[index].title.toString(),
                      "firm_name": pickupData[index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": pickupData[index].scheduleId.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id":
                          pickupData[index].clientInfoData[0].id, //other
                    };
                    print("-=-data11=- $data11");
                    print(
                        "-=-=-=shipmentOrder![index].client.id ${pickupData[index].clientInfoData[0].id}");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff4CAF50),
                      ),
                      child: Center(
                        child: Text("chat".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget MobileViewmarketorder() {
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: marketPlaceOrder.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              height: MediaQuery.of(context).size.height * (45 / 100),
              width: w,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Container(
                      //     width: MediaQuery.of(context).size.width * (40 / 100),
                      //     margin: EdgeInsets.only(top: 10, right: 20),
                      //     child: Text("Waiting Pickup",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.red))),
                      GestureDetector(
                        onTap: () {
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) =>
                          //         CustomDialogBox(id));
                        },
                        child: Container(
                            width:
                                MediaQuery.of(context).size.width * (40 / 100),
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              marketPlaceOrder[index].marketStatus.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
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
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Text(
                            "clientname".tr(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 15, right: 20),
                          child: Text("changestatus".tr(),
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
                            marketPlaceOrder[index].client[0].name.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      InkWell(
                        onTap: () {
                          var id = marketPlaceOrder[index].mid.toString();

                          var type = 'Pick up';
                          var itemimage = marketPlaceOrder[index]
                              .pickupItemimage
                              .toString();

                          var itemimage1 = marketPlaceOrder[index]
                              .pickupItemimage1
                              .toString();
                          var comment =
                              marketPlaceOrder[index].pickupComment.toString();
                          var comment1 =
                              marketPlaceOrder[index].pickupComment1.toString();
                          var bookingdate =
                              marketPlaceOrder[index].bookingDate.toString();
                          var status =
                              marketPlaceOrder[index].marketStatus.toString();

                          print(id);

                          print(type);
                          print(bookingdate);
                          print(status);

                          if (marketPlaceOrder[index].pickupagentId != "" &&
                              status == "assigned to agent" &&
                              marketPlaceOrder[index].pickupAccept == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                var bookingReason = '';
                                var bookingStatus = '';

                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you want to accept/reject booking?"),
                                  actions: [
                                    InkWell(
                                      child: const Text("Reject          "),
                                      onTap: () {
                                        bookingStatus = '0';
                                        Navigator.of(context).pop();
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              StatefulBuilder(
                                            builder: (BuildContext context,
                                                setState) {
                                              return AlertDialog(
                                                scrollable: true,
                                                content: StatefulBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                          setState) {
                                                    return acceptRejectMarketContainer(
                                                        id,
                                                        bookingReason,
                                                        bookingStatus);
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                    InkWell(
                                      child: const Text("        Accept "),
                                      onTap: () async {
                                        // Navigator.of(context).pop();
                                        bookingStatus = '1';
                                        var updateApiData = {
                                          "market_id": id.toString(),
                                          "status": bookingStatus.toString(),
                                          "reason": 'NA',
                                        };
                                        //print("updateApiData $updateApiData");
                                        var response = await Providers()
                                            .pickupAgentAcceptRejectMArket(
                                                updateApiData);
                                        if (response.status == true) {
                                          getMArketPlaceList();
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              content: const Text(
                                                  "status change successfully"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            CustomDialogBox1(
                                                              id,
                                                              type,
                                                              bookingdate,
                                                              status,
                                                              tabController!
                                                                  .index
                                                                  .toString(),
                                                              itemimage,
                                                              comment,
                                                              itemimage1,
                                                              comment1,
                                                            ));
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomDialogBox1(
                                      id,
                                      type,
                                      bookingdate,
                                      status,
                                      tabController!.index.toString(),
                                      itemimage,
                                      comment,
                                      itemimage1,
                                      comment1,
                                    ));
                          }
                        },
                        child: Container(
                            width:
                                MediaQuery.of(context).size.width * (40 / 100),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            margin: EdgeInsets.only(top: 10, right: 20),
                            child: Text("updatestatus".tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ),
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * (40 / 100),
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "clientname".tr(),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "5"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].client[0].id, "1c"));
                      usersList
                          .add(ChatUsers(marketPlaceOrder[index].sid, "1"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].departureId, "3"));
                      usersList.add(
                          ChatUsers(marketPlaceOrder[index].arrivalId, "4"));
                      usersList.add(ChatUsers(
                          marketPlaceOrder[index].receptionistId, "2r"));
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
                        'receiver_type': '1c', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id":
                            marketPlaceOrder[index].client[0].id, //other
                      };
                      print("-=-data11=- $data11");
                      print(
                          "-=-=-=shipmentOrder![index].client.id ${marketPlaceOrder[index].client[0].id}");
                      //return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        width: w,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                        child: Center(
                          child: Text(
                            "chat".tr(),
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
                ],
              ),
            );
          }),
    );
  }

  Widget mbooking() {
    return (Responsive.isDesktop(context))
        ? Container(
            height: 80,
            width: MediaQuery.of(context).size.width * (80 / 100),
            margin: EdgeInsets.all(15),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
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
                      print("csv-=-= $csv");
                      var dataUrl = AnchorElement(
                          href: "data:text/plain;charset=utf-8,$csv")
                        ..setAttribute("download", fileName + ".csv")
                        ..click();
                    },
                    child: Container(
                        margin: EdgeInsets.only(top: 15, right: 10),
                        height: MediaQuery.of(context).size.height * (5 / 100),
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
                ),
              ],
            ))
        : Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
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
                  DateTime todayDate = DateTime(now.year, now.month, now.day);

                  String fileName = "order_" +
                      getRandomString(5) +
                      "_" +
                      todayDate.toString();

                  String csv = const ListToCsvConverter().convert(rows);
                  print("csv-=-= $csv");
                  var dataUrl =
                      AnchorElement(href: "data:text/plain;charset=utf-8,$csv")
                        ..setAttribute("download", fileName + ".csv")
                        ..click();
                },
                child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
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
            ));
  }
}
