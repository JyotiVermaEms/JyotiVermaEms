import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/pages/Accountant/Dashboard/AccountantContainerList.dart';

class ContainerList extends StatefulWidget {
  var data;
  ContainerList(this.data);

  @override
  _ContainerListState createState() => _ContainerListState();
}

class _ContainerListState extends State<ContainerList> {
  var data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // clientbookingsApi();
    data = widget.data;
  }

  int? index;

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: AccountantContainerList(data),
        tablet: AccountantContainerList(data),
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
              child: AccountantContainerList(data),
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
