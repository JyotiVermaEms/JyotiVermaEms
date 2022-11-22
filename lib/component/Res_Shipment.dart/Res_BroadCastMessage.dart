import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Dashboard/Shipment_Dashboard.dart';
import 'package:shipment/pages/Shipment/Dashboard/broadCastMessageScreen.dart';

class ResBroadCastMessageScreen extends StatefulWidget {
  static const String route = '/';
  const ResBroadCastMessageScreen({Key? key}) : super(key: key);

  @override
  _ResBroadCastMessageScreen createState() => _ResBroadCastMessageScreen();
}

class _ResBroadCastMessageScreen extends State<ResBroadCastMessageScreen> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: BroadCastMessageScreen(),
        tablet: BroadCastMessageScreen(),
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
              child: BroadCastMessageScreen(),
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
