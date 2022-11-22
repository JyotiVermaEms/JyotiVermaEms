import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/ArrivalOrderManagement.dart';
import 'package:shipment/pages/Departure%20Manager/Order/DepartureOrder.dart';
import 'package:shipment/pages/Departure%20Manager/OrderHistory/orderhistory.dart';

class DepOrdersHistory extends StatefulWidget {
  const DepOrdersHistory({Key? key}) : super(key: key);

  @override
  _DepOrdersHistoryState createState() => _DepOrdersHistoryState();
}

class _DepOrdersHistoryState extends State<DepOrdersHistory> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: DepartureOrderHistory(),
        tablet: DepartureOrderHistory(),
        desktop: Row(
          children: [
          
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: DepartureSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: DepartureOrderHistory(),
            ),
          
          ],
        ),
      ),
    );
  }
}
