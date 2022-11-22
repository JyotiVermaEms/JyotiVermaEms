import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Dashboard/ItemDetails.dart';
import 'package:shipment/pages/Client/Dashboard/Price_Summary.dart';

class PaymentSummary extends StatefulWidget {
  List<ItemDetail>? itemDetail;
  var data;

  PaymentSummary({this.itemDetail, this.data});

  @override
  _PaymentSummaryState createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var itemList;
  var data;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    // for (int i = 0; i < widget.itemDetail!.length; i++) {
    // Uint8List image = Base64Codec().decode(widget.itemDetail![0].imageList); // image is a Uint8List

    //  var image = Base64Codec().decode(widget.itemDetail![0].imageList);

    itemList = widget.itemDetail;
    data = widget.data;

    log("itemList  >>  ${(itemList)}");
    log("data  >>  ${(data)}");

    // }
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    // log("DATA  >>  ${widget.itemDetail![0].imageList}");
    return Scaffold(
      body: Responsive(
        mobile: PriceSummary(itemList, data),
        tablet: PriceSummary(itemList, data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1300 ? 4 : 5,
              child: PriceSummary(itemList, data),
            ),
            // Expanded(
            //   flex: _size.width > 1340 ? 8 : 10,
            //   child: EmailScreen(),
            // ),
          ],
        ),
      ),
    );
  }
}
