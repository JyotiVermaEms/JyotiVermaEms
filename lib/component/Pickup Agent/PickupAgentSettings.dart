import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/Pickupagent_settings.dart';
import 'package:shipment/pages/Pickup%20Agent/pickupAgentProfileSetting.dart';
import 'package:shipment/pages/Receptionist/Settings/ProfileSettings.dart';

class PickupagentSettings extends StatefulWidget {
  const PickupagentSettings({Key? key}) : super(key: key);

  @override
  _PickupagentSettingsState createState() => _PickupagentSettingsState();
}

class _PickupagentSettingsState extends State<PickupagentSettings> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: PickupSettings(),
        tablet: PickupSettings(),
        desktop: Row(children: [
          // Once our width is less then 1300 then it start showing errors
          // Now there is no error if our width is less then 1340
          Expanded(
            flex: _size.width > 1340 ? 2 : 4,
            child: PickupSideBar(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 5 : 6,
            child: PickupSettings(),
          ),
          Expanded(
            flex: _size.width > 1340 ? 6 : 9,
            child: PickupAgentProfileSetting(),
          ),
        ]),
      ),
    );
  }
}
