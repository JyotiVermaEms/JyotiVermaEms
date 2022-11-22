import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class MarketPlaceDetails extends StatefulWidget {
  const MarketPlaceDetails({Key? key}) : super(key: key);

  @override
  _MarketPlaceDetailsState createState() => _MarketPlaceDetailsState();
}

class _MarketPlaceDetailsState extends State<MarketPlaceDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

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
                          'Market Place > Project details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                details(),
                Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                      height: 36,
                    )),
                itemreview()
              ])),
        ));
  }

  Widget details() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      height: h * 0.20,
      width: w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xffFFFFFF)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: w * .10,
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text(
                    'Order ID',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              // SizedBox(width: w * .10),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text('123456')),
            ],
          ),
          Row(
            children: [
              Container(
                  width: w * .10,
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text("Booking Date",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // SizedBox(width: w * .10),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text('29 oct 2021')),
            ],
          ),
          Row(
            children: [
              Container(
                  width: w * .10,
                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Text("Details",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              // SizedBox(width: w * .10),
              Container(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.5, color: Colors.black),
                    // borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xff1A494F)),
                child: Center(
                  child:
                      Icon(Icons.arrow_drop_down_outlined, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget itemreview() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        height: h,
        width: w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xffFFFFFF)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: w * .10,
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Text("Title",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                // SizedBox(width: w * .10),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text('Title ')),
              ],
            ),
            Row(
              children: [
                Container(
                    width: w * .10,
                    margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                    child: Text("Category",
                        style: TextStyle(fontWeight: FontWeight.bold))),
                // SizedBox(width: w * .10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 15,
                        width: 15,
                        child: ImageIcon(
                          AssetImage(
                            'assets/images/car.png',
                          ),
                          size: 10,
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 5, top: 15),
                          child: Text("Cars")),
                      Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.only(left: 10, top: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Color(0xffEFEFEF)),
                          child: Center(child: Text("3"))),
                    ]),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Pick-up Location",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 30),
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  child: TextFormField(
                    initialValue: "",
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Drop-off Location",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 30),
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  child: TextFormField(
                    initialValue: "",
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Delivery Days",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 15, left: 50),
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  child: TextFormField(
                    initialValue: "",
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Number of Items",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 30),
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  child: TextFormField(
                    initialValue: "",
                    enabled: false,
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Booking price",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 40),
                  width: MediaQuery.of(context).size.width * (20 / 100),
                  child: TextFormField(
                    initialValue: "",
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
            Row(children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Drop-Off",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 70),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Shipment Company Pic-up Service",
                        style: TextStyle(
                          fontSize: 14,
                        ))),
              )
            ]),
            Row(children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Items Images",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
              ),
              Container(
                  height: 150,
                  width: 300,
                  decoration: BoxDecoration(
                    // border: Border.all(

                    //     width: 0.5, color: Color(0xffACACAC)),
                    // borderRadius: BorderRadius.circular(0.0),
                    color: Color(0xffFFFFFF),
                  ),
                  margin: EdgeInsets.only(top: 10, right: 10, left: 40),
                  child: Image.asset(
                    'assets/images/Cars.png',
                    fit: BoxFit.cover,
                  )),
            ]),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                    child: Text(
                      "Booking summary",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 40),
                  width: MediaQuery.of(context).size.width * (60 / 100),
                  child: TextFormField(
                    initialValue: "",
                    maxLines: 3,
                    onChanged: (v) {
                      setState(() {
                        // userEmail = v.toLowerCase();
                      });
                    },
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
                        hintText:
                            "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
