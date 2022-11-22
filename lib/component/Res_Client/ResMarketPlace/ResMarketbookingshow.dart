import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Booking/Booking_Show.dart';
import 'package:shipment/pages/Client/Booking/marketplacebookingShow.dart';

class MarketBooking extends StatefulWidget {
  const MarketBooking({Key? key}) : super(key: key);

  @override
  _MarketBooking createState() => _MarketBooking();
}

class _MarketBooking extends State<MarketBooking> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        body: Responsive(
      mobile: MarketBookingShow(),
      tablet: MarketBookingShow(),
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
            child: MarketBookingShow(),
          ),
          // Expanded(
          //   flex: _size.width > 1340 ? 8 : 10,
          //   child: EmailScreen(),
          // ),
        ],
      ),
    ));
  }
}
