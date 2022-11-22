import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/shipmentSchedulModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Orders/OrderRecieved.dart';
import 'package:shipment/pages/Shipment/Orders/order.dart';

import '../../../pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ResOrders extends StatefulWidget {
  const ResOrders({
    Key? key,
  }) : super(key: key);

  @override
  _ResOrdersState createState() => _ResOrdersState();
}

class _ResOrdersState extends State<ResOrders> {
  var _lastQuitTime;
  List<Schedule>? scheduleData;
  int? schedulid;
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    var index;
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
          mobile: orders(),
          tablet: orders(),
          desktop: Row(
            children: [
              Expanded(
                flex: _size.width > 1340 ? 1 : 4,
                child: ShipmentSidebar(),
              ),
              Expanded(
                flex: _size.width > 1340 ? 4 : 5,
                child: orders(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
