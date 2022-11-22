import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/pages/Accountant/Dashboard/AccountantDashboard.dart';

class AAccountantDashboard extends StatefulWidget {
  const AAccountantDashboard({Key? key}) : super(key: key);

  @override
  _AAccountantDashboard createState() => _AAccountantDashboard();
}

class _AAccountantDashboard extends State<AAccountantDashboard> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: AccountantDashboard(),
        tablet: AccountantDashboard(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: AccountantSideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: AccountantDashboard(),
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
