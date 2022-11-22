import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Res_Transaction.dart';
import '../../../constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  _AddNewCardState createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;
  int? _radioValue = 0;
  String? name1, uid1, month, year, cardnumber1, cvv1;
  int? index;
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

  var clientToken;
  saveApi() async {
    var saveData = {
      "name": "$name1",
      "expire": "$month" + "/" + "$year",
      "card_number": "$cardnumber1",
      "cvv": "$cvv1",
    };

    print(jsonEncode(saveData));
    var save = await Providers().saveCardApiCall(saveData);
    if (save.status == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ResTransaction()));
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('auth_token', clientToken);

      print(save.data);
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(save.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  _cardValidation(value, fieldName) {
    final required = requiredField(value, fieldName);
    if (required != null) {
      return required;
    }
    RegExp nameExp = new RegExp(r'^([1-9]{11})$');
    if (Value != "") {
      if (value.length != 16) return " should be 16 digit";
    }
    return null;
  }

  String? requiredField(value, fieldName) {
    if (value.isEmpty) {
      return 'required';
    }
  }

  _cvvValidation(value, fieldName) {
    final required = requiredField(value, fieldName);
    if (required != null) {
      return required;
    }
    RegExp nameExp = new RegExp(r'^([0-9]{10})$');
    if (Value != "") {
      if (value.length != 3) return "should be 3  digit";
    }
    return null;
  }

  _monthValidation(value, fieldName) {
    final required = requiredField(value, fieldName);
    if (required != null) {
      return required;
    }
    RegExp nameExp = new RegExp(r'^([0-9]{10})$');
    if (Value != "") {
      if (value.length != 2) return "should be 2 digit";
    }
    return null;
  }

  _yearValidation(value, fieldName) {
    final required = requiredField(value, fieldName);
    if (required != null) {
      return required;
    }
    RegExp nameExp = new RegExp(r'^([0-9]{10})$');
    if (Value != "") {
      if (value.length != 4) return "should be 4 digit";
    }
    return null;
  }

  _nameValidation(value, fieldName) {
    final required = requiredField(value, fieldName);
    if (required != null) {
      return required;
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    // saveApi();
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
              child: Form(
                key: _formKey,
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
                            'Save Card',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        height: MediaQuery.of(context).size.height * (65 / 100),
                        // height: 100,
                        width: (Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (50 / 100)
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
                                  child: Text("Name on Card",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey))),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: TextFormField(
                                initialValue: "",
                                validator: (value) =>
                                    _nameValidation(value, "CardName"),
                                onChanged: (value) {
                                  name1 = value;
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
                                validator: (value) =>
                                    _cardValidation(value, "CardNumber"),
                                onChanged: (value) {
                                  cardnumber1 = value;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceAround,
                              // crossAxisAlignment:
                              //     CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10, right: 10, left: 15),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            "Expire Month",
                                            style: TextStyle(fontSize: 14),
                                          )),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      width: (Responsive.isDesktop(context))
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.2,
                                      // height: 50,
                                      child: TextFormField(
                                        initialValue: "",
                                        validator: (value) =>
                                            _monthValidation(value, "Month"),
                                        onChanged: (value) {
                                          month = value;
                                        },
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                            fillColor: Color(0xffF5F6FA),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            focusedBorder:
                                                new OutlineInputBorder(
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
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            // border: InputBorder.none,
                                            hintText: "MM",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ],
                                ),
                                // Spacer(),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 25, right: 15),
                                  child: Text(
                                    "/",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Align(
                                          child: Text(
                                        "Expire Year",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 10, 10, 10),
                                      width: (Responsive.isDesktop(context))
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.22,
                                      // height: 50,
                                      child: TextFormField(
                                        initialValue: "",
                                        validator: (value) =>
                                            _yearValidation(value, "Year"),
                                        onChanged: (value) {
                                          year = value;
                                        },
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                            fillColor: Color(0xffF5F6FA),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            focusedBorder:
                                                new OutlineInputBorder(
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
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            // border: InputBorder.none,
                                            hintText: "YYYY",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Align(
                                          child: Text(
                                        "CVV",
                                        style: TextStyle(fontSize: 14),
                                      )),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 10, 15, 10),
                                      width: (Responsive.isDesktop(context))
                                          ? 200
                                          : MediaQuery.of(context).size.width *
                                              0.2,
                                      // height: 60,
                                      child: TextFormField(
                                        initialValue: "",
                                        validator: (value) =>
                                            _cvvValidation(value, "CVV"),
                                        onChanged: (value) {
                                          cvv1 = value;
                                        },
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 17),
                                        decoration: InputDecoration(
                                            fillColor: Color(0xffF5F6FA),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            focusedBorder:
                                                new OutlineInputBorder(
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
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffF5F6FA)),
                                            ),
                                            // border: InputBorder.none,
                                            hintText: "311",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   // mainAxisAlignment:
                            //   //     MainAxisAlignment.spaceAround,
                            //   // crossAxisAlignment:
                            //   //     CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       margin: EdgeInsets.only(
                            //           top: 10, right: 10, left: 15),
                            //       child: Align(
                            //           alignment: Alignment.topLeft,
                            //           child: Text(
                            //             "Expire Month",
                            //             style: TextStyle(fontSize: 14),
                            //           )),
                            //     ),
                            //     // Spacer(),
                            //     // SizedBox(
                            //     //   width: 20,
                            //     // ),
                            //     Container(
                            //       margin: EdgeInsets.only(
                            //         top: 10,
                            //         left: 0,
                            //       ),
                            //       child: Align(
                            //           child: Text(
                            //         "Expire Year",
                            //         style: TextStyle(fontSize: 14),
                            //       )),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(
                            //         top: 10,
                            //         left: 150,
                            //       ),
                            //       child: Align(
                            //           child: Text(
                            //         "CVV",
                            //         style: TextStyle(fontSize: 14),
                            //       )),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: [
                            //     Container(
                            //       margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //       width: (Responsive.isDesktop(context))
                            //           ? 200
                            //           : MediaQuery.of(context).size.width * 0.2,
                            //       // height: 50,
                            //       child: TextFormField(
                            //         initialValue: "",
                            //         validator: (value) =>
                            //             _monthValidation(value, "Month"),
                            //         onChanged: (value) {
                            //           month = value;
                            //         },
                            //         style: TextStyle(
                            //             color: Colors.black54, fontSize: 17),
                            //         decoration: InputDecoration(
                            //             fillColor: Color(0xffF5F6FA),
                            //             filled: true,
                            //             enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedBorder: new OutlineInputBorder(
                            //               // borderRadius: new BorderRadius.circular(25.0),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             errorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedErrorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             // border: InputBorder.none,
                            //             hintText: "MM",
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 15)),
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.only(
                            //         top: 10,
                            //       ),
                            //       child: Container(
                            //         // margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //         child: Text(
                            //           "/",
                            //           style: TextStyle(fontSize: 20),
                            //         ),
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                            //       width: (Responsive.isDesktop(context))
                            //           ? 200
                            //           : MediaQuery.of(context).size.width *
                            //               0.22,
                            //       // height: 50,
                            //       child: TextFormField(
                            //         initialValue: "",
                            //         validator: (value) =>
                            //             _yearValidation(value, "Year"),
                            //         onChanged: (value) {
                            //           year = value;
                            //         },
                            //         style: TextStyle(
                            //             color: Colors.black54, fontSize: 17),
                            //         decoration: InputDecoration(
                            //             fillColor: Color(0xffF5F6FA),
                            //             filled: true,
                            //             enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedBorder: new OutlineInputBorder(
                            //               // borderRadius: new BorderRadius.circular(25.0),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             errorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedErrorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             // border: InputBorder.none,
                            //             hintText: "YYYY",
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 15)),
                            //       ),
                            //     ),
                            //     Container(
                            //       margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            //       width: (Responsive.isDesktop(context))
                            //           ? 200
                            //           : MediaQuery.of(context).size.width *
                            //               0.25,
                            //       // height: 60,
                            //       child: TextFormField(
                            //         initialValue: "",
                            //         validator: (value) =>
                            //             _cvvValidation(value, "CVV"),
                            //         onChanged: (value) {
                            //           cvv1 = value;
                            //         },
                            //         style: TextStyle(
                            //             color: Colors.black54, fontSize: 17),
                            //         decoration: InputDecoration(
                            //             fillColor: Color(0xffF5F6FA),
                            //             filled: true,
                            //             enabledBorder: OutlineInputBorder(
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedBorder: new OutlineInputBorder(
                            //               // borderRadius: new BorderRadius.circular(25.0),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             errorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             focusedErrorBorder: OutlineInputBorder(
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(4)),
                            //               borderSide: BorderSide(
                            //                   width: 1.2,
                            //                   color: Color(0xffF5F6FA)),
                            //             ),
                            //             // border: InputBorder.none,
                            //             hintText: "311",
                            //             hintStyle: TextStyle(
                            //                 color: Colors.grey, fontSize: 15)),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        )),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        if (this._formKey.currentState!.validate()) {
                          // _formKey.currentState!.save();

                          saveApi();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => CheckoutPayment()));
                        }
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
                ]),
              )),
        ));
  }
}
