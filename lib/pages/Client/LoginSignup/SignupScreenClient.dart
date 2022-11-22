// ignore_for_file: prefer_const_constructors

import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
//import 'dart:js' as js;

// import 'package:country_pickers/country.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/Terms&Conditions.dart';
import 'package:shipment/pages/Client/LoginSignup/signup_otp.dart';

class SignupScreenClient extends StatefulWidget {
  @override
  _SignupScreenClientState createState() => _SignupScreenClientState();
}

class _SignupScreenClientState extends State<SignupScreenClient> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool monVal = false;
  bool? monVal2 = false;

  bool _obscureText = true;

  int? radioItem;
  String? name,
      phonenumber,
      emailAddress,
      password,
      lname,
      username,
      countryName,
      countrycode;
  int val = -1;
  var type;
  int? _isRadioSelected = 1;

  _nameValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
    final RegExp oneDot = RegExp(r'^[a-zA-Z ]+$');
    if (!oneDot.hasMatch(val)) return "invalid name";
  }

  _passwordValidation(val, field) {
    RegExp nameExp = new RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&#])[A-Za-z\d$@$!%*?&]+$');
    if (val != "") {
      if (val.length != 8)
        return field +
            " should be 8 charectors long, Must contain at least one lowercase letter,  uppercase letter, one digit, and at least one of the special characters ";
    }
    return null;
  }

  _emailValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
      final RegExp oneDot = RegExp(r'^(?:[+0]9)?[0-9]{10}$');
      if (!oneDot.hasMatch(val)) return "Enter must be 10 digits";
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

  doRegister() async {
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

      var signupData = {
        "name": "$name",
        "lname": "$lname",
        "email": "$emailAddress",
        "password": "${encodeToSHA3(password)}",
        "npassword": "$password",
        "username": "$username",
        "phone": "$phonenumber",
        "country_code": "$countrycode",
        "country": "$countryName"
      };
      print(jsonEncode(signupData));

      var register = await Providers().registrationClient(signupData);
      if (register.status == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', register.data[0].token);
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
                            Otp1(signupData: signupData, type: "client"))),
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

  var h, w;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
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
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Center(
                child: SizedBox(
                  width: 400,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 5, left: 10),
                          child: Text("Register Client Account!!",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontSize: 28,
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
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            child: Text("User Name*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: "",
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
                              hintText: "Enter User name",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin:
                                EdgeInsets.only(top: 5, left: 15, right: 15),
                            child: Text("First Name*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
                      ),

                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          inputFormatters: [
                            // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z -]"))
                          ],
                          keyboardType: TextInputType.name,
                          initialValue: "",
                          validator: (val) => _nameValidation(val, "Name"),
                          onChanged: (val) {
                            name = val;
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
                      // SizedBox(height: MediaQuery.of(context).size.height * (5 / 100)),
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
                          inputFormatters: [
                            // @depreacted WhitelistingTextInputFormatter(RegExp("[a-zA-Z -]"))
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z -]"))
                          ],
                          keyboardType: TextInputType.name,
                          initialValue: "",
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
                        margin: EdgeInsets.all(10),
                        child: TextFormField(
                          initialValue: "",
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
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
                              hintText: "Enter Email address",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            child: Text("Phone number*",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400))),
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
                        child:
                            _buildCountryPickerDropdown(sortedByIsoCode: true),
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
                                  child: Text("terms & conditions",
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
                          doRegister();
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
                                  margin: EdgeInsets.all(10),

                                  // width: MediaQuery.of(context).size.width * 0.8,
                                  // color: Colors.lime,
                                  child: Center(
                                      child: Text("Register Account",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )))),
                              Container(
                                margin: EdgeInsets.only(top: 10, right: 10),
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
                            margin: EdgeInsets.fromLTRB(0, 5, 5, 10),
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
                              margin: EdgeInsets.only(top: 5, bottom: 10),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    double dropdownButtonWidth = MediaQuery.of(context).size.width * 0.09;
    //respect dropdown button icon size
    double dropdownItemWidth = dropdownButtonWidth - 30;
    double dropdownSelectedItemWidth = dropdownButtonWidth - 30;

    return Row(
      children: <Widget>[
        CountryCodePicker(
          showDropDownButton: true,
          onChanged: (e) {
            String tt = e.dialCode.toString();
            var temp = tt.split("+");
            countryName = e.name;
            countrycode = temp[1];
          },
          showCountryOnly: false,
          showOnlyCountryWhenClosed: false,
          alignLeft: false,
        ),
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
              validator: (val) => _phoneValidation(val, "Contact Number"),
              onChanged: (value) {
                phonenumber = value;
              },
              style: TextStyle(color: Colors.white, fontSize: 17),
              decoration: InputDecoration(
                hintText: "Enter contact Number",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
        )
      ],
    );
  }
}
