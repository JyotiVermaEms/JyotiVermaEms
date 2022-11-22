// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/ScheduleShipment.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/schedulCategory.dart';

class ScheduleCategoryShipmentPage extends StatefulWidget {
  const ScheduleCategoryShipmentPage({Key? key}) : super(key: key);

  @override
  _ScheduleCategoryShipmentPageState createState() =>
      _ScheduleCategoryShipmentPageState();
}

class _ScheduleCategoryShipmentPageState
    extends State<ScheduleCategoryShipmentPage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SelectCategory(),
        tablet: SelectCategory(),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: SelectCategory(),
            ),
          ],
        ),
      ),
    );
  }
}
