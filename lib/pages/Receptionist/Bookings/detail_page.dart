import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page_body.dart';

class ReceptionistDetail extends StatefulWidget {
  var data;

  ReceptionistDetail(this.data);

  @override
  _ReceptionistDetailState createState() => _ReceptionistDetailState();
}

class _ReceptionistDetailState extends State<ReceptionistDetail> {
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
        mobile: ReceptionistBody(data),
        tablet: ReceptionistBody(data),
        desktop: Row(
          children: [
           
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ReceptionSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ReceptionistBody(data),
            ),
           
          ],
        ),
      ),
    );
  }
}
