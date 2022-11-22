// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/pages/Departure%20Manager/Order/DepartureOrder.dart';
import 'package:shipment/pages/Departure%20Manager/Order/depaturealertdiaolog.dart';
import 'package:http/http.dart' as http;

class DepatureDetails extends StatefulWidget {
  var data;
  DepatureDetails(this.data);

  @override
  _DepatureDetails createState() => _DepatureDetails();
}

class _DepatureDetails extends State<DepatureDetails> {
  var imageList = [];
  PlatformFile? objFile = null;
  @override
  void initState() {
    super.initState();
  }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    var _currentIndex = 0;
    return Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
        child: (Responsive.isDesktop(context))
            ? Column(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(15, 10, 50, 0),
                  child: Text(
                    'Schedule Title : ' + widget.data['title'].toString(),
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
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Divider(
                    height: 30,
                    color: Colors.black,
                    thickness: 2,
                  ),
                ),
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: Container(
                //       margin: EdgeInsets.only(
                //           left: 10, right: 10, top: 10, bottom: 5),
                //       child: Text(
                //         "Item Details",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 18),
                //       )),
                // ),
                Expanded(
                  child: Container(
                      width: w * 0.75,
                      height: h * 0.50,
                      child: ListView.builder(
                          itemCount: widget.data['itemimage1'].length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            var jsondata =
                                widget.data['itemimage1'][index].itemName;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: widget
                                                        .data['itemimage1']
                                                            [index]
                                                        .itemImage
                                                        .length !=
                                                    0
                                                ? CarouselSlider(
                                                    options: CarouselOptions(
                                                      enableInfiniteScroll:
                                                          false,
                                                      autoPlay: true,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _currentIndex = index;
                                                        });
                                                        //print(_currentIndex);
                                                      },
                                                    ),
                                                    items:
                                                        widget
                                                            .data['itemimage1']
                                                                [index]
                                                            .itemImage
                                                            .map<Widget>(
                                                                (item) =>
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return imageViewDialog(
                                                                                context,
                                                                                item,
                                                                                widget.data['itemimage1'][index].itemImage);
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              150,
                                                                          width:
                                                                              230,
                                                                          child:
                                                                              Image.network(
                                                                            item,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                  )
                                                : Center(
                                                    child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "No Image Available",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            height: 150,
                                            width: 150,
                                          ),
                                          SizedBox(width: kDefaultPadding / 2),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    "Category : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
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
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    widget
                                                        .data['itemimage1']
                                                            [index]
                                                        .category
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, top: 10),
                                                  child: Text(
                                                    "Item Name : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      const EdgeInsets.only(
                                                          left: 5, top: 10),
                                                  child:
                                                      // Text(widget
                                                      //     .data['itemdetail'][index]
                                                      //     .itemName
                                                      //     .toString()),
                                                      Row(
                                                          children:
                                                              List.generate(
                                                    jsondata.length,
                                                    (index) => Row(children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          jsondata[index]
                                                                  .itemname +
                                                              ",",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 7, 10, 7),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0),
                                                              color: Color(
                                                                  0xffEFEFEF)),
                                                          child: Text(
                                                            jsondata[index].qty,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    "Description : ",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 5,
                                                  ),
                                                  child: Container(
                                                    height: 50,
                                                    width: 650,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Text(
                                                            widget
                                                                .data[
                                                                    'itemimage1']
                                                                    [index]
                                                                .description
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)
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
                ),
              ])
            : Column(children: [
                ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        height: h * 0.2,
                        width: MediaQuery.of(context).size.width * (100 / 100),
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF).withOpacity(0.5),
                        ),
                        child: Scrollbar(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                          width: 80,
                                          margin: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Text(
                                            "ID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          width: 80,
                                          margin: EdgeInsets.only(
                                              left: 20, top: 10),
                                          child: Text(
                                            widget.data['bid'].toString(),
                                            //{widget.data['id']}.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: 100,
                                          // margin: EdgeInsets.only(right: 70),
                                          child: Text(
                                            "Booking Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: 100,
                                          child: Text(
                                            widget.data['bdate'].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 140,
                                          // margin: EdgeInsets.only(right: 70),
                                          child: Text(
                                            "Departure Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 100,
                                          child: Text(
                                            widget.data['depaturedate']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 100,
                                          child: Text(
                                            "Arrival Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 100,
                                          child: Text(
                                            widget.data['arrivaldate']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 100,
                                          child: Text(
                                            "Type",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          margin: EdgeInsets.only(
                                            top: 10,
                                            left: 20,
                                          ),
                                          width: 100,
                                          child: Text(
                                            widget.data['type'].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: 120,
                                          margin: EdgeInsets.only(
                                              right: 16, top: 10),
                                          child: Text(
                                            "Company",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          width: 120,
                                          margin: EdgeInsets.only(
                                              right: 16, top: 10),
                                          child: Text(
                                            widget.data['company'].toString(),
                                            softWrap: true,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: 60,
                                          margin: EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: Text(
                                            "Action",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      InkWell(
                                        onTap: () {
                                          var pid =
                                              widget.data['pid'].toString();

                                          var itemimage = widget
                                              .data['pickupitemimage']
                                              .toString();
                                          var comment = widget
                                              .data['pickupcomment']
                                              .toString();
                                          var itemimage1 = widget
                                              .data['pickupitemimage1']
                                              .toString();
                                          var comment1 = widget
                                              .data['pickupcomment1']
                                              .toString();
                                          var depatureimage = widget
                                              .data['depatureimage']
                                              .toString();
                                          var depaturecomment = widget
                                              .data['depaturecomment']
                                              .toString();

                                          var bid =
                                              widget.data['bid'].toString();
                                          var type =
                                              widget.data['type'].toString();
                                          var bookingdate =
                                              widget.data['bdate'].toString();
                                          var status =
                                              widget.data['status'].toString();
                                          print("first face-----$itemimage");
                                          print(
                                              "first face commet-----$comment");
                                          print(
                                              "second google-----$itemimage1");
                                          print(
                                              "second google comment-----$comment1");

                                          widget.data['pickuptype'] == "Pick up"
                                              ? showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CustomDialogBox1(
                                                            bid,
                                                            pid,
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
                                                          ))
                                              : showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      CustomDialogBoxDropOff(
                                                        bid,
                                                        pid,
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
                                                      ));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: 10, top: 10),
                                            height: 40,
                                            width: 130,
                                            decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            // width:
                                            child: Center(
                                              child: Text(
                                                "View Path",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
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
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Divider(
                    height: 30,
                    color: Colors.black,
                    thickness: 2,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Text(
                        "Item Details",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ),
                Expanded(
                  child: Container(
                      width: w * 0.99,
                      height: h * 0.50,
                      child: ListView.builder(
                          itemCount: widget.data['itemimage1'].length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            var jsondata =
                                widget.data['itemimage1'][index].itemName;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 5,
                                        ),
                                        child:
                                            widget.data['itemimage1'][index]
                                                        .itemImage.length !=
                                                    0
                                                ? CarouselSlider(
                                                    options: CarouselOptions(
                                                      enableInfiniteScroll:
                                                          false,
                                                      autoPlay: true,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _currentIndex = index;
                                                        });
                                                        //print(_currentIndex);
                                                      },
                                                    ),
                                                    items:
                                                        widget
                                                            .data['itemimage1']
                                                                [index]
                                                            .itemImage
                                                            .map<Widget>(
                                                                (item) =>
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return imageViewDialog(
                                                                                context,
                                                                                item,
                                                                                widget.data['itemimage1'][index].itemImage);
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              100,
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Image.network(
                                                                            item,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ))
                                                            .toList(),
                                                  )
                                                : Center(
                                                    child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Text(
                                                      "No Image Available",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: 150,
                                        width: 150,
                                      ),
                                      SizedBox(width: kDefaultPadding / 2),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                "Category : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
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
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                widget.data['itemimage1'][index]
                                                    .category
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
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
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 10),
                                              child: Text(
                                                "Item Name : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
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
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 10),
                                              child: Container(
                                                height: 40,
                                                width: w * 0.4,
                                                child: Scrollbar(
                                                  isAlwaysShown: true,
                                                  child: ListView(
                                                      addRepaintBoundaries:
                                                          true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: List.generate(
                                                        jsondata.length,
                                                        (index) =>
                                                            Row(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Text(
                                                              jsondata[index]
                                                                      .itemname +
                                                                  ",",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          7,
                                                                          10,
                                                                          7),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50.0),
                                                                  color: Color(
                                                                      0xffEFEFEF)),
                                                              child: Text(
                                                                jsondata[index]
                                                                    .qty,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
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
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                "Description : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: Container(
                                                height: h * 0.19,
                                                width: w * 0.3,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                        widget
                                                            .data['itemimage1']
                                                                [index]
                                                            .description
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500)
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
                ),
              ]));
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
              width: 40,
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
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 120,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Departure Date",
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
          // Spacer(),
          // Container(
          //     width: 100,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "Title",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
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
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
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
                    width: 40,
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
                    width: 120,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.data['depaturedate'].toString(),
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

                // Container(
                //     height: 50,
                //     width: 100,

                //     // margin: EdgeInsets.only(left: 20),
                //     child: Center(
                //       child: Text(
                //         "hjjhjjh  djhjdjd jghjhjhjhj gghjghjghj jhgjhhj,gghjghjghj jhgjhhj,gghjghjghj jhgjhhj,gghjghjghj jhgjhhj",
                //         // widget.data['title'].toString(),
                //         softWrap: true,
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, fontSize: 12),
                //       ),
                //     )),

                Container(
                    width: 90,
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
                      softWrap: true,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                // Container(
                //     width: 80,
                //     // margin: EdgeInsets.only(right: 30),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
                // Spacer(),
                // Container(
                //     margin: EdgeInsets.only(left: 30),
                //     child: Text(
                //       "CMA CGM",
                //       // style: TextStyle(fontWeight: FontWeight.bold),
                //     )),

                // Container(
                //     width: 100,
                //     margin: EdgeInsets.only(right: 20),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
                InkWell(
                  onTap: () {
                    var pid = widget.data['pid'].toString();

                    var itemimage = widget.data['pickupitemimage'].toString();
                    var comment = widget.data['pickupcomment'].toString();
                    var itemimage1 = widget.data['pickupitemimage1'].toString();
                    var comment1 = widget.data['pickupcomment1'].toString();
                    var depatureimage = widget.data['depatureimage'].toString();
                    var depaturecomment =
                        widget.data['depaturecomment'].toString();

                    var bid = widget.data['bid'].toString();
                    var type = widget.data['type'].toString();
                    var bookingdate = widget.data['bdate'].toString();
                    var status = widget.data['status'].toString();
                    print("first face-----$itemimage");
                    print("first face commet-----$comment");
                    print("second google-----$itemimage1");
                    print("second google comment-----$comment1");

                    widget.data['pickuptype'] == "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogBox1(
                                  bid,
                                  pid,
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
                                ))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxDropOff(
                                  bid,
                                  pid,
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
                                ));
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: w * 0.09,
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

class profileConfirm extends StatefulWidget {
  const profileConfirm({Key? key}) : super(key: key);

  @override
  _profileConfirmtate createState() => _profileConfirmtate();
}

class _profileConfirmtate extends State<profileConfirm>
    with TickerProviderStateMixin {
  // GifController? controller1;

  // @override
  // void initState() {
  //   controller1 = GifController(vsync: this);
  //   super.initState();
  // }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox2(context),
    );
  }

  contentBox2(context) {
    return Container(
        height: 500,
        width: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
                child: Image.asset(
                  "assets/images/success.gif",
                ),
                height: MediaQuery.of(context).size.height * (20 / 100),
                width: MediaQuery.of(context).size.width * (20 / 100)),
            Center(
              child: Text(
                "Status has been Updated Successfully",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                    fontSize: 30),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        "Status has been Changed , Now You Can Proceed For Next Step"))),
            // Center(
            //     child: Align(
            //         alignment: Alignment.center,
            //         child:
            //             Text("Ask Shishank to Reset password before login"))),
            SizedBox(
              height: MediaQuery.of(context).size.height * (5 / 100),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xff1A494F)),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.4,
                  // color: Colors.lime,
                  child: Center(
                      child: Text(
                    "Close",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
            ),
          ],
        ));
  }
}
