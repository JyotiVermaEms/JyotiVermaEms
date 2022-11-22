// ignore_for_file: prefer_const_constructors, empty_statements
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var w, h;
  final _formKey = GlobalKey<FormState>();
  var email;
  var otp;
  bool load = false;
  bool validemail = false;
  bool visiblepassword = false;
  bool IconVisibility = false;

  doForgotPassword() async {
    // setState(() {
    //   load = true;
    // });
    var ForgotPassworddata = {
      "email": "$email",
    };

    print(jsonEncode(ForgotPassworddata));

    var ForgotPassword =
        await Providers().AllForgotPassword(ForgotPassworddata);

    log(jsonEncode(ForgotPassword));
    otp = ForgotPassword.data.otp;
    if (ForgotPassword.status == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("email", email);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(ForgotPassword.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Otp(otp: otp))),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(ForgotPassword.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    // setState(() {
    //   load = false;
    // });
  }

  _emailValidation(value, field) {
    final required = requiredField(value, field);
    if (required != null) {
      return required;
    }

    final validemail = validEmailField(value, field);
    if (validemail != null) return validemail;
  }

  requiredField(val, field) {
    if (val.isEmpty) {
      return field + ' is required';
    }
  }

  validEmailField(value, field) {
    final RegExp nameExp =
        new RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z-.]+$');
    if (!nameExp.hasMatch(value)) return 'Please enter valid email address.';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // doForgotPassword();
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Background.png"),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoginScreenClient()));
                            },
                          ),
                        ),
                      ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: h * 0.1),
                      Text(
                        "Forgot password?",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: h * 0.009,
                      ),
                      Text(
                        "Don't worry! Just fill in your email and \nwe'll send you otp to reset \nyour password",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: h * 0.09),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              // top: 28,
                              right: 20),
                          child: Text(
                            "Please Enter Your Register Email",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.008,
                      ),
                      (!Responsive.isDesktop(context))
                          ? Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.all(14),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  // initialValue: "",
                                  validator: (value) =>
                                      _emailValidation(value, "Email"),
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                            width: 1.2, color: Colors.white),
                                      ),
                                      // border: InputBorder.none,
                                      hintText: "Enter Email",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            )
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: w * 0.22,
                                // margin: EdgeInsets.all(14),
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  // initialValue: "",
                                  validator: (value) =>
                                      _emailValidation(value, "Email"),
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                  decoration: InputDecoration(
                                      fillColor: Colors.transparent,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                          width: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        borderSide: BorderSide(
                                            width: 1.2, color: Colors.white),
                                      ),
                                      // border: InputBorder.none,
                                      hintText: "Enter Email",
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 15)),
                                ),
                              ),
                            ),

                      SizedBox(
                        height: h * 0.002,
                      ),
                      load
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: (!Responsive.isDesktop(context))
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        margin: EdgeInsets.all(14),
                                        height: h * 0.08,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          color: Color(0xff1F2326),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              doForgotPassword();
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => Otp(
                                              //             // otp: otp,
                                              //             )));
                                            }
                                          },
                                          child: Center(
                                            child: Text('Send Email',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  // fontWeight: FontWeight.w600,
                                                  color: Color(0xffFFFFFF),
                                                )),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        margin: EdgeInsets.only(top: 25),
                                        height: h * 0.07,
                                        width: w * 0.23,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          color: Color(0xff1F2326),
                                        ),
                                        child: InkWell(
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              doForgotPassword();
                                            }
                                          },
                                          child: Center(
                                            child: Text('Send Email',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  // fontWeight: FontWeight.w600,
                                                  color: Color(0xffFFFFFF),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                            )
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
}
