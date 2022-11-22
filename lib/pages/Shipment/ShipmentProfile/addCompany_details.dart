// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Profile.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/constants.dart';

class AddCompanyDetails extends StatefulWidget {
  const AddCompanyDetails({Key? key}) : super(key: key);

  @override
  State<AddCompanyDetails> createState() => _AddCompanyDetailsState();
}

class _AddCompanyDetailsState extends State<AddCompanyDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? selectedDate = DateTime.now();
  var h, w;

  bool onEdit = false;
  final TextEditingController controller = TextEditingController();
  final TextEditingController languagectrl = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController LNcontroller = TextEditingController();

  final TextEditingController aboutmecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController mobilecontroller = TextEditingController();
  final TextEditingController languagecontroller = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  final TextEditingController Companynamecontroller = TextEditingController();
  final TextEditingController companyLocationcontroller =
      TextEditingController();
  final TextEditingController addresscontroller = TextEditingController();
  String imagepath = '';

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

  String filter = 'English';

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
  ];

  List getSuggestions2(String query) {
    List matches = [];
    matches.addAll(language);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  String _fileName = "";
  var countrycode, updatedCompanyName;

  var name,
      email,
      mobileNumber,
      languages,
      country,
      profileImage,
      username,
      lname,
      aboutMe;
  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedEmail,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updatedLName,
      updateLanguauge;

  Future getProfile() async {
    var response = await Providers().getshipmentProfile();
    if (response.status == true) {
      setState(() {
        aboutmecontroller.text = response.data[0].about_me;
        namecontroller.text = response.data[0].name;
        LNcontroller.text = response.data[0].lname;
        print("Name $name");
        emailcontroller.text = response.data[0].email;
        mobilecontroller.text = response.data[0].phone;
        languagecontroller.text = response.data[0].language;
        Companynamecontroller.text = response.data[0].companyname;
        addresscontroller.text = response.data[0].address;
        countrycontroller.text = response.data[0].country;
        profileImage = response.data[0].profileimage;
        usernamecontroller.text = response.data[0].username;
      });

      log("REPONSE" + jsonEncode(response.data));
      log("about show blow >>>>>>>>>>>???????????????" +
          jsonEncode(aboutMe.toString()));
    }
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "${namecontroller.text}" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLName == null ? LNcontroller.text : "$updatedLName",
      "email": emailcontroller.text,
      "phone": updatedNumber == null ? mobilecontroller.text : "$updatedNumber",
      "country":
          updatedCountry == null ? countrycontroller.text : "$updatedCountry",
      "address":
          updatedAddress == null ? addresscontroller.text : "$updatedAddress",
      "companyname": updatedCompanyName == null
          ? Companynamecontroller.text
          : "$updatedCompanyName",
      "annualshipment": "yes",
      "about_me":
          updatedAboutMe == null ? aboutmecontroller.text : "$updatedAboutMe",
      "language": updateLanguauge == null
          ? languagecontroller.text
          : "$updateLanguauge",
    };
    var response = await Providers().updateShipment(udpateData);
    if (response.status == true) {
      setState(() {
        // name = response.data[0].name;
        // print("Name $name");
        // email = response.data[0].email;
        // mobileNumber = response.data[0].phone;
        // languages = response.data[0].language;
        // country = response.data[0].country;
        // profileImage = response.data[0].profileimage;
        // aboutmecontroller.text = response.data[0].about_me;
        //  aboutmecontroller.text = response.data[0].about_me;
        namecontroller.text = response.data[0].name;
        LNcontroller.text = response.data[0].lname;
        print("Name $name");
        emailcontroller.text = response.data[0].email;
        mobilecontroller.text = response.data[0].phone;
        languagecontroller.text = response.data[0].language;
        Companynamecontroller.text = response.data[0].companyname;
        addresscontroller.text = response.data[0].address;
        countrycontroller.text = response.data[0].country;
        profileImage = response.data[0].profileimage;
        // usernamecontroller.text = response.data[0].username;
      });

      log("REPONSE" + jsonEncode(response.data));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "companyName",
          response.data[0].companyname == ""
              ? "NA"
              : response.data[0].companyname);

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text("Update succesfully"),
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

    // id =   response.user[universityList.indexOf(name)].id
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
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: ListView(children: [
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
                      // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                        child: Text(
                          'Complete Company Details',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  (Responsive.isDesktop(context)) ? 22 : 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                (Responsive.isDesktop(context))
                    ? profiledetails()
                    : profiledetails()
                // if (Responsive.isMobile(context))
              ])),
        ));
  }

  Widget profiledetails() {
    return Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(children: [
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
              // width: MediaQuery.of(context).size.width * (50 / 100),
              child: TextFormField(
                controller: this.namecontroller,
                // initialValue: "$name", // autofocus: false,
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
                controller: LNcontroller,
                // initialValue: "$lname", // autofocus: false,
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
                title: _buildCountryPickerDropdown(sortedByIsoCode: true)),
          ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //       margin: EdgeInsets.only(left: 15, top: 10),
          //       child: Text("Mobile Number", style: headingStyle16SB())),
          // ),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //     margin: EdgeInsets.only(left: 15, top: 10),
          //     // width: 500,
          //     child: TextFormField(
          //       controller: mobilecontroller, // maxLines: 3,
          //       inputFormatters: [
          //         // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
          //         FilteringTextInputFormatter.digitsOnly,
          //         LengthLimitingTextInputFormatter(10)
          //       ],
          //       onChanged: (v) {
          //         updatedNumber = v;
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
          //           hintText: "Mobile Number",
          //           hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
          //     ),
          //   ),
          // ),

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
                enabled: true,
                readOnly: true,
                controller: emailcontroller,
                // initialValue: "$email", // autofocus: false,
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
                child: Text("Company Name", style: headingStyle16SB())),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              // width: 500,
              child: TextFormField(
                controller: Companynamecontroller, // maxLines: 3,

                onChanged: (v) {
                  updatedCompanyName = v;
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
                    hintText: "CompanyName",
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
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: OutlineInputBorder(
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
                      hintText: "Country",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  onChanged: (value) {
                    this.countrycontroller.text = value;
                    // fromLocation = this.controller.text;

                    countrycontroller.selection = TextSelection.fromPosition(
                        TextPosition(offset: countrycontroller.text.length));
                  },
                  onSubmitted: (value) {
                    this.countrycontroller.text = value;
                    // fromLocation = this.controller.text;
                  })),
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
                controller: addresscontroller, // maxLines: 3,
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
              child: Text("Select Language", style: headingStyle16SB()),
            ),
          ),
          Container(
              width: w * 0.8,
              decoration: BoxDecoration(
                color: Color(0xffF5F6FA),
                border: Border.all(
                  width: 1.2,
                  color: Color(0xffF5F6FA),
                ),
              ),
              padding: EdgeInsets.only(left: 8),
              margin: EdgeInsets.only(left: 15, top: 10),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  // hint: Text("selectstatus".tr()),
                  value: filter,

                  // icon: Icon(Icons.arrow_drop_down),
                  // iconSize: 30,
                  elevation: 16,
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  onChanged: (String? value) {
                    setState(() {
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
                        style: TextStyle(color: Colors.black54, fontSize: 17),
                      ),
                    );
                  }).toList(),
                ),
              )
              // EasyAutocomplete(
              //     suggestions: language,
              //     controller: this.languagecontroller,
              //     decoration: InputDecoration(
              //         fillColor: Color(0xffF5F6FA),
              //         filled: true,
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           // borderRadius: new BorderRadius.circular(25.0),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //         ),
              //         focusedErrorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(4)),
              //           borderSide:
              //               BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
              //         ),
              //         // border: InputBorder.none,
              //         hintText: "Language",
              //         hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              //     onChanged: (value) {
              //       languagecontroller.text = value;
              //       // fromLocation = this.controller.text;

              //       languagecontroller.selection = TextSelection.fromPosition(
              //           TextPosition(offset: languagecontroller.text.length));
              //     },
              //     onSubmitted: (value) {
              //       languagecontroller.text = value;
              //       // fromLocation = this.controller.text;
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
                controller: aboutmecontroller,
                maxLines: 3, // autofocus: false,
                maxLength: 250,
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
                  margin: (Responsive.isDesktop(context))
                      ? EdgeInsets.only(left: 15, top: 15)
                      : EdgeInsets.only(left: 15, top: 15, bottom: 15),
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
        ]));
  }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    double dropdownButtonWidth = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width * 0.13
        : MediaQuery.of(context).size.width * 0.30;
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
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Container(
            child: TextFormField(
              controller: mobilecontroller, // maxLines: 3,
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
