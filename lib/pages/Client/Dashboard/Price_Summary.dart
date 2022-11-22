import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/getCouponListModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Made_Payment.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/Dashboard/ItemDetails.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/Client/getTexTmode.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class PriceSummary extends StatefulWidget {
  List<ItemDetail>? itemlist;
  var data;

  PriceSummary(this.itemlist, this.data);
  // const PriceSummary({Key? key}) : super(key: key);

  @override
  _PriceSummaryState createState() => _PriceSummaryState();
}

class _PriceSummaryState extends State<PriceSummary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  final TextEditingController couponCodeController =
      new TextEditingController();
  var h, w;
  var image, qty, category, des;
  var data = [];
  var totalprice;
  var Totalship = [];
  var Totalpickup = [];
  var Totalqty = [];
  var totalpickupfee = 0;
  var totalshippingfee = 0;
  var totalquantity = 0;
  var totalAmount1 = 0;
  double total = 0.0,
      shipingTotal = 0,
      pickupTotal = 0,
      totalAmount = 0,
      pickupfee = 0,
      amountttt = 0,
      couponamount = 0;
  double totalsum = 0.0;
  var tax;
  var sum = 0;
  var totalsum1 = [];
  var couponType, tempcouponCode;
  List<ItemDetail> allItem = [];

  List<CouponList> couponList = [];
  Data? textdata;

  var discountedAmount, amountafterdiscount;
  getTaxfunction() async {
    var responce1 = await Providers().getTaxList();

    setState(() {
      textdata = responce1.data;
    });
    if (responce1.status == true) {
      log("SHOW>>>>>>>>>>>${textdata!.tax}");
      tax = textdata!.tax.toString();
      totalAmount = totalsum + int.parse(tax);
    }
  }

  getcouponList() async {
    var responce = await Providers().getCouponList();

    setState(() {
      couponList = responce.data;
    });
  }

  getcoupon() async {
    var data = {
      "coupon_code": couponcode,
      "amount": "$totalsum",
      "order_id": widget.data['bookingid']
    };
    log("DATA JHJDH $data");

    var responce = await Providers().getCoupon(data);
    if (responce.status == true) {
      setState(() {
        couponamount = double.parse(responce.data[0].couponAmount.toString());
        couponType = responce.data[0].couponType;
        tempcouponCode = responce.data[0].couponCode;

        couponType == "percentage"
            ? couponamount = ((double.parse(couponamount.toString()) *
                    double.parse(totalsum.toString())) /
                100)
            : couponamount = couponamount;

        totalAmount = ((double.parse(totalsum.toString())) +
                (double.parse(tax.toString()))) -
            ((double.parse(couponamount.toString())));
        print("Tooooooooooo$totalAmount");
      });
    } else {
      showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              responce.message,
            ),
            actions: <Widget>[
              InkWell(
                child: const Text('OK'),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }
  }

  var couponcode;
  _showDialogOnButtonPressing() => showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * (20 / 100),
            height: MediaQuery.of(context).size.height * (50 / 100),
            child: ListView.builder(
                itemCount: couponList.length,
                itemBuilder: (
                  context,
                  index,
                ) {
                  return GestureDetector(
                    onTap: () {
                      setState(() async {});
                    },
                    child: ExpansionTile(
                      title: Text(
                        couponList[index].couponCode,
                      ),
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              couponcode = couponList[index].couponCode;
                              couponCodeController.text =
                                  couponList[index].couponCode;
                              print("Coupon code  $couponcode");
                            });
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            title: Text(
                              couponList[index].couponDescription,
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    getcouponList();
    getTaxfunction();

    for (int i1 = 0; i1 < data.length; i1++)
      totalprice = data[i1]['totalprice'];
    print("MMMMMMMMMMMMMMMMM$totalprice");

    for (int i = 0; i < widget.itemlist!.length; i++) {
      allItem.add(widget.itemlist![i]);
    }
    for (int i = 0; i < allItem.length; i++) {
      totalsum1.add(allItem[i].amounttotal);
    }

    for (int i = 0; i < totalsum1.length; i++) {
      totalsum += totalsum1[i] as int;
    }
  }

  List price = [];

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
              child: ListView(addAutomaticKeepAlives: true, children: [
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
                          child: Wrap(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  ' <',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                'Payment',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (40 / 100),
                          child: orderDetails()),
                      Container(
                          width: MediaQuery.of(context).size.width * (38 / 100),
                          child: priceSummary())
                    ],
                  ),
                if (!Responsive.isDesktop(context))
                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * (90 / 100),
                          child: orderDetails1()),
                      Container(
                          width: MediaQuery.of(context).size.width * (90 / 100),
                          child: priceSummary1())
                    ],
                  ),
              ])),
        ));
  }

  Widget orderDetails() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: allItem.length,
        shrinkWrap: true,
        // scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) {
          return Column(
            children: [
              if (Responsive.isDesktop(context))
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff4CAF50)),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      height: MediaQuery.of(context).size.height * (30 / 100),
                      // height: 100,
                      width: MediaQuery.of(context).size.width * (38 / 100),
                      child: Container(
                        margin: EdgeInsets.only(left: 10, top: 10),
                        child: Column(children: [
                          Row(children: [
                            Container(
                                width: 80,
                                height: 50,
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  "Category :",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: 80,
                                height: 50,
                                margin: EdgeInsets.only(left: 4),
                                child: Text(
                                  allItem[index].categoryName.toString(),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                // height: h * .10,
                                margin: EdgeInsets.only(left: 5),
                                child: SizedBox(
                                  width: 300,
                                  height: MediaQuery.of(context).size.height *
                                      (15 / 100),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          allItem[index].imageList!.length,
                                      itemBuilder: (context, index1) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            child: Image.network(
                                              allItem[index].imageList![index1],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      }),
                                )),
                          ]),
                          Row(children: [
                            Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  "Item :",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                width: 300,
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  "${allItem[index].nameItem.join(" ,  ")}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Color(0xffEFEFEF)),
                                child: Text(
                                  allItem[index].qty.join(" , "),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                          ]),
                        ]),
                      )),
                ),
            ],
          );
        });
  }

  Widget orderDetails1() {
    return ListView.builder(
        itemCount: allItem.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        // scrollDirection: Axis.horizontal,

        itemBuilder: (context, index) {
          return Container(
            child: Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff4CAF50)),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                height: MediaQuery.of(context).size.height * (20 / 100),
                // height: 100,
                width: w * 900,
                child: Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Column(children: [
                    Container(
                      height: 50,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(children: [
                                Container(
                                    width: 80,
                                    height: 50,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Category :",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: 80,
                                    height: 50,
                                    margin: EdgeInsets.only(left: 4),
                                    child: Text(
                                      allItem[index].categoryName.toString(),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    // height: h * .10,
                                    margin: EdgeInsets.only(left: 5),
                                    child: SizedBox(
                                      width: 300,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              (15 / 100),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              allItem[index].imageList!.length,
                                          itemBuilder: (context, index1) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.network(
                                                  allItem[index]
                                                      .imageList![index1],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }),
                                    )),
                              ]),
                            ]),
                      ),
                    ),
                    Container(
                      height: 50,
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(children: [
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Item :",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: 80,
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "${allItem[index].nameItem.join(",")}",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: Color(0xffEFEFEF)),
                                    child: Text(
                                      allItem[index].qty.join(" , "),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ]),
                            ]),
                      ),
                    ),
                  ]),
                )),
          );
        });
  }

  Widget priceSummary() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        height: MediaQuery.of(context).size.height * (80 / 100),
        // height: 100,
        width: (Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (38 / 100)
            : MediaQuery.of(context).size.width * (90 / 100),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Price summary",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: allItem.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  shipingTotal = allItem[index].amounttotal;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              right: 30,
                            ),
                            child: Align(
                                child: Text(
                              "${(allItem[index].categoryName).toString()}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 10, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Item Name",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              top: 10,
                              right: 30,
                            ),
                            child: Align(
                                child: Text(
                              "${allItem[index].nameItem.join(",")}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      widget.data['pickup_type'] == "Pick up"
                          ? Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 15, right: 10, left: 15),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Pickup Fee",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      )),
                                ),
                                Spacer(),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 15,
                                    right: 30,
                                  ),
                                  child: Align(
                                      child: Text(
                                    String.fromCharCodes(new Runes('\u0024')) +
                                        "${allItem[index].pickupfee.join(",")}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  )),
                                ),
                              ],
                            )
                          : Container(),
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "QTY",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              right: 30,
                            ),
                            child: Align(
                                child: Text(
                              "${allItem[index].qty.join(",")}",
                              // allItem[0]['quantity'],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${(allItem[index].categoryName).toString()}" +
                                      " Shiping fee",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              right: 30,
                            ),
                            child: Align(
                                child: Text(
                              String.fromCharCodes(new Runes('\u0024')) +
                                  "${allItem[index].shipinfee.join(",")}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${(allItem[index].categoryName).toString()}" +
                                      "Total",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )),
                          ),
                          Spacer(),
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              right: 30,
                            ),
                            child: Align(
                                child: Text(
                              String.fromCharCodes(new Runes('\u0024')) +
                                  "${(allItem[index].amounttotal).toString()}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                    right: 30,
                  ),
                  child: Align(
                      child: Text(
                    String.fromCharCodes(new Runes('\u0024')) +
                        "${totalsum.toString()}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Apply Coupon",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                  ),
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  height: MediaQuery.of(context).size.height * (10 / 100),
                  child: TextFormField(
                    controller: couponCodeController,
                    onChanged: (v) {},
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                    decoration: InputDecoration(
                        fillColor: Color(0xffF5F6FA),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          // borderRadius: new BorderRadius.circular(25.0),
                          borderSide:
                              BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                        ),
                        // border: InputBorder.none,
                        hintText: tempcouponCode,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getcoupon();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 20, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Apply",
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff4CAF50)),
                        )),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    _showDialogOnButtonPressing();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "See all offers",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Discount",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                    right: 30,
                  ),
                  child: Align(
                    child: Text("$couponamount"),

                    //       )
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Tax",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 15,
                    right: 30,
                  ),
                  child: Align(
                      child: Text(
                    String.fromCharCodes(new Runes('\u0024')) + textdata!.tax,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Total Amount",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: 30,
                  ),
                  child: Align(
                      child: Text(
                    String.fromCharCodes(new Runes('\u0024')) +
                        "${totalAmount.toString()}",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                print("SHHHHHHOOOOOOOOOOOWW$totalAmount");

                SharedPreferences prefs = await SharedPreferences.getInstance();
                var data = {
                  "schedule_id": (widget.data['schedule_id']),
                  "title": (widget.data['title']),
                  "receptionist_name": (widget.data['receptionist_name']),
                  "receptionist_email": (widget.data['receptionist_email']),
                  "receptionist_phone": (widget.data['receptionist_phone']),
                  "receptionist_address": (widget.data['receptionist_address']),
                  "receptionist_country": (widget.data['receptionist_country']),
                  "pickup_type": (widget.data['pickup_type']),
                  "pickup_date": (widget.data['pickup_date']),
                  "pickup_time": (widget.data['pickup_time']),
                  "pickup_location": (widget.data['pickup_location']),
                  "pickup_distance": (widget.data['pickup_distance']),
                  "pickup_estimate": (widget.data['pickup_estimate']),
                  "bookingid": (widget.data['bookingid']),
                  "amount": totalAmount,
                  "coupon_code": couponcode
                };

                prefs.setString("comeFrom", "payment");
                prefs.setString("bookingid", widget.data['bookingid']);

                launchUrl(
                  Uri.parse(widget.data['paymentUrl'] +
                      "?order_id=${widget.data['bookingid']}&type=booking"),
                  mode: LaunchMode.inAppWebView,
                  webViewConfiguration: const WebViewConfiguration(),
                );

                setState(() {});
                Navigator.pushNamed(context, Routes.CLIENTBOOKINGROUTE);
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.black),
                height: MediaQuery.of(context).size.height * (7 / 100),
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Check Out",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/images/arrow-right.png'),
                    )
                  ],
                ),
              ),

              // Container(
              //   margin:
              //       EdgeInsets.only(top: 15, bottom: 70),
              //   decoration: BoxDecoration(
              //       borderRadius:
              //           BorderRadius.circular(20.0),
              //       color: Colors.black),
              //   height: 45,
              //   width: 300,
              //   child: Center(
              //     child: Text("Check out",
              //         style:
              //             TextStyle(color: Colors.white)),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }

  Widget priceSummary1() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      height: MediaQuery.of(context).size.height * (80 / 100),
      // height: 100,
      width: MediaQuery.of(context).size.width * (90 / 100),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Price summary",
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
          ),
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: allItem.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                int shipingTotal = allItem[index].amounttotal;

                return Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Category",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 30,
                          ),
                          child: Align(
                              child: Text(
                            "${(allItem[index].categoryName).toString()}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Item Name",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            right: 30,
                          ),
                          child: Align(
                              child: Text(
                            "${allItem[index].nameItem.join(",")}",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                        ),
                      ],
                    ),
                    widget.data['pickup_type'] == "Pick up"
                        ? Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, right: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Pickup Fee",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )),
                              ),
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 15,
                                  right: 30,
                                ),
                                child: Align(
                                    child: Text(
                                  String.fromCharCodes(new Runes('\u0024')) +
                                      "${allItem[index].pickupfee.join(",")}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )),
                              ),
                            ],
                          )
                        : Container(),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "QTY",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            right: 30,
                          ),
                          child: Align(
                              child: Text(
                            "${allItem[index].qty.join(",")}",
                            // allItem[0]['quantity'],
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${(allItem[index].categoryName).toString()}" +
                                    " Shiping fee",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            right: 30,
                          ),
                          child: Align(
                              child: Text(
                            String.fromCharCodes(new Runes('\u0024')) +
                                "${allItem[index].shipinfee.join(",")}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "${(allItem[index].categoryName).toString()}" +
                                    "Total",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(
                            top: 15,
                            right: 30,
                          ),
                          child: Align(
                              child: Text(
                            String.fromCharCodes(new Runes('\u0024')) +
                                "${(allItem[index].amounttotal).toString()}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Price",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) +
                      "${totalsum.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Apply Coupon",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                ),
                width: MediaQuery.of(context).size.width * (15 / 100),
                height: MediaQuery.of(context).size.height * (10 / 100),
                child: TextFormField(
                  controller: couponCodeController,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: tempcouponCode,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              InkWell(
                onTap: () {
                  getcoupon();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 20, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Apply",
                        style:
                            TextStyle(fontSize: 14, color: Color(0xff4CAF50)),
                      )),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  _showDialogOnButtonPressing();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "See all offers",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      )),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Discount",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                  child: Text("$couponamount"),

                  //       )
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Tax",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + textdata!.tax,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) +
                      "${totalAmount.toString()}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          InkWell(
            onTap: () async {
              print("SHHHHHHOOOOOOOOOOOWW$totalAmount");

              SharedPreferences prefs = await SharedPreferences.getInstance();
              var data = {
                "schedule_id": (widget.data['schedule_id']),
                "title": (widget.data['title']),
                "receptionist_name": (widget.data['receptionist_name']),
                "receptionist_email": (widget.data['receptionist_email']),
                "receptionist_phone": (widget.data['receptionist_phone']),
                "receptionist_address": (widget.data['receptionist_address']),
                "receptionist_country": (widget.data['receptionist_country']),
                "pickup_type": (widget.data['pickup_type']),
                "pickup_date": (widget.data['pickup_date']),
                "pickup_time": (widget.data['pickup_time']),
                "pickup_location": (widget.data['pickup_location']),
                "pickup_distance": (widget.data['pickup_distance']),
                "pickup_estimate": (widget.data['pickup_estimate']),
                "bookingid": (widget.data['bookingid']),
                "amount": totalAmount,
                "coupon_code": couponcode
              };

              prefs.setString("comeFrom", "payment");
              prefs.setString("bookingid", widget.data['bookingid']);

              launchUrl(
                Uri.parse(widget.data['paymentUrl'] +
                    "?order_id=${widget.data['bookingid']}&type=booking"),
                mode: LaunchMode.inAppWebView,
                webViewConfiguration: const WebViewConfiguration(),
              );

              setState(() {});
              Navigator.pushNamed(context, Routes.CLIENTBOOKINGROUTE);
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.black),
              height: MediaQuery.of(context).size.height * (7 / 100),
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Check Out",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 20,
                    width: 20,
                    child: Image.asset('assets/images/arrow-right.png'),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
