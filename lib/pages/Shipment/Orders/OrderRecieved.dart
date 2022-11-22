import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Accountant/accountantUpdateProfileModel.dart';
import 'package:shipment/Model/Shipment/getShipmentConfirmOrderModel.dart';

import 'package:shipment/Provider/Provider.dart';

import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/Orders/bookingClientInfo.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class OrderRecieved extends StatefulWidget {
  const OrderRecieved({
    Key? key,
  }) : super(key: key);

  @override
  _OrderRecievedState createState() => _OrderRecievedState();
}

class _OrderRecievedState extends State<OrderRecieved>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

  TextEditingController datefilter = new TextEditingController();
  List<ConfirmOrder>? brdata;
  late TabController tabController;
  TextEditingController _textFieldController = TextEditingController();

  String? bookingId;
  var _currentIndex = 0;
  Duration? diff;
  var id;
  var imgList;
  bool isProcess = false;
  DateTime initialDate = DateTime.now();
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;
      });
    builder:
    (context, child) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 100,
              width: 100,
              child: child,
            ),
          ),
        ],
      );
    };
  }

  acceptedOrder() async {
    var Data = {"booking_id": id.toString(), "status": "1"};
    var response = await Providers().getAcceptedOrder(Data);
    if (response.status == true) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.SHIPMENTORDERROUTE),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  getCnfirmbookings() async {
    setState(() {
      isProcess = true;
    });
    print("in getCnfirmbookings");
    var response = await Providers().getshipmentconfirmBookings();
    setState(() {
      brdata = response.data;
    });
    var bookItem = [];
    // imgList = [];
    print("brdata ${brdata!.length}");

    for (int i = 0; i < brdata!.length; i++) {
      print("in for loop ${brdata![i].bookingItem.length}");
      bookingId = brdata![i].id.toString();

      //print("--->>>> ${brdata![i].bookingItem}");
      if (brdata![i].bookingItem != "[]") {
        for (int ii = 0; ii < brdata![i].bookingItem.length; ii++) {
          //print("-=-=-=>>>> ${brdata![i].bookingItem[ii].itemImage}");
          // print("-=-=-=>>>> ${brdata![i].bookingItem[ii].itemImage.length}");
        }
        setState(() {
          isProcess = false;
        });
      }
    }

    setState(() {});
    // print("imgList-=-=-=->>> api $imgList");

    // print(bookingId!.toString());
  }

  @override
  void initState() {
    super.initState();
    getCnfirmbookings();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
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
          ? Container(
              height: 10,
              width: 10,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                  color: Color(0xffF5F6F8),
                  child: SafeArea(
                      right: false,
                      child: Column(
                        children: [
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
                                if (Responsive.isDesktop(context))
                                  SizedBox(width: 5),
                                Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Order',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!Responsive.isDesktop(context))
                            Column(
                              children: [
                                brdata!.length == 0
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
                                            decoration:
                                                linearGradientForWhiteCard(),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 15),
                                                Text(
                                                  'Sorry, You have not any Booking Request yet',
                                                  style: headingStyle16MB(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : ordermobile()
                              ],
                            ),
                          if (Responsive.isDesktop(context))
                            brdata!.length == 0
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
                                        decoration:
                                            linearGradientForWhiteCard(),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Text(
                                              'Sorry, You have not any Booking Request yet',
                                              style: headingStyle16MB(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : order()
                        ],
                      ))),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {},
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
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: (Responsive.isDesktop(context))
                ? 136
                : MediaQuery.of(context).size.width * (40 / 100),
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.teal, width: 2.0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (DateFormat.yMd().format(initialDate).toString()),
                    style: headingStyle12blacknormal(),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate1(context);
                      datefilter.text =
                          (DateFormat.yMd().format(initialDate).toString());
                    },
                    child: Container(
                      // margin: EdgeInsets.only(left: 45, top: 5),
                      height: 20,
                      width: 20,
                      child: ImageIcon(
                        AssetImage(
                          "images/menu-board.png",
                        ),
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget order() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: brdata!.length,
        shrinkWrap: true,
        reverse: false,
        itemBuilder: (context, index) {
          return brdata!.length == 0
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
                          border:
                              Border.all(width: 0.5, color: Color(0xffACACAC)),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE5E5E5),
                        ),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 15, top: 10),
                                    width: 200,
                                    child: Text(
                                      "Orders placed",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    width: 200,
                                    child: Text(
                                      brdata![index].createdAt.substring(0, 10),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 200,
                                    child: Text(
                                      brdata![index].totalAmount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 400,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Ship To",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 400,
                                    child: Text(
                                      brdata![index].to.toLowerCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(right: 0, top: 10),
                                    child: Text(
                                      "Order ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(
                                        right: 0, top: 10, bottom: 10),
                                    child: Text(
                                      brdata![index].id.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              height: 250,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                              ),
                              margin:
                                  EdgeInsets.only(top: 10, right: 10, left: 0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: brdata![index].bookingItem.length,
                                  itemBuilder: (context, index1) {
                                    print("-=-=-");
                                    print(brdata![index]
                                        .bookingItem[index1]
                                        .itemImage
                                        .length);
                                    return brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .length >
                                            0
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              autoPlay: true,
                                            ),
                                            items: brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .map<Widget>((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                brdata![index]
                                                                    .bookingItem[
                                                                        index1]
                                                                    .itemImage);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          child: Image.network(
                                                            item,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Image.asset(
                                            "assets/images/cars.png",
                                            fit: BoxFit.cover,
                                          );
                                  }),
                            ),
                            secondRow(index),
                            Spacer(),
                            thirdRow(index),
                          ],
                        ),
                      ),
                      Container(
                          height: 80,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Color(0xffACACAC)),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffE5E5E5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  width: 200,
                                  child: Text(
                                    "Estimated Delivery:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  width: 200,
                                  child: Text(
                                    brdata![index].arrivalDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )),
                    ],
                  ),
                );
        });
  }

  Widget ordermobile() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: brdata!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return brdata!.length == 0
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
                  width: w,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Color(0xffACACAC)),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE5E5E5),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 5, top: 10),
                                    width: 80,
                                    child: Text(
                                      "Orders placed",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 5, top: 10, bottom: 10),
                                    width: 80,
                                    child: Text(
                                      brdata![index].createdAt.substring(0, 10),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 80,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 80,
                                    child: Text(
                                      brdata![index].totalAmount.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 80,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Ship To",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 80,
                                    child: Text(
                                      brdata![index].to.toLowerCase(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 80,
                                    margin: EdgeInsets.only(right: 0, top: 10),
                                    child: Text(
                                      "Order ID",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: 80,
                                    margin: EdgeInsets.only(
                                        right: 0, top: 10, bottom: 10),
                                    child: Text(
                                      brdata![index].id.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                              ),
                              margin:
                                  EdgeInsets.only(top: 10, right: 5, left: 0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: brdata![index].bookingItem.length,
                                  itemBuilder: (context, index1) {
                                    print("-=-=-");
                                    print(brdata![index]
                                        .bookingItem[index1]
                                        .itemImage
                                        .length);
                                    return brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .length >
                                            0
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              autoPlay: true,
                                            ),
                                            items: brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .map<Widget>((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                brdata![index]
                                                                    .bookingItem[
                                                                        index1]
                                                                    .itemImage);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          height: 150,
                                                          width: 300,
                                                          child: Image.network(
                                                            item,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Image.asset(
                                            "assets/images/cars.png",
                                            fit: BoxFit.cover,
                                          );
                                  }),
                            ),
                            secondRowMob(index),
                            thirdRowmobile(index),
                          ],
                        ),
                      ),
                      Container(
                          height: 80,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Color(0xffACACAC)),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffE5E5E5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, left: 15),
                                  width: 120,
                                  child: Text(
                                    "Estimated Delivery:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: 120,
                                  child: Text(
                                    brdata![index].arrivalDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )),
                    ],
                  ),
                );
        });
  }

  Widget secondRowMob(int index) {
    return Container(
      width: w * 0.50,
      height: h * 0.30,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color(0xffE6E7E8)),
                  margin: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  child: Center(
                    child: Text(
                      brdata![index].bookingDate.toString(),
                      style: TextStyle(
                          color: Color(0xff1A494F),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 40,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        "Title:",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: 100,
                      height: 40,
                      margin: EdgeInsets.only(top: 15),
                      child: Text(
                        brdata![index].title,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),

                  // Spacer(),
                  //
                ],
              ),
              Container(
                // height: 300,

                width: w * 0.5,
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: brdata![index].bookingItem.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index1) {
                      var jsondata =
                          brdata![index].bookingItem[index1].itemName;
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: 83,
                                  margin: EdgeInsets.only(left: 5, top: 20),
                                  child: Text(
                                    brdata![index].bookingItem[index1].category,
                                    softWrap: true,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, top: 10),
                                child: Container(
                                  height: 40,
                                  width: w * 0.7,
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    child: ListView(
                                      addRepaintBoundaries: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        Row(
                                            children: List.generate(
                                          jsondata.length,
                                          (index) => Row(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                jsondata[index].itemname + ",",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 7, 10, 7),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      );
                    }),
              ),
              Container(

                  // height: 100,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "Description",
                    softWrap: true,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              for (int i = 0; i < brdata![index].bookingItem.length; i++)
                Container(
                    height: h * 0.09,
                    width: w * 0.3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        brdata![index].bookingItem[i].description,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  Widget secondRow(int index) {
    return Container(
      width: w * 0.38,
      height: 300,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 90,
                    height: 40,
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      "Title :  ",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: 100,
                    height: 40,
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      brdata![index].title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
                Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color(0xffE6E7E8)),
                    margin: EdgeInsets.only(left: 15, top: 15),
                    child: Center(
                      child: Text(
                        brdata![index].bookingDate.toString(),
                        style: TextStyle(
                            color: Color(0xff1A494F),
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                // Spacer(),
                //
              ],
            ),
            Container(
              // height: 300,

              width: w * 0.38,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: brdata![index].bookingItem.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index1) {
                    var jsondata = brdata![index].bookingItem[index1].itemName;
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 83,
                                margin: EdgeInsets.only(left: 5, top: 20),
                                child: Text(
                                  brdata![index].bookingItem[index1].category,
                                  softWrap: true,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              child: Row(
                                  children: List.generate(
                                jsondata.length,
                                (index) => Row(children: [
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
                    );
                  }),
            ),
            Container(

                // height: 100,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Description",
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )),
            for (int i = 0; i < brdata![index].bookingItem.length; i++)
              InkWell(
                onTap: () {},
                child: Container(
                    width: 400,
                    child: SingleChildScrollView(
                      child: Text(
                        brdata![index].bookingItem[i].description,
                        softWrap: true,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }

  Widget dialogContent(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(left: 0.0, right: 0.0),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              width: w / 2,
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              margin: EdgeInsets.only(top: 13.0, right: 8.0),
              decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: new Text(text.toString(),
                            style: TextStyle(color: Colors.black)),
                      ) //
                          ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late StateSetter _setState;

  Widget thirdRow(int index) {
    var splitDate = brdata![index].expiredAt;
    var splitDate1 = brdata![index].currentDateTime;
    var secSplit = splitDate;
    var secSplit1 = splitDate1;

    DateTime dateTimeExpiredAt = DateTime.parse(secSplit);
    log("Expiredate--------${dateTimeExpiredAt.toString()}"); //2022-04-09 00:00:00.000
    DateTime dateTimeNow = DateTime.parse(secSplit1);
    log("Currentdatetttttttttttime-----${dateTimeNow.toString()}"); //2022-04-09 15:04:26.612

    final differenceInDays = dateTimeExpiredAt.difference(dateTimeNow).inDays;
    print('-=-=-=-=- $differenceInDays');

    DateTime dt1 = DateTime.parse(dateTimeExpiredAt.toString());
    DateTime dt2 = DateTime.parse(dateTimeNow.toString());

    Duration diff = dt1.difference(dt2);

    print(diff.inDays);

    print(diff.inHours);

    print(diff.inMinutes);

    print(diff.inSeconds);
    var days;
    var hours;
    var mints;
    var secs;
    days = diff.inDays;
    hours = diff.inHours.remainder(24);
    mints = diff.inMinutes.remainder(60);
    secs = diff.inSeconds.remainder(60);
    print("ppppppppppppppp$hours");
    print("ppppppppppppppp$mints");
    print("ppppppppppppppp$secs");

    Duration duration = Duration(hours: hours, minutes: mints, seconds: secs);
    Timer? timer;

    void startTimer() {
      var splitDate;

      timer = Timer.periodic(Duration(seconds: 1), (_) {
        var reduceSecondsBy = 1;

        var seconds = duration.inSeconds - reduceSecondsBy;

        _setState(() {
          if (seconds < 0) {
            timer!.cancel();
          } else {
            duration = Duration(seconds: seconds);
          }
        });
      });
    }

    void stopTimer() {
      _setState(() => timer!.cancel());
    }

    void resetTimer() {
      stopTimer();
      setState(() => duration = Duration(seconds: 1));
    }

    Widget cancelButton = InkWell(
      child: Container(
          height: 40,
          width: 100,
          margin: EdgeInsets.only(left: 50, bottom: 15),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.white),
          child: Center(
            child: Text(
              "Cancel",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          )),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    Widget ok1Button = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
        // acceptedOrder();
      },
    );
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        acceptedOrder();
      },
    );

    Widget continueButton = InkWell(
      child: Container(
          height: 40,
          width: 200,
          margin: EdgeInsets.only(left: 15, bottom: 15, right: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0), color: Colors.green),
          child: Center(
            child: Text(
              "Accept",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Are you sure you want to Accept?"),
              actions: [
                okButton,
                ok1Button,
              ],
            );
          },
        );
      },
    );

    AlertDialog alert = AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          color: Color(0xffE5E5E5), // red as border color
        ),
        height: h * 2,
        width: w * 0.8,
        child: Column(children: [
          DefaultTabController(
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
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Container(
            height: h * 0.65,
            width: w * 0.78,
            child: TabBarView(controller: tabController, children: [
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
                child: Column(children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(15, 0, 50, 0),
                    child: Text(
                      'Schedule Title : ' + brdata![index].title.toString(),
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
                      left: 10,
                      right: 10,
                    ),
                    child: Divider(
                      height: 30,
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: w * 0.75,
                        height: h * 0.50,
                        child: ListView.builder(
                            itemCount: brdata![index].bookingItem.length,
                            reverse: false,
                            itemBuilder: (context, index1) {
                              var jsondata =
                                  brdata![index].bookingItem[index1].itemName;

                              print(
                                  "TTTTTTTTT${brdata![index].bookingItem[index1].itemName}");
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
                                              child: brdata![index]
                                                          .bookingItem[index1]
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
                                                          setState(() {});
                                                        },
                                                      ),
                                                      items: brdata![index]
                                                          .bookingItem[index1]
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
                                                                              brdata![index].bookingItem[index1].itemImage);
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              height: 150,
                                              width: 150,
                                            ),
                                            SizedBox(
                                                width: kDefaultPadding / 2),
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
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Text(
                                                      brdata![index]
                                                          .bookingItem[index1]
                                                          .category
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                Row(
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
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                )),
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Text(
                                                              brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .description
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Colors
                                                                      .black,
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
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
                child: Column(children: [
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 30),
                            child: Container(
                              height: 280,
                              width: 350,
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                color: Color(0xffFFFFFF),
                              ),
                              margin:
                                  EdgeInsets.only(top: 10, right: 10, left: 0),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: brdata![index].bookingItem.length,
                                  itemBuilder: (context, index1) {
                                    print("-=-=-");
                                    print(brdata![index]
                                        .bookingItem[index1]
                                        .itemImage
                                        .length);
                                    return brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .length >
                                            0
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              //enlargeCenterPage: true,
                                              //enableInfiniteScroll: false,
                                              autoPlay: true,
                                            ),
                                            items: brdata![index]
                                                .bookingItem[index1]
                                                .itemImage
                                                .map<Widget>((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                brdata![index]
                                                                    .bookingItem[
                                                                        index1]
                                                                    .itemImage);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          //color: Colors.amber,
                                                          child: Image.network(
                                                            item,
                                                          ),
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Image.asset(
                                            "assets/images/cars.png",
                                            fit: BoxFit.cover,
                                          );
                                  }),
                            ),
                          ),
                        ]),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                            child: Container(
                          // height: 350,
                          child: Column(
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Order Type",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupType
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Location",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupLocation
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Date",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupDate
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Time",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupTime
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Distance",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupDistance
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Estimate",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupEstimate
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Transaction Id",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 400,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index].transactionId.toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ))
                      ],
                    ),
                  )
                ]),
              ),
              Container(
                  child: Padding(
                padding: const EdgeInsets.only(left: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: 80,
                          child: Text(
                            "Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          height: 50,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: Text(
                                  brdata![index]
                                      .receptionistInfo[0]
                                      .receptionistName
                                      .toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: 80,
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          height: 50,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                brdata![index]
                                    .receptionistInfo[0]
                                    .receptionistEmail
                                    .toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          child: Text(
                            "Address",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          height: 80,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                brdata![index]
                                    .receptionistInfo[0]
                                    .receptionistAddress
                                    .toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          child: Text(
                            "Country",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          height: 80,
                          width: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                brdata![index]
                                    .receptionistInfo[0]
                                    .receptionistCountry
                                    .toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ))
            ]),
          )
        ]),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return Column(
      children: [
        InkWell(
          onTap: () {
            var data = {
              'id': brdata![index].client[0].id.toString(),
              'name': brdata![index].client[0].name.toString(),
              'lname': brdata![index].client[0].lname.toString(),
              'email': brdata![index].client[0].email.toString(),
              'phone': brdata![index].client[0].phone.toString(),
              'address': brdata![index].client[0].address.toString(),
              'country': brdata![index].client[0].country.toString(),
              'profileimage': brdata![index].client[0].profileimage.toString(),
            };
            print("NNNNNNNNNNNNN$data");
            print("NNNNNNNNNNNNN$data");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientDetails(data)),
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Client Details",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        InkWell(
            onTap: () {
              showDialog(
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    startTimer();
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.only(
                          left: 100,
                          // top: 250,
                          top: 80),
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        // content: summaryBox(h, m, s),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          String strDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          var days = strDigits(duration.inDays);

                          var hours = strDigits(duration.inHours.remainder(24));
                          var minutes =
                              strDigits(duration.inMinutes.remainder(60));
                          var seconds =
                              strDigits(duration.inSeconds.remainder(60));
                          _setState = setState;

                          return Container(
                            height:
                                MediaQuery.of(context).size.height * (30 / 100),
                            width: (Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (38 / 100)
                                : MediaQuery.of(context).size.width *
                                    (90 / 100),
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFFFFF),
                            ),
                            child: ListView(
                              children: [
                                InkWell(
                                  onTap: () {
                                    //print("-=-=- $seconds");
                                    // stopTimer();

                                    Navigator.of(context).pop();
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Icon(
                                        Icons.close,
                                        color: Color(0xffC4C4C4),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Remaining Time',
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    right: 30,
                                  ),
                                  child: Align(
                                    child: Text(
                                      // '$h:$m:$s',
                                      '$hours:$minutes:$seconds',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 50),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  });
            },
            child: Container(
                width: 120,
                height: 120,
                child: Image.asset("assets/images/reminder.gif"))),
        GestureDetector(
          onTap: () {
            var data = {
              'id': brdata![index].id.toString(),
              'bookingdate': brdata![index].bookingDate.toString(),
              'arrivaldate': brdata![index].arrivalDate.toString(),
              'type': brdata![index].bookingType.toString(),
              'shipcmpany': brdata![index].shipmentCompany.toString(),
            };
            setState(() {
              id = brdata![index].id.toString();
            });
            print("kkkkkkkkkkkkkkkkkk" + id);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Accept Booking",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        InkWell(
          onTap: () {
            GlobalKey<FormState> _formkey = GlobalKey<FormState>();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  content: Form(
                    key: _formkey,
                    child: Container(
                        height: 180.0,
                        width: 400.0,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("Are you sure you want to reject?")),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 120,
                            width: 400,
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Required";
                                }
                              },
                              maxLength: 150,
                              maxLines: 6,
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: "Enter Reason",
                              ),
                            ),
                          ),
                        ])),
                  ),
                  actions: [
                    cancelButton,
                    InkWell(
                      child: Container(
                          height: 40,
                          width: 100,
                          margin: EdgeInsets.only(bottom: 15, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Color(0xff1A494F)),
                          child: Center(
                              child: Text("Reject",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))),
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          var Data = {
                            "booking_id": brdata![index].id.toString(),
                            "status": "0",
                            "reason": _textFieldController.text
                          };
                          print("Data-=-= $Data");
                          //return;
                          var response =
                              await Providers().getAcceptedOrder(Data);
                          if (response.status == true) {
                            // setState(() {
                            //   MaterialPageRoute(builder: (context) => Order());
                            // });
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Text(response.message),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, Routes.SHIPMENTDASHBOARD),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  border: Border.all(width: 0.5, color: Color(0xffACACAC)),
                  color: Color(0xffFFFFFF)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Reject",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }

  Widget thirdRowmobile(int index) {
    var splitDate = brdata![index].expiredAt;
    var splitDate1 = brdata![index].currentDateTime;
    var secSplit = splitDate;
    var secSplit1 = splitDate1;

    DateTime dateTimeExpiredAt = DateTime.parse(secSplit);
    log("Expiredate--------${dateTimeExpiredAt.toString()}"); //2022-04-09 00:00:00.000
    DateTime dateTimeNow = DateTime.parse(secSplit1);
    log("Currentdatetttttttttttime-----${dateTimeNow.toString()}"); //2022-04-09 15:04:26.612

    final differenceInDays = dateTimeExpiredAt.difference(dateTimeNow).inDays;
    print('-=-=-=-=- $differenceInDays');

    DateTime dt1 = DateTime.parse(dateTimeExpiredAt.toString());
    DateTime dt2 = DateTime.parse(dateTimeNow.toString());

    Duration diff = dt1.difference(dt2);

    print(diff.inDays);

    print(diff.inHours);

    print(diff.inMinutes);

    print(diff.inSeconds);
    var days;
    var hours;
    var mints;
    var secs;
    days = diff.inDays;
    hours = diff.inHours.remainder(24);
    mints = diff.inMinutes.remainder(60);
    secs = diff.inSeconds.remainder(60);
    print("ppppppppppppppp$hours");
    print("ppppppppppppppp$mints");
    print("ppppppppppppppp$secs");

    Duration duration = Duration(hours: hours, minutes: mints, seconds: secs);
    Timer? timer;

    void startTimer() {
      var splitDate;

      timer = Timer.periodic(Duration(seconds: 1), (_) {
        var reduceSecondsBy = 1;

        var seconds = duration.inSeconds - reduceSecondsBy;

        _setState(() {
          if (seconds < 0) {
            timer!.cancel();
          } else {
            duration = Duration(seconds: seconds);
          }
        });
      });
    }

    void stopTimer() {
      _setState(() => timer!.cancel());
    }

    void resetTimer() {
      stopTimer();
      setState(() => duration = Duration(seconds: 1));
    }

    Widget cancelButton = InkWell(
      child: Container(
          height: 30,
          width: 100,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.white),
          child: Center(
            child: Text("Cancel",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10)),
          )),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    Widget ok1Button = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
        // acceptedOrder();
      },
    );
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        acceptedOrder();
      },
    );

    Widget continueButton = InkWell(
      child: Container(
          height: 30,
          width: 100,
          margin: EdgeInsets.only(
            left: 5,
            right: 30,
            bottom: 5,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0), color: Colors.green),
          child: Center(
            child: Text(
              "Accept",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          )),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm"),
              content: Text("Are you sure you want to Accept?"),
              actions: [
                okButton,
                ok1Button,
              ],
            );
          },
        );
      },
    );

    AlertDialog alert = AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          color: Color(0xffE5E5E5), // red as border color
        ),
        width: w * 0.98,
        child: ListView(children: [
          Column(children: [
            DefaultTabController(
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
                        "Booking Details",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: new Tab(
                      child: Text(
                        "Pickup / Dropoff Details",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  new Tab(
                    child: Container(
                      width: 200,
                      child: Text(
                        "Receptionist Info",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              height: h * 0.65,
              width: w * 0.8,
              child: TabBarView(controller: tabController, children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
                  child: Column(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(15, 0, 50, 0),
                      child: Text(
                        'Schedule Title : ' + brdata![index].title.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                      ),
                      // Spacer(),
                    ),
                    ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            height: h * 0.2,
                            width:
                                MediaQuery.of(context).size.width * (99 / 100),
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
                                                margin: EdgeInsets.only(
                                                    left: 20, top: 10),
                                                child: Text(
                                                  "ID",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                width: 80,
                                                margin: EdgeInsets.only(
                                                    left: 20, top: 10),
                                                child: Text(
                                                  brdata![index].id.toString(),
                                                  //{widget.data['id']}.toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ]),
                                          Column(children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                width: 150,
                                                // margin: EdgeInsets.only(right: 70),
                                                child: Text(
                                                  "Booking Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                width: 100,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  brdata![index]
                                                      .bookingDate
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ]),
                                          Column(children: [
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                ),
                                                width: 150,
                                                // margin: EdgeInsets.only(right: 70),
                                                child: Text(
                                                  "Arrival Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                width: 150,
                                                margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                ),
                                                child: Text(
                                                  brdata![index]
                                                      .arrivalDate
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ]),
                                          Column(children: [
                                            Container(
                                                width: 150,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  "Type",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                width: 150,
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                  brdata![index]
                                                      .bookingType
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ]),
                                          Column(children: [
                                            Container(
                                                width: 120,
                                                margin: EdgeInsets.only(
                                                    right: 16, top: 10),
                                                child: Text(
                                                  "Company",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            Container(
                                                width: 120,
                                                margin: EdgeInsets.only(
                                                    right: 15, top: 10),
                                                child: Text(
                                                  brdata![index]
                                                      .shipmentCompany
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                )),
                                          ]),
                                        ]),
                                  ]),
                            ),
                          );
                        }),
                    Divider(
                      height: 30,
                      color: Colors.black,
                      thickness: 2,
                    ),
                    Expanded(
                      child: Container(
                          width: w * 0.80,
                          height: h * 0.50,
                          child: ListView.builder(
                              itemCount: brdata![index].bookingItem.length,
                              reverse: false,
                              itemBuilder: (context, index1) {
                                var jsondata =
                                    brdata![index].bookingItem[index1].itemName;

                                print(
                                    "TTTTTTTTT${brdata![index].bookingItem[index1].itemName}");
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
                                          (Responsive.isDesktop(context))
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      child: brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .itemImage
                                                                  .length !=
                                                              0
                                                          ? CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                enableInfiniteScroll:
                                                                    false,
                                                                autoPlay: true,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              items: brdata![
                                                                      index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .itemImage
                                                                  .map<Widget>(
                                                                      (item) =>
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return imageViewDialog(context, item, brdata![index].bookingItem[index1].itemImage);
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Padding(
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
                                                        width: kDefaultPadding /
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
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .category
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
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
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                        )),
                                                        Row(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Description : ",
                                                              style: TextStyle(
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
                                                            ),
                                                            child: Container(
                                                              height: 50,
                                                              width: 650,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                    brdata![index]
                                                                        .bookingItem[
                                                                            index1]
                                                                        .description
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w500)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Container(
                                                      child: brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .itemImage
                                                                  .length !=
                                                              0
                                                          ? CarouselSlider(
                                                              options:
                                                                  CarouselOptions(
                                                                enableInfiniteScroll:
                                                                    false,
                                                                autoPlay: true,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  setState(
                                                                      () {});
                                                                },
                                                              ),
                                                              items: brdata![
                                                                      index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .itemImage
                                                                  .map<Widget>(
                                                                      (item) =>
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return imageViewDialog(context, item, brdata![index].bookingItem[index1].itemImage);
                                                                                },
                                                                              );
                                                                            },
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: Container(
                                                                                height: h * 0.35,
                                                                                width: w * 0.80,
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
                                                        width: kDefaultPadding /
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
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .category
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                        Container(
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
                                                                    children: List
                                                                        .generate(
                                                                  jsondata
                                                                      .length,
                                                                  (index) => Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Text(
                                                                            jsondata[index].itemname +
                                                                                ",",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Container(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                7,
                                                                                10,
                                                                                7),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: Color(0xffEFEFEF)),
                                                                            child:
                                                                                Text(
                                                                              jsondata[index].qty,
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Row(children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Description : ",
                                                              style: TextStyle(
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
                                                            ),
                                                            child: Container(
                                                              height: h * 0.19,
                                                              width: w * 0.3,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Text(
                                                                      brdata![index]
                                                                          .bookingItem[
                                                                              index1]
                                                                          .description
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
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
                  ]),
                ),
                Container(
                  height: 800,
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                  child: ListView(children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Container(
                            height: 150,
                            width: 350,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                            ),
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 0),
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: brdata![index].bookingItem.length,
                                itemBuilder: (context, index1) {
                                  print("-=-=-");
                                  print(brdata![index]
                                      .bookingItem[index1]
                                      .itemImage
                                      .length);
                                  return brdata![index]
                                              .bookingItem[index1]
                                              .itemImage
                                              .length >
                                          0
                                      ? CarouselSlider(
                                          options: CarouselOptions(
                                            //enlargeCenterPage: true,
                                            //enableInfiniteScroll: false,
                                            autoPlay: true,
                                          ),
                                          items: brdata![index]
                                              .bookingItem[index1]
                                              .itemImage
                                              .map<Widget>((item) => InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return imageViewDialog(
                                                              context,
                                                              item,
                                                              brdata![index]
                                                                  .bookingItem[
                                                                      index1]
                                                                  .itemImage);
                                                        },
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        //color: Colors.amber,
                                                        child: Image.network(
                                                          item,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      : Image.asset(
                                          "assets/images/cars.png",
                                          fit: BoxFit.cover,
                                        );
                                }),
                          ),
                        ),
                        // SizedBox(
                        //   width: 40,
                        // ),
                        Container(
                            child: Container(
                          // height: 350,
                          child: Column(
                            children: [
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Order Type",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupType
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Location",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupLocation
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Date",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupDate
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Time",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupTime
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Distance",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupDistance
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Estimate",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        brdata![index]
                                            .pickupReview[0]
                                            .pickupEstimate
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              Row(children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 5),
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      "Transaction Id",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Container(
                                    height: 30,
                                    width: w * 0.32,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          brdata![index]
                                              .transactionId
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ]),
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Container(
                          width: 50,
                          child: Text(
                            "Name",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Container(
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                child: Text(
                                    brdata![index]
                                        .receptionistInfo[0]
                                        .receptionistName
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Container(
                          width: 50,
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Container(
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                brdata![index]
                                    .receptionistInfo[0]
                                    .receptionistEmail
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Container(
                          width: 50,
                          child: Text(
                            "Address",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Container(
                          height: 80,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                child: Text(
                                  brdata![index]
                                      .receptionistInfo[0]
                                      .receptionistAddress
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Container(
                          width: 50,
                          child: Text(
                            "Country",
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 5,
                        ),
                        child: Container(
                          height: 60,
                          width: 180,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                brdata![index]
                                    .receptionistInfo[0]
                                    .receptionistCountry
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ))
              ]),
            )
          ]),
        ]),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return Column(
      children: [
        InkWell(
          onTap: () {
            var data = {
              'id': brdata![index].client[0].id.toString(),
              'name': brdata![index].client[0].name.toString(),
              'lname': brdata![index].client[0].lname.toString(),
              'email': brdata![index].client[0].email.toString(),
              'phone': brdata![index].client[0].phone.toString(),
              'address': brdata![index].client[0].address.toString(),
              'country': brdata![index].client[0].country.toString(),
              'profileimage': brdata![index].client[0].profileimage.toString(),
            };
            print("NNNNNNNNNNNNN$data");
            print("NNNNNNNNNNNNN$data");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientDetails(data)),
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Center(
                child: Text(
                  "Client Details",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        InkWell(
            onTap: () {
              showDialog(
                  barrierColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    startTimer();
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.only(
                          left: 100,
                          // top: 250,
                          top: 10),
                      child: AlertDialog(
                        backgroundColor: Colors.white,
                        // content: summaryBox(h, m, s),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          String strDigits(int n) =>
                              n.toString().padLeft(2, '0');
                          var days = strDigits(duration.inDays);

                          var hours = strDigits(duration.inHours.remainder(24));
                          var minutes =
                              strDigits(duration.inMinutes.remainder(60));
                          var seconds =
                              strDigits(duration.inSeconds.remainder(60));
                          _setState = setState;

                          return Container(
                            height:
                                MediaQuery.of(context).size.height * (20 / 100),
                            width: (Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (38 / 100)
                                : MediaQuery.of(context).size.width *
                                    (90 / 100),
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFFFFF),
                            ),
                            child: ListView(
                              children: [
                                InkWell(
                                  onTap: () {
                                    //print("-=-=- $seconds");
                                    // stopTimer();

                                    Navigator.of(context).pop();
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Icon(
                                        Icons.close,
                                        color: Color(0xffC4C4C4),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 20,
                                    ),
                                    child: Text(
                                      'Remaining Time',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 30,
                                    right: 30,
                                  ),
                                  child: Align(
                                    child: Text(
                                      // '$h:$m:$s',
                                      '$hours:$minutes:$seconds',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  });
            },
            child: Container(
                width: 120,
                height: 120,
                child: Image.asset("assets/images/reminder.gif"))),
        GestureDetector(
          onTap: () {
            var data = {
              'id': brdata![index].id.toString(),
              'bookingdate': brdata![index].bookingDate.toString(),
              'arrivaldate': brdata![index].arrivalDate.toString(),
              'type': brdata![index].bookingType.toString(),
              'shipcmpany': brdata![index].shipmentCompany.toString(),
            };
            setState(() {
              id = brdata![index].id.toString();
            });
            print("kkkkkkkkkkkkkkkkkk" + id);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Accept Booking",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        InkWell(
          onTap: () {
            GlobalKey<FormState> _formkey = GlobalKey<FormState>();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm"),
                  content: Form(
                    key: _formkey,
                    child: Container(
                        height: 180.0,
                        width: 400.0,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.bottomLeft,
                              child: Text("Are you sure you want to reject?")),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 120,
                            width: 400,
                            child: TextFormField(
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Required";
                                }
                              },
                              maxLength: 150,
                              maxLines: 6,
                              controller: _textFieldController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hintText: "Enter Reason",
                              ),
                            ),
                          ),
                        ])),
                  ),
                  actions: [
                    cancelButton,
                    InkWell(
                      child: Container(
                          height: 40,
                          width: 100,
                          margin: EdgeInsets.only(bottom: 15, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Color(0xff1A494F)),
                          child: Center(
                              child: Text("Reject",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)))),
                      onTap: () async {
                        if (_formkey.currentState!.validate()) {
                          var Data = {
                            "booking_id": brdata![index].id.toString(),
                            "status": "0",
                            "reason": _textFieldController.text
                          };
                          print("Data-=-= $Data");
                          //return;
                          var response =
                              await Providers().getAcceptedOrder(Data);
                          if (response.status == true) {
                            // setState(() {
                            //   MaterialPageRoute(builder: (context) => Order());
                            // });
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                content: Text(response.message),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                        context, Routes.SHIPMENTDASHBOARD),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
              height: 40,
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  border: Border.all(width: 0.5, color: Color(0xffACACAC)),
                  color: Color(0xffFFFFFF)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Reject",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }

  Widget orderTemplate() {
    return Container(
        height: 80,
        width: MediaQuery.of(context).size.width * (95 / 100),
        margin: (Responsive.isDesktop(context))
            ? EdgeInsets.fromLTRB(15, 15, 15, 0)
            : EdgeInsets.fromLTRB(5, 5, 5, 0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: (Responsive.isDesktop(context))
            ? Row(
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
                      child: Text(
                        "Booking Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

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
                ],
              )
            : Scrollbar(
                isAlwaysShown: true,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 40,
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "ID",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          )),
                      // Spacer(),
                      Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 100,
                          child: Text(
                            "Booking Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )),

                      Container(
                          margin: EdgeInsets.only(top: 5),
                          width: 100,
                          // margin: EdgeInsets.only(right: 70),
                          child: Text(
                            "Arrival Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )),

                      Container(
                          width: 100,
                          child: Text(
                            "Type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )),
                      Container(
                          width: 120,
                          margin: EdgeInsets.only(right: 16),
                          child: Text(
                            "Company",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          )),
                    ],
                  ),
                ]),
              ));
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
              height: (Responsive.isDesktop(context)) ? 80 : 60,
              width: (Responsive.isDesktop(context))
                  ? MediaQuery.of(context).size.width * (98 / 100)
                  : MediaQuery.of(context).size.width * (50 / 100),
              margin: (Responsive.isDesktop(context))
                  ? EdgeInsets.fromLTRB(15, 0, 15, 0)
                  : EdgeInsets.fromLTRB(5, 0, 5, 0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: (Responsive.isDesktop(context))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: 40,
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              brdata![index].id.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              brdata![index].bookingDate.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                        Container(
                            width: 120,
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              brdata![index].arrivalDate.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                        Container(
                            width: 100,
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              brdata![index].bookingType.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                        Container(
                            width: 120,
                            margin: EdgeInsets.only(right: 15),
                            child: Text(
                              brdata![index].shipmentCompany.toString(),
                              softWrap: true,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )),
                      ],
                    )
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 40,
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                brdata![index].id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                brdata![index].bookingDate.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 120,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                brdata![index].arrivalDate.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                brdata![index].bookingType.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 120,
                              margin: EdgeInsets.only(right: 15),
                              child: Text(
                                brdata![index].shipmentCompany.toString(),
                                softWrap: true,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                        ],
                      ),
                    ]));
        });
  }
}

class DepatureDetails extends StatefulWidget {
  var data;
  DepatureDetails(this.data);

  @override
  _DepatureDetails createState() => _DepatureDetails();
}

class _DepatureDetails extends State<DepatureDetails> {
  var imageList = [];

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
      child: Column(children: [
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
        ),
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
              height: h * 0.50,
              child: ListView.builder(
                  itemCount: widget.data['itemimage1'].length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    print("+++++++++++${{
                      widget.data['itemimage1'][index].itemImage.toString()
                    }}");
                    var jsondata =
                        jsonDecode(widget.data['itemimage1'][index].itemName);
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                                    child: widget.data['itemimage1'][index]
                                                .itemImage.length !=
                                            0
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              autoPlay: true,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                                //print(_currentIndex);
                                              },
                                            ),
                                            items: widget
                                                .data['itemimage1'][index]
                                                .itemImage
                                                .map<Widget>((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                widget
                                                                    .data[
                                                                        'itemimage1']
                                                                        [index]
                                                                    .itemImage);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
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
                                            padding: const EdgeInsets.all(10),
                                            child: Text(
                                              "No Image Available",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
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
                                              const EdgeInsets.only(left: 5),
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
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            widget.data['itemimage1'][index]
                                                    .category +
                                                "  " +
                                                "(" +
                                                "Quantity :" +
                                                widget.data['itemimage1'][index]
                                                    .quantity
                                                    .toString() +
                                                ")",
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
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                jsondata[index]['name'] + ",",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
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
                                            width: 650,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget
                                                      .data['itemimage1'][index]
                                                      .description
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
      ]),
    );
  }
}
