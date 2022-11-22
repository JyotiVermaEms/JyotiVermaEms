import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/LoginScreenShipment.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/shipmentForgotPassword.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  var w, h;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  bool _isObscure = true;
  var email, passwordd, confirmPassword;
  var _passwordController = new TextEditingController();
  var _confirmpasswordController = new TextEditingController();

  bool visiblepassword = false;
  bool visiblepassword1 = false;
  bool load = false;

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  doResetPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
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
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreenShipment())),
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
                  InkWell(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 15, top: 10),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.white,
                          ),
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()));
                    },
                  ),
                  SizedBox(
                    height: h * 0.22,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.025),
                    child: Text(
                      "Update your password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: w * 0.025),
                    child: Text(
                      "Please enter your password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.2),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Container(
                    width: w * 0.24,
                    margin: EdgeInsets.only(left: w * 0.06, right: w * 0.06),
                    child: TextFormField(
                      obscureText: _obscureText,
                      initialValue: "",
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
                        passwordd = value;
                        setState(() {
                          passwordd.length == 0
                              ? visiblepassword = false
                              : visiblepassword = true;
                        });
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
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.022,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: w * 0.17),
                    child: Text(
                      "Confirm Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Container(
                    width: w * 0.24,
                    margin: EdgeInsets.only(left: w * 0.06, right: w * 0.06),
                    child: TextFormField(
                      obscureText: _isObscure,
                      initialValue: "",
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
                        confirmPassword = value;
                        setState(() {
                          confirmPassword.length == 0
                              ? visiblepassword1 = false
                              : visiblepassword1 = true;
                        });
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
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(
                              _isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h * 0.055,
                  ),
                  load
                      ? Center(
                          child: CircularProgressIndicator(
                              // color: FareColor().fareRed,
                              ),
                        )
                      : Center(
                          child: Container(
                            height: h * 0.08,
                            width: w * 0.24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.black,
                            ),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (passwordd == confirmPassword) {
                                    doResetPassword();
                                    //  doupdatepassword();
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             LoginScreenShipment()));
                                  } else if (passwordd != confirmPassword) {
                                    showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                            'Password Must be match',
                                          ),
                                          actions: <Widget>[
                                            InkWell(
                                              child: const Text('OK'),
                                              onTap: () {
                                                Navigator.of(context).pop(true);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              child: Center(
                                child: Text('Reset Password',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xffFFFFFF),
                                    )),
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
