import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Settings/ProfileSettings.dart';
import 'package:shipment/pages/Receptionist/Settings/Settings.dart';

class ReceptionistSettings extends StatefulWidget {
  const ReceptionistSettings({Key? key}) : super(key: key);

  @override
  _ReceptionistSettings createState() => _ReceptionistSettings();
}

class _ReceptionistSettings extends State<ReceptionistSettings> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Settings(),
        tablet: Settings(),
        desktop: Row(children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340
          Expanded(
            flex: _size.width > 1340 ? 2 : 4,
            child: ReceptionSidebar(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 5 : 6,
            child: Settings(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 6 : 9,
            child: ProfileSettings(),
          ),
        ]),
      ),
    );
  }
}
