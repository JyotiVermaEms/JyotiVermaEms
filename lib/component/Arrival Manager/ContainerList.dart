import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/ArrivalContainerList.dart';

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
        mobile: ArrivalContainerList(data),
        tablet: ArrivalContainerList(data),
        desktop: Row(
          children: [
           
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ArrivalSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ArrivalContainerList(data),
            ),
          
          ],
        ),
      ),
    );
  }
}
