import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/Dashboard/PickupContainerList.dart';

class ContainerList extends StatefulWidget {
  var data1;
  ContainerList(this.data1);

  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data1;

    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: PickupContainerList(data),
        tablet: PickupContainerList(data),
        desktop: Row(
          children: [
         
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: PickupSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: PickupContainerList(data),
            ),
           
          ],
        ),
      ),
    );
  }
}
