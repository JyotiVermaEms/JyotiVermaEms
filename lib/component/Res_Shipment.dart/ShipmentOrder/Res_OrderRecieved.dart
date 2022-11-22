import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Orders/OrderRecieved.dart';
import 'package:shipment/pages/Shipment/Orders/order.dart';

import '../../../pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ResOrderRecieved extends StatefulWidget {
  const ResOrderRecieved({Key? key}) : super(key: key);

  @override
  _ResOrderRecievedState createState() => _ResOrderRecievedState();
}

class _ResOrderRecievedState extends State<ResOrderRecieved> {
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
          mobile: OrderRecieved(),
          tablet: OrderRecieved(),
          desktop: Row(
            children: [
              Expanded(
                flex: _size.width > 1340 ? 1 : 4,
                child: ShipmentSidebar(),
              ),
              Expanded(
                flex: _size.width > 1340 ? 4 : 5,
                child: OrderRecieved(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
