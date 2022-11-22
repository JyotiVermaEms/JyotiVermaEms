import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Bookings/detail_page_body.dart';
import 'package:shipment/pages/Shipment/Orders/bookingclientInfo2.dart';

class ClientDetails extends StatefulWidget {
  var data;
  ClientDetails(this.data);

  @override
  _ClientDetails createState() => _ClientDetails();
}

class _ClientDetails extends State<ClientDetails> {
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
        mobile: ClientBody(widget.data),
        tablet: ClientBody(widget.data),  
        desktop: Row(
          children: [
      
           
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ClientBody(widget.data),
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
