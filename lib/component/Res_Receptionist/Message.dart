import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/component/Res_Receptionist/Reception_Sidebar.dart';
import 'package:shipment/pages/Receptionist/Chat/Messages.dart';

class Message extends StatefulWidget {
  const Message({Key? key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var data = {};
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: Messages(),
        tablet: Messages(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: ReceptionSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 7 : 25,
              child: Messages(),
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
