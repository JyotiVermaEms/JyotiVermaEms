// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
// import 'package:dio/dio.dart';
// import 'dart:html';
// import 'dart:io';
import 'package:shipment/Model/Client/ViewBookingModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/indicator.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Res_Client_Profile.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ClientProfile extends StatefulWidget {
  const ClientProfile({Key? key}) : super(key: key);

  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  final TextEditingController mobilecontroller = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  // File? _image;
  Image? image;
  String? imagePath;
  bool isProcess = false;
  List<Data> viewbooking = [];
  var dataMap1 = [];
  var countrycode;
  String filter = 'English';

  var h, w;
  var exp = true, openSUBMENU = false;
  int touchedIndex = -1;

  var name,
      email,
      mobileNumber,
      languages,
      country,
      profileImage,
      address,
      lname,
      username,
      aboutMe;

  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updatedLName;
  String? updateLanguauge;

  getView() async {
    setState(() {
      isProcess = true;
    });
    print('view booking');
    var response = await Providers().getViewBooking();
    if (response.status == true) {
      setState(() {
        viewbooking = response.data;
      });
      for (int i = 0; i < viewbooking.length; i++) {
        dataMap1.add(viewbooking[i].status);
        print("-=-=-=-=-=-===-=$dataMap1");
        // reason = viewbooking[i].reason.toString();
      }
    }
    setState(() {
      isProcess = false;
    });
  }

  Map<String, double> dataMap = {
    "Pending": 5,
    "Acceted": 3,
    "Rejected": 2,
  };

  bool onEdit = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController languagectrl = TextEditingController();

  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getClientProfile();
    if (response.status == true) {
      setState(() {
        aboutMe = response.data[0].aboutMe;
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        address = response.data[0].address;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
        username = response.data[0].username;
      });
      log(">>>>>>>>>>>" + profileImage);
      log("REPONSE" + jsonEncode(response.data));
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
      "phone": updatedNumber == null ? mobileNumber : "$updatedNumber",
      "country":
          updatedCountry == null ? countrycontroller.text : "$updatedCountry",
      "address": updatedAddress == null ? "$address" : "$updatedAddress",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge",
      "username": "$username"
    };
    print(jsonEncode(udpateData));

    var response = await Providers().updateClient(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        address = response.data[0].address;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
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
                        builder: (context) => ResClientProfile()));
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

    // id =   response.user[universityList.indexOf(name)].id
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    getView();
    // updateProfileApi();
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
    'French',
  ];

  List getSuggestions2(String query) {
    List matches = [];
    matches.addAll(language);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  String _fileName = "";
  String imagepath = '';
  PlatformFile? objFile = null;

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

  Widget container_client() {
    return Container(
      height: h,
      width: (Responsive.isDesktop(context)) ? w * 0.72 : w * 2,
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
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Text("Mobile Number", style: headingStyle16SB())),
              ),
              Container(
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.all(10)
                    : EdgeInsets.all(0),
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
                    title: _buildCountryPickerDropdown(sortedByIsoCode: true)),
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
                    onChanged: (v) {},
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
                    child: Text("Address", style: headingStyle16SB())),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  // width: 500,
                  child: TextFormField(
                    initialValue: "$address", // autofocus: false,
                    // maxLines: 3,
                    // inputFormatters: [
                    //   // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   LengthLimitingTextInputFormatter(10)
                    // ],
                    onChanged: (v) {
                      updatedAddress = v;
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
                        hintText: "Address",
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
              Container(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: EasyAutocomplete(
                      suggestions: _countries,
                      controller: this.countrycontroller,
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
                          hintText: "Country",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                      onChanged: (value) {
                        this.countrycontroller.text = value;
                        // fromLocation = this.controller.text;

                        countrycontroller.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: countrycontroller.text.length));
                      },
                      onSubmitted: (value) {
                        this.countrycontroller.text = value;
                        // fromLocation = this.controller.text;
                      })),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("Select Language", style: headingStyle16SB()),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffF5F6FA),
                  border: Border.all(
                    width: 1.2,
                    color: Color(0xffF5F6FA),
                  ),
                ),
                margin: EdgeInsets.only(left: 15, top: 10),
                padding: EdgeInsets.only(left: 5),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter stateSetter) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      // hint: Text("selectstatus".tr()),
                      value: filter,

                      // icon: Icon(Icons.arrow_drop_down),
                      // iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                      onChanged: (String? value) {
                        stateSetter(() {
                          filter = value!;
                          updateLanguauge = filter;
                          print("KKKKKKKKKKKKK$updateLanguauge");
                        });

                        // controller1.selection = TextSelection.fromPosition(
                        //     TextPosition(offset: controller1.text.length));
                      },
                      items: <String>[
                        'English',
                        'Chinese',
                        'Spanish',
                        'Arabic',
                        'Hindi',
                        'Bengali',
                        'Portuguese',
                        'Russian',
                        'German',
                        'Japanese'
                            'Lahnda',
                        'Vietnamese',
                        'Urdu',
                        'French',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
                //  SimpleAutoCompleteTextField(
                //     key: key,
                //     controller: languagectrl,
                //     suggestions: language,
                //     decoration: InputDecoration(
                //       fillColor: Color(0xffF5F6FA),
                //       filled: true,
                //       enabledBorder: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                //       ),
                //       hintText: "Select Language",
                //     ),
                //     textChanged: (text) {
                //       languagectrl.text = text;
                //       print("channgedddddd ${languagectrl.text}");
                //       // updateLanguauge = languagectrl.text;

                //       languagectrl.selection = TextSelection.fromPosition(
                //           TextPosition(offset: languagectrl.text.length));
                //     },
                //     clearOnSubmit: false,
                //        submitOnSuggestionTap:
                //       true,
                //     textSubmitted: (text) {
                //       setState(() {
                //         languagectrl.text = text;
                //         print("kkkkkkkkkkkkkkkkkkkkk ${languagectrl.text}");
                //         updateLanguauge = languagectrl.text;

                //       });

                //     })
                //  EasyAutocomplete(
                //     suggestions: language,
                //     controller: this.languagectrl,
                //     decoration: InputDecoration(
                //         fillColor: Color(0xffF5F6FA),
                //         filled: true,
                //         enabledBorder: OutlineInputBorder(
                //           borderSide: BorderSide(
                //               width: 1.2, color: Color(0xffF5F6FA)),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           // borderRadius: new BorderRadius.circular(25.0),
                //           borderSide: BorderSide(
                //               width: 1.2, color: Color(0xffF5F6FA)),
                //         ),
                //         errorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(4)),
                //           borderSide: BorderSide(
                //               width: 1.2, color: Color(0xffF5F6FA)),
                //         ),
                //         focusedErrorBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(4)),
                //           borderSide: BorderSide(
                //               width: 1.2, color: Color(0xffF5F6FA)),
                //         ),
                //         // border: InputBorder.none,
                //         hintText: "Select Language",
                //         hintStyle:
                //             TextStyle(color: Colors.grey, fontSize: 15)),
                //     onChanged: (value) {
                //       this.languagectrl.text = value;
                //       updateLanguauge = this.languagectrl.text;

                //       languagectrl.selection = TextSelection.fromPosition(
                //           TextPosition(offset: languagectrl.text.length));
                //     },
                //     onSubmitted: (value) {
                //       this.languagectrl.text = value;
                //       updateLanguauge = this.languagectrl.text;
                //     })
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

  void _showPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              chooseFileUsingFilePicker(context);
                              setState(() {});
                            },
                            child: Icon(Icons.camera)),
                        SizedBox(width: 5),
                        Text('Take a picture'),
                        SizedBox(width: 50),
                        // InkWell(
                        //     onTap: () {
                        //       Navigator.pop(context);
                        //     },
                        //     child: Icon(Icons.cancel)),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  void uploadSelectedFile(image) async {
    //---Create http package multipart request object
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

    //------Read response
    String result = await resp.stream.bytesToString();

    //-------Your response
    print(result);
  }

  List<ImageModel>? temp2;
  // var displayImage;
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

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: SideBar(),
        ),
        body: isProcess == true
            ? Container(child: Center(child: CircularProgressIndicator()))
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
                                      : Icon(Icons.person,
                                          color: Colors.black, size: 60
                                          // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                          ),
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
                                          color: Colors.black,
                                          size: 60,
                                          // Announced in accessibility modes (e.g TalkBack/VoiceOver). This label does not show in the UI.
                                        ),
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
                    // setState(() {
                    //   onEdit = true;
                    // });
                    showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.only(
                                left:
                                    (Responsive.isDesktop(context)) ? 100 : 10,
                                // top: 250,
                                top: 80),
                            child: AlertDialog(
                              backgroundColor: Colors.white,
                              content: container_client(),
                            ),
                          );
                        });
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
            // Row(
            //   children: [
            //     Container(
            //       margin: EdgeInsets.only(top: 15, left: 15),
            //       child: Align(
            //           alignment: Alignment.topLeft,
            //           child: Text("Profile:",
            //               style: TextStyle(fontSize: 14, color: Colors.black))),
            //     ),
            //     // Container(
            //     //   margin: EdgeInsets.only(top: 15, left: 5),
            //     //   child: Align(
            //     //       alignment: Alignment.topLeft,
            //     //       child: Text("Professional",
            //     //           style: TextStyle(fontSize: 14, color: Colors.black))),
            //     // ),
            //   ],
            // ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Mobile Number :",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5),
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
                  margin: EdgeInsets.only(top: 20, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Email :",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5),
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
                  margin: EdgeInsets.only(top: 20, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("language :",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5),
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
                  margin: EdgeInsets.only(top: 20, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Country :",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("$country",
                          style: TextStyle(fontSize: 14, color: Colors.black))),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 15, top: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("About me :",
                      style: TextStyle(fontSize: 14, color: Colors.black))),
            ),
            Container(
              height: 200,
              width: 350,
              margin: EdgeInsets.only(left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("$aboutMe ",
                      style: TextStyle(fontSize: 14, color: Colors.black))),
            ),
          ],
        ));
  }

  // Widget viewPieChart() {
  //   return Container(
  //       height: MediaQuery.of(context).size.height * (50 / 100),
  //       // height: 100,
  //       width: (!Responsive.isDesktop(context))
  //           ? MediaQuery.of(context).size.width * (100 / 100)
  //           : MediaQuery.of(context).size.width * (35 / 100),
  //       margin: EdgeInsets.all(15),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         color: Color(0xffFFFFFF),
  //       ),
  //       child: ListView(children: [
  //         Container(
  //           margin: EdgeInsets.only(top: 20, right: 10, left: 15),
  //           child: Align(
  //               alignment: Alignment.topLeft,
  //               child: Text(
  //                 "Transaction history",
  //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  //               )),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: PieChart(
  //             dataMap: dataMap,
  //             animationDuration: Duration(milliseconds: 800),
  //             chartLegendSpacing: 32,
  //             chartRadius: MediaQuery.of(context).size.width / 5.2,
  //             // colorList: colorList,
  //             initialAngleInDegree: 0,
  //             chartType: ChartType.disc,
  //             ringStrokeWidth: 32,
  //             legendOptions: LegendOptions(
  //               showLegendsInRow: false,
  //               legendPosition: LegendPosition.right,
  //               showLegends: true,
  //               // legendShape: _BoxShape.circle,
  //               legendTextStyle: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             chartValuesOptions: ChartValuesOptions(
  //               showChartValueBackground: true,
  //               showChartValues: true,
  //               showChartValuesInPercentage: false,
  //               showChartValuesOutside: false,
  //               decimalPlaces: 1,
  //             ),
  //             // gradientList: ---To add gradient colors---
  //             // emptyColorGradient: ---Empty Color gradient---
  //           ),
  //         )
  //         // pieChart(),
  //       ]));
  // }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    double dropdownButtonWidth = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width * 0.13
        : MediaQuery.of(context).size.width * 0.3;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryCodePicker(
            showDropDownButton: true,
            onChanged: (v) {
              countrycontroller.text = v.name.toString();
              countrycode = country.phoneCode;
            },
            showCountryOnly: false,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ),
        ),
        if (Responsive.isDesktop(context))
          SizedBox(
            width: 8.0,
          ),
        Expanded(
          child: Container(
            // margin: EdgeInsets.all(10),
            child: TextFormField(
              initialValue: "$mobileNumber", // maxLines: 3,
              inputFormatters: [
                // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                FilteringTextInputFormatter.digitsOnly,
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
        )
      ],
    );
  }
}
