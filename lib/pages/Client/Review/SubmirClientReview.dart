import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResClientReview.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SubmitClientFeedback extends StatefulWidget {
  var data;
  SubmitClientFeedback(this.data);

  @override
  _SubmitClientFeedbackState createState() => _SubmitClientFeedbackState();
}

class _SubmitClientFeedbackState extends State<SubmitClientFeedback> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  var sid, comment, tapped = 0, companyname;
  double? quality, price, support, service, ratings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    sid = widget.data['sid'];
    companyname = widget.data['companyname'];
    print("AAAAAAAAAAA$sid");
    print("AAAAAAAAAAA$companyname");
  }

  submit() async {
    var data = {
      "rating": "$ratings",
      "recommend": "yes",
      "comment": "$comment",
      "file": "",
      "sid": "$sid"
    };
    print("AAAAAAAAAAA$data");
    print("object>>>> $data");
    var res = await Providers().scheduleshipmentReview(data);

    if (res.status == true) {
      var data = {"sID": "$sid", "companyName": "$companyname"};
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ClientReviewRes(data)));
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
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                      child: Row(
                        children: [
                          Text(
                            'Submit your Review ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!Responsive.isDesktop(context))
                Column(
                  children: [submitMobileReview()],
                ),
              if (Responsive.isDesktop(context)) submitReview(),
            ],
          ))),
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
              child: Text(companyname.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: w * 0.15,
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
                width: w * 0.60,
                // height: h * 0.30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.10,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          // margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Quality",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Container(
                            margin: EdgeInsets.only(top: 5),

                            // width: 5,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            quality = rating;
                            print("quality   $quality");

                            print(rating);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: w * 0.10,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Price",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,

                          // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Container(
                            margin: EdgeInsets.only(top: 5),

                            // height: 10,
                            // width: 5,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                              // size: 10,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            price = rating;
                            print("price   $price");

                            print(rating);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: w * 0.10,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Text("Support",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          itemSize: 30,

                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Container(
                            margin: EdgeInsets.only(top: 5),

                            // height: 10,
                            // width: 5,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                              // size: 10,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            support = rating;
                            print("support   $support");

                            print(rating);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: w * .10,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          child: Text("Service Experience ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )),
                        ),
                        RatingBar.builder(
                          initialRating: 0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 30,
                          // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Container(
                            margin: EdgeInsets.only(top: 5),

                            // width: 5,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ),
                          onRatingUpdate: (rating) {
                            service = rating;
                            print("service   $service");
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w * 0.15,
                height: h * 0.10,
                margin: EdgeInsets.only(top: 20, left: 10),
                child: Text("Your Comment ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: w * 0.60,
                height: h * 0.10,
                child: TextFormField(
                  initialValue: "",
                  autofocus: false,
                  maxLines: 3,
                  onChanged: (v) {
                    setState(() {
                      comment = v;
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
              ratings = (((quality)! + (price)! + (service)! + (support)!) / 4);
              print("temp $ratings");
              submit();
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

  Widget buttons() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              tapped = 0;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: tapped == 0 ? Color(0xff1A494F) : Color(0xffBCBEC0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),

                    // width: MediaQuery.of(context).size.width * 0.8,
                    // color: Colors.lime,
                    child: Center(
                        child: Text("Yes",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              tapped = 1;
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: tapped == 1 ? Color(0xff1A494F) : Color(0xffBCBEC0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),

                    // width: MediaQuery.of(context).size.width * 0.8,
                    // color: Colors.lime,
                    child: Center(
                        child: Text("No",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )))),
              ],
            ),
          ),
        ),
      ],
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
              child: Text(companyname.toString(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: w * 0.4,
                      padding: EdgeInsets.only(top: 20),
                      // margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text("Quality",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      // allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Container(
                        margin: EdgeInsets.only(top: 5),

                        // width: 5,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        quality = rating;
                        print("quality   $quality");

                        print(rating);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w * 0.4,
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child: Text("Price",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      // allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Container(
                        margin: EdgeInsets.only(top: 5),

                        // width: 5,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        price = rating;
                        print("quality   $quality");

                        print(rating);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w * 0.4,
                      margin: EdgeInsets.only(top: 10, left: 5),
                      child: Text("Support",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      // allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Container(
                        margin: EdgeInsets.only(top: 5),

                        // width: 5,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        support = rating;
                        print("quality   $quality");

                        print(rating);
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: w * 0.4,
                      margin: EdgeInsets.only(top: 10, left: 5, bottom: 10),
                      child: Text("Service Experience ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      // allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      // itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => Container(
                        margin: EdgeInsets.only(top: 5),

                        // width: 5,
                        child: Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      ),
                      onRatingUpdate: (rating) {
                        service = rating;
                        print("quality   $quality");

                        print(rating);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
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
          GestureDetector(
            onTap: () {
              ratings = (((quality)! + (price)! + (service)! + (support)!) / 4);
              print("temp $ratings");
              submit();
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
