import 'dart:convert';
//import 'dart:html';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/Shipment/ShipmentOrderModel.dart';

import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Orders/shipmentcustomdialogBox.dart';
import 'package:universal_html/html.dart';
// import 'package:shipment/pages/Shipment/Orders/pdf.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class orders extends StatefulWidget {
  const orders({Key? key}) : super(key: key);

  @override
  _ordersState createState() => _ordersState();
}

class _ordersState extends State<orders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  String? bookingid, bookingdate, status1, title1, type, from1, to1, orderId;
  int? Id;
  List<ShipmentOrder>? shipmentOrder;
  var exData = [];
  bool isProcess = false;

  var chatListData = [];

  getShipmentList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().shipmentActiveOrder();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('client_Id', Id.toString());

    setState(() {
      shipmentOrder = response.data;
      exData = response.data;
    });

    setState(() {
      isProcess = false;
    });
  }

  var UserId, userRole;
  var roomId = 0;
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
    var data = {"userId": UserId.toString(), "userToRole": userRole.toString()};
    var response = await Providers().getChatList(data);
    print("-=-=-=data ${data}");
    if (response.status == true) {
      print("-=-=-=response data ${response.data}");

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
    getShipmentList();
    getProfileDetails();
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
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 10, 20, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'Order',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        Column(
                          children: [
                            booking(),
                            orderTemplate(),
                            orderDetails(),
                          ],
                        ),
                      if (!Responsive.isDesktop(context))
                        Column(
                          children: [
                            MobileVieworderTemplate(),
                          ],
                        ),
                    ])),
              ));
  }

  Widget booking() {
    return Container(
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
                      ["Order ID", "Title", "Type", "To", "From", "Status"]
                    ];
                    for (int i = 0; i < exData.length; i++) {
                      List row = [];
                      row.add(exData[i].id);
                      // row.add(exData[i].bookingDate);
                      row.add(exData[i].title);
                      row.add(exData[i].bookingType);
                      row.add(exData[i].to);
                      row.add(exData[i].from);
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
                      margin: EdgeInsets.only(right: 10),
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
                              "Export",
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
            Row(
              children: [],
            ),
          ],
        ));
  }

  Widget orderTemplate() {
    return shipmentOrder!.length == 0
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
                      'Sorry, You have not any Bookings yet',
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
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
                    width: MediaQuery.of(context).size.width * (11 / 100),
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "Order ID",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (15 / 100),

                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      "Booking Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),

                Container(
                    width: MediaQuery.of(context).size.width * (22 / 100),
                    child: Text(
                      "Schedule Title",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (18 / 100),
                    child: Text(
                      "Status",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    child: Text(
                      "Chat",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: shipmentOrder!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: 80,
            width: MediaQuery.of(context).size.width * (10 / 100),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * (10 / 100),
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      shipmentOrder![index].id.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                // Spacer(),
                Container(
                    width: MediaQuery.of(context).size.width * (17 / 100),

                    // margin: EdgeInsets.only(left: 20),
                    child: Text(
                      shipmentOrder![index].bookingDate.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),

                Container(
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  child:
                      // Row(
                      //   children: [
                      InkWell(
                    onTap: () {
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
                                    stitle: shipmentOrder![index].title,
                                    sid: shipmentOrder![index].id,
                                    stype: shipmentOrder![index].bookingType,
                                    sto: shipmentOrder![index].to,
                                    sfrom: shipmentOrder![index].from,
                                    bookingitem:
                                        shipmentOrder![index].bookingItem,
                                    h: h,
                                    w: w),
                              ),
                            );
                          });
                    },
                    child: Text(
                      shipmentOrder![index].title.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A494F)),
                    ),
                  ),
                ),
                // Spacer(),
                InkWell(
                  onTap: () {
                    var id = shipmentOrder![index].id.toString();
                    var type = shipmentOrder![index].bookingType.toString();
                    var bookingdate =
                        shipmentOrder![index].bookingDate.toString();
                    var status = shipmentOrder![index].status.toString();
                    var itemimage =
                        shipmentOrder![index].pickupItemimage.toString();
                    var comment =
                        shipmentOrder![index].pickupComment.toString();
                    var itemimage1 =
                        shipmentOrder![index].pickupItemimage1.toString();
                    var comment1 =
                        shipmentOrder![index].pickupComment1.toString();
                    var depatureimage =
                        shipmentOrder![index].departureImage.toString();
                    var depaturecomment =
                        shipmentOrder![index].departureComment.toString();
                    var arrivalimage =
                        shipmentOrder![index].arrivalImage.toString();
                    var arrivalcomment =
                        shipmentOrder![index].arrivalComment.toString();
                    var receptionistimage =
                        shipmentOrder![index].receptionistImage.toString();
                    var receptionistcomment =
                        shipmentOrder![index].receptionistComment.toString();

                    print(id);
                    print("Receptionist -------$receptionistimage");

                    print(type);
                    print(bookingdate);
                    print(status);
                    shipmentOrder![index].pickupReview[0].pickupType ==
                            "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxShipment(
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
                                    receptionistcomment))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxShipmentDropOff(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      height: 40,
                      width: MediaQuery.of(context).size.width * (15 / 100),
                      margin: EdgeInsets.only(right: 70),
                      child: Center(
                        child: Text(
                          shipmentOrder![index].status.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )),
                ),

                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(shipmentOrder![index].uid, "1"));
                    usersList
                        .add(ChatUsers(shipmentOrder![index].client.id, "1c"));
                    usersList.add(ChatUsers(
                        int.parse(shipmentOrder![index]
                            .schedule[0]
                            .departureWarehouse),
                        "3"));
                    usersList.add(ChatUsers(
                        int.parse(shipmentOrder![index]
                            .schedule[0]
                            .destinationWarehouse),
                        "4"));
                    usersList.add(
                        ChatUsers(shipmentOrder![index].receptionistId, "2r"));

                    var pickId = shipmentOrder![index].pickupagentId;
                    pickId != null ? usersList.add(ChatUsers(pickId, "5")) : '';

                    print("-=-= $chatListData");

                    int trendIndex = chatListData.indexWhere(
                        (f) => f['name'] == shipmentOrder![index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": shipmentOrder![index].title.toString(),
                      "firm_name": shipmentOrder![index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": shipmentOrder![index].scheduleId.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id": shipmentOrder![index].client.id, //other
                    };
                    print("-=-data11=- $data11");
                    print(
                        "-=-=-=shipmentOrder![index].client.id ${shipmentOrder![index].client.id}");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      height: 40,
                      width: MediaQuery.of(context).size.width * (10 / 100),
                      margin: EdgeInsets.only(right: 5),
                      child: Center(
                        child: Text(
                          "Chat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget MobileVieworderTemplate() {
    return ListView.builder(
        itemCount: shipmentOrder!.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * (38 / 100),
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
                          "Order ID",
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
                          shipmentOrder![index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * (40 / 100),
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: InkWell(
                        onTap: () {
                          var id = shipmentOrder![index].id.toString();
                          var type =
                              shipmentOrder![index].bookingType.toString();
                          var bookingdate =
                              shipmentOrder![index].bookingDate.toString();
                          var status = shipmentOrder![index].status.toString();
                          var itemimage =
                              shipmentOrder![index].pickupItemimage.toString();
                          var comment =
                              shipmentOrder![index].pickupComment.toString();
                          var itemimage1 =
                              shipmentOrder![index].pickupItemimage1.toString();
                          var comment1 =
                              shipmentOrder![index].pickupComment1.toString();
                          var depatureimage =
                              shipmentOrder![index].departureImage.toString();
                          var depaturecomment =
                              shipmentOrder![index].departureComment.toString();
                          var arrivalimage =
                              shipmentOrder![index].arrivalImage.toString();
                          var arrivalcomment =
                              shipmentOrder![index].arrivalComment.toString();
                          var receptionistimage = shipmentOrder![index]
                              .receptionistImage
                              .toString();
                          var receptionistcomment = shipmentOrder![index]
                              .receptionistComment
                              .toString();

                          print(id);
                          print("Receptionist -------$receptionistimage");

                          print(type);
                          print(bookingdate);
                          print(status);
                          shipmentOrder![index].pickupReview[0].pickupType ==
                                  "Pick up"
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialogBoxShipment(
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
                                          receptionistcomment))
                              : showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CustomDialogBoxShipmentDropOff(
                                          id,
                                          type,
                                          bookingdate,
                                          status,
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.green),
                            height: 40,
                            width:
                                MediaQuery.of(context).size.width * (14 / 100),
                            margin: EdgeInsets.only(right: 20),
                            padding: EdgeInsets.only(left: 10),
                            child: Center(
                              child: Text(
                                shipmentOrder![index].status.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                Container(
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
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          shipmentOrder![index].bookingDate.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Text("Schedule Title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text(shipmentOrder![index].title.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    var data11;
                    List<ChatUsers> usersList = [];
                    usersList.add(ChatUsers(shipmentOrder![index].uid, "1"));
                    usersList
                        .add(ChatUsers(shipmentOrder![index].client.id, "1c"));
                    usersList.add(ChatUsers(
                        int.parse(shipmentOrder![index]
                            .schedule[0]
                            .departureWarehouse),
                        "3"));
                    usersList.add(ChatUsers(
                        int.parse(shipmentOrder![index]
                            .schedule[0]
                            .destinationWarehouse),
                        "4"));
                    usersList.add(
                        ChatUsers(shipmentOrder![index].receptionistId, "2r"));

                    var pickId = shipmentOrder![index].pickupagentId;
                    pickId != null ? usersList.add(ChatUsers(pickId, "5")) : '';

                    print("-=-= $chatListData");

                    int trendIndex = chatListData.indexWhere(
                        (f) => f['name'] == shipmentOrder![index].id);
                    print("-=-=-trendIndex $trendIndex");
                    if (trendIndex != -1) {
                      roomId = chatListData[trendIndex]['id'];
                      print("-=-=- $usersList");
                      print("-=-roomId=- ${chatListData[trendIndex]['id']}");
                    }

                    data11 = {
                      "group_name": shipmentOrder![index].title.toString(),
                      "firm_name": shipmentOrder![index].title.toString(),
                      "chat_type": "group",
                      "room_id": roomId,
                      "userList": jsonEncode(usersList),
                      "user_id": UserId.toString(),
                      "sid": shipmentOrder![index].scheduleId.toString(),
                      'sender_type': userRole.toString(),
                      'receiver_type': '1c', //shipment
                      "sender_id": UserId.toString(), //me
                      "receiver_id": shipmentOrder![index].client.id, //other
                    };
                    print("-=-data11=- $data11");
                    print(
                        "-=-=-=shipmentOrder![index].client.id ${shipmentOrder![index].client.id}");
                    //return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatViewScreen(data11),
                        ));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
                      child: Center(
                        child: Text(
                          "Chat",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }

  Widget ContainerListDialog(
      {sid, stype, sto, sfrom, stitle, h, w, List<BookingItem>? bookingitem}) {
    return Container(
      margin: EdgeInsets.only(left: 40),
      height: h * 0.8,
      width: w * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: ListView(
        scrollDirection: Axis.vertical,
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
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                width: w * 0.15,
                child: Text(
                  "Order Id  :",
                  style: headingStyle16MB(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                width: w * 0.15,
                child: Text(
                  sid.toString(),
                  style: headingStyle16MB(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
          ),
          Row(
            children: [
              Container(
                width: w * 0.15,
                child: Text(
                  "Boat/ Place /Ship   :",
                  style: headingStyle16MB(),
                ),
              ),
              Container(
                width: w * 0.15,
                child: Text(
                  stype,
                  style: headingStyle16MB(),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Container(
                  width: w * 0.15,
                  child: Text(
                    "From   :",
                    style: headingStyle16MB(),
                  ),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(sfrom, style: headingStyle16MB()),
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
                  child: Text("To   :", style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(sto, style: headingStyle16MB()),
                )
              ],
            ),
          ),
          Container(
              // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
            color: Colors.black,
            thickness: 2,
            height: 36,
          )),
          Row(
            children: [
              Container(
                width: 200,
                height: 200,
                child: Text("Category   :", style: headingStyle16MB()),
              ),
              Container(
                height: h * 0.4,
                width: w * 0.65,
                margin: EdgeInsets.only(top: 20),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingitem!.length,
                    shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        childAspectRatio: 2 / 4),
                    itemBuilder: (context, index1) {
                      var jsondata = bookingitem[index1].itemName;
                      // print("-=--=-=-=$jsondata");
                      // print("-=--=-=-=${jsondata.length}");
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 500,
                          width: w * 0.4,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: w * 0.4,
                                    margin: EdgeInsets.only(
                                      top: 40,
                                      left: 5,
                                    ),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          bookingitem[index1]
                                                  .category
                                                  .toString() +
                                              ":",
                                          style: headingStyle16MB()),
                                    )),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 10),
                                  child: Column(
                                      children: List.generate(
                                    jsondata.length,
                                    (index) => Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          jsondata[index].itemname + ",",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 7, 10, 7),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              color: Color(0xffEFEFEF)),
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
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 3),
            height: 48,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, // set border color
                  width: 2.0), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  // searchfunction();
                },
                // controller: edit,
                decoration: InputDecoration(
                  // prefixIcon: IconButton(
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       searchfunction();
                  //     });

                  //   },
                  // ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   edit.clear();
                      //   searchDataresponse.removeLast();
                      //   // Widget build(BuildContext context)
                      //   // searchfunction();
                      //   MaterialPageRoute(
                      //       builder: (context) => bookingDesktopCard());
                      // });
                    },
                  ),
                  hintText: "Search Here",
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (val) {
                  // title = val;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
