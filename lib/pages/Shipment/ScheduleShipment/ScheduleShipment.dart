// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Client/showScheduleItemsModel.dart';
import 'package:shipment/Model/Shipment/getDepatureManagerListModel.dart';
import 'package:shipment/Model/Shipment/getarrivalMangerList.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Schedule_shipment_item.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_AddUser.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/ShipmentCategoryPage.dart';
import 'package:shipment/pages/Shipment/ScheduleShipment/schedulCategory.dart';
import 'package:shipment/pages/Shipment/Settings/AddUser.dart';
import '../../../constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

var bodydata1;

class ScheduleShipment extends StatefulWidget {
  const ScheduleShipment({Key? key}) : super(key: key);

  @override
  _ScheduleShipmentState createState() => _ScheduleShipmentState();
}

class _ScheduleShipmentState extends State<ScheduleShipment>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var h, w;
  TextEditingController datefilter = new TextEditingController();
  TextEditingController dateinput = new TextEditingController();
  TextEditingController dateArrivalinput = new TextEditingController();
  final TextEditingController _names = TextEditingController();
  final TextEditingController _depaturenames = TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();
  var _textFieldController = new TextEditingController();
  var _textFieldController1 = new TextEditingController();
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
  var depatureManagernames = '';
  var valueText = '';
  List<String> valueText1 = [];
  var codeDialog = '';
  // List itemTypeList = [];
  List<ShowScheduleItemsModelData> itemTypeListModel =
      <ShowScheduleItemsModelData>[];
  List<ShowScheduleItemsModelData>? scheduleItemlist;
  var itemNames = [];
  static List<String> attributeList = [];

  String? category, deusename;

  var amount;
  //List<Items>? item123;
  // var item123 = [
  //   "Cargo",
  //   "Air",
  //   "Ship",
  // ];
  List<List<Items>> item123 = [];
  List<ArrivalManagerDetais> managerList = [];
  List<DepatureManagerDetais> depaturemanagerList = [];

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

  List<String> categoryName = [];

  Widget addlist() {
    return ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemCount: categoryName.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            child: Text(categoryName[index]),
          );
        });
  }

  List<String> depmanName = [];
  List<String> arrmanName = [];

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
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: AlertDialog(
              // title: Text(''),
              content: Container(
                height: 140,
                width: 160,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          valueText = value;
                          categoryName.add(value);
                        });
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "itemtype".tr()),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        var temp = value;
                      });
                      valueText1.add(value);
                    },
                    controller: _textFieldController1,
                    decoration: InputDecoration(hintText: "attributes".tr()),
                  ),
                  // FlatButton(
                  //   color: Colors.teal,
                  //   textColor: Colors.white,
                  //   child: Text('add'),
                  //   onPressed: () {
                  //     setState(() {
                  //       addlist();
                  //     });
                  //   },
                  // ),
                ]),
              ),
              actions: <Widget>[
                Container(
                  color: Colors.teal,
                  child: InkWell(
                    // textColor: Colors.white,
                    child: Text(
                      'cancel'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                Container(
                  color: Colors.teal,
                  child: InkWell(
                    child:
                        Text('add'.tr(), style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        addItems();
                        codeDialog = valueText;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<String> nameList = [];
  List<String> emailList = [];

  getArrivalManagerName() async {
    var responce = await Providers().getArrivalManagerlist();
    print("responce.data-=-=-= ${responce.data}");

    setState(() {
      managerList = responce.data;
    });
    for (int i = 0; i < responce.data.length; i++) {
      setState(() {
        arrmanName.add(responce.data[i].name);
      });
    }
    // setState(() {
    //   managerList = responce.data;
    // });
  }

  getDepatureManagerName() async {
    var responce = await Providers().getDepatureManagerlist();
    setState(() {
      depaturemanagerList = responce.data;
    });
    for (int i = 0; i < depaturemanagerList.length; i++) {
      setState(() {
        depmanName.add(depaturemanagerList[i].name);
      });
      // deusename = depaturemanagerList![i].address;
    }
    print("vvbvbvbv" + deusename.toString());
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    getArrivalManagerName();
    getDepatureManagerName();

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
    if (scheduleItemlist!.length > 0) {
      itemTypeListModel.add(ShowScheduleItemsModelData(
        categoryName: scheduleItemlist![0].categoryName,
        id: scheduleItemlist![0].id,
      ));
      selected.add(scheduleItemlist![0].categoryName);
      for (int i = 0; i < scheduleItemlist!.length; i++) {
        itemNames.add(scheduleItemlist![i].categoryName);
        // iconlist.add(scheduleItemlist![i].icon);
      }
      item123.add(scheduleItemlist![0].items ?? []);
    }

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
      "arrival_date": dateArrivalinput.text,
      "departure_warehouse": depatureManagernames,
      "destination_warehouse": arrivalManagernames,
      "item_type": jsonEncode(itemTypeListModel)
    };

    print(" body Data >>>>>>>>>>>>>>>>>>>>>>>${jsonEncode(bodydata)}");
    var loginshipment = await Providers().scheduleShipmentApi(bodydata);
    if (loginshipment.status == true) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ResScheduleShipment()));
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(loginshipment.message.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD),
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

  addItems() async {
    var data = {"category": "$valueText", "item_name": jsonEncode(valueText1)};

    print(jsonEncode(data));

    var respo = await Providers().addItem(data);
    print("shishank");
    if (respo.status == true) {}
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
        child: ShipmentSidebar(),
      ),
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              height: h,
              color: Color(0xffF5F6F8),
              child: SafeArea(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                            margin: EdgeInsets.fromLTRB(5, 10,
                                (Responsive.isDesktop(context)) ? 50 : 10, 0),
                            child: Row(
                              children: [
                                Text(
                                  'scheduleshipment'.tr(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    shipmentType2(),
                  ],
                ),
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
                onFieldSubmitted: (value) {},
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {},
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
                "chooseyourshipmenttype".tr(),
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
                                          "plane".tr(),
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
                                      )),
                                      Container(
                                        child: Text(
                                          "boat".tr(),
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
                                          "road".tr(),
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
              child: TabBarView(
                  // physics: Responsive.isDesktop(context)? NeverScrollableScrollPhysics():
                  controller: _controller,
                  children: <Widget>[
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
        height: h,
        decoration: BoxDecoration(
          // border
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
                      Container(
                        margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width * (35 / 100),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(width: 1.2, color: Colors.white),

                            color: Colors.transparent,
                            // borderSide: BorderSide(
                            //         width: 1.2,
                            //         color: Colors.white,
                            //       ),
                          ),
                          child: ListTile(
                              title: _buildCountryPickerDropdown(
                                  sortedByIsoCode: true)),
                        ),
                        // SearchField(
                        //   onSubmit: (x) {
                        //     this.controller.text = x;
                        //     fromLocation = this.controller.text;

                        //     controller.selection = TextSelection.fromPosition(
                        //         TextPosition(offset: controller.text.length));
                        //   },
                        //   suggestions: _countries
                        //       .map((e) => SearchFieldListItem(e))
                        //       .toList(),
                        //   suggestionState: Suggestion.expand,
                        //   textInputAction: TextInputAction.next,
                        //   hint: 'SearchField Example 2',
                        //   hasOverlay: false,
                        //   searchStyle: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.black.withOpacity(0.8),
                        //   ),
                        //   validator: (x) {
                        //     if (!_countries.contains(x) || x!.isEmpty) {
                        //       return 'Please Enter a valid State';
                        //     }
                        //     return null;
                        //   },
                        //   searchInputDecoration: InputDecoration(
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(
                        //         color: Colors.black.withOpacity(0.8),
                        //       ),
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.red),
                        //     ),
                        //   ),
                        //   maxSuggestionsInViewPort: 6,
                        //   itemHeight: 50,
                        //   // onTap: () {},
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 5, top: 15),
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
                        margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width * (35 / 100),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(width: 1.2, color: Colors.white),

                            color: Colors.transparent,
                            // borderSide: BorderSide(
                            //         width: 1.2,
                            //         color: Colors.white,
                            //       ),
                          ),
                          child: ListTile(
                              title: _buildCountryPickerDropdown1(
                                  sortedByIsoCode: true)),
                        ),
                        //  SearchField(
                        //   suggestions: _countries
                        //       .map((e) => SearchFieldListItem(e))
                        //       .toList(),
                        //   suggestionState: Suggestion.expand,
                        //   textInputAction: TextInputAction.next,
                        //   controller: this.controllerTo,
                        //   // hint: 'SearchField Example 2',
                        //   hasOverlay: true,
                        //   searchStyle: TextStyle(
                        //     fontSize: 18,
                        //     color: Colors.black.withOpacity(0.8),
                        //   ),
                        //   validator: (x1) {
                        //     if (!_countries.contains(x1) || x1!.isEmpty) {
                        //       return 'required';
                        //     }
                        //     return null;
                        //   },
                        //   searchInputDecoration: InputDecoration(
                        //       fillColor: Color(0xffF5F6FA),
                        //       filled: true,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //             width: 1.2, color: Color(0xffF5F6FA)),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         // borderRadius: new BorderRadius.circular(25.0),
                        //         borderSide: BorderSide(
                        //             width: 1.2, color: Color(0xffF5F6FA)),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(4)),
                        //         borderSide: BorderSide(
                        //             width: 1.2, color: Color(0xffF5F6FA)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(4)),
                        //         borderSide: BorderSide(
                        //             width: 1.2, color: Color(0xffF5F6FA)),
                        //       ),
                        //       // border: InputBorder.none,
                        //       hintText: "to".tr(),
                        //       hintStyle:
                        //           TextStyle(color: Colors.grey, fontSize: 15)),
                        //   maxSuggestionsInViewPort: 6,
                        //   //itemHeight: 50,

                        //   onSubmit: (x11) {
                        //     this.controllerTo.text = x11;
                        //     toLocation = this.controllerTo.text;
                        //     print("toLocation-=-=-= $toLocation");

                        //     controllerTo.selection = TextSelection.fromPosition(
                        //         TextPosition(offset: controllerTo.text.length));
                        //   },
                        // ),
                      ),
                    ],
                  ),
                // Spacer(),
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                        height: 52,
                        width: (Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (10 / 100)
                            : MediaQuery.of(context).size.width * 0.3,
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
                              hintText: "departuredate".tr(),
                              hintStyle:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          var today = new DateTime.now();
                          var fiftyDaysFromNow =
                              today.add(new Duration(days: 2));

                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(Duration(days: 2)),
                            firstDate: DateTime.now().add(Duration(days: 2)),
                            lastDate: DateTime(2101),
                            // selectableDayPredicate: (DateTime val) =>
                            //     val.weekday == 5 || val.weekday == 6
                            //         ? false
                            //         : true,
                            // initialDate: fiftyDaysFromNow,
                            // firstDate:
                            //     DateTime.now().subtract(Duration(days: 0)),
                            // lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              departureDate = formattedDate;
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
                      SizedBox(
                        width: (Responsive.isDesktop(context)) ? 10 : 0,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: (Responsive.isDesktop(context)) ? 25 : 0),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 15, 5, 0),
                              height: 52,
                              width: (Responsive.isDesktop(context))
                                  ? MediaQuery.of(context).size.width *
                                      (10 / 100)
                                  : MediaQuery.of(context).size.width * 0.3,
                              child: TextFormField(
                                controller: dateArrivalinput,
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
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    // filled: true,

                                    // border: InputBorder.none,
                                    hintText: "arrivaldate".tr(),
                                    hintStyle: TextStyle(
                                        color: Colors.black, fontSize: 15)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                var differenceDay;
                                var birthday;
                                if (dateinput.text.isEmpty) {
                                  differenceDay = 2;
                                  birthday = DateTime.now()
                                      .add(Duration(days: differenceDay));
                                } else {
                                  // print("-=-=departureDate $departureDate");

                                  var selecteDate =
                                      dateinput.text.split('-'); //12
                                  birthday = DateTime(
                                          int.parse(selecteDate[0]),
                                          int.parse(selecteDate[1]),
                                          int.parse(selecteDate[2]))
                                      .add(Duration(days: 2));
                                  print(
                                      "-=-dateinput ${selecteDate[0]} ${selecteDate[1]} ${selecteDate[2]}");
                                  print("-=-birthday $birthday");
                                  final date2 = DateTime.now()
                                      .add(Duration(days: 2)); //10
                                  print("-=-date2 $date2");
                                  differenceDay = 2;
                                  // differenceDay =
                                  // birthday.difference(date2).inDays;
                                  // print("-=-=- $differenceDay");
                                }

                                DateTime? arrivalDate = await showDatePicker(
                                  context: context,
                                  initialDate: birthday,
                                  firstDate: birthday
                                      .subtract(Duration(days: differenceDay)),
                                  lastDate: DateTime(2101),
                                );

                                if (arrivalDate != null) {
                                  print(
                                      arrivalDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                      DateFormat('yyyy-MM-dd')
                                          .format(arrivalDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  //you can implement different kind of Date Format here according to your requirement

                                  setState(() {
                                    dateArrivalinput.text =
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
                            margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                            // height: 50,
                            width:
                                MediaQuery.of(context).size.width * (34 / 100),
                            child: SearchField(
                              suggestions: _countries
                                  .map((e) => SearchFieldListItem(e))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              controller: this.controller,

                              hasOverlay: true,
                              searchStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              validator: (x) {
                                if (!_countries.contains(x) || x!.isEmpty) {
                                  return 'required';
                                }
                                return null;
                              },

                              searchInputDecoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  hintText: "from".tr(),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                              maxSuggestionsInViewPort: 6,
                              // itemHeight: 50,

                              onSubmit: (x) {
                                // print("-=-=-= ${x.searchKey}");
                                this.controller.text = x;
                                fromLocation = this.controller.text;

                                controller.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: controller.text.length));
                              },
                            ),
                          ),
                          Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 15, right: 10),
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
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            // height: 50,
                            width:
                                MediaQuery.of(context).size.width * (35 / 100),
                            child: SearchField(
                              suggestions: _countries
                                  .map((e) => SearchFieldListItem(e))
                                  .toList(),
                              suggestionState: Suggestion.expand,
                              textInputAction: TextInputAction.next,
                              controller: this.controllerTo,
                              // hint: 'SearchField Example 2',
                              hasOverlay: true,
                              searchStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.8),
                              ),
                              validator: (x1) {
                                if (!_countries.contains(x1) || x1!.isEmpty) {
                                  return 'required';
                                }
                                return null;
                              },
                              searchInputDecoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  hintText: "to".tr(),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                              maxSuggestionsInViewPort: 6,
                              //itemHeight: 50,

                              onSubmit: (x11) {
                                this.controllerTo.text = x11;
                                toLocation = this.controllerTo.text;
                                print("toLocation-=-=-= $toLocation");

                                controllerTo.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: controllerTo.text.length));
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                if (!Responsive.isDesktop(context))
                  Container(
                    height: 90,
                    child: Scrollbar(
                      isAlwaysShown: true,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                            // height: 50,
                            width:
                                MediaQuery.of(context).size.width * (45 / 100),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._depaturenames,

                              validator: (x) {
                                if (x!.isEmpty) {
                                  return 'required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  hintText: "departurewarehouse".tr(),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),

                              // itemHeight: 50,
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: "",
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Color(0xff1A494F),
                                ),
                                margin: EdgeInsets.only(left: 10, top: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "assigntodeparturewherehouse".tr(),
                                      softWrap: true,
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onSelected: (String value) {
                              // this._depaturenames.text = value;
                              depatureManagernames = value;
                            },
                            itemBuilder: (BuildContext context) {
                              return depaturemanagerList.map((value) {
                                return new PopupMenuItem(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (90 / 100),
                                        child: new Text(value.name.toString())),
                                    value: value.id.toString());
                              }).toList();
                            },
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                            // height: 50,
                            width:
                                MediaQuery.of(context).size.width * (45 / 100),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              controller: this._names,
                              // hint: 'SearchField Example 2',

                              validator: (x1) {
                                if (x1!.isEmpty) {
                                  return 'required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.2, color: Color(0xffF5F6FA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  hintText: "arrivalwarehouse".tr(),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: "",
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    color: Color(0xff1A494F)),
                                margin: EdgeInsets.only(left: 10, top: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      "assigntoarrivalwherehouse".tr(),
                                      softWrap: true,
                                      // overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            onSelected: (String value) {
                              // this._names.text = value;
                              arrivalManagernames = value;
                            },
                            itemBuilder: (BuildContext context) {
                              return managerList.map((value) {
                                return new PopupMenuItem(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                (90 / 100),
                                        child: new Text(value.name.toString())),
                                    value: value.id.toString());
                              }).toList();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                if (Responsive.isDesktop(context))
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: this._depaturenames,

                          validator: (x) {
                            if (x!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Color(0xffF5F6FA),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.2, color: Color(0xffF5F6FA)),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                              hintText: "Departure Warehouse",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),

                          // itemHeight: 50,
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: "",
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 50,
                            width: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xff1A494F),
                            ),
                            margin: EdgeInsets.only(left: 10, top: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Assign to departure wherehouse",
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onSelected: (String value) {
                          // this._depaturenames.text = value;
                          depatureManagernames = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return depaturemanagerList.map((value) {
                            return new PopupMenuItem(
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        (90 / 100),
                                    child: new Text(value.name.toString())),
                                value: value.id.toString());
                          }).toList();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 20, 0, 0),
                        // height: 50,
                        width: MediaQuery.of(context).size.width * (20 / 100),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: this._names,
                          // hint: 'SearchField Example 2',

                          validator: (x1) {
                            if (x1!.isEmpty) {
                              return 'required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Color(0xffF5F6FA),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.2, color: Color(0xffF5F6FA)),
                              ),
                              focusedBorder: OutlineInputBorder(
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
                              hintText: "Arrival Warehouse",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      PopupMenuButton<String>(
                        tooltip: "",
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 50,
                            width: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Color(0xff1A494F),
                            ),
                            margin: EdgeInsets.only(left: 10, top: 15),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Assign to arrival wherehouse",
                                  softWrap: true,
                                  // overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        onSelected: (String value) {
                          // this._names.text = value;
                          arrivalManagernames = value;
                        },
                        itemBuilder: (BuildContext context) {
                          return managerList.map((value) {
                            return new PopupMenuItem(
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        (90 / 100),
                                    child: new Text(value.name.toString())),
                                value: value.id.toString());
                          }).toList();
                        },
                      ),
                    ],
                  ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        25, 15, (Responsive.isDesktop(context)) ? 0 : 10, 0),
                    height: 52,
                    width: (Responsive.isDesktop(context))
                        ? MediaQuery.of(context).size.width * (60 / 100)
                        : MediaQuery.of(context).size.width,
                    child: TextFormField(
                      initialValue: '',
                      // onChanged: (value) {},
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                      onChanged: (v) {
                        setState(() {
                          scheduleTitle = v.toString();
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        } else if (value.length > 120) {
                          return "max 120 characters";
                        }
                      },
                      // style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffF5F6FA)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffF5F6FA)),
                          ),
                          // border: InputBorder.none,
                          hintText: "entertitle".tr(),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ),

                button()
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
                    selected[index] + " Type",
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
                    "shippingfee".tr(),
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
      ],
    );
  }

  Widget button() {
    return GestureDetector(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            scheduleShipmentApicall();
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          InkWell(
            onTap: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShipmentAddUser()));
            }),
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 40),
              width: (Responsive.isDesktop(context))
                  ? 200
                  : MediaQuery.of(context).size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xff1F2326)),
              child: Container(
                  margin: EdgeInsets.all(15),

                  // width: MediaQuery.of(context).size.width * 0.8,
                  // color: Colors.lime,
                  child: Center(
                      child: Text("addaccount".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )))),
            ),
          ),
          InkWell(
            onTap: (() async {
              // Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 ScheduleCategoryShipmentPage()));
              // return;
              if (_formKey.currentState!.validate()) {
                bodydata1 = {
                  "shipment_type": shipmentTypeText,
                  "title": scheduleTitle,
                  "from": fromLocation,
                  "to": toLocation,
                  "departure_date": dateinput.text,
                  "arrival_date": dateArrivalinput.text,
                  "departure_warehouse": depatureManagernames,
                  "destination_warehouse": arrivalManagernames,
                  "departure_address": _depaturenames.text,
                  "arrival_address": _names.text,
                  // "item_type": jsonEncode(itemTypeListModel)
                };

                if (depatureManagernames.isEmpty) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text("Plese select departure wearhouse"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (arrivalManagernames.isEmpty) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text("pleseselectarrivalwearhouse".tr()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                print("-=-=-= $bodydata1");

                print(_depaturenames.text);
                print("-=-=-=");
                print(_names.text);

                SharedPreferences prefs = await SharedPreferences.getInstance();
                print("-=-=-= ${prefs.getString("companyName")}");

                //return;
                if (prefs.getString("companyName") != "NA") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScheduleCategoryShipmentPage()));
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text("pleaseaddyourcompanydetails".tr()),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.SHIPMENTUPDATEPROFILE);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 40, right: 10),
              width: (Responsive.isDesktop(context))
                  ? 200
                  : MediaQuery.of(context).size.width * 0.4,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xff1F2326)),
              child: Container(
                  margin: EdgeInsets.all(15),

                  // width: MediaQuery.of(context).size.width * 0.8,
                  // color: Colors.lime,
                  child: Center(
                      child: Text("next".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          )))),
            ),
          )
        ]));
  }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    // double dropdownButtonWidth = (Responsive.isDesktop(context))
    //     ? MediaQuery.of(context).size.width * 0.13
    //     : MediaQuery.of(context).size.width * 0.30;
    // //respect dropdown button icon size
    // double dropdownItemWidth = dropdownButtonWidth - 30;
    // double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          child: CountryCodePicker(
            showDropDownButton: true,
            onChanged: (v) {
              controller.text = v.name.toString();
              fromLocation = controller.text;
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
            },
            showFlag: false,
            showOnlyCountryWhenClosed: false,
            showCountryOnly: true,
            // showCountryOnly: true,
            // showOnlyCountryWhenClosed: true,
            // alignLeft: false,
          ),
        ),
        // SizedBox(
        //   width: 8.0,
        // ),
        Expanded(
          child: Container(
            child: TextFormField(
              controller: controller, // maxLines: 3,

              onChanged: (v) {
                this.controller.text = v.toString();
                fromLocation = this.controller.text;
                fromLocation = v;
                controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length));
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              decoration: InputDecoration(
                  fillColor: Color(0xffF5F6FA),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    // borderRadius: new BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  // border: InputBorder.none,
                  hintText: "From",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        )
      ],
    );
  }

  _buildCountryPickerDropdown1({
    bool sortedByIsoCode = false,
  }) {
    // double dropdownButtonWidth = (Responsive.isDesktop(context))
    //     ? MediaQuery.of(context).size.width * 0.13
    //     : MediaQuery.of(context).size.width * 0.30;
    // //respect dropdown button icon size
    // double dropdownItemWidth = dropdownButtonWidth - 30;
    // double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          child: CountryCodePicker(
            showDropDownButton: true,
            onChanged: (v) {
              controllerTo.text = v.name.toString();
              toLocation = controllerTo.text;
            },
            showFlag: false,
            showOnlyCountryWhenClosed: false,
            showCountryOnly: true,
            // showCountryOnly: true,
            // showOnlyCountryWhenClosed: true,
            // alignLeft: false,
          ),
        ),
        // SizedBox(
        //   width: 8.0,
        // ),
        Expanded(
          child: Container(
            child: TextFormField(
              controller: controllerTo, // maxLines: 3,

              onChanged: (v) {
                this.controllerTo.text = v.toString();
                toLocation = this.controller.text;
                controllerTo.selection = TextSelection.fromPosition(
                    TextPosition(offset: controllerTo.text.length));
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              decoration: InputDecoration(
                  fillColor: Color(0xffF5F6FA),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    // borderRadius: new BorderRadius.circular(25.0),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide:
                        BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  ),
                  // border: InputBorder.none,
                  hintText: "To",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        )
      ],
    );
  }
}
