import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/pages/Client/Review/ClientReview.dart';

class ClientReviewRes extends StatefulWidget {
  var data;
  ClientReviewRes(this.data);
  // const ClientReviewRes({Key? key}) : super(key: key);

  @override
  _ClientReviewResState createState() => _ClientReviewResState();
}

class _ClientReviewResState extends State<ClientReviewRes> {
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
        mobile: ClientReview(data),
        tablet: ClientReview(data),
        desktop: Row(
          children: [
         
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ClientReview(data),
            ),
          ],
        ),
      ),
    );
  }
}
