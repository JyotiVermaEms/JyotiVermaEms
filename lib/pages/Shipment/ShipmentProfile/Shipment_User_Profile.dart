// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/indicator.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ResShipmentadd_Company.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Profile.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:http/http.dart' as http;
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/subscriptionScreen.dart';
import 'package:shipment/pages/Shipment/Dashboard/Shipment_Dashboard.dart';
import '../../../constants.dart';

import 'dart:html' as html;

import 'package:flutter/foundation.dart' show kIsWeb;

class UserProfileShipment extends StatefulWidget {
  const UserProfileShipment({Key? key}) : super(key: key);

  @override
  _UserProfileShipmentState createState() => _UserProfileShipmentState();
}

class _UserProfileShipmentState extends State<UserProfileShipment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var exp = true, openSUBMENU = false;
  int touchedIndex = -1;
  String imagepath = '';
  Image? image;
  PlatformFile? objFile = null;
  bool isProcess = false;

  Widget pieChart() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 28,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: const Color(0xff0293ee),
                  text: 'One',
                  isSquare: false,
                  size: touchedIndex == 0 ? 18 : 16,
                  textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xfff8b250),
                  text: 'Two',
                  isSquare: false,
                  size: touchedIndex == 1 ? 18 : 16,
                  textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff845bef),
                  text: 'Three',
                  isSquare: false,
                  size: touchedIndex == 2 ? 18 : 16,
                  textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff13d38e),
                  text: 'Four',
                  isSquare: false,
                  size: touchedIndex == 3 ? 18 : 16,
                  textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      startDegreeOffset: 180,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: 0,
                      sections: showingSections()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        final color0 = const Color(0xff0293ee);
        final color1 = const Color(0xfff8b250);
        final color2 = const Color(0xff845bef);
        final color3 = const Color(0xff13d38e);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color0, width: 6)
                  : BorderSide(color: color0.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color1, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? BorderSide(color: color2, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3.withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? BorderSide(color: color3, width: 6)
                  : BorderSide(color: color2.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }

  bool onEdit = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController languagectrl = TextEditingController();

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

  List getSuggestions(String query) {
    List matches = [];
    matches.addAll(_countries);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> language = [
    'English',
    'Chinese',
    'Spanish',
    'Arabic',
    'Hindi',
    'Bengali',
    'Portuguese',
    'Russian',
    'German',
    'Japanese',
    'Javanese',
    'Lahnda',
    'Vietnamese',
    'Urdu',
    'Germany',
    'Urdu',
    'Urdu',
  ];

  List getSuggestions2(String query) {
    List matches = [];
    matches.addAll(language);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  String _fileName = "";
  _imgFromGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _fileName = image!.path.split('/').last;
      imagepath = image.path;
      // objFile = image;
      ;
    });
    print("ImagePath>>>>>>>>>>>" + imagepath);
    print("ImagePath>>>>>>>>>>>" + _fileName);
  }

  void _showPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                        chooseFileUsingFilePicker(context);
                        setState(() {});
                      },
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                chooseFileUsingFilePicker(context);
                                setState(() {});
                              },
                              child: Icon(Icons.camera)),
                          // SizedBox(width: 5),
                          Spacer(),
                          Text('Take a picture'),
                          SizedBox(width: 50),
                          // InkWell(
                          //     onTap: () {
                          //       Navigator.pop(context);
                          //     },
                          //     child: Icon(Icons.cancel)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget container_client() {
    return Container(
      height: h,
      width: w * 0.72,
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
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text("Update Profile",
                            style: headingStyle18SBblack())),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Icon(
                          Icons.close,
                          color: Color(0xffC4C4C4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text("Name", style: headingStyle16SB())),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  // width: 500,
                  child: TextFormField(
                    initialValue: "$name", // autofocus: false,
                    // maxLines: 3,
                    inputFormatters: [
                      // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
                    ],
                    onChanged: (v) {
                      updatedName = v;
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
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text("Last Name", style: headingStyle16SB())),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  // width: 500,
                  child: TextFormField(
                    initialValue: "$lname", // autofocus: false,
                    // maxLines: 3,
                    inputFormatters: [
                      // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z -]"))
                    ],
                    onChanged: (v) {
                      updatedLName = v;
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
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //       margin: EdgeInsets.only(left: 15, top: 10),
              //       child: Text("Profile ", style: headingStyle16SB())),
              // ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Container(
              //     margin: EdgeInsets.only(left: 15, top: 10),
              //     // width: 500,
              //     child: TextFormField(
              //       initialValue: "", // autofocus: false,
              //       // maxLines: 3,
              //       onChanged: (v) {
              //         updatedProfile = v;
              //       },
              //       style: TextStyle(color: Colors.black54, fontSize: 17),
              //       decoration: InputDecoration(
              //           fillColor: Color(0xffF5F6FA),
              //           filled: true,
              //           enabledBorder: OutlineInputBorder(
              //             borderSide:
              //                 BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //           ),
              //           focusedBorder: new OutlineInputBorder(
              //             // borderRadius: new BorderRadius.circular(25.0),
              //             borderSide:
              //                 BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //           ),
              //           errorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(4)),
              //             borderSide:
              //                 BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //           ),
              //           focusedErrorBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(4)),
              //             borderSide:
              //                 BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //           ),
              //           // border: InputBorder.none,
              //           hintText: "Profile",
              //           hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text("Mobile Number", style: headingStyle16SB())),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  // width: 500,
                  child: TextFormField(
                    initialValue: "$mobileNumber", // autofocus: false,
                    // maxLines: 3,
                    inputFormatters: [
                      // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10)
                    ],
                    onChanged: (v) {
                      updatedNumber = v;
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
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text("Email", style: headingStyle16SB())),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  // width: 500,
                  child: TextFormField(
                    enabled: false,

                    initialValue: "$email", // autofocus: false,
                    // maxLines: 3,
                    onChanged: (v) {
                      // updatedEmail = v;
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
                        hintText: "Shishank.barua@gmail.com",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text(
                    "Country",
                    style: headingStyle16SB(),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("Language", style: headingStyle16SB()),
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("About Me", style: headingStyle16SB()),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  // width: 500,
                  child: TextFormField(
                    initialValue: "$aboutMe", // autofocus: false,
                    maxLines: 5,
                    onChanged: (v) {
                      updatedAboutMe = v;
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
                        hintText: "about me",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  updateProfileApi();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xff1A494F)),
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ),
            ],
          )),
    );
  }

  var date, planid;

  var name,
      email,
      mobileNumber,
      languages,
      country,
      profileImage,
      username,
      address1,
      companyname,
      lname,
      aboutMe;
  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedEmail,
      updatedPhone,
      updatedCountry,
      updatedcompanyname,
      updatedAddress,
      updatedAboutMe,
      updatedLName,
      updateLanguauge,
      docs,
      drivingLicence,
      taxDocs;

  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentProfile();
    if (response.status == true) {
      setState(() {
        aboutMe = response.data[0].about_me;
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
        username = response.data[0].username;
        address1 = response.data[0].address;
        companyname = response.data[0].companyname;
        docs = response.data[0].docs;
        drivingLicence = response.data[0].drivingLicence;
        taxDocs = response.data[0].taxDocs;
        date = response.data[0].expireDate;
        planid = response.data[0].planId;
      });
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // if (prefs.getString('Shipemnt_auth_token') == null) {
      // } else {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setInt('plan_id', planid);
      //   prefs.setString('expiry_date', date);
      //   final now = DateTime.now();
      //   final expirationDate = DateTime(2022, 05, 05);

      //   print("AAAAAAAAAA$expirationDate");
      //   final bool isExpired = expirationDate.isBefore(now);
      //   print("hjjhjhjhjhjj$isExpired");

      //   if (planid == 0 ||
      //       response.data[0].expireDate.isEmpty ||
      //       isExpired == true) {
      //     Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN);
      //   } else {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ResDashboardshipment()),
      //     );
      //   }
      // }
      // if (response.data[0].expireDate.isEmpty ) {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => SubscriptionScreen()));
      // } else {
      //   final now = DateTime.now();
      //   final expirationDate = DateFormat('dd-MM-yyyy').parse(date);

      //   print("AAAAAAAAAA$expirationDate");
      //   final bool isExpired = expirationDate.isBefore(now);
      //   print("hjjhjhjhjhjj$isExpired");
      //   if (isExpired == false) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => SubscriptionScreen()),
      //     );
      //     // Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN2);
      //   } else {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => ResDashboardshipment()),
      //     );
      //   }
      // }

      print("-======= $taxDocs");
      print("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLName == null ? "$lname" : "$updatedLName",
      "email": "$email",
      "phone": updatedNumber == null ? mobileNumber : updatedNumber,
      "country": updatedCountry == null ? "$country" : "$updatedCountry",
      "address": updatedAddress == null ? "$address1" : "$updatedAddress",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge",
      "companyname":
          updatedcompanyname == null ? "$companyname" : "$updatedcompanyname"
    };
    var response = await Providers().updateShipment(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
        address1 = response.data[0].address;
        companyname = response.data[0].companyname;
      });

      log("REPONSE" + jsonEncode(response.data));

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResShipmentProfile()));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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

  void chooseFileUsingFilePicker(BuildContext context) async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
        withReadStream:
            true, // this will return PlatformFile object with read stream
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      // setState(() async {
      objFile = result.files.single;
      print("objFILE  $objFile");

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
      );
      //-----add other fields if needed
      // request.fields["id"] = "abc";

      //-----add selected file with request
      request.files.add(new http.MultipartFile(
          "file", objFile!.readStream!, objFile!.size,
          filename: objFile!.name));

      //-------Send request
      var resp = await request.send();
      print("resp  >>>>>>>>>>>>>>..$resp");

      //------Read response
      var result2 = await resp.stream.bytesToString();

      print(result2);
      var temp3 = ImageModel.fromJson(json.decode(result2));

      // temp2!.add(temp3);
      print("object  ${json.encode(temp3)}");
      setState(() {
        imagepath = temp3.data[0].image;

        updateProfileApi();
      });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");
      // itemList[index].imageList!.add(result2.toString());

      //-------Your response
      // print(result2);
      // });
    }
  }

  void FilePicker2(BuildContext context, type) async {
    //-----pick file by file picker,

    var result = await FilePicker.platform.pickFiles(
      withReadStream:
          true, // this will return PlatformFile object with read stream
      type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc', 'csv'],
    );
    if (result != null) {
      // setState(() async {
      objFile = result.files.single;
      print("objFILE  $objFile");

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
      );
      //-----add other fields if needed
      // request.fields["id"] = "abc";

      //-----add selected file with request
      request.files.add(new http.MultipartFile(
          "file", objFile!.readStream!, objFile!.size,
          filename: objFile!.name));

      //-------Send request
      var resp = await request.send();
      print("resp  >>>>>>>>>>>>>>..$resp");

      //------Read response
      var result2 = await resp.stream.bytesToString();

      print(result2);
      var temp3 = ImageModel.fromJson(json.decode(result2));

      // temp2!.add(temp3);
      print("object  ${json.encode(temp3)}");
      setState(() {
        imagepath = temp3.data[0].image;
      });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");

      // if(type == "doc"){
      //   updateDocApi(imagepath);
      // }else if(type == "drive"){
      //   updateDocApi(imagepath);
      // } else if (type == "taxtDoc") {
      //   updateDocApi(imagepath);
      // }

      updateDocApi(imagepath, type);
    }
  }

  Future updateDocApi(imageUrl, type) async {
    print("updateDocApi type $type");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var loginUserToken = prefs.getString('Shipemnt_auth_token');
    var udpateData = {"file": imageUrl, "token": loginUserToken};
    print("-=-= udpateData $udpateData");
    var response;
    if (type == "doc") {
      response = await Providers().updateDoc(udpateData);
    } else if (type == "drive") {
      response = await Providers().updateDriveDoc(udpateData);
    } else if (type == "taxtDoc") {
      response = await Providers().updateTaxDoc(udpateData);
    }

    if (response.status == true) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResShipmentProfile()));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
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
                color: Color(0xffE5E5E5),
                child: SafeArea(
                    right: false,
                    child: ListView(children: [
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
                            // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        Column(
                          children: [
                            profileView(),
                            Row(
                              children: [
                                profileDetails(),
                                // viewPieChart(),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Document',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Row(
                              //                 docs=response.data[0].docs;
                              // drivingLicence = response.data[0].drivingLicence;
                              // taxDocs= response.data[0].taxDocs;
                              children: [
                                i9FOrm(docs),
                                drivingLicenses(drivingLicence),
                                taxDocument(taxDocs)
                              ],
                            )
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment,
                          children: [
                            profileView(),
                            Align(
                                alignment: Alignment.topLeft,
                                child: profileDetails()),
                            // viewPieChart()
                          ],
                        ),
                      if (Responsive.isTablet(context))
                        Column(
                          children: [
                            profileView(),
                            profileDetails(),
                            // viewPieChart()
                          ],
                        ),
                    ])),
              ));
  }

  Widget profileView() {
    return Container(
        margin: EdgeInsets.all(15),
        height: 200,
        width: MediaQuery.of(context).size.width * (90 / 100),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Profileback.png"),
                fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 90.0,
                height: 90.0,
                margin: EdgeInsets.only(top: 12),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(200),
                  elevation: 10,
                  child: GestureDetector(
                    onTap: () {
                      print("profileImage $profileImage");
                      profileImage != ''
                          ? showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    child: Image.network(
                                      profileImage,
                                    ),
                                  ),
                                );
                              })
                          : null;
                    },
                    child: Stack(
                      children: [
                        imagepath != ''
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    child: imagepath != ''
                                        ? Image.network((imagepath),
                                            fit: BoxFit.cover)
                                        : Icon(Icons.person)
                                    // Image.asset(
                                    //     "assets/images/user_err.png",
                                    //     fit: BoxFit.cover)

                                    ))
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Container(
                                    height: 100,
                                    width: 100,

                                    // color: Colors.red,
                                    child: profileImage != ''
                                        ? Image.network(profileImage,
                                            fit: BoxFit.cover)
                                        : Icon(
                                            Icons.person,
                                            size: 50,
                                          )
                                    //  Image.asset(
                                    //     "assets/images/user_err.png",
                                    //     fit: BoxFit.cover)

                                    )),
                        Positioned(
                          bottom: 4,
                          right: 0,
                          child: Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle, color: Colors.teal),
                            child: InkWell(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: Icon(Icons.add, color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          margin: EdgeInsets.only(top: 80, bottom: 5, left: 10),
                          child: Text("$name",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 80, bottom: 5, left: 5),
                          child: Text("$lname",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                      ]),
                      Container(
                        margin: EdgeInsets.only(right: 10, left: 10),
                        child: Text("$email",
                            style: TextStyle(
                              color: Color(0xff90A0B7),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget profileDetails() {
    return Container(
        height: MediaQuery.of(context).size.height * (50 / 100),
        // height: 100,
        width: (!Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (90 / 100)
            : MediaQuery.of(context).size.width * (70 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: ListView(
          children: [
            Row(
              children: [
                // MainAxisAlignment:main
                Container(
                  margin: EdgeInsets.only(top: 40, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "$name" + " " + "$lname",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )),
                ),
                Spacer(),

                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResShipmentAdd_Company()));
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.grey,
                      )),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Mobile Number:",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("$mobileNumber",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Email:",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("$email",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("language:",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("$languages",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Country:",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("$country",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("About me:",
                      style: TextStyle(fontSize: 14, color: Colors.black))),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("$aboutMe ",
                      style: TextStyle(fontSize: 14, color: Colors.grey))),
            ),
          ],
        ));
  }

  Widget i9FOrm(fileUrl) {
    return Container(
        height: MediaQuery.of(context).size.height * (30 / 100),
        // height: 100,
        width: (!Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (90 / 100)
            : MediaQuery.of(context).size.width * (20 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Sample Form I-9',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                print("tap");
                print(fileUrl);

                html.AnchorElement anchorElement =
                    html.AnchorElement(href: fileUrl.toString())
                      ..target = '_blank';
                anchorElement.download = fileUrl.toString();
                anchorElement.click();
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xffE5E5E5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Download Document",
                                style: TextStyle(
                                    color: Color(0xff1A494F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)))),
                    Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: 30,
                        ),
                        height: 30,
                        // width: 300,
                        child: Icon(
                          Icons.download_for_offline_outlined,
                          size: 30,
                          color: Color(0xff1A494F),
                        )),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                FilePicker2(context, 'doc');
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff1F2326)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Submit Document",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )))),
                    Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: 30,
                        ),
                        height: 30,
                        // width: 300,
                        child: Icon(
                          Icons.publish_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget drivingLicenses(drivingLicensesFileUrl) {
    return Container(
        height: MediaQuery.of(context).size.height * (30 / 100),
        // height: 100,
        width: (!Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (90 / 100)
            : MediaQuery.of(context).size.width * (20 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Upload Driving Licenses',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(50.0),
            //       color: Color(0xffE5E5E5)),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Container(
            //           margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

            //           // width: MediaQuery.of(context).size.width * 0.8,
            //           // color: Colors.lime,
            //           child: Center(
            //               child: Text("Download Document",
            //                   style: TextStyle(
            //                       color: Color(0xff1A494F),
            //                       fontSize: 16,
            //                       fontWeight: FontWeight.bold)))),
            //       Container(
            //           margin: EdgeInsets.only(
            //             top: 15,
            //             right: 30,
            //           ),
            //           height: 30,
            //           // width: 300,
            //           child: Icon(
            //             Icons.download_for_offline_outlined,
            //             size: 30,
            //             color: Color(0xff1A494F),
            //           )),
            //     ],
            //   ),
            // ),

            InkWell(
              onTap: () {
                FilePicker2(context, 'drive');
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff1F2326)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Submit Document",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )))),
                    Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: 30,
                        ),
                        height: 30,
                        // width: 300,
                        child: Icon(
                          Icons.publish_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget taxDocument(taxDocsUrl) {
    return Container(
        height: MediaQuery.of(context).size.height * (30 / 100),
        // height: 100,
        width: (!Responsive.isDesktop(context))
            ? MediaQuery.of(context).size.width * (90 / 100)
            : MediaQuery.of(context).size.width * (20 / 100),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Upload Tax Document',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xffE5E5E5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      // taxDocsUrl
                      // print("ontap taxDocsUrl $taxDocsUrl");
                      html.AnchorElement anchorElement =
                          html.AnchorElement(href: taxDocsUrl.toString())
                            ..target = '_blank';
                      anchorElement.download = taxDocsUrl.toString();
                      anchorElement.click();
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Download Document",
                                style: TextStyle(
                                    color: Color(0xff1A494F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)))),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: 15,
                        right: 30,
                      ),
                      height: 30,
                      // width: 300,
                      child: Icon(
                        Icons.download_for_offline_outlined,
                        size: 30,
                        color: Color(0xff1A494F),
                      )),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                FilePicker2(context, 'taxtDoc');
              },
              child: Container(
                margin:
                    EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Color(0xff1F2326)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                        // width: MediaQuery.of(context).size.width * 0.8,
                        // color: Colors.lime,
                        child: Center(
                            child: Text("Submit Document",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )))),
                    Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: 30,
                        ),
                        height: 30,
                        // width: 300,
                        child: Icon(
                          Icons.publish_rounded,
                          size: 30,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
