import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Accountant/Dashboard/ClientInfo/clientInfo.dart';
import 'package:shipment/pages/Accountant/Dashboard/ClientInfo/orderlist.dart';
import 'package:shipment/pages/Departure%20Manager/Dashboard/depatureInfo.dart';
import 'package:shipment/pages/Departure%20Manager/Dashboard/depaturedetails.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class DepartureContainerList extends StatefulWidget {
  var data;

  DepartureContainerList(this.data);
  @override
  _DepartureContainerListState createState() => _DepartureContainerListState();
}

class _DepartureContainerListState extends State<DepartureContainerList>
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
    print("kkkkkkkkkkkkkk" + widget.data.toString());

    // setState(() {
    //   id = widget.data['id'].toString();
    //   print('>>>>>   $id');
    //   clientbookingsApi();
    // });
    // print('>>>>>   $id');
    // clientbookingsApi();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
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
    var data = widget.data;
    // print("dsnsdgs" + widget.data['id']);
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: DepartureSidebar(),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: Color(0xffE5E5E5),
            child: SafeArea(
                right: false,
                child: Padding(
                  padding: (Responsive.isDesktop(context))
                      ? const EdgeInsets.symmetric(horizontal: kDefaultPadding)
                      : const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(children: [
                    Row(
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
                          margin: (Responsive.isDesktop(context))
                              ? EdgeInsets.fromLTRB(5, 10, 50, 0)
                              : EdgeInsets.fromLTRB(5, 5, 50, 0),
                          child: Text(
                            'Dashboard > Container',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    (Responsive.isDesktop(context)) ? 22 : 18,
                                fontWeight: FontWeight.bold),
                          ),
                          // Spacer(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 590,
                          height: 50,
                          child: DefaultTabController(
                            initialIndex: 0,
                            length: 3,
                            child: TabBar(
                              controller: tabController,
                              labelColor: Color(0xff1A494F),
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color(0xff1A494F),
                              tabs: <Widget>[
                                Container(
                                  width: 200,
                                  child: new Tab(
                                    child: Text(
                                      "Booking Details",
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: new Tab(
                                    child: Text(
                                      "Pickup / Dropoff Details",
                                    ),
                                  ),
                                ),
                                new Tab(
                                  child: Container(
                                    width: 200,
                                    child: Text(
                                      "Receptionist Info",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      height: h * 0.78,
                      width:
                          (Responsive.isDesktop(context)) ? w * 0.78 : w * 1.0,
                      child: TabBarView(controller: tabController, children: [
                        Container(
                          child: DepatureDetails(widget.data),
                        ),
                        Container(
                          child: DepaturePickupDropoffDetails(widget.data),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, left: 7),
                          child: DepatureInfo(data),
                        ),
                      ]),
                    ),
                  ]),
                ))),
      ),
    );
  }

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

class DepaturePickupDropoffDetails extends StatefulWidget {
  var data;
  DepaturePickupDropoffDetails(this.data);

  @override
  _DepaturePickupDropoffDetails createState() =>
      _DepaturePickupDropoffDetails();
}

class _DepaturePickupDropoffDetails
    extends State<DepaturePickupDropoffDetails> {
  var imageList = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data['itemimage1'].length; i++) {
      for (int j = 0; j < widget.data['itemimage1'][i].itemImage.length; j++)
        imageList.add(widget.data['itemimage1'][i].itemImage[j].toString());

      print(":imageList");
      print(imageList);
      // }
    }
  }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return (Responsive.isDesktop(context))
        ? SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 20, 5, 10),
              child: Column(children: [
                SingleChildScrollView(
                  child: Row(
                    children: [
                      Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 90, top: 30),
                          child: Container(
                            child: imageList.length != 0
                                ? CarouselSlider(
                                    options: CarouselOptions(
                                      enableInfiniteScroll: false,
                                      autoPlay: true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                        //print(_currentIndex);
                                      },
                                    ),
                                    items: imageList
                                        .map<Widget>((item) => InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return imageViewDialog(
                                                        context,
                                                        item,
                                                        imageList);
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                  child: Image.network(
                                                    item,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                : Center(
                                    child: Text(
                                    "No Image Available",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            height: 300,
                            width: 350,
                          ),
                        ),
                      ]),
                      SizedBox(
                        width: 40,
                      ),
                      Container(
                          child: Container(
                        // height: 350,
                        child: Column(
                          children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Order Type",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickuptype'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Location",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickuplocation'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Date",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickupdate'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Time",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickuptime'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Distance",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickupdistance'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Estimate",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['pickupestimate'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            // Row(
                            //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 10),
                            //         child: Container(
                            //           width: 120,
                            //           child: Text(
                            //             "Transaction Id",
                            //             style: TextStyle(color: Colors.black),
                            //           ),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(
                            //           top: 10,
                            //         ),
                            //         child: Container(
                            //           height: 40,
                            //           width: 120,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               borderRadius: BorderRadius.circular(15)),
                            //           child: Center(
                            //             child: Text(
                            //               widget.data['transactionid'].toString(),
                            //               style: TextStyle(color: Colors.black),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 10, left: 10),
                            //         child: Container(
                            //           width: 120,
                            //           child: Text(
                            //             "Total Amount",
                            //             style: TextStyle(color: Colors.black),
                            //           ),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(
                            //           top: 10,
                            //         ),
                            //         child: Container(
                            //           height: 40,
                            //           width: 120,
                            //           decoration: BoxDecoration(
                            //               color: Colors.white,
                            //               borderRadius: BorderRadius.circular(15)),
                            //           child: Center(
                            //             child: Text(
                            //               widget.data['totalamount'].toString(),
                            //               style: TextStyle(color: Colors.black),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //     ]),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  width: 120,
                                  child: Text(
                                    "Transaction Id",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                child: Container(
                                  height: 50,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      widget.data['transactionid'].toString(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ))
                    ],
                  ),
                )
              ]),
            ),
          )
        : Container(
            height: h * 0.5,
            margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
            child: ListView(children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Container(
                    child: imageList.length != 0
                        ? CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                                //print(_currentIndex);
                              },
                            ),
                            items: imageList
                                .map<Widget>((item) => InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return imageViewDialog(
                                                context, item, imageList);
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          child: Image.network(
                                            item,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                            "No Image Available",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 310,
                    width: w * 0.8,
                  ),
                ),
              ]),
              SizedBox(
                width: 40,
              ),
              Container(
                  child: Container(
                // height: 350,
                child: Column(
                  children: [
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Order Type",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickuptype'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Location",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickuplocation'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Date",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickupdate'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Time",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickuptime'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Distance",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickupdistance'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Estimate",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              widget.data['pickupestimate'].toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, left: 30),
                        child: Container(
                          width: 90,
                          child: Text(
                            "Transaction Id",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          height: h * 0.06,
                          width: w * 0.50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                widget.data['transactionid'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
              ))
            ]),
          );
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 55,
      width: MediaQuery.of(context).size.width * (95 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 80,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Arrival Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: 100,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "Title",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                "Company",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: 90,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          // Container(
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //   "Shipment Comapny",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          // Spacer(),
          // Container(
          //     width: 100,
          //     margin: EdgeInsets.only(right: 20),
          //     child: Text(
          //       "Company",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //
          //
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
