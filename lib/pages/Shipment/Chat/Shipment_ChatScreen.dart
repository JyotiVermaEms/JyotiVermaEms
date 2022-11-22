// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/ViewChatScreen.dart';
import 'package:shipment/Element/extensions.dart';
import 'package:shipment/Model/Chat.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/Shipment/chat/chatListModel.dart';
import 'package:shipment/Model/chatSearchListModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ChatCard.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_ChatScreen_shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/Chat/chatScreen.dart';

import '../../../constants.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class ChatScreenShipment extends StatefulWidget {
  const ChatScreenShipment({Key? key}) : super(key: key);

  @override
  _ChatScreenShipmentState createState() => _ChatScreenShipmentState();
}

class _ChatScreenShipmentState extends State<ChatScreenShipment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? selectedDate = DateTime.now();
  var h, w;
  var exp = true, openSUBMENU = false;

  List<ChatListResponse>? chatListResponse;

  List<SearchResponse> chatSearchResponse = [];

  List<ClientResults> clientResults = [];
  List<ShipmentResult> shipmentResult = [];

  var searchResponse = [];

  late final TextEditingController? searchController = TextEditingController();

  searchClientList(name) async {
    var searchData = {"name": name.toString()};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get("Shipemnt_auth_token");

    final response = await Providers().chatSearchList(searchData, token);
    if (response.status == true) {
      print(response.data[0].clientResults.length);
      print(response.data[0].shipmentResult.length);

      if (response.data[0].clientResults.length > 0) {
        searchResponse = response.data[0].clientResults;
      } else if (response.data[0].shipmentResult.length > 0) {
        searchResponse = response.data[0].shipmentResult;
      } else if (response.data[0].clientResults.length > 0 &&
          response.data[0].shipmentResult.length > 0) {
        searchResponse = response.data[0].clientResults;
        searchResponse = response.data[0].shipmentResult;
      }

      print("-=-=-=>>>> $searchResponse");

      setState(() {});
      //print("-=-=-= $chatSearchResponse");
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

  late bool isActive = false;
  var userId = 0;
  var userRole = '';
  void getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userDetails = await Providers().getshipmentProfile();

    if (userDetails.status == true) {
      setState(() {
        userId = userDetails.data[0].id;
        userRole = userDetails.data[0].roles;
      });

      print("-=-=-=data $userId   $userRole");
      getChatList();
    }
  }

  getChatList() async {
    print("getChatList");
    var data = {
      // "userId": "9",
      // "userToRole": "1c"
      "userId": userId.toString(),
      "userToRole": userRole.toString()
    };
    var response = await Providers().getChatList(data);
    print("-=-=-=data ${data}");
    if (response.status == true) {
      print("-=-=-=response data ${response.data}");

      chatListResponse = response.data;

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetails();
    // Future.delayed(const Duration(seconds: 2), () {
    //   print("data");
    //   // getChatList();
    // });
  }

  late StateSetter _setState;

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: ShipmentSidebar(),
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
              // Row(
              //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   // crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Container(
              //       margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
              //       height: 52,
              //       width: MediaQuery.of(context).size.width * (27 / 100),
              //       child: TextFormField(
              //         controller: searchController,
              //         //initialValue: 'Search here',
              //         onChanged: (value) {
              //           // print("search api $value");
              //           // if (value.length > 2) {
              //           //   searchClientList(value);
              //           // }
              //         },
              //         style: TextStyle(color: Colors.black54, fontSize: 17),
              //         decoration: InputDecoration(
              //             fillColor: Color(0xffFFFFFF),
              //             filled: true,
              //             prefixIcon: IconButton(
              //               onPressed: () {
              //                 if (searchController!.text.length > 2) {
              //                   searchClientList(searchController!.text);
              //                 }
              //               },
              //               icon: Icon(Icons.search, color: Colors.grey),
              //             ),
              //             suffixIcon: searchController!.text.isNotEmpty
              //                 ? IconButton(
              //                     onPressed: () {
              //                       searchController!.clear();
              //                       searchResponse = [];
              //                       getChatList();
              //                     },
              //                     icon: Icon(Icons.cancel_outlined,
              //                         color: Colors.grey),
              //                   )
              //                 : Text(''),
              //             enabledBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //               borderSide: BorderSide(
              //                   width: 1.2, color: Color(0xffFFFFFF)),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(10.0),
              //               borderSide: BorderSide(
              //                   width: 1.2, color: Color(0xffFFFFFF)),
              //             ),
              //             errorBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //               borderSide: BorderSide(
              //                   width: 1.2, color: Color(0xffFFFFFF)),
              //             ),
              //             focusedErrorBorder: OutlineInputBorder(
              //               borderRadius: BorderRadius.all(Radius.circular(10)),
              //               borderSide: BorderSide(
              //                   width: 1.2, color: Color(0xffFFFFFF)),
              //             ),
              //             hintText: "Search",
              //             hintStyle:
              //                 TextStyle(color: Colors.grey, fontSize: 15)),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(height: kDefaultPadding),
              Expanded(
                child: searchResponse.isEmpty
                    ? ListView.builder(
                        itemCount: chatListResponse!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                                vertical: kDefaultPadding / 2),
                            child: InkWell(
                              onTap: () async {
                                touchedIndex = index;

                                var userTo =
                                    chatListResponse![index].userId; //other
                                var userBy = userId; //me
                                var userToRole =
                                    chatListResponse![index].userToRole;
                                var userByRole = userRole;

                                var data11;

                                data11 = {
                                  "room_id": chatListResponse![index]
                                      .roomId
                                      .toString(),
                                  "user_id": chatListResponse![index]
                                      .userId
                                      .toString(),
                                  "sid": chatListResponse![index].sid,
                                  "firm_name": chatListResponse![index]
                                      .fullName
                                      .toString(),
                                  "userTo": userTo,
                                  "userBy": userBy,
                                  "userToRole": userToRole,
                                  "userByRole": userByRole,
                                };

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatViewScreen(data11),
                                    ));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(kDefaultPadding),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? kPrimaryColor
                                          : kBgDarkColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 32,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: chatListResponse![
                                                                  index]
                                                              .profileimage !=
                                                          ""
                                                      ? NetworkImage(
                                                          chatListResponse![
                                                                  index]
                                                              .profileimage
                                                              .toString())
                                                      : AssetImage(
                                                              'assets/images/user_err.png')
                                                          as ImageProvider),
                                            ),
                                            SizedBox(
                                                width: kDefaultPadding / 2),
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Text.rich(
                                                  TextSpan(
                                                    text:
                                                        "${chatListResponse![index].fullName} \n",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isActive
                                                          ? Colors.white
                                                          : kTextColor,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: chatListResponse![
                                                                index]
                                                            .lastMessage,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText2!
                                                            .copyWith(
                                                              color: isActive
                                                                  ? Colors.white
                                                                  : kTextColor,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              chatListResponse![index]
                                                  .lastMessageTime,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    color: isActive
                                                        ? Colors.white70
                                                        : null,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: kDefaultPadding / 2),
                                        // Text(
                                        //   chat!.body,
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: Theme.of(context).textTheme.caption!.copyWith(
                                        //         height: 1.5,
                                        //         color: isActive ? Colors.white70 : null,
                                        //       ),
                                        // )
                                      ],
                                    ),
                                  ).addNeumorphism(
                                    blurRadius: 15,
                                    borderRadius: 15,
                                    offset: Offset(5, 5),
                                    topShadowColor: Colors.white60,
                                    bottomShadowColor:
                                        Color(0xFF234395).withOpacity(0.15),
                                  ),
                                  // if (!chat!.isChecked)
                                  //   Positioned(
                                  //     right: 8,
                                  //     top: 8,
                                  //     child: Container(
                                  //       height: 12,
                                  //       width: 12,
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: kBadgeColor,
                                  //       ),
                                  //     ).addNeumorphism(
                                  //       blurRadius: 4,
                                  //       borderRadius: 8,
                                  //       offset: Offset(2, 2),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: searchResponse.length,
                        itemBuilder: (context, index) {
                          print("-=-=-len ${searchResponse.length}");
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding,
                                vertical: kDefaultPadding / 2),
                            child: InkWell(
                              onTap: () async {
                                touchedIndex = index;

                                var userTo = searchResponse[index].id; //other
                                var userBy = userId; //me
                                var userToRole = searchResponse[index].roles;
                                var userByRole = userRole;

                                var data11;

                                data11 = {
                                  "room_id": 0,
                                  "user_id": searchResponse[index].id,
                                  "sid": 0,
                                  "firm_name":
                                      searchResponse[index].name.toString(),
                                  "userTo": userTo,
                                  "userBy": userBy,
                                  "userToRole": userToRole,
                                  "userByRole": userByRole,
                                };

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatViewScreen(data11),
                                    ));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(kDefaultPadding),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? kPrimaryColor
                                          : kBgDarkColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 32,
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: searchResponse[
                                                                  index]
                                                              .profileimage !=
                                                          ""
                                                      ? NetworkImage(
                                                          searchResponse[index]
                                                              .profileimage
                                                              .toString())
                                                      : AssetImage(
                                                              'assets/images/user_err.png')
                                                          as ImageProvider),
                                            ),
                                            SizedBox(
                                                width: kDefaultPadding / 2),
                                            Expanded(
                                              child: Text.rich(
                                                TextSpan(
                                                  text:
                                                      "${searchResponse[index].name} \n",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: isActive
                                                        ? Colors.white
                                                        : kTextColor,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(
                                                            color: isActive
                                                                ? Colors.white
                                                                : kTextColor,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption!
                                                      .copyWith(
                                                        color: isActive
                                                            ? Colors.white70
                                                            : null,
                                                      ),
                                                ),
                                                SizedBox(height: 5),
                                                // if (chat!.isAttachmentAvailable)
                                                //   WebsafeSvg.asset(
                                                //     "assets/Icons/Paperclip.svg",
                                                //     color: isActive ? Colors.white70 : kGrayColor,
                                                //   )
                                              ],
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: kDefaultPadding / 2),
                                        // Text(
                                        //   chat!.body,
                                        //   maxLines: 2,
                                        //   overflow: TextOverflow.ellipsis,
                                        //   style: Theme.of(context).textTheme.caption!.copyWith(
                                        //         height: 1.5,
                                        //         color: isActive ? Colors.white70 : null,
                                        //       ),
                                        // )
                                      ],
                                    ),
                                  ).addNeumorphism(
                                    blurRadius: 15,
                                    borderRadius: 15,
                                    offset: Offset(5, 5),
                                    topShadowColor: Colors.white60,
                                    bottomShadowColor:
                                        Color(0xFF234395).withOpacity(0.15),
                                  ),
                                  // if (!chat!.isChecked)
                                  //   Positioned(
                                  //     right: 8,
                                  //     top: 8,
                                  //     child: Container(
                                  //       height: 12,
                                  //       width: 12,
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: kBadgeColor,
                                  //       ),
                                  //     ).addNeumorphism(
                                  //       blurRadius: 4,
                                  //       borderRadius: 8,
                                  //       offset: Offset(2, 2),
                                  //     ),
                                  //   ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
