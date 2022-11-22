import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depatureDashboardModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturesearchtitlesssModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depauterStatsdashboardModel.dart';

import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Dashboard.dart';

import 'package:shipment/component/Departure%20Manager/Dashboard/res_dashboard_clientbooking.dart';
import 'package:shipment/component/Departure%20Manager/DepartureSidebar.dart';
import 'package:shipment/pages/Departure%20Manager/Notification/departureNotification.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

class DepartureDashboard extends StatefulWidget {
  const DepartureDashboard({Key? key}) : super(key: key);

  @override
  _DepartureDashboardState createState() => _DepartureDashboardState();
}

class _DepartureDashboardState extends State<DepartureDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = TextEditingController();
  TextEditingController edit = new TextEditingController();
  late AnimationController _controller;
  var h, w;
  var tShip, pShip, cShip, inShip, totalclient, packedship;

  // List<SearchData> searchDataresponse = [];
  var id = [];
  var cate = [];
  var avail = [];
  String filter = 'All';
  List<SearchD> searchDataresponse = [];
  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];

  var Iamhovering = -1;
  bool selected = true;
  List<DashboardData> depData = [];
  List<DStatsData>? dstDta;

  int? count;
  var dropdown;
  bool isProcess = false;

  void _entering(
    PointerEvent details,
    index,
  ) {
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

  void _hovering(
    PointerEvent details,
    index,
  ) {
    setState(() {
      Iamhovering = index;
    });
  }

  Widget _buildLoadingTwo() {
    return Stack(alignment: Alignment.center, children: [
      Image.network(
        'https://cdn.jsdelivr.net/gh/xdd666t/MyData@master/pic/flutter/blog/20211101162946.png',
        height: 50,
        width: 50,
      ),
      RotationTransition(
        alignment: Alignment.center,
        turns: _controller,
        child: Image.network(
          'https://cdn.jsdelivr.net/gh/xdd666t/MyData@master/pic/flutter/blog/20211101173708.png',
          height: 80,
          width: 80,
        ),
      ),
    ]);
  }

  searchfunction() async {
    var searchData = {
      "title": edit.text == null ? "" : edit.text.toString(),
      "stats": ""
    };

    final response = await Providers().searchDepatureManager(searchData);
    if (response.status == true) {
      setState(() {
        searchDataresponse = response.data;
        MaterialPageRoute(builder: (context) => shipmentList2());
      });
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  searchfunction1() async {
    var searchData = {"title": "", "stats": filter.toString()};

    final response = await Providers().searchDepatureManager(searchData);
    if (response.status == true) {
      setState(() {
        searchDataresponse = response.data;
        MaterialPageRoute(builder: (context) => shipmentList2());
      });
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

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

  Widget totalShipment() {
    return Padding(
      padding: (Responsive.isDesktop(context))
          ? const EdgeInsets.all(20.0)
          : const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: Container(
        height: (Responsive.isDesktop(context))
            ? 180
            : MediaQuery.of(context).size.height * (20 / 100),
        width: (Responsive.isDesktop(context))
            ? 300
            : MediaQuery.of(context).size.height * (35 / 100),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "totalshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "shipments".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 21 : 17),
                    // style: headingStyleinter14blackw500(),
                  ),
                  Text(
                    (tShip.toString()),
                    style: (Responsive.isDesktop(context))
                        ? headingStyleinter40blackw500()
                        : headingStyleinter14blackw500(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  getStatus() async {
    var response = await Providers().getdepaturehboardStatus();

    if (response.status == true) {
      setState(() {
        dstDta = response.data;
      });
      for (int i = 0; i < dstDta!.length; i++) {
        tShip = dstDta![i].totalSchedules;
        pShip = dstDta![i].openSchedules;
        cShip = dstDta![i].closedSchedules;
        inShip = dstDta![i].inprogressSchedules;
        packedship = dstDta![i].packedSchedules;
        totalclient = dstDta![i].totalClient;
      }
      print(dstDta);
    } else {
      print("-=-=-=");
      setState(() {
        tShip = 0;
        pShip = 0;
        cShip = 0;
        inShip = 0;
        packedship = 0;
        totalclient = 0;
      });
    }
  }

  var status;

  getShipmentList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getDepartureDashboard();

    if (response.status == true) {
      setState(() {
        depData = response.data;
      });
      for (int i = 0; i < depData.length; i++) {
        id.add(depData[i].id.toString());
        for (int k = 0; k < depData[i].bookings.length; k++) {
          status = depData[i].bookings[k].status;
        }
        for (int j = i; j < depData[i].itemType.length; j++) {
          // cate.add(depData[i].available[j].category);
          // avail.add(depData[i].available[j].available);
        }
      }
    }
    print("available hkhjhj" + status.toString());
    setState(() {
      isProcess = false;
    });
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('depature_token');
    print("Token $authToken");
    var response =
        await Providers().getShipmentSubPanelNotificationCount(authToken);

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
  }

  Widget topBar() {
    return (Responsive.isDesktop(context))
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 0, top: 3, left: 30),
                height: 48,
                width: 400,
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
                      searchfunction();
                    },
                    controller: edit,
                    decoration: InputDecoration(
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            searchfunction();
                          });
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            shipmentList2();
                            searchDataresponse = [];
                            edit.clear();
                            searchDataresponse.removeLast();

                            // Widget build(BuildContext context)
                            // searchfunction();
                            // MaterialPageRoute(builder: (context) => shipmentList());
                          });
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
              SizedBox(
                width: w * 0.2,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DropdownButton<String>(
                        hint: Text("chooselanguage".tr()),
                        value: dropdownvalue,
                        dropdownColor: Colors.white,
                        focusColor: Colors.white,
                        // Down Arrow Icon

                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                          if (dropdownvalue == "English") {
                            context.locale = Locale("en", "US");
                          } else if (dropdownvalue == "French") {
                            context.locale = Locale("fr", "FR");
                          } else if (dropdownvalue == "Spanish") {
                            context.locale = Locale("es", "US");
                          }
                        },
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                // color: Colors.amber,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DepartureNotificationScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.notifications,
                          size: 38,
                        ),
                      ),
                      count != null
                          ? Positioned(
                              left: 15,
                              top: 4,
                              right: 0,
                              child: Icon(Icons.fiber_manual_record,
                                  color: Colors.red, size: 12),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 3, left: 10),
                height: 48,
                width: MediaQuery.of(context).size.width * 0.50,
                padding: const EdgeInsets.only(
                  right: 0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.white, // set border color
                      width: 2.0), // set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0)), // set rounded corner radius
                ),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    searchfunction();
                  },
                  controller: edit,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          searchfunction();
                        });
                      },
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          shipmentList2();
                          searchDataresponse = [];
                          edit.clear();
                          searchDataresponse.removeLast();

                          // Widget build(BuildContext context)
                          // searchfunction();
                          // MaterialPageRoute(builder: (context) => shipmentList());
                        });
                      },
                    ),
                    hintText: "searchhere".tr(),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black),
                  autofocus: true,
                  onChanged: (val) {
                    // title = val;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, left: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      DropdownButton<String>(
                        hint: Text("chooselanguage".tr()),
                        value: dropdownvalue,
                        dropdownColor: Colors.white,
                        focusColor: Colors.white,
                        // Down Arrow Icon

                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 30,
                        elevation: 16,
                        style: TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                          if (dropdownvalue == "English") {
                            context.locale = Locale("en", "US");
                          } else if (dropdownvalue == "French") {
                            context.locale = Locale("fr", "FR");
                          } else if (dropdownvalue == "Spanish") {
                            context.locale = Locale("es", "US");
                          }
                        },
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 180
          : MediaQuery.of(context).size.height * (21 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (35 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: Text(
                "shipmentstatus".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "openshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  pShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "inprogresshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  inShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "packedshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                ),
                Text(
                  packedship.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "closedshipment".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                ),
                Text(
                  cShip.toString(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget ContainerListDialog({required int index, depData}) {
    return Container(
      height: h * 0.42,
      width: w * 0.38,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Icon(
                  Icons.close,
                  color: Color(0xffC4C4C4),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "availability".tr(),
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: depData[index].available.length,
              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3 / 1,
                  crossAxisSpacing: 0.1,
                  childAspectRatio: (7 / 1)),
              itemBuilder: (context, index1) {
                return Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            left: (Responsive.isDesktop(context)) ? 10 : 0,
                            top: 5),
                        height: 15,
                        width: 15,
                        child: Image.network(
                            "${depData[index].available[index1].icon}")),
                    // Spacer(),
                    Container(
                        width: (Responsive.isDesktop(context))
                            ? 100
                            : MediaQuery.of(context).size.width * 0.19,
                        // margin: EdgeInsets.only(left: 10, top: 5),
                        child: Text(depData[index]
                            .available[index1]
                            .category
                            .toString())),
                    // Spacer(),
                    Container(
                        margin: EdgeInsets.only(
                            left: (Responsive.isDesktop(context)) ? 10 : 0,
                            top: (Responsive.isDesktop(context)) ? 5 : 0),
                        // decoration: BoxDecoration(
                        //     borderRadius:
                        //         BorderRadius.circular(50.0),
                        //     color: Color(0xffEFEFEF)),
                        child: Text(depData[index]
                            .available[index1]
                            .available
                            .toString())),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Widget estimateCharges() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 10),
      height: (Responsive.isDesktop(context))
          ? 180
          : MediaQuery.of(context).size.height * (21 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (30 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("totalclients".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                      fontWeight: FontWeight.bold)
                  // style: headingStyleinter14blackw500(),
                  ),
            ),
          ),
          // Text(
          //   "Clients",
          //   style: TextStyle(fontSize: 21),
          //   // style: headingStyleinter14blackw500(),
          // ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "clients".tr(),
                  style: TextStyle(
                      fontSize: (Responsive.isDesktop(context)) ? 21 : 17),
                  // style: headingStyleinter14blackw500(),
                ),
                Text(
                  totalclient.toString(),
                  style: (Responsive.isDesktop(context))
                      ? headingStyleinter40blackw500()
                      : headingStyleinter14blackw500(),
                ),
                // Container(
                //   height: 16.5,
                //   width: 20,
                //   child: Icon(
                //     Icons.arrow_drop_up_rounded,
                //     color: Color(0xff1A494F),
                //     size: 30,
                //   ),
                // ),
              ],
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: Text(
          //     totalclient.toString(),
          //     style: (Responsive.isDesktop(context))
          //         ? headingStyleinter40blackw500()
          //         : headingStyleinter14blackw500(),
          //   ),
          // )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getShipmentList();
    getNotificationCount();
    getStatus();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: DepartureSidebar(),
      ),
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              color: Color(0xffE5E5E5),
              child: SafeArea(
                  right: false,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(

                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: kDefaultPadding
                            ),
                        child: Row(
                          children: [
                            if (!Responsive.isDesktop(context))
                              IconButton(
                                icon: Icon(Icons.menu),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                            Container(
                              margin: (Responsive.isDesktop(context))
                                  ? EdgeInsets.fromLTRB(20, 10, 5, 0)
                                  : EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text(
                                'dashboard'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (!Responsive.isDesktop(context))
                              Container(
                                margin: EdgeInsets.fromLTRB(160, 0, 0, 0),
                                // color: Colors.amber,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DepartureNotificationScreen()),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        child: Icon(
                                          Icons.notifications,
                                          size: 27,
                                        ),
                                      ),
                                      count != null
                                          ? Positioned(
                                              top: 7,
                                              left: 20,
                                              right: 0,
                                              child: Icon(
                                                  Icons.fiber_manual_record,
                                                  color: Colors.red,
                                                  size: 12),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                            if (Responsive.isDesktop(context)) topBar(),
                          ],
                        ),
                      ),
                      if (!Responsive.isDesktop(context))
                        Column(
                          children: [
                            Row(
                              children: [
                                topBar(),
                              ],
                            ),
                            Container(
                              height: 200,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  totalShipment(),
                                  usedMode(),
                                  estimateCharges(),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Column(
                                children: [
                                  // shipmentList(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "shipmentlist".tr(),
                                              style: headingStyle22blackw600(),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.white),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          side: BorderSide(
                                                              color:
                                                                  Colors.teal,
                                                              width: 2.0)))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  DropdownButton<String>(
                                                    hint: Text(
                                                        "selectstatus".tr()),
                                                    value: filter,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 30,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        filter = newValue!;
                                                      });
                                                      if (filter == "All") {
                                                        searchDataresponse = [];
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                shipmentList());
                                                      } else {
                                                        searchfunction1();
                                                      }
                                                    },
                                                    items: <String>[
                                                      'All',
                                                      'Open',
                                                      'InProgress',
                                                      'Packed',
                                                      'closed'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            mobileViewlist()
                          ],
                        ),
                      if (Responsive.isDesktop(context))
                        Column(
                          children: [
                            Row(
                              children: [
                                totalShipment(),
                                usedMode(),
                                estimateCharges(),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "shipmentlist".tr(),
                                        style: headingStyle22blackw600(),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                        color: Colors.teal,
                                                        width: 2.0)))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            DropdownButton<String>(
                                              hint: Text("selectstatus".tr()),
                                              value: filter,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 30,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  filter = newValue!;
                                                });
                                                if (filter == "All") {
                                                  searchDataresponse = [];
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          shipmentList());
                                                } else {
                                                  searchfunction1();
                                                }
                                              },
                                              items: <String>[
                                                'All',
                                                'Open',
                                                'InProgress',
                                                'Packed',
                                                'closed'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // topBar()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            shipmentList2()
                          ],
                        )
                    ],
                  ))),
    );
  }

  Widget shipmentList() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            "shipmentlist".tr(),
            style: (Responsive.isDesktop(context))
                ? headingStyleinter40blackw500()
                : headingStyleinter14blackw500(),
          ),
        ),
        (Responsive.isDesktop(context))
            ? SizedBox(
                width: 30,
              )
            : Spacer(),
        Container(
          margin: EdgeInsets.only(right: 15),
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.teal, width: 2.0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'selectstatus'.tr(),
                  style: headingStyle14blackw400(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        "images/setting-3.png",
                      ),
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                // topBar()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget scheduleStatus() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xff1A494F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.teal, width: 2.0)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'scheduleshipment'.tr(),
                  style: headingStyleinter14whitew500(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 20,
                    width: 20,
                    child: ImageIcon(
                      AssetImage(
                        "images/Vector1.png",
                      ),
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          (Responsive.isDesktop(context))
              ? SizedBox(
                  width: 30,
                )
              : Spacer(),
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return depData.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? depData.length
                : searchDataresponse.length,
            reverse: false,
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
                    child: InkWell(
                      onTap: () {
                        if (depData[index].bookings.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        "No Bookings are Available in this Schedule"),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      child: Text("Close"),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        } else {
                          print(
                              "<<<<<<<<<<<<<<<< ${depData[index].bookings.length}");

                          var data = {
                            'bookinglength': depData[index].bookings,
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'itemimage1': depData[index].bookings,
                            // 'itemdetail': depData[index]..bookings[0].booking[0].itemImage,
                            'itemimage': depData[index].bookings,
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'transactionid': depData[index]
                                  .bookings[i]
                                  .transactionId
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'totalamount': depData[index]
                                  .bookings[i]
                                  .totalAmount
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuptype': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupType
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuplocation': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupLocation
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupdate': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupDate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuptime': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupTime
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupdistance': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupDistance
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupestimate': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupEstimate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'name': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistName
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'email': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistEmail
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'phone': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistPhone
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'address': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistAddress
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'country': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistCountry
                                  .toString(),
                            'id': depData[index].id.toString(),
                            'title': depData[index].title.toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'bookingdate': depData[index]
                                  .bookings[i]
                                  .bookingDate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'arrivaldate': depData[index]
                                  .bookings[i]
                                  .arrivalDate
                                  .toString(),
                            'depaturedate':
                                depData[index].departureDate.toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'type': depData[index]
                                  .bookings[i]
                                  .bookingType
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'shipcmpany': depData[index]
                                  .bookings[i]
                                  .shipmentCompany
                                  .toString(),
                            'shipmentStatus':
                                depData[index].status.toLowerCase(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupagent_id': depData[index]
                                  .bookings[i]
                                  .pickupagentId
                                  .toString(),
                          };
                          print("=========== ${data['depatureitemimage']}");
                          print("=========== ${data['depaturecomment']}");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResDashboardDepature(data)));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 0, right: 0, top: 15, bottom: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
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
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 100,
                                        child: Text(searchDataresponse.length ==
                                                0
                                            ? depData[index].title.toString()
                                            : searchDataresponse[index]
                                                .title
                                                .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: Text(
                                        depData[index].shipmentType.toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        var data = {
                                          'bookinglength':
                                              depData[index].bookings,
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'itemimage1':
                                                depData[index].bookings,
                                          // 'itemdetail': depData[index]..bookings[0].booking[0].itemImage,
                                          'itemimage': depData[index].bookings,
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'transactionid': depData[index]
                                                .bookings[i]
                                                .transactionId
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'totalamount': depData[index]
                                                .bookings[i]
                                                .totalAmount
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickuptype': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupType
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickuplocation': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupLocation
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickupdate': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupDate
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickuptime': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupTime
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickupdistance': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupDistance
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickupestimate': depData[index]
                                                .bookings[i]
                                                .pickupReview[0]
                                                .pickupEstimate
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'name': depData[index]
                                                .bookings[i]
                                                .receptionistInfo[0]
                                                .receptionistName
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'email': depData[index]
                                                .bookings[i]
                                                .receptionistInfo[0]
                                                .receptionistEmail
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'phone': depData[index]
                                                .bookings[i]
                                                .receptionistInfo[0]
                                                .receptionistPhone
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'address': depData[index]
                                                .bookings[i]
                                                .receptionistInfo[0]
                                                .receptionistAddress
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'country': depData[index]
                                                .bookings[i]
                                                .receptionistInfo[0]
                                                .receptionistCountry
                                                .toString(),
                                          'id': depData[index].id.toString(),
                                          'title':
                                              depData[index].title.toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'bookingdate': depData[index]
                                                .bookings[i]
                                                .bookingDate
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'arrivaldate': depData[index]
                                                .bookings[i]
                                                .arrivalDate
                                                .toString(),
                                          'depaturedate': depData[index]
                                              .departureDate
                                              .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'type': depData[index]
                                                .bookings[i]
                                                .bookingType
                                                .toString(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'shipcmpany': depData[index]
                                                .bookings[i]
                                                .shipmentCompany
                                                .toString(),
                                          'shipmentStatus': depData[index]
                                              .status
                                              .toLowerCase(),
                                          for (int i = 0;
                                              i <
                                                  depData[index]
                                                      .bookings
                                                      .length;
                                              i++)
                                            'pickupagent_id': depData[index]
                                                .bookings[i]
                                                .pickupagentId
                                                .toString(),

                                          // for (int i = 0;
                                          //     i < depData[index].bookings.length;
                                          //     i++)
                                          //   'bookingstatus': depData[index].bookings[i].status
                                        };
                                        print(
                                            "=========== ${data['depatureitemimage']}");
                                        print(
                                            "=========== ${data['depaturecomment']}");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ResDashboardDepature(
                                                        data)));
                                      },
                                      icon: Icon(Icons.arrow_drop_down_rounded,
                                          size: 35,
                                          color: Iamhovering == index
                                              ? Color(0xff1A494F)
                                              : Color(0xffE5E5E5)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(depData[index].from +
                                      " To " +
                                      depData[index].to),
                                ),
                                Container(
                                  height: 30,
                                  width: 100,
                                  color: searchDataresponse.length > 0
                                      ? searchDataresponse[index].status ==
                                              "Closed"
                                          ? Color(0xffFF3D00)
                                          : searchDataresponse[index].status ==
                                                  "Packed"
                                              ? Colors.blue
                                              : searchDataresponse[index]
                                                          .status ==
                                                      "Open"
                                                  ? Colors.green
                                                  : searchDataresponse[index]
                                                              .status ==
                                                          "InProgress"
                                                      ? Colors.orangeAccent
                                                      : Colors.orangeAccent
                                      : depData[index].status == "Closed"
                                          ? Color(0xffFF3D00)
                                          : depData[index].status == "Packed"
                                              ? Colors.blue
                                              : depData[index].status == "Open"
                                                  ? Colors.green
                                                  : depData[index].status ==
                                                          "InProgress"
                                                      ? Colors.orangeAccent
                                                      : Colors.orangeAccent,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? depData[index].status
                                          : searchDataresponse[index].status,
                                      overflow: TextOverflow.ellipsis,
                                      style: headingStyle12whitew500(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: InkWell(
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Color(0xffC4C4C4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container(
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
                    SizedBox(height: 15),
                    Text(
                      'sorryouhavenotscheduleanyshipmentyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget shipmentList2() {
    return depData.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? depData.length
                : searchDataresponse.length,
            reverse: false,
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
                    child: InkWell(
                      onTap: () {
                        if (depData[index].bookings.isEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        "nobookingsareavailableinthisschedule"
                                            .tr()),
                                  ),
                                  actions: <Widget>[
                                    InkWell(
                                      child: Text("Close"),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        } else {
                          print(
                              "<<<<<<<<<<<<<<<< ${depData[index].bookings.length}");

                          var data = {
                            'bookinglength': depData[index].bookings,
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'itemimage1': depData[index].bookings,
                            'itemimage': depData[index].bookings,
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'transactionid': depData[index]
                                  .bookings[i]
                                  .transactionId
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'totalamount': depData[index]
                                  .bookings[i]
                                  .totalAmount
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuptype': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupType
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuplocation': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupLocation
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupdate': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupDate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickuptime': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupTime
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupdistance': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupDistance
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupestimate': depData[index]
                                  .bookings[i]
                                  .pickupReview[0]
                                  .pickupEstimate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'name': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistName
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'email': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistEmail
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'phone': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistPhone
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'address': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistAddress
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'country': depData[index]
                                  .bookings[i]
                                  .receptionistInfo[0]
                                  .receptionistCountry
                                  .toString(),
                            'id': depData[index].id.toString(),
                            'title': depData[index].title.toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'bookingdate': depData[index]
                                  .bookings[i]
                                  .bookingDate
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'arrivaldate': depData[index]
                                  .bookings[i]
                                  .arrivalDate
                                  .toString(),
                            'depaturedate':
                                depData[index].departureDate.toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'type': depData[index]
                                  .bookings[i]
                                  .bookingType
                                  .toString(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'shipcmpany': depData[index]
                                  .bookings[i]
                                  .shipmentCompany
                                  .toString(),
                            'shipmentStatus':
                                depData[index].status.toLowerCase(),
                            for (int i = 0;
                                i < depData[index].bookings.length;
                                i++)
                              'pickupagent_id': depData[index]
                                  .bookings[i]
                                  .pickupagentId
                                  .toString(),
                          };
                          print("=========== ${data['depatureitemimage']}");
                          print("=========== ${data['depaturecomment']}");

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ResDashboardDepature(data)));
                        }
                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 100,
                                  child: Text(searchDataresponse.length == 0
                                      ? depData[index].title.toString()
                                      : searchDataresponse[index]
                                          .title
                                          .toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 180,
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 120,
                                      child: Text(
                                        depData[index].shipmentType.toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                width: 200,
                                child: Text(depData[index].from +
                                    " To " +
                                    depData[index].to),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 10),
                              child: Container(
                                height: 30,
                                width: 100,
                                color: searchDataresponse.length > 0
                                    ? searchDataresponse[index].status ==
                                            "Closed"
                                        ? Color(0xffFF3D00)
                                        : searchDataresponse[index].status ==
                                                "Packed"
                                            ? Colors.blue
                                            : searchDataresponse[index]
                                                        .status ==
                                                    "Open"
                                                ? Colors.green
                                                : searchDataresponse[index]
                                                            .status ==
                                                        "InProgress"
                                                    ? Colors.orangeAccent
                                                    : Colors.orangeAccent
                                    : depData[index].status == "Closed"
                                        ? Color(0xffFF3D00)
                                        : depData[index].status == "Packed"
                                            ? Colors.blue
                                            : depData[index].status == "Open"
                                                ? Colors.green
                                                : depData[index].status ==
                                                        "InProgress"
                                                    ? Colors.orangeAccent
                                                    : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? depData[index].status
                                        : searchDataresponse[index].status,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle12whitew500(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                // onTap: () {
                                //   var data = {
                                //     "id": id[index],
                                //   };
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               ResContainerList(data
                                //                   // Id: id.toString(),
                                //                   )));
                                // },
                                child: Icon(
                                  Icons.more_vert,
                                  color: Color(0xffC4C4C4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
        : Container(
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
                      'sorryouhavenotscheduleanyshipmentyet'.tr(),
                      style: headingStyle16MB(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
