import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/viewMarketPlaceBooking.dart';
import 'package:shipment/Model/Client/viewProposalModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/re_proposalScreen.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/res_marketplacebooking2.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/pages/Client/MarketPlace/marketPlaceviewBooking2.dart';

import '../Dashboard/MobileDashboard.dart';

class viewMarketPlaceBooking extends StatefulWidget {
  const viewMarketPlaceBooking({Key? key}) : super(key: key);

  @override
  _viewMarketPlaceBookingState createState() => _viewMarketPlaceBookingState();
}

class _viewMarketPlaceBookingState extends State<viewMarketPlaceBooking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var _lastQuitTime;
  var index;
  var companyname;
  var statusCheck;
  List<ViewProposalData> viewproposalData = [];
  List<Data> marketplaceData = [];
  bool isProcess = false;

  showMarketplaceBooking() async {
    setState(() {
      isProcess = true;
    });
    print('view booking');
    var response = await Providers().showMarketPlaceBooking();
    if (response.status == true) {
      for (int i = 0; i < response.data.length; i++) {
        setState(() {
          marketplaceData.add(response.data[i]);
        });
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showMarketplaceBooking();
  }

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
                                  'Proposals',
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
                          marketplaceData.length == 0
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
                                          // Image.asset(
                                          //   'assets/images/applogo.png',
                                          //   height:
                                          //       MediaQuery.of(context).size.height * 0.10,
                                          // ),
                                          SizedBox(height: 15),
                                          Text(
                                            'Sorry, You have not Create any market place yet',
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
                              mobileViewlist(),
                              // MobileVieworderTemplate2(),
                            ],
                          ),
                      ])),
                )),
    );
  }

  Widget mobileViewlist() {
    return ListView.builder(
        itemCount: marketplaceData.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            width: w,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "marketplaceid".tr(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          marketplaceData[index].id.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
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
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          (DateFormat.yMd()
                              .format(DateTime.parse(
                                  marketplaceData[index].createdAt))
                              .toString()),
                          // marketplaceData[index].createdAt.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
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
                                  title:
                                      marketplaceData[index].title.toString(),
                                  id: marketplaceData[index].id.toString(),
                                  numberofitems:
                                      marketplaceData[index].category,
                                  bookingprice: marketplaceData[index]
                                      .bookingPrice
                                      .toString(),
                                  from: marketplaceData[index]
                                      .pickupLocation
                                      .toString(),
                                  to: marketplaceData[index]
                                      .dropoffLocation
                                      .toString(),
                                )),
                          );
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(left: 15, top: 5),
                          child: Text(
                            "scheduletitle".tr(),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          margin: EdgeInsets.only(top: 5, right: 20),
                          child: Text(
                            marketplaceData[index].title.toString(),
                            // marketplaceData[index].createdAt.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
                Container(
                    child: marketplaceData[index].proposal.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xffffab40)),
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                    marketplaceData[index].status.toString() ==
                                            "created"
                                        ? "Offer receive"
                                        : marketplaceData[index]
                                            .status
                                            .toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xff4caf50)),
                              child: Center(
                                child: Text(
                                  marketplaceData[index].status.toString() ==
                                          "created"
                                      ? "Pending"
                                      : marketplaceData[index]
                                          .status
                                          .toString(),
                                  // marketplaceData[index].status.toString(),
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                marketplaceData[index].proposal.length > 0
                    ? GestureDetector(
                        onTap: () {
                          var data = {
                            'marketplaceid':
                                marketplaceData[index].id.toString(),
                            'sid': marketplaceData[index].sid.toString(),
                          };

                          print("????????????????????????" +
                              data['marketplaceid'].toString());

                          // getProposalDetails();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResMarketPlaceBooking2(data)));
                        },
                        child: Container(
                          margin:
                              EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xff4caf50)),
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text("View Proposal",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    : const Text(''),
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
              width: MediaQuery.of(context).size.width * (18 / 100),
              margin: EdgeInsets.only(left: 15),
              child: Text(
                "Market Place ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: MediaQuery.of(context).size.width * (19 / 100),

              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),

          Container(
              width: MediaQuery.of(context).size.width * (24 / 100),
              child: Text(
                "Schedule Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: MediaQuery.of(context).size.width * (9 / 100),
              child: Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: marketplaceData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 100,

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
                      width: MediaQuery.of(context).size.width * (20 / 100),
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        marketplaceData[index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        (DateFormat.yMd()
                            .format(DateTime.parse(
                                marketplaceData[index].createdAt))
                            .toString()),
                        // marketplaceData[index].createdAt.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                    width: MediaQuery.of(context).size.width * (20 / 100),
                    child: InkWell(
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
                                      title: marketplaceData[index]
                                          .title
                                          .toString(),
                                      id: marketplaceData[index].id.toString(),
                                      numberofitems:
                                          marketplaceData[index].category,
                                      bookingprice: marketplaceData[index]
                                          .bookingPrice
                                          .toString(),
                                      from: marketplaceData[index]
                                          .pickupLocation
                                          .toString(),
                                      to: marketplaceData[index]
                                          .dropoffLocation
                                          .toString(),
                                    )),
                              );
                            });
                      },
                      child: Text(
                        marketplaceData[index].title.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A494F)),
                      ),
                    ),
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width * (11 / 100),
                    // margin: EdgeInsets.only(left: 15),
                    child:
                        //  viewbooking[index].status == 'Pending'
                        //     ? Text(
                        //         viewbooking[index].status,
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       )
                        //    : viewbooking![index].status == 1
                        //         ? Text(
                        //             viewbooking![index].status,
                        //             style: TextStyle(fontWeight: FontWeight.bold),
                        //           )
                        //     : viewbooking![index].status == 2
                        //             ? Text(
                        //                 viewbooking![index].status,
                        //                 style: TextStyle(fontWeight: FontWeight.bold),
                        //               )
                        //      : viewbooking![index].status == 2
                        //                 ? Text(viewbooking![index].status)
                        // :
                        Container(
                            margin: EdgeInsets.only(right: 40),
                            // height:
                            width:
                                MediaQuery.of(context).size.width * (50 / 100),
                            // height: 100,
                            // width: MediaQuery.of(context).size.width * (5 / 100),
                            // width: 100,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10.0),
                            //   color: Color(0xff0FBAB8),
                            // ),
                            child: Column(
                              children: [
                                Container(
                                    child: marketplaceData[index]
                                                .proposal
                                                .length >
                                            0
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Color(0xffffab40)),
                                              height: 30,
                                              width: 200,
                                              child: Center(
                                                child: Text(
                                                    marketplaceData[index]
                                                                .status
                                                                .toString() ==
                                                            "created"
                                                        ? "Offer receive"
                                                        : marketplaceData[index]
                                                            .status
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                            //  Container(
                                            //   child: Text(
                                            //     "offer Received ",

                                            //     // marketplaceData[index].status.toString(),
                                            //     style: TextStyle(
                                            //         fontSize: 15,
                                            //         color: Colors.green),
                                            //   ),
                                            // ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 30),
                                            child:
                                                // Container(
                                                //   margin:
                                                //       EdgeInsets.only(bottom: 10),
                                                //   decoration: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               20.0),
                                                //       color: Color(0xff4caf50)),
                                                //   height: 30,
                                                //   width: 150,
                                                //   child: const Center(
                                                //     child: Text("View Proposal",
                                                //         style: TextStyle(
                                                //             color: Colors.white)),
                                                //   ),
                                                // ),
                                                Container(
                                              height: 30,
                                              width: 500,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Color(0xff4caf50)),
                                              child: Center(
                                                child: Text(
                                                  marketplaceData[index]
                                                              .status
                                                              .toString() ==
                                                          "created"
                                                      ? "Pending"
                                                      : marketplaceData[index]
                                                          .status
                                                          .toString(),
                                                  // marketplaceData[index].status.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          )),
                                marketplaceData[index].proposal.length > 0
                                    ? GestureDetector(
                                        onTap: () {
                                          var data = {
                                            'marketplaceid':
                                                marketplaceData[index]
                                                    .id
                                                    .toString(),
                                            'sid': marketplaceData[index]
                                                .sid
                                                .toString(),
                                          };
                                          // var marketplaceid =
                                          //     marketplaceData[index]
                                          //         .id
                                          //         .toString();

                                          print("????????????????????????" +
                                              data['marketplaceid'].toString());

                                          // getProposalDetails();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResMarketPlaceBooking2(
                                                          data)));
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => ResProposalScreen()));
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (BuildContext context) =>
                                          //         CustomDialogBox());
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: Color(0xff4caf50)),
                                          height: 30,
                                          width: 200,
                                          child: const Center(
                                            child: Text("View Proposal",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            )),
                  )
                ]),
          );
        });
  }

  Widget ContainerListDialog(
      {String? title,
      String? id,
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
      child: (Responsive.isDesktop(context))
          ? SingleChildScrollView(
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

                  Row(
                    children: [
                      Container(
                        width: w * 0.15,
                        child: Text("Items", style: headingStyle16MB()),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                            width: w * 0.20,
                            height: h * 0.2,
                            // color: Colors.amber,
                            child: ListView.builder(
                                itemCount: numberofitems!.length,
                                itemBuilder: (context, index1) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 30),
                                    child: Text(
                                      numberofitems[index1]
                                          .bookingAttribute
                                          .join(",")
                                          .toString(),
                                    ),
                                  );
                                })),
                      ),
                    ],
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
                          child:
                              Text(from.toString(), style: headingStyle16MB()),
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
            )
          : SingleChildScrollView(
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
                          width: w * 0.35,
                          child: Text(
                            "Order id",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: w * 0.22,
                          child: Text(id.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: w * 0.35,
                          child: Text(
                            "Schedule Title",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: w * 0.22,
                          child: Text(
                            title.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: w * 0.35,
                        child: Text(
                          "Items",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                            width: w * 0.20,
                            height: h * 0.2,
                            // color: Colors.amber,
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: ListView.builder(
                                  itemCount: numberofitems!.length,
                                  itemBuilder: (context, index1) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 30),
                                      child: Text(
                                          numberofitems[index1]
                                              .bookingAttribute
                                              .join(",")
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),
                                    );
                                  }),
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: w * 0.35,
                          child: Text(
                            // bookingtype.toString(),
                            "Booking Estimate",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: w * 0.22,
                          child: Text(
                            // viewbooking![index].bookingType,
                            bookingprice.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 12),
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
                          width: w * 0.35,
                          child: Text(
                            "From",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: w * 0.22,
                          child: Text(from.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Container(
                          width: w * 0.35,
                          child: Text("To",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          width: w * 0.22,
                          child: Text(to.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
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
