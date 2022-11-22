import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Container_Details.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/arrivalDetails.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/arrivalInfo.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/arrivalcustomeralertdialog.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/ArrivalOrderManagement.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/clientInfo.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/orderlist.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ArrivalContainerList extends StatefulWidget {
  var data;
  ArrivalContainerList(this.data);

  @override
  _ArrivalContainerListState createState() => _ArrivalContainerListState();
}

class _ArrivalContainerListState extends State<ArrivalContainerList>
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print('>>>>>   $id');
    // clientbookingsApi();
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

  Widget container_client() {
    return Container(
      height: h,
      width: w * 0.80,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.asset(
                        "assets/images/Profile1.jpeg",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 55),
                            child: Text(
                              clientinfo![0].name,
                              style: headingStyle16blackw600(),
                            ),
                          ),
                          Text(
                            clientinfo![0].email,
                            style: headingStyle12blackw500(),
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
                    width: 250,
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
                            width: 100,
                            child: new Tab(
                              child: Text(
                                "Order Details",
                              ),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              "Info",
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
                width: w * 0.78,
                child: TabBarView(controller: tabController, children: [
                  Container(
                    child: OrderList(
                      Id: scheduleId.toString(),
                      cid: clientid.toString(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 7),
                    child: ClientInfo(id: id.toString()),
                  ),

                  // Container(
                  //   child: History(),
                  // )
                ]),
              ),
            ],
          )),
    );
  }

  Container Container_Client = Container(
      height: 507,
      width: 684,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xffFFFFFF).withOpacity(0.6),
          Color(0xffF3F3F3).withOpacity(0.36),
        ],
      )),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 82,
                width: 82,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Image.asset(
                  "assets/images/Profile1.jpeg",
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Text(
                          "Mark L. Guzman",
                          style: headingStyle16blackw600(),
                        ),
                      ),
                      Icon(Icons.more_horiz)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Product Manager at Deloitte Canada",
                      style: headingStyle12blackw500(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      "tim.jennings@example.com",
                      style: headingStyle12greyw400(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 110),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage(
                        "assets/images2/profile.png",
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: Text(
                            "Refer Info",
                            style: headingStyle12blackw500(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "tim.jennings@example.com",
                            style: headingStyle12greyw400(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 300,
                height: 50,
                child: DefaultTabController(
                  initialIndex: 1,
                  length: 3,
                  child: TabBar(
                    //  labelStyle: headingStyle16blackw600(),  //For Selected tab
                    //  unselectedLabelStyle: headingStyle14greyw500(), //For Un-selected Tabs
                    indicatorColor: Color(0xff1A494F),
                    tabs: <Widget>[
                      new Tab(
                        child: Text(
                          "Info",
                          style: headingStyle14tealw500(),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          "Order",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                      new Tab(
                        child: Text(
                          "History",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 7),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  "Credentials",
                  style: headingStyle16blackw600(),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Specialization",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 38),
                      child: Text(
                        "Location",
                        style: headingStyle14greyw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 27),
                      child: Text(
                        "Education",
                        style: headingStyle14greyw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 23),
                      child: Text(
                        "Languages",
                        style: headingStyle14greyw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 60),
                      child: Text(
                        "Years",
                        style: headingStyle14greyw500(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 75),
                      child: Text(
                        "Manager",
                        style: headingStyle14blackw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 40,
                        right: 20,
                      ),
                      child: Text(
                        "Toronto, Canada",
                        style: headingStyle14blackw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        "University of Denver",
                        style: headingStyle14blackw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 12),
                      child: Text(
                        "English, Japanese",
                        style: headingStyle14blackw500(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 125),
                      child: Text(
                        "12",
                        style: headingStyle14blackw500(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 1),
                          child: Text(
                            "Status",
                            style: headingStyle14greyw500(),
                          ),
                        ),
                        SizedBox(
                          width: 90,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 103),
                          child: Text(
                            "Active",
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 185),
                      child: Text(
                        "Credentials",
                        style: headingStyle16blackw600(),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 32),
                                child: Text(
                                  "Personal",
                                  style: headingStyle14greyw500(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, right: 57),
                                child: Text(
                                  "Work",
                                  style: headingStyle14greyw500(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 40, right: 0),
                                child: Text(
                                  "Work Address",
                                  style: headingStyle14greyw500(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 15),
                                child: Text(
                                  "MarklGuzman@rhyta.com\n(281) 660-1093",
                                  style: headingStyle14blackw500(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 25),
                                child: Text(
                                  "guzman.m@deloitte-c.com\n(281) 362-1093",
                                  style: headingStyle14blackw500(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 25),
                                child: Text(
                                  "1396 Margaret Street\nHouston, Tx 77026",
                                  style: headingStyle14blackw500(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ));

  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    var _currentIndex = 0;
    // print("dsnsdgs" + widget.data['id']);
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: ArrivalSidebar(),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffE5E5E5),
            child: SafeArea(
                right: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                            'Dashboard > Container',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    (Responsive.isDesktop(context)) ? 22 : 18,
                                fontWeight: FontWeight.bold),
                          ),
                          // Spacer(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 590,
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
                                  child: new Tab(
                                    child: Text(
                                      "Booking Details",
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: new Tab(
                                    child: Text(
                                      "Pickup / Dropoff Details",
                                    ),
                                  ),
                                ),
                                new Tab(
                                  child: Container(
                                    width: 200,
                                    child: Text(
                                      "Receptionist Info",
                                    ),
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
                    Container(
                      height: h * 0.78,
                      width:
                          (Responsive.isDesktop(context)) ? w * 0.78 : w * 0.9,
                      child: TabBarView(controller: tabController, children: [
                        (Responsive.isDesktop(context))
                            ? SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
                                  child: Column(children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.fromLTRB(15, 10, 50, 0),
                                      child: Text(
                                        'Schedule Title : ' +
                                            widget.data['title'].toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      // Spacer(),
                                    ),
                                    orderTemplate(),
                                    orderDetails(),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, top: 10),
                                      child: Divider(
                                        height: 30,
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                    ),
                                    Container(
                                        width: w * 0.75,
                                        height: h * 0.50,
                                        child: ListView.builder(
                                            itemCount: widget
                                                .data['itemimage1'].length,
                                            reverse: false,
                                            itemBuilder: (context, index) {
                                              var jsondata = widget
                                                  .data['itemimage1'][index]
                                                  .itemName;
                                              print("+++++++++++$jsondata");

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                                child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              child: widget
                                                                          .data[
                                                                              'itemimage1']
                                                                              [
                                                                              index]
                                                                          .itemImage
                                                                          .length !=
                                                                      0
                                                                  ? CarouselSlider(
                                                                      options:
                                                                          CarouselOptions(
                                                                        enableInfiniteScroll:
                                                                            false,
                                                                        autoPlay:
                                                                            true,
                                                                        onPageChanged:
                                                                            (index,
                                                                                reason) {
                                                                          setState(
                                                                              () {
                                                                            _currentIndex =
                                                                                index;
                                                                          });
                                                                          //print(_currentIndex);
                                                                        },
                                                                      ),
                                                                      items: widget
                                                                          .data[
                                                                              'itemimage1']
                                                                              [
                                                                              index]
                                                                          .itemImage
                                                                          .map<Widget>((item) =>
                                                                              InkWell(
                                                                                onTap: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (BuildContext context) {
                                                                                      return imageViewDialog(context, item, widget.data['itemimage1'][index]);
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(5.0),
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
                                                                      child:
                                                                          Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "No Image Available",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    )),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              height: 150,
                                                              width: 150,
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    kDefaultPadding /
                                                                        2),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child: Text(
                                                                      "Category : ",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            16,
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child: Text(
                                                                      widget
                                                                          .data[
                                                                              'itemimage1']
                                                                              [
                                                                              index]
                                                                          .category
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            14,
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        top:
                                                                            10),
                                                                    child: Text(
                                                                      "Item Name : ",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 5,
                                                                        top:
                                                                            10),
                                                                    child: Row(
                                                                        children:
                                                                            List.generate(
                                                                      jsondata
                                                                          .length,
                                                                      (index) =>
                                                                          Row(
                                                                              children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: Text(
                                                                                jsondata[index].itemname + ",",
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: Container(
                                                                                padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Color(0xffEFEFEF)),
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
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5),
                                                                    child: Text(
                                                                      "Description : ",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            12,
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
                                                                        const EdgeInsets
                                                                            .only(
                                                                      left: 5,
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          700,
                                                                      child:
                                                                          Align(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child: Text(
                                                                              widget.data['itemimage1'][index].description.toString(),
                                                                              style: TextStyle(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w500)
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
                                                                  ),
                                                                ]),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })),
                                  ]),
                                ),
                              )
                            : Container(
                                child: Column(children: [
                                  ListView.builder(
                                      itemCount: 1,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: h * 0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              (100 / 100),
                                          decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.circular(10.0),
                                            color: Color(0xffFFFFFF)
                                                .withOpacity(0.5),
                                          ),
                                          child: Scrollbar(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                            width: 80,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Text(
                                                              "ID",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Container(
                                                            width: 80,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 10),
                                                            child: Text(
                                                              widget.data['bid']
                                                                  .toString(),
                                                              //{widget.data['id']}.toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                    // Column(
                                                    //   children: [
                                                    //     Container(
                                                    //         margin:
                                                    //             EdgeInsets.only(
                                                    //                 top: 10),
                                                    //         width: 100,
                                                    //         // margin: EdgeInsets.only(right: 70),
                                                    //         child: Text(
                                                    //           "Booking Date",
                                                    //           style: TextStyle(
                                                    //               fontWeight:
                                                    //                   FontWeight
                                                    //                       .bold),
                                                    //         )),
                                                    //     Container(
                                                    //         margin:
                                                    //             EdgeInsets.only(
                                                    //                 top: 10),
                                                    //         width: 100,
                                                    //         child: Text(
                                                    //           widget
                                                    //               .data['bdate']
                                                    //               .toString(),
                                                    //           style: TextStyle(
                                                    //               fontWeight:
                                                    //                   FontWeight
                                                    //                       .bold,
                                                    //               fontSize: 12),
                                                    //         )),
                                                    //   ],
                                                    // ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 140,
                                                            // margin: EdgeInsets.only(right: 70),
                                                            child: Text(
                                                              "Departure Date",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 100,
                                                            child: Text(
                                                              widget
                                                                  .data['bdate']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 100,
                                                            child: Text(
                                                              "Arrival Date",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 100,
                                                            child: Text(
                                                              widget.data[
                                                                      'arrivaldate']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 100,
                                                            child: Text(
                                                              "Type",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 10,
                                                              left: 20,
                                                            ),
                                                            width: 100,
                                                            child: Text(
                                                              widget
                                                                  .data['type']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            width: 120,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 16,
                                                                    top: 10),
                                                            child: Text(
                                                              "Company",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        Container(
                                                            width: 120,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 16,
                                                                    top: 10),
                                                            child: Text(
                                                              widget.data[
                                                                      'company']
                                                                  .toString(),
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            )),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Container(
                                                            width: 60,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    top: 10),
                                                            child: Text(
                                                              "Action",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                        InkWell(
                                                          onTap: () {
                                                            var id = widget
                                                                .data['bid']
                                                                .toString();
                                                            var type = widget
                                                                .data['type']
                                                                .toString();
                                                            var bookingdate =
                                                                widget.data[
                                                                        'bdate']
                                                                    .toString();
                                                            var status = widget
                                                                .data['status']
                                                                .toString();
                                                            var itemimage = widget
                                                                .data[
                                                                    'pickupitemimage']
                                                                .toString();
                                                            var comment = widget
                                                                .data[
                                                                    'pickupcomment']
                                                                .toString();
                                                            var itemimage1 = widget
                                                                .data[
                                                                    'pickupitemimage1']
                                                                .toString();
                                                            var comment1 = widget
                                                                .data[
                                                                    'pickupcomment1']
                                                                .toString();
                                                            var depatureimage =
                                                                widget.data[
                                                                        'depatureimage']
                                                                    .toString();
                                                            var depaturecomment =
                                                                widget.data[
                                                                        'depaturecomment']
                                                                    .toString();
                                                            var arrivalimage =
                                                                widget.data[
                                                                        'arrivalimage']
                                                                    .toString();
                                                            var arrivalcomment =
                                                                widget.data[
                                                                        'arrivalcomment']
                                                                    .toString();

                                                            print(id);

                                                            print(type);
                                                            print(bookingdate);
                                                            print(status);
                                                            print(widget.data[
                                                                'pickuptype']);

                                                            widget.data['pickuptype'] ==
                                                                    "Pick up"
                                                                ? showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext context) => CustomDialogBoxx(
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
                                                                        arrivalcomment))
                                                                : showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext context) => CustomDialogBoxArrivalDropOff(
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
                                                                        arrivalcomment));
                                                          },
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right: 10,
                                                                      top: 10),
                                                              height: 40,
                                                              width: 130,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                              // width:
                                                              child: Center(
                                                                child: Text(
                                                                  "View Path",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Divider(
                                      height: 30,
                                      color: Colors.black,
                                      thickness: 2,
                                    ),
                                  ),
                                  Container(
                                      width: w * 1.0,
                                      height: h * 0.50,
                                      child: ListView.builder(
                                          itemCount:
                                              widget.data['itemimage1'].length,
                                          reverse: false,
                                          itemBuilder: (context, index) {
                                            var jsondata = widget
                                                .data['itemimage1'][index]
                                                .itemName;
                                            print("+++++++++++$jsondata");

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 8),
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        child: widget
                                                                    .data[
                                                                        'itemimage1']
                                                                        [index]
                                                                    .itemImage
                                                                    .length !=
                                                                0
                                                            ? CarouselSlider(
                                                                options:
                                                                    CarouselOptions(
                                                                  enableInfiniteScroll:
                                                                      false,
                                                                  autoPlay:
                                                                      true,
                                                                  onPageChanged:
                                                                      (index,
                                                                          reason) {
                                                                    setState(
                                                                        () {
                                                                      _currentIndex =
                                                                          index;
                                                                    });
                                                                    //print(_currentIndex);
                                                                  },
                                                                ),
                                                                items: widget
                                                                    .data[
                                                                        'itemimage1']
                                                                        [index]
                                                                    .itemImage
                                                                    .map<Widget>(
                                                                        (item) =>
                                                                            InkWell(
                                                                              onTap: () {
                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return imageViewDialog(context, item, widget.data['itemimage1'][index]);
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(5.0),
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
                                                                child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Text(
                                                                  "No Image Available",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        height: 150,
                                                        width: 150,
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              kDefaultPadding /
                                                                  2),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "Category : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                                // style: Theme.of(context)
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Text(
                                                                widget
                                                                    .data[
                                                                        'itemimage1']
                                                                        [index]
                                                                    .category
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      top: 10),
                                                              child: Text(
                                                                "Item Name : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5,
                                                                      top: 10),
                                                              child: Container(
                                                                height: 40,
                                                                width: w * 0.4,
                                                                child:
                                                                    Scrollbar(
                                                                  isAlwaysShown:
                                                                      true,
                                                                  child: ListView(
                                                                      addRepaintBoundaries: true,
                                                                      scrollDirection: Axis.horizontal,
                                                                      children: List.generate(
                                                                        jsondata
                                                                            .length,
                                                                        (index) =>
                                                                            Row(
                                                                                children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Text(
                                                                                  jsondata[index].itemname + ",",
                                                                                  style: TextStyle(
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Color(0xffEFEFEF)),
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
                                                              ),
                                                            ),
                                                          ]),
                                                          Row(children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "Description : ",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              child: Container(
                                                                height:
                                                                    h * 0.19,
                                                                width: w * 0.3,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child: Text(
                                                                        widget
                                                                            .data['itemimage1'][
                                                                                index]
                                                                            .description
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w500)
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
                                                            ),
                                                          ]),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          })),
                                ]),
                              ),
                        Container(
                          child: ArrivalDetails(data),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 7),
                          child: ArrivalReceptionistInfo(data),
                        ),
                      ]),
                    ),
                  ]),
                ))),
      ),
    );
  }

  Widget containerList() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: data1!.length,
        //  widget.bId.length,
        shrinkWrap: true,
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
                                padding: const EdgeInsets.only(left: 50),
                                child: Text(
                                  data1![index].client[l].name,
                                  style: headingStyle16blacknormal(),
                                ),
                              ),
                            // for (int k = 0; k < data1![index].item.length; k++)
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                data1![index].id.toString(),
                                style: headingStyle16blacknormal(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                data1![index].bookingDate.toString(),
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
                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin: EdgeInsets.only(
                                                  left: 100,
                                                  // top: 250,
                                                  top: 80),
                                              child: AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: container_client(),
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
                              padding:
                                  const EdgeInsets.only(left: 80, right: 20),
                              child: Container(
                                height: 22,
                                width: 86,
                                color: Color(0xffFF3D00),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    data1![index].status.toString(),
                                    style: headingStyle12whitew500(),
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
    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
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
                        onPressed: () {},
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
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
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
                      widget.data['bid'].toString(),
                      //{widget.data['id']}.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.data['bdate'].toString(),
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
                      widget.data['company'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                InkWell(
                  onTap: () {
                    var id = widget.data['bid'].toString();
                    var type = widget.data['type'].toString();
                    var bookingdate = widget.data['bdate'].toString();
                    var status = widget.data['status'].toString();
                    var itemimage = widget.data['pickupitemimage'].toString();
                    var comment = widget.data['pickupcomment'].toString();
                    var itemimage1 = widget.data['pickupitemimage1'].toString();
                    var comment1 = widget.data['pickupcomment1'].toString();
                    var depatureimage = widget.data['depatureimage'].toString();
                    var depaturecomment =
                        widget.data['depaturecomment'].toString();
                    var arrivalimage = widget.data['arrivalimage'].toString();
                    var arrivalcomment =
                        widget.data['arrivalcomment'].toString();

                    print(id);

                    print(type);
                    print(bookingdate);
                    print(status);
                    print(widget.data['pickuptype']);

                    widget.data['pickuptype'] == "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogBoxx(
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
                                arrivalcomment))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxArrivalDropOff(
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
                                    arrivalcomment));
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      child: Center(
                        child: Text(
                          "View Path",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      )),
                ),
              ],
            ),
          );
        });
  }
}
