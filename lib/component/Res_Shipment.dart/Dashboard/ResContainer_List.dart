import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Dashboard/dashboard_Container.dart';

class ResContainerList extends StatefulWidget {
  var data;
  ResContainerList(this.data);

  @override
  _ResContainerListState createState() => _ResContainerListState();
}

class _ResContainerListState extends State<ResContainerList> {
  
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clientbookingsApi();
    data = widget.data;
  }

  int? index;
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
   
    return Scaffold(
      body: Responsive(
        mobile: dashboard_ContainerList(data),
        tablet: dashboard_ContainerList(data),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: dashboard_ContainerList(data),
            ),
          ],
        ),
      ),
    );
  }
}
