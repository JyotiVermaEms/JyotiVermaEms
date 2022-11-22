import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/Order/InprogressOrders.dart';

class inprogressOrderList extends StatefulWidget {
  const inprogressOrderList({Key? key}) : super(key: key);

  @override
  _inprogressOrderListState createState() => _inprogressOrderListState();
}

class _inprogressOrderListState extends State<inprogressOrderList> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: inprogressOrders(),
        tablet: inprogressOrders(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: PickupSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: inprogressOrders(),
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
