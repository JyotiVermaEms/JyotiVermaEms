import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Arrival%20Manager/ContainerList.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/clientShowbooking.dart';

class ArrivalDashboradClientShowBookings extends StatefulWidget {
  var data;
  static const String route = '/';
  ArrivalDashboradClientShowBookings(this.data);

  @override
  _ArrivalDashboradClientShowBookings createState() =>
      _ArrivalDashboradClientShowBookings();
}

class _ArrivalDashboradClientShowBookings
    extends State<ArrivalDashboradClientShowBookings> {
  @override
  Widget build(BuildContext context) {
    var bookingdata = widget.data;
    // print("-=-=-=-=-=-=-=" + bookingdata);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ArrivalClientBookingShow(widget.data),
        tablet: ArrivalClientBookingShow(widget.data),
        desktop: Row(
          children: [
          
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ArrivalSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ArrivalClientBookingShow(widget.data),
            ),
           
          ],
        ),
      ),
    );
  }
}
