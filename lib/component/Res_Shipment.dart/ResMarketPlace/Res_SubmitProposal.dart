import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/MarketPlace/SubmitProposal.dart';

class ResSubmitProposal extends StatefulWidget {
  var data;
  ResSubmitProposal(this.data);
  // const ResSubmitProposal({Key? key}) : super(key: key);

  @override
  _ResSubmitProposalState createState() => _ResSubmitProposalState();
}

class _ResSubmitProposalState extends State<ResSubmitProposal> {
  @override
  Widget build(BuildContext context) {
    var data=widget.data;
    print("kkkkkkkkkkkkkkkkk" + widget.data.toString());
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: SubmitProposal(widget.data),
        tablet: SubmitProposal(widget.data),
        desktop: Row(
          children: [
           
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: SubmitProposal(widget.data),
            ),
           
          ],
        ),
      ),
    );
  }
}
