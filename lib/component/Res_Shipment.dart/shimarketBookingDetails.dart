import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Bookings/Bookings.dart';
import 'package:shipment/pages/Shipment/MarketPlace/SubmitProposal.dart';

class BookingMaerketDetails extends StatefulWidget {
  var data;
  BookingMaerketDetails(this.data);

  @override
  _BookingMaerketDetails createState() => _BookingMaerketDetails();
}

class _BookingMaerketDetails extends State<BookingMaerketDetails> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: BookingAttributeDetails(widget.data),
        tablet: BookingAttributeDetails(widget.data),
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
              child: BookingAttributeDetails(widget.data),
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
