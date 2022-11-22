// import 'package:flutter/material.dart';
// import 'package:shipment/Element/Responsive.dart';
// import 'package:shipment/Element/ViewChatScreen.dart';
// import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
// import 'package:shipment/pages/Arrival%20Manager/ArrivalChatScreen.dart';
// import 'package:shipment/pages/Departure%20Manager/Chat/DepartureChat.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   var data={};
//   @override
//   Widget build(BuildContext context) {
//     Size _size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Responsive(
//         mobile: DepartureChatScreen(),
//         tablet: DepartureChatScreen(),
//         desktop: Row(
//           children: [
//             // Once our width is less then 1300 then it start showing errors
//             // Now there is no error if our width is less then 1340
//             Expanded(
//               flex: _size.width > 1340 ? 2 : 4,
//               child: DepartureSidebar(),
//             ),
//             Expanded(
//               flex: _size.width > 1340 ? 4 : 5,
//               child: DepartureChatScreen(),
//             ),
//             Expanded(
//               flex: _size.width > 1340 ? 7 : 10,
//               child: ChatViewScreen(data),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
