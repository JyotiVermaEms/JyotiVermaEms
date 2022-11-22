import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/ArrivalOrderManagement.dart';
import 'package:shipment/pages/Departure%20Manager/Order/DepartureOrder.dart';

import 'Dashboard.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
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
              context, MaterialPageRoute(builder: (context) => Dashboard()));
          return false;
        } else {
          // SystemNavigator.pop();

          return false;
        }
      },
      child: Scaffold(
        body: Responsive(
          mobile: DepartureOrders(),
          tablet: DepartureOrders(),
          desktop: Row(
            children: [
              // Once our width is less then 1300 then it start showing errors
              // Now there is no error if our width is less then 1340
              Expanded(
                flex: _size.width > 1340 ? 1 : 4,
                child: DepartureSidebar(),
              ),
              Expanded(
                flex: _size.width > 1340 ? 4 : 5,
                child: DepartureOrders(),
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
