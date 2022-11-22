import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/pages/Pickup%20Agent/alertdialog.dart';

class PickupDetails extends StatefulWidget {
  var data;
  PickupDetails(this.data);

  @override
  _PickupDetails createState() => _PickupDetails();
}

class _PickupDetails extends State<PickupDetails> {
  var imageList = [];
  @override
  void initState() {
    super.initState();
    print("ioioioioioioi${widget.data['itemimage1']}");
    for (int i = 0; i < widget.data['itemimage1'].length; i++) {
      imageList.add(widget.data['itemimage1'][i].toString());

      print(":imageList");
      print(imageList);
    }
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
              Expanded(
                child: Container(
                    width: w * 0.75,
                    height: h * 0.48,
                    child: ListView.builder(
                        itemCount: widget.data['itemdetail'].length,
                        reverse: false,
                        itemBuilder: (context, index) {
                          print(
                              "-=-=-=--=====${widget.data['itemdetail'][index].itemImage}");
                          var jsondata =
                              widget.data['itemdetail'][index].itemName;
                          // print("-=-=-=--=====$jsondata");
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
                                                      .data['itemdetail'][index]
                                                      .itemImage
                                                      .length !=
                                                  0
                                              ? CarouselSlider(
                                                  options: CarouselOptions(
                                                    enableInfiniteScroll: false,
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
                                                          .data['itemdetail']
                                                              [index]
                                                          .itemImage
                                                          .map<Widget>(
                                                              (item) => InkWell(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return imageViewDialog(
                                                                              context,
                                                                              item,
                                                                              widget.data['itemdetail'][index].itemImage);
                                                                        },
                                                                      );
                                                                    },
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            230,
                                                                        child: Image
                                                                            .network(
                                                                          item,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ))
                                                          .toList(),
                                                )
                                              : Center(
                                                  child: Text(
                                                  "No Image Available",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(
                                                  widget
                                                      .data['itemdetail'][index]
                                                      .category
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
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
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 10),
                                                child: Row(
                                                    children: List.generate(
                                                  jsondata.length,
                                                  (index) => Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
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
                                                  height: 50,
                                                  width: 700,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Text(
                                                          widget
                                                              .data[
                                                                  'itemdetail']
                                                                  [index]
                                                              .description
                                                              .toString(),
                                                          softWrap: true,
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [],
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
                      height: h * 0.18,
                      width: MediaQuery.of(context).size.width * (98 / 100),
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF).withOpacity(0.5),
                      ),
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(children: [
                                    Container(
                                        width: 80,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(
                                          "ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 80,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(
                                          widget.data['id'].toString(),
                                          //{widget.data['id']}.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
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
                                        width: 100,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.data['bookingdate'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                        ),
                                        width: 100,
                                        // margin: EdgeInsets.only(right: 70),
                                        child: Text(
                                          "Arrival Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                        ),
                                        child: Text(
                                          widget.data['arrivaldate'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                        width: 100,
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                        ),
                                        child: Text(
                                          "Title",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin: EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                        ),
                                        child: Text(
                                          widget.data['title'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                        width: 100,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.data['type'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                        width: 120,
                                        margin:
                                            EdgeInsets.only(right: 16, top: 10),
                                        child: Text(
                                          "Company",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 120,
                                        margin:
                                            EdgeInsets.only(right: 15, top: 10),
                                        child: Text(
                                          widget.data['shipcmpany'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        )),
                                  ]),
                                  Column(children: [
                                    Container(
                                        width: 120,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(
                                          "Action",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    InkWell(
                                      onTap: () {
                                        var id = widget.data['id'].toString();
                                        var itemimage = widget
                                            .data['pickupitemimage']
                                            .toString();
                                        var itemimage1 = widget
                                            .data['pickupitemimage1']
                                            .toString();
                                        var comment = widget
                                            .data['pickupcomment']
                                            .toString();
                                        var comment1 = widget
                                            .data['pickupcomment1']
                                            .toString();

                                        var type =
                                            widget.data['type'].toString();
                                        var bookingdate = widget
                                            .data['bookingdate']
                                            .toString();
                                        var status =
                                            widget.data['status'].toString();

                                        print(id);
                                        print(itemimage);
                                        print(itemimage1);
                                        print(comment);
                                        print(comment1);
                                        print(type);
                                        print(bookingdate);
                                        print(status);
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
                                      },
                                      child: Container(
                                          height: 40,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          // width:
                                          margin: EdgeInsets.only(
                                              right: 15, top: 10),
                                          child: Center(
                                            child: Text(
                                              "View Path",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ]),
                                ],
                              ),
                            ]),
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
                        left: 10, right: 10, top: 10, bottom: 5),
                    child: Text(
                      "Item Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
              ),
              Expanded(
                child: Container(
                    width: w * 0.80,
                    height: h * 0.50,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView.builder(
                          itemCount: widget.data['itemdetail'].length,
                          reverse: false,
                          itemBuilder: (context, index) {
                            var jsondata =
                                widget.data['itemdetail'][index].itemName;
                            print("ehdjhjkdhjhd$jsondata");
                            print("-=--=-=-=${jsondata.length}");
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
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
                                        child:
                                            widget.data['itemdetail'][index]
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
                                                        print(_currentIndex);
                                                      },
                                                    ),
                                                    items:
                                                        widget
                                                            .data['itemdetail']
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
                                                                            print("in dialog client $_currentIndex");
                                                                            return imageViewDialog(
                                                                                context,
                                                                                _currentIndex,
                                                                                widget.data['itemdetail'][index].itemImage);
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
                                                                              350,
                                                                          width:
                                                                              w * 0.80,
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
                                                    child: Text(
                                                    "No Image Available",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Text(
                                                widget.data['itemdetail'][index]
                                                        .category +
                                                    ",",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
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
                                                      children: [
                                                        Row(
                                                            children:
                                                                List.generate(
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
                                                                style:
                                                                    TextStyle(
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
                                                                        BorderRadius.circular(
                                                                            50.0),
                                                                    color: Color(
                                                                        0xffEFEFEF)),
                                                                child: Text(
                                                                  jsondata[
                                                                          index]
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
                                                      ]),
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
                                                width: w * 0.4,
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Text(
                                                        widget
                                                            .data['itemdetail']
                                                                [index]
                                                            .description
                                                            .toString(),
                                                        softWrap: true,
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
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
                          }),
                    )),
              ),
            ]),
    );
  }

  Widget orderTemplate() {
    return Container(
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
              width: 80,
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
              width: w * 0.09,
              margin: EdgeInsets.only(left: 5, right: 5),
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
                    width: 40,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.data['id'].toString(),
                      //{widget.data['id']}.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.data['bookingdate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 110,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.data['arrivaldate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 80,
                    // margin: EdgeInsets.only(right: 20),
                    child: Text(
                      widget.data['type'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    height: 40,
                    width: 120,
                    margin: EdgeInsets.only(right: 15),
                    child: Center(
                      child: Text(
                        widget.data['shipcmpany'].toString(),
                        softWrap: true,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    )),
                InkWell(
                  onTap: () {
                    var id = widget.data['id'].toString();
                    var itemimage = widget.data['pickupitemimage'].toString();
                    var itemimage1 = widget.data['pickupitemimage1'].toString();
                    var comment = widget.data['pickupcomment'].toString();
                    var comment1 = widget.data['pickupcomment1'].toString();

                    var type = widget.data['type'].toString();
                    var bookingdate = widget.data['bookingdate'].toString();
                    var status = widget.data['status'].toString();

                    print(id);
                    print(itemimage);
                    print(itemimage1);
                    print(comment);
                    print(comment1);
                    print(type);
                    print(bookingdate);
                    print(status);
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
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 20),
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
