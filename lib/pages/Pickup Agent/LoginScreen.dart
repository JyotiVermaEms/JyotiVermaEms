import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/component/Pickup%20Agent/Dashboard/Dashboard.dart';
import 'package:shipment/helper/routes.dart';

class LoginScreen extends StatefulWidget {
  final String roles;
  const LoginScreen({Key? key, required this.roles}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool? monVal = false;
  bool? monVal2 = false;
  String? email, password;
  bool _obscureText = true;
  _emailValidation(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }

    // final validemail = validEmailField(val, field);
    // if (validemail != null) return validemail;
  }

  _requiredField(val, field) {
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

  var pickupAgentToken;
  doPickupAgentLOgin() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var loginData = {
        "email": "$email",
        "password": "${encodeToSHA3(password)}",
        "roles": widget.roles
        // "${encodeToSHA3(password)}",
      };
      print(jsonEncode(loginData));

      var response = await Providers().loginPickupAgent(loginData);
      log(jsonEncode(response));
      if (response.status == true) {
        pickupAgentToken = response.data[0].token;
        print("PickupAgent Token $pickupAgentToken");
        // print("Shipment Id $shipmentId");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', "$email");
        // prefs.setBool('isLoginShipment', true);
        // // prefs.setString('auth_token', shipmentToken);
        prefs.setString('Pickup_Agent_token', pickupAgentToken);

        // Navigator.of(context).pushNamed('/dashboardship');
        Navigator.pushNamed(context, Routes.PICKUPAGENTDASHBOARD);

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => PrePickupAgentDashboard()));
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future(() => true);
      },
      child: MaterialApp(
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
                              width: 700,
                              margin: EdgeInsets.only(top: 64, left: 15),
                              child: Text("Sign in as Pickup Agent",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700))),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 12, left: 15, right: 15),
                              child: Text("Go inside the best Shipment!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ))),
                          Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 20.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 36,
                                  )),
                            ),
                            Text("or",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400)),
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.white,
                                    height: 36,
                                  )),
                            ),
                          ]),
                          // Container(
                          //     margin:
                          //         EdgeInsets.only(top: 40, left: 15, right: 15),
                          //     child: Text("or",
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.w400))),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 36, left: 15, right: 15),
                                child: Text("Your email",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))),
                          ),
                          Container(
                            margin: EdgeInsets.all(14),
                            child: TextFormField(
                              // initialValue: "",
                              validator: (val) => _requiredField(val, "Email"),
                              // validator: (val) =>
                              //     _emailValidation(val, "Email"),
                              onChanged: (val) {
                                email = val;
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                                    borderSide: BorderSide(
                                        width: 1.2, color: Colors.white),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),
                          // SizedBox(height: MediaQuery.of(context).size.height * (5 / 100)),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                child: Text("Choose a password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400))),
                          ),

                          Container(
                            margin: EdgeInsets.all(14),
                            child: TextFormField(
                              // initialValue: "",
                              onFieldSubmitted: (value) {
                                doPickupAgentLOgin();
                              },
                              validator: (val) =>
                                  _requiredField(val, "Password"),
                              onChanged: (val) {
                                password = val;
                              },
                              obscureText: _obscureText,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                                    borderSide: BorderSide(
                                        width: 1.2, color: Colors.white),
                                  ),
                                  // border: InputBorder.none,
                                  hintText: "Enter password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              doPickupAgentLOgin();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Dashboard()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color(0xff1F2326)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.all(15),

                                      // width: MediaQuery.of(context).size.width * 0.8,
                                      // color: Colors.lime,
                                      child: Center(
                                          child: Text("Sign in",
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
