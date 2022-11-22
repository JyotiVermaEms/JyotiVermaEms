import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Chhose%20Screen/ClientScreen.dart';
import 'package:shipment/pages/Chhose%20Screen/ShipmentScreen.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';
import 'package:shipment/pages/Client/subscriptionScreen.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/SignupShipmentfirst.dart';
import 'package:shipment/pages/Shipment/clockscreen.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // checkout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var pid = prefs.getString('p_id');
  //   print("check plan id-------=-=-=-=$pid");
  //   if (pid == null) {
  //     print("check cscscsscplan id-------=-=-=-=$pid");
  //     Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN);
  //   }
  // }

  @override
  void initState() {
    // checkout();
    super.initState();
    isSelected = [true, false];
    // getLocalStorage();
  }

  bool initialPosition = true;

  int _toggleValue = 0;

  late List<bool> isSelected;
  late StateSetter _setState;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Background.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
              child: Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 15),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => AttendanceScreen()),
                          // );
                        },
                        child: Text("Shipment",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 61, left: 15),
                      child: Text("Welcome! to Shipment..",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 18,
                          ))),
                  Container(
                      margin: EdgeInsets.only(top: 17, left: 15),
                      child: Text("Choose your role",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 18,
                          ))),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.CLIENTLOGINROUTE);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 59),
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
                                  child: Text("Sign In",
                                      // "Sign in as client",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )))),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      log("\n\n\nTAPPED ON SHIPMENT\n\n\n");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreenClient()));
                    },
                    child: Container(
                        height: 60,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xff1F2326)),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Color(0xff1F2326)),
                        child: Center(
                          child: AnimatedToggle(
                            values: [
                              'Signup as a Client',
                              'Signup as a Shipment'
                            ],
                            onToggleCallback: (value) {
                              setState(() {
                                _toggleValue = value;
                              });
                            },
                            buttonColor: Colors.grey,
                            backgroundColor: Color(0xff1F2326),
                            textColor: Color(0xff1F2326),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;
  final Color textColor;

  AnimatedToggle({
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor = const Color(0xFFe7e7e8),
    this.buttonColor = const Color(0xFFFFFFFF),
    this.textColor = const Color(0xFF000000),
  });
  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  bool initialPosition = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            initialPosition = !initialPosition;
            var index = 0;
            if (!initialPosition) {
              index = 1;
            }
            widget.onToggleCallback(index);
            setState(() {});
            print("initialPosition -=-= $initialPosition");
            if (index == 1) {
              Future.delayed(const Duration(milliseconds: 255), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupScreenfirst()));
              });
            } else if (index == 0) {
              Future.delayed(const Duration(milliseconds: 255), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignupScreenClient()));
              });
            }
          },
          child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      widget.values.length,
                      (index) => Center(
                            child: Text(
                              widget.values[index],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          )),
                ),
              )),
        ),
        AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          alignment:
              initialPosition ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            width: 190,
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: ShapeDecoration(
              color: widget.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              initialPosition ? widget.values[0] : widget.values[1],
              style: TextStyle(
                fontSize: 15,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }
}
