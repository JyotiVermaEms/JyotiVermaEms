import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/pages/Arrival%20Manager/ArrivalChatScreen.dart';

class Arrivalchat extends StatefulWidget {
  const Arrivalchat({Key? key}) : super(key: key);

  @override
  _ArrivalchatState createState() => _ArrivalchatState();
}

class _ArrivalchatState extends State<Arrivalchat> {
  var data = {};
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ArrivalChatScreen(),
        tablet: ArrivalChatScreen(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: ArrivalSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 7 : 25,
              child: ArrivalChatScreen(),
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
