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
import 'package:shipment/Model/Shipment/getShipmentEmployeeModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResClientReview.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_AddUser.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/helper/routes.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ShipmentSubUser_Screen extends StatefulWidget {
  ShipmentSubUser_Screen();

  @override
  _ShipmentSubUser_ScreenState createState() => _ShipmentSubUser_ScreenState();
}

class _ShipmentSubUser_ScreenState extends State<ShipmentSubUser_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController controller = TextEditingController();
  var h, w;
  var sid, comment, tapped = 0, companyname;
  double? quality, price, support, service, ratings;
  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  final TextEditingController countrycontroller = TextEditingController();
  List<EmployeeData>? employeedata;
  var profileexp = -1;
  var timezoneexp = -1;
  var id = [];
  var status = [];
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
  var country;
  String? Ename1,
      Elname1,
      Eemail1,
      Ephone,
      Eaddress,
      Eroles,
      Ecountry,
      Epassword,
      Eusername;
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

  Future addEmployee() async {
    var employeeDetails = {
      "name": "$Ename1",
      "lname": "$Elname1",
      "email": "$Eemail1",
      "phone": "$Ephone",
      "country": "$Ecountry",
      "address": "$Eaddress",
      "password": "${encodeToSHA3(Epassword)}",
      "roles": "$Eroles" == "Account Manager"
          ? "2"
          : "$Eroles" == "Departure Manager"
              ? "3"
              : "$Eroles" == "Arrival Manager"
                  ? "4"
                  : "5",
      "username": "$Eusername"
    };
    print("Details $employeeDetails");
    var response = await Providers().addEmployee(employeeDetails);
    if (response.status == true) {
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

      log("REPONSE" + jsonEncode(response.data));
    } else
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

    // id =   response.user[universityList.indexOf(name)].id
  }

  @override
  void initState() {
    getEmployees();
    super.initState();
  }

  Future getEmployees() async {
    var response = await Providers().getShipmentEmployee();
    if (response.status == true) {
      setState(() {
        employeedata = response.data;
      });
      for (int i = 0; i < employeedata!.length; i++) {
        uname.add(employeedata![i].name.toString());

        id.add(employeedata![i].id.toString());
        ulname.add(employeedata![i].lname.toString());
        uemail.add(employeedata![i].email.toString());
        uaddress.add(employeedata![i].address.toString());
        ucountry.add(employeedata![i].country.toString());
        uphone.add(employeedata![i].phone.toString());
        uprofileImage.add(employeedata![i].profileimage.toString());
        status.add(employeedata![i].status.toString());
      }
      print("Adressss" + uaddress.toString());
      print("uprofileImage" + uprofileImage.toString());
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
        child: ShipmentSidebar(),
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
                      margin: EdgeInsets.fromLTRB(5, 10, 50, 0),
                      child: Row(
                        children: [
                          Text(
                            'Sub Users',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
                child: employeedata == null
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ShipmentAddUser()));
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
          // color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10),
        height: adduser == 0 ? h : h * 0.10,
        width: w,
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
                          margin: (Responsive.isDesktop(context))
                              ? EdgeInsets.only(left: 20, top: 10)
                              : EdgeInsets.only(top: 10, left: 20),
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
                            child: Text(
                              "Add Account",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A494F)),
                            )),
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
                            color: Color(0xffE5E5E5),
                          ),
                          margin: EdgeInsets.only(left: 10, top: 10),
                          // height: adduser == 0 ? h * 0.30 : h * 0.10,
                          width: w,
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 25),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500))),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 500,
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: TextFormField(
                              initialValue: "", // autofocus: false,

                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-z A-Z á-ú Á-Ú 0-9]")),
                              ],

                              onChanged: (v) {
                                Eusername = v;
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
                                  hintText: "User name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            width: 500,
                            child: TextFormField(
                              initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp("[a-zA-Z -]"))),
                              ],
                              validator: Validators.compose([
                                Validators.required(' required'),
                                Validators.patternString(
                                    r'^([a-zA-Z])', 'Invalid name'),
                                Validators.maxLength(255, "")
                              ]),
                              onChanged: (v) {
                                Ename1 = v;
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
                                  hintText: "First Name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            width: 500,
                            child: TextFormField(
                              initialValue: "", // autofocus: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    (RegExp("[a-zA-Z -]"))),
                              ],

                              onChanged: (v) {
                                Elname1 = v;
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
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: TextFormField(
                              initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              validator: Validators.compose([
                                Validators.required(' required'),
                                Validators.email("invalid email"),
                              ]),
                              onChanged: (v) {
                                Eemail1 = v;
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
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            width: 500,
                            child: TextFormField(
                              initialValue: "", // autofocus: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z]')),
                              ],

                              onChanged: (v) {
                                Ecountry = v;
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
                                  hintText: "Country",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: 500,
                            margin: EdgeInsets.only(top: 10, left: 15),
                            child: TextFormField(
                              initialValue: "", // autofocus: false,

                              onChanged: (v) {
                                Eaddress = v;
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
                                  hintText: "Address",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            width: 500,
                            child: TextFormField(
                              initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              onChanged: (v) {
                                Epassword = v;
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

                              addEmployee();
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
                                margin: EdgeInsets.only(left: 15, top: 15),
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
    );
  }

  Widget userManagement() {
    return Container(
      // color: Color(0xffE5E5E5),
      child: Padding(
        padding: EdgeInsets.only(left: 15),
        child: Column(
          children: [
            ExpansionTile(
              iconColor: const Color(0xff1A494F),
              // ignore: prefer_const_literals_to_create_immutables
              title: Row(children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: (Responsive.isDesktop(context)) ? 0 : 0),
                  child: Icon(
                    Icons.person,
                    color: Color(0xff1A494F),
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: (Responsive.isDesktop(context)) ? 20 : 20,
                ),
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
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: employeedata!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              print("button is tapped");
                              var data = {
                                "id": id[index].toString(),
                                "name": uname[index].toString(),
                                "lname": ulname[index].toString(),
                                "email": uemail[index].toString(),
                                "phone": uphone[index].toString(),
                                "address":
                                    employeedata![index].address.toString(),
                                "country":
                                    employeedata![index].country.toString(),
                                "profileImage": uprofileImage[index].toString(),
                                "status": status[index].toString()
                              };
                              print("djhjdhjhjds" + data.toString());
                              print("-=-=status $status");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      userManagement2(data));
                              // profileimage:
                              //     uprofileImage[index],
                              // name: uname[index],
                              // lname: ulname[index],
                              // email: uemail[index],
                              // phone: uphone[index],
                              // country: ucountry[index],
                              // address: uaddress[index]
                              // ));
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.only(top: 20, right: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: const Color(0xffFFFFFF)),
                                // height: MediaQuery.of(context).size.height * 0.12,
                                height: 97,
                                width: 373,
                                // width: MediaQuery.of(context).size.width * 0.9,
                                // color: Colors.lime,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 50.0,
                                        height: 50.0,
                                        margin: const EdgeInsets.only(top: 12),
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
                                              employeedata![index]
                                                          .profileimage ==
                                                      ''
                                                  ? const Center(
                                                      child: Icon(Icons.person))
                                                  : ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  100)),
                                                      child: Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: Image.network(
                                                              (employeedata![
                                                                      index]
                                                                  .profileimage
                                                                  .toString()),
                                                              fit: BoxFit
                                                                  .cover)))

                                              // Positioned(
                                              //   bottom: 4,
                                              //   right: 0,
                                              //   child: Container(
                                              //     decoration: new BoxDecoration(
                                              //         shape: BoxShape.circle,
                                              //         color: Color(0xff43A047)),
                                              //     child: InkWell(
                                              //         onTap: () {
                                              //           _showPicker(context);
                                              //         },
                                              //         child: Icon(Icons.add,
                                              //             color: Colors.black)),
                                              //   ),
                                              // )
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
                                                margin: const EdgeInsets.only(
                                                    top: 25, left: 8),
                                                child: Text(
                                                    (employeedata![index].name),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    )),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 8),
                                                child: Text(
                                                    (employeedata![index]
                                                        .email
                                                        .toString()),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10,
                                                    )),
                                              ),
                                              // Align(
                                              //   alignment:
                                              //       Alignment.bottomRight,
                                              //   child: Container(
                                              //       height: 15,
                                              //       width: 20,
                                              //       decoration:
                                              //           BoxDecoration(
                                              //               // borderRadius: BorderRadius.circular(50),
                                              //               shape: BoxShape
                                              //                   .circle,
                                              //               color: Color(
                                              //                   0xffFF2828)),
                                              //       // margin: EdgeInsets.only(right: 10),
                                              //       child: Center(
                                              //         child: Text(
                                              //           "1",
                                              //           style: TextStyle(
                                              //               fontSize: 8),
                                              //         ),
                                              //       )),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )));
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}