import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/showScheduleItemsModel.dart';
import 'package:shipment/Model/Shipment/getarrivalMangerList.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/component/Accountant/Dashboad/Dashboard.dart';
import 'package:shipment/component/Accountant/ScheduleShipment/SchdeuleShipment.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AccountScheduleShipment extends StatefulWidget {
  const AccountScheduleShipment({Key? key}) : super(key: key);

  @override
  _AccountScheduleShipmentState createState() =>
      _AccountScheduleShipmentState();
}

class _AccountScheduleShipmentState extends State<AccountScheduleShipment>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var h, w;
  TextEditingController datefilter = new TextEditingController();
  TextEditingController dateinput = new TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();
  TabController? _tabController;
  TabController? _controller;
  var selected = [];
  String shipmentTypeText = 'Plane';
  var shipmentTypeArray = ['Plane', 'Boat', 'Road'];
  String scheduleTitle = '';
  var fromLocation = '';
  var toLocation = '';
  var departureDate = '';
  var destiWarehouse = '';
  var arrivalManagernames = '';
  // List itemTypeList = [];
  List<ArrivalManagerDetais>? managerList;
  List<ShowScheduleItemsModelData> itemTypeListModel =
      <ShowScheduleItemsModelData>[];
  List<ShowScheduleItemsModelData>? scheduleItemlist;
  var itemNames = [];

  String? category;

  var amount;
  List<List<Items>> item123 = [];

  // var item123 = [];
  // final TextEditingController _itemTypecontrollr = new TextEditingController();
  List<TextEditingController> _itemTypecontrollr = [];

  List itemList = [];
  List iconlist = [];
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

  List<String> _countries = [
    "Afghanistan",
    "Åland Islands",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas (the)",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia (Plurinational State of)",
    "Bonaire, Sint Eustatius and Saba",
    "Bosnia and Herzegovina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory (the)",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cayman Islands (the)",
    "Central African Republic (the)",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling) Islands (the)",
    "Colombia",
    "Comoros (the)",
    "Congo (the Democratic Republic of the)",
    "Congo (the)",
    "Cook Islands (the)",
    "Costa Rica",
    "Croatia",
    "Cuba",
    "Curaçao",
    "Cyprus",
    "Czechia",
    "Côte d'Ivoire",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic (the)",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Eswatini",
    "Ethiopia",
    "Falkland Islands (the) [Malvinas]",
    "Faroe Islands (the)",
    "Fiji",
    "Finland",
    "France",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories (the)",
    "Gabon",
    "Gambia (the)",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard Island and McDonald Islands",
    "Holy See (the)",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran (Islamic Republic of)",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea (the Democratic People's Republic of)",
    "Korea (the Republic of)",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic (the)",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macao",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands (the)",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia (Federated States of)",
    "Moldova (the Republic of)",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands (the)",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger (the)",
    "Nigeria",
    "Niue",
    "Norfolk Island",
    "Northern Mariana Islands (the)",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Palestine, State of",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines (the)",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Republic of North Macedonia",
    "Romania",
    "Russian Federation (the)",
    "Rwanda",
    "Réunion",
    "Saint Barthélemy",
    "Saint Helena, Ascension and Tristan da Cunha",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Martin (French part)",
    "Saint Pierre and Miquelon",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Sint Maarten (Dutch part)",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia and the South Sandwich Islands",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "Sudan (the)",
    "Suriname",
    "Svalbard and Jan Mayen",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan (Province of China)",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Timor-Leste",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands (the)",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates (the)",
    "United Kingdom of Great Britain and Northern Ireland (the)",
    "United States Minor Outlying Islands (the)",
    "United States of America (the)",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Venezuela (Bolivarian Republic of)",
    "Viet Nam",
    "Virgin Islands (British)",
    "Virgin Islands (U.S.)",
    "Wallis and Futuna",
    "Western Sahara",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];

  getArrivalManagerName() async {
    var responce = await Providers().getArrivalManagerlist();
    setState(() {
      managerList = responce.data;
    });
  }

  List getSuggestions2(String query) {
    List matches = [];
    matches.add;
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    getArrivalManagerName();

    getScheduleItemList();
    var itemtextEditingController = TextEditingController(text: 'car');

    _itemTypecontrollr.add(itemtextEditingController);

    _tabController = new TabController(length: 3, vsync: this);
    _controller = new TabController(length: 3, vsync: this);
  }

  bool isProcess = false;
  getScheduleItemList() async {
    setState(() {
      isProcess = true;
    });
    var loginshipment = await Providers().getScheduleItemList();
    setState(() {
      scheduleItemlist = loginshipment.data;
    });
    if (scheduleItemlist!.length > 0)
      itemTypeListModel.add(ShowScheduleItemsModelData(
        categoryName: scheduleItemlist![0].categoryName,
        id: scheduleItemlist![0].id,
        icon: scheduleItemlist![0].icon,

        // category: 'car',
        // item: "charted",
        // pickupFee: 0,
        // quantity: 0,
        // shippingFee: 0
      ));
    selected.add(scheduleItemlist![0].categoryName);
    for (int i = 0; i < scheduleItemlist!.length; i++) {
      itemNames.add(scheduleItemlist![i].categoryName);
      iconlist.add(scheduleItemlist![i].icon);
    }
    item123.add(scheduleItemlist![0].items ?? []);
    setState(() {
      isProcess = false;
    });
    log("schedule shipmet" + jsonEncode(scheduleItemlist));
  }

  scheduleShipmentApicall() async {
    var bodydata = {
      "shipment_type": shipmentTypeText,
      "title": scheduleTitle,
      "from": fromLocation,
      "to": toLocation,
      "departure_date": dateinput.text,
      "arrival_date": "19-12-2022",
      "destination_warehouse": destiWarehouse,
      "item_type": jsonEncode(itemTypeListModel)
    };
    print(jsonEncode(bodydata));
    var loginshipment = await Providers().scheduleShipmentApi(bodydata);
    if (loginshipment.status == true) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScheduleShipment()));
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(loginshipment.message.toString()),
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
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(loginshipment.message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    log(jsonEncode(loginshipment));
  }

  List getSuggestions(String query) {
    List matches = [];
    matches.addAll(_countries);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  void dispose() {
    _tabController!.dispose();
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
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              height: h,
              color: Color(0xffF5F6F8),
              child: SafeArea(
                  child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                                'Schedule Shipment',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              // Spacer(),
                              // if (Responsive.isDesktop(context)) topBar()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if (!Responsive.isDesktop(context))
                  //   Column(
                  //     children: [topBar()],
                  //   ),
                  shipmentType2(),
                ],
              ))),
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
                  color: Colors.grey, // set border color
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

  Widget shipmentType2() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      margin: EdgeInsets.only(left: 24, top: 15, right: 10),
      // height: h,
      // width: w,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, left: 10),
              child: Text(
                "Choose your shipment type",
                // style: headingStyleAppColor18MB(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              // width: MediaQuery.of(context).size.width * (50 / 100),
              width: 300,
              // height: h,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // SizedBox(height: 20.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            child: TabBar(
                              onTap: (index) {
                                print(index);
                                setState(() {
                                  shipmentTypeText = shipmentTypeArray[index];
                                });
                              },
                              controller: _controller,
                              labelColor: Color(0xff1A494F),
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color(0xff1A494F),
                              tabs: <Widget>[
                                new Tab(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: Icon(
                                        Icons.local_airport_outlined,
                                        size: 18,
                                        color: Colors.black,
                                      )),
                                      Container(
                                        child: Text(
                                          "Plane",
                                          // style: headingStyle14tealw500(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Tab(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: Icon(
                                        Icons.directions_boat_filled,
                                        size: 18,
                                        // color: Colors.black,
                                      )),
                                      Container(
                                        child: Text(
                                          "Boat",
                                          // style: headingStyle14tealw500(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Tab(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: Icon(
                                        Icons.local_shipping_outlined,
                                        size: 18,
                                        // color: Colors.black,
                                      )),
                                      Container(
                                        child: Text(
                                          "Road",
                                          // style: headingStyle14tealw500(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ]),
            ),
          ),
          Container(
              height: h,
              width: w,
              // width: w, //height of TabBarView
              decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.grey, width: 0.5))),
              child: TabBarView(controller: _controller, children: <Widget>[
                planeShiping(),
                planeShiping(),
                planeShiping(),
              ]))
        ],
      ),
    );
  }

  Widget planeShiping() {
    return Container(
        // height: h * 0.8,
        decoration: BoxDecoration(
          // border: Border.all(width: 15, color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (Responsive.isDesktop(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                      //   height: 40,
                      //   width: MediaQuery.of(context).size.width * (25 / 100),
                      //   child: TypeAheadField(
                      //     hideSuggestionsOnKeyboardHide: false,
                      //     textFieldConfiguration: TextFieldConfiguration(
                      //       controller: this.controller,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           fromLocation = value.toString();
                      //         });
                      //       },
                      //       decoration: InputDecoration(
                      //           //
                      //           hintText: 'From',
                      //           hintStyle: TextStyle(
                      //               color: Colors.black, fontSize: 15)),
                      //     ),
                      //     suggestionsCallback: (v) {
                      //       return getSuggestions("$v");
                      //     },
                      //     itemBuilder: (context, suggestion) {
                      //       return ListTile(
                      //         title: Text(suggestion.toString()),
                      //       );
                      //     },
                      //     transitionBuilder:
                      //         (context, suggestionsBox, controller) {
                      //       return suggestionsBox;
                      //     },
                      //     onSuggestionSelected: (suggestion) {
                      //       this.controller.text = suggestion.toString();
                      //       fromLocation = this.controller.text;
                      //     },
                      //   ),
                      // ),

                      Container(
                          margin: EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffEEEEEE)),
                          height: 20,
                          width: 20,
                          child: ImageIcon(
                            AssetImage(
                              'assets/images/swap2.png',
                            ),
                            size: 10,
                          )),
                      // Container(
                      //   margin: EdgeInsets.fromLTRB(15, 20, 10, 0),
                      //   height: 40,
                      //   width: MediaQuery.of(context).size.width * (25 / 100),
                      //   child: TypeAheadField(
                      //     hideSuggestionsOnKeyboardHide: false,
                      //     textFieldConfiguration: TextFieldConfiguration(
                      //       controller: this.controllerTo,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           toLocation = value.toString();
                      //         });
                      //       },
                      //       decoration: InputDecoration(
                      //           hintText: 'To',
                      //           hintStyle: TextStyle(
                      //               color: Colors.black, fontSize: 15)),
                      //     ),
                      //     suggestionsCallback: (v) {
                      //       return getSuggestions("$v");
                      //     },
                      //     itemBuilder: (context, suggestion) {
                      //       return ListTile(
                      //         title: Text(suggestion.toString()),
                      //       );
                      //     },
                      //     transitionBuilder:
                      //         (context, suggestionsBox, controller) {
                      //       return suggestionsBox;
                      //     },
                      //     // noItemsFoundBuilder: (context) => Container(
                      //     //   height: 100,
                      //     //   child: Center(
                      //     //     child: Text(
                      //     //       'Do you want to add this name',
                      //     //       style: TextStyle(fontSize: 18),
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //     onSuggestionSelected: (suggestion) {
                      //       this.controllerTo.text = suggestion.toString();
                      //       toLocation = this.controller.text;
                      //     },
                      //   ),
                      // ),
                      // //  TextFormField(
                      //   initialValue: '',
                      //   onChanged: (value) {
                      //     setState(() {
                      //       toLocation = value.toString();
                      //     });
                      //   },
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'required*';
                      //     }
                      //     return null;
                      //   },
                      //   style: TextStyle(color: Colors.black54, fontSize: 17),
                      //   decoration: InputDecoration(
                      //       fillColor: Colors.transparent,
                      //       // filled: true,

                      //       // border: InputBorder.none,
                      //       hintText: "To",
                      //       hintStyle:
                      //           TextStyle(color: Colors.black, fontSize: 15)),
                      // ),
                    ],
                  ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                        height: 52,
                        width: MediaQuery.of(context).size.width * (10 / 100),
                        child: TextFormField(
                          controller: dateinput,
                          // initialValue: '',
                          onChanged: (value) {
                            setState(() {
                              // departureDate = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'required*';
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.black54, fontSize: 17),
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              // filled: true,

                              // border: InputBorder.none,
                              hintText: "Departure Date",
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateinput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 10, top: 15),
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 20,
                            )),
                      ),
                    ],
                  ),
                ),
                if (!Responsive.isDesktop(context))
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 15, 0, 0),
                            height: 52,
                            width:
                                MediaQuery.of(context).size.width * (25 / 100),
                            child: TextFormField(
                              initialValue: '',
                              onChanged: (value) {},
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  // filled: true,

                                  // border: InputBorder.none,
                                  hintText: "From",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xffEEEEEE)),
                              height: 20,
                              width: 20,
                              child: ImageIcon(
                                AssetImage(
                                  'assets/images/swap2.png',
                                ),
                                size: 10,
                              )),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 10, 0),
                            height: 52,
                            width:
                                MediaQuery.of(context).size.width * (25 / 100),
                            child: TextFormField(
                              initialValue: '',
                              onChanged: (value) {},
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  // filled: true,

                                  // border: InputBorder.none,
                                  hintText: "To",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                          // Container(
                          //     margin: EdgeInsets.only(left: 10, top: 15),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(10.0),
                          //         color: Color(0xffEEEEEE)),
                          //     height: 52,
                          //     // width: MediaQuery.of(context).size.width *
                          //     //     (40 / 100),
                          //     child: Image.asset(
                          //       'assets/images/dummy.png',
                          //     )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 15, 5, 0),
                            height: 52,
                            width:
                                MediaQuery.of(context).size.width * (20 / 100),
                            child: TextFormField(
                              initialValue: '',
                              onChanged: (value) {},
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Colors.transparent,
                                  // filled: true,

                                  // border: InputBorder.none,
                                  hintText: "Departure Date",
                                  hintStyle: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, top: 15),
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
                        ],
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * (25 / 100),
                      child: Column(
                        // crossAxisAlignment:
                        //     CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Destination Warehouse",
                                  style: headingStyleNormal(),
                                )),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 5, right: 10, left: 15),
                            width: MediaQuery.of(context).size.width * 5,
                            child: TextFormField(
                              initialValue: "",
                              onChanged: (v) {
                                setState(() {
                                  destiWarehouse = v.toString();
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required*';
                                }
                                return null;
                              },
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    // borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * (25 / 100),
                      child: Column(
                          // crossAxisAlignment:
                          //     CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(top: 15, left: 15, bottom: 5),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "ArrivalManger Warehouse",
                                    style: headingStyleNormal(),
                                  )),
                            ),
                            // Container(
                            //   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            //   child: TypeAheadFormField<ArrivalManagerDetais>(
                            //     validator: (value) {
                            //       if (value!.isEmpty) {
                            //         return 'required';
                            //       }
                            //     },

                            //     hideSuggestionsOnKeyboardHide: false,
                            //     textFieldConfiguration: TextFieldConfiguration(
                            //       controller: this._names,
                            //       onChanged: (value) {
                            //         arrivalManagernames = value;
                            //       },
                            //       decoration: InputDecoration(
                            //           fillColor: Color(0xffF5F6FA),
                            //           filled: true,
                            //           enabledBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(
                            //                 width: 1.2,
                            //                 color: Color(0xffF5F6FA)),
                            //           ),
                            //           focusedBorder: new OutlineInputBorder(
                            //             // borderRadius: new BorderRadius.circular(25.0),
                            //             borderSide: BorderSide(
                            //                 width: 1.2,
                            //                 color: Color(0xffF5F6FA)),
                            //           ),
                            //           errorBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             borderSide: BorderSide(
                            //                 width: 1.2,
                            //                 color: Color(0xffF5F6FA)),
                            //           ),
                            //           focusedErrorBorder: OutlineInputBorder(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             borderSide: BorderSide(
                            //                 width: 1.2,
                            //                 color: Color(0xffF5F6FA)),
                            //           ),
                            //           // border: InputBorder.none,
                            //           hintText: "",
                            //           hintStyle: TextStyle(
                            //               color: Colors.grey, fontSize: 15)),
                            //     ),
                            //     onSuggestionSelected: (managerList) {
                            //       this._names.text =
                            //           managerList.username.toString();
                            //       arrivalManagernames = this.controller.text;
                            //     },
                            //     // print(
                            //     //     'selected: ${managerList.username} ${managerList.address}'),
                            //     suggestionsCallback: (s) => managerList!.where(
                            //         (c) => c.name
                            //             .toLowerCase()
                            //             .contains(s.toLowerCase())),
                            //     itemBuilder: (ctx, managerList) {
                            //       return ListTile(
                            //         title:
                            //             Text(managerList.username.toString()),
                            //         subtitle:
                            //             Text(managerList.address.toString()),
                            //       );
                            //     },
                            //     transitionBuilder:
                            //         (context, suggestionsBox, controller) {
                            //       return suggestionsBox;
                            //     },
                            //     // noItemsFoundBuilder: (context) => Container(
                            //     //   height: 100,
                            //     //   child: Center(
                            //     //     child: Text(
                            //     //       'Do you want to add this name',
                            //     //       style: TextStyle(fontSize: 18),
                            //     //     ),
                            //     //   ),
                            //     // ),
                            //     // onSuggestionSelected: (suggestion) {
                            //     //   this._names.text = suggestion.toString();

                            //     //   arrivalManagerEmail = _names.text;
                            //     //   // getReceptionistData();

                            //     //   // print("universityName $universityName");
                            //     // },
                            //   ),
                            // ),
                          ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        right: 10,
                      ),
                      width: MediaQuery.of(context).size.width * (27 / 100),
                      child: Column(
                        // crossAxisAlignment:
                        //     CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, left: 15, bottom: 5),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Title",
                                  style: headingStyleNormal(),
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            width:
                                MediaQuery.of(context).size.width * (27 / 100),
                            // height: 100,
                            child: TextFormField(
                              maxLength: 120,
                              // maxLines: 2,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(120)
                              ],
                              initialValue: "",
                              onChanged: (v) {
                                setState(() {
                                  scheduleTitle = v.toString();
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty && value.length > 120) {
                                  return "max 120 characters";
                                }
                              },
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 17),
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    // borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "Item type",
                      style: headingStyleNormal(),
                    ),
                  ),
                ),
                (Responsive.isDesktop(context))
                    ? Container(
                        height: (Responsive.isDesktop(context))
                            ? h * 0.08
                            : h * 0.5,
                        width:
                            (Responsive.isDesktop(context)) ? w * 0.8 : w * 0.9,
                        child: Scrollbar(
                          child: ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: scheduleItemlist?.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  // selected = [];
                                  if (!selected.contains(itemNames[index])) {
                                    // item123!.add(scheduleItemlist![index].items);
                                    item123.add(
                                        scheduleItemlist![index].items ?? []);
                                    selected.add(itemNames[index]);
                                    var itemtextEditingController =
                                        TextEditingController(text: '');
                                    _itemTypecontrollr
                                        .add(itemtextEditingController);
                                    itemTypeListModel.add(
                                        ShowScheduleItemsModelData(
                                            categoryName: itemNames[index],
                                            id: 0,
                                            icon: iconlist[index]
                                            // category: itemNames[index],
                                            // item: '',
                                            // pickupFee: 0,
                                            // quantity: 0,
                                            // shippingFee: 0
                                            ));
                                  } else {
                                    itemTypeListModel.remove(index);

                                    _itemTypecontrollr.remove(index);
                                    selected.remove(itemNames[index]);
                                    item123.remove(index);
                                  }

                                  print(jsonEncode(itemTypeListModel));
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 15, 0, 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: selected.contains(itemNames[index])
                                          ? Color(0xff1A494F)
                                          : Color(0xffEFEFEF)),
                                  // height: 45,
                                  // width: (!Responsive.isDesktop(context))
                                  //     ? MediaQuery.of(context).size.width * 0.20
                                  //     : w * 0.10,
                                  // color: Colors.lime,
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Center(
                                      child: Text(
                                        scheduleItemlist![index]
                                            .categoryName
                                            .toString(),
                                        style: TextStyle(
                                          color: selected
                                                  .contains(itemNames[index])
                                              ? Color(0xffFFFFFF)
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container(
                        height: (Responsive.isDesktop(context))
                            ? h * 0.08
                            : h * 0.1,
                        width: (Responsive.isDesktop(context)) ? w * 0.8 : w,
                        child: Scrollbar(
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: itemList.length,
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 2,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (!selected.contains(itemList[index])) {
                                    selected.add(itemList[index]);
                                  } else {
                                    selected.remove(itemList[index]);
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: selected.contains(itemList[index])
                                          ? Color(0xff1A494F)
                                          : Color(0xffEFEFEF)),
                                  height: 45,
                                  width: (!Responsive.isDesktop(context))
                                      ? MediaQuery.of(context).size.width * 0.15
                                      : MediaQuery.of(context).size.width *
                                          0.08,
                                  // color: Colors.lime,
                                  child: Center(
                                    child: Text(
                                      itemList[index],
                                      style: TextStyle(
                                        color:
                                            selected.contains(itemList[index])
                                                ? Color(0xffFFFFFF)
                                                : Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                (Responsive.isDesktop(context))
                    ? Container(
                        height: h * 0.6,
                        child: GridView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          // scrollDirection: Axis.horizontal,
                          itemCount: selected.length,
                          shrinkWrap: true,

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
                            return formTypes(
                                title: selected[index], index: index);
                          },
                        ),
                      )
                    : Container(
                        height: h * 0.3,
                        width: w,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          itemCount: selected.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return formTypes(
                                title: selected[index], index: index);
                          },
                        ),
                      )
              ],
            )));
  }

  Widget formTypes({title, index}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, left: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xffFFFFFF),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    itemTypeListModel[index].categoryName.toString() + " Type",
                    style: headingStyleNormal(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  // width: 500,
                  // height: 40,
                  margin: EdgeInsets.only(left: 16, right: 10),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          new Expanded(
                            child: new TextFormField(
                              enabled: false,
                              onChanged: (value) {
                                var itemtextEditingController =
                                    TextEditingController(
                                        text: value.toString());
                                _itemTypecontrollr[index] =
                                    itemtextEditingController;
                              },
                              controller: _itemTypecontrollr[index],
                            ),
                          ),
                          new PopupMenuButton<String>(
                            icon: const Icon(Icons.arrow_drop_down),
                            onSelected: (String value) {
                              category = value;
                              _itemTypecontrollr[index].text = value;
                              print(_itemTypecontrollr[index].text);

                              itemTypeListModel[index].item = value;
                              // print(jsonEncode(itemTypeListModel));
                            },
                            itemBuilder: (BuildContext context) {
                              return item123[index].map((Items value) {
                                return new PopupMenuItem(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (90 / 100),
                                        child: new Text(
                                            value.itemName.toString())),
                                    value: value.itemName.toString());
                              }).toList();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Shipping Fee",
                    style: headingStyleNormal(),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  initialValue: "",
                  autofocus: false,
                  onChanged: (v) {
                    setState(() {
                      itemTypeListModel[index].shippingFee = int.parse(v);
                      // userEmail = v.toLowerCase();
                    });
                  },
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffEFEFEF),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      // border: InputBorder.none,
                      hintText: "",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //     margin: EdgeInsets.only(top: 10, left: 10),
              //     child: Text(
              //       "Pickup Fee",
              //       style: headingStyleNormal(),
              //     ),
              //   ),
              // ),
              // Container(
              //   height: 40,
              //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //   child: TextFormField(
              //     initialValue: "",
              //     autofocus: false,
              //     onChanged: (v) {
              //       setState(() {
              //         // userEmail = v.toLowerCase();
              //       });
              //     },
              //     style: TextStyle(color: Colors.black54, fontSize: 17),
              //     decoration: InputDecoration(
              //         fillColor: Color(0xffEFEFEF),
              //         filled: true,
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
              //         ),
              //         focusedBorder: new OutlineInputBorder(
              //           // borderRadius: new BorderRadius.circular(25.0),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
              //         ),
              //         focusedErrorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
              //         ),
              //         // border: InputBorder.none,
              //         hintText: "",
              //         hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  child: Text(
                    "Number of" + " $title",
                    style: headingStyleNormal(),
                  ),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                child: TextFormField(
                  initialValue: "",
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  autofocus: false,
                  onChanged: (v) {
                    setState(() {
                      itemTypeListModel[index].quantity = int.parse(v);
                    });
                  },
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffEFEFEF),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffEFEFEF)),
                      ),
                      // border: InputBorder.none,
                      hintText: "",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        if (index == 0)
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                scheduleShipmentApicall();
              }
            },
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff1F2326)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.all(15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Schedule Shipment",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )))),
                    Container(
                      margin: EdgeInsets.only(top: 15, right: 10),
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/images/arrow-right.png'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
