import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Settings/AddUser.dart';
import 'package:shipment/pages/Shipment/Settings/shipement_subusers_screen.dart';

class Shipment_subUser extends StatefulWidget {
  const Shipment_subUser({Key? key}) : super(key: key);

  @override
  State<Shipment_subUser> createState() => _Shipment_subUserState();
}

class _Shipment_subUserState extends State<Shipment_subUser> {
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ShipmentSubUser_Screen(),
        tablet: ShipmentSubUser_Screen(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ShipmentSubUser_Screen(),
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
