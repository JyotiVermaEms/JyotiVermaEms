import 'dart:developer';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Client/ViewScheduleShipment.dart';
import 'package:shipment/Model/Client/clientNoticationModel.dart';
import 'package:shipment/Model/Client/clientSearchAllModel.dart';
import 'package:shipment/Model/Shipment/shipmentnotificationcountmodel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResClientReview.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/notificationdashboard.dart';
import 'package:shipment/component/Res_Client/Select_Pickup_Dropoff.dart';
import '../../../component/Res_Client/DashboardHome.dart';
import '../../../constants.dart';

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({Key? key}) : super(key: key);

  @override
  _MobileDashboardState createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController datefilter = new TextEditingController();
  final TextEditingController datefilter2 = new TextEditingController();
  TextEditingController edit = new TextEditingController();
  TextEditingController locationto = new TextEditingController();
  TextEditingController locationfrom = new TextEditingController();
  TextEditingController searchDate = new TextEditingController();
  TextEditingController searchArrivalDate = new TextEditingController();

  DateTime? selectedDate = DateTime.now();
  var h, w;
  var exp = true, openSUBMENU = false;
  var load = false;
  var exp2 = -1;
  var closeicon = 1;
  List<ClientNotificationData> notificationData = [];
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

  var searchbar = false;
  bool isProcess = false;
  int? i;
  String dropdownvalue = 'English';
  var items = [
    'English',
    'French',
    'Spanish',
  ];

  // String? from, to;
  DateTime initialDate1 = DateTime.now();
  List<SearchData> searchDataresponse = [];

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate1, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  List<Schedule> scheduleData = [];
  List<String> companyList = [];
  List<AdsData> adsData = [];

  int? count;

  var from, to, title;
  List<String> date = [];
  var filteredNames = [], names = [], itemtype = [];

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate1,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate1)
      setState(() {
        initialDate1 = picked;
        searchDate.text = DateFormat('yyyy-MM-dd').format(picked);
        print("-==-=-=-=-=-==-=-$searchDate.text");

        searchfunction();
      });
  }

  DateTime initialDate2 = DateTime.now();
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked2 = await showDatePicker(
      context: context,
      initialDate: initialDate2,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked2 != null && picked2 != initialDate2)
      setState(() {
        initialDate2 = picked2;
        searchArrivalDate.text = DateFormat('yyyy-MM-dd').format(picked2);

        searchfunction();
      });
  }

  var imgList = [];

  getAdvertisment() async {
    print("getAdvertisment");
    var response = await Providers().getAdvertismentAPI();
    print("response.status -=- ${response.status}");
    if (response.status == true) {
      setState(() {
        adsData = response.data;
      });
      for (int i = 0; i < adsData.length; i++) {
        imgList.add(adsData[i].image);
      }
      print("client add api is calling successfully ${imgList}");
    }
  }

  getNotificationCount() async {
    var response = await Providers().getClientNotificationCount();

    if (response.status == true) {
      setState(() {
        count = response.data.toInt();
      });
      print("clientcountapi is calling successfully");
    }
  }

  getShipmentList() async {
    print("getShipmentList");
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getScheduleShipment();
    print("sssss" + response.toString());
    if (response.status == true) {
      setState(() {
        scheduleData = response.schedule;
      });
    }
    setState(() {
      isProcess = false;
    });
  }

  searchfunction() async {
    var searchData = {
      "from": locationfrom.text == null ? "" : locationfrom.text.toString(),
      "to": locationto == null ? "" : locationto.text.toString(),
      "title": edit.text == null ? "" : edit.text.toString(),
      "date": searchDate.text == null ? "" : searchDate.text.toString(),
      "arrivaldate": searchArrivalDate.text == null
          ? ""
          : searchArrivalDate.text.toString(),
    };

    final response = await Providers().searchClient(searchData);
    print("response.status ${response.status}");
    if (response.status == true) {
      setState(() {
        searchDataresponse = response.data;
        MaterialPageRoute(builder: (context) => bookingDesktopCard());
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

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    getShipmentList();
    getNotificationCount();
    getAdvertisment();

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
    return SafeArea(
      right: false,
      child: (!Responsive.isDesktop(context))
          ? WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                key: _scaffoldKey,
                drawer: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250),
                  child: SideBar(),
                ),
                body: isProcess == true
                    ? Center(child: CircularProgressIndicator())
                    : ListView(children: [
                        Container(
                            padding: EdgeInsets.only(
                                top: kIsWeb ? kDefaultPadding : 0),
                            color: Color(0xffE5E5E5),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      if (!Responsive.isDesktop(context))
                                        IconButton(
                                          icon: Icon(Icons.menu),
                                          onPressed: () {
                                            _scaffoldKey.currentState!
                                                .openDrawer();
                                          },
                                        ),
                                      if (Responsive.isDesktop(context))
                                        SizedBox(width: 5),
                                      Container(
                                        margin: (Responsive.isDesktop(context))
                                            ? EdgeInsets.fromLTRB(20, 10, 5, 0)
                                            : EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        child: Text(
                                          'dashboard'.tr(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Spacer(),
                                      (Responsive.isDesktop(context))
                                          ? topBar()
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const NotificationScreen()),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10,
                                                        top: 15,
                                                        bottom: 5),
                                                    child: Icon(
                                                      Icons.notifications,
                                                      size: 27,
                                                    ),
                                                  ),
                                                  count != null
                                                      ? Positioned(
                                                          top: 14,
                                                          left: 20,
                                                          right: 0,
                                                          child: Icon(
                                                              Icons
                                                                  .fiber_manual_record,
                                                              color: Colors.red,
                                                              size: 12),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                if (!Responsive.isDesktop(context))
                                  mobileTopBar(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: (Responsive.isDesktop(context))
                                          ? EdgeInsets.fromLTRB(25, 20, 0, 0)
                                          : EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      // height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          (25 / 100),
                                      child: SearchField(
                                        suggestions: _countries
                                            .map((e) => SearchFieldListItem(e))
                                            .toList(),
                                        suggestionState: Suggestion.expand,
                                        textInputAction: TextInputAction.next,
                                        controller: locationfrom,

                                        hasOverlay: true,
                                        searchStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        validator: (x) {
                                          if (!_countries.contains(x) ||
                                              x!.isEmpty) {
                                            return 'required';
                                          }
                                          return null;
                                        },

                                        searchInputDecoration: InputDecoration(
                                            fillColor: Color(0xffFFFFFF),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              // borderRadius: new BorderRadius.circular(25.0),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            // border: InputBorder.none,
                                            hintText: "from".tr(),
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                        maxSuggestionsInViewPort: 6,
                                        // itemHeight: 50,

                                        onSubmit: (x) {
                                          // print("-=-=-= ${x.searchKey}");
                                          locationfrom.text = x.toString();
                                          //  from = locationfrom.text;

                                          locationfrom.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: locationfrom
                                                          .text.length));
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: (Responsive.isDesktop(context))
                                          ? EdgeInsets.fromLTRB(25, 20, 0, 0)
                                          : EdgeInsets.fromLTRB(5, 0, 0, 0),
                                      // height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          (25 / 100),
                                      child: SearchField(
                                        suggestions: _countries
                                            .map((e) => SearchFieldListItem(e))
                                            .toList(),
                                        suggestionState: Suggestion.expand,
                                        textInputAction: TextInputAction.next,
                                        controller: locationto,
                                        // hint: 'SearchField Example 2',
                                        hasOverlay: true,
                                        searchStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.8),
                                        ),
                                        validator: (x1) {
                                          if (!_countries.contains(x1) ||
                                              x1!.isEmpty) {
                                            return 'required';
                                          }
                                          return null;
                                        },
                                        searchInputDecoration: InputDecoration(
                                            fillColor: Color(0xffFFFFFF),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              // borderRadius: new BorderRadius.circular(25.0),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1.2,
                                                  color: Color(0xffFFFFFF)),
                                            ),
                                            hintText: "to".tr(),
                                            hintStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15)),
                                        maxSuggestionsInViewPort: 6,

                                        onSubmit: (x11) {
                                          locationto.text = x11.toString();

                                          locationto.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: locationto
                                                          .text.length));
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        searchDate.clear();
                                        searchfunction();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            top: (Responsive.isDesktop(context))
                                                ? 15
                                                : 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Color(0xffEEEEEE)),
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print("GestureDetector");
                                        setState(() {
                                          locationfrom.clear();
                                          locationto.clear();
                                          searchDataresponse.removeLast();
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            top: (Responsive.isDesktop(context))
                                                ? 15
                                                : 0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Color(0xffEEEEEE)),
                                        height: 20,
                                        width: 20,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 100,
                                      width: (Responsive.isDesktop(context))
                                          ? 290
                                          : MediaQuery.of(context).size.width *
                                              0.21,
                                      margin: EdgeInsets.all(8.0),
                                      child: CarouselSlider.builder(
                                        options: CarouselOptions(
                                          height: 100.0,
                                          autoPlay: true,
                                        ),
                                        itemCount: adsData.length,
                                        itemBuilder:
                                            (context, itemIndex, realIndex) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .grey,
                                                                  size: 30,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  // width: double.infinity,
                                                                  width: (Responsive
                                                                          .isDesktop(
                                                                              context))
                                                                      ? 350
                                                                      : 230,
                                                                  height: 100,
                                                                  // color: Colors.amber,
                                                                  child: Text(
                                                                    adsData[itemIndex]
                                                                        .title,
                                                                    softWrap:
                                                                        true,
                                                                    maxLines: 3,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Image.network(
                                                                adsData[itemIndex]
                                                                    .image,
                                                                width: 200,
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .cover),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                              height: 100,
                                                              child: Text(
                                                                adsData[itemIndex]
                                                                    .description,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                  adsData[itemIndex].image,
                                                  width: 290,
                                                  height: 1024,
                                                  fit: BoxFit.cover),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (Responsive.isMobile(context))
                                  bookingMobileCard(),
                                if (Responsive.isDesktop(context))
                                  bookingDesktopCard(),
                              ],
                            )),
                      ]),
              ),
            )
          : Scaffold(
              key: _scaffoldKey,
              drawer: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: SideBar(),
              ),
              body: isProcess == true
                  ? Center(child: CircularProgressIndicator())
                  : ListView(children: [
                      Container(
                          padding: EdgeInsets.only(
                              top: kIsWeb ? kDefaultPadding : 0),
                          color: Color(0xffE5E5E5),
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
                                          _scaffoldKey.currentState!
                                              .openDrawer();
                                        },
                                      ),
                                    if (Responsive.isDesktop(context))
                                      SizedBox(width: 5),
                                    Container(
                                      margin: (Responsive.isDesktop(context))
                                          ? EdgeInsets.fromLTRB(20, 10, 5, 0)
                                          : EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Text(
                                        'dashboard'.tr(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Spacer(),
                                    (Responsive.isDesktop(context))
                                        ? topBar()
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NotificationScreen()),
                                              );
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10,
                                                      top: 15,
                                                      bottom: 5),
                                                  child: Icon(
                                                    Icons.notifications,
                                                    size: 27,
                                                  ),
                                                ),
                                                count != null
                                                    ? Positioned(
                                                        top: 14,
                                                        left: 21,
                                                        right: 0,
                                                        child: Icon(
                                                            Icons
                                                                .fiber_manual_record,
                                                            color: Colors.red,
                                                            size: 12),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              if (!Responsive.isDesktop(context))
                                mobileTopBar(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: (Responsive.isDesktop(context))
                                        ? EdgeInsets.fromLTRB(5, 20, 0, 0)
                                        : EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    // height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        (27 / 100),
                                    child: ListTile(
                                      title: _buildCountryPickerDropdown(
                                          sortedByIsoCode: true),
                                    ),
                                    //  SearchField(
                                    //   suggestions: _countries
                                    //       .map((e) => SearchFieldListItem(e))
                                    //       .toList(),
                                    //   suggestionState: Suggestion.expand,
                                    //   textInputAction: TextInputAction.next,
                                    //   controller: locationfrom,

                                    //   hasOverlay: true,
                                    //   searchStyle: TextStyle(
                                    //     fontSize: 18,
                                    //     color: Colors.black.withOpacity(0.8),
                                    //   ),
                                    //   validator: (x) {
                                    //     if (!_countries.contains(x) ||
                                    //         x!.isEmpty) {
                                    //       return 'required';
                                    //     }
                                    //     return null;
                                    //   },

                                    //   searchInputDecoration: InputDecoration(
                                    //       fillColor: Color(0xffFFFFFF),
                                    //       filled: true,
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       focusedBorder: OutlineInputBorder(
                                    //         // borderRadius: new BorderRadius.circular(25.0),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       errorBorder: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(4)),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       focusedErrorBorder:
                                    //           OutlineInputBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(4)),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       // border: InputBorder.none,
                                    //       hintText: "from".tr(),
                                    //       hintStyle: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 15)),
                                    //   maxSuggestionsInViewPort: 6,
                                    //   // itemHeight: 50,

                                    //   onSubmit: (x) {
                                    //     // print("-=-=-= ${x.searchKey}");
                                    //     locationfrom.text = x.toString();
                                    //     //  from = locationfrom.text;

                                    //     locationfrom.selection =
                                    //         TextSelection.fromPosition(
                                    //             TextPosition(
                                    //                 offset: locationfrom
                                    //                     .text.length));
                                    //   },
                                    // ),
                                  ),
                                  Container(
                                    margin: (Responsive.isDesktop(context))
                                        ? EdgeInsets.fromLTRB(0, 20, 0, 0)
                                        : EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    // height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        (27 / 100),
                                    child: ListTile(
                                      title: _buildCountryPickerDropdown1(
                                          sortedByIsoCode: true),
                                    ),
                                    //  SearchField(
                                    //   suggestions: _countries
                                    //       .map((e) => SearchFieldListItem(e))
                                    //       .toList(),
                                    //   suggestionState: Suggestion.expand,
                                    //   textInputAction: TextInputAction.next,
                                    //   controller: locationto,
                                    //   // hint: 'SearchField Example 2',
                                    //   hasOverlay: true,
                                    //   searchStyle: TextStyle(
                                    //     fontSize: 18,
                                    //     color: Colors.black.withOpacity(0.8),
                                    //   ),
                                    //   validator: (x1) {
                                    //     if (!_countries.contains(x1) ||
                                    //         x1!.isEmpty) {
                                    //       return 'required';
                                    //     }
                                    //     return null;
                                    //   },
                                    //   searchInputDecoration: InputDecoration(
                                    //       fillColor: Color(0xffFFFFFF),
                                    //       filled: true,
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       focusedBorder: OutlineInputBorder(
                                    //         // borderRadius: new BorderRadius.circular(25.0),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       errorBorder: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(4)),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       focusedErrorBorder:
                                    //           OutlineInputBorder(
                                    //         borderRadius: BorderRadius.all(
                                    //             Radius.circular(4)),
                                    //         borderSide: BorderSide(
                                    //             width: 1.2,
                                    //             color: Color(0xffFFFFFF)),
                                    //       ),
                                    //       hintText: "to".tr(),
                                    //       hintStyle: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 15)),
                                    //   maxSuggestionsInViewPort: 6,

                                    //   onSubmit: (x11) {
                                    //     locationto.text = x11.toString();

                                    //     locationto.selection =
                                    //         TextSelection.fromPosition(
                                    //             TextPosition(
                                    //                 offset: locationto
                                    //                     .text.length));
                                    //   },
                                    // ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      searchDate.clear();
                                      searchfunction();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          top: (Responsive.isDesktop(context))
                                              ? 15
                                              : 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Color(0xffEEEEEE)),
                                      height: 20,
                                      width: 20,
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("GestureDetector");
                                      setState(() {
                                        locationfrom.clear();
                                        locationto.clear();
                                        searchDataresponse.removeLast();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          top: (Responsive.isDesktop(context))
                                              ? 15
                                              : 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: Color(0xffEEEEEE)),
                                      height: 20,
                                      width: 20,
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 100,
                                    width: (Responsive.isDesktop(context))
                                        ? 290
                                        : MediaQuery.of(context).size.width *
                                            0.21,
                                    margin: EdgeInsets.all(8.0),
                                    child: CarouselSlider.builder(
                                      options: CarouselOptions(
                                        height: 100.0,
                                        autoPlay: true,
                                      ),
                                      itemCount: adsData.length,
                                      itemBuilder:
                                          (context, itemIndex, realIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons.cancel,
                                                                color:
                                                                    Colors.grey,
                                                                size: 30,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                // width: double.infinity,
                                                                width: (Responsive
                                                                        .isDesktop(
                                                                            context))
                                                                    ? 350
                                                                    : 230,
                                                                height: 100,
                                                                // color: Colors.amber,
                                                                child: Text(
                                                                  adsData[itemIndex]
                                                                      .title,
                                                                  softWrap:
                                                                      true,
                                                                  maxLines: 3,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Image.network(
                                                              adsData[itemIndex]
                                                                  .image,
                                                              width: 200,
                                                              height: 200,
                                                              fit:
                                                                  BoxFit.cover),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            height: 100,
                                                            child: Text(
                                                              adsData[itemIndex]
                                                                  .description,
                                                              softWrap: true,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Image.network(
                                                adsData[itemIndex].image,
                                                width: 290,
                                                height: 1024,
                                                fit: BoxFit.cover),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (Responsive.isMobile(context))
                                bookingMobileCard(),
                              if (Responsive.isDesktop(context))
                                bookingDesktopCard(),
                            ],
                          )),
                    ]),
            ),
    );
  }

  Widget topBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (Responsive.isDesktop(context))
            ? Container(
                margin: EdgeInsets.only(top: 20),
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
              )
            : Container(
                margin: EdgeInsets.only(top: 10),
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
                          } else if (dropdownvalue == "Spanish") {
                            context.locale = Locale("es", "US");
                          } else if (dropdownvalue == "French") {
                            context.locale = Locale("fr", "FR");
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
          margin: EdgeInsets.only(bottom: 0, top: 20, left: 20),
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
                print("value -=-= $value");
                if (!value.isEmpty) {
                  searchfunction();
                }
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
                      searchDate.clear();
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
                    print("GestureDetector onPressed");
                    setState(() {
                      getShipmentList();
                      searchDataresponse = [];
                      edit.clear();
                      searchDataresponse.removeLast();
                    });
                  },
                ),
                hintText: "searchhere".tr(),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.black),
              autofocus: true,
              onChanged: (val) {
                // setState(() {
                title = val;
                // });
                if (val.isEmpty) {
                  searchDataresponse = [];
                  getShipmentList();
                }
                print(" title $title");

                // searchfunction();
              },
            ),
          ),
        ),
        Column(children: [
          Container(
            child: Text("depaturedate".tr()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: (Responsive.isDesktop(context))
                  ? 120
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
                      (DateFormat('dd-MM-yyyy')
                          .format(initialDate1)
                          .toString()),
                      style: headingStyle12blacknormal(),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("dome chenges happeeenmnngnmf---=-=--===-=");
                        _selectDate1(context);
                        datefilter.text = (DateFormat('dd-MM-yyyy')
                            .format(initialDate1)
                            .toString());
                        print(datefilter.text);
                      },
                      child: Container(
                        // margin: EdgeInsets.only(left: 45, top: 5),
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
        Column(children: [
          Container(
            child: Text("arrivaldate".tr()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SizedBox(
              width: (Responsive.isDesktop(context))
                  ? 120
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
                      (DateFormat('dd-MM-yyyy')
                          .format(initialDate2)
                          .toString()),
                      style: headingStyle12blacknormal(),
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate2(context);
                        datefilter2.text = (DateFormat('dd-MM-yyyy')
                            .format(initialDate2)
                            .toString());
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DashboardHome()));
              },
              child: Icon(Icons.refresh_sharp, color: Colors.black)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()),
            );
          },
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 15, bottom: 5),
                child: Icon(
                  Icons.notifications,
                  size: 38,
                ),
              ),
              count != null
                  ? Positioned(
                      top: 18,
                      left: 25,
                      right: 0,
                      child: Icon(Icons.fiber_manual_record,
                          color: Colors.red, size: 12),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget mobileTopBar() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 0, top: 0, left: 15),
              height: 48,
              width: w * 0.48,
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
                  right: 5,
                ),
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    print("value -=-= $value");
                    if (!value.isEmpty) {
                      searchfunction();
                    }
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
                          searchDate.clear();
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
                        print("GestureDetector onPressed");
                        setState(() {
                          getShipmentList();
                          searchDataresponse = [];
                          edit.clear();
                          searchDataresponse.removeLast();
                        });
                      },
                    ),
                    hintText: "searchhere".tr(),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 15),
                  autofocus: true,
                  onChanged: (val) {
                    // setState(() {
                    title = val;
                    // });
                    if (val.isEmpty) {
                      searchDataresponse = [];
                      getShipmentList();
                    }
                    print(" title $title");

                    // searchfunction();
                  },
                ),
              ),
            ),
            Container(
              height: 48,
              width: w * 0.43,
              margin: EdgeInsets.only(top: 0, right: 5, bottom: 5),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        } else if (dropdownvalue == "Spanish") {
                          context.locale = Locale("es", "US");
                        } else if (dropdownvalue == "French") {
                          context.locale = Locale("fr", "FR");
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
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Container(
                child: Text("depaturedate".tr()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  width: (Responsive.isDesktop(context))
                      ? 120
                      : MediaQuery.of(context).size.width * (40 / 100),
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.teal, width: 2.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          (DateFormat('dd-MM-yyyy')
                              .format(initialDate1)
                              .toString()),
                          style: headingStyle12blacknormal(),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("dome chenges happeeenmnngnmf---=-=--===-=");
                            _selectDate1(context);
                            datefilter.text = (DateFormat('dd-MM-yyyy')
                                .format(initialDate1)
                                .toString());
                            print(datefilter.text);
                          },
                          child: Container(
                            // margin: EdgeInsets.only(left: 45, top: 5),
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            Column(children: [
              Container(
                child: Text("arrivaldate".tr()),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: SizedBox(
                  width: (Responsive.isDesktop(context))
                      ? 120
                      : MediaQuery.of(context).size.width * (40 / 100),
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.teal, width: 2.0)))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          (DateFormat('dd-MM-yyyy')
                              .format(initialDate2)
                              .toString()),
                          style: headingStyle12blacknormal(),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectDate2(context);
                            datefilter2.text = (DateFormat('dd-MM-yyyy')
                                .format(initialDate2)
                                .toString());
                          },
                          child: Container(
                            // margin: EdgeInsets.only(left: 45, top: 5),
                            height: 20,
                            width: 20,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => DashboardHome()));
                  },
                  child: Icon(Icons.refresh_sharp, color: Colors.black)),
            )
          ],
        )
      ],
    );
  }

  Widget bookingDesktopCard() {
    return ListView.builder(
      itemCount: searchDataresponse.isEmpty
          ? scheduleData.isEmpty
              ? 0
              : scheduleData.length
          : searchDataresponse.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return (scheduleData[index].availableContainer > 0 ||
                (searchDataresponse.isNotEmpty
                    ? searchDataresponse[index].availableContainer > 0
                    : scheduleData[index].availableContainer > 0))
            ? InkWell(
                onTap: () {
                  setState(() {
                    exp2 = index;
                    log("EXP2 >> $exp2");
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),
                  margin: EdgeInsets.only(left: 20, top: 15, right: 10),
                  height: exp2 == index ? h * 0.60 : h * 0.23,
                  width: w,
                  child: Column(
                    children: [
                      exp2 != index
                          ? Column(children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 15,
                                    ),
                                    height: 15,
                                    width: 15,
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 30.0,
                                    ),
                                  ),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 15),
                                      child: Text(
                                          searchDataresponse.length == 0
                                              ? scheduleData[index].companyname
                                              : searchDataresponse[index]
                                                  .companyname,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ))),
                                  InkWell(
                                      onTap: () {
                                        var data = {
                                          "sID": searchDataresponse.length == 0
                                              ? scheduleData[index].sid
                                              : searchDataresponse[index].sid,
                                          "companyName":
                                              searchDataresponse.length == 0
                                                  ? scheduleData[index]
                                                      .companyname
                                                  : searchDataresponse[index]
                                                      .companyname,
                                        };
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClientReviewRes(data)));
                                      },
                                      child: RatingBarIndicator(
                                        rating: double.parse(
                                            searchDataresponse.length == 0
                                                ? (scheduleData[index].rating)
                                                    .toString()
                                                : (searchDataresponse[index]
                                                        .rating)
                                                    .toString()),
                                        direction: Axis.horizontal,
                                        // allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30,
                                        unratedColor:
                                            Colors.black.withAlpha(50),
                                        itemBuilder: (context, index) =>
                                            Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.yellowAccent,
                                          ),
                                        ),
                                      )),
                                  Spacer(),
                                  Column(children: [
                                    Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 10),
                                            child: Text(
                                                "departuredate".tr() + ":",
                                                style: headingStyleNormal())),
                                        Container(
                                            margin: EdgeInsets.only(
                                                right: 15, top: 10, left: 5),
                                            child: Text(
                                              DateFormat("dd-MM-yyyy").format(
                                                DateTime.parse(
                                                  searchDataresponse.length == 0
                                                      ? scheduleData[index]
                                                          .departureDate
                                                      : searchDataresponse[
                                                              index]
                                                          .departureDate,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ])
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 5, top: 10),
                                      child: Text("arrivaldate".tr() + ":",
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(
                                        top: 10,
                                        right: 10,
                                      ),
                                      child: Text(
                                        DateFormat("dd-MM-yyyy").format(
                                          DateTime.parse(
                                            searchDataresponse.length == 0
                                                ? scheduleData[index]
                                                    .arrivalDate
                                                : searchDataresponse[index]
                                                    .arrivalDate,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text("title".tr() + ": ",
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index].title.toString()
                                          : searchDataresponse[index]
                                              .title
                                              .toString())),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 5, top: 10),
                                      child: Text("departurefrom".tr() + ":",
                                          style: headingStyleNormal())),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 20,
                                      top: 10,
                                    ),
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? scheduleData[index].from
                                          : searchDataresponse[index].from,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Text("totalcontainer".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(left: 5, top: 10),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index]
                                              .totalContainer
                                              .toString()
                                          : searchDataresponse[index]
                                              .totalContainer
                                              .toString())),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Text(
                                          "availablespacecontainer".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(left: 5, top: 10),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index]
                                              .availableContainer
                                              .toString()
                                          : searchDataresponse[index]
                                              .availableContainer
                                              .toString())),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 10, right: 5),
                                      child: Text("departureto".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 20,
                                      top: 10,
                                    ),
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? scheduleData[index].to
                                          : searchDataresponse[index].to,
                                    ),
                                  )
                                ],
                              ),
                            ])
                          : Column(children: [
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      height: 15,
                                      width: 15,
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 30.0,
                                      )),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 15),
                                      child: Text(
                                          searchDataresponse.length == 0
                                              ? scheduleData[index].companyname
                                              : searchDataresponse[index]
                                                  .companyname,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ))),
                                  InkWell(
                                      onTap: () {
                                        var data = {
                                          "sID": searchDataresponse.length == 0
                                              ? scheduleData[index].sid
                                              : searchDataresponse[index].sid,
                                          "companyName":
                                              searchDataresponse.length == 0
                                                  ? scheduleData[index]
                                                      .companyname
                                                  : searchDataresponse[index]
                                                      .companyname,
                                        };
                                        print("-=-=- $data");
                                        //return;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ClientReviewRes(data)));
                                      },
                                      child: RatingBarIndicator(
                                        rating: double.parse(
                                            searchDataresponse.length == 0
                                                ? (scheduleData[index].rating)
                                                    .toString()
                                                : (searchDataresponse[index]
                                                        .rating)
                                                    .toString()),
                                        direction: Axis.horizontal,
                                        // allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 30,
                                        unratedColor:
                                            Colors.black.withAlpha(50),
                                        itemBuilder: (context, index) =>
                                            Container(
                                          margin: EdgeInsets.only(top: 15),
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.yellowAccent,
                                          ),
                                        ),
                                      )),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 15, top: 5),
                                      child: Text("departuredate".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(
                                        right: 15,
                                        top: 5,
                                        left: 5,
                                      ),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index].departureDate
                                          : searchDataresponse[index]
                                              .departureDate)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: 5, top: 10),
                                      child: Text("arrivaldate".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      right: 10,
                                    ),
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? scheduleData[index].arrivalDate
                                          : searchDataresponse[index]
                                              .arrivalDate,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Text("title".tr() + ":",
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(
                                        left: 5,
                                      ),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index].title.toString()
                                          : searchDataresponse[index]
                                              .title
                                              .toString())),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(top: 10, right: 5),
                                      child: Text("departurefrom".tr() + ":",
                                          style: headingStyleNormal())),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: 20,
                                      top: 10,
                                    ),
                                    child: Text(
                                      searchDataresponse.length == 0
                                          ? scheduleData[index].from
                                          : searchDataresponse[index].from,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Text("totalcontainer".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(left: 5, top: 10),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index]
                                              .totalContainer
                                              .toString()
                                          : searchDataresponse[index]
                                              .totalContainer
                                              .toString())),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Text(
                                          "availablespacecontainer".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(left: 5, top: 10),
                                      child: Text(searchDataresponse.length == 0
                                          ? scheduleData[index]
                                              .availableContainer
                                              .toString()
                                          : searchDataresponse[index]
                                              .availableContainer
                                              .toString())),
                                  Spacer(),
                                  Container(
                                      margin:
                                          EdgeInsets.only(left: 15, top: 10),
                                      child: Text("departureto".tr(),
                                          style: headingStyleNormal())),
                                  Container(
                                      margin: EdgeInsets.only(
                                          right: 15, top: 10, left: 5),
                                      child: Text(
                                        searchDataresponse.length == 0
                                            ? scheduleData[index].to
                                            : searchDataresponse[index].to,
                                      )),
                                ],
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                    margin: EdgeInsets.only(left: 15, top: 10),
                                    child: Text("availability".tr(),
                                        style: headingStyleBold())),
                              ),
                              GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: searchDataresponse.length == 0
                                      ? scheduleData[index].available.length
                                      : searchDataresponse[index]
                                          .available
                                          .length,
                                  shrinkWrap: true,
                                  // scrollDirection: Axis.horizontal,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisSpacing: 4 / 1,
                                          // crossAxisSpacing: 1,
                                          childAspectRatio: 10 / 1),
                                  itemBuilder: (context, index1) {
                                    return Row(
                                      children: [
                                        Container(
                                            width: 180,
                                            // color: Colors.amber,
                                            margin: EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Text(
                                              scheduleData[index]
                                                  .available[index1]
                                                  .itemName
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Text(
                                              scheduleData[index]
                                                  .available[index1]
                                                  .available
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    );
                                  }),
                              InkWell(
                                onTap: () {
                                  var data = {
                                    "companyName": searchDataresponse.length ==
                                            0
                                        ? scheduleData[index].companyname
                                        : searchDataresponse[index].companyname,
                                    "id": searchDataresponse.length == 0
                                        ? scheduleData[index].id
                                        : searchDataresponse[index].id,
                                    "pickupFee": searchDataresponse.length == 0
                                        ? scheduleData[index]
                                            .itemType[0]
                                            .pickupFee
                                        : searchDataresponse[index]
                                            .itemType[0]
                                            .pickupFee,
                                    "title": searchDataresponse.length == 0
                                        ? scheduleData[index].title
                                        : searchDataresponse[index].title,
                                  };
                                  print("Data??????????????????? $data");

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PickupDrop(data)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 40),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.black),
                                  height: 35,
                                  width: 200,
                                  child: Center(
                                    child: Text("booknow".tr(),
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ])
                    ],
                  ),
                ),
              )
            : SizedBox();
      },
    );
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
              locationfrom.text = v.name.toString();
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
              controller: locationfrom, // maxLines: 3,

              onChanged: (v) {
                locationfrom.text = v.toString();
                //  from = locationfrom.text;

                locationfrom.selection = TextSelection.fromPosition(
                    TextPosition(offset: locationfrom.text.length));
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              decoration: InputDecoration(
                  fillColor: Color(0xffFFFFFF),
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
              locationto.text = v.name.toString();
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
              controller: locationto, // maxLines: 3,

              onChanged: (v) {
                locationto.text = v.toString();
                //  from = locationfrom.text;

                locationto.selection = TextSelection.fromPosition(
                    TextPosition(offset: locationto.text.length));
              },
              style: TextStyle(color: Colors.black54, fontSize: 17),
              decoration: InputDecoration(
                  fillColor: Color(0xffFFFFFF),
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

  Widget bookingMobileCard() {
    return ListView.builder(
      itemCount: searchDataresponse.isEmpty
          ? scheduleData.isEmpty
              ? 0
              : scheduleData.length
          : searchDataresponse.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (scheduleData[index].availableContainer > 0 ||
                (searchDataresponse.isNotEmpty
                    ? searchDataresponse[index].availableContainer > 0
                    : scheduleData[index].availableContainer > 0))
            ? InkWell(
                onTap: () {
                  setState(() {
                    exp2 = index;
                    log("EXP2 >> $exp2");
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffFFFFFF),
                  ),
                  margin: EdgeInsets.only(left: 15, top: 5, right: 15),
                  height: exp2 == index ? h * 0.74 : h * 0.45,
                  width: w,
                  child: exp2 != index
                      ? Column(children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                ),
                                height: 10,
                                width: 10,
                                child: Icon(
                                  Icons.arrow_right,
                                  size: 20.0,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 15),
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData[index].companyname
                                        : searchDataresponse[index].companyname,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )),
                              InkWell(
                                  onTap: () {
                                    var data = {
                                      "sID": searchDataresponse.length == 0
                                          ? scheduleData[index].sid
                                          : searchDataresponse[index].sid,
                                      "companyName":
                                          searchDataresponse.length == 0
                                              ? scheduleData[index].companyname
                                              : searchDataresponse[index]
                                                  .companyname,
                                    };
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientReviewRes(data)));
                                  },
                                  child: RatingBarIndicator(
                                    rating: double.parse(
                                        searchDataresponse.length == 0
                                            ? (scheduleData[index].rating)
                                                .toString()
                                            : (searchDataresponse[index].rating)
                                                .toString()),
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemSize: 20,
                                    unratedColor: Colors.black.withAlpha(50),
                                    itemBuilder: (context, index) => Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.yellowAccent,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("departuredate".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: 15, top: 10, left: 5),
                                  child: Text(
                                    DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                        searchDataresponse.length == 0
                                            ? scheduleData[index].departureDate
                                            : searchDataresponse[index]
                                                .departureDate,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("arrivaldate".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                        searchDataresponse.length == 0
                                            ? scheduleData[index].arrivalDate
                                            : searchDataresponse[index]
                                                .arrivalDate,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("title".tr() + ": ",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index].title.toString()
                                      : searchDataresponse[index]
                                          .title
                                          .toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("departurefrom".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  top: 10,
                                ),
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData[index].from
                                      : searchDataresponse[index].from,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, left: 15),
                                  child: Text("departureto".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                margin: EdgeInsets.only(
                                  right: 20,
                                  top: 10,
                                ),
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData[index].to
                                      : searchDataresponse[index].to,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("totalcontainer".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index]
                                          .totalContainer
                                          .toString()
                                      : searchDataresponse[index]
                                          .totalContainer
                                          .toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("availablespacecontainer".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index]
                                          .availableContainer
                                          .toString()
                                      : searchDataresponse[index]
                                          .availableContainer
                                          .toString())),
                            ],
                          ),
                          Spacer()
                        ])
                      : Column(children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 5,
                                ),
                                height: 10,
                                width: 10,
                                child: Icon(
                                  Icons.arrow_right,
                                  size: 20.0,
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 15),
                                  child: Text(
                                    searchDataresponse.length == 0
                                        ? scheduleData[index].companyname
                                        : searchDataresponse[index].companyname,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    // style: headingStyleNormal()
                                  )),
                              InkWell(
                                  onTap: () {
                                    var data = {
                                      "sID": searchDataresponse.length == 0
                                          ? scheduleData[index].sid
                                          : searchDataresponse[index].sid,
                                      "companyName":
                                          searchDataresponse.length == 0
                                              ? scheduleData[index].companyname
                                              : searchDataresponse[index]
                                                  .companyname,
                                    };
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientReviewRes(data)));
                                  },
                                  child: RatingBarIndicator(
                                    rating: double.parse(
                                        searchDataresponse.length == 0
                                            ? (scheduleData[index].rating)
                                                .toString()
                                            : (searchDataresponse[index].rating)
                                                .toString()),
                                    direction: Axis.horizontal,
                                    // allowHalfRating: true,
                                    itemCount: 5,
                                    itemSize: 20,
                                    unratedColor: Colors.black.withAlpha(50),
                                    itemBuilder: (context, index) => Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.yellowAccent,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("departuredate".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(
                                      right: 15, top: 10, left: 5),
                                  child: Text(
                                    DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                        searchDataresponse.length == 0
                                            ? scheduleData[index].departureDate
                                            : searchDataresponse[index]
                                                .departureDate,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("arrivaldate".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: 10,
                                    right: 10,
                                  ),
                                  child: Text(
                                    DateFormat("dd-MM-yyyy").format(
                                      DateTime.parse(
                                        searchDataresponse.length == 0
                                            ? scheduleData[index].arrivalDate
                                            : searchDataresponse[index]
                                                .arrivalDate,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("title".tr() + ": ",
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index].title.toString()
                                      : searchDataresponse[index]
                                          .title
                                          .toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("departurefrom".tr() + ":",
                                      style: headingStyleNormal())),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 15,
                                  top: 10,
                                ),
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData[index].from
                                      : searchDataresponse[index].from,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, left: 15),
                                  child: Text("departureto".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                margin: EdgeInsets.only(
                                  right: 20,
                                  top: 10,
                                ),
                                child: Text(
                                  searchDataresponse.length == 0
                                      ? scheduleData[index].to
                                      : searchDataresponse[index].to,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("totalcontainer".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index]
                                          .totalContainer
                                          .toString()
                                      : searchDataresponse[index]
                                          .totalContainer
                                          .toString())),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text("availablespacecontainer".tr(),
                                      style: headingStyleNormal())),
                              Container(
                                  margin: EdgeInsets.only(left: 5, top: 10),
                                  child: Text(searchDataresponse.length == 0
                                      ? scheduleData[index]
                                          .availableContainer
                                          .toString()
                                      : searchDataresponse[index]
                                          .availableContainer
                                          .toString())),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text("availability".tr(),
                                    style: headingStyleBold())),
                          ),
                          Container(
                            height: h * 0.2,
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: GridView.builder(
                                  // physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 0.1,
                                          crossAxisSpacing: 0.01,
                                          childAspectRatio: (2 / 1)),
                                  itemCount: searchDataresponse.length == 0
                                      ? scheduleData[index].available.length
                                      : searchDataresponse[index]
                                          .available
                                          .length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index1) {
                                    return Row(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(
                                              left: 15,
                                            ),
                                            // color: Colors.amber,
                                            width: w * 0.27,
                                            child: Text(
                                              scheduleData[index]
                                                  .available[index1]
                                                  .itemName
                                                  .toString(),
                                              style: TextStyle(fontSize: 12),
                                            )),
                                        Container(
                                            width: 35,
                                            // margin: EdgeInsets.only(
                                            //     left: 5,),
                                            // color: Colors.amber,
                                            child: Text(
                                              scheduleData[index]
                                                  .available[index1]
                                                  .available
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            )),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              var data = {
                                "companyName": searchDataresponse.length == 0
                                    ? scheduleData[index].companyname
                                    : searchDataresponse[index].companyname,
                                "id": searchDataresponse.length == 0
                                    ? scheduleData[index].id
                                    : searchDataresponse[index].id,
                                "pickupFee": searchDataresponse.length == 0
                                    ? scheduleData[index].itemType[0].pickupFee
                                    : searchDataresponse[index]
                                        .itemType[0]
                                        .pickupFee,
                                "title": searchDataresponse.length == 0
                                    ? scheduleData[index].title
                                    : searchDataresponse[index].title,
                              };
                              print("Data??????????????????? $data");

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PickupDrop(data)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black),
                              height: 35,
                              width: 200,
                              child: Center(
                                child: Text("booknow".tr(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ]),
                ),
              )
            : SizedBox();
      },
    );
  }
}
