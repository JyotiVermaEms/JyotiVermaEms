import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/component/Res_Client/DashboardHome.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/LoginSignup/LoginScreenClient.dart';
import 'package:shipment/pages/Client/LoginSignup/SignupScreenClient.dart';
import 'package:shipment/pages/Receptionist/Login/LoginReception.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Center(
            child: SizedBox(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 15),
                      child: Text("Shipment",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold))),
                  Container(
                      margin: EdgeInsets.only(top: 61, left: 15),
                      child: Text("Welcome! to Shipment...",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 18,
                          ))),
                  Container(
                      margin: EdgeInsets.only(top: 17, left: 15),
                      child: Text("Choose your category",
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

                              // width: MediaQuery.of(context).size.width * 0.8,
                              // color: Colors.lime,
                              child: Center(
                                  child: Text("Sign in as client",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )))),
                          Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            height: 20,
                            width: 20,
                            child: Image.asset('assets/images/arrow-right.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, Routes.RECEPTIONISTLOGINROUTE);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => LoginReception()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(50.0),
                          color: Color(0xff1F2326)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.all(15),

                              // width: MediaQuery.of(context).size.width * 0.8,
                              // color: Colors.lime,
                              child: Center(
                                  child: Text("Sign in as Receptionist",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      )))),
                          Container(
                            margin: EdgeInsets.only(top: 15, right: 10),
                            height: 20,
                            width: 20,
                            child: Image.asset('assets/images/arrow-right.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
    );
  }
}
