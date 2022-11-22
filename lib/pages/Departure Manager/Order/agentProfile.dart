import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/DepatureWareHouseManager/getPickupAgentModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/component/Departure%20Manager/selectAgent_details.dart';
import 'package:shipment/pages/Departure%20Manager/Order/agentProfile.dart';
import 'package:shipment/pages/Departure%20Manager/Settings/DepartureSettings.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ProfilDetails extends StatefulWidget {
  var details;
  ProfilDetails(this.details);

  @override
  _ProfilDetails createState() => _ProfilDetails();
}

class _ProfilDetails extends State<ProfilDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var h, w;
  TextEditingController _names = TextEditingController();
  final TextEditingController controller = TextEditingController();

  var imageList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("-==========-=-=-=-=-=-=" + widget.details.toString());
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: DepartureSidebar(),
      ),
      body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: ListView(
                children: [
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
                        if (Responsive.isDesktop(context)) SizedBox(width: 5),
                      ],
                    ),
                  ),
                  if (!Responsive.isDesktop(context)) mobileAgentDetails(),
                  if (Responsive.isDesktop(context)) AgentDetails()
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
      ],
    );
  }

  Widget mobileAgentDetails() {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Column(children: [
        // orderTemplate(),
        // orderDetails(),

        Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: widget.details['profileimage'].isNotEmpty
                    ? Container(
                        child: Image.network(
                          widget.details['profileimage'],
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 200,
                        width: 200,
                      )
                    : Container(
                        child: Icon(
                          Icons.person,
                          size: 200.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 200,
                        width: 200,
                      )),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 50),
              child: Container(
                  child: Container(
                // height: 350,
                child: Column(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 120,
                          child: Text(
                            "Agent ID",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['id'],
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
                          width: 120,
                          child: Text(
                            "First Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['name'],
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
                          width: 120,
                          child: Text(
                            "Last Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['lname'],
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
                          width: 120,
                          child: Text(
                            "User Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['username'],
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
                          width: 120,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['phoneno'],
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
                          width: 120,
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                widget.details['email'],
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
                          width: 120,
                          child: Text(
                            "Address",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['address'],
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
                          width: 120,
                          child: Text(
                            "Country",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['country'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              )),
            )
          ],
        ),
        SizedBox(
          height: 40,
        ),
      ]),
    ));
  }

  Widget AgentDetails() {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.fromLTRB(5, 20, 5, 30),
      child: Column(children: [
        // orderTemplate(),
        // orderDetails(),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Divider(
            height: 30,
            color: Colors.black,
            thickness: 2,
          ),
        ),
        Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: widget.details['profileimage'].isNotEmpty
                    ? Container(
                        child: Image.network(
                          widget.details['profileimage'],
                          fit: BoxFit.cover,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 350,
                        width: 350,
                      )
                    : Container(
                        child: Icon(
                          Icons.person,
                          size: 200.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        height: 350,
                        width: 350,
                      )),
            SizedBox(
              width: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                  child: Container(
                // height: 350,
                child: Column(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 120,
                          child: Text(
                            "Agent ID",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['id'],
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
                          width: 120,
                          child: Text(
                            "First Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['name'],
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
                          width: 120,
                          child: Text(
                            "Last Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['lname'],
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
                          width: 120,
                          child: Text(
                            "User Name",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['username'],
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
                          width: 120,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['phoneno'],
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
                          width: 120,
                          child: Text(
                            "Email",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                widget.details['email'],
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
                          width: 120,
                          child: Text(
                            "Address",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['address'],
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
                          width: 120,
                          child: Text(
                            "Country",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: w * 0.39,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.details['country'],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Container(
                    //     width: 120,
                    //     child: Text(
                    //       "Transaction Id",
                    //       style: TextStyle(color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 10,
                    //   ),
                    //   child: Container(
                    //     height: 40,
                    //     width: w * 0.39,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(15)),
                    //     child: Center(
                    //       child: Text(
                    //         "",
                    //         style: TextStyle(color: Colors.black),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10, left: 10),
                    //   child: Container(
                    //     width: 120,
                    //     child: Text(
                    //       "Total Amount",
                    //       style: TextStyle(color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     top: 10,
                    //   ),
                    //   child: Container(
                    //     height: 40,
                    //     width: w * 0.39,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius: BorderRadius.circular(15)),
                    //     child: Center(
                    //       child: Text(
                    //         "",
                    //         style: TextStyle(color: Colors.black),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )),
            )
          ],
        ),
        SizedBox(
          height: 40,
        ),

        // Center(
        //   child: Container(
        //       width: w * 0.2,
        //       decoration: BoxDecoration(
        //           color: Colors.green,
        //           borderRadius: BorderRadius.all(Radius.circular(20))),
        //       // width:
        //       //     MediaQuery.of(context).size.width * (12 / 100),
        //       height: 50,
        //       margin: EdgeInsets.only(right: 20),
        //       child: Center(
        //         child: Text(
        //           "Request for Change Password",
        //           style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 14,
        //               color: Colors.white),
        //         ),
        //       )),
        // ),
      ]),
    ));
  }
}
