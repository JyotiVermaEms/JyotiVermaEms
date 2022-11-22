// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/ShowClientReviewModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ClienSubmitReview.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ClientReview extends StatefulWidget {
  var data;
  ClientReview(this.data);

  @override
  _ClientReviewState createState() => _ClientReviewState();
}

class _ClientReviewState extends State<ClientReview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

  List? reviewData;

  List<Data> showData = [];

  var sid, companyName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sid = widget.data['sID'];
      print("object $sid");
      companyName = widget.data['companyName'];
    });

    showClientReview();
  }

  showClientReview() async {
    var data = {"sid": "$sid"};
    print("sid>> $data");
    var responce = await Providers().viewClientReview(data);

    if (responce.status == true) {
      setState(() {
        showData = responce.data;
      });
      // print("showData ${showData[0].clientname[0].profileimage}");
    }
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
          height: h,
          color: Color(0xffF5F6F8),
          child: SafeArea(
              child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
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
                        margin: (Responsive.isDesktop(context))
                            ? EdgeInsets.fromLTRB(5, 10, 50, 0)
                            : EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: (Responsive.isDesktop(context))
                            ? Row(
                                children: [
                                  Text(
                                    'Review and rating >',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            (Responsive.isDesktop(context))
                                                ? 22
                                                : 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    companyName.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            (Responsive.isDesktop(context))
                                                ? 18
                                                : 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // Spacer(),
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Review and rating >',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    companyName.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  // Spacer(),
                                ],
                              )),
                  ],
                ),
              ),
              if (!Responsive.isDesktop(context))
                Column(
                  children: [reivewList(), buttons()],
                ),
              if (Responsive.isDesktop(context))
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: w,
                    height: h,
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: Row(
                      children: [
                        Container(
                          width: w * 0.5,
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: reivewList()),
                        ),
                        // Spacer(),
                        Container(
                          width: w * 0.2,
                          child: buttons(),
                        )
                      ],
                    )),
            ],
          ))),
    );
  }

  Widget reivewList() {
    return ListView.builder(
      itemCount: showData.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                margin: EdgeInsets.only(left: 24, top: 15, right: 10),
                // height: h * 0,
                width: w,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child:
                                showData[index].clientname[0].profileimage != ''
                                    ? Image.network(showData[index]
                                        .clientname[0]
                                        .profileimage
                                        .toString())
                                    : Icon(Icons.person),
                            height: 75,
                            width: 50),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                    showData[index]
                                        .clientname[0]
                                        .name
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10, left: 10),
                                child: Text(
                                    (DateFormat.yMMMMd('en_US')
                                        .format(DateTime.parse(
                                            showData[index].createdAt))
                                        .toString()),
                                    // DateFormat.yMMMd('en_US')
                                    //     .parse(showData[index].createdAt)
                                    //     .toString(),
                                    style: TextStyle(
                                      color: Color(0xff90A0B7),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        if (Responsive.isDesktop(context))
                          Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: RatingBarIndicator(
                                rating: double.parse(
                                    double.parse(showData[index].rating)
                                        .toString()),
                                direction: Axis.horizontal,
                                // allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 30,
                                unratedColor: Colors.black.withAlpha(50),
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.yellowAccent,
                                  ),
                                ),
                              )),
                      ],
                    ),
                    // if (Responsive.isMobile(context))
                    //   Padding(
                    //     padding: const EdgeInsets.all(0.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Container(
                    //           // width: w * 0.20,
                    //           child: Row(
                    //             children: [
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 10),
                    //                   child: Icon(
                    //                     Icons.star_border,
                    //                     size: 20,
                    //                   )),
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 5),
                    //                   child: Icon(
                    //                     Icons.star_border,
                    //                     size: 20,
                    //                   )),
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 5),
                    //                   child: Icon(
                    //                     Icons.star_border,
                    //                     size: 20,
                    //                   )),
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 5),
                    //                   child: Icon(
                    //                     Icons.star_border,
                    //                     size: 20,
                    //                   )),
                    //               Container(
                    //                   margin:
                    //                       EdgeInsets.only(left: 5, right: 10),
                    //                   child: Icon(
                    //                     Icons.star_border,
                    //                     size: 20,
                    //                   )),
                    //             ],
                    //           ),
                    //         ),
                    //         // Container(
                    //         //   margin: EdgeInsets.only(right: 10, left: 10),
                    //         //   child: Text("4.0",
                    //         //       style: TextStyle(
                    //         //         color: Color(0xff90A0B7),
                    //         //         fontWeight: FontWeight.bold,
                    //         //         fontSize: 10,
                    //         //       )),
                    //         // ),
                    //       ],
                    //     ),
                    //   ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                          showData[index].comment != "null"
                              ? showData[index].comment.toString()
                              : "NA",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buttons() {
    return Column(
      children: [
        // GestureDetector(
        //   onTap: () {
        //     var data = {"sid": "$sid", "companyname": "$companyName"};
        //     print("jkjkjkjkj$data");

        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => ClinetSubmitReview(data)));
        //   },
        //   child: Container(
        //     margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(50.0),
        //         color: Color(0xffE1B400)),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Container(
        //             margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

        //             // width: MediaQuery.of(context).size.width * 0.8,
        //             // color: Colors.lime,
        //             child: Center(
        //                 child: Text("Share Reviewxax",
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 16,
        //                     )))),
        //         Container(
        //           margin: EdgeInsets.only(top: 15, right: 10, left: 30),
        //           height: 30,
        //           // width: 300,
        //           child: Image.asset('assets/images/arrow-right.png'),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
