import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/pages/Accountant/ScheduleShipment/AccountantScheduleShipment.dart';

class ScheduleShipment extends StatefulWidget {
  const ScheduleShipment({Key? key}) : super(key: key);

  @override
  _ScheduleShipmentState createState() => _ScheduleShipmentState();
}

class _ScheduleShipmentState extends State<ScheduleShipment> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: AccountScheduleShipment(),
        tablet: AccountScheduleShipment(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: AccountantSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: AccountScheduleShipment(),
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
