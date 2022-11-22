import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Model/Client/getScheduleItemModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Payment_Summary.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/Dashboard/ItemDetails.dart';
import 'package:shipment/pages/Client/Dashboard/ItemDetails.dart';
import '../../../constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class GoodsDetails extends StatefulWidget {
  var itemDetails;
  GoodsDetails(this.itemDetails);

  @override
  _GoodsDetailsState createState() => _GoodsDetailsState();
}

class _GoodsDetailsState extends State<GoodsDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  var h, w;
  var temp2;
  double amount = 0;
  var dataMap = [
    {'pid': 8876, 'name': 'Alex'},
    {'pid': 9762, 'name': 'Fred'},
    {'pid': 9562, 'name': 'Jack'},
  ];
  var allItem = [];
  var sum = 0;
  List<ItemDetail> itemList = [
    ItemDetail(
        categoryName: "",
        description: "",
        imageList: [],
        itemName: "",
        qty: [],
        pickupfee: [],
        shipinfee: [],
        nameItem: [],
        tempItem: [],
        amounttotal: 0)
  ];

  List tempItem = [];
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  var category;
  var itemtype;
  var qty2, des;
  List temp = [];
  int ontap = 0;
  var tatalcalulation;
  var quant;
  int indexGet = 0;

  List<String> _category = [];

  List image = [];
  var item;
  File? imagefile;
  var itemIcon;
  var itemid = [];
  var amounttotal1 = [];
  int amounttotalr = 0;
  var quantity = [];
  var talquanty = [];
  var ship_amount = [];
  var ship_totalamount;
  var availble;
  var commaAttr = [];
  getItemPrice(ind) async {
    print("TTTTTTTTT");
    print("TTTTTTTTT>>>>>>>>>>>>>>${itemList[ind].tempItem}");
    amounttotalr = 0;

    for (int i = 0; i < itemList[ind].tempItem.length; i++) {
      print("TTTTTTTTT>>>>>>>>>>>>>>${itemList[ind].qty}");
      print(
          "TTTTTTTTT>>>>>>>>>>>>>>${itemList[ind].tempItem[i]['shippingFee']}");
      print("TTTTTTTTT>>>>>>>>>>>>>>${itemList[ind].tempItem[i]['pickupfee']}");

      amounttotalr = amounttotalr +
          int.parse(itemList[ind].tempItem[i]['qty']) *
              int.parse(itemList[ind].tempItem[i]['shippingFee']) +
          int.parse(itemList[ind].tempItem[i]['pickupfee']);
    }
    print("TTTTTTTTT>>>>>>>>>>>>>>$amounttotalr");
    itemList[ind].amounttotal = amounttotalr;
    print(">>>>>>>>>>>>>>>>TTTTTTTTT${itemList[ind].amounttotal}");

    for (int i = 0; i < amounttotal1.length; i++) {
      sum += amounttotal1[i] as int;
    }
  }

  // var catData;
  var _amount;
  var globalIndexCheck = 0;
  var addAttr = [];
  var addtotal = [];
  List total = [];
  var quan = [];
  List dataAttr = [];
  List<Data> catData = <Data>[];
  getScheduleItem() async {
    var id = {
      "schedule_id": (widget.itemDetails['shipmentId'].toString()),
    };
    // var itemAttr;

    var res = await Providers().getScheduleItem(id);
    catData = res.data;
    for (int i = 0; i < catData.length; i++) {
      for (int j = 0; j < catData[i].item.length; j++) {
        _category.add(catData[i].itemId);
        dataAttr = catData[i].item;
        availble = catData[i].available;
      }
    }

    setState(() {});
  }

  showAttr(ind, index11) {
    (Responsive.isDesktop(context))
        ? showDialog(
            context: context,
            builder: (context) => Dialog(
                    child: Form(
                  key: _formkey1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * (55 / 100),
                    height: MediaQuery.of(context).size.height * (80 / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 5, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 80,
                                child: Text(
                                  "Item Name",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 90,
                                ),
                                width: 100,
                                child: Text(
                                  "Shipping Fee",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              widget.itemDetails['type'] == "Pick up"
                                  ? Container(
                                      margin: EdgeInsets.only(
                                        left: 40,
                                      ),
                                      width: 80,
                                      child: Text(
                                        "Pickup Fee",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 40,
                                ),
                                width: 80,
                                child: Text(
                                  "Total Container",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 30,
                                ),
                                width: 50,
                                child: Text(
                                  "Qty",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 5, 5, 0),
                          width: MediaQuery.of(context).size.width * (48 / 100),
                          height:
                              MediaQuery.of(context).size.height * (60 / 100),
                          child: ListView.builder(
                              itemCount: 1,
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                return Column(
                                  children: List.generate(
                                    catData[index11].item.length,
                                    (index1) {
                                      dataAttr = catData[index11].item;

                                      return StatefulBuilder(builder:
                                          (BuildContext context, _setState) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: 120,
                                                child: Text(
                                                    dataAttr[index1].itemName)),
                                            Container(
                                              // margin: EdgeInsets.only(top: 10),
                                              child: Checkbox(
                                                value: dataAttr[index1].key,
                                                onChanged: (value) {
                                                  _setState(() {
                                                    dataAttr[index1].key =
                                                        value;
                                                    print(
                                                        "RRRRRRRRR${dataAttr[index1].key}");
                                                  });

                                                  if (value == true) {
                                                    itemList[ind].tempItem.add({
                                                      'id': dataAttr[index1].id,
                                                      'itemname':
                                                          dataAttr[index1]
                                                              .itemName,
                                                      'qty': "0",
                                                      'pickupfee':
                                                          widget.itemDetails[
                                                                      'type'] ==
                                                                  "Pick up"
                                                              ? dataAttr[index1]
                                                                  .pickupFee
                                                              : "0",
                                                      'shippingFee':
                                                          dataAttr[index1]
                                                              .shippingFee
                                                    });
                                                    print(
                                                        "MMMMMMMMMMMMMMMMMMM${itemList[ind].tempItem}");
                                                    if (globalIndexCheck !=
                                                        ind) {
                                                      addAttr = [];
                                                    }

                                                    // getItemPrice(_amount);

                                                    addAttr.add(
                                                      dataAttr[index1].itemName,
                                                    );

                                                    for (int i = 0;
                                                        i < addtotal.length;
                                                        i++)
                                                      sum += addtotal[i] as int;

                                                    var chekData = itemList[ind]
                                                        .nameItem
                                                        .contains(
                                                            dataAttr[index1]
                                                                .itemName);
                                                    // itemid = dataAttr[index1].id;
                                                    ship_amount
                                                        .add(dataAttr[index1]);
                                                    itemtype = dataAttr[index1]
                                                        .itemName;

                                                    itemList[ind].shipinfee.add(
                                                        dataAttr[index1]
                                                            .shippingFee);
                                                    itemList[ind].pickupfee.add(
                                                        dataAttr[index1]
                                                            .pickupFee);
                                                    // itemList[ind].qty.add(0);

                                                    itemList[ind].nameItem.add(
                                                        dataAttr[index1]
                                                            .itemName);
                                                  } else {
                                                    addAttr.removeWhere(
                                                        (person) =>
                                                            person ==
                                                            dataAttr[index1]
                                                                .itemName);
                                                    itemList[ind].tempItem = [];
                                                    itemList[ind].amounttotal =
                                                        [];
                                                    print(
                                                        "FFFFFFFFFF${itemList[ind].tempItem}");
                                                    ;

                                                    itemList[ind]
                                                        .nameItem
                                                        .remove(dataAttr[index1]
                                                            .itemName);
                                                    itemList[ind]
                                                        .shipinfee
                                                        .remove(dataAttr[index1]
                                                            .shippingFee);
                                                    // getItemPrice(ind);
                                                    itemList[ind]
                                                        .pickupfee
                                                        .remove(dataAttr[index1]
                                                            .pickupFee);
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                margin: EdgeInsets.only(
                                                  left: 40,
                                                ),
                                                width: 80,
                                                child: Center(
                                                  child: Text(dataAttr[index1]
                                                      .shippingFee
                                                      .toString()),
                                                )),
                                            widget.itemDetails['type'] ==
                                                    "Pick up"
                                                ? Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    margin: EdgeInsets.only(
                                                      left: 40,
                                                    ),
                                                    width: 80,
                                                    child: Center(
                                                      child: widget.itemDetails[
                                                                  'type'] ==
                                                              "Pick up"
                                                          ? Text(
                                                              dataAttr[index1]
                                                                  .pickupFee
                                                                  .toString())
                                                          : Text("0"),
                                                    ))
                                                : Container(),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    border: Border.all(
                                                        color: Colors.grey)),
                                                height: 40,
                                                margin: EdgeInsets.only(
                                                  left: 40,
                                                ),
                                                width: 70,
                                                child: Center(
                                                  child: Text(dataAttr[index1]
                                                      .available
                                                      .toString()),
                                                )),
                                            dataAttr[index1].key == true
                                                ? Container(
                                                    height: 40,
                                                    margin: EdgeInsets.only(
                                                      left: 40,
                                                    ),
                                                    width: 70,
                                                    child: Center(
                                                      child: TextFormField(
                                                        validator: (v) {
                                                          if (v!.isEmpty) {
                                                            return 'required*';
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .digitsOnly
                                                        ],
                                                        initialValue: "",
                                                        onChanged: (v) {
                                                          setState(() {
                                                            if (int.parse(dataAttr[
                                                                        index1]
                                                                    .available) >=
                                                                int.parse(v)) {
                                                              indexGet =
                                                                  itemList[ind]
                                                                      .tempItem
                                                                      .indexWhere(
                                                                        (f) =>
                                                                            f['id'] ==
                                                                            dataAttr[index1].id,
                                                                      );

                                                              itemList[ind].tempItem[
                                                                          indexGet]
                                                                      ['qty'] =
                                                                  v.toString();
                                                              itemList[ind]
                                                                  .qty
                                                                  .add(itemList[
                                                                              ind]
                                                                          .tempItem[
                                                                      indexGet]['qty'])
                                                                  .toString();
                                                              itemList[ind]
                                                                  .qty
                                                                  .remove(itemList[
                                                                              ind]
                                                                          .tempItem[
                                                                      indexGet]['qty']);

                                                              print(
                                                                  "TTTTTTTTTTTTT${itemList[ind].tempItem[indexGet]['qty']}");

                                                              getItemPrice(ind);
                                                            } else {
                                                              showDialog<
                                                                  String>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  content: Text(
                                                                      "You have entered incorrect quantity"),
                                                                  actions: <
                                                                      Widget>[
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'OK'),
                                                                      child: const Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }
                                                          });
                                                        },
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 17),
                                                        decoration:
                                                            InputDecoration(
                                                                fillColor: Color(
                                                                    0xffF5F6FA),
                                                                filled: true,
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width:
                                                                          1.2,
                                                                      color: Color(
                                                                          0xffF5F6FA)),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width:
                                                                          1.2,
                                                                      color: Color(
                                                                          0xffF5F6FA)),
                                                                ),
                                                                errorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide: BorderSide(
                                                                      width:
                                                                          1.2,
                                                                      color: Color(
                                                                          0xffF5F6FA)),
                                                                ),
                                                                focusedErrorBorder:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                  borderSide: BorderSide(
                                                                      width:
                                                                          1.2,
                                                                      color: Color(
                                                                          0xffF5F6FA)),
                                                                ),
                                                                // border: InputBorder.none,
                                                                hintText: "4",
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        15)),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        );
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                if (_formkey1.currentState!.validate())
                                  Navigator.pop(context);
                              },
                              child: const Text('Done'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )))
        : showDialog(
            context: context,
            builder: (context) => Dialog(
                    child: Form(
                  key: _formkey1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * (5 / 100),
                    height: MediaQuery.of(context).size.height * (55 / 100),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 5, 0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    child: Text(
                                      "Item Name",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 45,
                                    ),
                                    width: 100,
                                    child: Text(
                                      "Shipping Fee",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  widget.itemDetails['type'] == "Pick up"
                                      ? Container(
                                          margin: EdgeInsets.only(
                                            left: 40,
                                          ),
                                          width: 80,
                                          child: Text(
                                            "Pickup Fee",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 40,
                                    ),
                                    width: 80,
                                    child: Text(
                                      "Total Container",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 30,
                                    ),
                                    width: 50,
                                    child: Text(
                                      "Qty",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 5, 5, 0),
                              width: (Responsive.isDesktop(context))
                                  ? MediaQuery.of(context).size.width *
                                      (48 / 100)
                                  : MediaQuery.of(context).size.width * 1.6,
                              height: (Responsive.isDesktop(context))
                                  ? MediaQuery.of(context).size.height *
                                      (60 / 100)
                                  : MediaQuery.of(context).size.height *
                                      (30 / 100),
                              child: ListView.builder(
                                  itemCount: 1,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    // temp.add(false);
                                    return Column(
                                      children: List.generate(
                                        catData[index11].item.length,
                                        (index1) {
                                          dataAttr = catData[index11].item;

                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  _setState) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: w * 0.23,
                                                    child: Text(dataAttr[index1]
                                                        .itemName)),
                                                Container(
                                                  // margin: EdgeInsets.only(top: 10),
                                                  child: Checkbox(
                                                    value: dataAttr[index1].key,
                                                    onChanged: (value) {
                                                      _setState(() {
                                                        dataAttr[index1].key =
                                                            value;
                                                        print(
                                                            "RRRRRRRRR${dataAttr[index1].key}");
                                                      });

                                                      if (value == true) {
                                                        itemList[ind]
                                                            .tempItem
                                                            .add({
                                                          'id': dataAttr[index1]
                                                              .id,
                                                          'itemname':
                                                              dataAttr[index1]
                                                                  .itemName,
                                                          'qty': "0",
                                                          'pickupfee':
                                                              widget.itemDetails[
                                                                          'type'] ==
                                                                      "Pick up"
                                                                  ? dataAttr[
                                                                          index1]
                                                                      .pickupFee
                                                                  : "0",
                                                          'shippingFee':
                                                              dataAttr[index1]
                                                                  .shippingFee
                                                        });
                                                        print(
                                                            "MMMMMMMMMMMMMMMMMMM${itemList[ind].tempItem}");
                                                        if (globalIndexCheck !=
                                                            ind) {
                                                          addAttr = [];
                                                        }

                                                        // getItemPrice(_amount);

                                                        addAttr.add(
                                                          dataAttr[index1]
                                                              .itemName,
                                                        );

                                                        for (int i = 0;
                                                            i < addtotal.length;
                                                            i++)
                                                          sum += addtotal[i]
                                                              as int;

                                                        var chekData = itemList[
                                                                ind]
                                                            .nameItem
                                                            .contains(
                                                                dataAttr[index1]
                                                                    .itemName);
                                                        // itemid = dataAttr[index1].id;
                                                        ship_amount.add(
                                                            dataAttr[index1]);
                                                        itemtype =
                                                            dataAttr[index1]
                                                                .itemName;

                                                        itemList[ind]
                                                            .shipinfee
                                                            .add(dataAttr[
                                                                    index1]
                                                                .shippingFee);
                                                        itemList[ind]
                                                            .pickupfee
                                                            .add(
                                                                dataAttr[index1]
                                                                    .pickupFee);
                                                        // itemList[ind].qty.add(0);

                                                        itemList[ind]
                                                            .nameItem
                                                            .add(
                                                                dataAttr[index1]
                                                                    .itemName);
                                                      } else {
                                                        addAttr.removeWhere(
                                                            (person) =>
                                                                person ==
                                                                dataAttr[index1]
                                                                    .itemName);
                                                        itemList[ind].tempItem =
                                                            [];
                                                        itemList[ind]
                                                            .amounttotal = [];
                                                        print(
                                                            "FFFFFFFFFF${itemList[ind].tempItem}");
                                                        ;

                                                        itemList[ind]
                                                            .nameItem
                                                            .remove(
                                                                dataAttr[index1]
                                                                    .itemName);
                                                        itemList[ind]
                                                            .shipinfee
                                                            .remove(dataAttr[
                                                                    index1]
                                                                .shippingFee);
                                                        // getItemPrice(ind);
                                                        itemList[ind]
                                                            .pickupfee
                                                            .remove(
                                                                dataAttr[index1]
                                                                    .pickupFee);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    margin: EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    width: 80,
                                                    child: Center(
                                                      child: Text(
                                                          dataAttr[index1]
                                                              .shippingFee
                                                              .toString()),
                                                    )),
                                                widget.itemDetails['type'] ==
                                                        "Pick up"
                                                    ? Container(
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey)),
                                                        margin: EdgeInsets.only(
                                                          left: 40,
                                                        ),
                                                        width: 80,
                                                        child: Center(
                                                          child: widget.itemDetails[
                                                                      'type'] ==
                                                                  "Pick up"
                                                              ? Text(dataAttr[
                                                                      index1]
                                                                  .pickupFee
                                                                  .toString())
                                                              : Text("0"),
                                                        ))
                                                    : Container(),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        border: Border.all(
                                                            color:
                                                                Colors.grey)),
                                                    height: 40,
                                                    margin: EdgeInsets.only(
                                                      left: 40,
                                                    ),
                                                    width: 70,
                                                    child: Center(
                                                      child: Text(
                                                          dataAttr[index1]
                                                              .available
                                                              .toString()),
                                                    )),
                                                dataAttr[index1].key == true
                                                    ? Container(
                                                        height: 40,
                                                        margin: EdgeInsets.only(
                                                          left: 40,
                                                        ),
                                                        width: 70,
                                                        child: Center(
                                                          child: TextFormField(
                                                            validator: (v) {
                                                              if (v!.isEmpty) {
                                                                return 'required*';
                                                              }
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly
                                                            ],
                                                            initialValue: "",
                                                            onChanged: (v) {
                                                              setState(() {
                                                                if (int.parse(dataAttr[
                                                                            index1]
                                                                        .available) >=
                                                                    int.parse(
                                                                        v)) {
                                                                  indexGet = itemList[
                                                                          ind]
                                                                      .tempItem
                                                                      .indexWhere(
                                                                        (f) =>
                                                                            f['id'] ==
                                                                            dataAttr[index1].id,
                                                                      );

                                                                  itemList[ind].tempItem[
                                                                              indexGet]
                                                                          [
                                                                          'qty'] =
                                                                      v.toString();
                                                                  itemList[ind]
                                                                      .qty
                                                                      .add(itemList[ind]
                                                                              .tempItem[indexGet]
                                                                          [
                                                                          'qty'])
                                                                      .toString();
                                                                  itemList[ind]
                                                                      .qty
                                                                      .remove(itemList[ind]
                                                                              .tempItem[indexGet]
                                                                          [
                                                                          'qty']);
                                                                  print(
                                                                      "TTTTTTTTTTTTT${itemList[ind].tempItem[indexGet]['qty']}");

                                                                  getItemPrice(
                                                                      ind);
                                                                } else {
                                                                  showDialog<
                                                                      String>(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      content: Text(
                                                                          "You have entered incorrect quantity"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'OK'),
                                                                          child:
                                                                              const Text('OK'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 17),
                                                            decoration:
                                                                InputDecoration(
                                                                    fillColor:
                                                                        Color(
                                                                            0xffF5F6FA),
                                                                    filled:
                                                                        true,
                                                                    enabledBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1.2,
                                                                          color:
                                                                              Color(0xffF5F6FA)),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      // borderRadius: new BorderRadius.circular(25.0),
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1.2,
                                                                          color:
                                                                              Color(0xffF5F6FA)),
                                                                    ),
                                                                    errorBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1.2,
                                                                          color:
                                                                              Color(0xffF5F6FA)),
                                                                    ),
                                                                    focusedErrorBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(4)),
                                                                      borderSide: BorderSide(
                                                                          width:
                                                                              1.2,
                                                                          color:
                                                                              Color(0xffF5F6FA)),
                                                                    ),
                                                                    // border: InputBorder.none,
                                                                    hintText:
                                                                        "4",
                                                                    hintStyle: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            15)),
                                                          ),
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            );
                                          });
                                        },
                                      ),
                                    );
                                  }),
                            ),
                            (Responsive.isDesktop(context))
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        onPressed: () {
                                          if (_formkey1.currentState!
                                              .validate())
                                            Navigator.pop(context);
                                        },
                                        child: const Text('Done'),
                                      ),
                                    ))
                                : Container(
                                    margin: EdgeInsets.only(left: w * 0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        onPressed: () {
                                          if (_formkey1.currentState!
                                              .validate())
                                            Navigator.pop(context);
                                        },
                                        child: const Text('Done'),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }

  _showDialogOnButtonPressing({ind}) => showDialog(
      context: context,
      builder: (context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * (20 / 100),
              height: MediaQuery.of(context).size.height * (50 / 100),
              child: ListView.builder(
                  itemCount: catData.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    print("TTTTTTTTindexxxxxxx$ind");
                    return GestureDetector(
                      onTap: () {
                        category = catData[index].item;

                        var checkCat = allItem.contains(category);

                        itemList[ind].categoryName = catData[index].itemId;

                        Navigator.pop(context);

                        setState(() {
                          temp.add(false);
                        });

                        showAttr(ind, index);
                      },
                      child: ListTile(
                        title: Text(catData[index].itemId.toString()),
                      ),
                    );
                  }),
            ),
          ));

  String? img64;
  _openCamera(BuildContext context, index) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      itemList[index].imageList!.length <= 5
          ? itemList[index].imageList!.add(_image!.path)
          : showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: Text("Max upload"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );

      imagefile = File(_image!.path);
    });
    final bytes = await Io.File(imagefile!.path).readAsBytes();
    img64 = base64Encode(bytes);
  }

  List goodsInfo = [];
  var itempickupfee, shiping;
  var bookingId;

  var imageURL;
  PlatformFile? objFile = null;

  void chooseFileUsingFilePicker(BuildContext context, index) async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
        withReadStream:
            true, // this will return PlatformFile object with read stream
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      // setState(() async {
      objFile = result.files.single;

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
      );

      request.files.add(new http.MultipartFile(
          "file", objFile!.readStream!, objFile!.size,
          filename: objFile!.name));

      //-------Send request
      var resp = await request.send();

      //------Read response
      var result2 = await resp.stream.bytesToString();

      var temp3 = ImageModel.fromJson(json.decode(result2));
      // temp2!.add(temp3);

      // var test = temp3.data[0].image.replace("/([^:]\/)\/+/g", "");
      var test = temp3.data[0].image.replaceAll("(?<!http:)//", "/");

      imageURL = temp3.data[0].image;

      setState(() {
        itemList[index].imageList!.add(imageURL.toString());
      });

      //-------Your response

      // });
    }
  }

  void uploadSelectedFile(index) async {
    //---Create http package multipart request object
    final request = http.MultipartRequest(
      "POST",
      Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
    );

    request.files.add(new http.MultipartFile(
        "file", objFile!.readStream!, objFile!.size,
        filename: objFile!.name));

    //-------Send request
    var resp = await request.send();

    //------Read response
    String result = await resp.stream.bytesToString();

    itemList[index].imageList!.add(result);

    //-------Your response
  }

  addBooking() async {
    setState(() {
      if (allItem.length == 0) {
        for (int i = 0; i < itemList.length; i++) {
          for (int i1 = 0; i1 < itemList[i].tempItem.length; i1++) {
            itemList[i].qty.add(itemList[i].tempItem[i1]['qty']);
            print(
                "HHHHHHHHHHHHHH${itemList[i].tempItem[i1]['qty'].runtimeType}");
          }
          allItem.add({
            "category_id": "${(itemList[i].categoryName).toString()}",
            "item_name": jsonEncode(itemList[i].tempItem),
            "shipping_fee": "${itemList[i].shipinfee.join(",")}",
            "pickupfee": "${(itemList[i].pickupfee.join(","))}",
            "item_image": jsonEncode(itemList[i].imageList),
            "description": "${(itemList[i].description).toString()}",
            "quantity": "${itemList[i].qty}",
          });
        }
      }
    });
    print("HHHHHHHHHHHHHH$allItem");

    var bookingData = {
      "schedule_id": (widget.itemDetails['shipmentId']).toString(),
      "title": (widget.itemDetails['title']).toString(),
      "receptionist_name": (widget.itemDetails['receptionName']).toString(),
      "receptionist_email": (widget.itemDetails['receptionEmail']).toString(),
      "receptionist_phone": (widget.itemDetails['receptionContact']).toString(),
      "receptionist_address":
          (widget.itemDetails['receptionAddress']).toString(),
      "receptionist_country":
          (widget.itemDetails['receptionCountry']).toString(),
      "pickup_type": (widget.itemDetails['type']).toString(),
      "pickup_date": (widget.itemDetails['pickup_dropoff_date']).toString(),
      "pickup_time": (widget.itemDetails['pickup_dropoff_time']).toString(),
      "pickup_location":
          (widget.itemDetails['pickup_dropoff_Location']).toString(),
      "pickup_distance": (widget.itemDetails['pickupMiles']).toString(),
      "pickup_estimate": (widget.itemDetails['pickupestimate']).toString(),
      "items": jsonEncode(allItem)
    };

    //return;
    var responce = await Providers().createBooking(bookingData);

    if (responce.status == true) {
      bookingId = responce.data[0].id;
      print("SHOW>>>BOOKING_ID>>>>$bookingId");

      var data = {
        "schedule_id": (widget.itemDetails['shipmentId']).toString(),
        "title": (widget.itemDetails['title']).toString(),
        "receptionist_name": (widget.itemDetails['receptionName']).toString(),
        "receptionist_email": (widget.itemDetails['receptionEmail']).toString(),
        "receptionist_phone":
            (widget.itemDetails['receptionContact']).toString(),
        "receptionist_address":
            (widget.itemDetails['receptionAddress']).toString(),
        "receptionist_country":
            (widget.itemDetails['receptionCountry']).toString(),
        "pickup_type": (widget.itemDetails['type']).toString(),
        "pickup_date": (widget.itemDetails['pickup_dropoff_date']).toString(),
        "pickup_time": (widget.itemDetails['pickup_dropoff_time']).toString(),
        "pickup_location":
            (widget.itemDetails['pickup_dropoff_Location']).toString(),
        "pickup_distance": (widget.itemDetails['pickupMiles']).toString(),
        "pickup_estimate": (widget.itemDetails['pickupestimate']).toString(),
        "bookingid": "$bookingId",
        "paymentUrl": responce.paymentLink,
        "totalprice": sum
      };

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PaymentSummary(itemDetail: itemList, data: data)));
    }
  }

  var data1;
  void initState() {
    super.initState();
    data1 = widget.itemDetails;

    getScheduleItem();
  }

  _requiredField(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  var cardCount = 1;
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
      body: Form(
        key: _formkey,
        child: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffE5E5E5),
            child: SafeArea(
                right: false,
                child: ListView(
                  addAutomaticKeepAlives: true,
                  scrollDirection: Axis.vertical,
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
                          Container(
                              margin: (Responsive.isDesktop(context))
                                  ? EdgeInsets.fromLTRB(10, 5, 5, 0)
                                  : EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: (Responsive.isDesktop(context))
                                  ? Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                Routes.CLIENTDASHBOARDROUTE);
                                          },
                                          child: Text(
                                            'Dashboard>',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            '${widget.itemDetails["companyName"]} >',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          'Pickup / Drop Off',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  : Wrap(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                Routes.CLIENTDASHBOARDROUTE);
                                          },
                                          child: Text(
                                            'Dashboard >',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            '${widget.itemDetails["companyName"]} >' +
                                                'Pickup / Drop Off',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )),
                        ],
                      ),
                    ),
                    // _card(),
                    (Responsive.isDesktop(context))
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              return _card(index: index);
                            },
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              return _card(index: index);
                            },
                          ),

                    if (Responsive.isDesktop(context))
                      category == null
                          ? Container()
                          : Row(children: [
                              InkWell(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    for (int i = 0; i < itemList.length; i++) {
                                      if (itemList[i].imageList!.isEmpty) {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content:
                                                Text("Please upload the image"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return;
                                      }
                                    }

                                    _formkey.currentState!.save();

                                    addBooking();
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 15, left: 15, right: 20, bottom: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color(0xff1F2326)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.all(15),
                                          child: Center(
                                              child: Text("Proceed to Payment",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  )))),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 15, right: 10, left: 30),
                                        height: 30,
                                        // width: 300,
                                        child: Image.asset(
                                            'assets/images/arrow-right.png'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cardCount += 1;
                                    itemList.add(ItemDetail(
                                        itemtotal: "",
                                        categoryName: "",
                                        description: "",
                                        imageList: [],
                                        itemName: "",
                                        qty: [],
                                        shipinfee: [],
                                        pickupfee: [],
                                        icon: "",
                                        nameItem: [],
                                        tempItem: []));
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 15, left: 15, right: 20, bottom: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Color(0xff1A494F)),
                                  height: MediaQuery.of(context).size.height *
                                      (7 / 100),
                                  width: 160,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Add More Item",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/arrow-right.png'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),

                    if (!Responsive.isDesktop(context))
                      category == null
                          ? Container()
                          : Row(children: [
                              InkWell(
                                onTap: () {
                                  if (_formkey.currentState!.validate()) {
                                    for (int i = 0; i < itemList.length; i++) {
                                      if (itemList[i].imageList!.isEmpty) {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            content:
                                                Text("Please upload the image"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                        return;
                                      }
                                    }

                                    _formkey.currentState!.save();

                                    addBooking();
                                  }
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      (7 / 100),
                                  width: 160,
                                  margin: EdgeInsets.only(
                                      top: 15, left: 15, right: 10, bottom: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: Color(0xff1F2326)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          //   left: 5,
                                          //   top: 15,
                                          // ),
                                          child: Center(
                                              child: Text("Proceed to Payment",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  )))),
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/arrow-right.png'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    cardCount += 1;
                                    itemList.add(ItemDetail(
                                        itemtotal: "",
                                        categoryName: "",
                                        description: "",
                                        imageList: [],
                                        itemName: "",
                                        qty: [],
                                        shipinfee: [],
                                        pickupfee: [],
                                        icon: "",
                                        nameItem: [],
                                        tempItem: []));
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 15, left: 10, right: 10, bottom: 50),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: Color(0xff1A494F)),
                                  height: MediaQuery.of(context).size.height *
                                      (7 / 100),
                                  width: 150,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          "Add More Item",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 5),
                                        height: 20,
                                        width: 20,
                                        child: Image.asset(
                                            'assets/images/arrow-right.png'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                  ],
                ))),
      ),
    );
  }

  Widget _card({index, index1}) {
    return (Responsive.isDesktop(context))
        ? Card(
            child: Container(
            margin: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            height: MediaQuery.of(context).size.height * (75 / 100),
            // height: 100,
            width: MediaQuery.of(context).size.width * (70 / 100),
            child: ListView(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Category" + (index + 1).toString(),
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // _showDialogOnButtonPressing2();
                        setState(() {
                          cardCount -= 1;

                          itemList.removeLast();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            color: Color(0xffC4C4C4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Container(
                      margin: EdgeInsets.only(left: 5, top: 15),
                      child: Text(
                        "${itemList[index].categoryName}" + ":",
                        style: TextStyle(fontSize: 18),
                      )),
                  dataAttr.length > 0
                      ? Container(
                          margin: EdgeInsets.only(left: 5, top: 15),
                          child: Text(
                            itemList[index].nameItem != null
                                ? "${itemList[index].nameItem.join(",")}"
                                : "",
                            style: TextStyle(fontSize: 18),
                          ))
                      : Text(''),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showDialogOnButtonPressing(ind: index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15, left: 15, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xff1A494F)),
                      height: MediaQuery.of(context).size.height * (7 / 100),
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "Select Items",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            height: 20,
                            width: 20,
                            child: Image.asset('assets/images/arrow-right.png'),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
                Row(children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Image",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ]),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {
                          if (itemList[index].imageList!.length < 5) {
                            chooseFileUsingFilePicker(context, index);
                          } else {
                            showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text(
                                    "Only 5 images upload",
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      child: const Text('OK'),
                                      onTap: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          height:
                              MediaQuery.of(context).size.height * (15 / 100),
                          width: MediaQuery.of(context).size.width * (8 / 100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Color(0xffE5E5E5),
                          ),
                          child: ImageIcon(
                            AssetImage(
                              'assets/images/document.png',
                            ),
                            size: 8,
                          ),
                        ),
                      ),
                    ),
                    itemList[index].imageList!.length == 0
                        ? Container()
                        : Container(
                            height: h * .10,
                            child: ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: itemList[index].imageList!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index1) {
                                  return Container(
                                      margin: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                        color: Color(0xffE5E5E5),
                                      ),
                                      child: Image.network(
                                        itemList[index].imageList![index1],
                                        fit: BoxFit.contain,
                                      ));
                                }),
                          ),
                    Spacer(),
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  "Total Fee",
                                  style: TextStyle(fontSize: 18),
                                )),
                            // itemList[index].qty == ""
                            itemList[index].amounttotal == null
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(left: 20, top: 10),
                                    child: Text(
                                      String.fromCharCodes(
                                              new Runes('\u0024')) +
                                          itemList[index]
                                              .amounttotal
                                              .toString(),
                                      style: TextStyle(fontSize: 18),
                                    ))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'required*';
                      }
                    },
                    maxLines: 3,
                    onChanged: (v) {
                      setState(() {
                        itemList[index].description = v;
                        des = v;
                      });
                    },
                    style: TextStyle(color: Colors.black, fontSize: 17),
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
                        hintText:
                            "The Summary page provides an overview of your shipment contents, as well as tools for tracking carrier progress and the receiving process of your shipments after they arrive at fulfillment centers. the shipping process involves everything from receiving a customer order to preparing it for last-mile delivery. Shipping an order involves several factors, such as order management, warehousing, and carrier relationships",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ))
        : Container(
            margin: EdgeInsets.fromLTRB(10, 15, 10, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),
            height: MediaQuery.of(context).size.height * (69 / 100),
            // height: 100,
            width: MediaQuery.of(context).size.width * (55 / 100),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Category" + (index + 1).toString(),
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        // _showDialogOnButtonPressing2();
                        setState(() {
                          cardCount -= 1;

                          itemList.removeLast();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            color: Color(0xffC4C4C4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "${itemList[index].categoryName}" + ":",
                        style: TextStyle(fontSize: 12),
                      )),
                  dataAttr.length > 0
                      ? Container(
                          margin: EdgeInsets.only(left: 5, top: 15),
                          child: SingleChildScrollView(
                            child: Text(
                              itemList[index].nameItem != null
                                  ? "${itemList[index].nameItem.join(",")}"
                                  : "",
                              style: TextStyle(fontSize: 10),
                            ),
                          ))
                      : Text(''),
                ]),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      _showDialogOnButtonPressing(ind: index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5, left: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xff1A494F)),
                      height: MediaQuery.of(context).size.height * (7 / 100),
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text(
                              "Select Items",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.only(right: 5),
                            height: 20,
                            width: 20,
                            child: Image.asset('assets/images/arrow-right.png'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Row(children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 20),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Image",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ]),
                Row(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        if (itemList[index].imageList!.length < 5) {
                          chooseFileUsingFilePicker(context, index);
                        } else {
                          showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                  "Only 5 images upload",
                                ),
                                actions: <Widget>[
                                  InkWell(
                                    child: const Text('OK'),
                                    onTap: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, top: 20),
                        height: MediaQuery.of(context).size.height * (15 / 100),
                        width: MediaQuery.of(context).size.width * (8 / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0xffE5E5E5),
                        ),
                        child: ImageIcon(
                          AssetImage(
                            'assets/images/document.png',
                          ),
                          size: 8,
                        ),
                      ),
                    ),
                  ),
                  itemList[index].imageList!.length == 0
                      ? Container()
                      : Container(
                          height: h * .10,
                          child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: itemList[index].imageList!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index1) {
                                return Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.0),
                                      color: Color(0xffE5E5E5),
                                    ),
                                    child: Image.network(
                                      itemList[index].imageList![index1],
                                      fit: BoxFit.contain,
                                    ));
                              }),
                        ),
                ]),
                Spacer(),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            child: Text(
                              "Total Fee",
                              style: TextStyle(fontSize: 18),
                            )),
                        // itemList[index].qty == ""
                        itemList[index].amounttotal == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                child: Text(
                                  String.fromCharCodes(new Runes('\u0024')) +
                                      itemList[index].amounttotal.toString(),
                                  style: TextStyle(fontSize: 18),
                                ))
                      ],
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, right: 10, left: 20),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: TextFormField(
                    validator: (v) {
                      if (v!.isEmpty) {
                        return 'required*';
                      }
                    },
                    maxLines: 3,
                    onChanged: (v) {
                      setState(() {
                        itemList[index].description = v;
                        des = v;
                      });
                    },
                    style: TextStyle(color: Colors.black, fontSize: 17),
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
                        hintText:
                            "description · to give a detailed/full description of the procedure · a brief/general description of the shiping items·",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
          );
  }
}
