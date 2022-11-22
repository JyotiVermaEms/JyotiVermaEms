import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Model/Shipment/scheduleShipmentRes.dart';
import 'package:shipment/pages/Client/MarketPlace/MarketPlaceviewBooking.dart';
import 'package:shipment/pages/Client/MarketPlace/marketPlaceviewBooking2.dart';

class ResMarketPlaceBooking2 extends StatefulWidget {
  var data;
  ResMarketPlaceBooking2(this.data);

  @override
  _ResMarketPlaceBookingState2 createState() => _ResMarketPlaceBookingState2();
}

class _ResMarketPlaceBookingState2 extends State<ResMarketPlaceBooking2> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    var id = widget.data['marketplaceid'].toString();
    print("-=-==-=-==" + id.toString());
    return Scaffold(
      body: Responsive(
        mobile: viewMarketPlaceBooking2(widget.data),
        tablet: viewMarketPlaceBooking2(widget.data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: viewMarketPlaceBooking2(widget.data),
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
