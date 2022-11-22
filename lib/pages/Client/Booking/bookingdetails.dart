import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/pages/Client/Booking/clientBookingContainerList.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page_body.dart';

class ResBookingDetails extends StatefulWidget {
  var data;

  ResBookingDetails(this.data);

  @override
  _ResBookingDetailsState createState() => _ResBookingDetailsState();
}

class _ResBookingDetailsState extends State<ResBookingDetails> {
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clientbookingsApi();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ClientViewDetailsBody(data),
        tablet: ClientViewDetailsBody(data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ClientViewDetailsBody(data),
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
