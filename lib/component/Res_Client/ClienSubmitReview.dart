import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/pages/Client/Review/SubmirClientReview.dart';

class ClinetSubmitReview extends StatefulWidget {
  var data;
  ClinetSubmitReview(this.data);
  // const ClinetSubmitReview({Key? key}) : super(key: key);

  @override
  _ClinetSubmitReviewState createState() => _ClinetSubmitReviewState();
}

class _ClinetSubmitReviewState extends State<ClinetSubmitReview> {
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
        mobile: SubmitClientFeedback(data),
        tablet: SubmitClientFeedback(data),
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
              child: SubmitClientFeedback(data),
            ),
          ],
        ),
      ),
    );
  }
}
