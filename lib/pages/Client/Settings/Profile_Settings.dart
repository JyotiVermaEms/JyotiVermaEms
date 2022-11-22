import 'dart:convert';
import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';

import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/TextStyle.dart';

import 'package:http/http.dart' as http;
import 'package:shipment/Element/customAlertClient.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Res_Setting.dart';
import 'package:shipment/constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/Settings/Settings.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/shipmentOtp.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Profile_Settings extends StatefulWidget {
  const Profile_Settings({Key? key}) : super(key: key);

  @override
  _Profile_SettingsState createState() => _Profile_SettingsState();
}

class _Profile_SettingsState extends State<Profile_Settings>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();

  var _passwordController = new TextEditingController();
  var _confirmpasswordController = new TextEditingController();
  var _emailController = new TextEditingController();
  final TextEditingController controller = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  final TextEditingController mobilecontroller = TextEditingController();

  var h, w;
  bool? monVal = false;
  var countrycode;
  bool? monVal2 = false;
  bool? isProcess = false;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  var adduser = -1;

  // String? name1, lname1, email1, phone, address, roles;
  var name, lname, email, mobileNumber, languages, password, country, userName;
  String? datalist;

  var emailAddress, passwordd, confirmPassword;
  // String? name, lname, email, phone, country, address, password, roles;
  String? userEmail;
 
  var updatedNumber,
      updatedName,
      updatedLastName,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updateLanguauge,
      updatedEmail,
      updatedpassword;
  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getClientProfile();
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        lname = response.data[0].lname;
        userName = response.data[0].username;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });

    // id =   response.user[universityList.indexOf(name)].id
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
  _phoneValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
    final RegExp oneDot = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!oneDot.hasMatch(val)) return "Enter must be 10 digits";
  }

  List getSuggestions(String query) {
    List matches = [];
    matches.addAll(_countries);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  Future getDeactiveProfile() async {
    var response = await Providers().getDeativate();
    if (response.status == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreenClient()),
        (Route<dynamic> route) => false,
      );
      // Navigator.pop(context);

      log("REPONSE" + jsonEncode(response.data));
    }
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "lname": updatedLastName == null ? "$lname" : "$updatedLastName",
      "email": "$email",
      "phone": "$mobileNumber",
      "country": "$country",
      "address": " ",
      "about_me": "  ",
      "language": "$languages",
      "username": "$userName"
    };
    var response = await Providers().updateClient(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
      });
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

  var profileexp = -1;
  var timezoneexp = -1;

  String? category;
  var updatedConfirmPassword, updatedPassword;

  var amount;
  var items = [
    'Europe/Andorra',
    'Asia/Dubai',
    'Asia/Kabul',
    'Europe/Tirane',
    'Asia/Yerevan',
    'Antarctica/Casey',
    'Antarctica/Davis',
    'Antarctica/DumontDUrville', // https://bugs.chromium.org/p/chromium/issues/detail?id=928068
    'Antarctica/Mawson',
    'Antarctica/Palmer',
    'Antarctica/Rothera',
    'Antarctica/Syowa',
    'Antarctica/Troll',
    'Antarctica/Vostok',
    'America/Argentina/Buenos_Aires',
    'America/Argentina/Cordoba',
    'America/Argentina/Salta',
    'America/Argentina/Jujuy',
    'America/Argentina/Tucuman',
    'America/Argentina/Catamarca',
    'America/Argentina/La_Rioja',
    'America/Argentina/San_Juan',
    'America/Argentina/Mendoza',
    'America/Argentina/San_Luis',
    'America/Argentina/Rio_Gallegos',
    'America/Argentina/Ushuaia',
    'Pacific/Pago_Pago',
    'Europe/Vienna',
    'Australia/Lord_Howe',
    'Antarctica/Macquarie',
    'Australia/Hobart',
    'Australia/Currie',
    'Australia/Melbourne',
    'Australia/Sydney',
    'Australia/Broken_Hill',
    'Australia/Brisbane',
    'Australia/Lindeman',
    'Australia/Adelaide',
    'Australia/Darwin',
    'Australia/Perth',
    'Australia/Eucla',
    'Asia/Baku',
    'America/Barbados',
    'Asia/Dhaka',
    'Europe/Brussels',
    'Europe/Sofia',
    'Atlantic/Bermuda',
    'Asia/Brunei',
    'America/La_Paz',
    'America/Noronha',
    'America/Belem',
    'America/Fortaleza',
    'America/Recife',
    'America/Araguaina',
    'America/Maceio',
    'America/Bahia',
    'America/Sao_Paulo',
    'America/Campo_Grande',
    'America/Cuiaba',
    'America/Santarem',
    'America/Porto_Velho',
    'America/Boa_Vista',
    'America/Manaus',
    'America/Eirunepe',
    'America/Rio_Branco',
    'America/Nassau',
    'Asia/Thimphu',
    'Europe/Minsk',
    'America/Belize',
    'America/St_Johns',
    'America/Halifax',
    'America/Glace_Bay',
    'America/Moncton',
    'America/Goose_Bay',
    'America/Blanc-Sablon',
    'America/Toronto',
    'America/Nipigon',
    'America/Thunder_Bay',
    'America/Iqaluit',
    'America/Pangnirtung',
    'America/Atikokan',
    'America/Winnipeg',
    'America/Rainy_River',
    'America/Resolute',
    'America/Rankin_Inlet',
    'America/Regina',
    'America/Swift_Current',
    'America/Edmonton',
    'America/Cambridge_Bay',
    'America/Yellowknife',
    'America/Inuvik',
    'America/Creston',
    'America/Dawson_Creek',
    'America/Fort_Nelson',
    'America/Vancouver',
    'America/Whitehorse',
    'America/Dawson',
    'Indian/Cocos',
    'Europe/Zurich',
    'Africa/Abidjan',
    'Pacific/Rarotonga',
    'America/Santiago',
    'America/Punta_Arenas',
    'Pacific/Easter',
    'Asia/Shanghai',
    'Asia/Urumqi',
    'America/Bogota',
    'America/Costa_Rica',
    'America/Havana',
    'Atlantic/Cape_Verde',
    'America/Curacao',
    'Indian/Christmas',
    'Asia/Nicosia',
    'Asia/Famagusta',
    'Europe/Prague',
    'Europe/Berlin',
    'Europe/Copenhagen',
    'America/Santo_Domingo',
    'Africa/Algiers',
    'America/Guayaquil',
    'Pacific/Galapagos',
    'Europe/Tallinn',
    'Africa/Cairo',
    'Africa/El_Aaiun',
    'Europe/Madrid',
    'Africa/Ceuta',
    'Atlantic/Canary',
    'Europe/Helsinki',
    'Pacific/Fiji',
    'Atlantic/Stanley',
    'Pacific/Chuuk',
    'Pacific/Pohnpei',
    'Pacific/Kosrae',
    'Atlantic/Faroe',
    'Europe/Paris',
    'Europe/London',
    'Asia/Tbilisi',
    'America/Cayenne',
    'Africa/Accra',
    'Europe/Gibraltar',
    'America/Godthab',
    'America/Danmarkshavn',
    'America/Scoresbysund',
    'America/Thule',
    'Europe/Athens',
    'Atlantic/South_Georgia',
    'America/Guatemala',
    'Pacific/Guam',
    'Africa/Bissau',
    'America/Guyana',
    'Asia/Hong_Kong',
    'America/Tegucigalpa',
    'America/Port-au-Prince',
    'Europe/Budapest',
    'Asia/Jakarta',
    'Asia/Pontianak',
    'Asia/Makassar',
    'Asia/Jayapura',
    'Europe/Dublin',
    'Asia/Jerusalem',
    'Asia/Kolkata',
    'Indian/Chagos',
    'Asia/Baghdad',
    'Asia/Tehran',
    'Atlantic/Reykjavik',
    'Europe/Rome',
    'America/Jamaica',
    'Asia/Amman',
    'Asia/Tokyo',
    'Africa/Nairobi',
    'Asia/Bishkek',
    'Pacific/Tarawa',
    'Pacific/Enderbury',
    'Pacific/Kiritimati',
    'Asia/Pyongyang',
    'Asia/Seoul',
    'Asia/Almaty',
    'Asia/Qyzylorda',
    'Asia/Qostanay', // https://bugs.chromium.org/p/chromium/issues/detail?id=928068
    'Asia/Aqtobe',
    'Asia/Aqtau',
    'Asia/Atyrau',
    'Asia/Oral',
    'Asia/Beirut',
    'Asia/Colombo',
    'Africa/Monrovia',
    'Europe/Vilnius',
    'Europe/Luxembourg',
    'Europe/Riga',
    'Africa/Tripoli',
    'Africa/Casablanca',
    'Europe/Monaco',
    'Europe/Chisinau',
    'Pacific/Majuro',
    'Pacific/Kwajalein',
    'Asia/Yangon',
    'Asia/Ulaanbaatar',
    'Asia/Hovd',
    'Asia/Choibalsan',
    'Asia/Macau',
    'America/Martinique',
    'Europe/Malta',
    'Indian/Mauritius',
    'Indian/Maldives',
    'America/Mexico_City',
    'America/Cancun',
    'America/Merida',
    'America/Monterrey',
    'America/Matamoros',
    'America/Mazatlan',
    'America/Chihuahua',
    'America/Ojinaga',
    'America/Hermosillo',
    'America/Tijuana',
    'America/Bahia_Banderas',
    'Asia/Kuala_Lumpur',
    'Asia/Kuching',
    'Africa/Maputo',
    'Africa/Windhoek',
    'Pacific/Noumea',
    'Pacific/Norfolk',
    'Africa/Lagos',
    'America/Managua',
    'Europe/Amsterdam',
    'Europe/Oslo',
    'Asia/Kathmandu',
    'Pacific/Nauru',
    'Pacific/Niue',
    'Pacific/Auckland',
    'Pacific/Chatham',
    'America/Panama',
    'America/Lima',
    'Pacific/Tahiti',
    'Pacific/Marquesas',
    'Pacific/Gambier',
    'Pacific/Port_Moresby',
    'Pacific/Bougainville',
    'Asia/Manila',
    'Asia/Karachi',
    'Europe/Warsaw',
    'America/Miquelon',
    'Pacific/Pitcairn',
    'America/Puerto_Rico',
    'Asia/Gaza',
    'Asia/Hebron',
    'Europe/Lisbon',
    'Atlantic/Madeira',
    'Atlantic/Azores',
    'Pacific/Palau',
    'America/Asuncion',
    'Asia/Qatar',
    'Indian/Reunion',
    'Europe/Bucharest',
    'Europe/Belgrade',
    'Europe/Kaliningrad',
    'Europe/Moscow',
    'Europe/Simferopol',
    'Europe/Kirov',
    'Europe/Astrakhan',
    'Europe/Volgograd',
    'Europe/Saratov',
    'Europe/Ulyanovsk',
    'Europe/Samara',
    'Asia/Yekaterinburg',
    'Asia/Omsk',
    'Asia/Novosibirsk',
    'Asia/Barnaul',
    'Asia/Tomsk',
    'Asia/Novokuznetsk',
    'Asia/Krasnoyarsk',
    'Asia/Irkutsk',
    'Asia/Chita',
    'Asia/Yakutsk',
    'Asia/Khandyga',
    'Asia/Vladivostok',
    'Asia/Ust-Nera',
    'Asia/Magadan',
    'Asia/Sakhalin',
    'Asia/Srednekolymsk',
    'Asia/Kamchatka',
    'Asia/Anadyr',
    'Asia/Riyadh',
    'Pacific/Guadalcanal',
    'Indian/Mahe',
    'Africa/Khartoum',
    'Europe/Stockholm',
    'Asia/Singapore',
    'America/Paramaribo',
    'Africa/Juba',
    'Africa/Sao_Tome',
    'America/El_Salvador',
    'Asia/Damascus',
    'America/Grand_Turk',
    'Africa/Ndjamena',
    'Indian/Kerguelen',
    'Asia/Bangkok',
    'Asia/Dushanbe',
    'Pacific/Fakaofo',
    'Asia/Dili',
    'Asia/Ashgabat',
    'Africa/Tunis',
    'Pacific/Tongatapu',
    'Europe/Istanbul',
    'America/Port_of_Spain',
    'Pacific/Funafuti',
    'Asia/Taipei',
    'Europe/Kiev',
    'Europe/Uzhgorod',
    'Europe/Zaporozhye',
    'Pacific/Wake',
    'America/New_York',
    'America/Detroit',
    'America/Kentucky/Louisville',
    'America/Kentucky/Monticello',
    'America/Indiana/Indianapolis',
    'America/Indiana/Vincennes',
    'America/Indiana/Winamac',
    'America/Indiana/Marengo',
    'America/Indiana/Petersburg',
    'America/Indiana/Vevay',
    'America/Chicago',
    'America/Indiana/Tell_City',
    'America/Indiana/Knox',
    'America/Menominee',
    'America/North_Dakota/Center',
    'America/North_Dakota/New_Salem',
    'America/North_Dakota/Beulah',
    'America/Denver',
    'America/Boise',
    'America/Phoenix',
    'America/Los_Angeles',
    'America/Anchorage',
    'America/Juneau',
    'America/Sitka',
    'America/Metlakatla',
    'America/Yakutat',
    'America/Nome',
    'America/Adak',
    'Pacific/Honolulu',
    'America/Montevideo',
    'Asia/Samarkand',
    'Asia/Tashkent',
    'America/Caracas',
    'Asia/Ho_Chi_Minh',
    'Pacific/Efate',
    'Pacific/Wallis',
    'Pacific/Apia',
    'Africa/Johannesburg'
  ];
  final TextEditingController _controllr = new TextEditingController();

  var passwordexp = -1;
  List<ExpansionpanelItem> profileitems = <ExpansionpanelItem>[
    ExpansionpanelItem(
      isExpanded: false,
      title: 'Profile',
      content: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 500,
                child: TextFormField(
                  initialValue: "", // autofocus: false,
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
                      hintText: "Shishank",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 500,
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  initialValue: "", // autofocus: false,
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
                      hintText: "Barua",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 500,
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  // initialValue: "", // autofocus: false,
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
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff1A494F)),
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Center(
                    child: InkWell(
                      child: Text(
                        "Update",
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
          ])),
    ),
  ];

  List<ExpansionpanelItem> passworditems = <ExpansionpanelItem>[
    ExpansionpanelItem(
      isExpanded: false,
      title: 'Password',
      content: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 500,
                child: TextFormField(
                  initialValue: "", // autofocus: false,
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
                      hintText: "Update Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 500,
                margin: EdgeInsets.only(top: 10),
                child: TextFormField(
                  initialValue: "", // autofocus: false,
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
                      hintText: "New Password",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xff1A494F)),
                  margin: EdgeInsets.only(left: 10, top: 15),
                  child: Center(
                    child: Text(
                      "Update Password",
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ])),
    ),
  ];

  var rname,
      rlname,
      remail,
      rpassword,
      rphone,
      raddress,
      rroles,
      rcountry,
      rusername;

  String encodeToSHA3Pass(password) {
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

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  doResetPassword() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var resetData = {
        "email": "$email",
        "password": "${encodeToSHA3(passwordd)}",
        "password_confirmation": "${encodeToSHA3(confirmPassword)}",
      };
      print(jsonEncode(resetData));
      var register = await Providers().getResetPassword(resetData);

      if (register.status == true) {
        _passwordController.clear();
        _confirmpasswordController.clear();
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(register.message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(register.message),
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    // getDeactiveProfile();
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xffE5E5E5),
      key: _scaffoldKey,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                    ),
                    profileExpand(),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          height: 36,
                        )),
                    passwordExpand(),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          height: 36,
                        )),
                    notificationExpand(),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          height: 36,
                        )),
                    timezoneExpand(),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          height: 36,
                        )),
                    deleteAccountxpand(),
                    Container(
                        margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                        child: Divider(
                          color: Colors.black,
                          thickness: 2,
                          height: 36,
                        )),
                    // addUser(),
                    // logOut(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget profileExpand() {
    return InkWell(
      onTap: () {
        setState(() {
          profileexp == -1 ? profileexp = 0 : profileexp = -1;
          log("EXP2 >> $exp2");
        });
      },
      onDoubleTap: () {
        setState(() {
          profileexp = -1;
          log("EXP2 >> $exp2");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10),
        height: profileexp == 0 ? h * 0.45 : h * 0.13,
        width: w,
        child: Column(
          children: [
            profileexp != 0
                ? Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child:
                                  Text("Profile", style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("$name",
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child:
                                  Text("Profile", style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Container(
                      //       margin: EdgeInsets.only(left: 15, top: 10),
                      //       child: Text("$name",
                      //           style: headingStyle16NBLightGrey())),
                      // ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          width: 500,
                          child: TextFormField(
                            initialValue: "$name", // autofocus: false,
                            // maxLines: 3,
                            inputFormatters: [
                              // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z -]"))
                            ],
                            onChanged: (v) {
                              updatedName = v;
                            },
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
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
                                hintText: "Shishank",
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
                            initialValue: "$lname", // autofocus: false,
                            // maxLines: 3,

                            inputFormatters: [
                              // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z -]"))
                            ],
                            onChanged: (v) {
                              updatedLastName = v;
                            },
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
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
                                hintText: "Barua",
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
                            // controller: _emailController,
                            initialValue: "$email", // autofocus: false,
                            readOnly: true,
                            enabled: true,
                            onChanged: (v) {},
                            style:
                                TextStyle(color: Colors.black54, fontSize: 17),
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
                                hintText: "Shishank.barua@gmail.com",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xff1A494F)),
                            margin: EdgeInsets.only(left: 15, top: 15),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  updateProfileApi();
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget passwordExpand() {
    return Form(
      key: _formKey,
      child: InkWell(
        onTap: () {
          setState(() {
            passwordexp == -1 ? passwordexp = 0 : passwordexp = -1;
            log("EXP2 >> $exp2");
          });
        },
        onDoubleTap: () {
          setState(() {
            passwordexp = -1;
            log("EXP2 >> $exp2");
          });
        },
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xffE5E5E5),
          ),
          margin: EdgeInsets.only(right: 10),
          height: passwordexp == 0 ? h * 0.38 : h * 0.13,
          width: w,
          child: Column(
            children: [
              passwordexp != 0
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text("Password",
                                    style: headingStyleBold())),
                            Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  // borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xff1A494F)),
                              child: Center(
                                child: Icon(Icons.arrow_drop_down_outlined,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text("Your email address is $email",
                                  style: headingStyle16NBLightGrey())),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: Text("Password",
                                    style: headingStyleBold())),
                            Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  // borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xff1A494F)),
                              child: Center(
                                child: Icon(Icons.arrow_drop_down_outlined,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child:
                                  Text("", style: headingStyle16NBLightGrey())),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 15),
                            width: 500,
                            child: TextFormField(
                              // controller: _passwordController,

                              // initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              onChanged: (v) {
                                passwordd = v;
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
                                  hintText: "new  Password",
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
                              // controller: _confirmpasswordController,

                              // initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              onChanged: (v) {
                                confirmPassword = v;
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
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Color(0xff1A494F)),
                              margin: EdgeInsets.only(left: 15, top: 15),
                              child: Center(
                                child: InkWell(
                                  onTap: () async {
                                    doResetPassword();
                                  },
                                  child: Text(
                                    "Update Password",
                                    style: TextStyle(
                                        color: Color(0xffFFFFFF),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget checkBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  activeColor: Color(0xff1A494F),
                  value: monVal2,
                  onChanged: (bool? value) async {
                    setState(() {
                      monVal2 = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Text("Receive weekly digest mails",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  activeColor: Color(0xff1A494F),
                  value: monVal,
                  onChanged: (bool? value) async {
                    setState(() {
                      monVal = value;
                    });
                  },
                ),
              ),
              Text("Receive new rating announcements",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget notificationExpand() {
    return InkWell(
      onTap: () {
        setState(() {
          exp2 == -1 ? exp2 = 0 : exp2 = -1;
          log("EXP2 >> $exp2");
        });
      },
      onDoubleTap: () {
        setState(() {
          exp2 = -1;
          log("EXP2 >> $exp2");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10),
        height: exp2 == 0 ? h * 0.30 : h * 0.13,
        width: w,
        child: Column(
          children: [
            exp2 != 0
                ? Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text("Notification",
                                  style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Rateit will send you notifications",
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child: Text("Notification",
                                  style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_up_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Rateit will send you notifications",
                                style: headingStyle16NBLightGrey())),
                      ),
                      checkBox()
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget timezoneExpand() {
    return InkWell(
      onTap: () {
        setState(() {
          timezoneexp == -1 ? timezoneexp = 0 : timezoneexp = -1;
          log("EXP2 >> $exp2");
        });
      },
      onDoubleTap: () {
        setState(() {
          timezoneexp = -1;
          log("EXP2 >> $exp2");
        });
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10),
        height: timezoneexp == 0 ? h * 0.30 : h * 0.13,
        width: w,
        child: Column(
          children: [
            timezoneexp != 0
                ? Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child:
                                  Text("Time Zone", style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                                "Your timezone is currently set to: Pacific Time (US)",
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 15, top: 10),
                              child:
                                  Text("Time Zone", style: headingStyleBold())),
                          Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Color(0xff1A494F)),
                            child: Center(
                              child: Icon(Icons.arrow_drop_up_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                                "Your timezone is currently set to: Pacific Time (US)",
                                style: headingStyle16NBLightGrey())),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 10),
                        decoration: BoxDecoration(
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                new Expanded(
                                  child: new TextField(
                                    enabled: false,
                                    controller: _controllr,
                                  ),
                                ),
                                new PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    category = value;
                                    _controllr.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return new PopupMenuItem(
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  (90 / 100),
                                              child: new Text(value)),
                                          value: value);
                                    }).toList();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget deleteAccountxpand() {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(width: 0.5, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffE5E5E5),
      ),
      margin: EdgeInsets.only(right: 10),
      height: timezoneexp == 0 ? h * 0.30 : h * 0.10,
      width: w,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("Deactivate", style: headingStyleBold())),
              Spacer(),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    height: 25,
                    width: 85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Color(0xff1A494F)),
                    margin: EdgeInsets.only(left: 15, top: 15),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Text(
                                  "Are you sure want to deactivate your account "),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => getDeactiveProfile(),
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          "Deactivate",
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text("If you no longer  want to receive emails..",
                    style: headingStyle16NBLightGrey())),
          )
        ],
      ),
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
          color: Color(0xffE5E5E5),
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
                        color: Color(0xffE5E5E5),
                      ),
                      margin: EdgeInsets.only(right: 10),
                      // height: adduser == 0 ? h * 0.30 : h * 0.10,
                      width: w,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15),
                            width: 50,
                            height: 50,
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
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Add Account",
                                  style: TextStyle(
                                      color: Color(0xff1A494F),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))),
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
                            margin: EdgeInsets.only(right: 10),
                            // height: adduser == 0 ? h * 0.30 : h * 0.10,
                            width: w,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  width: 50,
                                  height: 50,
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
                              margin: EdgeInsets.only(left: 15, top: 10),
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

                                    hintText: "User Name",
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
                                // controller: email,
                                // initialValue: "", // autofocus: false,
                                // maxLines: 3,
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
                              width: 500,
                              margin: EdgeInsets.only(left: 15, top: 10),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(50.0),
                                // border:
                                //     Border.all(width: 1.2, color: Colors.white),

                                color: Color(0xffF5F6FA),
                                // borderSide: BorderSide(
                                //         width: 1.2,
                                //         color: Colors.white,
                                //       ),
                              ),
                              child: ListTile(
                                  title: _buildCountryPickerDropdown(
                                      sortedByIsoCode: true)),
                            ),
                          ),

                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Container(
                          //     margin: EdgeInsets.only(left: 15, top: 10),
                          //     width: 500,
                          //     child: TextFormField(
                          //       // controller: phone,
                          //       // initialValue: "", // autofocus: false,
                          //       // maxLines: 3,
                          //       onChanged: (value) {
                          //         rphone = value;
                          //       },
                          //       validator: Validators.compose([
                          //         Validators.required(' required'),
                          //         Validators.patternString(r'^(0|[1-9][0-9]*)$',
                          //             'Invalid phone number'),
                          //         Validators.minLength(10, "")
                          //       ]),
                          //       style: TextStyle(
                          //           color: Colors.black54, fontSize: 17),
                          //       decoration: InputDecoration(
                          //           fillColor: Color(0xffF5F6FA),
                          //           filled: true,
                          //           enabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           focusedBorder: new OutlineInputBorder(
                          //             // borderRadius: new BorderRadius.circular(25.0),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           errorBorder: OutlineInputBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(4)),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           focusedErrorBorder: OutlineInputBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(4)),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           // border: InputBorder.none,
                          //           hintText: "Phone Number",
                          //           hintStyle: TextStyle(
                          //               color: Colors.grey, fontSize: 15)),
                          //     ),
                          //   ),
                          // ),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                width: 520,
                                padding: EdgeInsets.only(left: 15, top: 10),
                                child: EasyAutocomplete(
                                    suggestions: _countries,
                                    controller: countrycontroller,
                                    decoration: InputDecoration(
                                        fillColor: Color(0xffF5F6FA),
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
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Container(
                          //       // margin: EdgeInsets.only(left: 15, top: 10),
                          //       width: 520,
                          //       padding: EdgeInsets.only(left: 15, top: 10),
                          //       child: EasyAutocomplete(
                          //           suggestions: _countries,
                          //           controller: this.controller,
                          //           decoration: InputDecoration(
                          //               fillColor: Color(0xffF5F6FA),
                          //               filled: true,
                          //               enabledBorder: OutlineInputBorder(
                          //                 borderSide: BorderSide(
                          //                     width: 1.2,
                          //                     color: Color(0xffF5F6FA)),
                          //               ),
                          //               focusedBorder: OutlineInputBorder(
                          //                 // borderRadius: new BorderRadius.circular(25.0),
                          //                 borderSide: BorderSide(
                          //                     width: 1.2,
                          //                     color: Color(0xffF5F6FA)),
                          //               ),
                          //               errorBorder: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.all(
                          //                     Radius.circular(4)),
                          //                 borderSide: BorderSide(
                          //                     width: 1.2,
                          //                     color: Color(0xffF5F6FA)),
                          //               ),
                          //               focusedErrorBorder: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.all(
                          //                     Radius.circular(4)),
                          //                 borderSide: BorderSide(
                          //                     width: 1.2,
                          //                     color: Color(0xffF5F6FA)),
                          //               ),
                          //               // border: InputBorder.none,
                          //               hintText: "Select Country",
                          //               hintStyle: TextStyle(
                          //                   color: Colors.grey, fontSize: 15)),
                          //           onChanged: (value) {
                          //             this.controller.text = value;
                          //             updatedCountry = this.controller.text;
                          //           },
                          //           onSubmitted: (value) {
                          //             this.controller.text = value;
                          //             updatedCountry = this.controller.text;
                          //           })),
                          // ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 500,
                              margin: EdgeInsets.only(top: 10, left: 15),
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
                          // Align(
                          //   alignment: Alignment.topLeft,
                          //   child: Container(
                          //     margin: EdgeInsets.only(left: 15, top: 10),
                          //     width: 500,
                          //     child: TextFormField(
                          //       // controller: rolecontroller,
                          //       // initialValue: "", // autofocus: false,
                          //       // maxLines: 3,
                          //       onChanged: (value) {
                          //         rroles = value;
                          //       },
                          //       validator: Validators.compose([
                          //         Validators.required(' required'),
                          //       ]),
                          //       style: TextStyle(
                          //           color: Colors.black54, fontSize: 17),
                          //       decoration: InputDecoration(
                          //           fillColor: Color(0xffF5F6FA),
                          //           filled: true,
                          //           enabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           focusedBorder: new OutlineInputBorder(
                          //             // borderRadius: new BorderRadius.circular(25.0),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           errorBorder: OutlineInputBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(4)),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           focusedErrorBorder: OutlineInputBorder(
                          //             borderRadius:
                          //                 BorderRadius.all(Radius.circular(4)),
                          //             borderSide: BorderSide(
                          //                 width: 1.2, color: Color(0xffF5F6FA)),
                          //           ),
                          //           // border: InputBorder.none,
                          //           hintText: "Select Role",
                          //           hintStyle: TextStyle(
                          //               color: Colors.grey, fontSize: 15)),
                          //     ),
                          //   ),
                          // ),

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
      ),
    );
  }

  // _buildCountryPickerDropdown({
  //   bool sortedByIsoCode = false,
  // }) {
  //   double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.13;
  //   //respect dropdown button icon size
  //   double dropdownItemWidth = dropdownButtonWidth - 30;
  //   double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
  //   return Row(
  //     children: <Widget>[
  //       SizedBox(
  //         width: dropdownButtonWidth,
  //         child: CountryPickerDropdown(
  //           dropdownColor: Colors.white,
  //           iconEnabledColor: Colors.black,
  //           iconDisabledColor: Colors.black,
  //           iconSize: 16,
  //           /* underline: Container(
  //             height: 2,
  //             color: Colors.red,
  //           ),*/
  //           //show'em (the text fields) you're in charge now
  //           onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
  //           //if you have menu items of varying size, itemHeight being null respects
  //           //that, IntrinsicHeight under the hood ;).
  //           itemHeight: null,
  //           //itemHeight being null and isDense being true doesn't play along
  //           //well together. One is trying to limit size and other is saying
  //           //limit is the sky, therefore conflicts.
  //           //false is default but still keep that in mind.
  //           isDense: false,
  //           //if you want your dropdown button's selected item UI to be different
  //           //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
  //           // selectedItemBuilder: hasSelectedItemBuilder == true
  //           //     ? (Country country) => _buildDropdownSelectedItemBuilder(
  //           //         country, dropdownSelectedItemWidth)
  //           //     : null,
  //           //initialValue: 'AR',
  //           // itemBuilder: (Country country) => hasSelectedItemBuilder == true
  //           //     ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
  //           //     : _buildDropdownItem(country, dropdownItemWidth),
  //           // initialValue: 'AR',
  //           // itemFilter: filtered
  //           //     ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
  //           //     : null,
  //           // //priorityList is shown at the beginning of list
  //           // priorityList: hasPriorityList
  //           //     ? [
  //           //         CountryPickerUtils.getCountryByIsoCode('GB'),
  //           //         CountryPickerUtils.getCountryByIsoCode('CN'),
  //           //       ]
  //           //     : null,
  //           sortComparator: sortedByIsoCode
  //               ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
  //               : null,
  //           onValuePicked: (Country country) {
  //             print("${country.phoneCode}");
  //             countrycontroller.text = country.name;
  //             countrycode = country.phoneCode;
  //           },
  //         ),
  //       ),
  //       SizedBox(
  //         width: 8.0,
  //       ),
  //       Expanded(
  //         child: Container(
  //           // margin: EdgeInsets.all(10),
  //           child: TextFormField(
  //             controller: mobilecontroller, // maxLines: 3,
  //             // inputFormatters: [
  //             //   // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
  //             //   FilteringTextInputFormatter.digitsOnly,
  //             //   LengthLimitingTextInputFormatter(10)
  //             // ],
  //             onChanged: (value) {
  //               rphone = value;
  //             },
  //             style: TextStyle(color: Colors.black54, fontSize: 17),
  //             decoration: InputDecoration(
  //                 fillColor: Color(0xffF5F6FA),
  //                 filled: true,
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide:
  //                       BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
  //                 ),
  //                 focusedBorder: new OutlineInputBorder(
  //                   // borderRadius: new BorderRadius.circular(25.0),
  //                   borderSide:
  //                       BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
  //                 ),
  //                 errorBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(4)),
  //                   borderSide:
  //                       BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
  //                 ),
  //                 focusedErrorBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(4)),
  //                   borderSide:
  //                       BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
  //                 ),
  //                 // border: InputBorder.none,
  //                 hintText: "Mobile Number",
  //                 hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
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

  Widget logOut() {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreenClient()),
          (Route<dynamic> route) => false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: Color(0xffE5E5E5),
        ),
        margin: EdgeInsets.only(right: 10, bottom: 20),
        // height: adduser == 0 ? h * 0.30 : h * 0.10,
        width: w,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.black),
                  // borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xff1A494F)),
              child: Center(
                child: Icon(Icons.logout, color: Colors.white),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Log out",
                    style: TextStyle(
                        color: Color(0xff1A494F),
                        fontSize: 18,
                        fontWeight: FontWeight.w500))),
          ],
        ),
      ),
    );
  }
}

class ExpansionpanelItem {
  bool isExpanded;
  final String title;
  final Widget content;

  ExpansionpanelItem({
    required this.isExpanded,
    required this.title,
    required this.content,
  });
}
