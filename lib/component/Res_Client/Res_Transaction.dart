import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Transactions/Transaction_History.dart';

class ResTransaction extends StatefulWidget {
  const ResTransaction({Key? key}) : super(key: key);

  @override
  _ResTransactionState createState() => _ResTransactionState();
}

class _ResTransactionState extends State<ResTransaction> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: TransactionHistory(),
        tablet: TransactionHistory(),
        desktop: Row(
          children: [
            
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: TransactionHistory(),
            ),
            
          ],
        ),
      ),
    );
  }
}
