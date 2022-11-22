// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hex/hex.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';

import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Shipment/LoginSignUp/SignupShipmentfirst.dart';

import 'package:shipment/pages/Shipment/LoginSignUp/shipmentForgotPassword.dart';

class LoginScreenShipment extends StatefulWidget {
  const LoginScreenShipment({Key? key}) : super(key: key);

  @override
  _LoginScreenShipmentState createState() => _LoginScreenShipmentState();
}

class _LoginScreenShipmentState extends State<LoginScreenShipment> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool? monVal = false;
  bool? monVal2 = false;
  bool _obscureText = true;
  // bool _isChecked = false;

  String? email, password;

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

  String encodeToSHA3(password) {
    var k = SHA3(512, SHA3_PADDING, 512);
    k.update(utf8.encode(password));
    var hash = k.digest();
    return HEX.encode(hash);
  }

  var shipmentToken;
  doShipmentLOgin() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var loginData = {
        "email": "$email",
        "password": "${encodeToSHA3(password)}",
      };
      print(jsonEncode(loginData));

      var loginshipment = await Providers().loginShipment(loginData);
      log(jsonEncode(loginshipment));
      if (loginshipment.status == true) {
        shipmentToken = loginshipment.data[0].token;
        print("companyname");
        print(loginshipment.data[0].companyname);

        // print("Shipment Token $shipmentToken");
        // print("Shipment Id $shipmentId");
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString(
            "companyName",
            loginshipment.data[0].companyname == ""
                ? "NA"
                : loginshipment.data[0].companyname);

        prefs.setString('email', "$email");

        prefs.setBool('isLoginShipment', true);
        // prefs.setString('auth_token', shipmentToken);
        prefs.setString('Shipemnt_auth_token', shipmentToken);
        // Navigator.of(context).pushNamed('/dashboardship');

        storeemail.text = prefs.getString('email') != null
            ? prefs.getString('email').toString()
            : '';
        storepassword.text = prefs.getString('password') != null
            ? prefs.getString('password').toString()
            : '';
        prefs.setBool("rem", monVal!);
        print("monVal ==-= $monVal");
        if (loginshipment.data[0].companyname == "") {
          Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE);
        } else {
          Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => SHIPMENTDASHBOARD()));
        }

        // Navigator.of(context).pushReplacement(new MaterialPageRoute(
        //     builder: (BuildContext context) => ResDashboardshipment()));
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(loginshipment.message),
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

  bool _isProcessing = false;
  final TextEditingController storeemail = TextEditingController();

  final TextEditingController storepassword = TextEditingController();

  storeCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('monVal storeCred $monVal');
    print(prefs.get("rem"));
    prefs.get("rem") != null ? monVal = true : false;

    storeemail.text = prefs.getString('email') != null
        ? prefs.getString('email').toString()
        : '';
    storepassword.text = prefs.getString('password') != null
        ? prefs.getString('password').toString()
        : '';
    email = storeemail.text;
    password = storepassword.text;
    setState(() {});

    // signOutGoogle();
  }

  void initState() {
    super.initState();
    storeCred();
    signOutGoogle();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void signOutGoogle() async {
    print("signOutGoogle $kIsWeb");
    final GoogleSignIn googleSignIn = GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    try {
      if (prefs.get('isSocialLogin') == true) {
        googleSignIn.disconnect();
        await googleSignIn.signOut();
      }

      print("disconnect");
    } catch (e) {
      print("Error signing out. Try again. $e");
    }
  }

  Future<User?> signInShipWithGoogle() async {
    await Firebase.initializeApp();
    print("signInWithGoogle $kIsWeb");

    User? user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
        print("user data" + user.toString());
        socialLogin(user!.displayName, user.email, user.refreshToken);
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          user = userCredential.user;
          socialLogin(user!.displayName, user.email, user.refreshToken);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            print('The account already exists with a different credential.');
          } else if (e.code == 'invalid-credential') {
            print('Error occurred while accessing credentials. Try again.');
          }
        } catch (e) {
          print(e);
        }
      }
    }

    return user;
  }

  socialLogin(displayname, email, token) async {
    var socialData = {
      "name": "$displayname",
      "lname": " ",
      "email": "$email",
      "phone": " ",
      "provider": "Google",
      "social_token": "$token"
    };
    print("social login request" + jsonEncode(socialData));
    var responce = await Providers().socialShipmentLogin(socialData);
    print("social login response" + jsonEncode(socialData));
    print("responce.status-=-=- ${responce.status}");
    // print("responce.data[0]-=-=-= ${responce.data[0].token}");
    if (responce.status == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var clientToken = responce.data[0].token;

      prefs.setString('Shipemnt_auth_token', clientToken);
      prefs.setBool('isLoginShipment', true);
      prefs.setBool('isSocialLogin', true);

      Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE);
    } else {
      print(responce.message);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(responce.message),
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
                              margin: EdgeInsets.only(top: 64, left: 15),
                              child: Text("Sign in",
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700))),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 12, left: 15, right: 15),
                              child: Text("Go inside the best Shipment!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isProcessing = true;
                                  });
                                  await signInShipWithGoogle();
                                  // await signInWithGoogle().then((result) {
                                  //   log("result is" + result.toString());
                                  //   Navigator.of(context).pop();
                                  //   Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //       fullscreenDialog: true,
                                  //       builder: (context) => DashboardHome(),
                                  //     ),
                                  //   );
                                  // }).catchError((error) {
                                  //   print('Registration Error: $error');
                                  // });
                                  setState(() {
                                    _isProcessing = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(top: 15, left: 15),
                                    child: Image.asset(
                                        'assets/images/Group 13.png',
                                        height: 52,
                                        width: 50)),
                              ),
                              // GestureDetector(
                              //   onTap: () async {
                              //     // await _fblogin();
                              //   },
                              //   child: Container(
                              //       margin: EdgeInsets.only(top: 15, left: 16),
                              //       child: Image.asset(
                              //           'assets/images/Group 14.png',
                              //           height: 52,
                              //           width: 52)),
                              // ),
                            ],
                          ),

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
                              textInputAction: TextInputAction.next,
                              controller: storeemail,
                              autofillHints: [AutofillHints.username],
                              validator: (val) =>
                                  _emailValidation(val, "Email"),
                              onChanged: (value) {
                                email = value;
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
                              onFieldSubmitted: (value) {
                                doShipmentLOgin();
                              },
                              textInputAction: TextInputAction.search,
                              controller: storepassword,
                              autofillHints: [AutofillHints.password],
                              validator: (val) =>
                                  _requiredField(val, "Password"),
                              onChanged: (value) {
                                password = value;
                              },
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
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
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 15)),
                            ),
                          ),

                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 30),
                                child: Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, right: 15, top: 5),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 24.0,
                                      width: 24.0,
                                      child: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor:
                                                Color(0xff00C8E8) // Your color
                                            ),
                                        child: Checkbox(
                                          activeColor: Color(0xff00C8E8),
                                          value: monVal,
                                          onChanged: (bool? value) async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            setState(() {
                                              monVal = value;

                                              prefs.setString(
                                                  'email', "$email");
                                              prefs.setString(
                                                  'password', "$password");
                                            });
                                          },
// onChanged: _handleRemeberme
                                        ),
                                      )),
                                  SizedBox(width: 10.0),
                                  Text("Remember Me",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))
                                ]),
                          ),

                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 5, right: 15, top: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Theme(
                          //         data: Theme.of(context).copyWith(
                          //             unselectedWidgetColor: Colors.white),
                          //         child: Checkbox(
                          //           activeColor: Color(0xff43A047),
                          //           value: monVal,
                          //           onChanged: (bool? value) async {
                          //             setState(() {
                          //               monVal = value;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //       Text("I agree to terms & conditions",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.only(left: 5, right: 15),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: [
                          //       Theme(
                          //         data: Theme.of(context).copyWith(
                          //             unselectedWidgetColor: Colors.white),
                          //         child: Checkbox(
                          //           activeColor: Color(0xff43A047),
                          //           value: monVal2,
                          //           onChanged: (bool? value) async {
                          //             setState(() {
                          //               monVal2 = value;
                          //             });
                          //           },
                          //         ),
                          //       ),
                          //       Text(
                          //           "I’d like being informed about latest news and tips",
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: 16,
                          //               fontWeight: FontWeight.w500)),
                          //     ],
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () {
                              doShipmentLOgin();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             ResDashboardshipment()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 30),
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
                                          child: Text("Sign in as Shipment",
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
                                margin: EdgeInsets.fromLTRB(0, 20, 5, 10),
                                child: Text(
                                  'Don’t have an account?',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignupScreenfirst()),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    'Sign up',
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
        ),
      )),
    );
  }
}
