// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:intl/intl.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Client/getReceptionistModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/GoodsInfo.dart';
import 'package:shipment/helper/routes.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class SelectReceptionist extends StatefulWidget {
  var data;

  SelectReceptionist(this.data);
  // const SelectReceptionist({Key? key}) : super(key: key);

  @override
  _SelectReceptionistState createState() => _SelectReceptionistState();
}

class _SelectReceptionistState extends State<SelectReceptionist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  String? filter, filtername, filternumber, filteraddress, filtercountry;

  final TextEditingController _pickupdatecontrollr =
      new TextEditingController();
  final TextEditingController _dropOffdatecontrollr =
      new TextEditingController();

  final TextEditingController receptionistName = TextEditingController();
  final TextEditingController _emails = TextEditingController();

  final TextEditingController _contactnumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _country = TextEditingController();

  final TextEditingController _pickuptimecontrollr =
      new TextEditingController();
  final TextEditingController _dropOfftimecontrollr =
      new TextEditingController();

  TextEditingController pickUpTextEditingController = TextEditingController();

  DateTime _startDate = DateTime.now();

  String test = '';

  var h, w;
  var exp = true, openSUBMENU = false;
  var exp2 = -1;
  int? _radioValue = 0;

  var receptionName,
      receptionEmail,
      receptionContact,
      receptionAddress,
      receptionCountry;

  var pickup_location, pickup_miles_diff, pickup_estimate;
  var dropOff_location, dropOff_miles_diff, dropOff_estimate;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool isUserNameValidate = true;
  GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey3 = GlobalKey<FormState>();
  // Mode? _mode = Mode.overlay;

  void _handleRadioValueChange(value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
    print(_radioValue);
  }

  requiredField(val, field) {
    if (val.isEmpty) {
      return ' required';
    }
  }

  _phoneValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
    final RegExp oneDot = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
    if (!oneDot.hasMatch(val)) return "Enter must be 10 digits";
  }

  _estimateValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  _emailValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  _totalValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  TimeOfDay initialTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null && timeOfDay != initialTime) {
      setState(() {
        _radioValue = 0;
        initialTime = timeOfDay;
      });
    }
  }

  _selectTime1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != initialTime) {
      setState(() {
        _radioValue = 1;
        initialTime = timeOfDay;
      });
    }
  }

  DateTime initialDate = DateTime.now();
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate)
      setState(() {
        initialDate = picked;

        _radioValue = 1;
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

  DateTime initialDate1 = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate1,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != initialDate1)
      setState(() {
        initialDate1 = picked;

        _radioValue = 0;
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

  List<ReceptionData> receltionData = [];

  getReceptionistData() async {
    var data = {"email": "$receptionEmail"};

    var responce = await Providers().getReceptionDetails(data);

    if (responce.status == true) {
      setState(() {
        receptionistName.text = responce.data.name;
        receptionName = responce.data.name;
        receptionAddress = responce.data.address;
        _address.text = responce.data.address;
        receptionContact = responce.data.phone;
        _contactnumber.text = responce.data.phone;
        receptionCountry = responce.data.country;
        _country.text = responce.data.country;
      });
    }
    print("-==-=-=-=-=-=-=$receptionCountry");
  }

  List<String> itemList = [];

  getReceptionistName() async {
    var responce = await Providers().getReceptionist();
    for (int i = 0; i <= responce.data.length; i++) {
      itemList.add(responce.data[i].name);
      filtername = responce.data[0].name;
    }
  }

  List getSuggestions(String query) {
    List matches = [];
    matches.addAll(itemList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> emailList = [];
  getReceptionistemail() async {
    var responce = await Providers().getReceptionist();
    for (int i = 0; i <= responce.data.length; i++) {
      emailList.add(responce.data[i].email);
      filter = responce.data[0].email;
    }
  }

  List getSuggestions2(String query) {
    List matches = [];
    matches.addAll(emailList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> contactList = [];

  getReceptionistContact() async {
    var responce = await Providers().getReceptionist();
    for (int i = 0; i <= responce.data.length; i++) {
      contactList.add(responce.data[i].phone);
      filternumber = responce.data[0].phone;
    }
  }

  List getSuggestions3(String query) {
    List matches = [];
    matches.addAll(contactList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> addressList = [];
  List<String> countryList = [];

  getReceptionistAddress() async {
    var responce = await Providers().getReceptionist();
    for (int i = 0; i <= responce.data.length; i++) {
      addressList.add(responce.data[i].address);
      filteraddress = responce.data[0].address;
    }
  }

  List getSuggestions4(String query) {
    List matches = [];
    matches.addAll(addressList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  getReceptionistCountry() async {
    var responce = await Providers().getReceptionist();
    for (int i = 0; i <= responce.data.length; i++) {
      countryList.add(responce.data[i].country);
      filtercountry = responce.data[0].country;
    }
  }

  List getSuggestions5(String query) {
    List matches = [];
    matches.addAll(countryList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  var pickupfee, title;
  var itemprice;
  var itemid;
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    id = widget.data['id'];
    itemid = widget.data['itemid'];
    pickupfee = widget.data['pickupFee'];
    title = widget.data['title'];

    print("EMS ID $id");
    print("pickupfee  $pickupfee");
    print("itemid  $itemid");
    getReceptionistName();
    getReceptionistAddress();
    getReceptionistContact();
    getReceptionistemail();
    getReceptionistCountry();
  }

  var id;

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
          color: Color(0xffE5E5E5),
          child: SafeArea(
              right: false,
              child: ListView(children: [
                Column(
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
                                _scaffoldKey.currentState!.openDrawer();
                              },
                            ),
                          if (Responsive.isDesktop(context)) SizedBox(width: 5),
                          Container(
                              margin: (Responsive.isDesktop(context))
                                  ? EdgeInsets.fromLTRB(20, 20, 5, 0)
                                  : EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: (Responsive.isDesktop(context))
                                  ? Container(
                                      height: h * 0.1,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            'Dashboard >',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  Routes.CLIENTDASHBOARDROUTE);
                                            },
                                            child: Text(
                                              '${widget.data["companyName"]} >',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(
                                            'Pickup / Drop Off',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dashboard >',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                Routes.CLIENTDASHBOARDROUTE);
                                          },
                                          child: Text(
                                            '${widget.data["companyName"]} >' +
                                                'Pickup / Drop Off',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )),
                        ],
                      ),
                    ),
                    if (Responsive.isDesktop(context))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color(0xffFFFFFF)),
                                  height: MediaQuery.of(context).size.height *
                                      (90 / 100),
                                  // height: 100,

                                  width: MediaQuery.of(context).size.width *
                                      (32 / 100),
                                  child: receptionistInfo()),
                              Container(
                                  margin: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: _radioValue == 0
                                          ? Color(0xffFFFFFF)
                                          : Color(0xffFFFFFF).withOpacity(0.3)),
                                  height: MediaQuery.of(context).size.height *
                                      (90 / 100),
                                  // height: 100,

                                  width: MediaQuery.of(context).size.width *
                                      (32 / 100),
                                  child: dropInfo()),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _radioValue == 1
                                      ? Color(0xffFFFFFF)
                                      : Color(0xffFFFFFF).withOpacity(0.3)),
                              height: MediaQuery.of(context).size.height *
                                  (90 / 100),
                              // height: 100,

                              width: MediaQuery.of(context).size.width *
                                  (32 / 100),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: pickupInfo())),
                        ],
                      ),
                    if (Responsive.isMobile(context))
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xffFFFFFF)),
                              height: MediaQuery.of(context).size.height *
                                  (80 / 100),
                              // height: 100,

                              width: MediaQuery.of(context).size.width *
                                  (90 / 100),

                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: receptionistInfo()),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: _radioValue == 0
                                    ? Color(0xffFFFFFF)
                                    : Color(0xffFFFFFF).withOpacity(0.3),
                              ),
                              height: MediaQuery.of(context).size.height *
                                  (62 / 100),
                              // height: 100,

                              width: MediaQuery.of(context).size.width *
                                  (90 / 100),

                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: dropInfo()),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: _radioValue == 1
                                      ? Color(0xffFFFFFF)
                                      : Color(0xffFFFFFF).withOpacity(0.3)),
                              height: MediaQuery.of(context).size.height *
                                  (88 / 100),
                              // height: 100,

                              width: MediaQuery.of(context).size.width *
                                  (90 / 100),

                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: pickupInfo()),
                            ),
                          ],
                        ),
                      ),
                    if (Responsive.isTablet(context))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xffFFFFFF),
                            ),
                            height:
                                MediaQuery.of(context).size.height * (65 / 100),
                            // height: 100,

                            width:
                                MediaQuery.of(context).size.width * (90 / 100),

                            child: Align(
                                alignment: Alignment.topLeft,
                                child: receptionistInfo()),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: _radioValue == 0
                                  ? Color(0xffFFFFFF)
                                  : Color(0xffFFFFFF).withOpacity(0.3),
                            ),
                            height:
                                MediaQuery.of(context).size.height * (65 / 100),
                            // height: 100,

                            width:
                                MediaQuery.of(context).size.width * (90 / 100),

                            child: Align(
                                alignment: Alignment.topLeft,
                                child: dropInfo()),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: _radioValue == 0
                                  ? Color(0xffFFFFFF)
                                  : Color(0xffFFFFFF).withOpacity(0.3),
                            ),
                            height:
                                MediaQuery.of(context).size.height * (65 / 100),
                            // height: 100,

                            width:
                                MediaQuery.of(context).size.width * (90 / 100),

                            child: Align(
                                alignment: Alignment.topLeft,
                                child: pickupInfo()),
                          ),
                        ],
                      ),
                    InkWell(
                      onTap: () {
                        if (this._formkey3.currentState!.validate()) {
                          if (_radioValue == 0
                              ? this._formkey1.currentState!.validate()
                              : _radioValue == 1
                                  ? this._formkey.currentState!.validate()
                                  : this._formkey3.currentState!.validate()) {
                            if (receptionistName == null ||
                                receptionEmail == null ||
                                receptionContact == null ||
                                receptionAddress == null ||
                                receptionCountry == null) {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  content: Text("please fill all the details"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            if (_radioValue == 1) {
                              print("-=-=->>> $_radioValue");
                              if (_pickuptimecontrollr.text.isEmpty ||
                                  _pickupdatecontrollr.text.isEmpty) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content:
                                        Text("please select date and time"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                            } else if (_radioValue == 0) {
                              if (_dropOffdatecontrollr.text.isEmpty ||
                                  _dropOfftimecontrollr.text.isEmpty) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content:
                                        Text("please select date and time"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }
                            }

                            var data = {
                              "receptionName": receptionName,
                              "receptionEmail": receptionEmail,
                              "receptionContact": receptionContact,
                              "receptionAddress": receptionAddress,
                              "receptionCountry": receptionCountry,
                              "shipmentId": id,
                              "itemid": itemid,
                              "title": title,
                              "companyName": widget.data["companyName"],
                              "type": _radioValue == 0 ? "Drop off" : "Pick up",
                              "pickup_dropoff_Location": _radioValue == 0
                                  ? dropOff_location
                                  : pickup_location,
                              "pickup_dropoff_date": _radioValue == 0
                                  ? _dropOffdatecontrollr.text.toString()
                                  : _pickupdatecontrollr.text.toString(),
                              "pickup_dropoff_time": _radioValue == 0
                                  ? _dropOfftimecontrollr.text.toString()
                                  : _pickuptimecontrollr.text.toString(),
                              "pickupMiles":
                                  _radioValue == 0 ? "" : pickup_miles_diff,
                              "pickupestimate":
                                  _radioValue == 0 ? " " : pickup_estimate,
                              "pickupfee": _radioValue == 0
                                  ? " "
                                  : "${pickupfee.toString()}",
                            };

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GoodsInfo(data)));
                          } else {
                            if (_radioValue == 0
                                ? this._formkey1.currentState!.validate()
                                : _radioValue == 1
                                    ? this._formkey.currentState!.validate()
                                    : this._formkey3.currentState!.validate()) {
                              setState(() {
                                _pickupdatecontrollr.text.isEmpty
                                    ? _validate = true
                                    : _validate = false;
                              });

                              if (receptionistName == null ||
                                  receptionEmail == null ||
                                  receptionContact == null ||
                                  receptionAddress == null ||
                                  receptionCountry == null) {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content:
                                        Text("please fill all the details"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              var data = {
                                "receptionName": receptionName,
                                "receptionEmail": receptionEmail,
                                "receptionContact": receptionContact,
                                "receptionAddress": receptionAddress,
                                "": receptionCountry,
                                "shipmentId": id,
                                "itemid": itemid,
                                "title": title,
                                "companyName": widget.data["companyName"],
                                "type":
                                    _radioValue == 0 ? "Drop off" : "Pick up",
                                "pickup_dropoff_Location": _radioValue == 0
                                    ? dropOff_location
                                    : pickup_location,
                                "pickup_dropoff_date": _radioValue == 0
                                    ? _dropOffdatecontrollr.text.toString()
                                    : _pickupdatecontrollr.text.toString(),
                                "pickup_dropoff_time": _radioValue == 0
                                    ? _dropOfftimecontrollr.text.toString()
                                    : _pickuptimecontrollr.text.toString(),
                                "pickupMiles":
                                    _radioValue == 0 ? "" : pickup_miles_diff,
                                "pickupestimate":
                                    _radioValue == 0 ? " " : pickup_estimate,
                                "pickupfee": _radioValue == 0
                                    ? " "
                                    : "${pickupfee.toString()}",
                              };

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GoodsInfo(data)));
                            }
                          }
                        }
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: (Responsive.isDesktop(context))
                              ? w * .30
                              : w * 5.0,
                          margin: EdgeInsets.only(
                              top: 15, left: 15, right: 80, bottom: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Color(0xff1F2326)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(15),
                                  child: Center(
                                      child: Text("Proceed to Goods",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )))),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 15, right: 10, left: 30),
                                height: 25,
                                // width: 300,
                                child: Image.asset(
                                    'assets/images/arrow-right.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ])),
        ));
  }

  Widget receptionistInfo() {
    return Form(
      key: this._formkey3,
      child: InkWell(
        onTap: () {
          setState(() {
            _radioValue = 2;
          });
          print(_radioValue);
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Receptionist information",
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: (Responsive.isDesktop(context)) ? 30 : 17,
                color: Colors.black,
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Email address",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
                height: 60,
                width: w * 0.8,
                decoration: BoxDecoration(
                  color: Color(0xffF5F6FA),
                  border: Border.all(
                    color: Color(0xffF5F6FA),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(15, 10, 15, 10)
                    : EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      hint: Text("Select Email",
                          style: TextStyle(color: Colors.grey, fontSize: 15)),
                      // hint: Text("selectstatus".tr()),
                      value: filter,

                      // icon: Icon(Icons.arrow_drop_down),
                      // iconSize: 30,
                      elevation: 16,
                      style: TextStyle(color: Colors.grey, fontSize: 17),
                      onChanged: (String? value) {
                        setState(() {
                          filter = value!;
                          receptionEmail = filter;
                          getReceptionistData();
                          print("KKKKKKKKKKKKK$receptionEmail");
                        });

                        // controller1.selection = TextSelection.fromPosition(
                        //     TextPosition(offset: controller1.text.length));
                      },
                      items: emailList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 17),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
                //  SimpleAutoCompleteTextField(
                //     key: key,
                //     controller: this._emails,
                //     suggestions: emailList,
                //     decoration: InputDecoration(
                //       fillColor: Color(0xffF5F6FA),
                //       filled: true,
                //       enabledBorder: OutlineInputBorder(
                //         borderSide:
                //             BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                //       ),
                //       hintText: "Email",
                //     ),
                //     // textChanged: (text) {
                //     //   setState(() {
                //     //     _emails.text = text;

                //     //     receptionEmail = _emails.text;

                //     //     _emails.selection = TextSelection.fromPosition(
                //     //         TextPosition(offset: _emails.text.length));

                //     //     getReceptionistData();
                //     //   });
                //     // },
                //     submitOnSuggestionTap: true,
                //     clearOnSubmit: false,
                //     textSubmitted: (text) {
                //       setState(() {
                //         _emails.text = text;

                //         receptionEmail = _emails.text;
                //         getReceptionistData();
                //         print('onSubmitted value: $text');
                //       });
                //     })
                ),
            Container(
              margin: (Responsive.isDesktop(context))
                  ? EdgeInsets.only(top: 5, right: 10, left: 10)
                  : EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Name",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(15, 10, 15, 10)
                    : EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: EasyAutocomplete(
                    suggestions: itemList,
                    controller: this.receptionistName,
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
                        hintText:
                            filtername == null ? "Enter Name" : filtername,
                        hintStyle: TextStyle(
                            color: filtername == null
                                ? Colors.grey
                                : Colors.black87,
                            fontSize: 15)),
                    onChanged: (value) {
                      this.receptionistName.text = value;
                      receptionName = receptionistName.text;
                      print('onChanged value: $value');

                      receptionistName.selection = TextSelection.fromPosition(
                          TextPosition(offset: receptionistName.text.length));
                    },
                    onSubmitted: (value) =>
                        print('onSubmitted value: $value'))),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Contact number",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(15, 10, 15, 10)
                    : EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: EasyAutocomplete(
                    suggestions: contactList,
                    controller: this._contactnumber,
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
                        hintText: filternumber == null
                            ? "Enter Number"
                            : filternumber,
                        hintStyle: TextStyle(
                            color: filtername == null
                                ? Colors.grey
                                : Colors.black87,
                            fontSize: 15)),
                    onChanged: (value) {
                      this._contactnumber.text = value;
                      receptionContact = _contactnumber.text;

                      _contactnumber.selection = TextSelection.fromPosition(
                          TextPosition(offset: _contactnumber.text.length));
                    },
                    onSubmitted: (value) {
                      this._contactnumber.text = value;
                      receptionContact = _contactnumber.text;
                    })),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Address",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(15, 10, 15, 10)
                    : EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: EasyAutocomplete(
                    suggestions: addressList,
                    controller: this._address,
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
                        hintText: filteraddress == null
                            ? "Enter Address"
                            : filteraddress,
                        hintStyle: TextStyle(
                            color:
                                filtername == null ? Colors.grey : Colors.black,
                            fontSize: 15)),
                    onChanged: (value) {
                      this._address.text = value;
                      receptionAddress = _address.text;

                      _address.selection = TextSelection.fromPosition(
                          TextPosition(offset: _address.text.length));
                    },
                    onSubmitted: (value) {
                      this._address.text = value;
                      receptionAddress = _address.text;
                    })),
            Container(
              margin: EdgeInsets.only(right: 10, left: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Country",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
                margin: (Responsive.isDesktop(context))
                    ? EdgeInsets.fromLTRB(15, 10, 15, 10)
                    : EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: EasyAutocomplete(
                    suggestions: countryList,
                    controller: this._country,
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
                        hintText: filtercountry == null
                            ? "Enter Country"
                            : filtercountry,
                        hintStyle: TextStyle(
                            color:
                                filtername == null ? Colors.grey : Colors.black,
                            fontSize: 15)),
                    onChanged: (value) {
                      this._country.text = value;
                      receptionCountry = _country.text;

                      _country.selection = TextSelection.fromPosition(
                          TextPosition(offset: _country.text.length));
                    },
                    onSubmitted: (value) {
                      this._country.text = value;
                      receptionCountry = _country.text;
                    })),
          ],
        ),
      ),
    );
  }

  Widget dropInfo() {
    final _controller = TextEditingController();
    return Form(
      key: _formkey1,
      child: Column(
        children: [
          Row(
            children: [
              new Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Drop info",
                      style: TextStyle(
                        fontSize: 20,
                        color: _radioValue == 0
                            ? Colors.black
                            : Colors.black.withOpacity(0.3),
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: 10,
                ),
                child: Align(
                    child: Text(
                  "",
                  style: TextStyle(
                    fontSize: 20,
                    color: _radioValue == 0
                        ? Colors.black
                        : Colors.black.withOpacity(0.3),
                  ),
                )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: _radioValue == 0
                  ? Colors.black
                  : Colors.black.withOpacity(0.3),
              thickness: 2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, right: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Shipment company's warehouse Location",
                  style: TextStyle(fontSize: 14),
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: TextFormField(
                // autovalidateMode: AutovalidateMode.always,
                initialValue: "",
                validator: (val) => _emailValidation(val, "Email"),
                onChanged: (v) async {
                  // if (v.length >= 2) {
                  setState(() {
                    _radioValue = 0;
                    dropOff_location = v;
                  });

                  List _postList = [];

                  var urlData =
                      "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$kGoogleApiKey&query=$v";
                  //print(urlData);

                  var dataMap = {
                    "key": kGoogleApiKey,
                    "query": v,
                  };

                  var getMapDataRes = await Providers().getMap(v);

                  print("-=-=-=getMapDataRes");
                  print(getMapDataRes);

                  var predictions = jsonData;
                  var enData = jsonEncode(jsonData['results']);
                  if (predictions != null) {}
                },
                style: TextStyle(color: Colors.black54, fontSize: 17),
                decoration: InputDecoration(
                    fillColor: Color(0xffF5F6FA),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                    hintText:
                        "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            ),
          ),
          Text(test),
          if (Responsive.isDesktop(context))
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: 10,
                  ),
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  child: Column(
                    // crossAxisAlignment:
                    //     CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Date to drop-up",
                              style: TextStyle(fontSize: 14),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xffFFFFFF),
                          // border: Border.all(color:)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  onChanged: (v) {
                                    // findPlace(v);
                                    setState(() {
                                      dropOff_location = v;
                                      _radioValue = 0;
                                    });
                                  },
                                  enabled: false,
                                  controller: _dropOffdatecontrollr,
                                  decoration: InputDecoration(

                                      // errorText: _validate ? 'required' : null,
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,

                                      // prefixIcon: Icon(Icons.search),
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
                                      hintText: 'Enter Start Date',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15))),
                            ),
                            IconButton(
                                onPressed: () async {
                                  await _selectDate(context);
                                  _dropOffdatecontrollr.text = (DateFormat.yMd()
                                      .format(initialDate1)
                                      .toString());
                                  // _startDate.toString();
                                },
                                icon: ImageIcon(
                                  AssetImage('assets/images/calendar.png'),
                                  color: Color(0xff1F2326),
                                  size: 65,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: 10,
                  ),
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  child: Column(
                    // crossAxisAlignment:
                    //     CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: Align(
                            child: Text(
                          "Time to drop-up",
                          style: TextStyle(fontSize: 14),
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xffFFFFFF),
                          // border: Border.all(color:)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  enabled: false,
                                  controller: _dropOfftimecontrollr,
                                  decoration: InputDecoration(
                                      fillColor: Color(0xffF5F6FA),
                                      filled: true,
                                      // prefixIcon: Icon(Icons.search),
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
                                      hintText: 'Enter Time',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15))),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _selectTime(context);
                                _dropOfftimecontrollr.text =
                                    ("${initialTime.hour}:${initialTime.minute}")
                                        .toString();
                                // _startDate.toString();
                              },
                              icon: Icon(Icons.access_alarm, size: 30),
                              color: Color(0xff1F2326),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (Responsive.isMobile(context))
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date to drop-up",
                        style: TextStyle(fontSize: 14),
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF),
                    // border: Border.all(color:)
                  ),
                  child: Row(
                    children: [
                      new Expanded(
                        child: new TextField(
                            enabled: false,
                            controller: _dropOffdatecontrollr,
                            decoration: InputDecoration(
                                fillColor: Color(0xffF5F6FA),
                                filled: true,
                                // prefixIcon: Icon(Icons.search),
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
                                hintText: 'Enter Start Date',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15))),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _selectDate(context);
                          _dropOffdatecontrollr.text =
                              (DateFormat.yMd().format(_startDate).toString());
                          // _startDate.toString();
                        },
                        icon: Icon(Icons.calendar_month, size: 30),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Time to drop-up",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF),
                    // border: Border.all(color:)
                  ),
                  child: Row(
                    children: [
                      new Expanded(
                        child: new TextField(
                            enabled: false,
                            controller: _dropOfftimecontrollr,
                            decoration: InputDecoration(
                                fillColor: Color(0xffF5F6FA),
                                filled: true,
                                // prefixIcon: Icon(Icons.search),
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
                                hintText: 'Enter Time',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15))),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _selectTime(context);
                          _dropOfftimecontrollr.text =
                              ("${initialTime.hour}:${initialTime.minute}")
                                  .toString();
                          // _startDate.toString();
                        },
                        icon: Icon(Icons.access_alarm, size: 30),
                        color: Color(0xff1F2326),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (Responsive.isTablet(context))
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Date to drop-up",
                        style: TextStyle(fontSize: 14),
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF),
                    // border: Border.all(color:)
                  ),
                  child: Row(
                    children: [
                      new Expanded(
                        child: new TextField(
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Choose Date';
                            //   }
                            // },
                            enabled: false,
                            controller: _dropOffdatecontrollr,
                            decoration: InputDecoration(
                                fillColor: Color(0xffF5F6FA),
                                filled: true,
                                // prefixIcon: Icon(Icons.search),
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
                                hintText: 'Enter Start Date',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15))),
                      ),
                      IconButton(
                          onPressed: () async {
                            await _selectDate(context);
                            _dropOffdatecontrollr.text = (DateFormat.yMd()
                                .format(_startDate)
                                .toString());
                            // _startDate.toString();
                          },
                          icon: ImageIcon(
                            AssetImage('assets/images/calendar.png'),
                            color: Color(0xff1F2326),
                            size: 65,
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Time to drop-up",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF),
                    // border: Border.all(color:)
                  ),
                  child: Row(
                    children: [
                      new Expanded(
                        child: new TextFormField(
                            validator: (val) => _emailValidation(val, "Email"),
                            enabled: false,
                            controller: _dropOfftimecontrollr,
                            decoration: InputDecoration(
                                fillColor: Color(0xffF5F6FA),
                                filled: true,
                                // prefixIcon: Icon(Icons.search),
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
                                hintText: 'Enter Time',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15))),
                      ),
                      IconButton(
                        onPressed: () async {
                          await _selectTime(context);
                          _dropOfftimecontrollr.text =
                              ("${initialTime.hour}:${initialTime.minute}")
                                  .toString();
                          // _startDate.toString();
                        },
                        icon: Icon(Icons.access_alarm, size: 30),
                        color: Color(0xff1F2326),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  bool _validate = false;
  Widget pickupInfo() {
    return Align(
      alignment: Alignment.topLeft,
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Pick up",
                        style: TextStyle(
                          fontSize: 20,
                          color: _radioValue == 1
                              ? Colors.black
                              : Colors.black.withOpacity(0.3),
                        ),
                      )),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    right: 10,
                  ),
                  child: Align(
                      child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 20,
                      color: _radioValue == 1
                          ? Colors.black
                          : Colors.black.withOpacity(0.3),
                    ),
                  )),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Divider(
                height: 30,
                color: _radioValue == 1
                    ? Colors.black
                    : Colors.black.withOpacity(0.3),
                thickness: 2,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5, right: 10, left: 15),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Pick- up Location",
                    style: TextStyle(fontSize: 14),
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Container(
                margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TextFormField(
                  // autovalidateMode: AutovalidateMode.always,
                  initialValue: "",
                  validator: (val) => _emailValidation(val, "Email"),
                  onChanged: (v) async {
                    // if (v.length >= 2) {
                    setState(() {
                      _radioValue = 1;
                      pickup_location = v;
                    });

                    List _postList = [];

                    var urlData =
                        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$kGoogleApiKey&query=$v";
                    //print(urlData);

                    var dataMap = {
                      "key": kGoogleApiKey,
                      "query": v,
                    };

                    var getMapDataRes = await Providers().getMap(v);

                    print("-=-=-=getMapDataRes");
                    print(getMapDataRes);

                    var predictions = jsonData;
                    var enData = jsonEncode(jsonData['results']);
                    if (predictions != null) {}
                  },
                  style: TextStyle(color: Colors.black54, fontSize: 17),
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
                      hintText:
                          "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Date to pick-up",
                                style: TextStyle(fontSize: 14),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffFFFFFF),
                            // border: Border.all(color:)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    // enabled: false,
                                    controller: _pickupdatecontrollr,
                                    decoration: InputDecoration(
                                        fillColor: Color(0xffF5F6FA),
                                        filled: true,
                                        // prefixIcon: Icon(Icons.search),
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
                                        hintText: 'Enter Start Date',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15))),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await _selectDate1(context);
                                    _pickupdatecontrollr.text =
                                        (DateFormat.yMd()
                                            .format(initialDate)
                                            .toString());
                                    // _startDate.toString();
                                  },
                                  icon: ImageIcon(
                                    AssetImage('assets/images/Calendar.png'),
                                    color: Color(0xff1F2326),
                                    size: 65,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    child: Column(
                      // crossAxisAlignment:
                      //     CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Align(
                              child: Text(
                            "Time to pick-up",
                            style: TextStyle(fontSize: 14),
                          )),
                        ),
                        Container(
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffFFFFFF),
                            // border: Border.all(color:)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                    // validator: (val) =>
                                    //     _emailValidation(val, "Email"),
                                    readOnly: true,
                                    enabled: false,
                                    controller: _pickuptimecontrollr,
                                    decoration: InputDecoration(
                                        fillColor: Color(0xffF5F6FA),
                                        filled: true,
                                        // prefixIcon: Icon(Icons.search),
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
                                        hintText: 'Enter Time',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 15))),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _selectTime1(context);
                                  _pickuptimecontrollr.text =
                                      ("${initialTime.hour}:${initialTime.minute}")
                                          .toString();
                                  // _startDate.toString();
                                },
                                icon: Icon(Icons.access_alarm, size: 30),
                                color: Color(0xff1F2326),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (Responsive.isMobile(context))
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Date to pick-up",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffFFFFFF),
                      // border: Border.all(color:)
                    ),
                    child: Row(
                      children: [
                        new Expanded(
                          child: new TextField(
                              enabled: false,
                              controller: _pickupdatecontrollr,
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  // prefixIcon: Icon(Icons.search),
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
                                  hintText: 'Enter Start Date',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15))),
                        ),
                        IconButton(
                            onPressed: () async {
                              await _selectDate1(context);
                              _pickupdatecontrollr.text = (DateFormat.yMd()
                                  .format(_startDate)
                                  .toString());
                              // _startDate.toString();
                            },
                            icon: Icon(Icons.calendar_month, size: 30),
                            color: Color(0xff1F2326)),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Time to pick-up",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffFFFFFF),
                      // border: Border.all(color:)
                    ),
                    child: Row(
                      children: [
                        new Expanded(
                          child: new TextField(
                              enabled: false,
                              controller: _pickuptimecontrollr,
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  // prefixIcon: Icon(Icons.search),
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
                                  hintText: 'Enter Time',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15))),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _selectTime1(context);
                            _pickuptimecontrollr.text =
                                ("${initialTime.hour}:${initialTime.minute}")
                                    .toString();
                            // _startDate.toString();
                          },
                          icon: Icon(Icons.access_alarm, size: 30),
                          color: Color(0xff1F2326),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (Responsive.isTablet(context))
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Date to pick-up",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffFFFFFF),
                      // border: Border.all(color:)
                    ),
                    child: Row(
                      children: [
                        new Expanded(
                          child: new TextField(
                              enabled: false,
                              controller: _pickupdatecontrollr,
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  // prefixIcon: Icon(Icons.search),
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
                                  hintText: 'Enter Start Date',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15))),
                        ),
                        IconButton(
                            onPressed: () async {
                              await _selectDate1(context);
                              _pickupdatecontrollr.text = (DateFormat.yMd()
                                  .format(_startDate)
                                  .toString());
                              // _startDate.toString();
                            },
                            icon: ImageIcon(
                              AssetImage('assets/images/calendar.png'),
                              color: Color(0xff1F2326),
                              size: 65,
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Time to pick-up",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xffFFFFFF),
                      // border: Border.all(color:)
                    ),
                    child: Row(
                      children: [
                        new Expanded(
                          child: new TextField(
                              enabled: false,
                              controller: _pickuptimecontrollr,
                              decoration: InputDecoration(
                                  fillColor: Color(0xffF5F6FA),
                                  filled: true,
                                  // prefixIcon: Icon(Icons.search),
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
                                  hintText: 'Enter Time',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15))),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _selectTime(context);
                            _pickuptimecontrollr.text =
                                ("${initialTime.hour}:${initialTime.minute}")
                                    .toString();
                          },
                          icon: Icon(Icons.access_alarm, size: 30),
                          color: Color(0xff1F2326),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (Responsive.isDesktop(context))
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Total Miles difference",
                                style: TextStyle(fontSize: 14),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                          width: MediaQuery.of(context).size.width * (15 / 100),
                          child: TextFormField(
                            validator: (val) => _totalValidation(val, "Email"),
                            initialValue: "",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (v) {
                              setState(() {
                                _radioValue = 1;
                                pickup_miles_diff = v;
                              });
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
                                hintText: "7 Miles",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      right: 10,
                    ),
                    width: MediaQuery.of(context).size.width * (15 / 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          child: Align(
                              child: Text(
                            "Estimate",
                            style: TextStyle(fontSize: 14),
                          )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                          width: MediaQuery.of(context).size.width * (15 / 100),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (val) =>
                                _estimateValidation(val, "date"),
                            initialValue: "",
                            onChanged: (v) {
                              setState(() {
                                _radioValue = 1;
                                pickup_estimate = v;
                              });
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
                                hintText: "100",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (Responsive.isMobile(context))
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Total Miles difference",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 15, left: 15),
                    // width: MediaQuery.of(context).size.width * (15 / 100),
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        setState(() {
                          _radioValue = 1;
                          pickup_miles_diff = v;
                        });
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
                          hintText: "7 Miles",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Estimate",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                    // width: MediaQuery.of(context).size.width * (15 / 100),
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        setState(() {
                          _radioValue = 1;
                          pickup_estimate = v;
                        });
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
                          hintText: "100",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            if (Responsive.isTablet(context))
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Total Miles difference",
                          style: TextStyle(fontSize: 14),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 15, left: 15),
                    // width: MediaQuery.of(context).size.width * (15 / 100),
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        setState(() {
                          pickup_miles_diff = v;
                        });
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
                          hintText: "7 Miles",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Align(
                        child: Text(
                      "Estimate",
                      style: TextStyle(fontSize: 14),
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                    child: TextFormField(
                      initialValue: "",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) {
                        setState(() {
                          pickup_estimate = v;
                        });
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
                          hintText: "100",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

var jsonData = {
  "html_attributions": [],
  "results": [
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Mahavir Apartment, Silicon City, Rau, a-82, Nihalpur Mundi, Silicon City, Madhya Pradesh 452012, India",
      "geometry": {
        "location": {"lat": 22.6456992, "lng": 75.8321433},
        "viewport": {
          "northeast": {"lat": 22.64710707989272, "lng": 75.83348397989272},
          "southwest": {"lat": 22.64440742010727, "lng": 75.83078432010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "i Bus stop",
      "photos": [
        {
          "height": 3096,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/117090587934641710287\"\u003eSunil Pant\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEDAX9-F1u34b3kQpRLhzWWT1TZMa60MWihuAU4QRHHWPdyM9xJWQoBjHQB9oMmGxVBAYFteOqgy08KsGJTG0ohJak6FPtVpV5yTEDqacEBTDNKyphiUhNvsoTZwyVIWAtUl4YGCPq4XrDwgBqYa7EaW2BA5OcW6N5kF65c4ZrUehFOM",
          "width": 4128
        }
      ],
      "place_id": "ChIJP0aAY4v7YjkR8kt0g-zl2x8",
      "plus_code": {
        "compound_code": "JRWJ+7V Silicon City, Indore, Madhya Pradesh",
        "global_code": "7JJQJRWJ+7V"
      },
      "rating": 4,
      "reference": "ChIJP0aAY4v7YjkR8kt0g-zl2x8",
      "types": ["travel_agency", "point_of_interest", "establishment"],
      "user_ratings_total": 67
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Near, AB Rd, Khandelwal Nagar, Shiv Moti Nagar, Indore, Madhya Pradesh 452001, India",
      "geometry": {
        "location": {"lat": 22.697985, "lng": 75.87764000000001},
        "viewport": {
          "northeast": {"lat": 22.69936632989273, "lng": 75.87895007989272},
          "southwest": {"lat": 22.69666667010728, "lng": 75.87625042010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "I Store",
      "place_id": "ChIJkc0TsX_9YjkRWLoDpj90m9g",
      "plus_code": {
        "compound_code": "MVXH+53 Indore, Madhya Pradesh",
        "global_code": "7JJQMVXH+53"
      },
      "rating": 0,
      "reference": "ChIJkc0TsX_9YjkRWLoDpj90m9g",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Mahavir Apartment, Silicon City, Rau, 170-A, Indore, Madhya Pradesh 452009, India",
      "geometry": {
        "location": {"lat": 22.6466994, "lng": 75.8320287},
        "viewport": {
          "northeast": {"lat": 22.64803552989272, "lng": 75.83333962989271},
          "southwest": {"lat": 22.64533587010728, "lng": 75.83063997010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/school-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/school_pinlet",
      "name": "The i- SCHOOL, Rau",
      "opening_hours": {"open_now": false},
      "photos": [
        {
          "height": 1870,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/118155017329922503636\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uECZWevP8dcHglfNGhb4gvq_ovLIsotG91vuJZ3qgeB-S-UWsrq7CjmmXZ1MH5w7U6BkfD5NUjyYEz2xxSEnNCbQnJRR2OouGMzuY4AL3iE_bl8wNcse9mDsSrR9_YJmk2hQjzHVJdtVzuEv2OnFdPcHMZd6PN3nz-MEEOWRZewjGvG4",
          "width": 2486
        }
      ],
      "place_id": "ChIJQ_szzVD7YjkRAsrkk5J2LII",
      "plus_code": {
        "compound_code": "JRWJ+MR Indore, Madhya Pradesh",
        "global_code": "7JJQJRWJ+MR"
      },
      "rating": 5,
      "reference": "ChIJQ_szzVD7YjkRAsrkk5J2LII",
      "types": ["school", "point_of_interest", "establishment"],
      "user_ratings_total": 13
    },
    {
      "business_status": "CLOSED_TEMPORARILY",
      "formatted_address":
          "3rd floor, Sapna Sangeeta Rd, above sbi bank, Snehnagar, Indore, Madhya Pradesh 452001, India",
      "geometry": {
        "location": {"lat": 22.6996933, "lng": 75.86727979999999},
        "viewport": {
          "northeast": {"lat": 22.70101767989272, "lng": 75.86864977989271},
          "southwest": {"lat": 22.69831802010728, "lng": 75.86595012010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "icon_background_color": "#FF9E67",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
      "name": "I",
      "permanently_closed": true,
      "place_id": "ChIJrcBFv539YjkRB3iMSlZrhJg",
      "plus_code": {
        "compound_code": "MVX8+VW Indore, Madhya Pradesh",
        "global_code": "7JJQMVX8+VW"
      },
      "rating": 0,
      "reference": "ChIJrcBFv539YjkRB3iMSlZrhJg",
      "types": ["restaurant", "food", "point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "gate no 2, Shiv City, Indore, Madhya Pradesh 452012, India",
      "geometry": {
        "location": {"lat": 22.6511189, "lng": 75.8306532},
        "viewport": {
          "northeast": {"lat": 22.65248787989272, "lng": 75.83201102989273},
          "southwest": {"lat": 22.64978822010728, "lng": 75.82931137010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/restaurant-71.png",
      "icon_background_color": "#FF9E67",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/restaurant_pinlet",
      "name": "I ❤️ चाय",
      "opening_hours": {"open_now": true},
      "photos": [
        {
          "height": 1080,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/111495511024481803070\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uECIGUhAuRRMpVqAw-82cJfOQD7LCH9w9Fzy2WXB-afwQfoJ5y0ff8kPjX6jo1q4R761DwPXzm7O2HqZ1ntlIDdy8D9KDnCwDmq7e1XOJfjJcie1wInK6dQ5uRLXqVDvO6agf_jb5JA9aMh310ckijTJ__S7NvjdtoxGh0gZ4Wf-opLm",
          "width": 1920
        }
      ],
      "place_id": "ChIJY0tFsI79YjkR2_pt61V_QCs",
      "plus_code": {
        "compound_code": "MR2J+C7 Indore, Madhya Pradesh",
        "global_code": "7JJQMR2J+C7"
      },
      "rating": 5,
      "reference": "ChIJY0tFsI79YjkR2_pt61V_QCs",
      "types": ["restaurant", "food", "point_of_interest", "establishment"],
      "user_ratings_total": 2
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Bairathi Colony Number 2, Indore, Madhya Pradesh 452014, India",
      "geometry": {
        "location": {"lat": 22.7007891, "lng": 75.8560524},
        "viewport": {
          "northeast": {"lat": 22.70223277989273, "lng": 75.85730532989272},
          "southwest": {"lat": 22.69953312010728, "lng": 75.85460567010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "I-Phone Solution",
      "place_id": "ChIJk4RuMgD9YjkRiX4XaD2GbjM",
      "plus_code": {
        "compound_code": "PV24+8C Indore, Madhya Pradesh",
        "global_code": "7JJQPV24+8C"
      },
      "rating": 0,
      "reference": "ChIJk4RuMgD9YjkRiX4XaD2GbjM",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "1733, Sector D, Sudama Nagar, Indore, Madhya Pradesh 452009, India",
      "geometry": {
        "location": {"lat": 22.6911565, "lng": 75.8299013},
        "viewport": {
          "northeast": {"lat": 22.69253432989272, "lng": 75.83125052989273},
          "southwest": {"lat": 22.68983467010728, "lng": 75.82855087010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/school-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/school_pinlet",
      "name": "The i-SCHOOL SUDAMA NAGAR, Indore",
      "photos": [
        {
          "height": 2322,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/114807229332161688825\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEBZvOBN3LsDFQO1dDKmGaIT8I-abAcl5XHbVMstmgYM-id0t6psuVbNGJFqdMHlCp0hJpNx7JfgjVHIM7Bdo0k2x9KPVLElt5eEhSdnHhLHi_FFCHQkzsEXuEsT__LREhxwOvZtsnROlxMADSVpBHMrx2EqPQyQrLDJzbZEFvThTnKS",
          "width": 4128
        }
      ],
      "place_id": "ChIJkReNiL79YjkROd1H9sCQPbY",
      "plus_code": {
        "compound_code": "MRRH+FX Indore, Madhya Pradesh",
        "global_code": "7JJQMRRH+FX"
      },
      "rating": 5,
      "reference": "ChIJkReNiL79YjkROd1H9sCQPbY",
      "types": ["school", "point_of_interest", "establishment"],
      "user_ratings_total": 41
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "636-A, Narendra Tiwari Marg, near cakes & craft, Sudama Nagar, Indore, Madhya Pradesh 452009, India",
      "geometry": {
        "location": {"lat": 22.6952277, "lng": 75.8357752},
        "viewport": {
          "northeast": {"lat": 22.69661102989272, "lng": 75.83715577989273},
          "southwest": {"lat": 22.69391137010728, "lng": 75.83445612010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/shopping-71.png",
      "icon_background_color": "#4B96F3",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/shopping_pinlet",
      "name": "I Fashion Women's wear",
      "opening_hours": {"open_now": true},
      "photos": [
        {
          "height": 574,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/110404533495512404393\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uECCXnbFBc0OoIa8m5bKyDUirYgYna2NUMW7_MxQKf9Nau0VzT11ksA9FKQJJjR0TE_FiK8R-ewh7MZSUygLC187Gp-IqtlmkxKSxVvWmNis3WRSFnAjIzN6xugt3U7wo5_DQZdzSDE5IdvV9fjI81AaS6oP-_d1cj38sVVQJWMPsTsD",
          "width": 1022
        }
      ],
      "place_id": "ChIJTQ4tWev9YjkRJNLZoulhVTU",
      "plus_code": {
        "compound_code": "MRWP+38 Indore, Madhya Pradesh",
        "global_code": "7JJQMRWP+38"
      },
      "rating": 4.3,
      "reference": "ChIJTQ4tWev9YjkRJNLZoulhVTU",
      "types": [
        "clothing_store",
        "point_of_interest",
        "store",
        "establishment"
      ],
      "user_ratings_total": 3
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address": "402, Shiv City, Rau, Madhya Pradesh 452012, India",
      "geometry": {
        "location": {"lat": 22.6511183, "lng": 75.83065479999999},
        "viewport": {
          "northeast": {"lat": 22.65248727989272, "lng": 75.83201262989272},
          "southwest": {"lat": 22.64978762010728, "lng": 75.82931297010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/shopping-71.png",
      "icon_background_color": "#4B96F3",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/shopping_pinlet",
      "name": "I Love Chai",
      "opening_hours": {},
      "place_id": "ChIJBaqaNqX9YjkRubNcZ66f_-8",
      "plus_code": {
        "compound_code": "MR2J+C7 Shiv City, Indore, Madhya Pradesh",
        "global_code": "7JJQMR2J+C7"
      },
      "rating": 5,
      "reference": "ChIJBaqaNqX9YjkRubNcZ66f_-8",
      "types": ["food", "point_of_interest", "store", "establishment"],
      "user_ratings_total": 1
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Unnamed Road, Tulsi Parisar Phase 1, Indore, Madhya Pradesh 452012, India",
      "geometry": {
        "location": {"lat": 22.6360867, "lng": 75.8306652},
        "viewport": {
          "northeast": {"lat": 22.63745477989272, "lng": 75.83202162989271},
          "southwest": {"lat": 22.63475512010728, "lng": 75.82932197010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/lodging-71.png",
      "icon_background_color": "#909CE1",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/hotel_pinlet",
      "name": "Palash Parisar Part I",
      "photos": [
        {
          "height": 1800,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/111813674788309870833\"\u003eOmprakash Goud\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEDcWNIvX0Il2nkGjdaO5WUs0OYr6JLzYWLhy1xKnngLcnTgDav98W31qVEgE7llZFOlaqXgxnmirF49Lj5BnxFi2qIkhzynszVLO2Sr-J7K2QcGkQUgn5aByBOI6FyG0cIUHAahnbQ5L3DcdPG0oa7of7610h-tm5rypzrd4IR0gXhP",
          "width": 2400
        }
      ],
      "place_id": "ChIJq-kZPnn7YjkR1IL-3Exj25w",
      "plus_code": {
        "compound_code": "JRPJ+C7 Indore, Madhya Pradesh",
        "global_code": "7JJQJRPJ+C7"
      },
      "rating": 4.4,
      "reference": "ChIJq-kZPnn7YjkR1IL-3Exj25w",
      "types": ["lodging", "point_of_interest", "establishment"],
      "user_ratings_total": 67
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "UG-9, Block-C,Silver Mall, Madhya Pradesh 452001, India",
      "geometry": {
        "location": {"lat": 22.7081955, "lng": 75.8824422},
        "viewport": {
          "northeast": {"lat": 22.70958672989272, "lng": 75.88377107989272},
          "southwest": {"lat": 22.70688707010728, "lng": 75.88107142010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "YAS i-link",
      "place_id": "ChIJq6qqqib9YjkRUp8hv9qjo-0",
      "rating": 0,
      "reference": "ChIJq6qqqib9YjkRUp8hv9qjo-0",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "CLOSED_TEMPORARILY",
      "formatted_address":
          "Cloth Market, 28, Yashwant Ganj, M.T Cloth Market, Maharaja Tukoji Rao Holker Cloth Market, Indore, Madhya Pradesh 452002, India",
      "geometry": {
        "location": {"lat": 22.7178996, "lng": 75.8463648},
        "viewport": {
          "northeast": {"lat": 22.71925662989272, "lng": 75.84764427989273},
          "southwest": {"lat": 22.71655697010728, "lng": 75.84494462010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "I con engineers",
      "permanently_closed": true,
      "place_id": "ChIJbWlCDzP9YjkRWI_Z4K-Te10",
      "plus_code": {
        "compound_code": "PR9W+5G Indore, Madhya Pradesh",
        "global_code": "7JJQPR9W+5G"
      },
      "rating": 0,
      "reference": "ChIJbWlCDzP9YjkRWI_Z4K-Te10",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "23/5, Jawahar Marg, Nihalpura, Bombay Bazar, Indore, Madhya Pradesh 452007, India",
      "geometry": {
        "location": {"lat": 22.7152903, "lng": 75.8541244},
        "viewport": {
          "northeast": {"lat": 22.71671632989272, "lng": 75.85550182989273},
          "southwest": {"lat": 22.71401667010728, "lng": 75.85280217010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "I-DESIGN Shirts",
      "opening_hours": {"open_now": true},
      "photos": [
        {
          "height": 1162,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/100773854279109609102\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEBuVV_7KDTlKTY8-BHMDcPudzOd-cV8RpubQIqsfEjYGFpYdorz1_ZHPuObC2xssDasbofego6K8SA3xOpZ_3k9h1RQPJmR0Kdh2TB29VtzYZjhY3VaqZf_ysZbh_oBmvcnge53WU8WBOIGMPpZZU83ameiLAvofmTqWs-HEp85jBQ4",
          "width": 1080
        }
      ],
      "place_id": "ChIJ_WA-Qbn9YjkRjMWVEeW1u3k",
      "plus_code": {
        "compound_code": "PV83+4J Indore, Madhya Pradesh",
        "global_code": "7JJQPV83+4J"
      },
      "rating": 4.8,
      "reference": "ChIJ_WA-Qbn9YjkRjMWVEeW1u3k",
      "types": [
        "point_of_interest",
        "clothing_store",
        "store",
        "establishment"
      ],
      "user_ratings_total": 6
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "Indore BRTS Road, Gpo Square, Navlakha, Indore, Madhya Pradesh 452001, India",
      "geometry": {
        "location": {"lat": 22.7065933, "lng": 75.8789869},
        "viewport": {
          "northeast": {"lat": 22.70793887989272, "lng": 75.88028942989271},
          "southwest": {"lat": 22.70523922010728, "lng": 75.87758977010726}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "Gpo Chouraha I- Bus Stop",
      "opening_hours": {},
      "photos": [
        {
          "height": 2048,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/101843203577814665279\"\u003eRachit Jain\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEBvD6D8RXjII5xiZ6Lwooob83I8EI4g_XLpReHtGaha1arA63zTH7S_CLvMAz8i9RrSft9UpYJc4whlRxehUU-q-i_sDCsE7IJ9m2ppTgr7fsBVEW2R92UcYLvDiVVfdlWGhyLsmX6WIverHObGRiDbRW0zKJwiYR3w7a58zFuDj95u",
          "width": 1536
        }
      ],
      "place_id": "ChIJMe3TmSH9YjkRqmnk3ziD1bY",
      "plus_code": {
        "compound_code": "PV4H+JH Indore, Madhya Pradesh",
        "global_code": "7JJQPV4H+JH"
      },
      "rating": 3.6,
      "reference": "ChIJMe3TmSH9YjkRqmnk3ziD1bY",
      "types": ["transit_station", "point_of_interest", "establishment"],
      "user_ratings_total": 10
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address": "bus stop, Vishnupuri BRT, i, India",
      "geometry": {
        "location": {"lat": 22.6893253, "lng": 75.8639223},
        "viewport": {
          "northeast": {"lat": 22.69064437989272, "lng": 75.86530442989272},
          "southwest": {"lat": 22.68794472010728, "lng": 75.86260477010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "Vishnupuri BRT, i bus stop",
      "place_id": "ChIJ1Tcz9039YjkRmND7PaE_ylM",
      "plus_code": {
        "compound_code": "MVQ7+PH Indore, Madhya Pradesh",
        "global_code": "7JJQMVQ7+PH"
      },
      "rating": 4,
      "reference": "ChIJ1Tcz9039YjkRmND7PaE_ylM",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 2
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "997, Lakshman Singh Gour Marg, Foti Kothi Square, Bank Colony, Sudama Nagar, Indore, Madhya Pradesh 452009, India",
      "geometry": {
        "location": {"lat": 22.6944343, "lng": 75.8290901},
        "viewport": {
          "northeast": {"lat": 22.69582532989272, "lng": 75.83040147989273},
          "southwest": {"lat": 22.69312567010727, "lng": 75.82770182010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/school-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/school_pinlet",
      "name": "i-TecH Education",
      "place_id": "ChIJLWF8njX8YjkRPtkQcsn43Z0",
      "plus_code": {
        "compound_code": "MRVH+QJ Indore, Madhya Pradesh",
        "global_code": "7JJQMRVH+QJ"
      },
      "rating": 5,
      "reference": "ChIJLWF8njX8YjkRPtkQcsn43Z0",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 2
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "293, Usha Nagar, Indore, Madhya Pradesh 452009, India",
      "geometry": {
        "location": {"lat": 22.6989916, "lng": 75.8366908},
        "viewport": {
          "northeast": {"lat": 22.70038317989272, "lng": 75.83807437989272},
          "southwest": {"lat": 22.69768352010728, "lng": 75.83537472010728}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/school-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/school_pinlet",
      "name": "aS aM I - Campus 1",
      "opening_hours": {"open_now": true},
      "place_id": "ChIJq6qqWrP9YjkRbJL198RyMuw",
      "plus_code": {
        "compound_code": "MRXP+HM Indore, Madhya Pradesh",
        "global_code": "7JJQMRXP+HM"
      },
      "rating": 0,
      "reference": "ChIJq6qqWrP9YjkRbJL198RyMuw",
      "types": ["school", "point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "102, 1, Bk Sindhi Colony, Indore, Madhya Pradesh 452001, India",
      "geometry": {
        "location": {"lat": 22.700873, "lng": 75.8637439},
        "viewport": {
          "northeast": {"lat": 22.70221757989272, "lng": 75.86508287989271},
          "southwest": {"lat": 22.69951792010728, "lng": 75.86238322010726}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/generic_business-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "I-climber Marketing",
      "opening_hours": {"open_now": true},
      "photos": [
        {
          "height": 845,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/112695443773988166308\"\u003eA Google User\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEC8GSyDLagPNwQlLN_0CHW8wmj4nnyuFfIuJmaLgeinYawwQCfZk2uqr0UzqQgFmx33o98__b1Ni3o8RI2gtf3bQOFxhgYKC-Xlle5GKpdbXhQF-TZGYcGwDJnWr-6Ul481349UZY3FigD4VYMfsmczWHJrAJZH_Aj2C-LalaOvt3g",
          "width": 1500
        }
      ],
      "place_id": "ChIJkUFuSkv9YjkRoZItencXk7M",
      "plus_code": {
        "compound_code": "PV27+8F Indore, Madhya Pradesh",
        "global_code": "7JJQPV27+8F"
      },
      "rating": 0,
      "reference": "ChIJkUFuSkv9YjkRoZItencXk7M",
      "types": ["point_of_interest", "establishment"],
      "user_ratings_total": 0
    },
    {
      "formatted_address": "Sector I, Indore, Madhya Pradesh, India",
      "geometry": {
        "location": {"lat": 22.7096249, "lng": 75.80655569999999},
        "viewport": {
          "northeast": {"lat": 22.7116543, "lng": 75.8114092},
          "southwest": {"lat": 22.7063142, "lng": 75.8025243}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/geocode-71.png",
      "icon_background_color": "#7B9EB0",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/generic_pinlet",
      "name": "Sector I",
      "photos": [
        {
          "height": 1080,
          "html_attributions": [
            "\u003ca href=\"https://maps.google.com/maps/contrib/115381882583167003971\"\u003eKishor Panchal\u003c/a\u003e"
          ],
          "photo_reference":
              "Aap_uEC28cmW4c8PuEK15N0E2I5FYOvt_-y8kf_foIKqfNL1uimKRqqBtwHRDaqS601bsoWJLgK7JDG0wT14xW9BOFFlL_VBU80pE_3O22Ou4F5LI-SgO_qEc0wPNUpKEn7SNvX1-H8cr0bWiaoMI3WpMJshddS82gTahV0iCBpVOr5pxpNL",
          "width": 1920
        }
      ],
      "place_id": "ChIJB5pUMXb-YjkRXMzTHZMEDG4",
      "reference": "ChIJB5pUMXb-YjkRXMzTHZMEDG4",
      "types": ["sublocality_level_2", "sublocality", "political"]
    },
    {
      "business_status": "OPERATIONAL",
      "formatted_address":
          "109, Sector B, Green Park Colony, Indore, Madhya Pradesh 452006, India",
      "geometry": {
        "location": {"lat": 22.7067922, "lng": 75.8098294},
        "viewport": {
          "northeast": {"lat": 22.70814207989272, "lng": 75.81116917989272},
          "southwest": {"lat": 22.70544242010728, "lng": 75.80846952010727}
        }
      },
      "icon":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v1/png_71/shopping-71.png",
      "icon_background_color": "#4B96F3",
      "icon_mask_base_uri":
          "https://maps.gstatic.com/mapfiles/place_api/icons/v2/shoppingcart_pinlet",
      "name": "I mean Kirana",
      "place_id": "ChIJOYVPrc_9YjkRmcp54Q_Qqn8",
      "plus_code": {
        "compound_code": "PR45+PW Indore, Madhya Pradesh",
        "global_code": "7JJQPR45+PW"
      },
      "rating": 5,
      "reference": "ChIJOYVPrc_9YjkRmcp54Q_Qqn8",
      "types": [
        "grocery_or_supermarket",
        "food",
        "point_of_interest",
        "store",
        "establishment"
      ],
      "user_ratings_total": 1
    }
  ],
  "status": "OK"
};
