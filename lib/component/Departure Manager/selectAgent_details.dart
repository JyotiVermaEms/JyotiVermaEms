import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Departure%20Manager/Order/Select_Pickup_agent.dart';
import 'package:shipment/pages/Departure%20Manager/Order/agentProfile.dart';

class AgentProfilDetails extends StatefulWidget {
  var agentDetails;
  AgentProfilDetails(this.agentDetails);

  @override
  _AgentProfilDetails createState() => _AgentProfilDetails();
}

class _AgentProfilDetails extends State<AgentProfilDetails> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    var details = widget.agentDetails;
    print(details.toString());
    return Scaffold(
      body: Responsive(
        mobile: ProfilDetails(details),
        tablet: ProfilDetails(details),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: DepartureSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ProfilDetails(details),
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
