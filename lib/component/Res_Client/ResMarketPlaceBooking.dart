import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Model/Shipment/scheduleShipmentRes.dart';
import 'package:shipment/pages/Client/MarketPlace/MarketPlaceviewBooking.dart';

class ResMarketPlaceBooking extends StatefulWidget {
  const ResMarketPlaceBooking({Key? key}) : super(key: key);

  @override
  _ResMarketPlaceBookingState createState() => _ResMarketPlaceBookingState();
}

class _ResMarketPlaceBookingState extends State<ResMarketPlaceBooking> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: viewMarketPlaceBooking(),
        tablet: viewMarketPlaceBooking(),
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
              child: viewMarketPlaceBooking(),
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
