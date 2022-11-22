import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Departure%20Manager/Dashboard/DepartureContainerList.dart';

class ContainerList extends StatefulWidget {
  var data;

  ContainerList(this.data);
  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
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
        mobile: DepartureContainerList(widget.data),
        tablet: DepartureContainerList(widget.data),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: DepartureSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: DepartureContainerList(widget.data),
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
