import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page_body.dart';
import 'package:shipment/pages/Shipment/MarketPlace/marketclientbookingInfo.dart';
import 'package:shipment/pages/Shipment/Orders/bookingclientInfo2.dart';

class MarketBookingClientDetails extends StatefulWidget {
  var data;
  MarketBookingClientDetails(this.data);

  @override
  _MarketBookingClientDetails createState() => _MarketBookingClientDetails();
}

class _MarketBookingClientDetails extends State<MarketBookingClientDetails> {
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clientbookingsApi();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    print("-=-=-=-=-=-=${widget.data}");
    return Scaffold(
      body: Responsive(
        mobile: MarketClientBody(widget.data),
        tablet: MarketClientBody(widget.data),
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
              child: MarketClientBody(widget.data),
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
