import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/LinearGradient%20copy.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Accountant/accountLoginModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivaldashboardSearvhModel.dart';
import 'package:shipment/Model/ArrivalManager/arrivaldashboardStatsModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalDashboardModel.dart';
import 'package:shipment/Model/ArrivalManager/getArrivalProfileModel.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturesearchtitlesssModel.dart';
import 'package:shipment/Model/Shipment/shipmentSearchModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/ContainerList.dart';
import 'package:shipment/component/Arrival%20Manager/Dashboard.dart';
import 'package:shipment/component/Arrival%20Manager/Sidebar.dart';
import 'package:shipment/component/Arrival%20Manager/re_arrivalClientShowBooking.dart';
import 'package:shipment/pages/Arrival%20Manager/Notification/arrivalNotification.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

class ArrivalDashboard extends StatefulWidget {
  const ArrivalDashboard({Key? key}) : super(key: key);

  @override
  _ArrivalDashboardState createState() => _ArrivalDashboardState();
}

class _ArrivalDashboardState extends State<ArrivalDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController edit = new TextEditingController();
  var h, w;
  var id = [];

  List<searchArrivalData> searchDataresponse = [];
  List<ArrStData>? asdata;
  var tShip, pShip, cShip, inShip, totalclient, packedShip;

  bool iamhovering = false;
  bool iamhovering1 = false;
  bool iamhovering2 = false;
  bool iamhovering3 = false;
  bool iamhovering4 = false;
  bool iamhovering5 = false;
  String _value = " ";
  bool selected = true;
  int? count;
  bool isProcess = false;
  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];

  List<ArrivalData> arrd = [];

  var pendingshipent = [], progressShipment = [], completedshipment = [];
  String filter = 'All';

  void _entering(PointerEvent details, int index) {
    setState(() {
      iamhovering = false;
    });
  }

  void _entering1(PointerEvent details) {
    setState(() {
      iamhovering1 = false;
    });
  }

  void _entering2(PointerEvent details) {
    setState(() {
      iamhovering2 = false;
    });
  }

  void _entering3(PointerEvent details) {
    setState(() {
      iamhovering3 = false;
    });
  }

  void _entering4(PointerEvent details) {
    setState(() {
      iamhovering4 = false;
    });
  }

  void _entering5(PointerEvent details) {
    setState(() {
      iamhovering5 = false;
    });
  }

  void _hovering(PointerEvent details, int index) {
    setState(() {
      iamhovering = true;
    });
  }

  void _hovering1(PointerEvent details) {
    setState(() {
      iamhovering1 = true;
    });
  }

  void _hovering2(PointerEvent details) {
    setState(() {
      iamhovering2 = true;
    });
  }

  void _hovering3(PointerEvent details) {
    setState(() {
      iamhovering3 = true;
    });
  }

  void _hovering4(PointerEvent details) {
    setState(() {
      iamhovering4 = true;
    });
  }

  void _hovering5(PointerEvent details) {
    setState(() {
      iamhovering5 = true;
    });
  }

  getStatus() async {
    var response = await Providers().getArrivalStatus();

    if (response.status == true) {
      setState(() {
        asdata = response.data;
      });
      for (int i = 0; i < asdata!.length; i++) {
        tShip = asdata![i].totalSchedules;
        pShip = asdata![i].openSchedules;
        cShip = asdata![i].closedSchedules;
        inShip = asdata![i].inprogressSchedules;
        totalclient = asdata![i].totalClient;
        packedShip = asdata![i].packedSchedules;
      }
      print(asdata);
    } else {
      print("-=-=-=");
      setState(() {
        tShip = 0;
        pShip = 0;
        cShip = 0;
        inShip = 0;
        totalclient = 0;
        packedShip = 0;
      });
    }
  }

  getNotificationCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('Arrival_Manager_token');
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

  getArrivalList() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getArrivalDashboard();

    if (response.status == true) {
      setState(() {
        arrd = response.data;
      });
      for (int i = 0; i < arrd.length; i++) {
        id.add(arrd[i].id.toString());
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  Widget ContainerListDialog({required int index, arrData}) {
    return Container(
      height: h * 0.68,
      width: w * 0.48,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: SingleChildScrollView(
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
              padding: const EdgeInsets.only(left: 30, bottom: 20),
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
                itemCount: 2,
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
                          margin: EdgeInsets.only(left: 10, top: 5),
                          height: 15,
                          width: 15,
                          child: Image.network(
                              "${arrd[index].available[index1].icon}")),
                      // Spacer(),
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 5),
                          child: Text(arrd[index]
                              .available[index1]
                              .category
                              .toString())),
                      // Spacer(),
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 5),
                          // decoration: BoxDecoration(
                          //     borderRadius:
                          //         BorderRadius.circular(50.0),
                          //     color: Color(0xffEFEFEF)),
                          child: Text(arrd[index]
                              .available[index1]
                              .available
                              .toString())),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget shipmentList2() {
    return arrd.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? arrd.length
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
                    color: iamhovering == index
                        ? Color(0xffFFFFFF).withOpacity(1)
                        : Color(0xffFFFFFF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (arrd[index].bookings.isEmpty) {
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
                          // print("-=-==--= ${arrd[index].bookings}");
                          var data1 = {
                            'bookinglength': arrd[index].bookings,
                            'itemimage1': arrd[index].bookings,
                            'itemimage':
                                arrd[index].bookings[0].booking[0].itemImage,
                            'transactionid': arrd[index]
                                .bookings[0]
                                .transactionId
                                .toString(),
                            'totalamount':
                                arrd[index].bookings[0].totalAmount.toString(),
                            'pickuptype': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupType
                                .toString(),
                            'pickuplocation': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupLocation
                                .toString(),
                            'pickupdate': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupDate
                                .toString(),
                            'pickuptime': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupTime
                                .toString(),
                            'pickupdistance': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupDistance
                                .toString(),
                            'pickupestimate': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupEstimate
                                .toString(),
                            'name': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistName
                                .toString(),
                            'email': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistEmail
                                .toString(),
                            'phone': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistPhone
                                .toString(),
                            'address': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistAddress
                                .toString(),
                            'country': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistCountry
                                .toString(),
                            'id': arrd[index].id.toString(),
                            'title': arrd[index].title.toString(),
                            'bookingdate':
                                arrd[index].bookings[0].bookingDate.toString(),
                            'arrivaldate':
                                arrd[index].bookings[0].arrivalDate.toString(),
                            'type':
                                arrd[index].bookings[0].bookingType.toString(),
                            'shipcmpany': arrd[index]
                                .bookings[0]
                                .shipmentCompany
                                .toString(),
                            'shipmentStatus': arrd[index].status.toLowerCase(),
                          };
                          print(
                              "**********************${data1['shipmentStatus']}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ArrivalDashboradClientShowBookings(data1
                                          //  Id: id.toString(),
                                          )));
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
                              padding: const EdgeInsets.only(left: 10),
                              child: Container(
                                width: 50,
                                child: Text(arrd[index].id.toString()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  width: 90,
                                  child: Text(searchDataresponse.length == 0
                                      ? arrd[index].title.toString()
                                      : searchDataresponse[index]
                                          .title
                                          .toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 50,
                              ),
                              child: Row(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 120,
                                      child: Text(
                                        arrd[index].shipmentType.toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      var data1 = {
                                        'bookinglength': arrd[index].bookings,
                                        'itemimage1': arrd[index].bookings,
                                        'itemimage': arrd[index]
                                            .bookings[0]
                                            .booking[0]
                                            .itemImage,
                                        'transactionid': arrd[index]
                                            .bookings[0]
                                            .transactionId
                                            .toString(),
                                        'totalamount': arrd[index]
                                            .bookings[0]
                                            .totalAmount
                                            .toString(),
                                        'pickuptype': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupType
                                            .toString(),
                                        'pickuplocation': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupLocation
                                            .toString(),
                                        'pickupdate': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupDate
                                            .toString(),
                                        'pickuptime': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupTime
                                            .toString(),
                                        'pickupdistance': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupDistance
                                            .toString(),
                                        'pickupestimate': arrd[index]
                                            .bookings[0]
                                            .pickupReview[0]
                                            .pickupEstimate
                                            .toString(),
                                        'name': arrd[index]
                                            .bookings[0]
                                            .receptionistInfo[0]
                                            .receptionistName
                                            .toString(),
                                        'email': arrd[index]
                                            .bookings[0]
                                            .receptionistInfo[0]
                                            .receptionistEmail
                                            .toString(),
                                        'phone': arrd[index]
                                            .bookings[0]
                                            .receptionistInfo[0]
                                            .receptionistPhone
                                            .toString(),
                                        'address': arrd[index]
                                            .bookings[0]
                                            .receptionistInfo[0]
                                            .receptionistAddress
                                            .toString(),
                                        'country': arrd[index]
                                            .bookings[0]
                                            .receptionistInfo[0]
                                            .receptionistCountry
                                            .toString(),
                                        'id': arrd[index].id.toString(),
                                        'title': arrd[index].title.toString(),
                                        'bookingdate': arrd[index]
                                            .bookings[0]
                                            .bookingDate
                                            .toString(),
                                        'arrivaldate': arrd[index]
                                            .bookings[0]
                                            .arrivalDate
                                            .toString(),
                                        'type': arrd[index]
                                            .bookings[0]
                                            .bookingType
                                            .toString(),
                                        'shipcmpany': arrd[index]
                                            .bookings[0]
                                            .shipmentCompany
                                            .toString(),
                                        'shipmentStatus':
                                            arrd[index].status.toLowerCase(),
                                      };
                                      print(
                                          "**********************${data1['shipmentStatus']}");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArrivalDashboradClientShowBookings(
                                                      data1
                                                      //  Id: id.toString(),
                                                      )));
                                    },
                                    icon: Icon(Icons.arrow_drop_down_rounded,
                                        size: 35,
                                        color: iamhovering == index
                                            ? Color(0xff1A494F)
                                            : Color(0xffE5E5E5)),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                width: 200,
                                child: Text(
                                    arrd[index].from + " To " + arrd[index].to),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                height: 22,
                                width: 86,
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
                                    : arrd[index].status == "Closed"
                                        ? Color(0xffFF3D00)
                                        : arrd[index].status == "Packed"
                                            ? Colors.blue
                                            : arrd[index].status == "Open"
                                                ? Colors.green
                                                : arrd[index].status ==
                                                        "InProgress"
                                                    ? Colors.orangeAccent
                                                    : Colors.orangeAccent,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? arrd[index].status
                                        : searchDataresponse[index].status,
                                    overflow: TextOverflow.ellipsis,
                                    style: headingStyle12whitew500(),
                                  ),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getArrivalList();
    getNotificationCount();

    // searchfunction1();
    getStatus();
  }

  searchfunction() async {
    var searchData = {
      "title": edit.text == null ? "" : edit.text.toString(),
      "stats": ""
    };

    final response = await Providers().searchArrivalManager(searchData);
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

    final response = await Providers().searchArrivalManager(searchData);
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

  Widget topBarMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: w * 0.39,
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(20, 10, 0, 0)
                    : EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text(
                  'dashboard'.tr(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
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
                                  const ArrivalNotificationScreen()),
                        );
                      },
                      child: Stack(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: 150, bottom: 5, top: 10),
                            child: Icon(
                              Icons.notifications,
                              size: 27,
                            ),
                          ),
                          count != null
                              ? Positioned(
                                  left: 160,
                                  right: 0,
                                  top: 12,
                                  child: Icon(Icons.fiber_manual_record,
                                      color: Colors.red, size: 12),
                                )
                              : Container()
                        ],
                      )))
            ]),
      ],
    );
  }

  Widget topBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    MaterialPageRoute(builder: (context) => shipmentList());
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
      ),
      SizedBox(
        width: w * 0.26,
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
                      builder: (context) => const ArrivalNotificationScreen()),
                );
              },
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 5),
                    child: Icon(
                      Icons.notifications,
                      size: 38,
                    ),
                  ),
                  count != null
                      ? Positioned(
                          top: 5,
                          left: 20,
                          right: 0,
                          child: Icon(Icons.fiber_manual_record,
                              color: Colors.red, size: 12),
                        )
                      : Container()
                ],
              )))
    ]);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: Text('Do you want to exit App'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  exit(0);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return (!Responsive.isDesktop(context))
        ? WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              key: _scaffoldKey,
              drawer: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: ArrivalSidebar(),
              ),
              body: isProcess == true
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      padding:
                          EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                      color: Color(0xffE5E5E5),
                      child: SafeArea(
                          right: false,
                          child: ListView(
                            children: [
                              Padding(
                                padding: (Responsive.isDesktop(context))
                                    ? const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding)
                                    : const EdgeInsets.symmetric(horizontal: 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!Responsive.isDesktop(context))
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: IconButton(
                                          icon: Icon(Icons.menu),
                                          onPressed: () {
                                            _scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                        ),
                                      ),
                                    if (Responsive.isDesktop(context)) topBar(),
                                    if (!Responsive.isDesktop(context))
                                      topBarMobile(),
                                  ],
                                ),
                              ),
                              if (!Responsive.isDesktop(context))
                                Column(
                                  children: [
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: 20,
                                              left: 15,
                                              top: 10,
                                              right: 5),
                                          height: 48,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors
                                                    .white, // set border color
                                                width: 2.0), // set border width
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    10.0)), // set rounded corner radius
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 0,
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
                                                      searchDataresponse
                                                          .removeLast();
                                                      // Widget build(BuildContext context)
                                                      // searchfunction();
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              shipmentList());
                                                    });
                                                  },
                                                ),
                                                hintText: "searchhere".tr(),
                                                border: InputBorder.none,
                                              ),
                                              style: TextStyle(
                                                  color: Colors.black),
                                              autofocus: true,
                                              onChanged: (val) {
                                                // title = val;
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                DropdownButton<String>(
                                                  hint: Text(
                                                      "chooselanguage".tr()),
                                                  value: dropdownvalue,
                                                  dropdownColor: Colors.white,
                                                  focusColor: Colors.white,
                                                  // Down Arrow Icon

                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 16,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      dropdownvalue = newValue!;
                                                    });
                                                    if (dropdownvalue ==
                                                        "English") {
                                                      context.locale =
                                                          Locale("en", "US");
                                                    } else if (dropdownvalue ==
                                                        "French") {
                                                      context.locale =
                                                          Locale("fr", "FR");
                                                    } else if (dropdownvalue ==
                                                        "Spanish") {
                                                      context.locale =
                                                          Locale("es", "US");
                                                    }
                                                  },
                                                  items:
                                                      items.map((String items) {
                                                    return DropdownMenuItem(
                                                      value: items,
                                                      child: Text(items),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 200,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          totalShipment(),
                                          usedMode(),
                                          estimateCharges()
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Row(
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
                                                                .circular(10.0),
                                                        side: BorderSide(
                                                            color: Colors.teal,
                                                            width: 2.0)))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                DropdownButton<String>(
                                                  hint:
                                                      Text("selectstatus".tr()),
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
                                                    'Closed'
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
                                          // topBar()
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                                style:
                                                    headingStyle22blackw600(),
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.white),
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
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
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
                                                          searchDataresponse =
                                                              [];
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
                                                        'Closed'
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
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: ArrivalSidebar(),
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
                              padding: (Responsive.isDesktop(context))
                                  ? const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding)
                                  : const EdgeInsets.symmetric(horizontal: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!Responsive.isDesktop(context))
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: IconButton(
                                        icon: Icon(Icons.menu),
                                        onPressed: () {
                                          _scaffoldKey.currentState!
                                              .openDrawer();
                                        },
                                      ),
                                    ),
                                  if (Responsive.isDesktop(context)) topBar(),
                                  if (!Responsive.isDesktop(context))
                                    topBarMobile(),
                                ],
                              ),
                            ),
                            if (!Responsive.isDesktop(context))
                              Column(
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            bottom: 20,
                                            left: 15,
                                            top: 10,
                                            right: 5),
                                        height: 48,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors
                                                  .white, // set border color
                                              width: 2.0), // set border width
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  10.0)), // set rounded corner radius
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 5,
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
                                                    searchDataresponse
                                                        .removeLast();
                                                    // Widget build(BuildContext context)
                                                    // searchfunction();
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            shipmentList());
                                                  });
                                                },
                                              ),
                                              hintText: "searchhere".tr(),
                                              border: InputBorder.none,
                                            ),
                                            style:
                                                TextStyle(color: Colors.black),
                                            autofocus: true,
                                            onChanged: (val) {
                                              // title = val;
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              DropdownButton<String>(
                                                hint:
                                                    Text("chooselanguage".tr()),
                                                value: dropdownvalue,
                                                dropdownColor: Colors.white,
                                                focusColor: Colors.white,
                                                // Down Arrow Icon

                                                icon:
                                                    Icon(Icons.arrow_drop_down),
                                                iconSize: 30,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownvalue = newValue!;
                                                  });
                                                  if (dropdownvalue ==
                                                      "English") {
                                                    context.locale =
                                                        Locale("en", "US");
                                                  } else if (dropdownvalue ==
                                                      "French") {
                                                    context.locale =
                                                        Locale("fr", "FR");
                                                  } else if (dropdownvalue ==
                                                      "Spanish") {
                                                    context.locale =
                                                        Locale("es", "US");
                                                  }
                                                },
                                                items:
                                                    items.map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        totalShipment(),
                                        usedMode(),
                                        estimateCharges()
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 10),
                                    child: Row(
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
                                                icon:
                                                    Icon(Icons.arrow_drop_down),
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
                                                  'Closed'
                                                ].map<DropdownMenuItem<String>>(
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
                                        // topBar()
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                                      'Closed'
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

  Widget totalShipment() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 15, top: 5, bottom: 5),
      height: (Responsive.isDesktop(context))
          ? 170
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
              child: Text(
                "totalshipment".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
                // style: headingStyleinter14blackw500(),
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
    );
  }

  Widget usedMode() {
    return Container(
      height: (Responsive.isDesktop(context))
          ? 170
          : MediaQuery.of(context).size.height * (21 / 100),
      width: (Responsive.isDesktop(context))
          ? 300
          : MediaQuery.of(context).size.height * (34 / 100),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          // for (int i = 0; i < scheduleData!.length; i++)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: Text(
                "shipmentstatus".tr(),
                style: TextStyle(
                    fontSize: (Responsive.isDesktop(context)) ? 21 : 17,
                    fontWeight: FontWeight.bold),
                // style: headingStyleinter14blackw500(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "pendingshipment".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                    // style: headingStyleinter14blackw500(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    pShip.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "inprogresshipment".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    inShip.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "closedshipment".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    cShip.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Packed".tr(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 15 : 11),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    packedShip.toString(),
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 20 : 14,
                        fontWeight: FontWeight.bold),
                  ),
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
          ? 170
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
                      fontWeight: FontWeight.bold)),
            ),
          ),
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
                DropdownButton<String>(
                  hint: Text("selectstatus".tr()),
                  value: filter,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      filter = newValue!;
                    });
                    if (filter == "all".tr()) {
                      searchDataresponse = [];
                      MaterialPageRoute(builder: (context) => shipmentList());
                    } else {
                      searchfunction1();
                    }
                  },
                  items: <String>[
                    'All',
                    'Open',
                    'InProgress',
                    'Packed',
                    'Closed'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
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

  Widget scheduleStatus() {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Row(
        children: [
          (Responsive.isDesktop(context))
              ? SizedBox(
                  width: 30,
                )
              : Spacer(),
          ElevatedButton(
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
                  '21.08.2021',
                  style: headingStyle12blackw500(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
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
        ],
      ),
    );
  }

  Widget mobileViewlist() {
    return arrd.isNotEmpty
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchDataresponse.length == 0
                ? arrd.length
                : searchDataresponse.length,
            shrinkWrap: true,
            reverse: true,
            // scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
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
                    color: iamhovering == index
                        ? Color(0xffFFFFFF).withOpacity(1)
                        : Color(0xffFFFFFF).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (arrd[index].bookings.isEmpty) {
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
                                      child: Text("close".tr()),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        } else {
                          // print("-=-==--= ${arrd[index].bookings}");
                          var data1 = {
                            'bookinglength': arrd[index].bookings,
                            'itemimage1': arrd[index].bookings,
                            'itemimage':
                                arrd[index].bookings[0].booking[0].itemImage,
                            'transactionid': arrd[index]
                                .bookings[0]
                                .transactionId
                                .toString(),
                            'totalamount':
                                arrd[index].bookings[0].totalAmount.toString(),
                            'pickuptype': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupType
                                .toString(),
                            'pickuplocation': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupLocation
                                .toString(),
                            'pickupdate': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupDate
                                .toString(),
                            'pickuptime': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupTime
                                .toString(),
                            'pickupdistance': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupDistance
                                .toString(),
                            'pickupestimate': arrd[index]
                                .bookings[0]
                                .pickupReview[0]
                                .pickupEstimate
                                .toString(),
                            'name': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistName
                                .toString(),
                            'email': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistEmail
                                .toString(),
                            'phone': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistPhone
                                .toString(),
                            'address': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistAddress
                                .toString(),
                            'country': arrd[index]
                                .bookings[0]
                                .receptionistInfo[0]
                                .receptionistCountry
                                .toString(),
                            'id': arrd[index].id.toString(),
                            'title': arrd[index].title.toString(),
                            'bookingdate':
                                arrd[index].bookings[0].bookingDate.toString(),
                            'arrivaldate':
                                arrd[index].bookings[0].arrivalDate.toString(),
                            'type':
                                arrd[index].bookings[0].bookingType.toString(),
                            'shipcmpany': arrd[index]
                                .bookings[0]
                                .shipmentCompany
                                .toString(),
                            'shipmentStatus': arrd[index].status.toLowerCase(),
                          };
                          print(
                              "**********************${data1['shipmentStatus']}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ArrivalDashboradClientShowBookings(data1
                                          //  Id: id.toString(),
                                          )));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    width: 50,
                                    child: Text(arrd[index].id.toString()),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: Text(searchDataresponse.length == 0
                                        ? arrd[index].title.toString()
                                        : searchDataresponse[index]
                                            .title
                                            .toString()),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: Text(
                                        arrd[index].shipmentType.toString(),
                                        style: headingStyle16blackw400(),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_drop_down_rounded,
                                          size: 35,
                                          color: iamhovering == index
                                              ? Color(0xff1A494F)
                                              : Color(0xffE5E5E5),
                                        ))
                                  ],
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    child: Text(arrd[index].from +
                                        " To " +
                                        arrd[index].to)),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 255,
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
                                      : arrd[index].status == "Closed"
                                          ? Color(0xffFF3D00)
                                          : arrd[index].status == "Packed"
                                              ? Colors.blue
                                              : arrd[index].status == "Open"
                                                  ? Colors.green
                                                  : arrd[index].status ==
                                                          "InProgress"
                                                      ? Colors.orangeAccent
                                                      : Colors.orangeAccent,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? arrd[index].status
                                          : searchDataresponse[index].status,
                                      overflow: TextOverflow.ellipsis,
                                      style: headingStyle12whitew500(),
                                    ),
                                  ),
                                ),
                                InkWell(
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
                              ],
                            )
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
    ;
    // return ListView.builder(
    //     itemCount: 2,
    //     shrinkWrap: true,
    //     itemBuilder: (context, index) {
    //       return InkWell(
    //         onTap: () {
    //           // Navigator.push(context,
    //           //     MaterialPageRoute(builder: (context) => ContainerList(data)));
    //         },
    //         child: Container(
    //           // height: (!Responsive.isDesktop(context))
    //           //     ? MediaQuery.of(context).size.height * (10 / 100)
    //           //     : MediaQuery.of(context).size.height * (45 / 100),
    //           height: MediaQuery.of(context).size.height * (65 / 100),
    //           width: w,
    //           margin: EdgeInsets.all(15),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10.0),
    //             color: Color(0xffFFFFFF),
    //           ),

    //           child: Column(
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 // crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(left: 15, top: 15),
    //                       child: Text(
    //                         "Firm Name",
    //                         style: TextStyle(fontWeight: FontWeight.w500),
    //                       )),
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(top: 15, right: 20),
    //                       child: Text(
    //                         "Status",
    //                         style: TextStyle(fontWeight: FontWeight.w500),
    //                       )),
    //                 ],
    //               ),
    //               SizedBox(
    //                 width: 10,
    //               ),
    //               Row(
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(left: 15, top: 10),
    //                       child: Text(
    //                         "Tosco - China Ocean cfdfsdfsdyxzzz ",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       )),
    //                   Container(
    //                     color: Color(0xffFF3D00),
    //                     width: MediaQuery.of(context).size.width * (40 / 100),
    //                     margin: EdgeInsets.only(top: 10, right: 20),
    //                     child: Text("Closed", style: headingStyle12whitew500()),
    //                   )
    //                 ],
    //               ),
    //               Container(
    //                   // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
    //                   child: Divider(
    //                 color: Colors.grey,
    //                 height: 36,
    //               )),
    //               Row(
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(left: 15, top: 10),
    //                       child: Text(
    //                         "From",
    //                         style: TextStyle(fontWeight: FontWeight.w500),
    //                       )),
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(top: 10, right: 20),
    //                       child: Text("To",
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.w500,
    //                               color: Colors.black))),
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(left: 15, top: 10),
    //                       child: Text(
    //                         "India",
    //                         style: TextStyle(fontWeight: FontWeight.bold),
    //                       )),
    //                   Container(
    //                       width: MediaQuery.of(context).size.width * (40 / 100),
    //                       margin: EdgeInsets.only(top: 10, right: 20),
    //                       child: Text("USA",
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.bold,
    //                               color: Colors.black))),
    //                 ],
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 15, top: 10),
    //                 child: Align(
    //                   alignment: Alignment.topLeft,
    //                   child: Text(
    //                     "Availability",
    //                     style: TextStyle(
    //                       decoration: TextDecoration.none,
    //                       fontSize: 20,
    //                       color: Colors.black,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 20),
    //                 child: Row(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 30),
    //                       child: Row(
    //                         children: [
    //                           Container(
    //                             // margin: EdgeInsets.only(left: 45, top: 5),
    //                             height: 15,
    //                             width: 15,
    //                             child: ImageIcon(
    //                               AssetImage(
    //                                 'assets/images/car.png',
    //                               ),
    //                               size: 20,
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Text("Car",
    //                                 style: TextStyle(
    //                                   decoration: TextDecoration.none,
    //                                   color: Colors.black,
    //                                   fontSize: 15,
    //                                 )),
    //                           ),
    //                           Container(
    //                             decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                   color: Color(0xffEFEFEF),
    //                                 ),
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(10))),
    //                             height: 31,
    //                             width: 31,
    //                             child: Center(
    //                               child: Text("3",
    //                                   style: TextStyle(
    //                                     decoration: TextDecoration.none,
    //                                     color: Colors.black,
    //                                     fontSize: 15,
    //                                   )),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 100),
    //                       child: Row(
    //                         children: [
    //                           Container(
    //                             // margin: EdgeInsets.only(left: 45, top: 5),
    //                             height: 15,
    //                             width: 15,
    //                             child: ImageIcon(
    //                               AssetImage(
    //                                 'assets/images/box.png',
    //                               ),
    //                               size: 20,
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Text("Boxes",
    //                                 style: TextStyle(
    //                                   decoration: TextDecoration.none,
    //                                   color: Colors.black,
    //                                   fontSize: 15,
    //                                 )),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                   border: Border.all(
    //                                     color: Color(0xffEFEFEF),
    //                                   ),
    //                                   borderRadius: BorderRadius.all(
    //                                       Radius.circular(10))),
    //                               height: 31,
    //                               width: 31,
    //                               child: Center(
    //                                 child: Text("6",
    //                                     style: TextStyle(
    //                                       decoration: TextDecoration.none,
    //                                       color: Colors.black,
    //                                       fontSize: 15,
    //                                     )),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 20),
    //                 child: Row(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 30.0),
    //                       child: Row(
    //                         children: [
    //                           Container(
    //                             // margin: EdgeInsets.only(left: 45, top: 5),
    //                             height: 15,
    //                             width: 15,
    //                             child: ImageIcon(
    //                               AssetImage(
    //                                 'assets/images/slidervertical.png',
    //                               ),
    //                               size: 20,
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Text("Barrel",
    //                                 style: TextStyle(
    //                                   decoration: TextDecoration.none,
    //                                   color: Colors.black,
    //                                   fontSize: 15,
    //                                 )),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                   border: Border.all(
    //                                     color: Color(0xffEFEFEF),
    //                                   ),
    //                                   borderRadius: BorderRadius.all(
    //                                       Radius.circular(10))),
    //                               height: 31,
    //                               width: 31,
    //                               child: Center(
    //                                 child: Text("12",
    //                                     style: TextStyle(
    //                                       decoration: TextDecoration.none,
    //                                       color: Colors.black,
    //                                       fontSize: 15,
    //                                     )),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 80),
    //                       child: Row(
    //                         children: [
    //                           Container(
    //                             // margin: EdgeInsets.only(left: 45, top: 5),
    //                             height: 15,
    //                             width: 15,
    //                             child: ImageIcon(
    //                               AssetImage(
    //                                 'assets/images/Group 840.png',
    //                               ),
    //                               size: 20,
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Text("Tv",
    //                                 style: TextStyle(
    //                                   decoration: TextDecoration.none,
    //                                   color: Colors.black,
    //                                   fontSize: 15,
    //                                 )),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.only(left: 5),
    //                             child: Container(
    //                               decoration: BoxDecoration(
    //                                   border: Border.all(
    //                                     color: Color(0xffEFEFEF),
    //                                   ),
    //                                   borderRadius: BorderRadius.all(
    //                                       Radius.circular(10))),
    //                               height: 31,
    //                               width: 31,
    //                               child: Center(
    //                                 child: Text("6",
    //                                     style: TextStyle(
    //                                       decoration: TextDecoration.none,
    //                                       color: Colors.black,
    //                                       fontSize: 15,
    //                                     )),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 20, left: 30),
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       // margin: EdgeInsets.only(left: 45, top: 5),
    //                       height: 15,
    //                       width: 15,
    //                       child: ImageIcon(
    //                         AssetImage(
    //                           'assets/images/bus.png',
    //                         ),
    //                         size: 20,
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 5),
    //                       child: Text("Fridge",
    //                           style: TextStyle(
    //                             decoration: TextDecoration.none,
    //                             color: Colors.black,
    //                             fontSize: 15,
    //                           )),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.only(left: 5),
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                             border: Border.all(
    //                               color: Color(0xffEFEFEF),
    //                             ),
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(10))),
    //                         height: 31,
    //                         width: 31,
    //                         child: Center(
    //                           child: Text("12",
    //                               style: TextStyle(
    //                                 decoration: TextDecoration.none,
    //                                 color: Colors.black,
    //                                 fontSize: 15,
    //                               )),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
