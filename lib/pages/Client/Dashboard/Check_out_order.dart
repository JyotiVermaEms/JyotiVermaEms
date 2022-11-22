import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/helper/routes.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class CheckoutOrder extends StatefulWidget {
  var data;
  CheckoutOrder(this.data);

  @override
  _CheckoutOrderState createState() => _CheckoutOrderState();
}

class _CheckoutOrderState extends State<CheckoutOrder> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  String? category;

  var amount;
  var item = [
    "No Saved Card",
  ];
  final TextEditingController _controllr = new TextEditingController();

  void _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    });
  }

  checkout() async {
    var checkoutData = {
      "id": "${widget.data['bookingid'].toString()}",
      "transaction_id": "",
      "card_type": "debit",
      "total_amount": "${widget.data['amount'].toString()}",
      "coupon_code": "${widget.data['coupon_code'].toString()}",
    };
    print("object {$checkoutData}");
    var responce = await Providers().updateBookinClient(checkoutData);

    if (responce.status == true) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(responce.message),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.CLIENTBOOKINGROUTE),
              child: const Text('OK'),
            ),
          ],
        ),
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
          color: Color(0xffE5E5E5),
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
                                'CheckOut',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                          // Text(
                          //   ' < CheckOut',
                          //   style: TextStyle(
                          //       color: Colors.black,
                          //       fontSize: 22,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: MediaQuery.of(context).size.height * (10 / 100),
                    // height: 100,
                    width: (Responsive.isDesktop(context))
                        ? MediaQuery.of(context).size.width * (30 / 100)
                        : MediaQuery.of(context).size.width * (90 / 100),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffFFFFFF),
                    ),

                    child: Row(
                      children: [
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Stripe',
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff6461FC),
                              fontWeight: FontWeight.bold),
                        ),
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        Container(
                            child: Image.asset("assets/images/paypal.png")),
                        new Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text(
                          'Cash',
                          style: new TextStyle(
                              fontSize: 16.0,
                              color: Color(0xff2E724F),
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            '667.0',
                            style: new TextStyle(
                                fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      height: MediaQuery.of(context).size.height * (60 / 100),
                      // height: 100,
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (40 / 100)
                          : MediaQuery.of(context).size.width * (90 / 100),
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xffFFFFFF),
                      ),
                      child: ListView(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Card Details",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Used Saved Card",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey))),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              margin: EdgeInsets.only(left: 16, right: 10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.grey))),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          controller: _controllr,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.arrow_drop_down),
                                        onSelected: (String value) {
                                          category = value;
                                          _controllr.text = value;
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return item
                                              .map<PopupMenuItem<String>>(
                                                  (String value) {
                                            return PopupMenuItem(
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            (90 / 100),
                                                    child: Text(value)),
                                                value: value);
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("Name on Card",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey))),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: TextFormField(
                              initialValue: "",
                              onChanged: (v) {
                                setState(() {
                                  // userEmail = v.toLowerCase();
                                });
                              },
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    // borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "Shishank Barua",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, right: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Card Number",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: TextFormField(
                              initialValue: "",
                              onChanged: (v) {
                                setState(() {
                                  // userEmail = v.toLowerCase();
                                });
                              },
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    // borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "4601 -1256- 7896 -****",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                          Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.spaceAround,
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: 10, right: 10, left: 15),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Expire",
                                      style: TextStyle(fontSize: 14),
                                    )),
                              ),
                              // Spacer(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                  left: 150,
                                ),
                                child: Align(
                                    child: Text(
                                  "CVV",
                                  style: TextStyle(fontSize: 14),
                                )),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                                width: 70,
                                height: 40,
                                child: TextFormField(
                                  initialValue: "",
                                  onChanged: (v) {
                                    setState(() {
                                      // userEmail = v.toLowerCase();
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
                                      hintText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Align(
                                    child: Text(
                                  "/",
                                  style: TextStyle(fontSize: 20),
                                )),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                height: 40,
                                width: 70,
                                child: TextFormField(
                                  initialValue: "",
                                  onChanged: (v) {
                                    setState(() {
                                      // userEmail = v.toLowerCase();
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
                                      hintText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                height: 40,
                                width: 100,
                                child: TextFormField(
                                  initialValue: "",
                                  onChanged: (v) {
                                    setState(() {
                                      // userEmail = v.toLowerCase();
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
                                      hintText: "",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      checkout();
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => CheckoutPayment()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 15, bottom: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black),
                      height: 45,
                      width: 300,
                      child: Center(
                        child: Text("Payment",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }
}
