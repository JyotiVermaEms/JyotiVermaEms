import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/DepatureWareHouseManager/getPickupAgentModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/component/Departure%20Manager/selectAgent_details.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/pages/Departure%20Manager/Order/Select_Pickup_agent.dart';

class SelectMarketAgent extends StatefulWidget {
  var pid;
  var bid;
  SelectMarketAgent({Key? key, required this.pid, required this.bid})
      : super(key: key);

  @override
  _SelectMarketAgentState createState() => _SelectMarketAgentState();
}

class _SelectMarketAgentState extends State<SelectMarketAgent> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SelectMPickupAgent(pid1: widget.pid, bid1: widget.bid),
        tablet: SelectMPickupAgent(pid1: widget.pid, bid1: widget.bid),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: DepartureSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: SelectMPickupAgent(pid1: widget.pid, bid1: widget.bid),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectMPickupAgent extends StatefulWidget {
  var pid1;
  var bid1;
  SelectMPickupAgent({Key? key, required this.pid1, required this.bid1})
      : super(key: key);

  @override
  _SelectMPickupAgentState createState() => _SelectMPickupAgentState();
}

class _SelectMPickupAgentState extends State<SelectMPickupAgent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var h, w;
  TextEditingController _names = TextEditingController();
  final TextEditingController controller = TextEditingController();
  Color CardColor = Color(0xffF7F6FB);
  bool Iamhovering = false;
  List<ListData>? pickupAgent;
  var pickupAgentnames = '';
  var agentList = [];
  var name;
  var pickupAgentid;
  var checklist;

  getAgentList() async {
    var response = await Providers().getPickupAgentlist();
    setState(() {
      pickupAgent = response.data;
    });
    for (int i = 0; i < pickupAgent!.length; i++) {
      agentList.add(pickupAgent![i].name);
    }
  }

  assignFunction() async {
    var pickagentid = widget.pid1;
    var agentId = pickagentid.split(' ');
    var pickupdata = {
      "market_id": widget.bid1.toString(),
      "pickupagent_id": agentId[0],

      // "${encodeToSHA3(password)}",
    };
    print("-=-=- $pickupdata");
    // return;
    var response = await Providers().assignMarketPickupAgent(pickupdata);
    if (response.status == true) {
      //=======add member to chat group========
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<ChatUsers> usersList = [];
      usersList.add(ChatUsers(int.parse(agentId[0]), "5"));

      var localRoomId = prefs.getInt("localRoomId");
      print("-=-=-localRoomId ${localRoomId}");
      print("-=-userLisat data ${jsonEncode(usersList)}");
      if (localRoomId != null) {
        print("in !=null");
        var addMemberdata = {
          "room_id": localRoomId.toString(),
          "users": "[{\"userId\":${int.parse(agentId[0])},\"userRole\":\"5\"}]"
          // "users": jsonEncode(usersList),
        };

        var responseAddMember = await Providers().addGroupMember(addMemberdata);
      }
      //=======add member to chat group========
      prefs.remove("localRoomId");
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAgentList();
  }

  @override
  Widget build(BuildContext context) {
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
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                          child: Text(
                            'Order> Assigned agent',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    (Responsive.isDesktop(context)) ? 22 : 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!Responsive.isDesktop(context)) mobileselectAgent(),
                  if (Responsive.isDesktop(context)) selectAgent()
                ],
              ))),
    );
  }

  Widget mobileselectAgent() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 50, top: 5),
      child: Column(children: [
        Card(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            margin: EdgeInsets.all(15),
            height: h * 0.32,
            width: MediaQuery.of(context).size.width * (80 / 100),
            // margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Choose agent",
                          // style: headingStyleBold(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  PopupMenuButton<String>(
                    tooltip: "",
                    initialValue: "pickupAgentnames",
                    child: Container(
                      height: 50,
                      width: w * 0.50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200]),
                      margin: EdgeInsets.only(top: 20, right: 10, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Center(
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                              Text(checklist == null
                                  ? "Select Agent"
                                  : checklist),
                            ])),
                      ),
                    ),
                    onSelected: (String value) {
                      print("=-=-= value $value");

                      _names.text = pickupAgentnames = _names.text;
                      widget.pid1 = value;
                      checklist = value;

                      print("=-=-= value ${widget.pid1}");

                      // this.initialValue =
                      setState(() {});
                    },
                    itemBuilder: (BuildContext context) {
                      return pickupAgent!.map((value) {
                        return PopupMenuItem(
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (90 / 100),
                                child: Text(value.id.toString() +
                                    "  " +
                                    "  " +
                                    value.name)),
                            value:
                                value.id.toString() + "  " + "  " + value.name);
                      }).toList();
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      width: w * 0.50,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            assignFunction();
                          }
                        },
                        child: Text('Assign'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 10, bottom: 5),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Pickup Agent List",
                // style: headingStyleBold(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              )),
        ),
        ListView.builder(
            itemCount: pickupAgent!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  height: h * 0.35,
                  width: MediaQuery.of(context).size.width * (80 / 100),
                  // margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),

                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: w * 0.23,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      "ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: w * 0.25,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),

                                    child: Text(
                                      pickupAgent![index].id.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            // Spacer(),
                            Row(
                              children: [
                                Container(
                                    width: w * 0.23,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(
                                      "Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: w * 0.25,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),

                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      pickupAgent![index].name.toString() +
                                          " " +
                                          pickupAgent![index].lname.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),

                            Row(
                              children: [
                                Container(
                                    width: w * 0.23,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                  width: w * 0.25,
                                  margin: EdgeInsets.only(top: 10),

                                  // Row(
                                  //   children: [

                                  child: Text(
                                    pickupAgent![index].email.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff1A494F)),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Container(
                                    width: w * 0.23,
                                    // width: MediaQuery.of(context).size.width * (20 / 100),
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(
                                      "Country",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: w * 0.25,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Center(
                                      child: Text(
                                        pickupAgent![index].country.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            ),

                            GestureDetector(
                              onTap: () {
                                print("__==-=-=-=-=-=-" +
                                    pickupAgent![index].id.toString());
                                var agentDetails = {
                                  'profileimage': pickupAgent![index]
                                      .profileimage
                                      .toString(),
                                  'id': pickupAgent![index].id.toString(),
                                  'name': pickupAgent![index].name.toString(),
                                  'lname': pickupAgent![index].lname.toString(),
                                  'username':
                                      pickupAgent![index].username.toString(),
                                  'phoneno':
                                      pickupAgent![index].phone.toString(),
                                  'email': pickupAgent![index].email.toString(),
                                  'address':
                                      pickupAgent![index].email.toString(),
                                  'country':
                                      pickupAgent![index].country.toString(),
                                };
                                print("==-=-===-=-=-=-=-=-=-=" +
                                    agentDetails.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AgentProfilDetails(agentDetails)),
                                );
                              },
                              child: Container(
                                  width: w * 0.45,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  // width:
                                  //     MediaQuery.of(context).size.width * (12 / 100),
                                  height: 40,
                                  margin: EdgeInsets.only(
                                      right: 20, bottom: 5, top: 10),
                                  child: Center(
                                    child: Text(
                                      "View Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
      ]),
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

  Widget selectAgent() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 50, top: 30),
      child: Column(children: [
        Card(
          margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            margin: EdgeInsets.all(15),
            height: h * 0.32,
            width: MediaQuery.of(context).size.width * (80 / 100),
            // margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Choose agent",
                          // style: headingStyleBold(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  PopupMenuButton<String>(
                    tooltip: "",
                    initialValue: "pickupAgentnames",
                    child: Container(
                      height: 50,
                      width: w * 0.30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[200]),
                      margin: EdgeInsets.only(top: 20, right: 10, bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Center(
                            child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                              ),
                              Text(checklist == null
                                  ? "Select Agent"
                                  : checklist),
                            ])),
                      ),
                    ),
                    onSelected: (String value) {
                      print("=-=-= value $value");

                      _names.text = pickupAgentnames = _names.text;
                      widget.pid1 = value;
                      checklist = value;

                      print("=-=-= value ${widget.pid1}");

                      // this.initialValue =
                      setState(() {});
                    },
                    itemBuilder: (BuildContext context) {
                      return pickupAgent!.map((value) {
                        return PopupMenuItem(
                            child: Container(
                                width: MediaQuery.of(context).size.width *
                                    (90 / 100),
                                child: Text(value.id.toString() +
                                    "  " +
                                    "  " +
                                    value.name)),
                            value:
                                value.id.toString() + "  " + "  " + value.name);
                      }).toList();
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      width: w * 0.12,
                      height: 35,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            assignFunction();
                          }
                        },
                        child: Text('Assign'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15, left: 10, bottom: 8),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Pickup Agent List",
                // style: headingStyleBold(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              )),
        ),
        orderTemplate(),
        orderDetails(),
      ]),
    );
  }

  Widget orderTemplate() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Container(
        // height: (!Responsive.isDesktop(context))
        //     ? MediaQuery.of(context).size.height * (10 / 100)
        //     : MediaQuery.of(context).size.height * (45 / 100),
        height: h * 0.06,
        width: MediaQuery.of(context).size.width * (80 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: w * 0.04,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "ID",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                // width: MediaQuery.of(context).size.width * (20 / 100),
                width: w * 0.08,
                // margin: EdgeInsets.only(right: 30),
                child: Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),

            Container(
                width: w * 0.08,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                child: Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
                width: w * 0.06,
                // width: MediaQuery.of(context).size.width * (20 / 100),
                // margin: EdgeInsets.only(left: 15),
                child: Text(
                  "Country",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // Spacer(),
            Container(
                width: w * 0.06,
                margin: EdgeInsets.only(right: 40),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                // width: MediaQuery.of(context).size.width * (10 / 100),
                child: Text(
                  "Action",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ],
        ),
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: pickupAgent!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Container(
              // height: (!Responsive.isDesktop(context))
              //     ? MediaQuery.of(context).size.height * (10 / 100)
              //     : MediaQuery.of(context).size.height * (45 / 100),
              height: 80,
              width: MediaQuery.of(context).size.width * (20 / 100),
              // margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w * 0.04,
                      // width: MediaQuery.of(context).size.width * (20 / 100),
                      margin: EdgeInsets.only(left: 35),
                      child: Text(
                        pickupAgent![index].id.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: w * 0.10,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      // margin: EdgeInsets.only(left: 20),
                      child: Text(
                        pickupAgent![index].name.toString() +
                            " " +
                            pickupAgent![index].lname.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                    width: w * 0.11,
                    // width: MediaQuery.of(context).size.width * (20 / 100),

                    // margin: EdgeInsets.only(left: 20),
                    child:
                        // Row(
                        //   children: [
                        Text(
                      pickupAgent![index].email.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A494F)),
                    ),
                  ),

                  Container(
                      width: w * 0.061,
                      // width: MediaQuery.of(context).size.width * (20 / 100),

                      child: Center(
                        child: Text(
                          pickupAgent![index].country.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )),

                  GestureDetector(
                    onTap: () {
                      print("__==-=-=-=-=-=-" +
                          pickupAgent![index].id.toString());
                      var agentDetails = {
                        'profileimage':
                            pickupAgent![index].profileimage.toString(),
                        'id': pickupAgent![index].id.toString(),
                        'name': pickupAgent![index].name.toString(),
                        'lname': pickupAgent![index].lname.toString(),
                        'username': pickupAgent![index].username.toString(),
                        'phoneno': pickupAgent![index].phone.toString(),
                        'email': pickupAgent![index].email.toString(),
                        'address': pickupAgent![index].email.toString(),
                        'country': pickupAgent![index].country.toString(),
                      };
                      print("==-=-===-=-=-=-=-=-=-=" + agentDetails.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AgentProfilDetails(agentDetails)),
                      );
                    },
                    child: Container(
                        width: w * 0.12,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width:
                        //     MediaQuery.of(context).size.width * (12 / 100),
                        height: 40,
                        margin: EdgeInsets.only(right: 20),
                        child: Center(
                          child: Text(
                            "View Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
