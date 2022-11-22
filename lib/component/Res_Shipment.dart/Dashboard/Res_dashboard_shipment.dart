import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ResDashboardshipment extends StatefulWidget {
  static const String route = '/';
  const ResDashboardshipment({Key? key}) : super(key: key);

  @override
  _ResDashboardshipmentState createState() => _ResDashboardshipmentState();
}

class _ResDashboardshipmentState extends State<ResDashboardshipment> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ShipmentDashboard(),
        tablet: ShipmentDashboard(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ShipmentDashboard(),
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
