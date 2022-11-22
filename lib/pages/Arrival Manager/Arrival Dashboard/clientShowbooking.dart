import 'package:flutter/material.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Shipment/ShipmentOrderModel.dart';
import 'package:shipment/Model/Shipment/broadCastMessageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Dashboard.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';

import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/pages/Client/Booking/clientBookingContainerList.dart';

import '../../../component/Arrival Manager/ContainerList.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ArrivalClientBookingShow extends StatefulWidget {
  var bookingdata;
  ArrivalClientBookingShow(this.bookingdata);

  @override
  _ArrivalClientBookingShow createState() => _ArrivalClientBookingShow();
}

class _ArrivalClientBookingShow extends State<ArrivalClientBookingShow>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var index1;
  var clientname;
  String? bookingid,
      bookingdate,
      status1,
      title1,
      type,
      from1,
      to1,
      orderId,
      pickuptype,
      pickupAgentId;

  int? Id;
  List<ShipmentOrder> shipmentOrder = [];
  // var bookingid=[];
  var id1 = [];
  var pickuplocation;
  late TabController tabController;

//========get messages data
  List<GetBroadcastData>? messagesData = [];
  getAllBroadcastMSGApi() async {
    print("-=-in getAllBroadcastMSGApi ${widget.bookingdata['id']}");
    // return;
    var data = {"schedule_id": widget.bookingdata['id'].toString()};

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
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    getAllBroadcastMSGApi();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: ArrivalSidebar(),
        ),
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: ListView(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                      (Responsive.isDesktop(context))
                          ? Container(
                              margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                              child: Text(
                                'Booking Details',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.fromLTRB(5, 10, 10, 0),
                              child: Text(
                                'Booking Details',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      (Responsive.isDesktop(context))
                          ? InkWell(
                              onTap: () {
                                print(widget.bookingdata['shipmentStatus']);
                                widget.bookingdata['shipmentStatus'] ==
                                        "inprogress"
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Are you sure you want to Close this schedule?"),
                                            actions: [
                                              InkWell(
                                                child: Text("No          "),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              InkWell(
                                                child: Text("        Yes "),
                                                onTap: () async {
                                                  var arrivalData = {
                                                    "booking_id": widget
                                                        .bookingdata[
                                                            'bookinglength'][0]
                                                        .id
                                                        .toString(),
                                                    "booking_status": "",
                                                    "schedule_status": "Closed",
                                                    "pickup_itemimage": '',
                                                  };

                                                  print(arrivalData);
                                                  print(widget.bookingdata);
                                                  print(widget.bookingdata[
                                                      'shipmentStatus']);

                                                  //return;

                                                  var response =
                                                      await Providers()
                                                          .changeArrivalStatus(
                                                              arrivalData);
                                                  if (response.status == true) {
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        content: Text(
                                                            response.message),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PreArrivalDashboard()));
                                                            },
                                                            child: const Text(
                                                                'OK'),
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
                                      )
                                    : null;
                              },
                              child: Container(
                                  width: w * 0.11,
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  // width:
                                  //     MediaQuery.of(context).size.width * (12 / 100),
                                  height: 40,
                                  margin: EdgeInsets.only(right: 20),
                                  child: Center(
                                    child: Text(
                                      widget.bookingdata['shipmentStatus']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                            )
                          : InkWell(
                              onTap: () {
                                print(widget.bookingdata['shipmentStatus']);
                                widget.bookingdata['shipmentStatus'] ==
                                        "inprogress"
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                                "Are you sure you want to Close this schedule?"),
                                            actions: [
                                              InkWell(
                                                child: Text("No          "),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              InkWell(
                                                child: Text("        Yes "),
                                                onTap: () async {
                                                  var arrivalData = {
                                                    "booking_id": widget
                                                        .bookingdata[
                                                            'bookinglength'][0]
                                                        .id
                                                        .toString(),
                                                    "booking_status": "",
                                                    "schedule_status": "Closed",
                                                    "pickup_itemimage": '',
                                                  };

                                                  print(arrivalData);
                                                  print(widget.bookingdata);
                                                  print(widget.bookingdata[
                                                      'shipmentStatus']);

                                                  //return;

                                                  var response =
                                                      await Providers()
                                                          .changeArrivalStatus(
                                                              arrivalData);
                                                  if (response.status == true) {
                                                    setState(() {
                                                      Navigator.pop(context);
                                                    });
                                                    showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        content: Text(
                                                            response.message),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PreArrivalDashboard()));
                                                            },
                                                            child: const Text(
                                                                'OK'),
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
                                      )
                                    : null;
                              },
                              child: Container(
                                  width: w * 0.20,
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  // width:
                                  //     MediaQuery.of(context).size.width * (12 / 100),
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      widget.bookingdata['shipmentStatus']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.white),
                                    ),
                                  )),
                            )
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
                                        "Bookings",
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      width: 200,
                                      child: Text(
                                        "Broadcast Messages",
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
                        child: TabBarView(controller: tabController, children: [
                          SingleChildScrollView(
                              child: Column(
                            children: [
                              orderTemplate(),
                              orderDetails(),
                            ],
                          )),
                          messagesData!.isEmpty
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
                              : broadCastMessagesList(messagesData),
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
                                        "Bookings",
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      width: 200,
                                      child: Text(
                                        "Broadcast Messages",
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
                        child: TabBarView(controller: tabController, children: [
                          mobileorderDetails(),
                          messagesData!.isEmpty
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
                              : mobilebroadCastMessagesList(messagesData),
                        ]),
                      ),
                    ],
                  ),
              ])),
        ));
  }

  Widget mobileorderDetails() {
    print(">>>>>>>>>>>>>>>>>>");
    return ListView.builder(
        itemCount: widget.bookingdata['bookinglength'].length,
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            width: w,
            margin: EdgeInsets.all(10),
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
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          "Booking ID",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        child: Text(
                          "Departure Date",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          (widget.bookingdata['bookinglength'])[index]
                              .id
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                            (widget.bookingdata['bookinglength'])[index]
                                .bookingDate
                                .toString(),
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
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Arrival Date",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text("Title",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          (widget.bookingdata['bookinglength'])[index]
                              .arrivalDate
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                            (widget.bookingdata['bookinglength'])[index]
                                .title
                                .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
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
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Type",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text("Company",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          (widget.bookingdata['bookinglength'])[index]
                              .bookingType
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (30 / 100),
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          (widget.bookingdata['bookinglength'])[index]
                              .shipmentCompany
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    for (int i = 0;
                        i < widget.bookingdata['bookinglength'].length;
                        i++) {
                      // print(
                      //     ">>>>>>>>>>>>>>>>>>>>>>>>>>${widget.bookingdata['bookinglength'][i].pickupReview[0].pickupLocation.toString()}");
                      var pickuplocation = widget
                          .bookingdata['bookinglength'][i]
                          .pickupReview[0]
                          .pickupLocation
                          .toString();
                    }
                    var data = {
                      'name': widget.bookingdata['bookinglength'][index]
                          .receptionistInfo[0].receptionistName
                          .toString(),
                      'email': widget.bookingdata['bookinglength'][index]
                          .receptionistInfo[0].receptionistEmail
                          .toString(),
                      'phone': widget.bookingdata['bookinglength'][index]
                          .receptionistInfo[0].receptionistPhone
                          .toString(),
                      'address': widget.bookingdata['bookinglength'][index]
                          .receptionistInfo[0].receptionistAddress
                          .toString(),
                      'country': widget.bookingdata['bookinglength'][index]
                          .receptionistInfo[0].receptionistCountry
                          .toString(),
                      // 'itemimage1': widget
                      //     .bookingdata['bookinglength'][index].itemImage,

                      'itemimage1':
                          widget.bookingdata['bookinglength'][index].booking,

                      'pickupitemimage': widget
                          .bookingdata['bookinglength'][index].pickupItemimage
                          .toString(),
                      'pickupcomment': widget
                          .bookingdata['bookinglength'][index].pickupComment
                          .toString(),
                      'pickupitemimage1': widget
                          .bookingdata['bookinglength'][index].pickupItemimage1
                          .toString(),
                      'pickupcomment1': widget
                          .bookingdata['bookinglength'][index].pickupComment1
                          .toString(),
                      'depatureimage': widget
                          .bookingdata['bookinglength'][index].departureImage
                          .toString(),
                      'depaturecomment': widget
                          .bookingdata['bookinglength'][index].departureComment
                          .toString(),
                      'transactionid': widget
                          .bookingdata['bookinglength'][index].transactionId
                          .toString(),
                      'pickupestimate': widget
                          .bookingdata['bookinglength'][index]
                          .pickupReview[0]
                          .pickupEstimate
                          .toString(),
                      'pickupdistance': widget
                          .bookingdata['bookinglength'][index]
                          .pickupReview[0]
                          .pickupDistance
                          .toString(),
                      'pickuptime': widget.bookingdata['bookinglength'][index]
                          .pickupReview[0].pickupTime
                          .toString(),
                      'pickuptype': widget.bookingdata['bookinglength'][index]
                          .pickupReview[0].pickupType
                          .toString(),
                      'pickupdate': widget.bookingdata['bookinglength'][index]
                          .pickupReview[0].pickupDate
                          .toString(),
                      'pickuplocation': widget
                          .bookingdata['bookinglength'][index]
                          .pickupReview[0]
                          .pickupLocation
                          .toString(),
                      'totalamount': widget
                          .bookingdata['bookinglength'][index].totalAmount
                          .toString(),

                      'depaturedate': widget.bookingdata['depaturedate'],
                      'bid': widget.bookingdata['bookinglength'][index].id,
                      'bdate': widget
                          .bookingdata['bookinglength'][index].bookingDate,
                      'arrivaldate': widget
                          .bookingdata['bookinglength'][index].arrivalDate,
                      // 'depaturedate': widget
                      //     .bookingdata['bookinglength'][index].departureDate,
                      'title': widget.bookingdata['bookinglength'][index].title,
                      'company': widget
                          .bookingdata['bookinglength'][index].shipmentCompany,
                      'type': widget
                          .bookingdata['bookinglength'][index].bookingType,
                      'status': widget
                          .bookingdata['bookinglength'][index].status
                          .toString(),
                      'pid': widget.bookingdata['pickupagent_id'],
                    };
                    print(">>>>>>>>>>>>>" +
                        widget.bookingdata['bookinglength'][index].id
                            .toString());
                    // var data = widget.bookingdata;
                    print("jyioigjkkfkkgjkfj" +
                        data['depaturecomment'].toString());
                    print("jyioigjkkfkkgjkfj" +
                        data['depatureitemimage'].toString());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContainerList(data)),
                    );
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
                          right: 10, left: 10, bottom: 20, top: 20),
                      child: Center(
                        child: Text(
                          "View Details",
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

  Widget orderTemplate() {
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
                width: w * 0.05,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Booking ID",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),

            Container(
                width: w * 0.08,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                child: Text(
                  "Departure Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.07,
                child: Text(
                  "Arrival Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // Spacer(),
            Container(
                width: w * 0.03,
                margin: EdgeInsets.only(right: 40),
                child: Text(
                  "Title",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
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
          ],
        ),
      ),
    );
  }

  Widget orderDetails() {
    print(">>>>>>>>>>>>>>>>>>");
    return ListView.builder(
        itemCount: widget.bookingdata['bookinglength'].length,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
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
                        (widget.bookingdata['bookinglength'])[index]
                            .id
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: w * 0.08,
                      child: Text(
                        (widget.bookingdata['bookinglength'])[index]
                            .bookingDate
                            .toString(),
                        // widget.bookingdata['bookinglength'][index].bookingdate
                        //     .toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                    width: w * 0.07,
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
                                // margin: EdgeInsets.only(
                                //     left: 100,
                                //     // top: 250,
                                //     top: 190),
                                child: AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: ContainerListDialog(
                                      stitle: shipmentOrder[index].title,
                                      sid: shipmentOrder[index].id,
                                      stype: shipmentOrder[index].bookingType,
                                      sto: shipmentOrder[index].to,
                                      sfrom: shipmentOrder[index].from,
                                      bookingitem:
                                          shipmentOrder[index].bookingItem,
                                      h: h,
                                      w: w),
                                ),
                              );
                            });
                      },
                      child: Text(
                        (widget.bookingdata['bookinglength'])[index]
                            .arrivalDate
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A494F)),
                      ),
                    ),
                  ),
                  Container(
                      width: w * 0.06,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      child: Center(
                        child: Text(
                          (widget.bookingdata['bookinglength'])[index]
                              .title
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),
                  Container(
                      width: w * 0.05,
                      child: Text(
                        (widget.bookingdata['bookinglength'])[index]
                            .bookingType
                            .toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: w * 0.06,
                      child: Text(
                        (widget.bookingdata['bookinglength'])[index]
                            .shipmentCompany
                            .toString(),

                        // widget.bookingdata['shipcmpany'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  GestureDetector(
                    onTap: () {
                      for (int i = 0;
                          i < widget.bookingdata['bookinglength'].length;
                          i++) {
                        var pickuplocation = widget
                            .bookingdata['bookinglength'][i]
                            .pickupReview[0]
                            .pickupLocation
                            .toString();
                      }
                      var data = {
                        'name': widget.bookingdata['bookinglength'][index]
                            .receptionistInfo[0].receptionistName
                            .toString(),
                        'email': widget.bookingdata['bookinglength'][index]
                            .receptionistInfo[0].receptionistEmail
                            .toString(),
                        'phone': widget.bookingdata['bookinglength'][index]
                            .receptionistInfo[0].receptionistPhone
                            .toString(),
                        'address': widget.bookingdata['bookinglength'][index]
                            .receptionistInfo[0].receptionistAddress
                            .toString(),
                        'country': widget.bookingdata['bookinglength'][index]
                            .receptionistInfo[0].receptionistCountry
                            .toString(),
                        // 'itemimage1': widget
                        //     .bookingdata['bookinglength'][index].itemImage,

                        'itemimage1':
                            widget.bookingdata['bookinglength'][index].booking,
                        'itemimage1':
                            widget.bookingdata['bookinglength'][index].booking,

                        'pickupitemimage': widget
                            .bookingdata['bookinglength'][index].pickupItemimage
                            .toString(),
                        'pickupcomment': widget
                            .bookingdata['bookinglength'][index].pickupComment
                            .toString(),
                        'pickupitemimage1': widget
                            .bookingdata['bookinglength'][index]
                            .pickupItemimage1
                            .toString(),
                        'pickupcomment1': widget
                            .bookingdata['bookinglength'][index].pickupComment1
                            .toString(),
                        'depatureimage': widget
                            .bookingdata['bookinglength'][index].departureImage
                            .toString(),
                        'depaturecomment': widget
                            .bookingdata['bookinglength'][index]
                            .departureComment
                            .toString(),
                        'arrivalimage': widget
                            .bookingdata['bookinglength'][index].arrivalImage
                            .toString(),
                        'arrivalcomment': widget
                            .bookingdata['bookinglength'][index].arrivalComment
                            .toString(),
                        'transactionid': widget
                            .bookingdata['bookinglength'][index].transactionId
                            .toString(),
                        'pickupestimate': widget
                            .bookingdata['bookinglength'][index]
                            .pickupReview[0]
                            .pickupEstimate
                            .toString(),
                        'pickupdistance': widget
                            .bookingdata['bookinglength'][index]
                            .pickupReview[0]
                            .pickupDistance
                            .toString(),
                        'pickuptime': widget.bookingdata['bookinglength'][index]
                            .pickupReview[0].pickupTime
                            .toString(),
                        'pickuptype': widget.bookingdata['bookinglength'][index]
                            .pickupReview[0].pickupType
                            .toString(),
                        'pickupdate': widget.bookingdata['bookinglength'][index]
                            .pickupReview[0].pickupDate
                            .toString(),
                        'pickuplocation': widget
                            .bookingdata['bookinglength'][index]
                            .pickupReview[0]
                            .pickupLocation
                            .toString(),
                        'totalamount': widget
                            .bookingdata['bookinglength'][index].totalAmount
                            .toString(),

                        'depaturedate': widget.bookingdata['depaturedate'],
                        'bid': widget.bookingdata['bookinglength'][index].id,
                        'bdate': widget
                            .bookingdata['bookinglength'][index].bookingDate,
                        'arrivaldate': widget
                            .bookingdata['bookinglength'][index].arrivalDate,
                        // 'depaturedate': widget
                        //     .bookingdata['bookinglength'][index].departureDate,
                        'title':
                            widget.bookingdata['bookinglength'][index].title,
                        'company': widget.bookingdata['bookinglength'][index]
                            .shipmentCompany,
                        'type': widget
                            .bookingdata['bookinglength'][index].bookingType,
                        'status':
                            widget.bookingdata['bookinglength'][index].status,
                      };
                      print(">>>>>>>>>>>>>" +
                          widget.bookingdata['bookinglength'][index].id
                              .toString());
                      // var data = widget.bookingdata;
                      print("jyioigjkkfkkgjkfj" + data.toString());

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ContainerList(data)),
                      );
                    },
                    child: Container(
                        width: w * 0.11,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        height: 40,
                        margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            "View Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget MobileVieworderTemplate() {
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
                          "123456 ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Waiting Pickup",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red))),
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
                          "21.08.2021",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Boat",
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
                          "APM-Maersk.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("USA",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("India",
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

  Widget MobileVieworderTemplate2() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
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
                          "123456 ",
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
                        //         CustomDialogBox());
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
                              "Deliverd",
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
                          "21.08.2021",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("Boat",
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
                          "APM-Maersk.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("USA",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                    Container(
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("India",
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
      {sid, stype, sto, sfrom, stitle, h, w, List<BookingItem>? bookingitem}) {
    return Container(
      height: h * 0.35,
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
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                sid.toString(),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            // child: Row(
            //   children: [
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         "Title",
            //         style: headingStyle16MB(),
            //       ),
            //     ),
            //     Container(
            //       width: w * 0.15,
            //       child: Text(
            //         stitle,
            //         style: headingStyle16MB(),
            //       ),
            //     )
            //   ],
            // ),
          ),
          Row(
            children: [
              Container(
                width: w * 0.15,
                child: Text(
                  "Boat/ Place /Ship",
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
                    "From",
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
                  child: Text("To", style: headingStyle16MB()),
                ),
                Container(
                  width: w * 0.10,
                  child: Text(sto, style: headingStyle16MB()),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: Row(
          //     children: [
          //       Container(
          //         width: w * 0.15,
          //         child: Text("Items", style: headingStyle16MB()),
          //       ),
          //       Container(
          //         width: w,
          //         child: GridView.builder(
          //             physics: NeverScrollableScrollPhysics(),
          //             itemCount: bookingitem!.length,
          //             shrinkWrap: true,
          //             // scrollDirection: Axis.horizontal,
          //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 2,
          //               mainAxisSpacing: 0.01,
          //               crossAxisSpacing: 0.01,
          //               // childAspectRatio: 0.1
          //             ),
          //             itemBuilder: (context, index1) {
          //               return Align(
          //                 alignment: Alignment.topLeft,
          //                 child: Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     children: [
          //                       Container(
          //                           margin: EdgeInsets.only(left: 5, top: 10),
          //                           child: Text(bookingitem[index1]
          //                               .category
          //                               .toString())),
          //                       Container(
          //                           height: 40,
          //                           width: 40,
          //                           margin: EdgeInsets.only(left: 10, top: 10),
          //                           decoration: BoxDecoration(
          //                               borderRadius:
          //                                   BorderRadius.circular(50.0),
          //                               color: Color(0xffEFEFEF)),
          //                           child: Center(
          //                               child: Text(bookingitem[index1]
          //                                   .quantity
          //                                   .toString()))),
          //                     ]),
          //               );
          //             }),
          //       ),
          //     ],
          //   ),
          // ),
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
        // Padding(
        //   padding: const EdgeInsets.only(left: 20),
        //   child: SizedBox(
        //     width: (Responsive.isDesktop(context))
        //         ? 136
        //         : MediaQuery.of(context).size.width * (40 / 100),
        //     height: 48,
        //     child: ElevatedButton(
        //       onPressed: () {},
        //       style: ButtonStyle(
        //           backgroundColor: MaterialStateProperty.all(Colors.white),
        //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //               RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10.0),
        //                   side: BorderSide(color: Colors.teal, width: 2.0)))),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Text(
        //             '21.08.2021',
        //             style: headingStyle12blacknormal(),
        //           ),
        //           Container(
        //             // margin: EdgeInsets.only(left: 45, top: 5),
        //             height: 20,
        //             width: 20,
        //             child: ImageIcon(
        //               AssetImage(
        //                 "images/menu-board.png",
        //               ),
        //               size: 20,
        //               color: Colors.black,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
