import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/pages/Client/MarketPlace/CreateBooking/MarketplaceDetails.dart';

class ResMarketPlacedetails extends StatefulWidget {
  const ResMarketPlacedetails({Key? key}) : super(key: key);

  @override
  _ResMarketPlacedetailsState createState() => _ResMarketPlacedetailsState();
}

class _ResMarketPlacedetailsState extends State<ResMarketPlacedetails> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: MarketPlaceDetails(),
        tablet: MarketPlaceDetails(),
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
              child: MarketPlaceDetails(),
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
