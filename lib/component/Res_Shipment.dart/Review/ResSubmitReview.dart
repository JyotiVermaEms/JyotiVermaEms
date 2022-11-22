import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Review/SubmitReviewShipment.dart';

class ResSubmitReview extends StatefulWidget {
  var data;
  ResSubmitReview(this.data);

  @override
  _ResSubmitReviewState createState() => _ResSubmitReviewState();
}

class _ResSubmitReviewState extends State<ResSubmitReview> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SubmitReviewShipment(widget.data),
        tablet: SubmitReviewShipment(widget.data),
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
              child: SubmitReviewShipment(widget.data),
            ),
          ],
        ),
      ),
    );
  }
}
