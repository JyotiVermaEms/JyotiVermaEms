import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Shipment/getShipmentConfirmOrderModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import '../../../component/Accountant/Dashboad/Dashboard.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AccountantOrderRecieved extends StatefulWidget {
  const AccountantOrderRecieved({Key? key}) : super(key: key);

  @override
  _AccountantOrderRecievedState createState() =>
      _AccountantOrderRecievedState();
}

class _AccountantOrderRecievedState extends State<AccountantOrderRecieved> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  TextEditingController datefilter = new TextEditingController();
  List<ConfirmOrder>? brdata;
  String? bookingId;
  var id;

  DateTime initialDate = DateTime.now();
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;
      });
    builder:
    (context, child) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 100,
              width: 100,
              child: child,
            ),
          ),
        ],
      );
    };
  }

  acceptedOrder() async {
    var Data = {"booking_id": id.toString(), "status": "1"};
    var response = await Providers().getAcceptedOrder(Data);
    if (response.status == true) {
      // setState(() {
      //   MaterialPageRoute(builder: (context) => Order());
      // });
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AAccountantDashboard())),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  var accountantToken;
  getCnfirmbookings() async {
    var response = await Providers().getshipmentconfirmBookings();

    setState(() {
      brdata = response.data;
    });
    for (int i = 0; i < brdata!.length; i++) {
      bookingId = brdata![i].id.toString();
    }

    print(brdata);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCnfirmbookings();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: AccountantSideBar(),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffF5F6F8),
            child: SafeArea(
                right: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          if (!Responsive.isDesktop(context))
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                          if (Responsive.isDesktop(context)) SizedBox(width: 5),
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Order',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                // // Spacer(),
                                // if (Responsive.isDesktop(context))
                                // topBar()
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isDesktop(context))
                      Column(
                        children: [topBar()],
                      ),
                    if (Responsive.isDesktop(context)) order()
                  ],
                ))),
      ),
    );
  }

  Widget topBar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 3),
            height: 48,
            width: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.white, // set border color
                  width: 2.0), // set border width
              borderRadius: BorderRadius.all(
                  Radius.circular(10.0)), // set rounded corner radius
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: TextFormField(
                onFieldSubmitted: (value) {
                  // searchfunction();
                },
                // controller: edit,
                decoration: InputDecoration(
                  // prefixIcon: IconButton(
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: Colors.grey,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       searchfunction();
                  //     });

                  //   },
                  // ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // setState(() {
                      //   edit.clear();
                      //   searchDataresponse.removeLast();
                      //   // Widget build(BuildContext context)
                      //   // searchfunction();
                      //   MaterialPageRoute(
                      //       builder: (context) => bookingDesktopCard());
                      // });
                    },
                  ),
                  hintText: "Search Here",
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                autofocus: true,
                onChanged: (val) {
                  // title = val;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: (Responsive.isDesktop(context))
                ? 136
                : MediaQuery.of(context).size.width * (40 / 100),
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.teal, width: 2.0)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (DateFormat.yMd().format(initialDate).toString()),
                    style: headingStyle12blacknormal(),
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate1(context);
                      datefilter.text =
                          (DateFormat.yMd().format(initialDate).toString());
                    },
                    child: Container(
                      // margin: EdgeInsets.only(left: 45, top: 5),
                      height: 20,
                      width: 20,
                      child: ImageIcon(
                        AssetImage(
                          "images/menu-board.png",
                        ),
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget order() {
    return ListView.builder(
        itemCount: brdata!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return brdata!.length == 0
              ? Container(
                  height: 200,
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 1,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: linearGradientForWhiteCard(),
                      child: Column(
                        children: [
                          // Image.asset(
                          //   'assets/images/applogo.png',
                          //   height:
                          //       MediaQuery.of(context).size.height * 0.10,
                          // ),
                          SizedBox(height: 15),
                          Text(
                            'Sorry, You have not any Bookings yet',
                            style: headingStyle16MB(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  // height: 80,
                  width: w,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 0.5, color: Color(0xffACACAC)),
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE5E5E5),
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: 15, top: 10),
                                    width: 200,
                                    child: Text(
                                      "Orders placed",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 15, top: 10, bottom: 10),
                                    width: 200,
                                    child: Text(
                                      brdata![index].createdAt.substring(0, 10),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Column(
                              children: [
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Total",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 200,
                                    child: Text(
                                      brdata![index].totalAmount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Container(
                                    width: 400,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Ship To",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    width: 400,
                                    child: Text(
                                      brdata![index].to.toLowerCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            Spacer(),

                            Column(
                              children: [
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(right: 0, top: 10),
                                    child: Text(
                                      "Order ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    width: 200,
                                    margin: EdgeInsets.only(
                                        right: 0, top: 10, bottom: 10),
                                    child: Text(
                                      brdata![index].id.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                                height: 250,
                                width: 300,
                                decoration: BoxDecoration(
                                  // border: Border.all(

                                  //     width: 0.5, color: Color(0xffACACAC)),
                                  // borderRadius: BorderRadius.circular(0.0),
                                  color: Color(0xffFFFFFF),
                                ),
                                margin: EdgeInsets.only(
                                    top: 10, right: 10, left: 10),
                                child: Image.asset(
                                  'assets/images/Cars.png',
                                  fit: BoxFit.cover,
                                )),
                            secondRow(index),
                            Spacer(),
                            thirdRow(index),
                          ],
                        ),
                      ),
                      Container(
                          height: 80,
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Color(0xffACACAC)),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffE5E5E5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  width: 200,
                                  child: Text(
                                    "Estimated Delivery:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  width: 200,
                                  child: Text(
                                    brdata![index].arrivalDate,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          )),
                    ],
                  ),
                );
        });
  }

  Widget secondRow(int index) {
    return Container(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    brdata![index].title,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              Container(
                  height: 40,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color(0xffE6E7E8)),
                  margin: EdgeInsets.only(left: 15, top: 15),
                  child: Center(
                    child: Text(
                      brdata![index].bookingDate.toString(),
                      style: TextStyle(
                          color: Color(0xff1A494F),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              // Spacer(),
              //
            ],
          ),
          Container(
            // height: 300,
            width: 400,
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: brdata![index].bookingItem.length,
                shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // mainAxisSpacing: 0.01,
                  // crossAxisSpacing: 0.01,
                  // childAspectRatio: 0.1
                ),
                itemBuilder: (context, index1) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Container(
                          //     margin: EdgeInsets.only(top: 10),
                          //     height: 15,
                          //     width: 15,
                          //     child: Image.network(
                          //         brdata![index].bookingItem[index1].icon)),
                          Container(
                              margin: EdgeInsets.only(left: 5, top: 20),
                              child: Text(
                                  brdata![index].bookingItem[index1].category)),
                          Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.only(left: 10, top: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color(0xffEFEFEF)),
                              child: Center(
                                  child: Text(brdata![index]
                                      .bookingItem[index1]
                                      .quantity
                                      .toString()))),
                        ]),
                  );
                }),
          ),
          for (int i = 0; i < brdata![index].bookingItem.length; i++)
            Container(
                width: 400,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  brdata![index].bookingItem[i].description,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                )),
        ],
      ),
    );
  }

  Widget thirdRow(int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              id = brdata![index].id.toString();
            });
            print("kkkkkkkkkkkkkkkkkk" + id);
            acceptedOrder();
          },
          child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Color(0xff1A494F)),
              margin: EdgeInsets.only(left: 15, top: 15, right: 15),
              child: Center(
                child: Text(
                  "Accept",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        Container(
            height: 40,
            width: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                border: Border.all(width: 0.5, color: Color(0xffACACAC)),
                color: Color(0xffFFFFFF)),
            margin: EdgeInsets.only(left: 15, top: 15, right: 15),
            child: Center(
              child: Text(
                "Reject",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )),
      ],
    );
  }
}
