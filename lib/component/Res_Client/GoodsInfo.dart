import 'package:flutter/material.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/pages/Client/Dashboard/Goods_Details.dart';

class GoodsInfo extends StatefulWidget {
  var data;
  GoodsInfo(this.data);

  // const GoodsInfo({Key? key}) : super(key: key);

  @override
  _GoodsInfoState createState() => _GoodsInfoState();
}

class _GoodsInfoState extends State<GoodsInfo> {
  var itemDetails;
  void initState() {
// TODO: implement initState
    super.initState();
    itemDetails = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: GoodsDetails(itemDetails),
        tablet: GoodsDetails(itemDetails),
        desktop: Row(
          children: [
        
            Expanded(
              flex: _size.width > 1340 ? 1 : 4,
              child: SideBar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: GoodsDetails(itemDetails),
            ),
            
          ],
        ),
      ),
    );
  }
}
