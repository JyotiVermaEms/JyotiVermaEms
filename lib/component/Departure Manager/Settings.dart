import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Client/Settings/Settings.dart';
import 'package:shipment/pages/Departure%20Manager/Settings/DepartureSettings.dart';
import 'package:shipment/pages/Departure%20Manager/Settings/depatureManagerProfileSettings.dart';
import 'package:shipment/pages/Receptionist/Settings/ProfileSettings.dart';

class DepSettings extends StatefulWidget {
  const DepSettings({Key? key}) : super(key: key);

  @override
  _DepSettingsState createState() => _DepSettingsState();
}

class _DepSettingsState extends State<DepSettings> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: DepartureSettings(),
        tablet: DepartureSettings(),
        desktop: Row(children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340
          Expanded(
            flex: _size.width > 1340 ? 2 : 4,
            child: DepartureSidebar(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 5 : 6,
            child: DepartureSettings(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 6 : 9,
            child: DepatureMangerProfileSetting(),
          ),
        ]),
      ),
    );
  }
}
