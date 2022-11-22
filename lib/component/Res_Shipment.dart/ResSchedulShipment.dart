import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/ScheduleShipment.dart';

import '../../pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ResScheduleShipment extends StatefulWidget {
  const ResScheduleShipment({Key? key}) : super(key: key);

  @override
  _ResScheduleShipmentState createState() => _ResScheduleShipmentState();
}

class _ResScheduleShipmentState extends State<ResScheduleShipment> {
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
          mobile: ScheduleShipment(),
          tablet: ScheduleShipment(),
          desktop: Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340
              Expanded(
                flex: _size.width > 1340 ? 1 : 2,
                child: ShipmentSidebar(),
              ),
              Expanded(
                flex: _size.width > 1340 ? 4 : 5,
                child: ScheduleShipment(),
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
