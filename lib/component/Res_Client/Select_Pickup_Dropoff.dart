import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Dashboard/SelectReceptionist.dart';

class PickupDrop extends StatefulWidget {
  var data;
  PickupDrop(this.data);
  // const PickupDrop({Key? key}) : super(key: key);

  @override
  _PickupDropState createState() => _PickupDropState();
}

class _PickupDropState extends State<PickupDrop> {
  var data;
  @override
  void initState() {
    super.initState();
    data = widget.data;
    print("EMS $data");
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SelectReceptionist(data),
        tablet: SelectReceptionist(data),
        desktop: Row(
          children: [
          
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: SelectReceptionist(data),
            ),

          
          ],
        ),
      ),
    );
  }
}
