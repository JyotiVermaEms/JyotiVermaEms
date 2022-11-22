// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/showScheduleItemsModel.dart';
import 'package:shipment/Model/Shipment/getDepatureManagerListModel.dart';
import 'package:shipment/Model/Shipment/getarrivalMangerList.dart';
import 'package:shipment/Model/Shipment/scheduleShipmentRes.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Schedule_shipment_item.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/ScheduleShipment.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/schedulCategory.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  _SelectCategory createState() => _SelectCategory();
}

class _SelectCategory extends State<SelectCategory>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var h, w;
  TextEditingController datefilter = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController _depaturenames = TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();
  var _textFieldController = TextEditingController();
  var _textFieldController1 = TextEditingController();
  TabController? _tabController;
  TabController? _controller;
  var selected = [];
  String shipmentTypeText = 'Plane';
  var shipmentTypeArray = ['Plane', 'Boat', 'Road'];
  String scheduleTitle = '';
  var fromLocation = '';
  var toLocation = '';
  var departureDate = '';
  var destiWarehouse = '';
  var arrivalManagernames = '';
  var depatureManagernames = '';
  var valueText = '';
  List<String> valueText1 = [];
  var codeDialog = '';
  var data = [];
  var data1 = [];
  // List itemTypeList = [];
  List<ShowScheduleItemsModelData> itemTypeListModel =
      <ShowScheduleItemsModelData>[];
  List<ShowScheduleItemsModelData>? scheduleItemlist;
  var itemNames = [];
  static List<String> attributeList = [];

  String? category, deusename;
  int tab = 0;

  var amount;
  List<scheduleShipmentResData>? scheduldata;

  List<List<Items>> item123 = [];
  List<ArrivalManagerDetais>? managerList;
  List<DepatureManagerDetais> depaturemanagerList = [];

  // var item123 = [];
  // final TextEditingController _itemTypecontrollr = new TextEditingController();
  List<TextEditingController> _itemTypecontrollr = [];

  List itemList = [];
  List iconlist = [];
  DateTime initialDate = DateTime.now();

  List<TextEditingController> _QTYcontrollr = [];
  List<TextEditingController> _Feecontrollr = <TextEditingController>[];
  List<TextEditingController> _PickFeecontrollr = [];

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;
      });
    builder:
    (context, child) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 100,
              width: 100,
              child: child,
            ),
          ),
        ],
      );
    };
  }

  List<String> categoryName = [];

  Widget addlist() {
    return ListView.builder(
        itemCount: categoryName.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            child: Text(categoryName[index]),
          );
        });
  }

  List<String> depmanName = [];
  List<String> arrmanName = [];

  List<String> _countries = [
    'India',
    'Japan',
    'China',
    'USA',
    'France',
    'Egypt',
    'Norway',
    'Nigeria',
    'Colombia',
    'Australia',
    'South Korea',
    'Bangladesh',
    'Mozambique',
    'Canada',
    'Germany',
    'Belgium',
    'Vietnam',
    'Bhutan',
    'Israel',
    'Brazil'
  ];
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              // title: Text(''),
              content: Container(
                height: 140,
                width: 160,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                          categoryName.add(value);
                        });
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "ItemType"),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        var temp = value;
                      });
                      valueText1.add(value);
                    },
                    controller: _textFieldController1,
                    decoration: InputDecoration(hintText: "Attributes"),
                  ),
                ]),
              ),
              actions: <Widget>[
                Container(
                  color: Colors.teal,
                  child: InkWell(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.teal,
                  child: InkWell(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        addItems();
                        codeDialog = valueText;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<String> nameList = [];
  List<String> emailList = [];
  getArrivalManagerName() async {
    var responce = await Providers().getArrivalManagerlist();

    for (int i = 0; i < responce.data.length; i++) {
      setState(() {
        arrmanName.add(responce.data[i].name);
      });
    }
  }

  getDepatureManagerName() async {
    var responce = await Providers().getDepatureManagerlist();
    setState(() {
      depaturemanagerList = responce.data;
    });
    for (int i = 0; i < depaturemanagerList.length; i++) {
      setState(() {
        depmanName.add(depaturemanagerList[i].name);
      });
    }
    print("vvbvbvbv" + deusename.toString());
  }

  @override
  void initState() {
    super.initState();
    var itemtextEditingController = TextEditingController(text: '');

    _itemTypecontrollr.add(itemtextEditingController);
    getArrivalManagerName();
    getDepatureManagerName();

    getScheduleItemList();

    _tabController = TabController(length: 3, vsync: this);
    _controller = TabController(length: 3, vsync: this);
  }

  bool isProcess = false;
  getScheduleItemList() async {
    setState(() {
      isProcess = true;
    });
    var loginshipment = await Providers().getScheduleItemList();
    setState(() {
      scheduleItemlist = loginshipment.data;
    });
    if (scheduleItemlist!.isNotEmpty) {
      itemTypeListModel.add(ShowScheduleItemsModelData(
        categoryName: scheduleItemlist![0].categoryName,
        id: scheduleItemlist![0].id,
      ));
      selected.add(scheduleItemlist![0].categoryName);
      for (int i = 0; i < scheduleItemlist!.length; i++) {
        itemNames.add(scheduleItemlist![i].categoryName);
        // iconlist.add(scheduleItemlist![i].icon);
      }

      item123.add(scheduleItemlist![0].items ?? []);

      var itemtextController = TextEditingController(text: '');

      _itemTypecontrollr.add(itemtextController);
    }
    setState(() {
      isProcess = false;
    });
    log("schedule shipmet" + jsonEncode(scheduleItemlist));
    log("-=-=-=- _itemTypecontrollr $_itemTypecontrollr");
  }

  scheduleShipmentApicall() async {
    print(selected.length);

    print(itemTypeListModel.length);

    final myList1 = [
      {
        'c_name': 'Fertilizers',
        'name': 'Fertilizers 1',
        'key': false,
        'item_shipping_fee': 3,
        'item_pickup_fee': 4,
        'item_quantity': 342
      },
      {
        'c_name': 'Fertilizers',
        'name': 'Fertilizers 2',
        'key': false,
        'item_shipping_fee': 6,
        'item_pickup_fee': 56,
        'item_quantity': 54
      },
      {
        'c_name': 'Fertilizers',
        'name': 'Fertilizers 1',
        'key': false,
        'item_shipping_fee': 3,
        'item_pickup_fee': 4,
        'item_quantity': 342
      },
      {
        'c_name': 'Fertilizers',
        'name': 'Fertilizers 2',
        'key': false,
        'item_shipping_fee': 6,
        'item_pickup_fee': 56,
        'item_quantity': 54
      },
      {
        'c_name': 'Test',
        'name': 'test5',
        'key': false,
        'item_shipping_fee': 46,
        'item_pickup_fee': 65,
        'item_quantity': 33
      },
    ];

    List myList = [];

    if (selected.isEmpty) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Please select item"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    var bodydata = {
      "shipment_type": bodydata1['shipment_type'],
      "title": bodydata1['title'],
      "from": bodydata1['from'],
      "to": bodydata1['to'],
      "departure_date": bodydata1['departure_date'],
      "arrival_date": bodydata1['arrival_date'],
      "departure_warehouse": bodydata1['departure_warehouse'],
      "destination_warehouse": bodydata1['destination_warehouse'],
      "departure_address": bodydata1['departure_address'],
      "arrival_address": bodydata1['arrival_address'],
      // "item_type":
      //     "[{\"id\":1,\"category_name\":\"Food\",\"item\":\"[{\\\"name\\\":\\\"Fish\\\",\\\"key\\\":false,\\\"item_shipping_fee\\\":15,\\\"item_pickup_fee\\\":25,\\\"item_quantity\\\":30},{\\\"name\\\":\\\"Dairy products\\\",\\\"key\\\":false,\\\"item_shipping_fee\\\":10,\\\"item_pickup_fee\\\":52,\\\"item_quantity\\\":60}]\",\"shipping_fee\":null,\"pickup_fee\":null,\"quantity\":null,\"icon\":null},{\"id\":2,\"category_name\":\"Electronics\",\"item\":\"[{\\\"name\\\":\\\"Camera & Photo\\\",\\\"key\\\":false,\\\"item_shipping_fee\\\":20,\\\"item_pickup_fee\\\":30,\\\"item_quantity\\\":40},{\\\"name\\\":\\\"Car Electronics & GPS\\\",\\\"key\\\":false,\\\"item_shipping_fee\\\":22,\\\"item_pickup_fee\\\":33,\\\"item_quantity\\\":44}]\",\"shipping_fee\":null,\"pickup_fee\":null,\"quantity\":null,\"icon\":null}]",
      "item_type": jsonEncode(itemTypeListModel)
    };
    print("len itemTypeListModel ${itemTypeListModel.length}");
    print(" body Data >>>>>>>>>>>>>>>>>>>>>>>${jsonEncode(bodydata)}");
    print(
        " body bodydata1 >>>>>>>>>>>>>>>>>>>>>>>${bodydata1['shipment_type']}");
    var checkData = 0;
    for (var i = 0; i < itemTypeListModel.length; i++) {
      if (itemTypeListModel[i].item == null) {
        checkData++;
      }
    }

    if (checkData != 0) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text('Select items'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // return;
    var loginshipment = await Providers().scheduleShipmentApi(bodydata);
    if (loginshipment.status == true) {
      setState(() {
        scheduldata = loginshipment.data;
      });
      if (scheduldata![0].permissionStatus == "Approved") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ResScheduleShipment()));
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(loginshipment.message.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Please wait for your  company's approval"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(loginshipment.message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    log(jsonEncode(loginshipment));
  }

  List getSuggestions(String query) {
    List matches = [];
    matches.addAll(_countries);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  addItems() async {
    var data = {"category": "$valueText", "item_name": jsonEncode(valueText1)};

    print(jsonEncode(data));

    var respo = await Providers().addItem(data);
    print("shishank");
    if (respo.status == true) {}
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
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
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              height: h,
              color: Color(0xffF5F6F8),
              child: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                            margin: EdgeInsets.fromLTRB(5, 5,
                                (Responsive.isDesktop(context)) ? 50 : 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'scheduleshipment'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Spacer(),
                                // if (Responsive.isDesktop(context)) topBar()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (!Responsive.isDesktop(context))
                    //   Column(
                    //     children: [topBar()],
                    //   ),
                    shipmentType2(),
                  ],
                ),
              ))),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 3),
            height: 48,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.grey, // set border color
                  width: 2.0), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  // searchfunction();
                },
                // controller: edit,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  hintText: "searchhere".tr(),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (val) {
                  // title = val;
                },
              ),
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
                    (DateFormat.yMd().format(initialDate).toString()),
                    style: headingStyle12blacknormal(),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate1(context);
                      datefilter.text =
                          (DateFormat.yMd().format(initialDate).toString());
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget shipmentType2() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      margin: EdgeInsets.only(left: 24, top: 5, right: 10),
      // height: h,
      // width: w,
      child: Container(
        // height: h * 5,
        width: w,
        // color: Colors.black26,
        child: planeShiping(),
      ),
    );
  }

  Widget planeShiping() {
    return Container(
        // height: h,
        decoration: BoxDecoration(
          // border: Border.all(width: 15, color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                // if (Responsive.isDesktop(context))
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 5),
                    child: InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResShipementItems()));
                      }),
                      child: Text(
                        "managecategories".tr(),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "categories".tr(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),

                      // style: headingStyleNormal(),
                    ),
                  ),
                ),
                (Responsive.isDesktop(context))
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                          height: (Responsive.isDesktop(context))
                              ? h * 0.08
                              : h * 0.5,
                          width: (Responsive.isDesktop(context))
                              ? w * 0.8
                              : w * 0.9,
                          child: Scrollbar(
                            child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: scheduleItemlist?.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // selected = [];
                                    print(
                                        "-=-=-=-=-= selected.contains ${!selected.contains(itemNames[index])}");
                                    print("-=->>selected $selected");
                                    print(
                                        "-=->>scheduleItemlist![index] ${scheduleItemlist![index]}");
                                    if (!selected.contains(itemNames[index])) {
                                      item123.add(
                                          scheduleItemlist![index].items ?? []);
                                      selected.add(itemNames[index]);
                                      var itemtextEditingController =
                                          TextEditingController(text: '');
                                      _itemTypecontrollr
                                          .add(itemtextEditingController);
                                      itemTypeListModel
                                          .add(ShowScheduleItemsModelData(
                                        categoryName: itemNames[index],
                                        id: scheduleItemlist![index].id,
                                      ));
                                    } else {
                                      print("index $index");
                                      print(
                                          " itemTypeListModel.removeAt(index) ${jsonEncode(itemTypeListModel)}");
                                      print(
                                          " _itemTypecontrollr. ${(_itemTypecontrollr)}");
                                      print(" selected. $selected");
                                      print(" item123. ${jsonEncode(item123)}");

                                      itemTypeListModel.removeWhere((item) =>
                                          item.categoryName ==
                                          itemNames[index]);

                                      _itemTypecontrollr.remove(
                                          _itemTypecontrollr.length - 1);
                                      selected.remove(itemNames[index]);
                                      item123.remove(
                                          scheduleItemlist![index].items);
                                    }

                                    print(jsonEncode(itemTypeListModel));

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 5, 0, 15),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color:
                                            selected.contains(itemNames[index])
                                                ? Color(0xff1A494F)
                                                : Color(0xffEFEFEF)),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Center(
                                        child: Text(
                                          scheduleItemlist![index]
                                              .categoryName
                                              .toString(),
                                          style: TextStyle(
                                            color: selected
                                                    .contains(itemNames[index])
                                                ? Color(0xffFFFFFF)
                                                : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                          height: h * 0.07,
                          width: w * 0.9,
                          child: Scrollbar(
                            child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              itemCount: scheduleItemlist?.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    // selected = [];
                                    print(
                                        "-=-=-=-=-= selected.contains ${!selected.contains(itemNames[index])}");
                                    print("-=->>selected $selected");
                                    print(
                                        "-=->>scheduleItemlist![index] ${scheduleItemlist![index]}");
                                    if (!selected.contains(itemNames[index])) {
                                      item123.add(
                                          scheduleItemlist![index].items ?? []);
                                      selected.add(itemNames[index]);
                                      var itemtextEditingController =
                                          TextEditingController(text: '');
                                      _itemTypecontrollr
                                          .add(itemtextEditingController);
                                      itemTypeListModel
                                          .add(ShowScheduleItemsModelData(
                                        categoryName: itemNames[index],
                                        id: scheduleItemlist![index].id,
                                      ));
                                    } else {
                                      print("index $index");
                                      print(
                                          " itemTypeListModel.removeAt(index) ${jsonEncode(itemTypeListModel)}");
                                      print(
                                          " _itemTypecontrollr. ${(_itemTypecontrollr)}");
                                      print(" selected. $selected");
                                      print(" item123. ${jsonEncode(item123)}");

                                      itemTypeListModel.removeWhere((item) =>
                                          item.categoryName ==
                                          itemNames[index]);

                                      _itemTypecontrollr.remove(
                                          _itemTypecontrollr.length - 1);
                                      selected.remove(itemNames[index]);
                                      item123.remove(
                                          scheduleItemlist![index].items);
                                    }

                                    print(jsonEncode(itemTypeListModel));

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 5, 0, 15),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color:
                                            selected.contains(itemNames[index])
                                                ? Color(0xff1A494F)
                                                : Color(0xffEFEFEF)),
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: Center(
                                        child: Text(
                                          scheduleItemlist![index]
                                              .categoryName
                                              .toString(),
                                          style: TextStyle(
                                            color: selected
                                                    .contains(itemNames[index])
                                                ? Color(0xffFFFFFF)
                                                : Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                (Responsive.isDesktop(context))
                    ? Column(
                        children: [
                          Container(
                            // color: Colors.green,
                            //height: h * 0.5,
                            width: w,
                            // height: h / 1.3,
                            child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selected.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 3 / 1,
                                      crossAxisSpacing: 1.0,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              0.8)
                                      // childAspectRatio: (1.6 / 1),
                                      ),
                              itemBuilder: (context, index) {
                                return formTypes(
                                    title: selected[index], index: index);
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: selected.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return formTypes(
                                title: selected[index], index: index);
                          },
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                button(),
                SizedBox(
                  height: 10,
                ),
              ],
            )));
  }

  Widget formTypes({title, index}) {
    print("-=-=-= formTypes index $index");

    item123[index].forEach((str) {
      var itemtextEditingController = TextEditingController(text: '');
      var feetextEditingController = TextEditingController(text: '');
      var pfeetextEditingController = TextEditingController(text: '');

      _QTYcontrollr.add(itemtextEditingController);
      _Feecontrollr.add(feetextEditingController);
      _PickFeecontrollr.add(pfeetextEditingController);
    });

    return Container(
      margin: EdgeInsets.only(top: 5, left: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  selected[index],
                  style: headingStyleNormal(),
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 16, right: 10),
              // color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(item123[index].length, (itemIndex) {
                      print("item123 ${item123[index].length}");
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Container(
                                width: 120,
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  item123[index][itemIndex].itemName.toString(),
                                  style: headingStyleNormal(),
                                  softWrap: true,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: item123[index][itemIndex].statusItem,
                              onChanged: (value) {
                                var prodLists = data.where((prod) =>
                                    prod["name"] ==
                                    item123[index][itemIndex].itemName);
                                print("prodLists-=-= ${prodLists.length}");
                                print(item123[index][itemIndex].itemName);
                                if (data.isNotEmpty) {
                                  data.removeWhere(
                                      (person) => person['c_name'] != title);
                                }
                                print("data-=first rm check-= $data");
                                // ignore: unrelated_type_equality_checks
                                if (prodLists.isNotEmpty) {
                                  data.removeWhere((person) =>
                                      person['name'] ==
                                      item123[index][itemIndex].itemName);
                                  _Feecontrollr[itemIndex].text = '';
                                  _PickFeecontrollr[itemIndex].text = '';
                                  _QTYcontrollr[itemIndex].text = '';

                                  print("data-=after check-= $data");
                                } else {
                                  data.add({
                                    'name': item123[index][itemIndex].itemName,
                                    'key': false,
                                    'item_shipping_fee': 0,
                                    'item_pickup_fee': 0,
                                    'item_quantity': 0,
                                    'c_name': title.toString(),
                                  });
                                }

                                setState(() {
                                  item123[index][itemIndex].statusItem = value;
                                });
                                _itemTypecontrollr[index].text = item123[index]
                                        [itemIndex]
                                    .itemName
                                    .toString();
                                print("before push check $data");

                                print("-=-=-jsonEncode ${jsonEncode(data)}");
                                // var compareIndex = 0;
                                // for (var i = 0;
                                //     i < itemTypeListModel.length;
                                //     i++) {
                                //   if (title ==
                                //       itemTypeListModel[i].categoryName) {
                                //     print("title $title");
                                //     print(
                                //         "itemTypeListModel[i].categoryName ${itemTypeListModel[i].categoryName}");

                                //     compareIndex = i;
                                //   }
                                // }
                                // print("compareIndex $compareIndex");
                                print("compareIndex data $data");

                                int indexCheck = data.indexWhere((prod) =>
                                    prod["name"] ==
                                    item123[index][itemIndex]
                                        .itemName
                                        .toString());
                                print("indexCheck=-=->>$indexCheck");

                                int indexGet11 = itemTypeListModel
                                    .indexWhere((f) => f.categoryName == title);

                                print("-=-=<<<indexGet11>>>> $indexGet11");

                                print("-=-=<<<data>>>> ${data[index]}");

                                print(
                                    "-=->>itemTypeListModel[indexGet11] ${itemTypeListModel[indexGet11].item}");

                                print("check data values onchange $data");

                                itemTypeListModel[indexGet11].item =
                                    jsonEncode(data);

                                print(
                                    "itemTypeListModel ${jsonEncode(itemTypeListModel)}");
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  // controller: _Feecontrollr[itemIndex],
                                  autofocus: false,
                                  onChanged: (v) {
                                    // var itemtextEditingController =
                                    //     TextEditingController(text: v);
                                    // _Feecontrollr.add(
                                    //     itemtextEditingController);

                                    print("check data values $data");
                                    print("in len ${data.length}");
                                    print(
                                        "in itemTypeListModel len ${itemTypeListModel.length}");

                                    int indexGet1 = data.indexWhere(
                                        (f) => f['name'] == title.toString());

                                    print("-=-=<<<indexGet1>>>> $indexGet1");

                                    int indexGet = data.indexWhere((f) =>
                                        f['name'] ==
                                        item123[index][itemIndex]
                                            .itemName
                                            .toString());
                                    print("-=-=<<<indexGet>>>> $indexGet");

                                    data[indexGet]['item_shipping_fee'] =
                                        int.parse(v);

                                    print(
                                        "--==>>itemTypeListModel ${itemTypeListModel[index]}");

                                    int indexGet11 =
                                        itemTypeListModel.indexWhere(
                                            (f) => f.categoryName == title);

                                    print("-=-=<<<indexGet11>>>> $indexGet11");

                                    print("-=-=<<<data>>>> ${data[index]}");

                                    print(
                                        "-=->>itemTypeListModel[indexGet11] ${itemTypeListModel[indexGet11].item}");

                                    itemTypeListModel[indexGet11].item =
                                        jsonEncode(data);

                                    print(
                                        "itemTypeListModel ${jsonEncode(itemTypeListModel)}");

                                    setState(() {});

                                    print("after check data values $data");
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 17),
                                  validator: (x) {
                                    if (item123[index][itemIndex].statusItem ==
                                        true) {
                                      // if (_Feecontrollr[itemIndex]
                                      //     .text
                                      //     .isEmpty) {
                                      //   return 'required';
                                      // }
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffEFEFEF),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffEFEFEF)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        // borderRadius: new BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffEFEFEF)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffEFEFEF)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        borderSide: BorderSide(
                                            width: 1.2,
                                            color: Color(0xffEFEFEF)),
                                      ),
                                      // border: InputBorder.none,
                                      hintText: "shippingfee".tr(),
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize:
                                              (Responsive.isDesktop(context))
                                                  ? 12
                                                  : 4)),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: TextFormField(
                                // controller: _PickFeecontrollr[itemIndex],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autofocus: false,
                                onChanged: (v) {
                                  // var itemtextEditingController1 =
                                  //     TextEditingController(text: v);
                                  // _PickFeecontrollr.add(
                                  //     itemtextEditingController1);

                                  int indexGet = data.indexWhere((f) =>
                                      f['name'] ==
                                      item123[index][itemIndex]
                                          .itemName
                                          .toString());
                                  print("-=-=<<<indexGet>>>> $indexGet");

                                  data[indexGet]['item_pickup_fee'] =
                                      int.parse(v);
                                  itemTypeListModel[index].item =
                                      jsonEncode(data);

                                  print("after check data values $data");
                                  setState(() {
                                    // item123[index][itemIndex].quantity =
                                    //     _QTYcontrollr[itemIndex].text;
                                    // itemTypeListModel[index].quantity =
                                    //     int.parse(v);
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                validator: (x) {
                                  if (item123[index][itemIndex].statusItem ==
                                      true) {
                                    // if (_PickFeecontrollr[itemIndex]
                                    //     .text
                                    //     .isEmpty) {
                                    //   return 'required';
                                    // }
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: Color(0xffEFEFEF),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    // border: InputBorder.none,
                                    hintText: "pickupfee".tr(),
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            (Responsive.isDesktop(context))
                                                ? 12
                                                : 4)),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: TextFormField(
                                // controller: _QTYcontrollr[itemIndex],
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                autofocus: false,
                                onChanged: (v) {
                                  // var itemtextEditingController1 =
                                  //     TextEditingController(text: v);
                                  // _QTYcontrollr.add(
                                  //     itemtextEditingController1);

                                  int indexGet = data.indexWhere((f) =>
                                      f['name'] ==
                                      item123[index][itemIndex]
                                          .itemName
                                          .toString());
                                  print("-=-=<<<indexGet>>>> $indexGet");

                                  int indexGet11 = itemTypeListModel.indexWhere(
                                      (f) => f.categoryName == title);

                                  print("-=-=<<<indexGet11>>>> $indexGet11");

                                  print(
                                      "-=->>itemTypeListModel[indexGet11] ${itemTypeListModel[indexGet11].item}");

                                  data[indexGet]['item_quantity'] =
                                      int.parse(v);
                                  itemTypeListModel[indexGet11].item =
                                      jsonEncode(data);

                                  print("after check data values $data");

                                  setState(() {
                                    // item123[index][itemIndex].quantity =
                                    //     _QTYcontrollr[itemIndex].text;
                                    // itemTypeListModel[index].quantity =
                                    //     int.parse(v);
                                  });
                                },
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                validator: (x) {
                                  if (item123[index][itemIndex].statusItem ==
                                      true) {
                                    // if (_QTYcontrollr[itemIndex]
                                    //     .text
                                    //     .isEmpty) {
                                    //   return 'required';
                                    // }
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    fillColor: Color(0xffEFEFEF),
                                    filled: true,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      // borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                      borderSide: BorderSide(
                                          width: 1.2, color: Color(0xffEFEFEF)),
                                    ),
                                    // border: InputBorder.none,
                                    hintText: "quantity".tr(),
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize:
                                            (Responsive.isDesktop(context))
                                                ? 12
                                                : 4)),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formTypesOld({title, index}) {
    print("-=-=-= index $index");
    var data = [];
    var data1 = [];
    return Container(
      margin: EdgeInsets.only(top: 15, left: 10),
      decoration: BoxDecoration(
        // color: Colors.red,
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                selected[index] + " Type",
                style: headingStyleNormal(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: false,
                          onChanged: (value) {
                            // var itemtextEditingController =
                            //     TextEditingController(text: value.toString());
                            // _itemTypecontrollr[index] =
                            //     itemtextEditingController;
                          },
                          controller: _itemTypecontrollr[index],
                          // controller: TextEditingController(text: "data")
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          category = value;
                          _itemTypecontrollr[index].text = value;
                          //print(_itemTypecontrollr[index].text);

                          itemTypeListModel[index].item = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return item123[index].map((Items value) {
                            return PopupMenuItem(
                                child: StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return CheckboxListTile(
                                        activeColor: Colors.teal,
                                        dense: false,
                                        title: Text(
                                          value.itemName.toString(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5),
                                        ),
                                        value: value.statusItem,
                                        onChanged: (val) {
                                          setState(() {
                                            value.statusItem = val;
                                          });

                                          _itemTypecontrollr[index].text =
                                              value.itemName.toString();

                                          data.add({
                                            'name': value.itemName,
                                            'key': false
                                          });
                                          print("-=-=-${jsonEncode(data)}");
                                          // print("data mname ${data[index]['name']}");
                                          itemTypeListModel[index].item =
                                              jsonEncode(data);

                                          print(
                                              "itemTypeListModel $itemTypeListModel");
                                        });
                                  },
                                ),
                                value: value.itemName.toString());
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
              width: 100,
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "shippingfee".tr(),
                style: headingStyleNormal(),
              ),
            ),
          ),
          Container(
            height: 33,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              initialValue: "",
              autofocus: false,
              onChanged: (v) {
                setState(() {
                  itemTypeListModel[index].shippingFee = int.parse(v);
                  // userEmail = v.toLowerCase();
                });
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              validator: (x) {
                if (x!.isEmpty) {
                  return 'required';
                }
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Color(0xffEFEFEF),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: new BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  // border: InputBorder.none,
                  hintText: "",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                // "Number of" + " $title",
                "quantity".tr(),
                style: headingStyleNormal(),
              ),
            ),
          ),
          Container(
            height: 33,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextFormField(
              initialValue: "",
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              autofocus: false,
              onChanged: (v) {
                setState(() {
                  itemTypeListModel[index].quantity = int.parse(v);
                });
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              validator: (x) {
                if (x!.isEmpty) {
                  return 'required';
                }
                return null;
              },
              decoration: InputDecoration(
                  fillColor: Color(0xffEFEFEF),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: new BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                  ),
                  // border: InputBorder.none,
                  hintText: "",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        if (tab == 1) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text("Already Shipment Schedule"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        if (tab == 0) {
          if (_formKey.currentState!.validate()) {
            scheduleShipmentApicall();
          }
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10),
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Color(0xff1F2326)
              // color: Colors.green,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(15),
                  child: Center(
                      child: Text("scheduleshipment".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )))),
              Container(
                margin: EdgeInsets.only(top: 15, right: 10),
                height: 20,
                width: 20,
                child: Image.asset('assets/images/arrow-right.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
