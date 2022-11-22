import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/demo.dart';
import 'package:shipment/Element/Responsive.dart';

import 'package:shipment/component/Res_Client/ResMarketPlace/Res_gallary.dart';
import 'package:shipment/constants.dart';
import 'package:timelines/timelines.dart';
import 'dart:math';

import 'package:flutter/foundation.dart' show kIsWeb;

class Princing extends StatefulWidget {
  var data;
  Princing(this.data);

  // const Princing({Key? key}) : super(key: key);

  @override
  _PrincingState createState() => _PrincingState();
}

class _PrincingState extends State<Princing> {
  List? temp;
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    // List? temp;
    // DateTime? selectedDate = DateTime.now();
    // temp!.add(widget.data['category']);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var h, w;

  int? _radioValue = 0;

  void _handleRadioValueChange2(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  var deliverDays, bookingPrice, numberOfitems;

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

                processTimeline2(),
                pricing(),
                // buttons(),
              ])),
        ));
  }

  Widget buttons() {
    return Row(
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
              if (_formKey.currentState!.validate()) {
                var data = {
                  "title": widget.data['title'],
                  "Pickuplocation": widget.data['Pickuplocation'],
                  "dropofflocation": widget.data['dropofflocation'],
                  "category": widget.data['category'],
                  "deliverdays": "$deliverDays",
                  "numberItems": "$numberOfitems",
                  "bookingPrice": "$bookingPrice",
                  "pickup_dropoff": _radioValue == 0 ? "Pick up" : "drop off"
                };
                print("object data>>>>>>>>>>  ${jsonEncode(data)}");

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResGallery(data)));
              }
            },
            child: (Responsive.isDesktop(context))
                ? Container(
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 20, bottom: 50),
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
                                child: Text("Save & Continue",
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
                  )
                : Container(
                    margin:
                        EdgeInsets.only(top: 15, left: 0, right: 5, bottom: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Color(0xff1F2326)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                            // width: MediaQuery.of(context).size.width * 0.25,
                            // color: Colors.lime,
                            child: Text("Save & Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ))),
                        Container(
                          margin: EdgeInsets.only(top: 15, right: 10, left: 5),
                          height: 30,
                          // width: 300,
                          child: Image.asset('assets/images/arrow-right.png'),
                        ),
                      ],
                    ),
                  )),
      ],
    );
  }

  Widget pricing() {
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Price & scope",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Create pricing tiers",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Customize your project with 1 or 3 pricing tiers",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, left: 15),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Starter",
                            style: TextStyle(fontSize: 14),
                          )),
                    ),
                    (!Responsive.isDesktop(context))
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Delivery Days",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 15, left: 15),
                                // width: MediaQuery.of(context).size.width * (15 / 100),
                                child: TextFormField(
                                  initialValue: "",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      deliverDays = v;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        // borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      // border: InputBorder.none,
                                      hintText:
                                          "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Delivery Days",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 15, left: 35),
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  initialValue: "",
                                  onChanged: (v) {
                                    setState(() {
                                      deliverDays = v;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        // borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      // border: InputBorder.none,
                                      hintText:
                                          "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              )
                            ],
                          ),
                    // (!Responsive.isDesktop(context))
                    //     ? Column(
                    //         children: [
                    //           Container(
                    //             margin: EdgeInsets.only(top: 10, left: 15),
                    //             child: Align(
                    //                 alignment: Alignment.topLeft,
                    //                 child: Text(
                    //                   "Number of Iteam",
                    //                   style: TextStyle(fontSize: 14),
                    //                 )),
                    //           ),
                    //           Container(
                    //             margin:
                    //                 EdgeInsets.only(top: 10, right: 10, left: 15),
                    //             // width: MediaQuery.of(context).size.width * (15 / 100),
                    //             child: TextFormField(
                    //               initialValue: "",
                    //               keyboardType: TextInputType.number,
                    //               inputFormatters: [
                    //                 FilteringTextInputFormatter.digitsOnly
                    //               ],
                    //               onChanged: (v) {
                    //                 setState(() {
                    //                   numberOfitems = v;
                    //                 });
                    //               },
                    //               style: TextStyle(
                    //                   color: Colors.black54, fontSize: 17),
                    //               decoration: InputDecoration(
                    //                   fillColor: Color(0xffF5F6FA),
                    //                   filled: true,
                    //                   enabledBorder: OutlineInputBorder(
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   focusedBorder: new OutlineInputBorder(
                    //                     // borderRadius: new BorderRadius.circular(25.0),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   errorBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(4)),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   focusedErrorBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(4)),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   // border: InputBorder.none,
                    //                   hintText:
                    //                       "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                    //                   hintStyle: TextStyle(
                    //                       color: Colors.grey, fontSize: 15)),
                    //             ),
                    //           ),
                    //         ],
                    //       )
                    //     : Row(
                    //         children: [
                    //           Container(
                    //             margin: EdgeInsets.only(top: 10, left: 15),
                    //             child: Align(
                    //                 alignment: Alignment.topLeft,
                    //                 child: Text(
                    //                   "Number of Items",
                    //                   style: TextStyle(fontSize: 14),
                    //                 )),
                    //           ),
                    //           Container(
                    //             margin:
                    //                 EdgeInsets.only(top: 10, right: 10, left: 30),
                    //             width: MediaQuery.of(context).size.width *
                    //                 (20 / 100),
                    //             child: TextFormField(
                    //               initialValue: "",
                    //               keyboardType: TextInputType.number,
                    //               inputFormatters: [
                    //                 FilteringTextInputFormatter.digitsOnly
                    //               ],
                    //               onChanged: (v) {
                    //                 setState(() {
                    //                   numberOfitems = v;
                    //                 });
                    //               },
                    //               style: TextStyle(
                    //                   color: Colors.black54, fontSize: 17),
                    //               decoration: InputDecoration(
                    //                   fillColor: Color(0xffF5F6FA),
                    //                   filled: true,
                    //                   enabledBorder: OutlineInputBorder(
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   focusedBorder: new OutlineInputBorder(
                    //                     // borderRadius: new BorderRadius.circular(25.0),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   errorBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(4)),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   focusedErrorBorder: OutlineInputBorder(
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(4)),
                    //                     borderSide: BorderSide(
                    //                         width: 1.2, color: Color(0xffF5F6FA)),
                    //                   ),
                    //                   // border: InputBorder.none,
                    //                   hintText:
                    //                       "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                    //                   hintStyle: TextStyle(
                    //                       color: Colors.grey, fontSize: 15)),
                    //             ),
                    //           ),
                    //         ],
                    //       ),

                    new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                    (!Responsive.isDesktop(context))
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Booking price",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 15, left: 15),
                                // width: MediaQuery.of(context).size.width * (15 / 100),
                                child: TextFormField(
                                  initialValue: "",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  onChanged: (v) {
                                    setState(() {
                                      bookingPrice = v;
                                    });
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        // borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      // border: InputBorder.none,
                                      hintText:
                                          "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Booking price (\$)",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 10, left: 35),
                                width: MediaQuery.of(context).size.width *
                                    (20 / 100),
                                child: TextFormField(
                                  initialValue: "",
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (v) {
                                    setState(() {
                                      bookingPrice = v;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "This field is required";
                                    }
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        // borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffF5F6FA)),
                                      ),
                                      // border: InputBorder.none,
                                      hintText:
                                          "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                    new Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                    (!Responsive.isDesktop(context))
                        ? Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Choose Drop-Off",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(left: 10),
                                        child: new Radio(
                                          value: 0,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChange2,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Shipment Company Pick-up Service",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: new Radio(
                                          value: 1,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChange2,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text("Self Pick-up Service",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ],
                                  )
                                ]),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Choose Drop-Off",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              Column(children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: new Radio(
                                          value: 0,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChange2,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "Shipment Company Pick-up Service",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: new Radio(
                                          value: 1,
                                          groupValue: _radioValue,
                                          onChanged: _handleRadioValueChange2,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                              "Self Pick-up Service                                   ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ],
                                  ),
                                )
                              ]),
                            ],
                          ),
                    buttons(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget processTimeline2() {
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
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Pricing",
                  style: TextStyle(
                      color: Colors.grey,
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
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '3',
                  style: TextStyle(color: Colors.grey),
                ))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Gallery",
                  style: TextStyle(
                      color: Colors.grey,
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
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '4',
                  style: TextStyle(color: Colors.grey),
                ))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Description",
                  style: TextStyle(
                      color: Colors.grey,
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
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '5',
                  style: TextStyle(color: Colors.grey),
                ))),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                    'Requirement',
                    style: TextStyle(
                        color: Colors.grey,
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
                  border: Border.all(color: Colors.grey),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '6',
                  style: TextStyle(color: Colors.grey),
                ))),
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
