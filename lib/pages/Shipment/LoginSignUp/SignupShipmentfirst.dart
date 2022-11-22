import 'dart:convert';
import 'dart:developer';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/LoginSignup/Terms&Conditions.dart';
import 'package:shipment/pages/Client/LoginSignup/signup_otp.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/SignupShipment.dart';

class SignupScreenfirst extends StatefulWidget {
  const SignupScreenfirst({Key? key}) : super(key: key);
  static const route = '/SignupScreenfirst';
  @override
  _SignupScreenfirstState createState() => _SignupScreenfirstState();
}

class _SignupScreenfirstState extends State<SignupScreenfirst> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool monVal = false;
  String? name,
      emailAddress,
      phonenumber,
      password,
      lname,
      username,
      countryName,
      countrycode;

  String? radioItem = '';
  bool _obscureText = true;
  var uname;

  _emailValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }

    final validemail = validEmailField(val, field);
    if (validemail != null) return validemail;
  }

  _requiredField(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  _nameValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
    final RegExp oneDot = RegExp(r'^[a-zA-Z ]+$');
    if (!oneDot.hasMatch(val)) return "invalid name";
  }

  _phoneValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  shipmentRegister() async {
    if (this._formKey.currentState!.validate()) {
      if (monVal == false) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text("Please Accept terms and Conditions"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }
      _formKey.currentState!.save();

      SystemChannels.textInput.invokeMethod('TextInput.hide');

      var shipmentData = {
        "username": "$username",
        "name": "$name",
        "lname": "$lname",
        "email": "$emailAddress",
        "phone": "$phonenumber",
        "password": "${encodeToSHA3(password)}",
        "companyname": "",
        "annualshipment": "",
        "country": "",
        "file": " ",
      };
      print(jsonEncode(shipmentData));
      // return;
      var register = await Providers().registrationShipment(shipmentData);
      print(jsonEncode(register));
      if (register.status == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Shipemnt_auth_token', register.data[0].token);
        prefs.setString('u_id', register.data[0].id.toString());
        prefs.setString('user_name', register.data[0].username.toString());

        print("token ${register.data[0].token}");
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(register.message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Otp1(signupData: shipmentData, type: "shipment"))),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //             Otp1(signupData: shipmentData, type: "shipment")));

        prefs.setString(
            "companyName",
            register.data[0].companyname == ""
                ? "NA"
                : register.data[0].companyname);
        // if (register.data[0].companyname == "") {
        //   Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE);
        // } else {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder: (context) => ResDashboardshipment()),
        //   );
      }
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => ResDashboardshipment()),
      // );
      else {
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

  // id =   response.user[universityList.indexOf(name)].id

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Background.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 400,
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 64, left: 15),
                          child: Text("Register Shipment Company Account!",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700))),
                      Divider(
                        height: 30,
                        color: Colors.white,
                        // thickness: 3,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 10, left: 15, right: 15),
                            child: Text("User Name*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          // controller: usenamecontroller,
                          validator: (val) => _requiredField(val, "User Name"),
                          onChanged: (val) {
                            username = val;
                          },
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide:
                                    BorderSide(width: 1.2, color: Colors.white),
                              ),
                              // border: InputBorder.none,
                              hintText: "Enter User Name",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Text("First Name*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),
                      Container(
                        margin: EdgeInsets.all(14),
                        child: TextFormField(
                          // controller: namecontroller,
                          inputFormatters: [
                            // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z -]"))
                          ],
                          keyboardType: TextInputType.name,
                          // initialValue: "",
                          validator: (val) => _requiredField(val, "Name"),
                          onChanged: (value) {
                            name = value;
                          },
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide:
                                    BorderSide(width: 1.2, color: Colors.white),
                              ),
                              // border: InputBorder.none,
                              hintText: "Enter First name",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Text("Last Name*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          // controller: lastnamecontroller,
                          inputFormatters: [
                            // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z -]"))
                          ],
                          keyboardType: TextInputType.name,
                          validator: (val) => _nameValidation(val, "Last Name"),
                          onChanged: (val) {
                            lname = val;
                          },
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide:
                                    BorderSide(width: 1.2, color: Colors.white),
                              ),
                              // border: InputBorder.none,
                              hintText: "Enter Last name",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Text("Email address*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),
                      Container(
                        margin: EdgeInsets.all(14),
                        child: TextFormField(
                          // controller: emailcontroller,
                          validator: (val) => _emailValidation(val, "Email"),
                          onChanged: (value) {
                            emailAddress = value;
                          },
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide:
                                    BorderSide(width: 1.2, color: Colors.white),
                              ),
                              // border: InputBorder.none,
                              hintText: "Enter Email address*",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Text("Password*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter password';
                            } else {
                              if (value.length < 8) {
                                return 'Password should be at least 8 character';
                              } else {
                                return null;
                              }
                            }
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          style: TextStyle(color: Colors.white, fontSize: 17),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              fillColor: Colors.transparent,
                              filled: true,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(
                                  width: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide:
                                    BorderSide(width: 1.2, color: Colors.white),
                              ),
                              // border: InputBorder.none,
                              hintText: "Password",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 5,
                          right: 15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.white),
                              child: Checkbox(
                                activeColor: Color(0xff43A047),
                                value: monVal,
                                onChanged: (bool? value) async {
                                  setState(() {
                                    monVal = value!;
                                    // state.didChange(value);
                                  });
                                },
                              ),
                            ),
                            Text("I agree to ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (Context) => TermsConditon()));
                                // js.context.callMethod('open', [
                                //   'https://www.freeprivacypolicy.com/live/dac78798-73d1-401f-8b01-15d7616dce6f'
                                // ]);
                              },
                              child: Container(
                                  child: Text("Terms & Conditions",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                      ))),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print(lname);
                          if (_formKey.currentState!.validate()) {
                            shipmentRegister();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Color(0xff1F2326)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.all(15),

                                  // width: MediaQuery.of(context).size.width * 0.8,
                                  // color: Colors.lime,
                                  child: Center(
                                      child: Text("Sign up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )))),
                              Container(
                                margin: EdgeInsets.only(top: 15, right: 10),
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                    'assets/images/arrow-right.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 5, 10),
                            child: Text(
                              'Do you already have an account?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.CLIENTLOGINROUTE);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCountryPickerDropdown({
    bool sortedByIsoCode = false,
  }) {
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.12;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;
    return Row(
      children: <Widget>[
        SizedBox(
          width: dropdownButtonWidth,
          child: CountryPickerDropdown(
            /* underline: Container(
              height: 2,
              color: Colors.red,
            ),*/
            //show'em (the text fields) you're in charge now
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            //if you have menu items of varying size, itemHeight being null respects
            //that, IntrinsicHeight under the hood ;).
            itemHeight: null,
            //itemHeight being null and isDense being true doesn't play along
            //well together. One is trying to limit size and other is saying
            //limit is the sky, therefore conflicts.
            //false is default but still keep that in mind.
            isDense: false,
            //if you want your dropdown button's selected item UI to be different
            //than itemBuilder's(dropdown menu item UI), then provide this selectedItemBuilder.
            // selectedItemBuilder: hasSelectedItemBuilder == true
            //     ? (Country country) => _buildDropdownSelectedItemBuilder(
            //         country, dropdownSelectedItemWidth)
            //     : null,
            //initialValue: 'AR',
            // itemBuilder: (Country country) => hasSelectedItemBuilder == true
            //     ? _buildDropdownItemWithLongText(country, dropdownItemWidth)
            //     : _buildDropdownItem(country, dropdownItemWidth),
            // initialValue: 'AR',
            // itemFilter: filtered
            //     ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
            //     : null,
            // //priorityList is shown at the beginning of list
            // priorityList: hasPriorityList
            //     ? [
            //         CountryPickerUtils.getCountryByIsoCode('GB'),
            //         CountryPickerUtils.getCountryByIsoCode('CN'),
            //       ]
            //     : null,
            sortComparator: sortedByIsoCode
                ? (Country a, Country b) => a.isoCode.compareTo(b.isoCode)
                : null,
            onValuePicked: (Country country) {
              print("${country.phoneCode}");
              countryName = country.name;
              countrycode = country.phoneCode;
            },
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Container(
            // margin: EdgeInsets.all(10),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (val) => _phoneValidation(val, "Contact Number"),
              onChanged: (value) {
                phonenumber = value;
              },
              style: TextStyle(color: Colors.white, fontSize: 17),
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
