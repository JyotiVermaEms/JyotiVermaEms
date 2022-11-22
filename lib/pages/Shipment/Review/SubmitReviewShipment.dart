import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Review/ResReviewList.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SubmitReviewShipment extends StatefulWidget {
  var data;
  SubmitReviewShipment(this.data);

  // const SubmitReviewShipment({Key? key}) : super(key: key);

  @override
  _SubmitReviewShipmentState createState() => _SubmitReviewShipmentState();
}

class _SubmitReviewShipmentState extends State<SubmitReviewShipment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  var id, comment, name, ratings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    id = widget.data['id'];
    comment = widget.data['comment'];
    name = widget.data['name'];
    name = widget.data['ratings'];
  }

  commentReview() async {
    var comment = {"review_id": id.toString(), "response": "thank you"};
    print(" commnet $comment");

    var res = await Providers().reviewComment(comment);
    if (res.status == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResReviewlist()));
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
        child: ShipmentSidebar(),
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
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                      child: Row(
                        children: [
                          // Text(
                          //   'Review and rating > ',
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 22,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          Text(
                            'Submit your Review ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          // Spacer(),
                          if (Responsive.isDesktop(context)) topBar()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!Responsive.isDesktop(context))
                Column(
                  children: [topBar(), submitMobileReview()],
                ),
              if (Responsive.isDesktop(context)) submitReview(),
            ],
          ))),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            height: 48,
            width: (Responsive.isDesktop(context))
                ? 349
                : MediaQuery.of(context).size.width * (30 / 100),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Color(0xff90A0B7),
                ),
                Text(
                  "Search",
                  style: headingStyle12greynormal(),
                ),
              ],
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
                    '21.08.2021',
                    style: headingStyle12blacknormal(),
                  ),
                  Container(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget submitReview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      margin: EdgeInsets.only(left: 24, top: 15, right: 10),
      height: h,
      width: w,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text("COSCO – China Ocean Shipping Company",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
          ),
          Container(
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
                        child: Image.asset('assets/images/Ellipse7.png'),
                        height: 75,
                        width: 50),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(widget.data['name'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 10),
                            child: Text("1 Feb, 2020",
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
                      RatingBarIndicator(
                        rating: double.parse(
                            double.parse(widget.data['ratings']).toString()),
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
                      )
                  ],
                ),
                if (Responsive.isMobile(context))
                  RatingBarIndicator(
                    rating: double.parse(
                        double.parse(widget.data['ratings']).toString()),
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
                  ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Text(widget.data['comment'].toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      )),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w * 0.15,
                height: h * 0.10,
                margin: EdgeInsets.only(top: 10, left: 10),
                child: Text("Your Comment ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
              ),
              Container(
                width: w * 0.60,
                height: h * 0.10,
                child: TextFormField(
                  initialValue: "",
                  autofocus: false,
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
                      hintText: "",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              commentReview();
            },
            child: Container(
              width: 200,
              margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black),
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
      ),
    );
  }

  Widget submitMobileReview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      margin: EdgeInsets.only(left: 24, top: 15, right: 10),
      height: h,
      width: w,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text("COSCO – China Ocean Shipping Company",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              // width: w * 0.15,
              // height: h * 0.30,

              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text("Rate and Review your experience",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffF4F4F4),
            ),
            // width: w * 0.60,
            // height: h * 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // width: w * 0.10,
                      padding: EdgeInsets.only(top: 20),
                      // margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text("Quality",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 10, left: 10),
                      padding: EdgeInsets.only(top: 20),

                      width: w * 0.20,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // width: w * 0.10,
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text("Price",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                      width: w * 0.20,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // width: w * 0.10,
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text("Support",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                      width: w * 0.20,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      // width: w * .10,
                      margin: EdgeInsets.only(top: 10, left: 10, bottom: 20),
                      child: Text("Service Experience ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                      width: w * 0.20,
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                          Container(
                              margin: EdgeInsets.only(left: 5, right: 10),
                              child: Icon(
                                Icons.star_border,
                                size: 20,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              // width: w * 0.15,
              // height: h * 0.10,
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text("Would you recommend this provider?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
          ),
          // Container(width: w * 0.60, height: h * 0.10, child: buttons()),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text("Your Comment ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
          ),
          Container(
            child: TextFormField(
              initialValue: "",
              autofocus: false,
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
                  hintText: "",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
              child: Text("Upload image/video ",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  )),
            ),
          ),
          Container(
            width: w * 0.60,
            height: h * 0.10,
            child: DottedBorder(
              padding: EdgeInsets.only(top: 10, left: 10),
              color: Colors.black,
              strokeWidth: 1,
              child: Container(
                width: w,
                height: h * 0.10,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(0.0),
                //   color: Color(0xffE5E5E5),
                // ),
                child: Center(
                  child: Text(
                    'drag or upload project files',
                    style: headingStyle16blacknormal(),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 200,
              margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.black),
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
      ),
    );
  }
}
