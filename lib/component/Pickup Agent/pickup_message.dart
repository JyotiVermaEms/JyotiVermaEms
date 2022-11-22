import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/component/Pickup%20Agent/Pickup_Sidebar.dart';
import 'package:shipment/pages/Pickup%20Agent/Pickup_Messages.dart';

class Pickup_messages extends StatefulWidget {
  const Pickup_messages({Key? key}) : super(key: key);

  @override
  _Pickup_messagesState createState() => _Pickup_messagesState();
}

class _Pickup_messagesState extends State<Pickup_messages> {
  var data = {};
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Pickup_Messages(),
        tablet: Pickup_Messages(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: PickupSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 25,
              child: Pickup_Messages(),
            ),
            // Expanded(
            //   flex: _size.width > 1340 ? 7 : 10,
            //   child: ChatViewScreen(data),
            // ),
          ],
        ),
      ),
    );
  }
}
