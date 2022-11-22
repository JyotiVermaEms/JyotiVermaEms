import 'dart:convert';
import 'dart:developer';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:searchfield/searchfield.dart';
import 'package:sha3/sha3.dart';

import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Element/alertdialogshipmentAddUser.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_AddUser.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/constants.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _formkey1 = new GlobalKey<FormState>();

  GlobalKey<FormState> _formKey2 = new GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController countrycontroller = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  DateTime? selectedDate = DateTime.now();
  Image? image;
  var h, w;
  String imagepath = '';
  PlatformFile? objFile = null;
  var fromLocation = '';

  var addAccounte = -1;
  var adduser = -1;
  String filter = 'Arrival Manager';

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

  List<String> roleList = [
    'Account Manager',
    'Departure Manager',
    'Arrival Manager',
    'Pickup agent',
  ];
  String? Ename1,
      Elname1,
      Eemail1,
      Ephone,
      Eaddress,
      Eroles,
      Ecountry,
      Epassword,
      Eusername;

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
      });

      log("REPONSE" + jsonEncode(response.data));
      log("about show blow >>>>>>>>>>>???????????????" +
          jsonEncode(aboutMe.toString()));
    }
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLName == null ? "$lname" : "$updatedLName",
      "email": "$email",
      "phone": updatedNumber == null ? mobileNumber : updatedNumber,
      "country": updatedCountry == null ? "$country" : "$updatedCountry",
      "address": " ",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge",
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
      });

      log("REPONSE" + jsonEncode(response.data));

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShipmentAddUser()));
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

  Future addEmployee() async {
    var employeeDetails = {
      "name": "$Ename1",
      "lname": "$Elname1",
      "email": "$Eemail1",
      "phone": "$Ephone",
      "country": countrycontroller.text,
      "address": "$Eaddress",
      "password": "${encodeToSHA3(Epassword)}",
      "npassword": "$Epassword",
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
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
      // showDialog<String>(
      //   context: context,
      //   builder: (BuildContext context) => AlertDialog(
      //     content: Text(response.message),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () => Navigator.pop(context, 'OK'),
      //         child: const Text('OK'),
      //       ),
      //     ],
      //   ),
      // );

      log("REPONSEggg" + jsonEncode(response.data));
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

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateProfileApi();
    // addEmployee();
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

  void _showPicker(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
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
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
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

  Widget profileView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200.0,
        height: 200.0,
        margin: EdgeInsets.only(top: 12),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(200),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(200),
          elevation: 10,
          child: Stack(
            children: [
              profileImage == null
                  ? Center(
                      child: Icon(
                      Icons.add_a_photo,
                    ))
                  : imagepath != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network((imagepath),
                                  fit: BoxFit.cover)))
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Container(
                              height: 90,
                              width: 90,

                              // color: Colors.red,
                              child: Image.network(profileImage,
                                  fit: BoxFit.cover))

                          // image == ""
                          //     ? Image.network(profileImage,
                          //         fit: BoxFit.cover)
                          //     : Container()),
                          ),
              Positioned(
                bottom: 10,
                right: 21,
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
    );
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Add Account & User',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  (Responsive.isDesktop(context)) ? 22 : 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Spacer(),

                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: IconButton(
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black.withOpacity(0.5),
                              size: 30,
                            ),
                            onPressed: () => Navigator.pop(context)),
                      )
                    ],
                  ),
                ),
                if (Responsive.isDesktop(context))
                  Column(
                    children: [
                      addAccount(),
                    ],
                  ),
                if (!Responsive.isDesktop(context)) addAccountMobile(),
                addUser()
                // if (Responsive.isMobile(context))
              ])),
        ));
  }

  Widget addAccount() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xffFFFFFF)),

      // height: 100,

      width: MediaQuery.of(context).size.width * (80 / 100),
      child: Form(
        key: _formkey1,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Role Information",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Select Role",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF5F6FA),
                    border: Border.all(color: Color(0xffF5F6FA), width: 1.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: MediaQuery.of(context).size.width * (66 / 100),
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(left: 15, bottom: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      hint: Text("selectstatus".tr()),
                      value: filter,
                      // icon: Icon(Icons.arrow_drop_down),
                      // iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      onChanged: (String? value) {
                        setState(() {
                          filter = value!;
                          Eroles = filter;
                          print("KKKKKKKKKKKKK$Eroles");
                        });

                        // controller1.selection = TextSelection.fromPosition(
                        //     TextPosition(offset: controller1.text.length));
                      },
                      items: <String>[
                        'Account Manager',
                        'Departure Manager',
                        'Arrival Manager',
                        'Pickup agent',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 15),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  //  EasyAutocomplete(
                  //   suggestions: roleList,
                  //   controller: this.controller1,
                  //   decoration: InputDecoration(
                  //       fillColor: Color(0xffF5F6FA),
                  //       filled: true,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         // borderRadius: new BorderRadius.circular(25.0),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(4)),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(4)),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                  //       ),
                  //       // border: InputBorder.none,
                  //       hintText: "Enter Role",
                  //       hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  //   onChanged: (value) {
                  //     Eroles = value;
                  //     print("KKKKKKKKKKKKK$Eroles");

                  //     controller1.selection = TextSelection.fromPosition(
                  //         TextPosition(offset: controller1.text.length));
                  //   },
                  //   onSubmitted: (value) {
                  //     controller1.text = value.toString();
                  //   },
                  // )),
                )),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                          left: 15,
                        ),
                        child:
                            Text("First Name", style: TextStyle(fontSize: 14))),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      width: 500,
                      child: TextFormField(
                        initialValue: "", // autofocus: false,
                        // maxLines: 3,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.allow(
                        //       (RegExp("[a-zA-Z -]"))),
                        // ],
                        // validator: Validators.compose([
                        //   Validators.required(' required'),
                        //   Validators.patternString(
                        //       r'^([a-zA-Z])', 'Invalid name'),
                        //   Validators.maxLength(255, "")
                        // ]),
                        validator: Validators.compose([
                          Validators.required(' required'),
                        ]),
                        onChanged: (v) {
                          Ename1 = v;
                        },
                        style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            hintText: "Enter First Name",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      child: Text(
                        "Last Name",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      width: 500,
                      child: TextFormField(
                        initialValue: "", // autofocus: false,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              (RegExp("[a-zA-Z -]"))),
                        ],
                        validator: Validators.compose([
                          Validators.required(' required'),
                        ]),
                        // maxLines: 3,
                        // validator: Validators.compose([
                        //   Validators.required(' required'),
                        //   Validators.patternString(
                        //       r'^([a-zA-Z])', 'Invalid last name'),
                        //   Validators.maxLength(255, "")
                        // ]),
                        onChanged: (v) {
                          Elname1 = v;
                        },
                        style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            hintText: "Enter Last Name",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ],
                )
              ],
            ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15, top: 10),
            //     width: 500,
            //     child: TextFormField(
            //       initialValue: "", // autofocus: false,
            //       // maxLines: 3,
            //       inputFormatters: [
            //         FilteringTextInputFormatter.allow(
            //             (RegExp("[a-zA-Z -]"))),
            //       ],
            //       validator: Validators.compose([
            //         Validators.required(' required'),
            //         Validators.patternString(
            //             r'^([a-zA-Z])', 'Invalid name'),
            //         Validators.maxLength(255, "")
            //       ]),
            //       onChanged: (v) {
            //         Ename1 = v;
            //       },
            //       style: TextStyle(color: Colors.black54, fontSize: 17),
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
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           focusedErrorBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           // border: InputBorder.none,
            //           hintText: "First Name",
            //           hintStyle:
            //               TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15, top: 10),
            //     width: 500,
            //     child: TextFormField(
            //       initialValue: "", // autofocus: false,
            //       inputFormatters: [
            //         FilteringTextInputFormatter.allow(
            //             (RegExp("[a-zA-Z -]"))),
            //       ],
            //       // maxLines: 3,
            //       // validator: Validators.compose([
            //       //   Validators.required(' required'),
            //       //   Validators.patternString(
            //       //       r'^([a-zA-Z])', 'Invalid last name'),
            //       //   Validators.maxLength(255, "")
            //       // ]),
            //       onChanged: (v) {
            //         Elname1 = v;
            //       },
            //       style: TextStyle(color: Colors.black54, fontSize: 17),
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
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           focusedErrorBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           // border: InputBorder.none,
            //           hintText: "Last Name",
            //           hintStyle:
            //               TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //       margin: EdgeInsets.only(left: 15, top: 10),
            //       child: Text("Warehouse Name", style: headingStyle16SB())),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15),
            //     // width: MediaQuery.of(context).size.width * (50 / 100),
            //     child: TextFormField(
            //       // controller: this.namecontroller,
            //       // initialValue: "$name", // autofocus: false,
            //       // maxLines: 3,
            //       onChanged: (v) {
            //         // updatedName = v;
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
            //           hintText: "Please give a name to you warehouse",
            //           hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("Enter Address", style: TextStyle(fontSize: 14))),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(left: 15, bottom: 10, top: 10),
                width: MediaQuery.of(context).size.width * (66 / 100),
                child: TextFormField(
                  // controller: this.namecontroller,
                  // initialValue: "$name", // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {
                    Eaddress = v;
                  },
                  validator: Validators.compose([
                    Validators.required(' required'),
                  ]),
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
                      hintText: "Enter Address",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addAccountMobile() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xffFFFFFF)),

      // height: 100,

      width: MediaQuery.of(context).size.width * (80 / 100),
      child: Form(
        key: _formkey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Role Information",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Select Role",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left: 15, bottom: 10, right: 10),
                  child: EasyAutocomplete(
                    suggestions: roleList,
                    controller: this.controller1,
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
                        hintText: "Enter Role",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                    onChanged: (value) {
                      Eroles = value;

                      controller1.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller1.text.length));
                    },
                    onSubmitted: (value) {
                      controller1.text = value;
                    },
                  )),
            ),
            Container(
                margin: EdgeInsets.only(
                  left: 15,
                ),
                child: Text("First Name", style: TextStyle(fontSize: 14))),
            Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                initialValue: "", // autofocus: false,
                // maxLines: 3,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(
                //       (RegExp("[a-zA-Z -]"))),
                // ],
                // validator: Validators.compose([
                //   Validators.required(' required'),
                //   Validators.patternString(
                //       r'^([a-zA-Z])', 'Invalid name'),
                //   Validators.maxLength(255, "")
                // ]),
                validator: Validators.compose([
                  Validators.required(' required'),
                ]),
                onChanged: (v) {
                  Ename1 = v;
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
                    hintText: "Enter First Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Text(
                    "Last Name",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, top: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    initialValue: "", // autofocus: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow((RegExp("[a-zA-Z -]"))),
                    ],
                    validator: Validators.compose([
                      Validators.required(' required'),
                    ]),
                    // maxLines: 3,
                    // validator: Validators.compose([
                    //   Validators.required(' required'),
                    //   Validators.patternString(
                    //       r'^([a-zA-Z])', 'Invalid last name'),
                    //   Validators.maxLength(255, "")
                    // ]),
                    onChanged: (v) {
                      Elname1 = v;
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
                        hintText: "Enter Last Name",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15, top: 10),
            //     width: 500,
            //     child: TextFormField(
            //       initialValue: "", // autofocus: false,
            //       // maxLines: 3,
            //       inputFormatters: [
            //         FilteringTextInputFormatter.allow(
            //             (RegExp("[a-zA-Z -]"))),
            //       ],
            //       validator: Validators.compose([
            //         Validators.required(' required'),
            //         Validators.patternString(
            //             r'^([a-zA-Z])', 'Invalid name'),
            //         Validators.maxLength(255, "")
            //       ]),
            //       onChanged: (v) {
            //         Ename1 = v;
            //       },
            //       style: TextStyle(color: Colors.black54, fontSize: 17),
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
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           focusedErrorBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           // border: InputBorder.none,
            //           hintText: "First Name",
            //           hintStyle:
            //               TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15, top: 10),
            //     width: 500,
            //     child: TextFormField(
            //       initialValue: "", // autofocus: false,
            //       inputFormatters: [
            //         FilteringTextInputFormatter.allow(
            //             (RegExp("[a-zA-Z -]"))),
            //       ],
            //       // maxLines: 3,
            //       // validator: Validators.compose([
            //       //   Validators.required(' required'),
            //       //   Validators.patternString(
            //       //       r'^([a-zA-Z])', 'Invalid last name'),
            //       //   Validators.maxLength(255, "")
            //       // ]),
            //       onChanged: (v) {
            //         Elname1 = v;
            //       },
            //       style: TextStyle(color: Colors.black54, fontSize: 17),
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
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           focusedErrorBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(4)),
            //             borderSide: BorderSide(
            //                 width: 1.2, color: Color(0xffF5F6FA)),
            //           ),
            //           // border: InputBorder.none,
            //           hintText: "Last Name",
            //           hintStyle:
            //               TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //       margin: EdgeInsets.only(left: 15, top: 10),
            //       child: Text("Warehouse Name", style: headingStyle16SB())),
            // ),
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 15),
            //     // width: MediaQuery.of(context).size.width * (50 / 100),
            //     child: TextFormField(
            //       // controller: this.namecontroller,
            //       // initialValue: "$name", // autofocus: false,
            //       // maxLines: 3,
            //       onChanged: (v) {
            //         // updatedName = v;
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
            //           hintText: "Please give a name to you warehouse",
            //           hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            //     ),
            //   ),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: EdgeInsets.only(left: 15, top: 10),
                  child: Text("Enter Address", style: TextStyle(fontSize: 14))),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin:
                    EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 10),
                width: MediaQuery.of(context).size.width,
                child: TextFormField(
                  // controller: this.namecontroller,
                  // initialValue: "$name", // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {
                    Eaddress = v;
                  },
                  validator: Validators.compose([
                    Validators.required(' required'),
                  ]),
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
                      hintText: "Enter Address",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addUser() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Color(0xffFFFFFF)),

      // height: 100,

      width: MediaQuery.of(context).size.width * (80 / 100),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Account Information",
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
          ),
          // Container(
          //     margin: EdgeInsets.only(left: 10),
          //     child: Text("Add Account",
          //         style: TextStyle(
          //             color: Color(0xff1A494F),
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500))),
          Form(
            key: _formKey,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //     margin: EdgeInsets.only(left: 10),
                  //     child: Text("Add Account",
                  //         style: TextStyle(
                  //             color: Color(0xff1A494F),
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w500))),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (66 / 100)
                          : MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(top: 10, left: 30),
                      child: TextFormField(
                        initialValue: "", // autofocus: false,

                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-z A-Z á-ú Á-Ú 0-9]")),
                        ],
                        // maxLines: 3,
                        validator: Validators.compose([
                          Validators.required(' required'),
                          // Validators.email("invalid email"),
                        ]),
                        onChanged: (v) {
                          Eusername = v;
                        },
                        style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (66 / 100)
                          : MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(top: 10, left: 30),
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
                        style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 30, top: 10),
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (68 / 100)
                          : MediaQuery.of(context).size.width * (83 / 100),
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
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 30, top: 10),
                        // height: 50,
                        width: (Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (66 / 100)
                            : MediaQuery.of(context).size.width * 0.8,
                        child: EasyAutocomplete(
                            suggestions: _countries,
                            controller: countrycontroller,
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
                                hintText: "Country",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                            onChanged: (value) {
                              countrycontroller.text = value;
                              // Ecountry = countrycontroller.text;

                              countrycontroller.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: countrycontroller.text.length));
                            },
                            onSubmitted: (value) {
                              countrycontroller.text = value;
                              // Ecountry = countrycontroller.text;
                            })),
                  ),

                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 30, top: 10),
                      width: (Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (66 / 100)
                          : MediaQuery.of(context).size.width * (80 / 100),
                      child: TextFormField(
                        initialValue: "", // autofocus: false,
                        // maxLines: 3,
                        onChanged: (v) {
                          Epassword = v;
                        },
                        validator: Validators.compose([
                          Validators.required(' required'),
                          // Validators.patternString('invalid Password'),
                        ]),
                        style: TextStyle(color: Colors.black54, fontSize: 17),
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
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (this._formKey.currentState!.validate() &&
                          this._formkey1.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (Eroles!.isEmpty) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Text("Plese select Role"),
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
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        // log("signupapi");
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
            ]),
          )
        ],
      ),
    );
  }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    double dropdownButtonWidth = (Responsive.isDesktop(context))
        ? MediaQuery.of(context).size.width * 0.13
        : MediaQuery.of(context).size.width * 0.38;
    ;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryCodePicker(
            flagWidth: 30.0,
            showFlag: true,
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
          width: (Responsive.isDesktop(context)) ? 8.0 : 2.0,
        ),
        Expanded(
          child: Container(
            child: TextFormField(
              onChanged: (v) {
                Ephone = v;
              },
              validator: Validators.compose([
                Validators.required(' required'),
              ]),
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
