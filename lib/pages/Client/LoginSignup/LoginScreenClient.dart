// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login_web/flutter_facebook_login_web.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';
import 'package:sha3/sha3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Model/Client/clientLoginModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/component/Res_Receptionist/Res_Booking.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/component/Res_Shipment.dart/Dashboard/Res_dashboard_shipment.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/Socail_Login_Mobile.dart';

import 'package:shipment/pages/Client/LoginSignup/forgotpassword.dart';
import 'package:shipment/pages/Client/subscriptionScreen.dart';

import '../../../helper/routes.dart';
import '../Dashboard/MobileDashboard.dart';

class LoginScreenClient extends StatefulWidget {
  const LoginScreenClient({Key? key}) : super(key: key);

  @override
  _LoginScreenClientState createState() => _LoginScreenClientState();
}

class _LoginScreenClientState extends State<LoginScreenClient> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isProcess = false;

  String? uid;
  String? name;
  String? userEmail;
  String? imageUrl;
  String? googleToken;
  List<LoginData> logindata = [];
  var date, planid;

  var mobileNumber,
      languages,
      country,
      profileImage,
      username,
      address1,
      companyname,
      lname,
      aboutMe;

  bool? monVal = false;
  bool _isProcessing = false;

  bool? monVal2 = false;
  bool _obscureText = true;

  String? email, password;
  List itemList = [];
  DateTime currentTime = new DateTime.now();

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

  var clientToken, clientId, emailId;
  doClientLogin() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var loginData = {
        "email": "$email",
        "password": "${encodeToSHA3(password)}",
      };
      print(jsonEncode(loginData));

      var login = await Providers().loginCommon(loginData);
      if (login.status == true) {
        if (login.data[0].roles == "1c") {
          clientToken = login.data[0].token;

          print("Client Token $clientToken");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "$email");
          prefs.setString('auth_token', clientToken);
          prefs.setBool('isLogin', true);
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);
          print("monVal ==-= $monVal");
          if (prefs.getString('auth_token') != null)
            Navigator.pushNamed(context, Routes.CLIENTDASHBOARDROUTE);
        } else if (login.data[0].roles == "2r") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "$email");
          prefs.setBool('isLoginReceptionist', true);
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);
          print("monVal ==-= $monVal");
          prefs.setString('receptionist_token', login.data[0].token);
          Navigator.pushNamed(context, Routes.RECEPTIONISTDASHBOARD);
        } else if (login.data[0].roles == "1") {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString(
              "companyName",
              login.data[0].companyname.toString() == ""
                  ? "NA"
                  : login.data[0].companyname.toString());

          prefs.setString('email', "$email");

          prefs.setBool('isLoginShipment', true);
          prefs.setString('Shipemnt_auth_token', login.data[0].token);

          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);
          print("monVal ==-= $monVal");
          if (login.data[0].token == null) {
            Navigator.pushNamed(context, Routes.SHIPMENTLOGINROUTE);
          } else {
            if (login.data[0].companyname == "") {
              Navigator.pushNamed(context, Routes.SHIPMENTUPDATEPROFILE);
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('plan_id', login.data[0].planId);
              prefs.setString('expiry_date', login.data[0].expireDate);
              final now = DateTime.now();
              final expirationDate =
                  DateFormat('yyyy-MM-dd').parse(login.data[0].expireDate);
              // final expirationDate = DateTime(2022, 1, 10);

              print("AAAAAAAAAA$expirationDate");
              final bool isExpired = expirationDate.isBefore(now);
              print("hjjhjhjhjhjj$isExpired");

              if (login.data[0].planId == 1 ||
                  login.data[0].expireDate.isEmpty ||
                  isExpired == true) {
                Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN);
              }
              Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD);
            }
          }
        } else if (login.data[0].roles == "5") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "$email");
          prefs.setBool('isLoginPickupAgent', true);
          prefs.setString('Pickup_Agent_token', login.data[0].token);
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);
          Navigator.pushNamed(context, Routes.PICKUPAGENTDASHBOARD);
        } else if (login.data[0].roles == "3") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', "$email");
          prefs.setBool('isLoginDeparture', true);
          prefs.setString('depature_token', login.data[0].token);
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);
          Navigator.pushNamed(context, Routes.DEPATUREDASHBOARD);
        } else if (login.data[0].roles == "4") {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('Arrival_Manager_token', login.data[0].token);
          prefs.setString('email', "$email");
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);

          Navigator.pushNamed(context, Routes.ARRIVALDASHBOARD);
        } else if (login.data[0].roles == "2") {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString('account_auth_token', login.data[0].token);
          prefs.setString('email', "$email");
          storeemail.text = prefs.getString('email') != null
              ? prefs.getString('email').toString()
              : '';
          storepassword.text = prefs.getString('password') != null
              ? prefs.getString('password').toString()
              : '';
          prefs.setBool("rem", monVal!);

          Navigator.pushNamed(context, Routes.ACCOUNTANTDASHBOARD);
        }
      } else {
        if (login.message == "Login Fail, Your Subscription plan expire") {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(login.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    prefs.setString('u_id', login.data[0].id.toString());
                    var ResendOtpdatadatA = login.data[0].id;
                    print("kkkkkkkkk${prefs.getString('u_id')}");
                    Navigator.pushNamed(
                        context, Routes.SUBSCRTIONSCREEN2); // Navigator.push(
                  },
                  child: const Text('Reneval'),
                ),
              ],
            ),
          );
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              content: Text(login.message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('ok'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  doClientLogin1() async {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var loginData = {
        "email": "$email",
        "password": "${encodeToSHA3(password)}",
      };
      print(jsonEncode(loginData));
      var login = await Providers().loginClient(loginData);
      if (login.status == true) {
        clientToken = login.data[0].token;
        // clientId = login.data[0].clientId.;
        print("Client Token $clientToken");
        // print("clientId $clientId");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', "$email");
        prefs.setString('auth_token', clientToken);
        prefs.setBool('isLogin', true);

        Navigator.pushNamed(context, Routes.CLIENTDASHBOARDROUTE);
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: Text(login.message),
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

  final TextEditingController storeemail = TextEditingController();

  final TextEditingController storepassword = TextEditingController();

  storeCred() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('monVal $monVal');
    prefs.get("rem") != null ? monVal = true : false;
    if (monVal == true) {
      setState(() {
        storeemail.text = prefs.getString('email') != null
            ? prefs.getString('email').toString()
            : '';
        storepassword.text = prefs.getString('password') != null
            ? prefs.getString('password').toString()
            : '';
      });
    }

    signOutGoogle();
  }

  Future getProfile() async {
    setState(() {
      isProcess = true;
    });
    var response = await Providers().getshipmentProfile();

    if (response.status == true) {
      setState(() {
        date = response.data[0].expireDate;
        planid = response.data[0].planId;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('Shipemnt_auth_token') == "") {
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('plan_id', planid);
        prefs.setString('expiry_date', date);
        final now = DateTime.now();
        final expirationDate = DateFormat('yyyy-MM-dd').parse(date);
        // final expirationDate = DateTime(2022, 1, 10);

        print("AAAAAAAAAA$expirationDate");
        final bool isExpired = expirationDate.isBefore(now);
        print("hjjhjhjhjhjj$isExpired");

        if (planid == 0 ||
            response.data[0].expireDate.isEmpty ||
            isExpired == true) {
          Navigator.pushNamed(context, Routes.SUBSCRTIONSCREEN);
        } else {
          Navigator.pushNamed(context, Routes.SHIPMENTDASHBOARD);
        }
      }

      print("REPONSE" + jsonEncode(response.data));
    }
    setState(() {
      isProcess = false;
    });
  }

  void initState() {
    super.initState();
    // getProfile();
   
    storeCred();
  }

  void signOutGoogle() async {
    print("signOutGoogleprint $kIsWeb");
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

  String _message = '';

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
    var responce = await Providers().socialclientLogin(socialData);
    print("social login response" + jsonEncode(socialData));
    print("responce.status-=-=- ${responce.status}");
    // print("responce.data[0]-=-=-= ${responce.data[0].token}");
    if (responce.status == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var clientToken = responce.data[0].token;

      prefs.setString('auth_token', clientToken);
      prefs.setBool('isLogin', true);
      prefs.setBool('isSocialLogin', true);
      print(">>>>>>>>>>" + responce.status.toString());

      (Responsive.isDesktop(context))
          ? Navigator.pushNamed(context, Routes.CLIENTDASHBOARDROUTE)
          : Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => DashboardHome()));
    } else {
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

  socialfbLogin(googleToken) async {
    var socialData = {
      "name": "",
      "lname": " ",
      "email": "",
      "phone": " ",
      "provider": "Facebook",
      "social_token": "$googleToken"
    };

    var responce = await Providers().socialfbLogin(socialData);
    log(jsonEncode(responce));
    if (responce.status == true) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => DashboardHome()));
    } else {
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

  Future<User?> signInWithGoogle() async {
    await Firebase.initializeApp();
    // print("signInWithGoogle $kIsWeb");

    User? user;
    // signOutGoogle();
    // return user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);
        user = userCredential.user;
        print("user data" + user.toString());
        socialLogin(user!.displayName, user.email, user.refreshToken);
      } catch (e) {
        print("Praveen>>>>>>>>" + e.toString());
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
        print("google token---" + credential.toString());
        try {
          final UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          print("google token 12---" + userCredential.toString());
          user = userCredential.user;
          print("user data" + user.toString());
          socialLogin(user!.displayName, user.email,
              googleSignInAuthentication.accessToken);
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
  }

  //   // if (user != null) {
  //   //   uid = user.uid;
  //   //   name = user.displayName;
  //   //   userEmail = user.email;
  //   //   imageUrl = user.photoURL;
  //   //   googleToken = user.refreshToken;

  //   //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //   // prefs.setBool('auth', true);
  //   // }

  //   return user;
  // }

  String createdViewId = 'map_element';

  @override
  void dispose() {
    super.dispose();
  }

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pushNamed(context, Routes.SPLASHROUTE);

          return Future(() => true);
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Background.png"),
                  fit: BoxFit.cover)),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: SizedBox(
                      width: 400,
                      child: ListView(
                        children: [
                          AutofillGroup(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        top: (Responsive.isDesktop(context))
                                            ? 64
                                            : 10,
                                        left: 15),
                                    child: Text("Sign in",
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontWeight: FontWeight.w700))),
                                Container(
                                    margin: EdgeInsets.only(
                                        top: (Responsive.isDesktop(context))
                                            ? 12
                                            : 5,
                                        left: 15,
                                        right: 15),
                                    child: Text("Go inside the best Shipment!",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ))),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (Responsive.isDesktop(context))
                                        ? GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                _isProcessing = true;
                                              });
                                              await signInWithGoogle();

                                              setState(() {
                                                _isProcessing = false;
                                              });
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 15, left: 15),
                                                child: Image.asset(
                                                    'assets/images/Group 13.png',
                                                    height: 52,
                                                    width: 50)),
                                          )
                                        : GestureDetector(
                                            onTap: () async {
                                              signInWithGoogle();
                                              // setState(() {
                                              //   isLoading = true;
                                              // });
                                              // FirebaseService service =
                                              //     new FirebaseService();
                                              // try {
                                              //   await service
                                              //       .signInwithGoogle();

                                              //   User? user = FirebaseAuth
                                              //       .instance.currentUser;
                                              //   print(user);
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               DashboardHome()));
                                              // } catch (e) {
                                              //   if (e
                                              //       is FirebaseAuthException) {
                                              //     showMessage(e.message!);
                                              //   }
                                              // }
                                            },
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 15, left: 15),
                                                child: Image.asset(
                                                    'assets/images/Group 13.png',
                                                    height: 52,
                                                    width: 50)),
                                          ),
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

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: (Responsive.isDesktop(context))
                                              ? 36
                                              : 10,
                                          left: 15,
                                          right: 15),
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
                                        _requiredField(val, "Email"),
                                    onChanged: (value) {
                                      email = value;
                                    },
                                    onSaved: (value) {
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
                                // SizedBox(height: MediaQuery.of(context).size.height * (5 / 100)),

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 15, right: 15),
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
                                      doClientLogin();
                                    },
                                    textInputAction: TextInputAction.search,
                                    controller: storepassword,
                                    autofillHints: [AutofillHints.password],
                                    validator: (val) =>
                                        _requiredField(val, "Password"),
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    onSaved: (value) {
                                      password = value;
                                    },
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
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
                                            builder: (context) =>
                                                ForgotPassword()),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 30),
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                            fontSize: 14),
                                      ),
                                    ),
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
                                            unselectedWidgetColor:
                                                Colors.white),
                                        child: Checkbox(
                                          activeColor: Color(0xff43A047),
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
                                        ),
                                      ),
                                      Text("Remember Me ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    doClientLogin();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: (Responsive.isDesktop(context))
                                            ? 30
                                            : 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        color: Color(0xff1F2326)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            margin: EdgeInsets.all(15),
                                            child: Center(
                                                child: Text("Sign In",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    )))),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: (Responsive.isDesktop(
                                                      context))
                                                  ? 15
                                                  : 5,
                                              right: 10),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ));
  }
}
