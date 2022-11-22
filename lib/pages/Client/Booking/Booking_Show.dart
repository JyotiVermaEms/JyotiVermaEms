import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/Client/ViewBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Booking_Dashboard.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/pages/Client/Booking/bookingdetails.dart';
import 'package:shipment/pages/Shipment/MarketPlace/alertdialogMarketplacebooking.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

import '../Dashboard/MobileDashboard.dart';

class BookingShow extends StatefulWidget {
  const BookingShow({Key? key}) : super(key: key);

  @override
  _BookingShowState createState() => _BookingShowState();
}

class _BookingShowState extends State<BookingShow>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;

  List<Data> viewbooking = [];
  List<MarketBookingData> viewMarketbooking = [];

  String? token;
  var index;
  var companyname;
  var statusCheck;
  var reason;

  TabController? tabController;
  var UserId, userRole;
  var roomId = 0;
  var listBData = [];
  var listMData = [];
  var chatListData = [];
  bool isProcess = false;

  var localBookingid1 = '0';

  getView() async {
    setState(() {
      isProcess = true;
    });
    print('view booking');
    var response = await Providers().getViewBooking();
    if (response.status == true) {
      setState(() {
        viewbooking = response.data;
      });
      for (int i = 0; i < viewbooking.length; i++) {
        // reason = viewbooking[i].reason.toString();
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  getMarketView() async {
    setState(() {
      isProcess = true;
    });
    print('view getMarketView booking');
    var response = await Providers().getViewMarketAcceotBooking();
    if (response.status == true) {
      for (int i = 0; i < response.data.length; i++) {
        setState(() {
          viewMarketbooking.add(response.data[i]);
        });
      }
    }
    setState(() {
      isProcess = false;
    });
  }

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

      print("--->>.len ${response.data.length}");

      for (int i = 0; i < response.data.length; i++) {
        print(response.data[i].sid);
        chatListData
            .add({"id": response.data[i].roomId, "name": response.data[i].sid});
      }

      print("-=-=-=chatListData data $chatListData");

      setState(() {});
    } else {
      roomId = 0;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileDetails();
    setState(() {});
    getView();
    // getMarketView();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );

    Future.delayed(Duration(seconds: 30), () {
      // Do something
    });
  }

  checkPaymentDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getStatus = prefs.getString("comeFrom");
    //localBookingid = prefs.getString("bookingid")!;
    if (getStatus != null) {
      getView();
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Reject Reason"),
      content: Text(reason),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget ContainerListDialog1({
    String? reason,
  }) {
    return Container(
        height: h * 0.30,
        width: w * 0.20,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                "rejectreason".tr(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 60),
                child: Text(reason.toString())),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Container(
                    height: 30,
                    width: 40,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Center(
                        child: Text(
                      "ok".tr(),
                      style: TextStyle(color: Colors.grey),
                    ))),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ));
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
                      ? MobileDashboard()
                      : DashboardHome()));
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
            child: SideBar(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (!Responsive.isDesktop(context))
                                IconButton(
                                  icon: Icon(Icons.menu),
                                  onPressed: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                              Container(
                                margin: EdgeInsets.fromLTRB(5, 5, 120, 0),
                                child: Text(
                                  'booking'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (Responsive.isDesktop(context))
                                SizedBox(width: w * 0.55),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                      onTap: () {
                                        (!Responsive.isDesktop(context))
                                            ? Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BookingShow()))
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        BookingDashboard()));
                                      },
                                      child: Icon(Icons.refresh_sharp,
                                          color: Colors.black)))
                            ],
                          ),
                        ),
                        if (Responsive.isDesktop(context))
                          Column(
                            children: [
                              Container(
                                height: h,
                                width: w * 0.80,
                                child: SingleChildScrollView(
                                  child: viewbooking.length == 0
                                      ? Container(
                                          height: 200,
                                          width: double.infinity,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
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
                                                    style: headingStyle16MB(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          children: [
                                            orderTemplate(),
                                            orderDetails(),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        if (!Responsive.isDesktop(context))
                          Column(
                            children: [
                              MobileVieworderTemplate(),
                              // MobileVieworderTemplate2(),
                            ],
                          ),
                      ])),
                )),
    );
  }

  Widget booking() {
    return Container(
        height: 80,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("allorder".tr(),
                          style: TextStyle(fontSize: 14, color: Colors.grey))),
                ),

                Container(
                    margin: EdgeInsets.only(top: 15, right: 10),
                    height: MediaQuery.of(context).size.height * (5 / 100),
                    // height: 100,
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Text(
                          "selectstatus".tr(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )),
                Spacer(),

                Container(
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

                // Spacer(),
                Container(
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
                            "print".tr(),
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
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(top: 15, right: 15),
                    height: MediaQuery.of(context).size.height * (5 / 100),
                    // width: MediaQuery.of(context)
                    //         .size
                    //         .width *
                    //     (11 / 100),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            "addbooking".tr(),
                            style: headingStylewhite14(),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Icon(
                            Icons.add_box,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ));
  }

  Widget orderTemplate() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "bookingid".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (15 / 100),

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
              width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "status".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (15 / 100),
              child: Text(
                "action".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (5 / 100),
              child: Text(
                "chat".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: viewbooking.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (context, index) {
          var reason = viewbooking[index].reason.toString();
          print("Resonnnnn show finally ------$reason");
          return Container(
            height: 80,
            width: w * 0.90,
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Row(children: [
              Container(
                  width: MediaQuery.of(context).size.width * (10 / 100),
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    viewbooking[index].id.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              // Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width * (15 / 100),

                  // margin: EdgeInsets.only(left: 20),
                  child: Text(
                    (DateFormat('dd-MM-yyyy').format(DateTime.parse(
                        viewbooking[index].createdAt.toString()))),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),

              Container(
                width: MediaQuery.of(context).size.width * (15 / 100),
                child: InkWell(
                  onTap: () {
                    log(viewbooking[index].shipmentCompany);
                    log(viewbooking[index].id.toString());
                    log(viewbooking[index].to.toString());
                    log(viewbooking[index].from.toString());

                    log(viewbooking[index].bookingType);

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
                                  dialogid: viewbooking[index].id,
                                  dailogbookingtype:
                                      viewbooking[index].bookingType,
                                  dailogfrom: viewbooking[index].from,
                                  dialogto: viewbooking[index].to,
                                  dailogshipmentCompany:
                                      viewbooking[index].shipmentCompany),
                            ),
                          );
                        });
                  },
                  child: Text(
                    viewbooking[index].title.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff1A494F)),
                  ),
                ),
              ),

              Container(
                  width: MediaQuery.of(context).size.width * (10 / 100),
                  margin: EdgeInsets.only(right: 20),
                  child: viewbooking[index].accepted == 0
                      ? viewbooking[index].rejected == 0
                          ? Text(
                              "Pending",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : InkWell(
                              onTap: () {
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
                                          content: ContainerListDialog1(
                                            reason: viewbooking[index].reason,
                                          ),
                                        ),
                                      );
                                    });
                                // showAlertDialog(context);
                              },
                              child: Text(
                                "Rejected",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ))
                      : Text(
                          viewbooking[index].status,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  // )
                  ),
              InkWell(
                onTap: () {
                  var data = {
                    "id": viewbooking[index].id,
                    for (int i = 0; i < viewbooking[index].item.length; i++)
                      'itemimage1': viewbooking[index].item[i].itemImage,
                    'itemdetail': viewbooking[index].item,
                    'transactionid':
                        viewbooking[index].transactionId.toString(),
                    'totalamount': viewbooking[index].totalAmount.toString(),
                    'pickuptype': viewbooking[index]
                        .pickupReview[0]
                        .pickupType
                        .toString(),
                    'pickuplocation': viewbooking[index]
                        .pickupReview[0]
                        .pickupLocation
                        .toString(),
                    'pickupdate': viewbooking[index]
                        .pickupReview[0]
                        .pickupDate
                        .toString(),
                    'pickuptime': viewbooking[index]
                        .pickupReview[0]
                        .pickupTime
                        .toString(),
                    'pickupdistance': viewbooking[index]
                        .pickupReview[0]
                        .pickupDistance
                        .toString(),
                    'pickupestimate': viewbooking[index]
                        .pickupReview[0]
                        .pickupEstimate
                        .toString(),
                    'name': viewbooking[index].receptionist[0].name.toString(),
                    'lname':
                        viewbooking[index].receptionist[0].lname.toString(),
                    'email':
                        viewbooking[index].receptionist[0].email.toString(),
                    'Id': viewbooking[index].receptionist[0].id.toString(),
                    'profileimage': viewbooking[index]
                        .receptionist[0]
                        .profileimage
                        .toString(),
                    'phone':
                        viewbooking[index].receptionist[0].phone.toString(),
                    'address':
                        viewbooking[index].receptionist[0].address.toString(),
                    'country':
                        viewbooking[index].receptionist[0].country.toString(),
                    'status':
                        viewbooking[index].receptionist[0].status.toString(),
                    'company': viewbooking[index].shipmentCompany.toString(),
                    'schedule_id': viewbooking[index].scheduleId.toString(),
                    'title': viewbooking[index].title.toString(),
                    'bookingdate': viewbooking[index].bookingDate.toString(),
                    'arrivaldate': viewbooking[index].arrivalDate.toString(),
                    'type': viewbooking[index].bookingType.toString(),
                    'shipcmpany': viewbooking[index].shipmentCompany.toString(),
                    'bookingStatus': viewbooking[index].status.toString(),
                    for (int i = 0; i < viewbooking[index].item.length; i++)
                      'pickupsilder': viewbooking[index].item,
                    'itemimage': viewbooking[index].pickupItemimage.toString(),
                    'comment': viewbooking[index].pickupComment.toString(),
                    'itemimage1':
                        viewbooking[index].pickupItemimage1.toString(),
                    'comment1': viewbooking[index].pickupComment1.toString(),
                    'depatureimage':
                        viewbooking[index].departureImage.toString(),
                    'depaturecomment':
                        viewbooking[index].departureComment.toString(),
                    'arrivalimage': viewbooking[index].arrivalImage.toString(),
                    'arrivalcomment':
                        viewbooking[index].arrivalComment.toString(),
                    'receptionistimage':
                        viewbooking[index].receptionistImage.toString(),
                    'receptionistcomment':
                        viewbooking[index].receptionistComment.toString(),
                  };
                  print("-=-=-=-=-=data >> ----$data");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResBookingDetails(data),
                      ));
                },
                child: Container(
                  margin:
                      EdgeInsets.only(left: 15, top: 15, bottom: 30, right: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green),
                  height: 45,
                  width: 140,
                  child: Center(
                    child: Text("viewdetails".tr(),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
              viewbooking[index].rejected == 0
                  ? GestureDetector(
                      onTap: () {
                        var data11;
                        List<ChatUsers> usersList = [];
                        usersList.add(ChatUsers(UserId, "1c"));
                        usersList.add(
                            ChatUsers(viewbooking[index].arrival[0].id, "4"));
                        usersList.add(
                            ChatUsers(viewbooking[index].departure[0].id, "3"));

                        usersList.add(ChatUsers(
                            viewbooking[index].departure[0].shipmentId, "1"));
                        usersList.add(ChatUsers(
                            viewbooking[index].receptionist[0].id, "2r"));
                        viewbooking[index].pickupagentId != 0
                            ? usersList.add(ChatUsers(
                                viewbooking[index].pickupagentId, "5"))
                            : '';

                        print("-=chatListData-= $chatListData");

                        int trendIndex = chatListData.indexWhere(
                            (f) => f['name'] == viewbooking[index].id);
                        print("-=-=-trendIndex $trendIndex");
                        if (trendIndex != -1) {
                          roomId = chatListData[trendIndex]['id'];
                          print("-=-=- $usersList");
                          print(
                              "-=-roomId=- ${chatListData[trendIndex]['id']}");
                        }

                        data11 = {
                          "group_name": viewbooking[index].title.toString(),
                          "firm_name": viewbooking[index].title.toString(),
                          "chat_type": "group",
                          "room_id": roomId,
                          "userList": jsonEncode(usersList),
                          "user_id": viewbooking[index].uid.toString(),
                          "sid": viewbooking[index].id.toString(),
                          'sender_type': userRole.toString(),
                          'receiver_type': '1', //shipment
                          "sender_id": UserId.toString(), //me
                          "receiver_id": viewbooking[index]
                              .departure[0]
                              .shipmentId
                              .toString(), //other
                        };
                        print("-=-=- $data11");
                        print(viewbooking[index]
                            .departure[0]
                            .shipmentId
                            .toString());
                        // return;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatViewScreen(data11),
                            ));
                      },
                      child: Container(
                          margin:
                              EdgeInsets.only(left: 20, top: 15, bottom: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green),
                          height: 45,
                          width: 130,
                          child: Center(
                            child: Text(
                              "chat".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    )
                  : Container(
                      margin: EdgeInsets.only(left: 20, top: 15, bottom: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey),
                      height: 45,
                      width: 130,
                      child: Center(
                        child: Text(
                          "chat".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ))
            ]),
          );
        });
  }

  Widget marketBookingTemplate() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width * (80 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      child: Row(
        children: [
          Container(
              width: MediaQuery.of(context).size.width * (12 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Market ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (14 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              width: MediaQuery.of(context).size.width * (16 / 100),
              child: Text(
                "Schedule Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (14 / 100),
              child: Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (13 / 100),
              child: Text(
                "Chat",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (7 / 100),
              child: Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Container(
          //     width: MediaQuery.of(context).size.width * (10 / 100),
          //     child: Text(
          //       "Action",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Container(
          //     width: MediaQuery.of(context).size.width * (10 / 100),
          //     child: Text(
          //       "Chat",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
        ],
      ),
    );
  }

  Widget marketBookingDetails() {
    return isProcess == true
        ? Container(
            height: 10,
            width: 10,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          )
        : ListView.builder(
            itemCount: viewMarketbooking.length,
            shrinkWrap: true,
            reverse: false,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                width: w * 0.90,
                margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                child: Row(children: [
                  Container(
                      width: MediaQuery.of(context).size.width * (12 / 100),
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        viewMarketbooking[index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: MediaQuery.of(context).size.width * (14 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        (DateFormat('dd-MM-yyyy').format(DateTime.parse(
                            viewMarketbooking[index].createdAt.toString()))),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    child: InkWell(
                      onTap: () {
                        // log(viewbooking[index].shipmentCompany);
                        // log(viewbooking[index].id.toString());
                        // log(viewbooking[index].to.toString());
                        // log(viewbooking[index].from.toString());

                        // log(viewbooking[index].bookingType);

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
                                      dialogid: viewMarketbooking[index].id,
                                      dailogbookingtype: 'Market Place',
                                      dailogfrom: viewMarketbooking[index]
                                          .pickupLocation,
                                      dialogto: viewMarketbooking[index]
                                          .dropoffLocation,
                                      dailogshipmentCompany: ''),
                                ),
                              );
                            });
                      },
                      child: Text(
                        viewMarketbooking[index].title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A494F)),
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      viewMarketbooking[index].status,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var data11;
                      List<ChatUsers> usersList = [];
                      usersList.add(ChatUsers(UserId, "1c"));
                      usersList.add(
                          ChatUsers(viewMarketbooking[index].arrivalId, "4"));
                      usersList.add(
                          ChatUsers(viewMarketbooking[index].departureId, "3"));
                      viewMarketbooking[index].pickupagentId != 0
                          ? usersList.add(ChatUsers(
                              viewMarketbooking[index].pickupagentId, "5"))
                          : '';
                      usersList.add(ChatUsers(
                          viewMarketbooking[index].receptionistId, "2r"));

                      usersList
                          .add(ChatUsers(viewMarketbooking[index].sid, "1"));

                      print("-=chatListData-= $chatListData");
                      // var checkID = "m_" + viewMarketbooking[index].id.toString();
                      var checkID = viewMarketbooking[index].id;
                      var trendIndex =
                          chatListData.indexWhere((f) => f['name'] == checkID);
                      print("-=-=-trendIndex $trendIndex");
                      if (trendIndex != -1) {
                        roomId = chatListData[trendIndex]['id'];
                        print("-=-=- $usersList");
                        print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                      }

                      data11 = {
                        "group_name": viewMarketbooking[index].title.toString(),
                        "firm_name": viewMarketbooking[index].title.toString(),
                        "chat_type": "group",
                        "room_id": roomId,
                        "userList": jsonEncode(usersList),
                        "user_id": viewMarketbooking[index].uid.toString(),
                        "sid": checkID.toString(),
                        'sender_type': userRole.toString(),
                        'receiver_type': '1', //shipment
                        "sender_id": UserId.toString(), //me
                        "receiver_id":
                            viewMarketbooking[index].sid.toString(), //other
                      };
                      print("-=-=- $data11");

                      // return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatViewScreen(data11),
                          ));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 15, bottom: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.green),
                        height: 45,
                        width: 140,
                        child: Center(
                          child: Text(
                            "Chat",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      var id = viewMarketbooking[index].id.toString();
                      var type = viewMarketbooking[index].dropoff.toString();
                      var bookingdate =
                          viewMarketbooking[index].bookingDate.toString();
                      var status = viewMarketbooking[index].status;
                      var itemimage =
                          viewMarketbooking[index].pickupItemimage.toString();
                      var comment =
                          viewMarketbooking[index].pickupComment.toString();
                      var itemimage1 =
                          viewMarketbooking[index].pickupItemimage1.toString();
                      var comment1 =
                          viewMarketbooking[index].pickupComment1.toString();
                      var depatureimage =
                          viewMarketbooking[index].departureImage.toString();
                      var depaturecomment = viewMarketbooking[index].toString();
                      var arrivalimage =
                          viewMarketbooking[index].arrivalImage.toString();
                      var arrivalcomment =
                          viewMarketbooking[index].arrivalComment.toString();
                      var receptionistimage =
                          viewMarketbooking[index].receptionistImage.toString();
                      var receptionistcomment = viewMarketbooking[index]
                          .receptionistComment
                          .toString();
                      var pickupType =
                          viewMarketbooking[index].dropoff.toString();
                      print(id);

                      print(type);
                      print(bookingdate);
                      print("jsdkhkhdsjkhjkd$status");
                      viewMarketbooking[index].dropoff == "Pick up"
                          ? showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxShipmentMarket(
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
                                      receptionistcomment

                                      // bookingData[index]
                                      //     .pickupReview[0]
                                      //     .pickupType
                                      //     .toString(),
                                      ))
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomDialogBoxShipmentDropOff(
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
                                      receptionistcomment));
                    },
                    child: Container(
                        margin: EdgeInsets.only(left: 40, top: 15, bottom: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.green),
                        height: 45,
                        width: 140,
                        child: Center(
                          child: Text(
                            "View Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ]),
              );
            });
  }

  Widget MobileVieworderTemplate() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
          itemCount: viewbooking.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              // height: (!Responsive.isDesktop(context))
              //     ? MediaQuery.of(context).size.height * (10 / 100)
              //     : MediaQuery.of(context).size.height * (45 / 100),
              // height: MediaQuery.of(context).size.height * (50 / 100),
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
                            "bookingid".tr(),
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
                            viewbooking[index].id.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 10, right: 20),
                          child: viewbooking[index].accepted == 0
                              ? viewbooking[index].rejected == 0
                                  ? Text(
                                      "Pending",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : InkWell(
                                      onTap: () {
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
                                                child: AlertDialog(
                                                  backgroundColor: Colors.white,
                                                  content: ContainerListDialog1(
                                                    reason: viewbooking[index]
                                                        .reason,
                                                  ),
                                                ),
                                              );
                                            });
                                        // showAlertDialog(context);
                                      },
                                      child: Text(
                                        "Rejected",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ))
                              : Text(
                                  viewbooking[index].status,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
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
                          child: Text("scheduletitle".tr(),
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
                            (DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                viewbooking[index].createdAt.toString()))),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: InkWell(
                          onTap: () {
                            log(viewbooking[index].shipmentCompany);
                            log(viewbooking[index].id.toString());
                            log(viewbooking[index].to.toString());
                            log(viewbooking[index].from.toString());

                            log(viewbooking[index].bookingType);

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
                                          dialogid: viewbooking[index].id,
                                          dailogbookingtype:
                                              viewbooking[index].bookingType,
                                          dailogfrom: viewbooking[index].from,
                                          dialogto: viewbooking[index].to,
                                          dailogshipmentCompany:
                                              viewbooking[index]
                                                  .shipmentCompany),
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            viewbooking[index].title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1A494F)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      var data = {
                        "id": viewbooking[index].id,
                        for (int i = 0; i < viewbooking[index].item.length; i++)
                          'itemimage1': viewbooking[index].item[i].itemImage,
                        'itemdetail': viewbooking[index].item,
                        'transactionid':
                            viewbooking[index].transactionId.toString(),
                        'totalamount':
                            viewbooking[index].totalAmount.toString(),
                        'pickuptype': viewbooking[index]
                            .pickupReview[0]
                            .pickupType
                            .toString(),
                        'pickuplocation': viewbooking[index]
                            .pickupReview[0]
                            .pickupLocation
                            .toString(),
                        'pickupdate': viewbooking[index]
                            .pickupReview[0]
                            .pickupDate
                            .toString(),
                        'pickuptime': viewbooking[index]
                            .pickupReview[0]
                            .pickupTime
                            .toString(),
                        'pickupdistance': viewbooking[index]
                            .pickupReview[0]
                            .pickupDistance
                            .toString(),
                        'pickupestimate': viewbooking[index]
                            .pickupReview[0]
                            .pickupEstimate
                            .toString(),
                        'name':
                            viewbooking[index].receptionist[0].name.toString(),
                        'lname':
                            viewbooking[index].receptionist[0].lname.toString(),
                        'email':
                            viewbooking[index].receptionist[0].email.toString(),
                        'Id': viewbooking[index].receptionist[0].id.toString(),
                        'profileimage': viewbooking[index]
                            .receptionist[0]
                            .profileimage
                            .toString(),
                        'phone':
                            viewbooking[index].receptionist[0].phone.toString(),
                        'address': viewbooking[index]
                            .receptionist[0]
                            .address
                            .toString(),
                        'country': viewbooking[index]
                            .receptionist[0]
                            .country
                            .toString(),
                        'status': viewbooking[index]
                            .receptionist[0]
                            .status
                            .toString(),
                        'company':
                            viewbooking[index].shipmentCompany.toString(),
                        'schedule_id': viewbooking[index].scheduleId.toString(),
                        'title': viewbooking[index].title.toString(),
                        'bookingdate':
                            viewbooking[index].bookingDate.toString(),
                        'arrivaldate':
                            viewbooking[index].arrivalDate.toString(),
                        'type': viewbooking[index].bookingType.toString(),
                        'shipcmpany':
                            viewbooking[index].shipmentCompany.toString(),
                        'bookingStatus': viewbooking[index].status.toString(),
                        for (int i = 0; i < viewbooking[index].item.length; i++)
                          'pickupsilder': viewbooking[index].item,
                        'itemimage':
                            viewbooking[index].pickupItemimage.toString(),
                        'comment': viewbooking[index].pickupComment.toString(),
                        'itemimage1':
                            viewbooking[index].pickupItemimage1.toString(),
                        'comment1':
                            viewbooking[index].pickupComment1.toString(),
                        'depatureimage':
                            viewbooking[index].departureImage.toString(),
                        'depaturecomment':
                            viewbooking[index].departureComment.toString(),
                        'arrivalimage':
                            viewbooking[index].arrivalImage.toString(),
                        'arrivalcomment':
                            viewbooking[index].arrivalComment.toString(),
                        'receptionistimage':
                            viewbooking[index].receptionistImage.toString(),
                        'receptionistcomment':
                            viewbooking[index].receptionistComment.toString(),
                      };
                      print("-=-=-=-=-=data >> ----$data");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResBookingDetails(data),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 15, bottom: 10, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.green),
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text("viewdetails".tr(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  viewbooking[index].rejected == 0
                      ? GestureDetector(
                          onTap: () {
                            var data11;
                            List<ChatUsers> usersList = [];
                            usersList.add(ChatUsers(UserId, "1c"));
                            usersList.add(ChatUsers(
                                viewbooking[index].arrival[0].id, "4"));
                            usersList.add(ChatUsers(
                                viewbooking[index].departure[0].id, "3"));

                            usersList.add(ChatUsers(
                                viewbooking[index].departure[0].shipmentId,
                                "1"));
                            usersList.add(ChatUsers(
                                viewbooking[index].receptionist[0].id, "2r"));
                            viewbooking[index].pickupagentId != 0
                                ? usersList.add(ChatUsers(
                                    viewbooking[index].pickupagentId, "5"))
                                : '';

                            print("-=chatListData-= $chatListData");

                            int trendIndex = chatListData.indexWhere(
                                (f) => f['name'] == viewbooking[index].id);
                            print("-=-=-trendIndex $trendIndex");
                            if (trendIndex != -1) {
                              roomId = chatListData[trendIndex]['id'];
                              print("-=-=- $usersList");
                              print(
                                  "-=-roomId=- ${chatListData[trendIndex]['id']}");
                            }

                            data11 = {
                              "group_name": viewbooking[index].title.toString(),
                              "firm_name": viewbooking[index].title.toString(),
                              "chat_type": "group",
                              "room_id": roomId,
                              "userList": jsonEncode(usersList),
                              "user_id": viewbooking[index].uid.toString(),
                              "sid": viewbooking[index].id.toString(),
                              'sender_type': userRole.toString(),
                              'receiver_type': '1', //shipment
                              "sender_id": UserId.toString(), //me
                              "receiver_id": viewbooking[index]
                                  .departure[0]
                                  .shipmentId
                                  .toString(), //other
                            };
                            print("-=-=- $data11");
                            print(viewbooking[index]
                                .departure[0]
                                .shipmentId
                                .toString());
                            // return;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatViewScreen(data11),
                                ));
                          },
                          child: Container(
                              margin: EdgeInsets.only(
                                  left: 15, top: 5, bottom: 30, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.green),
                              height: 45,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "Chat",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        )
                      : Container(
                          margin: EdgeInsets.only(
                              left: 15, top: 5, bottom: 30, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.grey),
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Chat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )),
                ],
              ),
            );
          }),
    );
  }

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
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
                          "Booking ID",
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
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          viewbooking[index].id.toString(),
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
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBox());
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(left: 15, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xff0FBAB8),
                          ),
                          child: Center(
                            child: Text(
                              viewbooking[index].status,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
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
                          "Booking Date",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Boat/ Plane / Roads",
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
                          viewbooking[index].bookingDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(viewbooking[index].bookingType,
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
                          "Shipment Company",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("from",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text("to",
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
                          viewbooking[index].shipmentCompany,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(viewbooking[index].to,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(viewbooking[index].from,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
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
      height: h * 0.35,
      width: (Responsive.isDesktop(context)) ? w * 0.40 : w * 0.75,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
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
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
                    child: Text(
                      "Booking Id",
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
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
                    child: Text(
                      "Company Name",
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
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
                    child: Text(
                      // bookingtype.toString(),
                      "Booking Type",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
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
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
                    child: Text(
                      "From",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width: w * 0.10,
                    child:
                        Text(dailogfrom.toString(), style: headingStyle16MB()),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    width:
                        (Responsive.isDesktop(context)) ? w * 0.15 : w * 0.30,
                    child: Text("To", style: headingStyle16MB()),
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
      ),
    );
  }
}
