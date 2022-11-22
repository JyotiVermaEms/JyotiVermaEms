import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/customAlertClient.dart';
import 'package:shipment/Model/Client/getViewRecepinstModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResClientReview.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ClinetSubUser_Screen extends StatefulWidget {
  ClinetSubUser_Screen();

  @override
  _ClinetSubUser_ScreenState createState() => _ClinetSubUser_ScreenState();
}

class _ClinetSubUser_ScreenState extends State<ClinetSubUser_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  var h, w;
  var sid, comment, tapped = 0, companyname;
  double? quality, price, support, service, ratings;
  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  final TextEditingController countrycontroller = TextEditingController();
  List<UserData> udata = [];
  var profileexp = -1;
  var timezoneexp = -1;
  var uname = [];
  var ucountry = [];
  var uaddress = [];
  var ulname = [];
  var uphone = [];
  var uemail = [];
  var uprofileImage = [];
  bool isProcess = false;
  var uploadimage;
  var upstatus;
  var countrycode;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  var adduser = -1;
  var status = [];
  var rname,
      rlname,
      remail,
      rpassword,
      rphone,
      raddress,
      rroles,
      rcountry,
      rusername,
      country;
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
  String encodeToSHA3Pass(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  signUpApi() async {
    var data = {
      "username": rusername,
      "name": rname,
      "lname": rlname,
      "email": remail,
      "password": "${encodeToSHA3(rpassword)}",
      "npassword": rpassword,
      "phone": rphone,
      "address": raddress,
      "roles": "",
      "country": countrycontroller.text,
    };
    print(jsonEncode(data));
    var res = await Providers().addReceptionist(data);

    if (res.status == true) {
      showDialog(
          context: context,
          builder: (BuildContext context) => ClientprofileConfirm(data));
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(res.message),
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
    getUsers();
    super.initState();
  }

  Future getUsers() async {
    var response = await Providers().getViewReceptionist();
    if (response.status == true) {
      setState(() {
        udata = response.data;
      });
      for (int i = 0; i < udata.length; i++) {
        uprofileImage.add(udata[i].profileimage);
        uploadimage = udata[i].profileimage.toString();
        upstatus = udata[i].status.toString();
        uname.add(udata[i].name.toString());
        ulname.add(udata[i].lname.toString());
        uemail.add(udata[i].email.toString());
        uphone.add(udata[i].phone.toString());
        ucountry.add(udata[i].country.toString());
        uaddress.add(udata[i].address.toString());
        status.add(udata[i].status.toString());
      }
    }
    print(">>>>>>>>>>>>>>>>>>>>" + upstatus.toString());
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
      body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          height: h,
          color: Color(0xffF5F6F8),
          child: SafeArea(
              child: ListView(
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
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 5),
                      child: Text(
                        'Sub Users',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // if (Responsive.isDesktop(context))
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  // color: Color(0xffFFFFFF),

                  // border: Border.all(width: 0.5, color: Colors.black),

                  // color: Colors.white,
                ),
                child: udata == null
                    ? addUser()
                    : Column(
                        children: [
                          addUser(),
                          userManagement(),
                        ],
                      ),
              ),
            ],
          ))),
    );
  }

  Widget addUser() {
    return InkWell(
      onTap: () {
        setState(() {
          adduser == -1 ? adduser = 0 : adduser = -1;
          log("EXP2 >> $exp2");
          log("checked");
        });
      },
      onDoubleTap: () {
        setState(() {
          adduser = -1;
          log("EXP2 >> $exp2");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          // color: Color(0xffFFFFFF),

          // border: Border.all(width: 0.5, color: Colors.black),

          // color: Colors.white,
        ),
        margin: EdgeInsets.only(right: 10),
        height: adduser == 0 ? h : h * 0.10,
        width: w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              adduser != 0
                  ? Container(
                      decoration: BoxDecoration(
                        // border: Border.all(width: 0.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(10.0),
                        // color: Colors.white,
                      ),
                      margin: EdgeInsets.only(left: 10),
                      height: 60,
                      width: w,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 10),
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.add, color: Colors.white),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Text("Add Account",
                                  style: TextStyle(
                                      color: Color(0xff1A494F),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    )
                  : Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              // border: Border.all(width: 0.5, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: EdgeInsets.only(left: 10, top: 10),
                            // height: adduser == 0 ? h * 0.30 : h * 0.10,
                            width: w,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 0.5, color: Colors.black),
                                      // borderRadius: BorderRadius.circular(10.0),
                                      color: Color(0xff1A494F)),
                                  child: Center(
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text("Add Account",
                                        style: TextStyle(
                                            color: Color(0xff1A494F),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, top: 10),
                              width: 500,
                              child: TextFormField(
                                // initialValue: "", // autofocus: false,
                                // maxLines: 3,
                                onChanged: (value) {
                                  rusername = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.patternString(
                                      r'^([a-zA-Z])', 'Invalid User name'),
                                  Validators.maxLength(255, "")
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
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

                                    hintText: "User Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, top: 10),
                              width: 500,
                              child: TextFormField(
                                // initialValue: "", // autofocus: false,
                                // maxLines: 3,
                                onChanged: (value) {
                                  rname = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.patternString(
                                      r'^([a-zA-Z])', 'Invalid name'),
                                  Validators.maxLength(255, "")
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Color(0xffFFFFFF),
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

                                    hintText: "First Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, top: 10),
                              width: 500,
                              child: TextFormField(
                                // controller: lname,
                                // initialValue: "", // autofocus: false,
                                // maxLines: 3,
                                onChanged: (value) {
                                  rlname = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.patternString(
                                      r'^([a-zA-Z])', 'Invalid last name'),
                                  Validators.maxLength(255, "")
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Color(0xffFFFFFF),
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
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              margin: EdgeInsets.only(top: 10, left: 30),
                              child: TextFormField(
                                onChanged: (value) {
                                  remail = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.email("invalid email"),
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Color(0xffFFFFFF),
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
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              margin: EdgeInsets.only(left: 30, top: 10),
                              decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                              ),
                              child: ListTile(
                                  title: _buildCountryPickerDropdown(
                                      sortedByIsoCode: true)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 550,
                                padding: EdgeInsets.only(left: 30, top: 10),
                                child: EasyAutocomplete(
                                    suggestions: _countries,
                                    controller: countrycontroller,
                                    decoration: InputDecoration(
                                        fillColor: Color(0xffFFFFFF),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 1.2,
                                              color: Color(0xffF5F6FA)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          // borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              width: 1.2,
                                              color: Color(0xffF5F6FA)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1.2,
                                              color: Color(0xffF5F6FA)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1.2,
                                              color: Color(0xffF5F6FA)),
                                        ),
                                        // border: InputBorder.none,
                                        hintText: "Country",
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15)),
                                    onChanged: (value) {
                                      print("-=-=-=-=-" + value.toString());
                                      countrycontroller.text = value;
                                      // rcountry =
                                      //     countrycontroller.text.toString();

                                      countrycontroller.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: countrycontroller
                                                      .text.length));
                                    },
                                    onSubmitted: (value) {
                                      print("-=-=-=-=-" + value.toString());
                                      countrycontroller.text = value;
                                      // rcountry =
                                      //     countrycontroller.text.toString();
                                    })),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              margin: EdgeInsets.only(top: 10, left: 30),
                              child: TextFormField(
                                controller: this.controller,
                                // // initialValue: "", // autofocus: false,
                                // maxLines: 3,
                                onChanged: (value) {
                                  raddress = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.maxLength(255, "")
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Color(0xffFFFFFF),
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
                                    hintText: "Address",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 30, top: 10),
                              width: 500,
                              child: TextFormField(
                                // controller: password,
                                // initialValue: "", // autofocus: false,
                                // maxLines: 3,
                                onChanged: (value) {
                                  rpassword = value;
                                },
                                validator: Validators.compose([
                                  Validators.required(' required'),
                                  Validators.minLength(6, ""),
                                  Validators.maxLength(18, "")
                                ]),
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 17),
                                decoration: InputDecoration(
                                    fillColor: Color(0xffFFFFFF),
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
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 15)),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (this._formKey2.currentState!.validate()) {
                                _formKey2.currentState!.save();
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                log("signupapi");
                                signUpApi();

                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) =>
                                //         profileConfirm());
                              }
                            },
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                  height: 40,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xff1A494F)),
                                  margin: EdgeInsets.only(left: 30, top: 15),
                                  child: Center(
                                    child: Text(
                                      "Add User",
                                      style: TextStyle(
                                          color: Color(0xffFFFFFF),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget userManagement() {
    return Container(
      // color: Color(0xffE5E5E5),
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: ExpansionTile(
            iconColor: Color(0xff1A494F),
            title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.person,
                    color: Color(0xff1A494F),
                    size: 45,
                  ),
                  // SizedBox(
                  //   width: 80,
                  // ),
                  Text(
                    'Users'.tr(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1A494F)),
                  ),
                ]),
            children: [
              ListTile(
                title: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: udata.length,
                    shrinkWrap: true,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            //  getUsers();
                            print("button is tapped${udata[index].status}");
                            var data = {
                              "id": udata[index].id.toString(),
                              "name": uname[index].toString(),
                              "lname": ulname[index].toString(),
                              "email": uemail[index].toString(),
                              "phone": uphone[index].toString(),
                              "address": uaddress[index].toString(),
                              "country": ucountry[index].toString(),
                              "profileImage": uprofileImage[index].toString(),
                              "status": status[index].toString()
                            };

                            print(
                                "djhjdhjhjds ${udata[index].status.toString()}");
                            var uploadimage = uprofileImage[index].toString();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    userManagement2(data));
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 20, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color(0xffFFFFFF)),
                              // height: MediaQuery.of(context).size.height * 0.12,
                              height: 97,
                              width: 373,
                              // width: MediaQuery.of(context).size.width * 0.9,
                              // color: Colors.lime,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(top: 12),
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                      ),
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(200),
                                        elevation: 10,
                                        child: Stack(
                                          children: [
                                            udata[index].profileimage != ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    child: Container(
                                                      height: 100,
                                                      width: 100,
                                                      child: Image.network(
                                                          udata[index]
                                                              .profileimage
                                                              .toString(),
                                                          fit: BoxFit.cover),
                                                    ),
                                                  )
                                                : Center(
                                                    child: Icon(Icons.person)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 25, left: 8),
                                              child: Text((udata[index].name),
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  )),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 8),
                                              child: Text(
                                                  (udata[index]
                                                      .email
                                                      .toString()),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )));
                    }),
              ),
            ]),
      ),
    );
  }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.09;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;

    return Row(
      children: <Widget>[
        CountryCodePicker(
          showDropDownButton: true,
          onChanged: (v) {
            countrycontroller.text = v.name.toString();
            countrycode = country.phoneCode;

            // String tt = e.dialCode.toString();
            // var temp = tt.split("+");
            // rphone = e.name;
            // countrycode = temp[1];
            // countrycontroller.text = country.name;
            // countrycode = country.phoneCode;
          },
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
        ),

        // Expanded(
        //   child: CountryCodePicker(
        //     onChanged: (e) {
        //       String tt = e.dialCode.toString();
        //       var temp = tt.split("+");
        //       countryName = e.name;
        //       countrycode = temp[1];
        //     },
        //     showCountryOnly: false,
        //     showOnlyCountryWhenClosed: false,
        //     alignLeft: false,
        //   ),
        // ),

        // SizedBox(
        //   width: dropdownButtonWidth,
        //   child: CountryPickerDropdown(
        //     // dropdownColor: Colors.white,
        //     iconEnabledColor: Colors.white,
        //     iconDisabledColor: Colors.white,

        //     /* underline: Container(
        //       height: 2,
        //       color: Colors.red,
        //     ),*/
        //     //show'em (the text fields) you're in charge now
        //     onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        //     //if you have menu items of varying size, itemHeight being null respects
        //     //that, IntrinsicHeight under the hood ;).
        //     itemHeight: null,
        //     //itemHeight being null and isDense being true doesn't play along
        //     //well together. One is trying to limit size and other is saying
        //     //limit is the sky, therefore conflicts.
        //     //false is default but still keep that in mind.
        //     isDense: false,
        //     //if you want your dropdown button's selected item UI to be different
        //     //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
        //     // selectedItemBuilder: hasSelectedItemBuilder == true
        //     //     ? (Country country) => _buildDropdownSelectedItemBuilder(
        //     //         country, dropdownSelectedItemWidth)
        //     //     : null,
        //     //initialValue: 'AR',
        //     // itemBuilder: (Country country) => hasSelectedItemBuilder == true
        //     //     ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
        //     //     : _buildDropdownItem(country, dropdownItemWidth),
        //     // initialValue: 'AR',
        //     // itemFilter: filtered
        //     //     ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
        //     //     : null,
        //     // //priorityList is shown at the beginning of list
        //     // priorityList: hasPriorityList
        //     //     ? [
        //     //         CountryPickerUtils.getCountryByIsoCode('GB'),
        //     //         CountryPickerUtils.getCountryByIsoCode('CN'),
        //     //       ]
        //     //     : null,
        //     sortComparator: sortedByIsoCode
        //         ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
        //         : null,
        //     onValuePicked: (Country country) {
        //       print("${country.phoneCode}");
        //       countryName = country.name;
        //       countrycode = country.phoneCode;
        //     },
        //   ),
        // ),

        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Container(
            // margin: EdgeInsets.all(10),

            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              initialValue: "",
              validator: Validators.compose([
                Validators.required(' required'),
              ]),
              onChanged: (value) {
                rphone = value;
              },
              style: TextStyle(color: Colors.black54, fontSize: 15),
              decoration: InputDecoration(
                  // fillColor: Colors.transparent,
                  // filled: true,
                  // focusedBorder: new OutlineInputBorder(
                  //   borderRadius: new BorderRadius.circular(50.0),
                  //   borderSide: BorderSide(
                  //     width: 1.2,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(50.0),
                  //   borderSide: BorderSide(
                  //     width: 1.2,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // focusedErrorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(50.0),
                  //   borderSide: BorderSide(width: 1.2, color: Colors.white),
                  // ),
                  // border: InputBorder.none,
                  hintText: "Enter contact Number",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        )
      ],
    );
  }
}
