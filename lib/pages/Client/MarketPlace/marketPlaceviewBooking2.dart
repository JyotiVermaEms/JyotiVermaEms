// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/getViewRecepinstModel.dart';
import 'package:shipment/Model/Client/viewMarketPlaceBooking.dart';
import 'package:shipment/Model/Client/viewProposalModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/re_proposalScreen.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/helper/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class viewMarketPlaceBooking2 extends StatefulWidget {
  var data;
  viewMarketPlaceBooking2(this.data);

  @override
  _viewMarketPlaceBookingState2 createState() =>
      _viewMarketPlaceBookingState2();
}

class _viewMarketPlaceBookingState2 extends State<viewMarketPlaceBooking2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var id1;
  var mkid;

  var index;
  var companyname;
  var statusCheck;
  List<ViewProposalData> viewproposalData = [];

  final TextEditingController _name = TextEditingController();
  var receptionistId = 0;

  getProposalDetails() async {
    var response = await Providers().getViewProposal();

    if (response.status == true) {
      for (int i = 0; i < response.data.length; i++) {
        setState(() {
          viewproposalData = response.data;
        });
      }
    }
  }

  List<UserData> clientEplyData = [];

  var item123 = [];
  var listData = [];

  Future getUsers() async {
    var response = await Providers().getViewReceptionist();
    if (response.status == true) {
      //setState(() {
      clientEplyData = response.data;
      // listData = response.data;
      // });
      for (int i = 0; i < clientEplyData.length; i++) {
        listData
            .add({"id": clientEplyData[i].id, "name": clientEplyData[i].name});
        // item123.add({"name": clientEplyData[i].name},
        //     {"id": clientEplyData[i].id}, {"key": false});
        item123.add(clientEplyData[i].id);
      }
      setState(() {});
    }
    print(">>>>>>>clientEplyData>>>>>>>>>>>>> $item123");
    print(listData);
  }

  @override
  void initState() {
    super.initState();
    // showMarketplaceBooking();
    print(">>>>>>>>>>>>" + widget.data['marketplaceid'].toString());
    print("siddddd>>" + widget.data['sid'].toString());
    mkid = widget.data['marketplaceid'];
    print(">>>>>>>>>>>>" + mkid.toString());
    getUsers();
    getProposalDetails();
  }

  @override
  Widget build(BuildContext context) {
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
              child: ListView(children: [
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
                      // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                        child: Text(
                          'marketplacebooking'.tr(),
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
                  viewproposalData.length == 0
                      ? Container(
                          height: 200,
                          width: double.infinity,
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
                                  // Image.asset(
                                  //   'assets/images/applogo.png',
                                  //   height:
                                  //       MediaQuery.of(context).size.height * 0.10,
                                  // ),
                                  SizedBox(height: 15),
                                  Text(
                                    'sorryouhavenotcreate'.tr(),
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
                if (!Responsive.isDesktop(context))
                  Column(
                    children: [
                      mobileVieworderTemplate(),
                      // MobileVieworderTemplate2(),
                    ],
                  ),
              ])),
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
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Proposal ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Company ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (20 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Proposal Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              width: MediaQuery.of(context).size.width * (20 / 100),
              child: Text(
                "Company Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (10 / 100),
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
        itemCount: viewproposalData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          log("MMMMMMM ${int.parse(viewproposalData[index].shippingPrice!) + int.parse(viewproposalData[index].pickupfee!) + int.parse(viewproposalData[index].tax!)}");
          return mkid.toString() == viewproposalData[index].mid.toString()
              ? Container(
                  // height: (!Responsive.isDesktop(context))
                  //     ? MediaQuery.of(context).size.height * (10 / 100)
                  //     : MediaQuery.of(context).size.height * (45 / 100),
                  height: 120,

                  // width: MediaQuery.of(context).size.width * (80 / 100),
                  width: w * 0.90,

                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width:
                                MediaQuery.of(context).size.width * (10 / 100),
                            margin: EdgeInsets.only(left: 25),
                            child: Text(
                              viewproposalData[index].id.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        Container(
                            width:
                                MediaQuery.of(context).size.width * (10 / 100),
                            margin: EdgeInsets.only(left: 25),
                            child: Text(
                              viewproposalData[index].sid.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Spacer(),
                        Container(
                            width:
                                MediaQuery.of(context).size.width * (20 / 100),

                            // margin: EdgeInsets.only(left: 20),
                            child: Text(
                              viewproposalData[index]
                                  .createdAt
                                  .substring(0, 10),
                              // (DateFormat.yMd()
                              //     .format(DateTime.parse(
                              //         marketplaceData[index].createdAt))
                              //     .toString()),
                              // marketplaceData[index].createdAt.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),

                        Container(
                          width: MediaQuery.of(context).size.width * (18 / 100),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              viewproposalData[index]
                                  .shipment[0]
                                  .companyname
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A494F)),
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            InkWell(
                              onTap:
                                  viewproposalData[index].market[0].status ==
                                          "created"
                                      ? () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var budgetAmount = '0';
                                              return AlertDialog(
                                                title: Text("Confirm"),
                                                content: Text(
                                                    "Are you sure you want to accept proposal?"),
                                                actions: [
                                                  InkWell(
                                                    child: Text("No          "),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  InkWell(
                                                    child: Text("        Yes "),
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              setState) {
                                                            print(
                                                                "clientEplyData-=- $clientEplyData");
                                                            budgetAmount =
                                                                viewproposalData[
                                                                        index]
                                                                    .shippingPrice!;

                                                            return AlertDialog(
                                                              scrollable: true,
                                                              title: Wrap(
                                                                  direction: Axis
                                                                      .vertical,
                                                                  children: [
                                                                    Text(
                                                                      "Assign Receptionist",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                    ),
                                                                    Text(
                                                                        "Bid amount : \$${int.parse(viewproposalData[index].shippingPrice!) + int.parse(viewproposalData[index].pickupfee!) + int.parse(viewproposalData[index].tax!)}")
                                                                  ]),
                                                              content:
                                                                  StatefulBuilder(
                                                                builder: (BuildContext
                                                                        context,
                                                                    setState) {
                                                                  return Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                10),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        PopupMenuButton<
                                                                            String>(
                                                                          tooltip:
                                                                              "",
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(border: Border(left: BorderSide(color: Colors.grey), right: BorderSide(color: Colors.grey), bottom: BorderSide(color: Colors.grey), top: BorderSide(color: Colors.grey))),
                                                                            child:
                                                                                TextFormField(
                                                                              decoration: InputDecoration(hintText: "Please select receptionist"),
                                                                              enabled: false,
                                                                              onChanged: (value) {
                                                                                var itemtextEditingController = TextEditingController(text: value.toString());
                                                                              },
                                                                              controller: this._name,
                                                                            ),
                                                                          ),
                                                                          onSelected:
                                                                              (String value) {
                                                                            this._name.text =
                                                                                value;

                                                                            int trendIndex = listData.indexWhere((f) =>
                                                                                f['name'] ==
                                                                                value);

                                                                            receptionistId =
                                                                                listData[trendIndex]['id'];

                                                                            setState(() {});
                                                                          },
                                                                          itemBuilder:
                                                                              (BuildContext context) {
                                                                            return clientEplyData.map((value) {
                                                                              return PopupMenuItem(child: Container(width: MediaQuery.of(context).size.width * (90 / 100), child: Text(value.name.toString())), value: value.name.toString());
                                                                            }).toList();
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              18,
                                                                        ),
                                                                        TextFormField(
                                                                          initialValue: viewproposalData[index]
                                                                              .market[0]
                                                                              .bookingPrice
                                                                              .toString(), // autofocus: false,
                                                                          maxLength:
                                                                              8,

                                                                          onChanged:
                                                                              (val) {
                                                                            budgetAmount =
                                                                                val;
                                                                          },
                                                                          style: TextStyle(
                                                                              color: Colors.black54,
                                                                              fontSize: 17),
                                                                          decoration: InputDecoration(
                                                                              labelText: "Enter amount",
                                                                              labelStyle: TextStyle(
                                                                                color: Colors.black87,
                                                                                fontSize: 15,
                                                                              ),
                                                                              counterText: "",
                                                                              fillColor: Color(0xffF5F6FA),
                                                                              filled: true,
                                                                              enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                                                                              focusedBorder: UnderlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.blue),
                                                                              ),
                                                                              hintText: "Enter amount",
                                                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            print("budgetAmount-=-= $budgetAmount");
                                                                            //return;
                                                                            if (receptionistId ==
                                                                                0) {
                                                                              showDialog<String>(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  content: Text("Please select receptionist"),
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

                                                                            if (budgetAmount ==
                                                                                "") {
                                                                              showDialog<String>(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  content: Text("Please enter amount"),
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
                                                                            var updateApiData =
                                                                                {
                                                                              "proposal_id": viewproposalData[index].id.toString(),
                                                                              "mid": viewproposalData[index].mid.toString(),
                                                                              "sid": viewproposalData[index].sid.toString(),
                                                                              "receptionist_id": receptionistId.toString(),
                                                                              "final_amount": budgetAmount.toString(),
                                                                            };

                                                                            var response =
                                                                                await Providers().acceptProposalStatus(updateApiData);
                                                                            if (response.status ==
                                                                                true) {
                                                                              setState(() {
                                                                                Navigator.pop(context);
                                                                              });
                                                                              print("-=-=-response.data[0].id ${response.data[0].id}");
                                                                              showDialog<String>(
                                                                                context: context,
                                                                                builder: (BuildContext context) => AlertDialog(
                                                                                  content: Text(response.message),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                        launchUrl(
                                                                                          Uri.parse("$paymentURL?order_id=${response.data[0].id}&type=market"),
                                                                                          mode: LaunchMode.inAppWebView,
                                                                                          webViewConfiguration: const WebViewConfiguration(),
                                                                                        );
                                                                                        Navigator.pushNamed(context, Routes.CLIENTMARKETPLACEBOOKINGROUTE);
                                                                                      },
                                                                                      child: const Text('OK'),
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
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0), color: Colors.blue),
                                                                                height: 35,
                                                                                // width: 300,
                                                                                child: Center(
                                                                                  child: Text('Accept proposal', style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                              )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      : null,
                              child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (12 / 100),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          (80 / 100),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.amber),
                                        height: 35,
                                        // width: 300,
                                        child: Center(
                                          child: Text(
                                              viewproposalData[index]
                                                          .market[0]
                                                          .status ==
                                                      "created"
                                                  ? "Accept"
                                                  // viewproposalData[index]
                                                  //     .status
                                                  //     .toString()
                                                  : widget.data['sid']
                                                              .toString() ==
                                                          viewproposalData[
                                                                  index]
                                                              .sid
                                                              .toString()
                                                      ? "Accepted"
                                                      : "Rejected",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width *
                                  (12 / 100),
                              // margin: EdgeInsets.only(left: 15),
                              child: GestureDetector(
                                onTap: () {
                                  int index1;
                                  var data1 = {
                                    'name': viewproposalData[index]
                                        .shipment[0]
                                        .name
                                        .toString(),
                                    'lname': viewproposalData[index]
                                        .shipment[0]
                                        .lname
                                        .toString(),
                                    'email': viewproposalData[index]
                                        .shipment[0]
                                        .email
                                        .toString(),
                                    'phone': viewproposalData[index]
                                        .shipment[0]
                                        .phone
                                        .toString(),
                                    'company': viewproposalData[index]
                                        .shipment[0]
                                        .companyname
                                        .toString(),
                                    'country': viewproposalData[index]
                                        .shipment[0]
                                        .country
                                        .toString(),
                                    'address': viewproposalData[index]
                                        .shipment[0]
                                        .address
                                        .toString(),
                                    'mktbookingId':
                                        viewproposalData[index].mid.toString(),
                                    'shipthrogh':
                                        viewproposalData[index].type.toString(),
                                    'pickupfee': viewproposalData[index]
                                        .pickupfee
                                        .toString(),
                                    'shipping_prize': viewproposalData[index]
                                        .shippingPrice
                                        .toString(),
                                    'tax':
                                        viewproposalData[index].tax.toString(),
                                    'status': viewproposalData[index]
                                        .status
                                        .toString(),
                                    'bookingdate': viewproposalData[index]
                                        .createdAt
                                        .substring(0, 10),
                                    'ProposalDescription':
                                        viewproposalData[index]
                                            .proposals
                                            .toString(),
                                    'title': viewproposalData[index]
                                        .market[0]
                                        .title
                                        .toString(),
                                    'pickup_location': viewproposalData[index]
                                        .market[0]
                                        .pickupLocation
                                        .toString(),
                                    'Drop_off': viewproposalData[index]
                                        .market[0]
                                        .dropoffLocation
                                        .toString(),
                                    'Delivery_days': viewproposalData[index]
                                        .market[0]
                                        .deliveryDays
                                        .toString(),
                                    'pickup/dropoff': viewproposalData[index]
                                        .market[0]
                                        .dropoff
                                        .toString(),
                                    'mrktstatus': viewproposalData[index]
                                        .market[0]
                                        .status
                                        .toString(),
                                    'booking_date': viewproposalData[index]
                                        .market[0]
                                        .bookingDate
                                        .toString(),
                                    'booking_price': viewproposalData[index]
                                        .market[0]
                                        .bookingPrice
                                        .toString(),
                                    'description': viewproposalData[index]
                                        .market[0]
                                        .description
                                        .toString(),
                                    'special_needs': viewproposalData[index]
                                        .market[0]
                                        .needs
                                        .toString(),
                                  };
                                  print(data1.toString());
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResProposalScreen(data1)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Container(
                                      // margin: EdgeInsets.only(right: 30),
                                      // height:
                                      width: MediaQuery.of(context).size.width *
                                          (80 / 100),
                                      // height: 100,
                                      // width: MediaQuery.of(context).size.width * (5 / 100),
                                      // width: 100,
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(10.0),
                                      //   color: Color(0xff0FBAB8),
                                      // ),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.black),
                                        height: 35,
                                        // width: 300,
                                        child: const Center(
                                          child: Text("Proposal Details",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                )
              : SizedBox();
        });
  }

  Widget mobileVieworderTemplate() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: viewproposalData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          log("MMMMMMM ${int.parse(viewproposalData[index].shippingPrice!) + int.parse(viewproposalData[index].pickupfee!) + int.parse(viewproposalData[index].tax!)}");
          return mkid.toString() == viewproposalData[index].mid.toString()
              ? Container(
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
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 15),
                              child: Text(
                                "proposalid".tr(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(top: 15, right: 20),
                              child: Text(
                                "companyid".tr(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (37 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                viewproposalData[index].id.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Container(
                              margin: EdgeInsets.only(right: 5),
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                viewproposalData[index].sid.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                "proposaldate".tr(),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )),
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(top: 10, right: 20),
                              child: Text("companyname".tr(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width *
                                  (40 / 100),
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text(
                                viewproposalData[index]
                                    .createdAt
                                    .substring(0, 10),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          Container(
                            width:
                                MediaQuery.of(context).size.width * (18 / 100),
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                viewproposalData[index]
                                    .shipment[0]
                                    .companyname
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff1A494F)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap:
                            viewproposalData[index].market[0].status ==
                                    "created"
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        var budgetAmount = '0';
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text(
                                              "Are you sure you want to accept proposal?"),
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
                                                Navigator.of(context).pop();
                                                showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          StatefulBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            setState) {
                                                      print(
                                                          "clientEplyData-=- $clientEplyData");
                                                      budgetAmount =
                                                          viewproposalData[
                                                                  index]
                                                              .shippingPrice!;
                                                      return AlertDialog(
                                                        scrollable: true,
                                                        title: Wrap(
                                                            direction:
                                                                Axis.vertical,
                                                            children: [
                                                              Text(
                                                                "Assign Receptionist",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                              ),
                                                              Text(
                                                                  "Bid amount : \$${viewproposalData[index].shippingPrice}")
                                                            ]),
                                                        content:
                                                            StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              setState) {
                                                            return Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 10),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  PopupMenuButton<
                                                                      String>(
                                                                    tooltip: "",
                                                                    child:
                                                                        Container(
                                                                      decoration: BoxDecoration(
                                                                          border: Border(
                                                                              left: BorderSide(color: Colors.grey),
                                                                              right: BorderSide(color: Colors.grey),
                                                                              bottom: BorderSide(color: Colors.grey),
                                                                              top: BorderSide(color: Colors.grey))),
                                                                      child:
                                                                          TextFormField(
                                                                        decoration:
                                                                            InputDecoration(hintText: "Please select receptionist"),
                                                                        enabled:
                                                                            false,
                                                                        onChanged:
                                                                            (value) {
                                                                          var itemtextEditingController =
                                                                              TextEditingController(text: value.toString());
                                                                        },
                                                                        controller:
                                                                            this._name,
                                                                      ),
                                                                    ),
                                                                    onSelected:
                                                                        (String
                                                                            value) {
                                                                      this._name.text =
                                                                          value;

                                                                      int trendIndex = listData.indexWhere((f) =>
                                                                          f['name'] ==
                                                                          value);

                                                                      receptionistId =
                                                                          listData[trendIndex]
                                                                              [
                                                                              'id'];

                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return clientEplyData
                                                                          .map(
                                                                              (value) {
                                                                        return PopupMenuItem(
                                                                            child:
                                                                                Container(width: MediaQuery.of(context).size.width * (90 / 100), child: Text(value.name.toString())),
                                                                            value: value.name.toString());
                                                                      }).toList();
                                                                    },
                                                                  ),
                                                                  SizedBox(
                                                                    height: 18,
                                                                  ),
                                                                  TextFormField(
                                                                    initialValue: viewproposalData[
                                                                            index]
                                                                        .market[
                                                                            0]
                                                                        .bookingPrice
                                                                        .toString(), // autofocus: false,
                                                                    maxLength:
                                                                        8,

                                                                    onChanged:
                                                                        (val) {
                                                                      budgetAmount =
                                                                          val;
                                                                    },
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontSize:
                                                                            17),
                                                                    decoration: InputDecoration(
                                                                        labelText: "Enter amount",
                                                                        labelStyle: TextStyle(
                                                                          color:
                                                                              Colors.black87,
                                                                          fontSize:
                                                                              15,
                                                                        ),
                                                                        counterText: "",
                                                                        fillColor: Color(0xffF5F6FA),
                                                                        filled: true,
                                                                        enabledBorder: new UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 1.0)),
                                                                        focusedBorder: UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.blue),
                                                                        ),
                                                                        hintText: "Enter amount",
                                                                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      print(
                                                                          "budgetAmount-=-= $budgetAmount");
                                                                      //return;
                                                                      if (receptionistId ==
                                                                          0) {
                                                                        showDialog<
                                                                            String>(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              AlertDialog(
                                                                            content:
                                                                                Text("Please select receptionist"),
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

                                                                      if (budgetAmount ==
                                                                          "") {
                                                                        showDialog<
                                                                            String>(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              AlertDialog(
                                                                            content:
                                                                                Text("Please enter amount"),
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
                                                                      var updateApiData =
                                                                          {
                                                                        "proposal_id": viewproposalData[index]
                                                                            .id
                                                                            .toString(),
                                                                        "mid": viewproposalData[index]
                                                                            .mid
                                                                            .toString(),
                                                                        "sid": viewproposalData[index]
                                                                            .sid
                                                                            .toString(),
                                                                        "receptionist_id":
                                                                            receptionistId.toString(),
                                                                        "final_amount":
                                                                            budgetAmount.toString(),
                                                                      };

                                                                      var response =
                                                                          await Providers()
                                                                              .acceptProposalStatus(updateApiData);
                                                                      if (response
                                                                              .status ==
                                                                          true) {
                                                                        setState(
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                        print(
                                                                            "-=-=-response.data[0].id ${response.data[0].id}");
                                                                        showDialog<
                                                                            String>(
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              AlertDialog(
                                                                            content:
                                                                                Text(response.message),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                  launchUrl(
                                                                                    Uri.parse("$paymentURL?order_id=${response.data[0].id}=&amount=$budgetAmount&type=market"),
                                                                                    mode: LaunchMode.inAppWebView,
                                                                                    webViewConfiguration: const WebViewConfiguration(),
                                                                                  );
                                                                                  Navigator.pushNamed(context, Routes.CLIENTMARKETPLACEBOOKINGROUTE);
                                                                                },
                                                                                child: const Text('OK'),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                        width: MediaQuery.of(context).size.width * (50 / 100),
                                                                        child: Container(
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                              color: Colors.blue),
                                                                          height:
                                                                              35,
                                                                          // width: 300,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text('Accept proposal', style: TextStyle(color: Colors.white)),
                                                                          ),
                                                                        )),
                                                                  )
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width * (60 / 100),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (80 / 100),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.amber),
                                  height: 35,
                                  // width: 300,
                                  child: Center(
                                    child: Text(
                                        viewproposalData[index]
                                                    .market[0]
                                                    .status ==
                                                "created"
                                            ? "Accept"
                                            // viewproposalData[index]
                                            //     .status
                                            //     .toString()
                                            : widget.data['sid'].toString() ==
                                                    viewproposalData[index]
                                                        .sid
                                                        .toString()
                                                ? "Accepted"
                                                : "Rejected",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * (60 / 100),
                        // margin: EdgeInsets.only(left: 15),
                        child: GestureDetector(
                          onTap: () {
                            int index1;
                            var data1 = {
                              'name': viewproposalData[index]
                                  .shipment[0]
                                  .name
                                  .toString(),
                              'lname': viewproposalData[index]
                                  .shipment[0]
                                  .lname
                                  .toString(),
                              'email': viewproposalData[index]
                                  .shipment[0]
                                  .email
                                  .toString(),
                              'phone': viewproposalData[index]
                                  .shipment[0]
                                  .phone
                                  .toString(),
                              'company': viewproposalData[index]
                                  .shipment[0]
                                  .companyname
                                  .toString(),
                              'country': viewproposalData[index]
                                  .shipment[0]
                                  .country
                                  .toString(),
                              'address': viewproposalData[index]
                                  .shipment[0]
                                  .address
                                  .toString(),
                              'mktbookingId':
                                  viewproposalData[index].mid.toString(),
                              'shipthrogh':
                                  viewproposalData[index].type.toString(),
                              'pickupfee':
                                  viewproposalData[index].pickupfee.toString(),
                              'shipping_prize': viewproposalData[index]
                                  .shippingPrice
                                  .toString(),
                              'tax': viewproposalData[index].tax.toString(),
                              'status':
                                  viewproposalData[index].status.toString(),
                              'bookingdate': viewproposalData[index]
                                  .createdAt
                                  .substring(0, 10),
                              'ProposalDescription':
                                  viewproposalData[index].proposals.toString(),
                              'title': viewproposalData[index]
                                  .market[0]
                                  .title
                                  .toString(),
                              'pickup_location': viewproposalData[index]
                                  .market[0]
                                  .pickupLocation
                                  .toString(),
                              'Drop_off': viewproposalData[index]
                                  .market[0]
                                  .dropoffLocation
                                  .toString(),
                              'Delivery_days': viewproposalData[index]
                                  .market[0]
                                  .deliveryDays
                                  .toString(),
                              'pickup/dropoff': viewproposalData[index]
                                  .market[0]
                                  .dropoff
                                  .toString(),
                              'mrktstatus': viewproposalData[index]
                                  .market[0]
                                  .status
                                  .toString(),
                              'booking_date': viewproposalData[index]
                                  .market[0]
                                  .bookingDate
                                  .toString(),
                              'booking_price': viewproposalData[index]
                                  .market[0]
                                  .bookingPrice
                                  .toString(),
                              'description': viewproposalData[index]
                                  .market[0]
                                  .description
                                  .toString(),
                              'special_needs': viewproposalData[index]
                                  .market[0]
                                  .needs
                                  .toString(),
                            };
                            print(data1.toString());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResProposalScreen(data1)));
                          },
                          child: Container(
                              // margin: EdgeInsets.only(right: 30),
                              // height:
                              width: MediaQuery.of(context).size.width * 5,
                              // height: 100,
                              // width: MediaQuery.of(context).size.width * (5 / 100),
                              // width: 100,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(10.0),
                              //   color: Color(0xff0FBAB8),
                              // ),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black),
                                height: 35,
                                // width: 300,
                                child: const Center(
                                  child: Text("Proposal Details",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox();
        });
  }

  Widget ContainerListDialog(
      {String? title,
      String? id,
      // String? itemsName,
      List? numberofitems,
      String? bookingprice,
      String? from,
      String? to}) {
    print("-=-=title $title");
    return Container(
      height: h * 0.40,
      width: w * 0.40,
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
                    width: w * 0.15,
                    child: Text(
                      "Order id",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width: w * 0.15,
                    child: Text(
                      id.toString(),
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
                      "Schedule Title",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width: w * 0.15,
                    child: Text(
                      title.toString(),
                      style: headingStyle16MB(),
                    ),
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
            //         child: Text(
            //           "Items ",
            //           style: headingStyle16MB(),
            //         ),
            //       ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Container(
                    width: w * 0.15,
                    child: Text("Items", style: headingStyle16MB()),
                  ),
                  Container(
                    width: w * 0.15,
                    height: h * 0.2,
                    //color: Colors.amber,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: numberofitems!.length,
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // mainAxisSpacing: 0.01,
                          // crossAxisSpacing: 0.01,
                          // childAspectRatio: 0.1
                        ),
                        itemBuilder: (context, index1) {
                          return Container(
                              margin: EdgeInsets.only(left: 5, top: 10),
                              child: Text(numberofitems[index1]
                                  .categoryItem
                                  .toString()));
                        }),
                  ),
                ],
              ),
            ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  // Container(
                  //   width: w * 0.15,
                  //   child: Text(
                  //     "Number Of Items",
                  //     style: headingStyle16MB(),
                  //   ),
                  // ),
                  // Container(
                  //   width: w * 0.15,
                  //   child: Text(
                  //     numberofitems.toString(),
                  //     style: headingStyle16MB(),
                  //   ),
                  // )
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
                      "Booking Estimate",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width: w * 0.15,
                    child: Text(
                      // viewbooking![index].bookingType,
                      bookingprice.toString(),
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
                      "From",
                      style: headingStyle16MB(),
                    ),
                  ),
                  Container(
                    width: w * 0.10,
                    child: Text(from.toString(), style: headingStyle16MB()),
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
                    child: Text(to.toString(), style: headingStyle16MB()),
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
