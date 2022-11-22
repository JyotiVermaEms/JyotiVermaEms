import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Model/Client/showScheduleItemsModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_BookingOverView.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_Client_items.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_Market_Place.dart';
import 'package:shipment/constants.dart';

class ClientItems extends StatefulWidget {
  const ClientItems({Key? key}) : super(key: key);

  @override
  State<ClientItems> createState() => _ClientItemsState();
}

class Student1 {
  String _name;
  int _sessionId;

  Student1(this._name, this._sessionId);

  Student1.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _sessionId = json['sessionId'];

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'sessionId': _sessionId,
    };
  }
}

class _ClientItemsState extends State<ClientItems> {
  List<Student1> _studentList = [];
  Map<int, Student1> _studentMap = {};
  var valueText;
  List<String> attribute = [];
  var attr;

  TextEditingController textEditingController = new TextEditingController();

  addItems() async {
    for (int i = 0; i < _studentList.length; i++) {
      attribute.add(_studentList[i]._name);
    }
    var data = {"category": "$valueText", "item_name": jsonEncode(attribute)};

    print(jsonEncode(data));

    var respo = await Providers().addClientItem(data);
    print("shishank");
    if (respo.status == true) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ResBookingOverView()));
    }
  }

  var id;

  deleteItem() async {
    var data = {"id": "$id"};

    print(jsonEncode(data));

    var respo = await Providers().deleteClientItem(data);
    print("shishank");
    if (respo.status == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ResClientItems()));
    }
  }

  void _addNewStudent() {
    setState(() {
      _studentList.add(Student1('', 1));
    });

    print(_studentList.length);
  }

  List<ShowScheduleItemsModelData>? scheduleItemlist;

  getScheduleItemList() async {
    var loginshipment = await Providers().getClientItemList();
    setState(() {
      scheduleItemlist = loginshipment.data;
    });

    log("schedule shipmet" + jsonEncode(scheduleItemlist));
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    getScheduleItemList();
  }

  var h, w;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
        color: Color(0xffFFFFFF),
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        child: SafeArea(
            right: false,
            child: Padding(
              padding: (Responsive.isDesktop(context))
                  ? const EdgeInsets.symmetric(horizontal: kDefaultPadding)
                  : const EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                children: [
                  Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding)
                        : const EdgeInsets.symmetric(horizontal: 0),
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
                          width: w * 0.7,
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: InkWell(
                                    onTap: () {
                                      // Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResBookingOverView()));
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios_new,
                                      size: (Responsive.isDesktop(context))
                                          ? 25
                                          : 18,
                                    )),
                              ),
                              Container(
                                child: Text(
                                  'Add Items',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (Responsive.isDesktop(context))
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF),
                        ),
                        margin: EdgeInsets.only(left: 24, top: 15, right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: w / 2,
                                // height: h / 2,
                                // color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ' required.';
                                            }
                                          },
                                          // initialValue: 'ItemType',
                                          maxLength: 25,
                                          onChanged: (value) {
                                            valueText = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Enter category',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black26,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: w * 0.010,
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          onChanged: (value) {
                                            setState(() {
                                              attr = value;
                                            });
                                            // attribute.add(attr);
                                          },
                                          // ini  tialValue: 'Attributes',

                                          decoration: InputDecoration(
                                            hintText: 'enter attributes',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  print("object");
                                                  _addNewStudent();
                                                },
                                                child: Icon(Icons.add)),
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black26,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        _studentList.isNotEmpty
                                            ? Builder(
                                                builder: (context) {
                                                  print(
                                                      "List : ${_studentList.toString()}");
                                                  _studentMap =
                                                      _studentList.asMap();
                                                  print(
                                                      "MAP : ${_studentMap.toString()}");
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _studentMap.length,
                                                    itemBuilder:
                                                        (context, position) {
                                                      print(
                                                          'Item Position $position');
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    TextFormField(
                                                                  onFieldSubmitted:
                                                                      (name) {
                                                                    setState(
                                                                        () {
                                                                      _studentList[position]
                                                                              ._name =
                                                                          name;
                                                                      print(
                                                                          "  objsafdfasdf>>>>>>>>>>>>> ${_studentList.contains(attr)}");
                                                                      _studentList.contains(
                                                                              attr)
                                                                          ? _studentList[position]._name =
                                                                              name
                                                                          : _studentList
                                                                              .add(attr);
                                                                    });
                                                                    // attribute.add(
                                                                    //     _studentList[
                                                                    //             position]
                                                                    //         ._name);
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return ' required.';
                                                                    }
                                                                  },
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _studentList[position]
                                                                              ._name =
                                                                          value;
                                                                    });
                                                                    // attribute.add(
                                                                    //     _studentList[
                                                                    //             position]
                                                                    //         ._name);
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'enter attribute name',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .black12,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            15.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _studentList
                                                                      .removeAt(
                                                                          position);
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : SizedBox(),

                                        Container(
                                          height:
                                              (Responsive.isDesktop(context))
                                                  ? h * 0.15
                                                  : h * 0.5,
                                          width: (Responsive.isDesktop(context))
                                              ? w * 0.8
                                              : w * 0.9,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              // physics: NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  scheduleItemlist?.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    // selected = [];
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    margin: EdgeInsets.fromLTRB(
                                                        15, 15, 0, 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color:
                                                            Color(0xff1A494F)),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 10, 0),
                                                          child: Center(
                                                            child: Text(
                                                              scheduleItemlist![
                                                                      index]
                                                                  .categoryName
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .mode_edit_sharp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                print(
                                                                    "open dialog");
                                                                showDialog<
                                                                    String>(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                          insetPadding: EdgeInsets
                                                                              .zero,
                                                                          contentPadding: EdgeInsets
                                                                              .zero,
                                                                          scrollable:
                                                                              true,
                                                                          content:
                                                                              StatefulBuilder(
                                                                            builder:
                                                                                (BuildContext context, StateSetter setState) {
                                                                              return EditMarketItemDialog(scheduleItemlist![index].id, scheduleItemlist![index].categoryName.toString(), scheduleItemlist![index].items, setState);
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: Center(
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                showDialog<
                                                                    String>(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                    content: Text(
                                                                        "Are you Sure you want to delete this Category"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            id =
                                                                                scheduleItemlist![index].id;
                                                                          });
                                                                          deleteItem();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                        child: const Text(
                                                                            'No'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                        // _studentList.length != 0
                                        //     ? Row(
                                        //         children: [
                                        //           ...List.generate(
                                        //             _studentList.length,
                                        //             (index) {
                                        //               return Text(
                                        //                   _studentList[index]
                                        //                       ._name
                                        //                       .toString());
                                        //               // here by default width and height is 0
                                        //             },
                                        //           ),
                                        //         ],
                                        //       )
                                        //     : SizedBox(),
                                      ],
                                    ),
                                  ),
                                )),
                            button(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (!Responsive.isDesktop(context))
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffFFFFFF),
                        ),
                        margin: EdgeInsets.only(left: 24, top: 15, right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                // height: h / 2,
                                // color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return ' required.';
                                            }
                                          },
                                          // initialValue: 'ItemType',
                                          maxLength: 25,
                                          onChanged: (value) {
                                            valueText = value;
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Enter category',
                                            counterText: '',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black26,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: w * 0.010,
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          onChanged: (value) {
                                            setState(() {
                                              attr = value;
                                            });
                                            // attribute.add(attr);
                                          },
                                          // ini  tialValue: 'Attributes',

                                          decoration: InputDecoration(
                                            hintText: 'enter attributes',
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  print("object");
                                                  _addNewStudent();
                                                },
                                                child: Icon(Icons.add)),
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black26,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        _studentList.isNotEmpty
                                            ? Builder(
                                                builder: (context) {
                                                  print(
                                                      "List : ${_studentList.toString()}");
                                                  _studentMap =
                                                      _studentList.asMap();
                                                  print(
                                                      "MAP : ${_studentMap.toString()}");
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        _studentMap.length,
                                                    itemBuilder:
                                                        (context, position) {
                                                      print(
                                                          'Item Position $position');
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5.0),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    TextFormField(
                                                                  onFieldSubmitted:
                                                                      (name) {
                                                                    setState(
                                                                        () {
                                                                      _studentList[position]
                                                                              ._name =
                                                                          name;
                                                                      print(
                                                                          "  objsafdfasdf>>>>>>>>>>>>> ${_studentList.contains(attr)}");
                                                                      _studentList.contains(
                                                                              attr)
                                                                          ? _studentList[position]._name =
                                                                              name
                                                                          : _studentList
                                                                              .add(attr);
                                                                    });
                                                                  },
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return ' required.';
                                                                    }
                                                                  },
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _studentList[position]
                                                                              ._name =
                                                                          value;
                                                                    });
                                                                  },
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'enter attribute name',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.0,
                                                                      color: Colors
                                                                          .black26,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Colors
                                                                            .black12,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            15.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _studentList
                                                                      .removeAt(
                                                                          position);
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : SizedBox(),
                                        Container(
                                          height: h * 0.15,
                                          width: w * 0.8,
                                          child: Scrollbar(
                                            child: ListView.builder(
                                              // physics: NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  scheduleItemlist?.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    // selected = [];
                                                  },
                                                  child: Container(
                                                    height: 50,
                                                    margin: EdgeInsets.fromLTRB(
                                                        15, 15, 0, 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        color:
                                                            Color(0xff1A494F)),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: h * 0.1,
                                                          width: w * 0.28,
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  5, 5, 10, 5),
                                                          child: Center(
                                                            child: Text(
                                                              scheduleItemlist![
                                                                      index]
                                                                  .categoryName
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .mode_edit_sharp,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onPressed: () {
                                                                print(
                                                                    "open dialog");
                                                                showDialog<
                                                                    String>(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                          insetPadding: EdgeInsets
                                                                              .zero,
                                                                          contentPadding: EdgeInsets
                                                                              .zero,
                                                                          scrollable:
                                                                              true,
                                                                          content:
                                                                              StatefulBuilder(
                                                                            builder:
                                                                                (BuildContext context, StateSetter setState) {
                                                                              return EditMarketItemDialog(scheduleItemlist![index].id, scheduleItemlist![index].categoryName.toString(), scheduleItemlist![index].items, setState);
                                                                            },
                                                                          )),
                                                                );
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: Center(
                                                                child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                showDialog<
                                                                    String>(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      AlertDialog(
                                                                    content: Text(
                                                                        "Are you Sure you want to delete this Category"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            id =
                                                                                scheduleItemlist![index].id;
                                                                          });
                                                                          deleteItem();
                                                                        },
                                                                        child: const Text(
                                                                            'Yes'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'OK'),
                                                                        child: const Text(
                                                                            'No'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            button(),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );
  }

  Widget EditMarketItemDialog(categoryID, categoryName, itemDataArr, setState) {
    print("itemArr -=->> ${itemDataArr.length}");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              print("close dialog");
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 350),
                child: Icon(
                  Icons.cancel,
                  size: 40,
                ),
              ),
            ),
          ),
          TextFormField(
            maxLength: 25,
            // onChanged: (value) {
            //   valueText = value;
            // },
            initialValue: categoryName,
            decoration: InputDecoration(
              hintText: 'Enter Category ',
              counterText: '',
              hintStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            ),
          ),
          SizedBox(
            height: w * 0.030,
          ),
          TextFormField(
            // enabled: true,
            readOnly: true,
            onChanged: (value) {
              setState(() {
                attr = value;
              });
            },
            // ini  tialValue: 'Attributes',

            decoration: InputDecoration(
              hintText: 'Enter Item',
              suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      itemDataArr.add(Items(itemName: '', statusItem: false));
                    });

                    print(itemDataArr.length);
                  },
                  child: Icon(Icons.add)),
              hintStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
            ),
          ),
          itemDataArr.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemDataArr.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, position) {
                      print('Item Position ${itemDataArr[position].itemName}');
                      return Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: TextFormField(
                                  maxLength: 25,
                                  initialValue: itemDataArr[position].itemName,
                                  onFieldSubmitted: (name) {
                                    setState(() {
                                      itemDataArr[position].itemName = name;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      itemDataArr[position].itemName = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'enter attribute name',
                                    counterText: '',
                                    hintStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black26,
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                print("remove position $position");

                                if (itemDataArr.length == 1) {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      content: Text(
                                          "At least 1 item should be here "),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                } else {
                                  itemDataArr.removeAt(position);

                                  for (int i = 0; i < itemDataArr.length; i++) {
                                    if (itemDataArr[i].itemName != "") {
                                      attribute.remove(itemDataArr[i].itemName);
                                    }
                                  }

                                  var data = {
                                    "category_id": "$categoryID",
                                    "category": "$categoryName",
                                    "item_name": jsonEncode(attribute)
                                  };

                                  print(jsonEncode(data));
                                  //return;
                                  var respo =
                                      await Providers().editDeleteItem(data);

                                  if (respo.status == true) {
                                    setState(() {});
                                  }
                                }
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              : SizedBox(),
          GestureDetector(
            onTap: () async {
              for (int i = 0; i < itemDataArr.length; i++) {
                if (itemDataArr[i].itemName != "") {
                  attribute.add(itemDataArr[i].itemName);
                }
              }
              var data = {
                "category_id": "$categoryID",
                "category": "$categoryName",
                "item_name": jsonEncode(attribute)
              };

              print(jsonEncode(data));
              //return;
              var respo = await Providers().editDeleteItem(data);

              if (respo.status == true) {
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 10, top: 20),
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff1F2326)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.all(15),
                        child: Center(
                            child: Text("Update Item",
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
          )
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          addItems();
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 20),
          width: 300,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Color(0xff1F2326)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(15),

                  // width: MediaQuery.of(context).size.width * 0.8,
                  // color: Colors.lime,
                  child: Center(
                      child: Text("Add Item",
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
