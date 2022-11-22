// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, unused_field, non_constant_identifier_names, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  var data;
  ChatScreen(this.data, {Key? key}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late File _image;
  late bool _connectedToSocket;
  late bool _connectedToSocket2;

  late IO.Socket socket;

  bool tapped = false;

  late String username, profilePic;
  late bool online;
  var message, sender_id, receiver_id, date, room_id, time, text, request;

  var chathistory = [];
  late List<String> messages;
  var array1 = [];
  bool isActive = false;
  late int minutes;
  String logText = "";

  DateTime now = DateTime.now();

  dateTime() {
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(now);
    final String changeTime = DateFormat('HH:mm').format(DateTime.now());
    setState(() {
      date = formatted;
      time = changeTime;
      print("Date $date");
      print("Time $time");
    });
  }

  var sId, UserId;

  void getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userDetails = await Providers().getshipmentProfile();
    print(userDetails.status);
    if (userDetails.status == true) {
      sId = userDetails.data[0].id;

      setState(() {
        UserId = sId;
      });
    }

    // print("DATATT ${json.encode(profileDetails)}");
  }

  bool isProcess = false;
  var myresponse = [];
  void getChatHistory() async {
    print('mfkcdmkvmfdvmkfd');
    print(widget.data.toString());
    // setState(() {
    //   isProcess = true;
    // });
    var chatHistory = {
      "room_id": widget.data['room_id'].toString(),
      "user_id": widget.data['user_id'].toString(),

      //  "room_id":1,
      //  "userId": 143
    };

    print("object-==-==" + jsonEncode(chatHistory));
    var getData = await Providers().ChatHistory(chatHistory);
    print("-=-=- chatHistory ${chatHistory}");
    if (this.mounted) {
      setState(() {
        chathistory = getData.data;
      });
    }
    log("chat histroy data" + jsonEncode(chathistory));
    if (chathistory.length > 0) {
      int lastIndex = 0;
      for (int i = 0; i < chathistory.length; i++) {
        if (chathistory[i].receiverId != widget.data['user_id']) {
          lastIndex = i;
          break;
        }
      }
      var date = chathistory[lastIndex].date;
      date = date.split('-')[2] +
          "-" +
          date.split('-')[0] +
          "-" +
          date.split('-')[1];

      var lastmsgTime = date + ' ' + chathistory[lastIndex].time + ":00";
      Duration diff = DateTime.now().difference(DateTime.parse(lastmsgTime));
      if (diff.inMinutes < 1) {
        setState(() {
          isActive = true;
          logText = "";
        });
      } else {
        if (this.mounted) {
          setState(() {
            minutes = diff.inMinutes;
          });
        }
        if (diff.inMinutes < 60) {
          setState(() {
            logText = "Last seen " + minutes.toString() + "m ago";
          });
        } else {
          if (this.mounted) {
            setState(() {
              logText =
                  "Last seen " + ((minutes / 60).toInt()).toString() + "h ago";
            });
          }
        }
        print("now " + DateTime.now().toString());
        print("minuts" + minutes.toString());
        print("time" + lastmsgTime);
      }
    }

    if (uiRender) {
      setState(() {
        uiRender = true;
      });
    } else {
      if (this.mounted) {
        setState(() {
          uiRender = false;
        });
      }
    }

    // setState(() {});
    print("DATATT ${json.encode(array1)}");
  }

  bool uiRender = false;
  void connectToServer() {
    try {
      print("in try1");

      // Configure socket transports must be sepecified
      IO.Socket socket =
          IO.io('https://shipment.engineermaster.in/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();

      var check = {
        "room_id": widget.data['room_id'],
        "message": text,
        "receiver_id": widget.data['user_id'],
        "sender_id": UserId.toString(),
        "date": date,
        "time": time
      };
      print("object data" + jsonEncode(check).toString());

      socket.emit("message", {
        "room_id": widget.data['room_id'],
        "message": text,
        "receiver_id": widget.data['user_id'],
        "sender_id": UserId.toString(),
        "date": date,
        "time": time,
      });

      print("in try3");
      print(widget.data['room_id']);
      print(widget.data['user_id']);
      print(UserId.toString());
      // Handle socket events
      socket.on(
          'connect',
          (_) => {
                // print("_connectedToSocket " + socket.connected.toString())
                // setState(() {
                //   _connectedToSocket = true;
                // })
              });
      socket.on('message', handleMessage);
      print("in try4");

      //socket.on('location', handleLocationListen);
      //socket.on('typing', handleTyping);
      // socket.on('message', message);
      print("in try5");
      print("in try 6");
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print("error is " + e.toString());
    }
  }

  // Send Location to Server
  sendLocation(Map<String, dynamic> data) {
    //socket.emit("location", data);
  }

  // Listen to Location updates of connected usersfrom server
  handleLocationListen(Map<String, dynamic> data) async {
    print("location" + data.toString());
  }

  // Send update of user's typing status
  sendTyping(bool typing) {
    // socket.emit("typing", {
    //   "id": socket.id,
    //   "typing": typing,
    // });
  }

  // Listen to update of typing status from connected users
  handleTyping(Map<String, dynamic> data) {
    // print(data);
  }

  // Send a Message to the server
  sendMessage(String message) {
    socket.emit("message", request);
  }

  // Listen to all message events from connected users
  void handleMessage(data) {
    print('hello');
    //getChatHistory();
    var msg = (data['message']['room']);

    log("msg ${msg}");
  }

  @override
  void initState() {
    super.initState();
    getChatHistory();

    dateTime();
    getProfileDetails();
    _connectedToSocket = false;
    _connectedToSocket2 = false;

    connectToServer2();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        title: Row(
          children: [
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.data['firm_name'],
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
                // online
                //     ?
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 1),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.yellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      isActive ? "Active Now" : "${logText}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
                // : Text(
                //     time,
                //     style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: 12,
                //     ),
                //   ),
              ],
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.more_vert, size: 20),
        //     color: Colors.black,
        //     onPressed: () {
        //       Navigator.pushReplacement(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => JobDescription(widget.data)));
        //     },
        //   ),
        // ],
      ),
      body: isProcess == true
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: ListView.builder(
                    // reverse: true,
                    itemCount: chathistory.length > 0 ? chathistory.length : 0,
                    shrinkWrap: true,
                    reverse: true,

                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // print(array1[index].message);
                      return Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: chathistory[index].senderId ==
                                  widget.data['user_id']
                              ? Alignment.topLeft
                              : Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: chathistory[index].senderId ==
                                        widget.data['user_id']
                                    ? Colors.grey
                                    : Color(0xff43A047)
                                //  ),
                                ),
                            padding: EdgeInsets.all(16),
                            child: Text(
                              (chathistory[index] != null &&
                                      chathistory[index] != "")
                                  ? (chathistory[index].message == null ||
                                          chathistory[index].message == '' ||
                                          chathistory[index].message ==
                                              'null' ||
                                          chathistory[index].message == Null)
                                      ? " "
                                      : chathistory[index].message
                                  : null,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              onChanged: (value) {
                                if (value.length >= 1) {
                                  // textEditingController.text = value;
                                  text = value;
                                  setState(() {
                                    tapped = true;
                                  });
                                } else {
                                  setState(() {
                                    tapped = false;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                              // chathistory.add(json.decode(text));
                              textEditingController.clear();
                              // tapped == true ?

                              // this.setState(
                              //     () => messages.add(textEditingController.text));
                              // textEditingController.text = '';

                              connectToServer();

                              // : null;
                              // text = "";
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Color(0xff43A047),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void connectToServer2() {
    try {
      // Configure socket transports must be sepecified
      IO.Socket socket = IO.io('http://44.194.48.17', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();

      socket.on(
          'connect',
          (_) => {
                print("_connectedToSocket2" + socket.connected.toString())
                // setState(() {
                //   _connectedToSocket = true;
                // })
              });
      socket.on('disconnect', (_) => print('disconnect'));
      socket.on('fromServer', (_) => print(_));
    } catch (e) {
      print(e.toString());
    }
  }
}
