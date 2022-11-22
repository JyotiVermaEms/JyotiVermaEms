// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/ColorUtility.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/broadCastMessageModel.dart';

import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/clientInfo.dart';

import 'package:shipment/pages/Shipment/Dashboard/ClientInfo/orderlist.dart';
import 'package:shipment/pages/Shipment/Dashboard/dashboard_Container.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class BroadCastMessageScreen extends StatefulWidget {
  BroadCastMessageScreen();

  @override
  _BroadCastMessageScreen createState() => _BroadCastMessageScreen();
}

class _BroadCastMessageScreen extends State<BroadCastMessageScreen> {
  List<BroadcastUsers> usersList = [];
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController1 = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: ShipmentSidebar(),
        ),
        body: Container(
            color: Color(0xffE5E5E5),
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            child: Form(
                // key: _formKey,
                child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.only(top: 20, left: 30),
                      child: Text(
                        'Broadcast message >',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 100, top: 40),
                      child: Text("Title",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 100, top: 10, right: 100),
                      child: TextFormField(
                        maxLength: 25,
                        onChanged: (value) {},
                        // controller: _textFieldController,
                        // show below validator
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(25.0),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            // border: InputBorder.none,
                            hintText: "Enter Title",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(
                        left: 100,
                      ),
                      child: Text("Message",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 100, top: 10, right: 100),
                      child: TextFormField(
                        maxLines: 7,
                        maxLength: 250,
                        onChanged: (value) {},
                        controller: _textFieldController1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter message';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              // borderRadius: new BorderRadius.circular(25.0),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1.2, color: Colors.grey),
                            ),
                            // border: InputBorder.none,
                            hintText: "Enter Message",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.black),
                          height: 45,
                          width: (!Responsive.isDesktop(context))
                              ? MediaQuery.of(context).size.width * (20 / 100)
                              : MediaQuery.of(context).size.width * (15 / 100),
                          margin: EdgeInsets.only(left: 40, top: 10),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xff4CAF50)),
                          height: 45,
                          width: (!Responsive.isDesktop(context))
                              ? MediaQuery.of(context).size.width * (9 / 100)
                              : MediaQuery.of(context).size.width * (15 / 100),
                          margin:
                              EdgeInsets.only(right: 100, left: 40, top: 10),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Send',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ))));
  }
}
