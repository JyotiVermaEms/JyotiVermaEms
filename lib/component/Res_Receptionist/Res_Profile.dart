import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Profile/Profile.dart';

class ResProfile extends StatefulWidget {
  const ResProfile({Key? key}) : super(key: key);

  @override
  _ResProfileState createState() => _ResProfileState();
}

class _ResProfileState extends State<ResProfile> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Profile(),
        tablet: Profile(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ReceptionSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: Profile(),
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
