// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/CustomAlertDialog.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Shipment/getShipmentEmployeeModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Profile.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Settings.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:shipment/constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';

class SettingsShipment extends StatefulWidget {
  const SettingsShipment({Key? key}) : super(key: key);

  @override
  _SettingsShipmentState createState() => _SettingsShipmentState();
}

class _SettingsShipmentState extends State<SettingsShipment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var _passwordController = new TextEditingController();
  var _confirmpasswordController = new TextEditingController();
  var _emailController = new TextEditingController();
  var h, w;
  bool? monVal = false;
  bool? monVal2 = false;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  var adduser = -1;
  String imagepath = '';
  Image? image;
  var id = [];
  var uname = [];

  var ucountry = [];
  var uaddress = [];
  var ulname = [];
  var uphone = [];
  var uemail = [];
  var status = [];

  var uprofileImage = [];
  List<EmployeeData>? employeedata;

  var profileexp = -1;
  var timezoneexp = -1;
  String? imagePath;
  PlatformFile? objFile = null;
  bool isProcess = false;

  String? category;

  var amount;
  var item = [
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
  String? name1, lname1, email1, phone, address1, roles;
  var name,
      lname,
      email,
      mobileNumber,
      languages,
      password,
      aboutMe,
      username,
      companyname,
      country,
      profileImage;
  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updateLanguauge,
      updatedEmail,
      updatedpassword,
      updatedcompanyname;
  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentProfile();
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        aboutMe = response.data[0].about_me;
        profileImage = response.data[0].profileimage;
        username = response.data[0].username;
        address1 = response.data[0].address;
        companyname = response.data[0].companyname;
      });

      log("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });

    // id =   response.user[universityList.indexOf(name)].id
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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  chooseFileUsingFilePicker(context);
                                  setState(() {});
                                },
                                child: const Icon(Icons.camera)),
                            const Spacer(),
                            Text('takeapicture'.tr()),
                            const SizedBox(width: 50),
                            // InkWell(
                            //     onTap: () {
                            //       Navigator.pop(context);
                            //     },
                            //     child: const Icon(Icons.cancel)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  doResetPassword() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      var resetData1 = {
        "email": "$email",
        "password": "${encodeToSHA3(passwordd)}",
        "password_confirmation": "${encodeToSHA3(confirmPassword)}",
      };
      print(jsonEncode(resetData1));
      var register = await Providers().getShipmentResetPassword(resetData1);

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

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLastName == null ? "$lname" : "$updatedLastName",
      "email": "$email",
      "phone": updatedNumber == null ? mobileNumber : updatedNumber,
      "country": updatedCountry == null ? "$country" : "$updatedCountry",
      "address": updatedAddress == null ? "$address1" : "$updatedAddress",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge",
      "companyname":
          updatedcompanyname == null ? "$companyname" : "$updatedcompanyname",
    };
    var response = await Providers().updateShipment(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        aboutMe = response.data[0].aboutMe;
        address1 = response.data[0].address;
        profileImage = response.data[0].profileimage;
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
                        builder: (context) => const ResShipmentSettings()));
              },
              child: Text('ok'.tr()),
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
              child: Text('ok').tr(),
            ),
          ],
        ),
      );
    }

    // id =   response.user[universityList.indexOf(name)].id
  }

  var passwordexp = -1;
  var emailAddress, passwordd, confirmPassword;
  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  List<ExpansionpanelItem> items = <ExpansionpanelItem>[
    ExpansionpanelItem(
        isExpanded: false,
        title: 'usermanagement'.tr(),
        content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: <Widget>[
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: 5,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) => userManagement2(
                        //         name: uname.toString(),
                        //         lname: ulname.toString(),
                        //         email: uemail.toString(),
                        //         phone: uphone.toString(),
                        //         country: ucountry.toString(),
                        //         address: uaddress.toString()));
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 15, right: 15),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Image.asset(
                                      'assets/images/Ellipse7.png',
                                      fit: BoxFit.fill),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(top: 15),
                                          child: const Text(("Shishank"),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              )),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, right: 10),
                                          child: const Text(("Lunch"),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              softWrap: false,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
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
                          )),
                    );
                  }),
            ])),
        leading: const Icon(Icons.person, color: Color(0xff1A494F))),
  ];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    print(uname);
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: ShipmentSidebar(),
        ),
        body: isProcess == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
                color: const Color(0xffE5E5E5),
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
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                              ),
                            // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                              child: Text(
                                'settings'.tr(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (Responsive.isDesktop(context))
                        Column(
                          children: [
                            profileProgress(),
                            userManagement(),
                          ],
                        ),
                      if (Responsive.isMobile(context))
                        Column(
                          children: [
                            profileProgress(),
                            userManagement(),
                            profileExpand(),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 5.0),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                  height: 36,
                                )),
                            passwordExpand(),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 5.0),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                  height: 36,
                                )),
                            notificationExpand(),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 5.0),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                  height: 36,
                                )),
                            timezoneExpand(),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 5.0),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                  height: 36,
                                )),
                            deleteAccountxpand(),
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 5.0),
                                child: const Divider(
                                  color: Colors.black,
                                  thickness: 2,
                                  height: 36,
                                )),
                            // addUser(),
                            // logOut(),
                          ],
                        )
                    ])),
              ));
  }

  Widget profileProgress() {
    return Container(
        margin: const EdgeInsets.all(15),
        height: 200,
        width: MediaQuery.of(context).size.width * (90 / 100),
        decoration: const BoxDecoration(color: Color(0xff1A494F)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 90.0,
                height: 90.0,
                margin: const EdgeInsets.only(top: 12),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(200),
                  elevation: 10,
                  child: Stack(
                    children: [
                      profileImage == ''
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              child: Center(
                                  child: Icon(
                                Icons.person,
                                size: 30,
                              )),
                            )
                          : imagepath != ''
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.network((imagepath),
                                          fit: BoxFit.cover)))
                              : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
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
                        bottom: 4,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child: InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child:
                                  const Icon(Icons.add, color: Colors.black)),
                        ),
                      )
                    ],
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
                          margin: const EdgeInsets.only(
                              top: 80, bottom: 5, left: 10),
                          child: Text("$name",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 80, bottom: 5, left: 5),
                          child: Text("$lname",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ),
                      ]),
                      Container(
                        margin: const EdgeInsets.only(right: 10, left: 10),
                        child: Text("$email",
                            style: const TextStyle(
                              color: Color(0xff90A0B7),
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //         margin: EdgeInsets.only(left: 10),
                      //         child: Icon(
                      //           Icons.call,
                      //           size: 18,
                      //           color: Colors.white,
                      //         )),
                      //     Container(
                      //         margin: EdgeInsets.only(left: 30),
                      //         child: Icon(
                      //           Icons.message_outlined,
                      //           size: 18,
                      //           color: Colors.white,
                      //         )),
                      //     Container(
                      //         margin: EdgeInsets.only(left: 30),
                      //         child: Icon(
                      //           Icons.location_on,
                      //           size: 18,
                      //           color: Colors.white,
                      //         )),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget userManagement() {
    return Container(
      // color: Color(0xffE5E5E5),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (Responsive.isDesktop(context)) ? 55 : 37),
              child: Icon(Icons.person, color: Color(0xff1A494F)),
            ),
            SizedBox(
              width: (Responsive.isDesktop(context)) ? 80 : 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE);
              },
              child: Text(
                'companyprofile'.tr(),
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1A494F)),
              ),
            ),
          ],
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
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10),
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
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("profile".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
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
                            child: Text("$name" + " " + "$lname",
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("profile".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: Text("namesurnamemailaddress".tr(),
                                style: headingStyle16NBLightGrey())),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          width: 500,
                          child: TextFormField(
                            initialValue: "$name", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {
                              updatedName = v;
                            },
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
                            decoration: const InputDecoration(
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
                                hintText: "Shishank",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "$lname", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {
                              updatedLastName = v;
                            },
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
                            decoration: const InputDecoration(
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
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          child: TextFormField(
                            enabled: false,
                            initialValue: "$email", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
                            decoration: const InputDecoration(
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
                                color: const Color(0xff1A494F)),
                            margin: const EdgeInsets.only(left: 15, top: 15),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  updateProfileApi();
                                },
                                child: Text(
                                  "update".tr(),
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
            color: const Color(0xffE5E5E5),
          ),
          margin: const EdgeInsets.only(right: 10),
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
                                margin:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Text("password".tr(),
                                    style: headingStyleBold())),
                            const Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  // borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xff1A494F)),
                              child: const Center(
                                child: Icon(Icons.arrow_drop_down_outlined,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("youremailaddress".tr() + " $email",
                                  style: headingStyle16NBLightGrey())),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Text("Password",
                                    style: headingStyleBold())),
                            const Spacer(),
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  // borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xff1A494F)),
                              child: const Center(
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
                        //       child:
                        //           Text("", style: headingStyle16NBLightGrey())),
                        // ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            width: 500,
                            child: TextFormField(
                              // controller: _passwordController,
                              // initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              onChanged: (v) {
                                passwordd = v;
                              },
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 17),
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
                                  hintText: "newpassword".tr(),
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            width: 500,
                            child: TextFormField(
                              // controller: _confirmpasswordController,
                              // initialValue: "", // autofocus: false,
                              // maxLines: 3,
                              onChanged: (v) {
                                confirmPassword = v;
                              },
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 17),
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
                                  hintText: "confirmpassword".tr(),
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
                                  color: const Color(0xff1A494F)),
                              margin: const EdgeInsets.only(left: 15, top: 15),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    doResetPassword();
                                  },
                                  child: Text(
                                    "updatepassword".tr(),
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
          margin: const EdgeInsets.only(left: 10, top: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  activeColor: const Color(0xff1A494F),
                  value: monVal2,
                  onChanged: (bool? value) async {
                    setState(() {
                      monVal2 = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Text("receiveweeklydigestmails".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Theme(
                data: Theme.of(context)
                    .copyWith(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  activeColor: const Color(0xff1A494F),
                  value: monVal,
                  onChanged: (bool? value) async {
                    setState(() {
                      monVal = value;
                    });
                  },
                ),
              ),
              Text("receivenewratingannouncements".tr(),
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
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10),
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
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("notifications".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: Text("rateitwillsendyounotifications".tr(),
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("notifications".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
                              child: Icon(Icons.arrow_drop_up_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: Text("rateitwillsendyounotifications".tr(),
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
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10),
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
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("timezone".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
                              child: Icon(Icons.arrow_drop_down_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                                "yourtimezoneiscurrentlysettopacifictime".tr(),
                                style: headingStyle16NBLightGrey())),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 15, top: 10),
                              child: Text("timezone".tr(),
                                  style: headingStyleBold())),
                          const Spacer(),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                // borderRadius: BorderRadius.circular(10.0),
                                color: const Color(0xff1A494F)),
                            child: const Center(
                              child: Icon(Icons.arrow_drop_up_outlined,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                                "yourtimezoneiscurrentlysettopacifictime".tr(),
                                style: headingStyle16NBLightGrey())),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 10),
                        decoration: const BoxDecoration(
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
                                    return item.map<PopupMenuItem<String>>(
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
    return InkWell(
      onTap: () {
        // setState(() {
        //   timezoneexp == -1 ? timezoneexp = 0 : timezoneexp = -1;
        //   log("EXP2 >> $exp2");
        // });
      },
      // onDoubleTap: () {
      //   setState(() {
      //     timezoneexp = -1;
      //     log("EXP2 >> $exp2");
      //   });
      // },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10),
        height: timezoneexp == 0 ? h * 0.30 : h * 0.10,
        width: w,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 15, top: 10),
                    child:
                        Text("deleteaccount".tr(), style: headingStyleBold())),
                const Spacer(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      height: 25,
                      width: 85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xff1A494F)),
                      margin: const EdgeInsets.only(left: 15, top: 15),
                      child: Center(
                        child: Text(
                          "deactivate".tr(),
                          style: TextStyle(
                              color: Color(0xffFFFFFF),
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  child: Text("ifyounolongerwanttoreceiveemails".tr(),
                      style: headingStyle16NBLightGrey())),
            )
          ],
        ),
      ),
    );
  }

  Widget addUser() {
    return InkWell(
      onTap: () {
        setState(() {
          adduser == -1 ? adduser = 0 : adduser = -1;
          log("EXP2 >> $exp2");
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
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10),
        height: adduser == 0 ? h : h * 0.10,
        width: w,
        child: Column(
          children: [
            adduser != 0
                ? Container(
                    decoration: BoxDecoration(
                      // border: Border.all(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color(0xffE5E5E5),
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    // height: adduser == 0 ? h * 0.30 : h * 0.10,
                    width: w,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 0.5, color: Colors.black),
                              // borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xff1A494F)),
                          child: const Center(
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text("addaccount".tr(),
                                style: TextStyle(
                                    color: Color(0xff1A494F),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500))),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0),
                          color: const Color(0xffE5E5E5),
                        ),
                        margin: const EdgeInsets.only(right: 10),
                        // height: adduser == 0 ? h * 0.30 : h * 0.10,
                        width: w,
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: Colors.black),
                                  // borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xff1A494F)),
                              child: const Center(
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Text("addaccount".tr(),
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
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "firstname".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "lastname".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 500,
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "emailid".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "phonenumber".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "country".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: 500,
                          margin: const EdgeInsets.only(top: 10, left: 15),
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "address".tr(),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          width: 500,
                          child: TextFormField(
                            initialValue: "", // autofocus: false,
                            // maxLines: 3,
                            onChanged: (v) {},
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 17),
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
                                hintText: "password".tr(),
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
                      //       initialValue: "", // autofocus: false,
                      //       // maxLines: 3,
                      //       onChanged: (v) {},
                      //       style:
                      //           TextStyle(color: Colors.black54, fontSize: 17),
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
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget logOut() {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var getRem = prefs.get("rem");
        var reEmail = '';
        var rePass = '';
        var reStatus = false;

        if (getRem != null) {
          reEmail = prefs.getString("email")!;
          rePass = prefs.getString("password")!;
          reStatus = prefs.getBool("rem")!;
        }
        prefs.clear();
        prefs.setString('email', reEmail);
        prefs.setString('password', rePass);
        prefs.setBool('rem', reStatus);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreenShipment()),
          (Route<dynamic> route) => false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          // border: Border.all(width: 0.5, color: Colors.black),
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xffE5E5E5),
        ),
        margin: const EdgeInsets.only(right: 10, bottom: 20),
        // height: adduser == 0 ? h * 0.30 : h * 0.10,
        width: w,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.black),
                  // borderRadius: BorderRadius.circular(10.0),
                  color: const Color(0xff1A494F)),
              child: const Center(
                child: Icon(Icons.logout, color: Colors.white),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text("Log out",
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
  final Icon leading;

  ExpansionpanelItem(
      {required this.isExpanded,
      required this.title,
      required this.content,
      required this.leading});
}
