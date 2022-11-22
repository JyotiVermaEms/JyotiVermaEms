import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/pages/Client/Review/SubmirClientReview.dart';
import 'package:shipment/pages/Client/Settings/subuser_Screen.dart';

class ClinetSubUsers extends StatefulWidget {

  ClinetSubUsers();
  // const ClinetSubmitReview({Key? key}) : super(key: key);

  @override
  _ClinetSubUsersState createState() => _ClinetSubUsersState();
}

class _ClinetSubUsersState extends State<ClinetSubUsers> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ClinetSubUser_Screen(),
        tablet: ClinetSubUser_Screen(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: ClinetSubUser_Screen(),
            ),
          ],
        ),
      ),
    );
  }
}
