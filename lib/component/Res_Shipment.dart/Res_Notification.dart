import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';

import 'package:shipment/pages/Shipment/Notification/shipmentNotification.dart';

import '../../pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ShipmentNotificationScreen extends StatefulWidget {
  static const String route = '/';
  const ShipmentNotificationScreen({Key? key}) : super(key: key);

  @override
  _ShipmentNotificationScreen createState() => _ShipmentNotificationScreen();
}

class _ShipmentNotificationScreen extends State<ShipmentNotificationScreen> {
  var _lastQuitTime;
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_lastQuitTime == null ||
            DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
          print('Press again Back Button exit');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => (!Responsive.isDesktop(context))
                      ? ShipmentDashboard()
                      : ResDashboardshipment()));
          return false;
        } else {
          // SystemNavigator.pop();

          return false;
        }
      },
      child: Scaffold(
        body: Responsive(
          mobile: ShipmentNotificationShow(),
          tablet: ShipmentNotificationShow(),
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
                child: ShipmentNotificationShow(),
              ),
              // Expanded(
              //   flex: _size.width > 1340 ? 8 : 10,
              //   child: EmailScreen(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
