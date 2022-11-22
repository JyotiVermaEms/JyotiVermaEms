import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Provider/Provider.dart';

import 'package:shipment/component/Res_Client/ResMarketPlaceBooking.dart';
import 'package:shipment/constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/itemmodel.dart';

class BookingOrderReview extends StatefulWidget {
  var data;
  BookingOrderReview(this.data);

  // const BookingOrderReview({Key? key}) : super(key: key);

  @override
  _BookingOrderReviewState createState() => _BookingOrderReviewState();
}

class _BookingOrderReviewState extends State<BookingOrderReview> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

  var data;
  DateTime _startDate = DateTime.now();
  List<String> imgList = [];

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    data = widget.data;
    print("data  $data");
    temp.add(widget.data['category']);
    print('object ${jsonDecode(widget.data['category'])}');
    imgList.add(widget.data['image']);
  }

  List temp = [];

  createMarketPlace() async {
    var marketPlaceData = {
      "title": "${widget.data['title']}",
      "category": (widget.data['category']),
      "pickup_location": widget.data['Pickuplocation'].toString(),
      "dropoff_location": widget.data['dropofflocation'].toString(),
      "delivery_days": widget.data['deliverdays'].toString(),
      // "items": widget.data['numberItems'].toString(),
      "item_image":
          widget.data['image'] == null ? "" : widget.data['image'].toString(),
      "booking_price": (widget.data['bookingPrice']).toString(),
      "dropoff": widget.data['pickup_dropoff'].toString(),
      "description": widget.data['bookingSummary'].toString(),
      "needs": widget.data['additionNotes'].toString(),
      "status": "created",
      "booking_date": _startDate.toString()
    };
    print("jjjjjjdddddddd" + marketPlaceData.toString());
    imgList.add((widget.data['image']));

    var responce = await Providers().marketPlace(marketPlaceData);

    if (responce.status == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResMarketPlaceBooking()),
      );
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
          color: Color(0xffF5F6F8),
          child: SafeArea(
              right: false,
              child: Column(children: [
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
                          'Market Place > Project overview',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                processTimeline5(),
                (Responsive.isDesktop(context))
                    ? bookingReview()
                    : mobilebookingReview(),
                // buttons(),
              ])),
        ));
  }

  Widget buttons() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            height: 60,
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Colors.black),
                color: Color(0xffFFFFFF)),
            child: Center(
                child: Text("Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ))),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            createMarketPlace();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => ResMarketPlacedetails()));
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Color(0xff1F2326)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                    // width: MediaQuery.of(context).size.width * 0.8,
                    // color: Colors.lime,
                    child: Center(
                        child: Text("Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 30),
                  height: 30,
                  // width: 300,
                  child: Image.asset('assets/images/arrow-right.png'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bookingReview() {
    return Expanded(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              // height: 80,
              width: w,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffE5E5E5),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                width: 280,
                                child: Text(
                                  "Orders placed",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                width: 280,
                                child: Text(
                                  DateFormat.yMMMEd()

                                      // displaying formatted date
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                                width: 260,
                                margin: EdgeInsets.only(right: 0, top: 10),
                                child: Text(
                                  "Title",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: 280,
                                margin: EdgeInsets.only(
                                    right: 0, top: 10, bottom: 10),
                                child: Text(
                                  widget.data['title'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        // SizedBox(
                        //   width: 70,
                        // ),
                        Column(
                          children: [
                            Container(
                                width: 280,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Total (\$)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: 280,
                                child: Text(
                                  widget.data['bookingPrice'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Ship To",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                width: 150,
                                child: Text(
                                  widget.data['dropofflocation'].toString(),
                                  softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(children: [
                      secondRow(),
                    ]),
                  ),
                  buttons(),
                ],
              ),
            );
          }),
    );
  }

  Widget mobilebookingReview() {
    return Expanded(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            print("-=-=- ${widget.data['image']}");
            print("--categoryData---");
            print(jsonDecode(widget.data['category']));

            var categoryData = jsonDecode(widget.data['category']);
            var imageData = jsonDecode(widget.data['image']);
            return Container(
              // height: 80,
              width: w,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffE5E5E5),
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "Orders placed",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 10, bottom: 10),
                                child: Text(
                                  DateFormat.yMMMEd()

                                      // displaying formatted date
                                      .format(DateTime.now())
                                      .toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 0, top: 10),
                                child: Text(
                                  "Title",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(
                                    right: 0, top: 10, bottom: 10),
                                child: Text(
                                  widget.data['title'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        // SizedBox(
                        //   width: 70,
                        // ),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Total (\$)",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  widget.data['bookingPrice'].toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  "Ship To",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  widget.data['dropofflocation'].toString(),
                                  softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Category",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  Container(
                    // height: 300,
                    // width: 200,

                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryData.length,
                        // itemCount: dataList.length,
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   crossAxisCount: 1,
                        //   // mainAxisSpacing: 0.01,
                        //   childAspectRatio: 1.1,
                        //   // childAspectRatio: 0.1
                        // ),
                        itemBuilder: (context, index1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(

                                      // color: Colors.red,
                                      width: 220,
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                        top: 10,
                                        left: 20,
                                      ),
                                      child: Text(
                                        categoryData[index1]['categoryItem'],
                                        softWrap: true,
                                      )),
                                ]),
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Item Name & Quantity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  Container(
                    // height: 300,
                    // width: 300,

                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryData.length,
                        // itemCount: dataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: 350,
                                          // height: 200,
                                          margin: EdgeInsets.only(
                                            left: 20,
                                          ),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: List.generate(
                                                categoryData[index1]
                                                        ['booking_attribute']
                                                    .length,
                                                (index) => Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        categoryData[index1][
                                                                'booking_attribute']
                                                            [index],
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        // color: Colors.red,
                                                        // width: 80,
                                                        margin: EdgeInsets.only(
                                                            left: 10, top: 8),
                                                        child: Center(
                                                          child: Text(
                                                            categoryData[index1]
                                                                ['quantity'],
                                                            softWrap: true,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ]),
                          );
                        }),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "Image",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  SizedBox(
                    width: 360,
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageData!.length,
                        itemBuilder: (context, index1) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image.network(
                                imageData![index1],
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          );
                        }),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Text(
                              "Description",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            width: 900,
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.data['bookingSummary'].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Requirement",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Container(
                            width: 900,
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Center(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.data['additionNotes'].toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )),
                      ]),
                  buttons(),
                ],
              ),
            );
          }),
    );
  }

  Widget secondRow() {
    print("-=-=- ${widget.data['image']}");
    print("--categoryData---");
    print(jsonDecode(widget.data['category']));

    var categoryData = jsonDecode(widget.data['category']);
    var imageData = jsonDecode(widget.data['image']);
    return Container(
      margin: EdgeInsets.only(left: 10, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      width: 200,
                      child: Text(
                        "Category",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(left: 10, top: 10),
                      width: 340,
                      child: Text(
                        "Item Name",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 180,
                      child: Text(
                        "Quantity",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 300,
                      child: Center(
                        child: Text(
                          "Image",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )),
                ]),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // height: 300,
                    width: 200,

                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryData.length,
                        // itemCount: dataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(

                                      // color: Colors.red,
                                      width: 220,
                                      margin: EdgeInsets.only(
                                        bottom: 10,
                                        top: 10,
                                        left: 15,
                                      ),
                                      child: Text(
                                        categoryData[index1]['categoryItem'],
                                        softWrap: true,
                                      )),
                                ]),
                          );
                        }),
                  ),
                  Container(
                    // height: 300,
                    width: 300,

                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryData.length,
                        // itemCount: dataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 400,
                                      // height: 200,
                                      margin: EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: List.generate(
                                            categoryData[index1]
                                                    ['booking_attribute']
                                                .length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                categoryData[index1]
                                                        ['booking_attribute']
                                                    [index],
                                                softWrap: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                ]),
                          );
                        }),
                  ),
                  Container(
                    // height: 300,
                    width: 180,

                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: categoryData.length,
                        // itemCount: dataList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index1) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      // color: Colors.red,
                                      // width: 80,
                                      margin: EdgeInsets.only(left: 65, top: 8),
                                      child: Center(
                                        child: Text(
                                          categoryData[index1]['quantity'],
                                          softWrap: true,
                                        ),
                                      )),
                                ]),
                          );
                        }),
                  ),
                  SizedBox(
                    width: 360,
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageData!.length,
                        itemBuilder: (context, index1) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Image.network(
                                imageData![index1],
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          );
                        }),
                  )
                ]),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: 900,
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.data['bookingSummary'].toString(),
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Requirement",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                Container(
                    width: 900,
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.data['additionNotes'].toString(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ]),
        ],
      ),
    );
  }

  Widget processTimeline5() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
                color: Color(0xff4CAF50),
              ),
              child: Container(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Overview",
                style: TextStyle(
                    color: Color(0xff4CAF50),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Color(0xff4CAF50),
              thickness: 2,
              height: 30,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Pricing",
                  style: TextStyle(
                      color: Color(0xff4CAF50),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Color(0xff4CAF50),
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Gallery",
                  style: TextStyle(
                      color: Color(0xff4CAF50),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Description",
                  style: TextStyle(
                      color: Color(0xff4CAF50),
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                    'Requirement',
                    style: TextStyle(
                        color: Color(0xff4CAF50),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ))),
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xff4CAF50)),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.edit,
                    color: Color(0xff4CAF50),
                    size: 20,
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  child: Center(
                      child: Text(
                    'Review',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ))),
            ],
          ),
        ],
      ),
    );
  }
}
