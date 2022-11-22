import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/Booking_Description.dart';

class ResBookingDescription extends StatefulWidget {
  var data;
  ResBookingDescription(this.data);
  // const ResBookingDescription({Key? key}) : super(key: key);

  @override
  _ResBookingDescriptionState createState() => _ResBookingDescriptionState();
}

class _ResBookingDescriptionState extends State<ResBookingDescription> {
  var data;
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: BookinDescription(data),
        tablet: BookinDescription(data),
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
              child: BookinDescription(data),
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
