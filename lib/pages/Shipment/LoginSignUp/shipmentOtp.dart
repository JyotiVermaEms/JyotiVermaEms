import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/shipmentForgotPassword.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/shipmentUpdatePassword.dart';

class Otp extends StatefulWidget {
  final int otp;
  const Otp({Key? key, required this.otp}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

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

class _OtpState extends State<Otp> {
  var w, h;
  var _formKey = GlobalKey<FormState>();
  var OTP;
  bool load = false;
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
            // backgroundColor: Color(0xfff7f6fb),
            body: SafeArea(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(top: 10, left: 10),
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
                                            ForgotPassword()));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.03,
                  ),

                  // OtpTimer(),

                  SizedBox(
                    height: h * 0.32,
                  ),
                  Text(
                    "Please check your e-mail account for the verification code \nwe just sent you and enter that code in \nthe box below",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: h * 0.03, left: w * 0.05, right: w * 0.05),
                    // padding: EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: w * 0.23,
                          margin:
                              EdgeInsets.only(left: w * 0.06, right: w * 0.06),
                          child: TextFormField(
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(4),
                            ],
                            initialValue: "",
                            onChanged: (value) {
                              OTP = value;
                              // RegExp regex = RegExp(
                              //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              // if (value.length == 4) {
                              //   setState(() {
                              //     validotp = true;
                              //   });
                              // } else {
                              //   setState(() {
                              //     validotp = false;
                              //   });
                              // }
                              // setState(() {
                              //   OTP.length == 0
                              //       ? IconVisibility = false
                              //       : IconVisibility = true;
                              // });
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
                              // suffixIcon: IconButton(
                              //   icon: (IconVisibility && validotp)
                              //       ? Icon(
                              //           Icons.check_circle_outline,
                              //           size: 20,
                              //           color: Colors.green,
                              //         )
                              //       : (IconVisibility && !validotp)
                              //           ? Icon(
                              //               Icons.highlight_off,
                              //               size: 20,
                              //               color: Colors.red,
                              //             )
                              //           : Icon(
                              //               Icons.highlight_off,
                              //               size: 20,
                              //               color: Colors.white,
                              //             ),
                              //   onPressed: () {},
                              // ),
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: w * 0.06, right: w * 0.06),
                        //   child: TextFormField(
                        //     keyboardType: TextInputType.phone,
                        //     initialValue: "",
                        //     validator: (value) {
                        //       if (value!.length == 4)
                        //         return null;
                        //       else
                        //         return 'Enter 4-digit OTP';
                        //     },
                        //     onChanged: (value) {
                        //       OTP = value;
                        //     },
                        //     style: TextStyle(color: Colors.black, fontSize: 17),
                        //     decoration: InputDecoration(
                        //       fillColor: Color(0xffFFFFFF),
                        //       filled: true,
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide:
                        //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                        //       ),
                        //       // ignore: unnecessary_new
                        //       focusedBorder: new OutlineInputBorder(
                        //         // borderRadius: new BorderRadius.circular(25.0),
                        //         borderSide:
                        //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                        //       ),
                        //       errorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(10)),
                        //         borderSide:
                        //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                        //       ),
                        //       focusedErrorBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.all(Radius.circular(20)),
                        //         borderSide:
                        //             BorderSide(width: 1.2, color: Color(0xffFFFFFF)),
                        //       ),
                        //       // border: InputBorder.none,
                        //       hintText: "Enter Mobile Number",
                        //       hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        //       suffixIcon: IconButton(
                        //         icon: Icon(
                        //           Icons.check_circle_outline,
                        //           size: 20,
                        //           color: Color(0xff00D88A),
                        //         ),
                        //         onPressed: () {},
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     _textFieldOTP(first: true, last: false),
                        //     _textFieldOTP(first: false, last: false),
                        //     _textFieldOTP(first: false, last: false),
                        //     _textFieldOTP(first: false, last: true),
                        //   ],
                        // ),
                        SizedBox(
                          height: h * 0.05,
                        ),
                        InkWell(
                          onTap: () {
                            print(widget.otp);
                            if (_formKey.currentState!.validate()) {
                              if (OTP.toString() == widget.otp.toString()) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UpdatePassword()));
                              } else {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    content: Text("inavalid otp"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'OK'),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              // print(widget.otp);
                              // if (_formKey.currentState!.validate()) {
                              //   setState(() {
                              //     load = true;
                              //   });
                              //   if (OTP.toString() == widget.otp.toString()) {
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) => UpdatePassword()));
                              //   } else {
                              //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //       content: Text("Invalid OTP"),
                              //     ));
                              //   }
                              //   setState(() {
                              //     load = false;
                              //   });
                              // }
                            }
                          },
                          child: load
                              ? Center(
                                  child: CircularProgressIndicator(
                                      // color: FareColor().fareRed,
                                      ),
                                )
                              : Container(
                                  height: h * 0.07,
                                  width: w * 0.24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Color(0xff1F2326),
                                  ),
                                  child: Center(
                                    child: Text("Confirm",
                                        style: TextStyle(
                                          fontSize: 17,
                                          // fontWeight: FontWeight.w600,
                                          color: Color(0xffFFFFFF),
                                        )
                                        // style: FareStyle().style17whitew600(),
                                        ),
                                  )),
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
