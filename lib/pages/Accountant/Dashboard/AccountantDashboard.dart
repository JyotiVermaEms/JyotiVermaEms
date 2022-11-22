import 'package:flutter/material.dart';

import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/component/Accountant/Dashboad/ContainerList.dart';

import '../../../component/Accountant/ScheduleShipment/SchdeuleShipment.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:shipment/Model/Shipment/shipmentSchedulModel.dart';
import 'package:shipment/Model/Shipment/shipmentSearchModel.dart';
import 'package:shipment/Provider/Provider.dart';

class AccountantDashboard extends StatefulWidget {
  const AccountantDashboard({Key? key}) : super(key: key);

  @override
  _AccountantDashboardState createState() => _AccountantDashboardState();
}

class _AccountantDashboardState extends State<AccountantDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController datefilter = TextEditingController();
  TextEditingController edit = new TextEditingController();
  var h, w;

  List<SearchData> searchDataresponse = [];
  var id = [];
  String filter = 'Open';

  var Iamhovering = -1;

  bool selected = true;
  List<Schedule>? scheduleData;
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

  getShipmentList() async {
    var response = await Providers().getschedules();

    if (response.status == true) {
      setState(() {
        scheduleData = response.schedule;
      });
      for (int i = 0; i < scheduleData!.length; i++) {
        id.add(scheduleData![i].id.toString());
      }
    }
  }

  Widget ContainerListDialog({required int index, scheduleData}) {
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
            padding: const EdgeInsets.only(left: 30, top: 10, bottom: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Availability",
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
              itemCount: scheduleData[index].available.length,
              shrinkWrap: true,
              // scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 3 / 1,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: (5 / 1)),
              itemBuilder: (context, index1) {
                return Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        height: 15,
                        width: 15,
                        child: Image.network(
                            "${scheduleData[index].available[index1].icon}")),
                    // Spacer(),
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        child: Text(searchDataresponse.length == 0
                            ? scheduleData[index]
                                .available[index1]
                                .category
                                .toString()
                            : searchDataresponse[index]
                                .itemType[index1]
                                .categoryName
                                .toString())),
                    // Spacer(),
                    Container(
                        margin: EdgeInsets.only(left: 10, top: 5),
                        // decoration: BoxDecoration(
                        //     borderRadius:
                        //         BorderRadius.circular(50.0),
                        //     color: Color(0xffEFEFEF)),
                        child: Text(
                          searchDataresponse.length == 0
                              ? scheduleData[index]
                                  .available[index1]
                                  .available
                                  .toString()
                              : searchDataresponse[index]
                                  .itemType[index1]
                                  .quantity
                                  .toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                );
              }),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: Row(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 30),
          //         child: Row(
          //           children: [
          //             Container(
          //               // margin: EdgeInsets.only(left: 45, top: 5),
          //               height: 15,
          //               width: 15,
          //               child: ImageIcon(
          //                 AssetImage(
          //                   'assets/images/car.png',
          //                 ),
          //                 size: 20,
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Text("Car",
          //                   style: TextStyle(
          //                     decoration: TextDecoration.none,
          //                     color: Colors.black,
          //                     fontSize: 15,
          //                   )),
          //             ),
          //             Container(
          //               decoration: BoxDecoration(
          //                   border: Border.all(
          //                     color: Color(0xffEFEFEF),
          //                   ),
          //                   borderRadius:
          //                       BorderRadius.all(Radius.circular(10))),
          //               height: 31,
          //               width: 31,
          //               child: Center(
          //                 child: Text("3",
          //                     style: TextStyle(
          //                       decoration: TextDecoration.none,
          //                       color: Colors.black,
          //                       fontSize: 15,
          //                     )),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 100),
          //         child: Row(
          //           children: [
          //             Container(
          //               // margin: EdgeInsets.only(left: 45, top: 5),
          //               height: 15,
          //               width: 15,
          //               child: ImageIcon(
          //                 AssetImage(
          //                   'assets/images/box.png',
          //                 ),
          //                 size: 20,
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Text("Boxes",
          //                   style: TextStyle(
          //                     decoration: TextDecoration.none,
          //                     color: Colors.black,
          //                     fontSize: 15,
          //                   )),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     border: Border.all(
          //                       color: Color(0xffEFEFEF),
          //                     ),
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(10))),
          //                 height: 31,
          //                 width: 31,
          //                 child: Center(
          //                   child: Text("6",
          //                       style: TextStyle(
          //                         decoration: TextDecoration.none,
          //                         color: Colors.black,
          //                         fontSize: 15,
          //                       )),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: Row(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 30.0),
          //         child: Row(
          //           children: [
          //             Container(
          //               // margin: EdgeInsets.only(left: 45, top: 5),
          //               height: 15,
          //               width: 15,
          //               child: ImageIcon(
          //                 AssetImage(
          //                   'assets/images/slidervertical.png',
          //                 ),
          //                 size: 20,
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Text("Barrel",
          //                   style: TextStyle(
          //                     decoration: TextDecoration.none,
          //                     color: Colors.black,
          //                     fontSize: 15,
          //                   )),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     border: Border.all(
          //                       color: Color(0xffEFEFEF),
          //                     ),
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(10))),
          //                 height: 31,
          //                 width: 31,
          //                 child: Center(
          //                   child: Text("12",
          //                       style: TextStyle(
          //                         decoration: TextDecoration.none,
          //                         color: Colors.black,
          //                         fontSize: 15,
          //                       )),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 80),
          //         child: Row(
          //           children: [
          //             Container(
          //               // margin: EdgeInsets.only(left: 45, top: 5),
          //               height: 15,
          //               width: 15,
          //               child: ImageIcon(
          //                 AssetImage(
          //                   'assets/images/Group 840.png',
          //                 ),
          //                 size: 20,
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Text("Tv",
          //                   style: TextStyle(
          //                     decoration: TextDecoration.none,
          //                     color: Colors.black,
          //                     fontSize: 15,
          //                   )),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.only(left: 5),
          //               child: Container(
          //                 decoration: BoxDecoration(
          //                     border: Border.all(
          //                       color: Color(0xffEFEFEF),
          //                     ),
          //                     borderRadius:
          //                         BorderRadius.all(Radius.circular(10))),
          //                 height: 31,
          //                 width: 31,
          //                 child: Center(
          //                   child: Text("6",
          //                       style: TextStyle(
          //                         decoration: TextDecoration.none,
          //                         color: Colors.black,
          //                         fontSize: 15,
          //                       )),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, left: 30),
          //   child: Row(
          //     children: [
          //       Container(
          //         // margin: EdgeInsets.only(left: 45, top: 5),
          //         height: 15,
          //         width: 15,
          //         child: ImageIcon(
          //           AssetImage(
          //             'assets/images/bus.png',
          //           ),
          //           size: 20,
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 5),
          //         child: Text("Fridge",
          //             style: TextStyle(
          //               decoration: TextDecoration.none,
          //               color: Colors.black,
          //               fontSize: 15,
          //             )),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 5),
          //         child: Container(
          //           decoration: BoxDecoration(
          //               border: Border.all(
          //                 color: Color(0xffEFEFEF),
          //               ),
          //               borderRadius: BorderRadius.all(Radius.circular(10))),
          //           height: 31,
          //           width: 31,
          //           child: Center(
          //             child: Text("12",
          //                 style: TextStyle(
          //                   decoration: TextDecoration.none,
          //                   color: Colors.black,
          //                   fontSize: 15,
          //                 )),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShipmentList();
    // searchfunction();
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
                        if (Responsive.isDesktop(context)) topBar(),
                        SizedBox(width: 5),
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 10, 5, 0),
                          child: Text(
                            '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!Responsive.isDesktop(context))
                    Column(
                      children: [
                        Row(
                          children: [
                            totalShipment(),
                            usedMode(),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: estimateCharges()),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            children: [
                              shipmentList(),
                              SizedBox(
                                height: 10,
                              ),
                              scheduleStatus()
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            totalShipment(),
                            usedMode(),
                            estimateCharges(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Shipment List",
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
                                                    BorderRadius.circular(10.0),
                                                side: BorderSide(
                                                    color: Colors.teal,
                                                    width: 2.0)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        DropdownButton<String>(
                                          hint: Text("Select Status"),
                                          value: filter,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          // underline: Container(
                                          //   height: 2,
                                          //   color: Colors.black,
                                          // ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              filter = newValue!;
                                            });
                                            searchfunction1();
                                          },

                                          items: <String>[
                                            'Open',
                                            'Not Approved',
                                            'pending',
                                            'closed'
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(left: 20),
                                        //   child: Container(
                                        //     // margin: EdgeInsets.only(left: 45, top: 5),
                                        //     height: 20,
                                        //     width: 20,
                                        //     child: ImageIcon(
                                        //       AssetImage(
                                        //         "images/setting-3.png",
                                        //       ),
                                        //       size: 20,
                                        //       color: Colors.black,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  // topBar()
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xff1A494F)),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ScheduleShipment()));
                                            },
                                            child: Text(
                                              'Schedule Shipment',
                                              style:
                                                  headingStyleinter14whitew500(),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
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
                                    SizedBox(
                                      width: 30,
                                    ),
                                    // ElevatedButton(
                                    //   onPressed: () {},
                                    //   style: ButtonStyle(
                                    //       backgroundColor:
                                    //           MaterialStateProperty.all(
                                    //               Colors.white),
                                    //       shape: MaterialStateProperty.all<
                                    //               RoundedRectangleBorder>(
                                    //           RoundedRectangleBorder(
                                    //               borderRadius:
                                    //                   BorderRadius.circular(
                                    //                       10.0),
                                    //               side: BorderSide(
                                    //                   color: Colors.teal,
                                    //                   width: 2.0)))),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         (DateFormat.yMd()
                                    //             .format(initialDate)
                                    //             .toString()),
                                    //         style: headingStyle12blacknormal(),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           _selectDate1(context);
                                    //           datefilter.text =
                                    //               (DateFormat.yMd()
                                    //                   .format(initialDate)
                                    //                   .toString());
                                    //         },
                                    //         child: Container(
                                    //           // margin: EdgeInsets.only(left: 45, top: 5),
                                    //           height: 20,
                                    //           width: 20,
                                    //           child: ImageIcon(
                                    //             AssetImage(
                                    //               "images/menu-board.png",
                                    //             ),
                                    //             size: 20,
                                    //             color: Colors.black,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        shipmentList2()
                        // scheduleData != null
                        //     ? ListView.builder(
                        //         physics: NeverScrollableScrollPhysics(),
                        //         itemCount: scheduleData != null
                        //             ? scheduleData!.length
                        //             : 0,
                        //         shrinkWrap: true,
                        //         itemBuilder: (context, index) {
                        //           return Padding(
                        //             padding: const EdgeInsets.all(16.0),
                        //             child: InkWell(
                        //               onTap: () => Navigator.push(
                        //                   context,
                        //                   MaterialPageRoute(
                        //                       builder: (context) =>
                        //                           ResContainerList(
                        //                             Id: id.toString(),
                        //                           ))),
                        //               child: MouseRegion(
                        //                 onEnter: (val) {
                        //                   _entering(val, index);
                        //                 },
                        //                 onHover: (value) {
                        //                   _hovering(value, index);
                        //                 },
                        //                 onExit: (val) {
                        //                   _entering(val, -1);
                        //                 },
                        //                 child: Card(
                        //                   color: Iamhovering == index
                        //                       ? Color(0xffFFFFFF).withOpacity(1)
                        //                       : Color(0xffFFFFFF)
                        //                           .withOpacity(0.5),
                        //                   shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10),
                        //                   ),
                        //                   child: Container(
                        //                     child: Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment
                        //                               .spaceBetween,
                        //                       children: [
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 20, right: 20),
                        //                           child: Container(
                        //                             height: 28,
                        //                             width: 28,
                        //                             decoration: BoxDecoration(
                        //                                 gradient:
                        //                                     LinearGradient(
                        //                               begin: Alignment.topLeft,
                        //                               end:
                        //                                   Alignment.bottomRight,
                        //                               tileMode: TileMode.clamp,
                        //                               colors: [
                        //                                 Color(0xffFFCC00),
                        //                                 Color(0xffFFDE17),
                        //                               ],
                        //                             )),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 30),
                        //                           child: InkWell(
                        //                             onTap: () {
                        //                               Navigator.push(
                        //                                   context,
                        //                                   MaterialPageRoute(
                        //                                       builder: (context) =>
                        //                                           ResReviewlist()));
                        //                             },
                        //                             child: Container(
                        //                               width: 100,
                        //                               child: Text(
                        //                                 scheduleData![index]
                        //                                     .title
                        //                                     .toString(),
                        //                                 style:
                        //                                     headingStyle16blackw400(),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                             left: 180,
                        //                           ),
                        //                           child: Row(
                        //                             children: [
                        //                               Align(
                        //                                 alignment:
                        //                                     Alignment.center,
                        //                                 child: Text(
                        //                                   "Container list",
                        //                                   style:
                        //                                       headingStyle16blackw400(),
                        //                                 ),
                        //                               ),
                        //                               IconButton(
                        //                                 onPressed: () {
                        //                                   showDialog(
                        //                                       barrierColor: Colors
                        //                                           .transparent,
                        //                                       context: context,
                        //                                       builder:
                        //                                           (BuildContext
                        //                                               context) {
                        //                                         return Container(
                        //                                           decoration: BoxDecoration(
                        //                                               borderRadius:
                        //                                                   BorderRadius.all(
                        //                                                       Radius.circular(10))),
                        //                                           margin: EdgeInsets.only(
                        //                                               left: 100,
                        //                                               // top: 250,
                        //                                               top: 190),
                        //                                           child:
                        //                                               AlertDialog(
                        //                                             backgroundColor:
                        //                                                 Colors
                        //                                                     .white,
                        //                                             content:
                        //                                                 ContainerListDialog(
                        //                                               scheduleData:
                        //                                                   scheduleData,
                        //                                               index:
                        //                                                   index,
                        //                                             ),
                        //                                           ),
                        //                                         );
                        //                                       });
                        //                                 },
                        //                                 icon: Icon(
                        //                                     Icons
                        //                                         .arrow_drop_down_rounded,
                        //                                     size: 35,
                        //                                     color: Iamhovering ==
                        //                                             index
                        //                                         ? Color(
                        //                                             0xff1A494F)
                        //                                         : Color(
                        //                                             0xffE5E5E5)),
                        //                               )
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 100),
                        //                           child: Text(
                        //                             scheduleData![index].from +
                        //                                 " To " +
                        //                                 scheduleData![index].to,
                        //                             style:
                        //                                 headingStyle16blackw400(),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 130),
                        //                           child: Container(
                        //                             height: 22,
                        //                             width: 86,
                        //                             color: scheduleData![
                        //                                         index] ==
                        //                                     1
                        //                                 ? Color(0xffFF3D00)
                        //                                 : scheduleData![
                        //                                             index] ==
                        //                                         2
                        //                                     ? Colors.blue
                        //                                     : scheduleData![
                        //                                                 index] ==
                        //                                             3
                        //                                         ? Colors.green
                        //                                         : scheduleData![
                        //                                                     index] ==
                        //                                                 4
                        //                                             ? Colors
                        //                                                 .pink
                        //                                             : Colors
                        //                                                 .orangeAccent,
                        //                             child: Align(
                        //                               alignment:
                        //                                   Alignment.center,
                        //                               child: Text(
                        //                                 scheduleData![index]
                        //                                             .status ==
                        //                                         1
                        //                                     ? "Closed"
                        //                                     : scheduleData![index]
                        //                                                 .status ==
                        //                                             2
                        //                                         ? "Deliverd"
                        //                                         : scheduleData![index]
                        //                                                     .status ==
                        //                                                 3
                        //                                             ? "In Transit"
                        //                                             : scheduleData![index].status ==
                        //                                                     4
                        //                                                 ? "Picked up"
                        //                                                 : "Closed",
                        //                                 style:
                        //                                     headingStyle12whitew500(),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         Padding(
                        //                           padding:
                        //                               const EdgeInsets.only(
                        //                                   left: 30),
                        //                           child: Icon(
                        //                             Icons.more_vert,
                        //                             color: Color(0xffC4C4C4),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         })
                        //     : Container(
                        //         child: SizedBox(
                        //         height: 300,
                        //         child: Center(
                        //             child:
                        //                 CircularProgressIndicator.adaptive()),
                        //       )),
                      ],
                    )
                ],
              ))),
    );
  }

  searchfunction() async {
    var searchData = {
      "title": edit.text == null ? "" : edit.text.toString(),
      "stats": ""
    };

    final response = await Providers().searchShipment(searchData);
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

    final response = await Providers().searchShipment(searchData);
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

  Widget topBar() {
    return Row(
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
                      edit.clear();
                      searchDataresponse.removeLast();
                      // Widget build(BuildContext context)
                      // searchfunction();
                      MaterialPageRoute(builder: (context) => shipmentList());
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
        // Padding(
        //   padding: const EdgeInsets.only(left: 20),
        //   child: SizedBox(
        //     width: (Responsive.isDesktop(context))
        //         ? 200
        //         : MediaQuery.of(context).size.width * (40 / 100),
        //     height: 48,
        //     child: ElevatedButton(
        //       onPressed: () {},
        //       style: ButtonStyle(
        //           backgroundColor: MaterialStateProperty.all(Colors.white),
        //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //               RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(10.0),
        //                   side: BorderSide(color: Colors.teal, width: 2.0)))),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: <Widget>[
        //           Text(
        //             (DateFormat.yMd().format(initialDate).toString()),
        //             style: headingStyle12blacknormal(),
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               _selectDate1(context);
        //               // datefilter.text =
        //               //     (DateFormat.yMd().format(initialDate1).toString());
        //             },
        //             child: Container(
        //               // margin: EdgeInsets.only(left: 45, top: 5),
        //               height: 20,
        //               width: 20,
        //               child: Icon(
        //                 Icons.calendar_today,
        //                 color: Colors.black,
        //                 size: 20,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
    // Row(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 30),
    //       child: Container(
    //         height: 48,
    //         width: (Responsive.isDesktop(context))
    //             ? 349
    //             : MediaQuery.of(context).size.width * (30 / 100),
    //         decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.all(Radius.circular(10))),
    //         child: Row(
    //           children: [
    //             Icon(
    //               Icons.search,
    //               color: Color(0xff90A0B7),
    //             ),
    //             Text(
    //               "Search",
    //               style: headingStyle12greynormal(),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   Padding(
    //     padding: const EdgeInsets.only(left: 20),
    //     child: SizedBox(
    //       width: (Responsive.isDesktop(context))
    //           ? 136
    //           : MediaQuery.of(context).size.width * (40 / 100),
    //       height: 48,
    //       child: ElevatedButton(
    //         onPressed: () {},
    //         style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.white),
    //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //                 RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(10.0),
    //                     side: BorderSide(color: Colors.teal, width: 2.0)))),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Text(
    //               (DateFormat.yMd().format(initialDate1).toString()),
    //               style: headingStyle12blacknormal(),
    //             ),
    //             Container(
    //               // margin: EdgeInsets.only(left: 45, top: 5),
    //               height: 20,
    //               width: 20,
    //               child: ImageIcon(
    //                 AssetImage(
    //                   "images/menu-board.png",
    //                 ),
    //                 size: 20,
    //                 color: Colors.black,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //  ),
    //   ],
    // );
  }

  Widget totalShipment() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Container(
        height: (Responsive.isDesktop(context))
            ? 168
            : MediaQuery.of(context).size.height * (20 / 100),
        width: (Responsive.isDesktop(context))
            ? 350
            : MediaQuery.of(context).size.height * (20 / 100),
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
                  "Total Shippment",
                  style: headingStyleinter14blackw500(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xffF7F6FB),
                    child: Container(
                      // margin: EdgeInsets.only(left: 45, top: 5),
                      height: 30,
                      width: 30,
                      child: ImageIcon(
                        AssetImage(
                          'assets/images/3d-square.png',
                        ),
                        size: 30,
                        color: Color(0xff1A494F),
                      ),
                    ),
                  ),
                  Text(
                    "2.57%",
                    style: (Responsive.isDesktop(context))
                        ? headingStyleinter40blackw500()
                        : headingStyleinter14blackw500(),
                  ),
                  Text(
                    "2.2%",
                    style: (Responsive.isDesktop(context))
                        ? headingStyleinter40blackw500()
                        : headingStyleinter14blackw500(),
                  ),
                  Container(
                    height: 16.5,
                    width: 20,
                    child: Icon(
                      Icons.arrow_drop_up_rounded,
                      color: Color(0xff1A494F),
                      size: 30,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 168
          : MediaQuery.of(context).size.height * (20 / 100),
      width: (Responsive.isDesktop(context))
          ? 350
          : MediaQuery.of(context).size.height * (20 / 100),
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
                "Highest Used Mode",
                style: headingStyleinter14blackw500(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: CircleAvatar(
                    backgroundColor: Color(0xffF7F6FB),
                    child: Container(
                      // margin: EdgeInsets.only(left: 45, top: 5),
                      height: 30,
                      width: 30,
                      child: ImageIcon(
                        AssetImage(
                          'images/box.png',
                        ),
                        size: 30,
                        color: Color(0xff1A494F),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: (Responsive.isDesktop(context)) ? 30 : 0,
                ),
                Text(
                  "50",
                  style: (Responsive.isDesktop(context))
                      ? headingStyleinter40blackw500()
                      : headingStyleinter14blackw500(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget estimateCharges() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 10),
      height: (Responsive.isDesktop(context))
          ? 168
          : MediaQuery.of(context).size.height * (20 / 100),
      width: (Responsive.isDesktop(context))
          ? 320
          : MediaQuery.of(context).size.height * (20 / 100),
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
                "Average Estimated Charge",
                style: headingStyleinter14blackw500(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xffF7F6FB),
                  child: Container(
                    // margin: EdgeInsets.only(left: 45, top: 5),
                    height: 30,
                    width: 30,
                    child: ImageIcon(
                      AssetImage(
                        'images/box1.png',
                      ),
                      size: 30,
                      color: Color(0xff1A494F),
                    ),
                  ),
                ),
                Text(
                  "\$200",
                  style: (Responsive.isDesktop(context))
                      ? headingStyleinter40blackw500()
                      : headingStyleinter14blackw500(),
                ),
                Text(
                  "2.2%",
                  style: (Responsive.isDesktop(context))
                      ? headingStyleinter40blackw500()
                      : headingStyleinter14blackw500(),
                ),
                Container(
                  height: 16.5,
                  width: 20,
                  child: Icon(
                    Icons.arrow_drop_up_rounded,
                    color: Color(0xff1A494F),
                    size: 35,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget shipmentList() {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Text(
            "Shipment List",
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
                  'Select Status',
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
                  'Schedule Shipment',
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
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all(Colors.white),
          //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //           RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(10.0),
          //               side: BorderSide(color: Colors.teal, width: 2.0)))),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Text(
          //         (DateFormat.yMd().format(initialDate).toString()),
          //         style: headingStyle12blacknormal(),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 18),
          //         child: GestureDetector(
          //           onTap: () {
          //             _selectDate1(context);
          //             datefilter.text =
          //                 (DateFormat.yMd().format(initialDate).toString());
          //           },
          //           child: Container(
          //             // margin: EdgeInsets.only(left: 45, top: 5),
          //             height: 20,
          //             width: 20,
          //             child: ImageIcon(
          //               AssetImage(
          //                 "images/menu-board.png",
          //               ),
          //               size: 20,
          //               color: Colors.black,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: MediaQuery.of(context).size.height * (65 / 100),
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
                          "Firm Name",
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
                          "Tosco - China Ocean cfdfsdfsdyxzzz ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                      color: Color(0xffFF3D00),
                      width: MediaQuery.of(context).size.width * (40 / 100),
                      margin: EdgeInsets.only(top: 10, right: 20),
                      child: Text("Closed", style: headingStyle12whitew500()),
                    )
                  ],
                ),
                Container(
                    // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                  color: Colors.grey,
                  height: 36,
                )),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "From",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("To",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black))),
                  ],
                ),
                Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "India",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width * (40 / 100),
                        margin: EdgeInsets.only(top: 10, right: 20),
                        child: Text("USA",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Availability",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  Widget shipmentList2() {
    return scheduleData != null
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? scheduleData!.length
                : searchDataresponse.length,
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
                        var data = {
                          "id": id[index],
                        };
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContainerList(data
                                    // Id: id.toString(),
                                    )));
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
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             ResReviewlist()));
                                },
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData![index].title.toString()
                                        : searchDataresponse[index]
                                            .title
                                            .toString(),
                                    style: headingStyle16blackw400(),
                                  ),
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
                                        "Container list",
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
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
                                                  top: 190),
                                              child: AlertDialog(
                                                backgroundColor: Colors.white,
                                                content: ContainerListDialog(
                                                  scheduleData:
                                                      searchDataresponse
                                                                  .length ==
                                                              0
                                                          ? scheduleData
                                                          : searchDataresponse,
                                                  index: index,
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(Icons.arrow_drop_down_rounded,
                                        size: 35,
                                        color: Iamhovering == index
                                            ? Color(0xff1A494F)
                                            : Color(0xffE5E5E5)),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                width: 200,
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData![index].from +
                                          " To " +
                                          scheduleData![index].to
                                      : searchDataresponse[index].from +
                                          " To " +
                                          searchDataresponse[index].to,
                                  style: headingStyle16blackw400(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 130),
                              child: Container(
                                height: 22,
                                width: 86,
                                color: [index] == 1
                                    ? Color(0xffFF3D00)
                                    : [index] == 2
                                        ? Colors.blue
                                        : [index] == 3
                                            ? Colors.green
                                            : [index] == 4
                                                ? Colors.pink
                                                : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData![index].status
                                        : searchDataresponse[index].status,
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
            child: SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator.adaptive()),
          ));
  }
}
