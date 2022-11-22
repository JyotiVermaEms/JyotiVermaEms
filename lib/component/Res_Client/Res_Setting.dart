import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Settings/Profile_Settings.dart';
import 'package:shipment/pages/Client/Settings/Settings.dart';

class ResSettings extends StatefulWidget {
  const ResSettings({Key? key}) : super(key: key);

  @override
  _ResSettingsState createState() => _ResSettingsState();
}

class _ResSettingsState extends State<ResSettings> {
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
            child: SideBar(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 5 : 6,
            child: Settings(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 6 : 9,
            child: Profile_Settings(),
          ),
        ]),
      ),
    );
  }
}
