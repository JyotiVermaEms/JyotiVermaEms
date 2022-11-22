import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Shipment/getDepatureManagerListModel.dart';
import 'package:shipment/Model/Shipment/getarrivalMangerList.dart';
import 'package:shipment/Model/Shipment/marketplaceOrderDataModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_marketplace_Shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/shimarketBookingDetails.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SubmitProposal extends StatefulWidget {
  var data;
  SubmitProposal(this.data);
  // const SubmitProposal({Key? key}) : super(key: key);

  @override
  _SubmitProposalState createState() => _SubmitProposalState();
}

class _SubmitProposalState extends State<SubmitProposal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var h, w;
  String? category;
  var imageList = [];

  var amount;
  var item = [
    "Boat",
    "Plane",
    "Ship",
  ];
  final TextEditingController _controllr = new TextEditingController();
  final TextEditingController _depcontrollr = new TextEditingController();

  final TextEditingController _arrivalcontrollr = new TextEditingController();

  var orderid;

  var departureId, arrivalId;

  var listData = [];
  var listData1 = [];

  List<ArrivalManagerDetais> managerList = [];
  List<DepatureManagerDetais> depaturemanagerList = [];

  getArrivalManagerName() async {
    var responce = await Providers().getArrivalManagerlist();
    print("responce.data-=-=-= ${responce.data}");

    managerList = responce.data;

    for (int i = 0; i < managerList.length; i++) {
      listData1.add({"id": managerList[i].id, "name": managerList[i].name});
    }
    setState(() {});
  }

  getDepatureManagerName() async {
    var responce = await Providers().getDepatureManagerlist();

    depaturemanagerList = responce.data;

    for (int i = 0; i < depaturemanagerList.length; i++) {
      listData.add({
        "id": depaturemanagerList[i].id,
        "name": depaturemanagerList[i].name
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ioioioioioioi${widget.data['category']}");

    print("ioioioioioioi${widget.data['itemimage']}");
    for (int i = 0; i < widget.data['itemimage'].length; i++) {
      imageList.add(widget.data['itemimage'][i].toString());
    }
    print(":imageList");
    print(imageList);

    print("<<<<<<<<>>>>>>>>>" + widget.data['id'].toString());
    orderid = widget.data['id'].toString();
    print("=-=-=-=" + orderid.toString());
    bookingdetailsAPI();
    getArrivalManagerName();
    getDepatureManagerName();
  }

  List<orderData> orderhistory = [];
  var title,
      date,
      desp,
      bookingAttribute,
      email,
      name,
      uid,
      shipingfee,
      tax,
      time,
      pickupfee,
      quantity,
      notes,
      picklocation,
      categoryitem,
      dropoflocation,
      categroyshow;
  bookingdetailsAPI() async {
    var data = {"market_id": orderid.toString()};
    print("Data>>>>>>> $data");

    var response = await Providers().marketplaceOrderDetails(data);
    print("in bookingdetails ${response.status}");

    if (response.status == true) {
      print("Successfully run api");
      for (int i = 0; i < response.data.length; i++) {
        orderhistory.add(response.data[i]);

        title = response.data[i].title;
        print("title  $title");
        date = response.data[i].createdAt.substring(0, 10);
        time = response.data[i].createdAt.substring(11, 16);

        print("createdAt  $date");

        name = response.data[i].client[0].name;
        print("name  $name");
        email = response.data[i].client[0].email;
        print("email  $email");
        uid = response.data[i].client[0].id;
        picklocation = response.data[i].pickupLocation;
        dropoflocation = response.data[i].dropoffLocation;

        print("uid  $uid");
        categroyshow = response.data[i].category.toString();
        print(">>>>>>>>>>>>>>>>" + categroyshow);
      }

      setState(() {});
    }
  }

  sendProposal() async {
    var data = {
      "uid": "$uid",
      "mid": orderid.toString(),
      "proposal": "$notes",
      "type": _controllr.text.toString(),
      "pickupfee": pickupfee.toString(),
      "shipping_price": shipingfee.toString(),
      "tax": tax.toString(),
      "departure_id": departureId.toString(),
      "arrival_id": arrivalId.toString()
    };

    print(data);
    //return;

    var responce = await Providers().sendOrderProposal(data);

    if (responce.status == true) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(responce.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResMarketPlaceShipment()));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  var marketplaceid, status;

  @override
  Widget build(BuildContext context) {
    print("=-=-=-=" + widget.data['itemimage'].toString());

    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: ShipmentSidebar(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffF7F8F9),
            child: SafeArea(
                right: false,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
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
                            margin: (Responsive.isDesktop(context))
                                ? EdgeInsets.fromLTRB(5, 10, 50, 0)
                                : EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Market Place > Submit a proposal',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: (Responsive.isDesktop(context))
                                          ? 22
                                          : 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isDesktop(context))
                      Column(
                        children: [
                          // topBar(),
                          proposalSetting(),
                          bookingDetails(),
                          terms(),
                          additionalDetails(),
                          buttons(),
                        ],
                      ),
                    if (Responsive.isDesktop(context))
                      Column(
                        children: [
                          proposalSetting(),
                          bookingDetails(),
                          terms(),
                          additionalDetails(),
                          buttons(),
                        ],
                      ),
                  ],
                ))),
      ),
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

  Widget proposalSetting() {
    return (Responsive.isDesktop(context))
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            height: h * 0.38,
            width: w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "Proposal Settings",
                          style: headingStyleAppColor18MB(),
                        ),
                      ),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                      color: Colors.grey,
                      height: 36,
                    )),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "Propose with a Specialized profile",
                          style: headingStyleNormal(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 300,
                        margin: EdgeInsets.only(left: 16, right: 10),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
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
                                    decoration: InputDecoration(
                                        hintText: "Please Select Ship Type"),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    print(_controllr.text);
                                    category = value;
                                    _controllr.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return item.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return new PopupMenuItem(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (90 / 100),
                                              child: new Text(value)),
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
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "This proposal requires XYZ",
                          style: headingStyleNormal(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          "When you submit this proposal, you'll have XYZ remaining.",
                          style: headingStyleNormal(),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        child: Text(
                          "Choose Departure agent",
                          style: headingStyleNormal(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 300,
                        margin: EdgeInsets.only(left: 16, right: 10),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: false,
                                    controller: _depcontrollr,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Please choose departure agent"),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    print(_depcontrollr.text);

                                    _depcontrollr.text = value;

                                    int trendIndex = listData
                                        .indexWhere((f) => f['name'] == value);

                                    departureId = listData[trendIndex]['id'];

                                    setState(() {});
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return depaturemanagerList.map((value) {
                                      return PopupMenuItem(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (90 / 100),
                                              child:
                                                  Text(value.name.toString())),
                                          value: value.name.toString());
                                    }).toList();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 80, left: 10),
                        child: Text(
                          "Choose Arrival agent",
                          style: headingStyleNormal(),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 300,
                        margin: EdgeInsets.only(left: 16, right: 10),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: false,
                                    controller: _arrivalcontrollr,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Please choose arrival agent"),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    print(_arrivalcontrollr.text);

                                    _arrivalcontrollr.text = value;

                                    int trendIndex1 = listData1
                                        .indexWhere((f) => f['name'] == value);

                                    arrivalId = listData1[trendIndex1]['id'];
                                    setState(() {});
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return managerList.map((value) {
                                      return PopupMenuItem(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (90 / 100),
                                              child:
                                                  Text(value.name.toString())),
                                          value: value.name.toString());
                                    }).toList();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
        : Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            height: h * 0.38,
            width: w,
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Proposal Settings",
                              style: headingStyleAppColor18MB(),
                            ),
                          ),
                        ),
                        Container(
                            child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Propose with a Specialized profile",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 300,
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
                                        decoration: InputDecoration(
                                            hintText:
                                                "Please Select Ship Type"),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (String value) {
                                        print(_controllr.text);
                                        category = value;
                                        _controllr.text = value;
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return item.map<PopupMenuItem<String>>(
                                            (String value) {
                                          return new PopupMenuItem(
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      (90 / 100),
                                                  child: new Text(value)),
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "This proposal requires XYZ",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "When you submit this proposal, you'll have XYZ remaining.",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 80, left: 10),
                            child: Text(
                              "Choose Departure agent",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 300,
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
                                        controller: _depcontrollr,
                                        decoration: InputDecoration(
                                            hintText:
                                                "Please choose departure agent"),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (String value) {
                                        print(_depcontrollr.text);

                                        _depcontrollr.text = value;

                                        int trendIndex = listData.indexWhere(
                                            (f) => f['name'] == value);

                                        departureId =
                                            listData[trendIndex]['id'];

                                        setState(() {});
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return depaturemanagerList.map((value) {
                                          return PopupMenuItem(
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      (90 / 100),
                                                  child: Text(
                                                      value.name.toString())),
                                              value: value.name.toString());
                                        }).toList();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 80, left: 10),
                            child: Text(
                              "Choose Arrival agent",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 300,
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
                                        controller: _arrivalcontrollr,
                                        decoration: InputDecoration(
                                            hintText:
                                                "Please choose arrival agent"),
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.arrow_drop_down),
                                      onSelected: (String value) {
                                        print(_arrivalcontrollr.text);

                                        _arrivalcontrollr.text = value;

                                        int trendIndex1 = listData1.indexWhere(
                                            (f) => f['name'] == value);

                                        arrivalId =
                                            listData1[trendIndex1]['id'];
                                        setState(() {});
                                      },
                                      itemBuilder: (BuildContext context) {
                                        return managerList.map((value) {
                                          return PopupMenuItem(
                                              child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      (90 / 100),
                                                  child: Text(
                                                      value.name.toString())),
                                              value: value.name.toString());
                                        }).toList();
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ));
  }

  Widget bookingDetails() {
    return (Responsive.isDesktop(context))
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            // height: h * 0.70,
            width: w,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "Booking Details",
                      style: headingStyleAppColor18MB(),
                    ),
                  ),
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: w * 0.30,
                      child: Column(
                        children: [
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("Title",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(title,
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(date.toString(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("Time",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(time.toString(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("Pickup Location",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(picklocation.toString(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text("DropOff Location",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(left: 20, top: 10),
                                  child: Text(dropoflocation.toString(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Text("Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ),
                                Spacer(),
                                Container(
                                  width: 180,
                                  margin: EdgeInsets.only(
                                      left: 20, top: 10, bottom: 10),
                                  child: Text(email.toString(),
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ]),
                        ],
                      ),
                    ),
                    Container(
                        // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: VerticalDivider(
                      color: Colors.grey,
                    )),
                    Container(
                      width: w * 0.30,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: imageList.isNotEmpty
                                  ? CarouselSlider(
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                        autoPlay: true,
                                      ),
                                      items: imageList
                                          .map((item) => InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return imageViewDialog(
                                                          context,
                                                          item,
                                                          imageList);
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Image.network(
                                                    item,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  : Center(
                                      child: Text(
                                      "No Image Available",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 250,
                              width: 300,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            // height: h * 0.70,
            width: w,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "Booking Details",
                      style: headingStyleAppColor18MB(),
                    ),
                  ),
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Container(
                  height: h * 0.5,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView(scrollDirection: Axis.vertical, children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: w * 0.99,
                            child: Column(
                              children: [
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    width: 100,
                                    child: Text("Title",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                  Spacer(),
                                  Container(
                                    width: 180,
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(title.toString(),
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text("Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 180,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(date.toString(),
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text("Time",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 180,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(time.toString(),
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text("Pickup Location",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 180,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(picklocation.toString(),
                                            softWrap: true,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text("DropOff Location",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 180,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 10),
                                        child: Text(dropoflocation.toString(),
                                            softWrap: true,
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 100,
                                        margin: EdgeInsets.only(
                                            left: 20, top: 10, bottom: 10),
                                        child: Text("Email",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 180,
                                        margin: EdgeInsets.only(
                                            left: 20, top: 10, bottom: 10),
                                        child: Text(email.toString(),
                                            style: TextStyle(fontSize: 16)),
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                          Container(
                              child: Divider(
                            color: Colors.grey,
                          )),
                          Container(
                            width: w * 0.8,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    child: imageList.isNotEmpty
                                        ? CarouselSlider(
                                            options: CarouselOptions(
                                              enableInfiniteScroll: false,
                                              autoPlay: true,
                                            ),
                                            items: imageList
                                                .map((item) => InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return imageViewDialog(
                                                                context,
                                                                item,
                                                                imageList);
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Image.network(
                                                          item,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                          )
                                        : Center(
                                            child: Text(
                                            "No Image Available",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 250,
                                    width: 300,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
  }

  Widget terms() {
    return (Responsive.isDesktop(context))
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            height: h * 0.70,
            width: w,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        "Terms",
                        style: headingStyleAppColor18MB(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 30),
                      child: Text(
                        "Client's budget:  " +
                            widget.data['clientbugdet'] +
                            "\$",
                        // + widget.data['totalamount'],

                        style: headingStyleAppColor18MB(),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                color: Colors.grey,
                height: 36,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: w * 0.50,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "What is the rate you'd like to bid for this job?",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Your Shipment profile rate: 100.00",
                              style: headingStyle16blacknormal(),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      "Shipping Price (\$)",
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      "Total amount the client will see on your proposal",
                                      overflow: (!Responsive.isDesktop(context))
                                          ? TextOverflow.ellipsis
                                          : TextOverflow.visible,
                                      style: headingStyleAppColor14MB(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: (Responsive.isDesktop(context))
                                    ? 200
                                    : w * 0.30,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    shipingfee = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "250",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "Tax",
                                  style: headingStyle16blacknormal(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: 200,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    tax = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "20",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      "Pick-up Fee",
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      "The estimated amount you'll receive after service fees",
                                      style: headingStyleAppColor14MB(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: 200,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    pickupfee = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "10",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: VerticalDivider(
                    color: Colors.grey,
                  )),
                  Container(
                    width: w * 0.20,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                          // height: 150,
                          // width: 300,
                          decoration: BoxDecoration(
                            // border: Border.all(

                            //     width: 0.5, color: Color(0xffACACAC)),
                            // borderRadius: BorderRadius.circular(0.0),
                            color: Color(0xffFFFFFF),
                          ),
                          margin: EdgeInsets.only(top: 32, right: 10, left: 20),
                          child: Image.asset(
                            'assets/images/Frame.png',
                            fit: BoxFit.cover,
                          )),
                    ),
                  )
                ],
              ),
            ]))
        : Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black),
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            margin: EdgeInsets.only(left: 24, top: 15, right: 10),
            height: h * 0.75,
            width: w,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      child: Text(
                        "Terms",
                        style: headingStyleAppColor18MB(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 30),
                      child: Text(
                        "Client's budget:  " +
                            widget.data['clientbugdet'] +
                            "\$",
                        // + widget.data['totalamount'],

                        style: headingStyleAppColor18MB(),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                color: Colors.grey,
                height: 36,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: w * 0.80,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "What is the rate you'd like to bid for this job?",
                              style: headingStyleNormal(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              "Your Shipment profile rate: 100.00",
                              style: headingStyle16blacknormal(),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    // height: 40,
                                    // width: w * 0.5,
                                    child: Text(
                                      "Shipping Price (\$)",
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    // height: 40,
                                    // width: w * 0.5,
                                    margin: EdgeInsets.only(top: 10, left: 5),
                                    child: Text(
                                        "Total amount the client " +
                                            "\n" +
                                            " will see on your proposal",
                                        softWrap: true,
                                        overflow:
                                            (!Responsive.isDesktop(context))
                                                ? TextOverflow.ellipsis
                                                : TextOverflow.visible,
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: (Responsive.isDesktop(context))
                                    ? 200
                                    : w * 0.30,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    shipingfee = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "250",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                // width: w * 0.5,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  "Tax",
                                  style: headingStyle16blacknormal(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: (Responsive.isDesktop(context))
                                    ? 200
                                    : w * 0.30,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    tax = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "20",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                          color: Colors.grey,
                          height: 36,
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                      "Pick-up Fee",
                                      style: headingStyle16blacknormal(),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    width: w * 0.40,
                                    margin: EdgeInsets.only(top: 10, left: 10),
                                    child: Text(
                                        "The estimated amount you'll receive after service fees",
                                        // style: headingStyleAppColor14MB(),
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 15),
                                width: (Responsive.isDesktop(context))
                                    ? 200
                                    : w * 0.30,
                                child: TextFormField(
                                  initialValue: "", // autofocus: false,
                                  // maxLines: 3,
                                  onChanged: (v) {
                                    pickupfee = v;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'required*';
                                    }
                                    return null;
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
                                      hintText: "10",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: VerticalDivider(
                    color: Colors.grey,
                  )),
                ],
              ),
            ]));
  }

  Widget additionalDetails() {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        margin: EdgeInsets.only(left: 24, top: 15, right: 10),
        height: (Responsive.isDesktop(context)) ? h * 0.50 : h * 0.60,
        width: w,
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Additional details",
                style: headingStyleAppColor18MB(),
              ),
            ),
          ),
          Container(
              // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
            color: Colors.grey,
            height: 36,
          )),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Additional Note",
                style: headingStyle16blacknormal(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Introduce yourself and explain why you’re a strong candidate for this job. Feel free to suggest any changes to the job details or ask to schedule a video call.",
                style: headingStyle16blacknormal(),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: TextFormField(
              initialValue: "",
              autofocus: false,
              maxLines: 3,
              maxLength: 250,
              onChanged: (v) {
                setState(() {
                  notes = v;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'required*';
                }
                return null;
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
          // Container(
          //     // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
          //     child: Divider(
          //   color: Colors.grey,
          //   height: 36,
          // )),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //     margin: EdgeInsets.only(top: 10, left: 10),
          //     child: Text(
          //       "Attachments",
          //       style: headingStyle16blacknormal(),
          //     ),
          //   ),
          // ),
          // DottedBorder(
          //   padding: EdgeInsets.only(top: 10, left: 10),
          //   color: Colors.black,
          //   strokeWidth: 1,
          //   child: Container(
          //     width: w,
          //     height: h * 0.10,
          //     // decoration: BoxDecoration(
          //     //   borderRadius: BorderRadius.circular(0.0),
          //     //   color: Color(0xffE5E5E5),
          //     // ),
          //     child: Center(
          //       child: Text(
          //         'drag or upload project files',
          //         style: headingStyle16blacknormal(),
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //     margin: EdgeInsets.only(top: 10, left: 10),
          //     child: Text(
          //       "You may attach up to 10 files under the size of 25MB each. Include work samples or other documents to support your application. Do not attach your résumé — your Upwork profile is automatically forwarded to the client with your proposal.",
          //       style: headingStyle16blacknormal(),
          //     ),
          //   ),
          // ),
        ]));
  }

  Widget buttons() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_controllr.text.isEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("Please Select ship type"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              if (_depcontrollr.text.isEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("Please choose departure agent"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }

              if (_arrivalcontrollr.text.isEmpty) {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text("Please choose arrival agent"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
                return;
              }
              if (_formKey.currentState!.validate()) {
                sendProposal();
              }
              // acceptBooking();
              // sendProposal();
            },
            child: Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
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
                          child: Text("Send Proposal",
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
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).pop();
          //   },
          //   child: Container(
          //     width: 100,
          //     height: 60,
          //     margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(50.0),
          //         // border: Border.all(color: Colors.black),
          //         color: Colors.red),
          //     child: Center(
          //         child: Text("Reject",
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 16,
          //             ))),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget summaryBox(data) {
    return Container(
      height: MediaQuery.of(context).size.height * (80 / 100),
      // height: 100,
      width: (Responsive.isDesktop(context))
          ? MediaQuery.of(context).size.width * (70 / 100)
          : MediaQuery.of(context).size.width * (100 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // color: Color(0xffE5E5E5),
      ),

      child: Column(children: [
        Row(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 20, right: 10, bottom: 5),
                child: Text(
                  "Item Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 10, bottom: 10),
            child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: 25,
                )),
          ),
        ]),
        Expanded(
          child: Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              width: w * 0.70,
              height: h * 0.80,

              // color: Color(0xffE5E5E5),
              // decoration: BoxDecoration(
              //     border: Border.all(width: 0.5, color: Colors.black),
              //     borderRadius: BorderRadius.circular(10.0),
              //     color: Colors.white),
              child: ListView.builder(
                  itemCount: widget.data['category'].length,
                  reverse: false,
                  itemBuilder: (context, index) {
                    var jsondata =
                        widget.data['category'][index].bookingAttribute;
                    // var jsondata = widget.data['itemdetail'][index].itemName;
                    print("ehdjhjkdhjhd$jsondata");
                    print("-=--=-=-=${jsondata.length}");
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: Colors.black),
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   child: imageList.length != 0
                                  //       ? CarouselSlider(
                                  //           options: CarouselOptions(
                                  //             enableInfiniteScroll: false,
                                  //             autoPlay: true,
                                  //             onPageChanged: (index, reason) {
                                  //               setState(() {
                                  //                 _currentIndex = index;
                                  //               });
                                  //               //print(_currentIndex);
                                  //             },
                                  //           ),
                                  //           items: imageList
                                  //               .map<Widget>((item) =>
                                  //                   InkWell(
                                  //                     onTap: () {
                                  //                       showDialog(
                                  //                         context: context,
                                  //                         builder:
                                  //                             (BuildContext
                                  //                                 context) {
                                  //                           return imageViewDialog(
                                  //                               context,
                                  //                               item);
                                  //                         },
                                  //                       );
                                  //                     },
                                  //                     child: Padding(
                                  //                       padding:
                                  //                           const EdgeInsets
                                  //                               .all(5.0),
                                  //                       child: Container(
                                  //                         height: 150,
                                  //                         width: 230,
                                  //                         child:
                                  //                             Image.network(
                                  //                           item,
                                  //                           fit: BoxFit.cover,
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ))
                                  //               .toList(),
                                  //         )
                                  //       : Center(
                                  //           child: Text(
                                  //           "No Image Available",
                                  //           style: TextStyle(
                                  //               color: Colors.black,
                                  //               fontSize: 16,
                                  //               fontWeight: FontWeight.bold),
                                  //         )),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.white,
                                  //       borderRadius:
                                  //           BorderRadius.circular(15)),
                                  //   height: 150,
                                  //   width: 230,
                                  // ),

                                  SizedBox(width: kDefaultPadding / 2),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Category :",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              // style: Theme.of(context)
                                              //     .textTheme
                                              //     .caption!
                                              //     .copyWith(
                                              //       color: Colors.black,
                                              //     ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Container(
                                            child: Text(
                                              widget.data['category'][index]
                                                      .categoryItem +
                                                  "  " +
                                                  "(" +
                                                  "Quantity :" +
                                                  widget.data['category'][index]
                                                      .quantity
                                                      .toString() +
                                                  ")",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Item Name : ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Row(
                                              children: List.generate(
                                            jsondata.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                jsondata[index] + ",",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          )),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10, bottom: 10),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Description : ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Container(
                                            height: 40,
                                            width: 500,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                child: Text(
                                                    widget.data['description']
                                                        .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500)
                                                    // style: Theme.of(context)
                                                    //     .textTheme
                                                    //     .caption!
                                                    //     .copyWith(
                                                    //       color: Colors.black,
                                                    //     ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10, bottom: 10),
                                          child: Container(
                                            width: 100,
                                            child: Text(
                                              "Needs  : ",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                          ),
                                          child: Container(
                                            height: 40,
                                            width: 500,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  widget.data['needs']
                                                      .toString(),
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500)
                                                  // style: Theme.of(context)
                                                  //     .textTheme
                                                  //     .caption!
                                                  //     .copyWith(
                                                  //       color: Colors.black,
                                                  //     ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, top: 5),
                                        child: Divider(
                                          height: 30,
                                          color: Colors.black,
                                          thickness: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Text.rich(
                                  //   TextSpan(
                                  //     text: "jsdkjksjf",
                                  //     style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w500,
                                  //       color: kTextColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(0, 10),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(11, 19),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // Text(
                                      //   notificationData[index]
                                      //       .createdAt
                                      //       .substring(0, 10),
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .caption!
                                      //       .copyWith(
                                      //         color: Colors.black,
                                      //       ),
                                      // ),
                                      // SizedBox(height: 5),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(height: kDefaultPadding / 2),
                              // Text(
                              //   chat!.body,
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: Theme.of(context).textTheme.caption!.copyWith(
                              //         height: 1.5,
                              //         color: isActive ? Colors.white70 : null,
                              //       ),
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        ),
      ]),
    );
  }
}

class BookingAttributeDetails extends StatefulWidget {
  var data;
  BookingAttributeDetails(this.data);

  @override
  _BookingAttributeDetails createState() => _BookingAttributeDetails();
}

class _BookingAttributeDetails extends State<BookingAttributeDetails> {
  var imageList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var jsondata;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.data['category'].length; i++) {
      //   print("-=-=-=-=-=${widget.data['category'][i].quantity.toString()} ");
      //   print("-=-=-=-=-=${widget.data['category'][i].categoryItem.toString()} ");

      for (int j = 0;
          j < widget.data['category'][i].bookingAttribute.length;
          j++) {
        print("-=-=-=-=-=${widget.data['category'][i].bookingAttribute[j]} ");

        jsondata = widget.data['category'][i].bookingAttribute[j];
        print("0-000-0-0-$jsondata");
      }
    }
  }

  var w, h;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    var _currentIndex = 0;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250), child: ShipmentSidebar()),
      body: Container(
        height: h * 0.80,
        margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: Column(children: [
          // Container(
          //   margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          //   child: Divider(
          //     height: 30,
          //     color: Colors.black,
          //     thickness: 2,
          //   ),
          // ),
          Row(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 10, top: 50, bottom: 5),
                  child: Text(
                    "Item Details",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(
                right: 40,
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                  )),
            ),
          ]),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),

                // color: Color(0xffE5E5E5),
                // decoration: BoxDecoration(
                //     border: Border.all(width: 0.5, color: Colors.black),
                //     borderRadius: BorderRadius.circular(10.0),
                //     color: Colors.white),
                child: ListView.builder(
                    itemCount: widget.data['category'].length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      var jsondata =
                          widget.data['category'][index].bookingAttribute;
                      // var jsondata = widget.data['itemdetail'][index].itemName;
                      print("ehdjhjkdhjhd$jsondata");
                      print("-=--=-=-=${jsondata.length}");
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Container(
                                    //   child: imageList.length != 0
                                    //       ? CarouselSlider(
                                    //           options: CarouselOptions(
                                    //             enableInfiniteScroll: false,
                                    //             autoPlay: true,
                                    //             onPageChanged: (index, reason) {
                                    //               setState(() {
                                    //                 _currentIndex = index;
                                    //               });
                                    //               //print(_currentIndex);
                                    //             },
                                    //           ),
                                    //           items: imageList
                                    //               .map<Widget>((item) =>
                                    //                   InkWell(
                                    //                     onTap: () {
                                    //                       showDialog(
                                    //                         context: context,
                                    //                         builder:
                                    //                             (BuildContext
                                    //                                 context) {
                                    //                           return imageViewDialog(
                                    //                               context,
                                    //                               item);
                                    //                         },
                                    //                       );
                                    //                     },
                                    //                     child: Padding(
                                    //                       padding:
                                    //                           const EdgeInsets
                                    //                               .all(5.0),
                                    //                       child: Container(
                                    //                         height: 150,
                                    //                         width: 230,
                                    //                         child:
                                    //                             Image.network(
                                    //                           item,
                                    //                           fit: BoxFit.cover,
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   ))
                                    //               .toList(),
                                    //         )
                                    //       : Center(
                                    //           child: Text(
                                    //           "No Image Available",
                                    //           style: TextStyle(
                                    //               color: Colors.black,
                                    //               fontSize: 16,
                                    //               fontWeight: FontWeight.bold),
                                    //         )),
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.white,
                                    //       borderRadius:
                                    //           BorderRadius.circular(15)),
                                    //   height: 150,
                                    //   width: 230,
                                    // ),

                                    SizedBox(width: kDefaultPadding / 2),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10),
                                            child: Container(
                                              width: 100,
                                              child: Text(
                                                "Category : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                // style: Theme.of(context)
                                                //     .textTheme
                                                //     .caption!
                                                //     .copyWith(
                                                //       color: Colors.black,
                                                //     ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10),
                                            child: Container(
                                              child: Text(
                                                widget.data['category'][index]
                                                        .categoryItem +
                                                    "  " +
                                                    "(" +
                                                    "Quantity :" +
                                                    widget
                                                        .data['category'][index]
                                                        .quantity
                                                        .toString() +
                                                    ")",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10),
                                            child: Container(
                                              width: 100,
                                              child: Text(
                                                "Item Name : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10),
                                            child: Row(
                                                children: List.generate(
                                              jsondata.length,
                                              (index) => Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  jsondata[index] + ",",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            )),
                                          ),
                                        ]),
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10, bottom: 10),
                                            child: Container(
                                              width: 100,
                                              child: Text(
                                                "Description : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Container(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  child: Text(
                                                      widget.data['description']
                                                          .toString(),
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500)
                                                      // style: Theme.of(context)
                                                      //     .textTheme
                                                      //     .caption!
                                                      //     .copyWith(
                                                      //       color: Colors.black,
                                                      //     ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 10, bottom: 10),
                                            child: Container(
                                              width: 100,
                                              child: Text(
                                                "Needs  : ",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: Container(
                                              height: 40,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    widget.data['needs']
                                                        .toString(),
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500)
                                                    // style: Theme.of(context)
                                                    //     .textTheme
                                                    //     .caption!
                                                    //     .copyWith(
                                                    //       color: Colors.black,
                                                    //     ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          child: Divider(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Text.rich(
                                    //   TextSpan(
                                    //     text: "jsdkjksjf",
                                    //     style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w500,
                                    //       color: kTextColor,
                                    //     ),
                                    //   ),
                                    // ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        // Text(
                                        //   notificationData[index]
                                        //       .createdAt
                                        //       .substring(0, 10),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .caption!
                                        //       .copyWith(
                                        //         color: Colors.black,
                                        //       ),
                                        // ),
                                        // Text(
                                        //   notificationData[index]
                                        //       .createdAt
                                        //       .substring(11, 19),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .caption!
                                        //       .copyWith(
                                        //         color: Colors.black,
                                        //       ),
                                        // ),
                                        // Text(
                                        //   notificationData[index]
                                        //       .createdAt
                                        //       .substring(0, 10),
                                        //   style: Theme.of(context)
                                        //       .textTheme
                                        //       .caption!
                                        //       .copyWith(
                                        //         color: Colors.black,
                                        //       ),
                                        // ),
                                        // SizedBox(height: 5),
                                      ],
                                    ),
                                  ],
                                ),
                                // SizedBox(height: kDefaultPadding / 2),
                                // Text(
                                //   chat!.body,
                                //   maxLines: 2,
                                //   overflow: TextOverflow.ellipsis,
                                //   style: Theme.of(context).textTheme.caption!.copyWith(
                                //         height: 1.5,
                                //         color: isActive ? Colors.white70 : null,
                                //       ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          ),
        ]),
      ),
    );
  }
}
