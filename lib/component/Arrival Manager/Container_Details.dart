import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Arrival%20Dashboard/ContainerDetails.dart';

class Container_Details extends StatefulWidget {
  const Container_Details({Key? key}) : super(key: key);

  @override
  _Container_DetailsState createState() => _Container_DetailsState();
}

class _Container_DetailsState extends State<Container_Details> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ContainerDetails(),
        tablet: ContainerDetails(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ArrivalSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ContainerDetails(),
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
