import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/previousbookingmodel.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';

class OrderList extends StatefulWidget {
  final String Id;
  var cid;
  OrderList({Key? key, required this.Id, required this.cid}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderList> {
  List<DataResponse>? data1;
  int? index;

  String? client, orderId, bookingdate, title, from, to, type;
  List<Client>? clientinfo;
  List<Item>? item;
  List<PreBookingData> previousdata = [];
  String? name,
      lname,
      email,
      country1,
      address1,
      language1,
      aboutme1,
      status,
      mobilenumber;
  var id;
  var bookingdata = [];

  clientbookingsApi() async {
    var data = {"schedule_id": widget.Id};

    var res = await Providers().shipmentClientBooking(data);
    if (res.status == true) {
      setState(() {
        data1 = res.data;
      });
      for (int i = 0; i < data1!.length; i++) {
        clientinfo = data1![i].client;
        item = data1![i].item;
        for (int j = 0; j < item!.length; j++) {
          orderId = item![j].id.toString();
        }
        for (int j = 0; j < clientinfo!.length; j++) {
          name = clientinfo![j].name;
          lname = clientinfo![j].lname;
          email = clientinfo![j].email;
          language1 = clientinfo![j].language;
          country1 = clientinfo![j].country.toString();
          aboutme1 = clientinfo![j].about_me.toString();
          status = clientinfo![j].status;
          mobilenumber = clientinfo![j].phone;
          address1 = clientinfo![j].address.toString();
        }
        title = data1![i].title.toString();
        type = data1![i].bookingType.toString();
        from = data1![i].from.toString();
        to = data1![i].to.toString();
        bookingdate = data1![i].bookingDate.toString();
      }
      print("""""" """""" """object""" """""" """""" + orderId.toString());
      print("""""" """""" """object""" """""" """""" + name.toString());
      print("""""" """""" """object""" """""" """""" + address1.toString());
      print("""""" """""" """object""" """""" """""" + aboutme1.toString());
      print("""""" """""" """object""" """""" """""" + country1.toString());
    }
  }

  pervioubookingsApi() async {
    var data = {"schedule_id": widget.Id, "client_id": widget.cid.toString()};
    var res = await Providers().previousBookingshow(data);
    if (res.status == true) {
      setState(() {
        previousdata = res.data;
      });
      for (int i = 0; i < previousdata.length; i++) {
        print("--->>");
        print(previousdata[i].booking);
        for (int ii = 0; ii < previousdata[i].booking.length; ii++) {
          bookingdata.add(previousdata[i].booking[ii]);
        }
        // for (int j = 0; j < previousdata[i].booking.length; j++)
        //   id = previousdata[i].booking[j].id;
        // print("dhghghdgshghgdsh$id");
      }
    }
    print("jhjhhjdshjhf${bookingdata.length}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("--------------${widget.Id}");
    print("--------------${widget.cid}");
    clientbookingsApi();
    pervioubookingsApi();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      orderTemplate(),
      data1 != null
          ? Container(height: 800, child: orderDetails())
          : Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text("No More Bookings "),
            )
    ]));
  }

  var h, w;
  Widget orderTemplate() {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        height: 28,
        width: MediaQuery.of(context).size.width * (90 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: (Responsive.isDesktop(context))
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 50,
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "Order ID",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 120,
                      // margin: EdgeInsets.only(right: 70),
                      child: Text(
                        "Booking Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 90,
                      // margin: EdgeInsets.only(right: 90),
                      child: Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 90),
                      child: Text(
                        "Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: 90,
                      // margin: EdgeInsets.only(right: 90),
                      child: Text(
                        "From",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 90,
                      // margin: EdgeInsets.only(right: 90),
                      child: Text(
                        "To",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),

                  Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        "Status",
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
                          width: 120,
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            "Order ID",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 200,
                          // margin: EdgeInsets.only(right: 70),
                          child: Text(
                            "Booking Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 90,
                          // margin: EdgeInsets.only(right: 90),
                          child: Text(
                            "Title",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 90),
                          child: Text(
                            "Type",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Container(
                          width: 90,
                          // margin: EdgeInsets.only(right: 90),
                          child: Text(
                            "From",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      // Spacer(),
                      Container(
                          width: 90,
                          // margin: EdgeInsets.only(right: 90),
                          child: Text(
                            "To",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),

                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 20),
                          child: Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ]),
              ),
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: bookingdata.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return bookingdata.isNotEmpty
              ? (Responsive.isDesktop(context))
                  ? Container(
                      width: MediaQuery.of(context).size.width * (90 / 100),
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                bookingdata[index].id.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 90,
                              // margin: EdgeInsets.only(left: 10),
                              child: Text(
                                //data1![index].createdAt,
                                DateFormat("yyyy-MM-dd").format(DateTime.parse(
                                    bookingdata[index].createdAt)),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 90,
                              // margin: EdgeInsets.only(left: 20),
                              child: Text(
                                bookingdata[index].title,
                                softWrap: true,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )),
                          Container(
                              width: 90,
                              // margin: EdgeInsets.only(right: 20),
                              child: Text(
                                bookingdata[index].bookingType,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 90,
                              // margin: EdgeInsets.only(right: 30),
                              child: Text(
                                bookingdata[index].from,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 80,
                              // margin: EdgeInsets.only(right: 30),
                              child: Text(
                                bookingdata[index].to,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                          Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                bookingdata[index].status,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              )),
                        ],
                      ),
                    )
                  : Container(
                      height: 40,
                      // width: MediaQuery.of(context).size.width * (90 / 100),
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      child:
                          Scrollbar(
                               isAlwaysShown: true,
                            child: ListView(scrollDirection: Axis.horizontal, children: [
                                                  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 50,
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    bookingdata[index].id.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                          
                              Container(
                                  width: 90,
                                  // margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    //data1![index].createdAt,
                                    DateFormat("yyyy-MM-dd").format(
                                        DateTime.parse(
                                            bookingdata[index].createdAt)),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                          
                              Container(
                                  width: 90,
                                  // margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    bookingdata[index].title,
                                    softWrap: true,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  )),
                          
                              Container(
                                  width: 90,
                                  // margin: EdgeInsets.only(right: 20),
                                  child: Text(
                                    bookingdata[index].bookingType,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                          
                              Container(
                                  width: 90,
                                  // margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    bookingdata[index].from,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                          
                              Container(
                                  width: 80,
                                  // margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    bookingdata[index].to,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                              // Spacer(),
                              // Container(
                              //     margin: EdgeInsets.only(left: 30),
                              //     child: Text(
                              //       "CMA CGM",
                              //       // style: TextStyle(fontWeight: FontWeight.bold),
                              //     )),
                          
                              Container(
                                  width: 100,
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text(
                                    bookingdata[index].status,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  )),
                            ],
                                                  ),
                                                ]),
                          ),
                    )
              : Container();
        });
  }
}
