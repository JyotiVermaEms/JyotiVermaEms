import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Departure%20Manager/Order/Select_Pickup_agent.dart';

class SelectAgent extends StatefulWidget {
  var pid;
  var bid;
  SelectAgent({Key? key, required this.pid, required this.bid})
      : super(key: key);

  @override
  _SelectAgentState createState() => _SelectAgentState();
}

class _SelectAgentState extends State<SelectAgent> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SelectPickupAgent(pid1: widget.pid, bid1: widget.bid),
        tablet: SelectPickupAgent(pid1: widget.pid, bid1: widget.bid),
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
              child: SelectPickupAgent(pid1: widget.pid, bid1: widget.bid),
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
