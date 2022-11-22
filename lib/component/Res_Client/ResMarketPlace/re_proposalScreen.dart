import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Model/Shipment/scheduleShipmentRes.dart';
import 'package:shipment/pages/Client/MarketPlace/MarketPlaceviewBooking.dart';
import 'package:shipment/pages/Client/MarketPlace/viewPropasl.dart';

class ResProposalScreen extends StatefulWidget {
  var data1;
  ResProposalScreen(this.data1);

  @override
  _ResProposalScreen createState() => _ResProposalScreen();
}

class _ResProposalScreen extends State<ResProposalScreen> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data1;
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ViewProposalScreen(data),
        tablet: ViewProposalScreen(data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ViewProposalScreen(data),
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
