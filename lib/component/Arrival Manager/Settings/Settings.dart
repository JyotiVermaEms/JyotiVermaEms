import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/Settings/ArrivalProfileSettings.dart';
import 'package:shipment/pages/Arrival%20Manager/Settings/ArrivalSettings.dart';
import 'package:shipment/pages/Receptionist/Settings/ProfileSettings.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ArrivalSettings(),
        tablet: ArrivalSettings(),
        desktop: Row(children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340
          Expanded(
            flex: _size.width > 1340 ? 2 : 4,
            child: ArrivalSidebar(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 5 : 6,
            child: ArrivalSettings(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 6 : 9,
            child: ArrivalProfileSetting(),
          ),
        ]),
      ),
    );
  }
}
