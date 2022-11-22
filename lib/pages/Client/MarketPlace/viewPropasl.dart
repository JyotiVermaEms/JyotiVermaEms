import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/marketPlace_requirement.dart';
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/proposal_details.dart';
import 'package:shipment/pages/Pickup%20Agent/Dashboard/pickupDetails.dart';
import 'package:shipment/pages/Pickup%20Agent/Dashboard/receptionistInfo.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ViewProposalScreen extends StatefulWidget {
  var data;
  ViewProposalScreen(this.data);

  @override
  _ViewProposalScreen createState() => _ViewProposalScreen();
}

class _ViewProposalScreen extends State<ViewProposalScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? tabController;
  var data;

  int _selectedIndex = 1;
  var h, w;
  var shipmentname2;
  Color CardColor = Color(0xffF7F6FB);
  var Iamhovering = -1;

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
 

  @override
  void initState() {
    super.initState();
   

    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController!.addListener(() {
      setState(() {
        _selectedIndex = tabController!.index;
      });
      // print("Selected Index: " + tabController!.index.toString());
    });
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
                            'Proposal',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
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
                                  child: new Tab(
                                    child: Text(
                                      "Proposal Detail",
                                    ),
                                  ),
                                ),
                                new Tab(
                                  child: Container(
                                    width: 200,
                                    child: Text(
                                      "Market Place Requirment",
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
                      width: w * 0.78,
                      child: TabBarView(controller: tabController, children: [
                        Container(
                          child: ViewProposal(data),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 7),
                          child: MarketPlaceRequirement(data),
                        ),
                      ]),
                    ),
                  ]),
                ))),
      ),
    );
  }

  Widget containerList() {
    return Container(
        margin: EdgeInsets.all(30),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10.0), color: Color(0xffFFFFFF)),

        // width: MediaQuery.of(context).size.width * (80 / 100),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Id",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_estimate",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Booking_date",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "arrival_date",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "shipment_company",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_type",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_location",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_date",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_time",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickup_distance",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "pickupagent_id",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "transaction_id",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "total_amount",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "card_type",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Divider(
                  height: 30,
                  color: Colors.black,
                  thickness: 2,
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10, left: 10, top: 10),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Receptionist Information",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Name",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Email",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Phone",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                  Container(
                    width: 120,
                    margin: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      "Address",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF)),
                      margin: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Center(
                          child: Text("First Name",
                              style: TextStyle(fontSize: 14)))),
                ],
              ),
            ]));
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
