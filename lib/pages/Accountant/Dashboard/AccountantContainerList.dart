import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';

import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/pages/Accountant/Dashboard/ClientInfo/clientInfo.dart';
import 'package:shipment/pages/Accountant/Dashboard/ClientInfo/orderlist.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AccountantContainerList extends StatefulWidget {
  var data;
  AccountantContainerList(this.data);

  @override
  _AccountantContainerList createState() => _AccountantContainerList();
}

class _AccountantContainerList extends State<AccountantContainerList>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = TextEditingController();
  TextEditingController edit = new TextEditingController();
  var h, w;
  late TabController tabController;
  int _selectedIndex = 1;
  Color CardColor = Color(0xffF7F6FB);
  var Iamhovering = -1;
  String? name, emailId;

  int? index;
  void _entering(PointerEvent details, index) {
    setState(() {
      Iamhovering = index;
    });
  }

  void _hovering(PointerEvent details, index) {
    setState(() {
      Iamhovering = index;
    });
  }

  var statusList = [
    1,
    2,
    3,
    4,
    5,
  ];
  List<DataResponse>? data1 = [];
  String? client, bookingId, bookingdate, scheduleId;
  List<Client>? clientinfo;
  List<Item>? item;

  String? id;

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

  clientbookingsApi() async {
    var data = {"schedule_id": id.toString()};

    var res = await Providers().shipmentClientBooking(data);
    if (res.status == true) {
      setState(() {
        data1 = res.data;
      });
      for (int i = 0; i < data1!.length; i++) {
        clientinfo = data1![i].client;
        item = data1![i].item;
        for (int j = 0; j < item!.length; j++) {
          bookingId = item![j].bookingId.toString();
          scheduleId = item![j].scheduleId.toString();
        }
        for (int l = 0; l < clientinfo!.length; l++) {}

        bookingdate = data1![i].bookingDate.toString();
      }
    }
  }

  Widget container_client() {
    return Container(
      height: h,
      width: w * 0.80,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffFFFFFF).withOpacity(0.6),
                Color(0xffF3F3F3).withOpacity(0.36),
              ],
            ),
            // color: Colors.red,
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 10, top: 10),
                    child: Icon(
                      Icons.close,
                      color: Color(0xffC4C4C4),
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.green,
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: 82,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Image.asset(
                        "assets/images/Profile1.jpeg",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 55),
                            child: Text(
                              clientinfo![0].name,
                              style: headingStyle16blackw600(),
                            ),
                          ),
                          Text(
                            clientinfo![0].email,
                            style: headingStyle12blackw500(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 250,
                    height: 50,
                    child: DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: TabBar(
                        controller: tabController,
                        labelColor: Color(0xff1A494F),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xff1A494F),
                        tabs: <Widget>[
                          Container(
                            width: 100,
                            child: new Tab(
                              child: Text(
                                "Order Details",
                              ),
                            ),
                          ),
                          new Tab(
                            child: Text(
                              "Info",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 350,
                width: w * 0.78,
                child: TabBarView(controller: tabController, children: [
                  Container(
                    child: OrderList(Id: scheduleId.toString()),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 7),
                    child: ClientInfo(id: id.toString()),
                  ),

                  // Container(
                  //   child: History(),
                  // )
                ]),
              ),
            ],
          )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      id = widget.data['id'].toString();
      print('>>>>>   $id');
      clientbookingsApi();
    });
    // print('>>>>>   $id');
    // clientbookingsApi();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    tabController.addListener(() {
      setState(() {
        _selectedIndex = tabController.index;
      });
      print("Selected Index: " + tabController.index.toString());
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
      body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                                'Dashboard > Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),

                              // Padding(
                              //   padding: const EdgeInsets.only(left: 20),
                              //   child: SizedBox(
                              //     width: (Responsive.isDesktop(context))
                              //         ? 136
                              //         : MediaQuery.of(context).size.width *
                              //             (40 / 100),
                              //     height: 48,
                              //     child: Container(
                              //       decoration: BoxDecoration(
                              //         color: Colors.white,
                              //         border: Border.all(
                              //             color:
                              //                 Colors.teal, // set border color
                              //             width: 2.0), // set border width
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(
                              //                 10.0)), // set rounded corner radius
                              //       ),
                              //       child: Padding(
                              //         padding: EdgeInsets.all(10),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: <Widget>[
                              //             Text(
                              //               (DateFormat.yMd()
                              //                   .format(initialDate)
                              //                   .toString()),
                              //               style: headingStyle12blacknormal(),
                              //             ),
                              //             GestureDetector(
                              //               onTap: () {
                              //                 _selectDate1(context);
                              //                 // datefilter.text =
                              //                 //     (DateFormat.yMd().format(initialDate1).toString());
                              //               },
                              //               child: Container(
                              //                 // margin: EdgeInsets.only(left: 45, top: 5),
                              //                 height: 20,
                              //                 width: 20,
                              //                 child: Icon(
                              //                   Icons.calendar_today,
                              //                   color: Colors.black,
                              //                   size: 20,
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // if (Responsive.isDesktop(context)) topBar(widget.ddate)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!Responsive.isDesktop(context))
                    Column(
                      children: [MobileViewlist()],
                    ),
                  if (Responsive.isDesktop(context)) containerList()
                ],
              ))),
    );
  }

  //

  Widget containerList() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: data1!.length,
        //  widget.bId.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: MouseRegion(
                  onEnter: (val) {
                    _entering(val, index);
                  },
                  onHover: (value) {
                    _hovering(value, index);
                  },
                  onExit: (val) {
                    _entering(val, -1);
                  },
                  child: Card(
                    color: Iamhovering == index
                        ? Color(0xffFFFFFF).withOpacity(1)
                        : Color(0xffFFFFFF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  tileMode: TileMode.clamp,
                                  colors: [
                                    Color(0xffFFCC00),
                                    Color(0xffFFDE17),
                                  ],
                                )),
                              ),
                            ),
                            for (int l = 0;
                                l < data1![index].client.length;
                                l++)
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Text(
                                  data1![index].client[l].name,
                                  style: headingStyle16blacknormal(),
                                ),
                              ),
                            // for (int k = 0; k < data1![index].item.length; k++)
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                data1![index].id.toString(),
                                style: headingStyle16blacknormal(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Text(
                                data1![index].bookingDate.toString(),
                                style: headingStyle16blacknormal(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Row(
                                children: [
                                  Text(
                                    "Client list",
                                    style: headingStyle16blackw400(),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierColor: Colors.transparent,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              margin: EdgeInsets.only(
                                                  left: 100,
                                                  // top: 250,
                                                  top: 80),
                                              child: AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: container_client(),
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 35,
                                      color: Color(0xff1A494F),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 80, right: 20),
                              child: Container(
                                height: 22,
                                width: 86,
                                color: Color(0xffFF3D00),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Pending",
                                    style: headingStyle12whitew500(),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  )));
        });
  }

  Widget MobileViewlist() {
    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: MediaQuery.of(context).size.height * (50 / 100),
            width: w,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 15),
                        child: Text(
                          "Container Name",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 15, right: 20),
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Container 1",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      color: Color(0xffFF3D00),
                      width: MediaQuery.of(context).size.width * (20 / 100),
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: Center(
                          child: Text("Pending",
                              style: headingStyle12whitew500())),
                    )
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Client list",
                        style: headingStyle16blackw400(),
                      ),
                      IconButton(
                        onPressed: () {
                          // showDialog(
                          //     barrierColor: Colors.transparent,
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return Container(
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(10))),
                          //         margin: EdgeInsets.only(
                          //             left: 100,
                          //             // top: 250,
                          //             top: 80),
                          //         child: AlertDialog(
                          //           backgroundColor: Colors.white,
                          //           content: container_client(),
                          //         ),
                          //       );
                          //     });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 35,
                          color: Color(0xff1A494F),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/car.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Car",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffEFEFEF),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              height: 31,
                              width: 31,
                              child: Center(
                                child: Text("3",
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      fontSize: 15,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/box.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Boxes",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("6",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/slidervertical.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Barrel",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("12",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: Row(
                          children: [
                            Container(
                              // margin: EdgeInsets.only(left: 45, top: 5),
                              height: 15,
                              width: 15,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/Group 840.png',
                                ),
                                size: 20,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("Tv",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffEFEFEF),
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 31,
                                width: 31,
                                child: Center(
                                  child: Text("6",
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30),
                  child: Row(
                    children: [
                      Container(
                        // margin: EdgeInsets.only(left: 45, top: 5),
                        height: 15,
                        width: 15,
                        child: ImageIcon(
                          AssetImage(
                            'assets/images/bus.png',
                          ),
                          size: 20,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Fridge",
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 15,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffEFEFEF),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          height: 31,
                          width: 31,
                          child: Center(
                            child: Text("12",
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
