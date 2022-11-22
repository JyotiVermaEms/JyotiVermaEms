import 'package:flutter/material.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Model/Chat.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Accountant/AccountSidebar.dart';
import 'package:shipment/component/Res_Client/ChatCard.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class AccountantChatScreen extends StatefulWidget {
  const AccountantChatScreen({Key? key}) : super(key: key);

  @override
  _AccountantChatScreenState createState() => _AccountantChatScreenState();
}

class _AccountantChatScreenState extends State<AccountantChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var exp = true, openSUBMENU = false;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: AccountantSideBar(),
      ),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: Color(0xffE5E5E5),
        child: SafeArea(
          right: false,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      IconButton(
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      ),
                    if (!Responsive.isDesktop(context)) SizedBox(width: 5),
                  ],
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
                    height: 52,
                    width: MediaQuery.of(context).size.width * (27 / 100),
                    child: TextFormField(
                      initialValue: '',
                      onChanged: (value) {},
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                      decoration: InputDecoration(
                          fillColor: Color(0xffFFFFFF),
                          filled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              // tapped == true ? progessBar() : null;
                            },
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search, color: Colors.grey),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffFFFFFF)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffFFFFFF)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffFFFFFF)),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                width: 1.2, color: Color(0xffFFFFFF)),
                          ),
                          // border: InputBorder.none,
                          hintText: "Search",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  // On mobile this active dosen't mean anything
                  itemBuilder: (context, index) => ChatCard(
                    isActive: Responsive.isMobile(context) ? false : index == 0,
                    chat: messages[index],
                    press: () {
                      // (!Responsive.isDesktop(context))
                      //     ? Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => ChatViewScreen(),
                      //         ))
                      //     : Null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
