import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/Pricing.dart';

class ResPricing extends StatefulWidget {
  var data;

  ResPricing(this.data);
  // const ResPricing({Key? key}) : super(key: key);

  @override
  _ResPricingState createState() => _ResPricingState();
}

class _ResPricingState extends State<ResPricing> {
  var data;
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    data = widget.data;
    print("object data   ${jsonEncode(data)}");
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Princing(data),
        tablet: Princing(data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: Princing(data),
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
