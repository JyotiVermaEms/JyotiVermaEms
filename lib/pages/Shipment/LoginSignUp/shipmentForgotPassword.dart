import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/shipmentOtp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var w, h;
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  var email;
  var otp;

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

  doForgotPassword() async {
    // setState(() {
    //   load = true;
    // });
    var forgotPassworddata = {
      "email": "$email",
    };

    print(jsonEncode(forgotPassworddata));

    var forgotPassword =
        await Providers().shipmentForgotPassword(forgotPassworddata);

    log(jsonEncode(forgotPassword));
    otp = forgotPassword.data.otp;
    if (forgotPassword.status == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("email", email);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(forgotPassword.message),
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
          content: Text(forgotPassword.message),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: w,
                  //   height: h * 0.35,
                  //   decoration: BoxDecoration(
                  //     // borderRadius: BorderRadius.only(
                  //     //   bottomRight: Radius.circular(30),
                  //     //   bottomLeft: Radius.circular(30),
                  //     // ),
                  //     // color: Color(0xffFFFFFF),
                  //     image: DecorationImage(
                  //       image: AssetImage(
                  //         "assets/images/Background.png",
                  //       ),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 40.0, left: 10),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
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
                                  builder: (context) => LoginScreenShipment()));
                        },
                      ),
                    ),
                  ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: h * 0.28),
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: w * 0.22,
                      // margin: EdgeInsets.all(14),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        // initialValue: "",
                        validator: (value) => _emailValidation(value, "Email"),
                        onChanged: (value) {
                          email = value;
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
                            hintText: "Enter Email",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(35),
                  //   ),
                  //   width: w * 0.3,
                  //   margin: EdgeInsets.only(
                  //     left: 20.0,
                  //   ),
                  //   child: TextFormField(
                  //     initialValue: "",
                  //     onChanged: (value) {
                  //       email = value;
                  //       RegExp regex = RegExp(
                  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  //       if (value.isEmpty) {
                  //         setState(() {
                  //           validemail = false;
                  //         });
                  //       } else {
                  //         if (regex.hasMatch(value)) {
                  //           setState(() {
                  //             validemail = true;
                  //           });
                  //         }
                  //       }
                  //       setState(() {
                  //         email.length == 0
                  //             ? IconVisibility = false
                  //             : IconVisibility = true;
                  //       });
                  //     },
                  //     style: TextStyle(color: Colors.white, fontSize: 17),
                  //     decoration: InputDecoration(
                  //       fillColor: Color(0xffFFFFFF),
                  //       filled: true,
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                  //       ),
                  //       focusedBorder: new OutlineInputBorder(
                  //         // borderRadius: new BorderRadius.circular(25.0),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(8)),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(35)),
                  //         borderSide:
                  //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                  //       ),
                  //       // border: InputBorder.none,
                  //       hintText: "Enter Email",
                  //       hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                  //       suffixIcon: IconButton(
                  //         icon: (IconVisibility && validemail)
                  //             ? Icon(
                  //                 Icons.check_circle_outline,
                  //                 size: 20,
                  //                 color: Colors.green,
                  //               )
                  //             : (IconVisibility && !validemail)
                  //                 ? Icon(
                  //                     Icons.highlight_off,
                  //                     size: 20,
                  //                     color: Colors.red,
                  //                   )
                  //                 : Icon(
                  //                     Icons.highlight_off,
                  //                     size: 20,
                  //                     color: Colors.white,
                  //                   ),
                  //         onPressed: () {},
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: h * 0.030,
                  ),
                  load
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: h * 0.07,
                              width: w * 0.23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35),
                                color: Color(0xff1F2326),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    doForgotPassword();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => Otp(
                                    //               otp: 12,
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
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
