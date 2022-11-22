import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/ArrivalOrderManagement.dart';
import 'package:shipment/pages/Arrival%20Manager/orderhistory/orderhistory.dart';

class ResOrderHistory extends StatefulWidget {
  const ResOrderHistory({Key? key}) : super(key: key);

  @override
  _ResOrderHistoryState createState() => _ResOrderHistoryState();
}

class _ResOrderHistoryState extends State<ResOrderHistory> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ArrivalOrderHistory(),
        tablet: ArrivalOrderHistory(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ArrivalSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ArrivalOrderHistory(),
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
