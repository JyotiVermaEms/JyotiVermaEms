import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Departure%20Manager/Dashboard/depature_clientbookingShow.dart';
import 'package:shipment/pages/Shipment/Dashboard/Shipment_Dashboard.dart';

class ResDashboardDepature extends StatefulWidget {
  var data;
  static const String route = '/';
  ResDashboardDepature(this.data);

  @override
  _ResDashboardDepature createState() => _ResDashboardDepature();
}

class _ResDashboardDepature extends State<ResDashboardDepature> {
  @override
  Widget build(BuildContext context) {
    var bookingdata = widget.data;
    // print("-=-=-=-=-=-=-=" + bookingdata);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: DepartureClientBookingShow(widget.data),
        tablet: DepartureClientBookingShow(widget.data),
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
              child: DepartureClientBookingShow(widget.data),
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
