// ignore_for_file: prefer_const_constructors, prefer_is_empty

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';

import 'package:shipment/pages/Client/LoginSignup/forgotpassword.dart';
import 'package:shipment/pages/Client/LoginSignup/updatepassword.dart';
import 'package:shipment/pages/Client/subscriptionScreen.dart';
// import 'package:flutter_application_4/Pages/timer_demo.dart';

class Otp1 extends StatefulWidget {
  var type;
  var signupData;
  Otp1({
    Key? key,
    required this.signupData,
    required this.type,
  }) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp1> {
  var _formKey = GlobalKey<FormState>();
  var w, h;
  var OTP;
  bool IconVisibility = false;
  bool enabled = true;
  bool validotp = false;
  bool load = false;
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 60;
  int currentSeconds = 0;
  String? changeName = "Submit";
  Timer? timer;
  var otp;

  requiredField(value, field) {
    if (value.isEmpty) {
      return field + ' is required';
    }
  }

  _otprequiredValidation(value, field) {
    final required = requiredField(value, field);
    if (required != null) {
      return required;
    }
  }

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        log("YYYYYYY $currentSeconds");
        if (timer.tick >= timerMaxSeconds) {
          changeName = "Resend Otp";
          enabled = false;
          print("--=-=-=-=-=-=-$changeName");
          timer.cancel();
        }
      });
    });
  }

  doForgotPassword() async {
    setState(() {
      load = true;
    });
    var ResendOtpdatadata = {
      "otp": OTP.toString(),
      "type": widget.type,
      "email": widget.signupData['email']
    };

    print(jsonEncode(ResendOtpdatadata));

    var resenddata = await Providers().verifyOtp(ResendOtpdatadata);

    log(jsonEncode(resenddata));

    if (resenddata.status == true) {
      print("MMMMMMMMMMMMMMMM${resenddata.status}");
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.getString(
        "companyName",
      );
      // widget.type == "client"
      //     ? Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => DashboardHome()))
      //     : "companyName" == ""
      //         ? Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE)
      //         : Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => ResDashboardshipment()),
      //           );

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(resenddata.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => widget.type == "client"
                  ? Navigator.pushNamed(context, Routes.CLIENTDASHBOARDROUTE)
                  : "companyName" == ""
                      ? Navigator.pushNamed(
                          context, Routes.SHIPMENTUPDATEPROFILE)
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubscriptionScreen()),
                        ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(resenddata.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      load = false;
    });
  }

  doForgotPassword1() async {
    setState(() {
      load = true;
    });
    var ForgotPassworddata = {
      "type": widget.type,
      "email": widget.signupData['email']
    };

    print(jsonEncode(ForgotPassworddata));

    var VerifyOtpdata = await Providers().resendOtp(ForgotPassworddata);
    setState(() {
      enabled = true;
      startTimeout();
    });

    log(jsonEncode(VerifyOtpdata));

    if (VerifyOtpdata.status == true) {
      print("MMMMMMMMMMMMMMMM$VerifyOtpdata.status ");
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // pref.setString("email", widget.signupData['email']);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(VerifyOtpdata.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(VerifyOtpdata.message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimeout();
    print(">>>${widget.signupData['email']}");
    print(">>>${widget.type}");
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: MaterialApp(
        home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Background.png"),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        // margin: EdgeInsets.only(top: 10, left: 10),
                        // child: IconButton(
                        //   icon: Icon(
                        //     Icons.arrow_back_ios,
                        //     size: 20,
                        //     color: Colors.white,
                        //   ),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => SignupScreenClient()));
                        //   },
                        // ),
                        ),
                  ),
                  SizedBox(
                    height: h * 0.1,
                  ),
                  SizedBox(
                    width: 400,
                    child: Column(
                      children: [
                        Text(
                          "We have sent one time OTP in your Email ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "please enter here",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          timerText,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          // style: FareStyle().style17whitew600(),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        Container(
                          margin: EdgeInsets.all(14),
                          child: TextFormField(
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(4),
                            ],
                            initialValue: "",
                            onChanged: (value) {
                              OTP = value;
                            },
                            validator: (value) =>
                                _otprequiredValidation(value, "otp"),
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
                              hintText: "Enter OTP",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.01,
                        ),
                        load
                            ? Center(
                                child: CircularProgressIndicator(
                                    // color: FareColor().fareRed,
                                    ),
                              )
                            : Container(
                                height: 40,
                                margin: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: enabled
                                      ? Color(0xff1F2326)
                                      : Colors.grey[800],
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    enabled ? doForgotPassword() : null;
                                  },
                                  child: Center(
                                    child: Text('Verify OTP',
                                        style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: enabled
                                              ? Color(0xffFFFFFF)
                                              : Colors.black,
                                        )),
                                  ),
                                ),
                              ),
                        InkWell(
                          onTap: () async {
                            doForgotPassword1();
                          },
                          child: Text(
                            'Resend Otp',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
