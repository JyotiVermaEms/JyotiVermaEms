import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/Model/Chat.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Arrival%20Manager/Order/OrderManagement.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Order.dart';
import 'package:shipment/component/Pickup%20Agent/Order/inprogressorderList.dart';
import 'package:shipment/component/Res_Receptionist/Res_Booking.dart';
import 'package:shipment/component/Res_Shipment.dart/ResMarketPlace/Res_marketplace_Shipment.dart';
import 'package:shipment/component/Res_Shipment.dart/ShipmentOrder/Res_Order.dart';
import 'package:shipment/constants.dart';
import 'package:shipment/helper/routes.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:universal_html/html.dart';

import 'package:http/http.dart' as http;

class ChatViewScreen extends StatefulWidget {
  var data;
  ChatViewScreen(this.data, {Key? key}) : super(key: key);
  @override
  State<ChatViewScreen> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  TextEditingController textEditingController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // late File _image;
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

    var userDetails;
    if (prefs.getString('Shipemnt_auth_token') != null) {
      userDetails = await Providers().getshipmentProfile();
    } else if (prefs.getString('auth_token') != null) {
      userDetails = await Providers().getClientProfile();
    } else if (prefs.getString('depature_token') != null) {
      userDetails = await Providers().getDepatureProfile();
    } else if (prefs.getString('Pickup_Agent_token') != null) {
      userDetails = await Providers().getpickupAgentProfile();
    } else if (prefs.getString('Arrival_Manager_token') != null) {
      userDetails = await Providers().getArrivalManagerProfile();
    } else if (prefs.getString('receptionist_token') != null) {
      userDetails = await Providers().getReceptionisProfile();
    }

    print(userDetails.status);
    if (userDetails.status == true) {
      // sId = userDetails.data[0].id;

      setState(() {
        UserId = userDetails.data[0].id;
      });

      print("-=-=-UserId $UserId");

      getChatHistory();
    }
  }

  bool isProcess = false;
  var myresponse = [];
  void getChatHistory() async {
    print('mfkcdmkvmfdvmkfd getChatHistory');
    print(widget.data.toString());

    print("-=-=- ${widget.data['user_id']}");
    // setState(() {
    //   isProcess = true;
    // });
    var chatHistory = {
      "room_id": widget.data['room_id'].toString(),
      "userId": widget.data['user_id'].toString(),
    };

    print("object-==-==" + jsonEncode(chatHistory));
    var getData = await Providers().ChatHistory(chatHistory);
    print("-=-=- chatHistory ${chatHistory}");
    // if (this.mounted) {
    setState(() {
      chathistory = getData.data;
    });
    // }
    log("chat histroy data" + jsonEncode(chathistory));
    if (chathistory.length > 0) {
      int lastIndex = 0;
      for (int i = 0; i < chathistory.length; i++) {
        if (chathistory[i].receiverId != widget.data['userTo']) {
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

  var imageURL;
  PlatformFile? objFile = null;

  String imagepath = '';
  String msgType = 'text';

  Future<void> connectToServer() async {
    print("connectToServer-=-=");
    try {
      print("in try1111");

      // http://44.194.48.17:4000 Configure socket transports must be sepecified
      IO.Socket socket =
          IO.io('https://shipment.engineermaster.in/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      setState(() {
        socket.connect();
      });

      socket.emit("message", {
        "room_id": widget.data['room_id'],
        "message": textEditingController.text,
        "receiver_id": widget.data['receiver_id'],
        "sender_id": widget.data['sender_id'].toString(),
        "date": date,
        "time": time,
        "file": imagepath.toString(),
        "message_type": textEditingController.text.isNotEmpty ? "text" : "file"
      });

      // Handle socket events
      socket.on(
          'connect',
          (_) => {
                print("_connectedToSocket " + socket.connected.toString())
                // setState(() {
                //   _connectedToSocket = true;
                // })
              });

      socket.on('message', handleMessage);

      //socket.on('location', handleLocationListen);
      //socket.on('typing', handleTyping);
      //socket.on('message', message);
      print(socket.connected);
      //socket.on('disconnect', (_) => print('disconnect'));
      //socket.on('fromServer', (_) => print(_));
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
    socket.emit(
      "message",
      {
        "id": socket.id,
        "message": "message", // Message to be sent
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // Listen to all message events from connected users
  void handleMessage(data) {
    print('handleMessage $data');
    print("again call getChatHistory");

    getChatHistory();
    var msg = (data['message']['room']);

    log("msg ${msg}");
  }

  @override
  void initState() {
    super.initState();
    print("-=-userList=>>> ${widget.data['userList']}");
    getProfileDetails();
    print("-=-room_id=>>> ${widget.data['room_id']}");

    getChatHistory();

    dateTime();

    _connectedToSocket = false;
    _connectedToSocket2 = false;

    // connectToServer2();
    connectToServer();
  }

  void dispose() {
    super.dispose();
  }

  void connectToServer2() {
    try {
      // Configure socket transports must be sepecified
      IO.Socket socket = IO.io('http://44.194.48.17:4000', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      print("connectToServer2 connect ${socket.connected} ");
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

  void chooseFileUsingFilePicker(BuildContext context) async {
    //-----pick file by file picker,

    print(widget.data);
    // return;

    var result = await FilePicker.platform.pickFiles(
        withReadStream:
            true, // this will return PlatformFile object with read stream
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      // setState(() async {
      objFile = result.files.single;
      print("objFILE  $objFile");

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("https://shipment.engineermaster.in/api/imageUrl"),
      );
      //-----add other fields if needed
      // request.fields["id"] = "abc";

      //-----add selected file with request
      request.files.add(new http.MultipartFile(
          "file", objFile!.readStream!, objFile!.size,
          filename: objFile!.name));

      //-------Send request
      var resp = await request.send();
      print("resp  >>>>>>>>>>>>>>..$resp");

      //------Read response
      var result2 = await resp.stream.bytesToString();

      var temp3 = ImageModel.fromJson(json.decode(result2));
      print("--=---=-= $result2");
      // temp2!.add(temp3);
      print("object  ${json.encode(temp3)}");

      setState(() {
        imagepath = temp3.data[0].image;
        msgType = "file";
      });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");

      if (widget.data['room_id'] == 0) {
        //==========create chat room============
        DateTime now = DateTime.now();
        final DateFormat formatter = DateFormat('MM-dd-yyyy');
        final String formattedDate = formatter.format(now);
        final String changeTime = DateFormat('HH:mm').format(DateTime.now());

        var dataPost = {
          "group_name": widget.data['group_name'].toString(),
          "time": time.toString(),
          "date": formattedDate.toString(),
          "chat_type": "group",
          "users": widget.data['userList'],
          "sid": widget.data['sid'].toString(),
        };
        var createRoomDetails = await Providers().createChatRoom(dataPost);

        print(createRoomDetails.data[0].roomId);

        if (createRoomDetails.status == true) {
          widget.data['room_id'] = createRoomDetails.data[0].roomId;
        }

        //==========create chat room============
      }

      var dataPost = {
        "message": textEditingController.text,
        "room_id": widget.data['room_id'].toString(),
        "receiver_id": widget.data['receiver_id'].toString(),
        "sender_id": widget.data['sender_id'].toString(),
        "sender_type": widget.data['sender_type'].toString(),
        "receiver_type": widget.data['receiver_type'].toString(),
        "time": time,
        "date": date,
        "file": imagepath.toString(),
        "message_type": msgType
      };

      var sendMsgDetails = await Providers().sendChatMessage(dataPost);
      print("-=-=-=sendMsgDetails ${sendMsgDetails.status}");
      connectToServer();
    }
  }

  final maxLines = 5;

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
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString("pageFrom") == "chat") {
                prefs.remove("pageFrom");
                Navigator.pop(context);
              } else {
                if (prefs.getString('Shipemnt_auth_token') != null) {
                  if (prefs.getString("mtype") == "market") {
                    prefs.remove("mtype");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResMarketPlaceShipment()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ResOrders()));
                  }
                } else if (prefs.getString('auth_token') != null) {
                  Navigator.pushNamed(context, Routes.CLIENTBOOKINGROUTE);
                } else if (prefs.getString('depature_token') != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Orders()));
                } else if (prefs.getString('Pickup_Agent_token') != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => inprogressOrderList()));
                } else if (prefs.getString('Arrival_Manager_token') != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderManagement()));
                } else if (prefs.getString('receptionist_token') != null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ResBookings()));
                }
              }
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
                  "${widget.data['firm_name']}  ",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
                // online
                //     ?
                Row(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(top: 1),
                    //   width: 10,
                    //   height: 10,
                    //   decoration: BoxDecoration(
                    //     color: Colors.green,
                    //     shape: BoxShape.circle,
                    //     border: Border.all(
                    //       width: 2,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 3),
                    // Text(
                    //   "Active Now",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      body: Stack(
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
                print("widget.data['sender_id']-=-=-=");
                print(widget.data['sender_id']);
                print("sendrid-=-=-= ${chathistory[index].senderId}");
                // print("UserId-=-=-= $UserId");
                print(widget.data);

                return Row(
                  children: [
                    chathistory[index].senderId != UserId
                        ? Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 32,
                              child: Tooltip(
                                message: chathistory[index].fullName,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: chathistory[index]
                                              .profileimage !=
                                          ""
                                      ? NetworkImage(
                                          chathistory[index].profileimage)
                                      : AssetImage("assets/images/user_err.png")
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                            alignment: chathistory[index].senderId == UserId
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: chathistory[index].senderId == UserId
                                      ? Colors.lightBlue
                                      : Colors.grey),
                              padding: EdgeInsets.all(16),
                              child: chathistory[index].messageType == "text"
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        chathistory[index].senderId != UserId
                                            ? Text(chathistory[index].fullName)
                                            : Text(""),
                                        Text(
                                          (chathistory[index] != null &&
                                                  chathistory[index] != "")
                                              ? (chathistory[index]
                                                              .message ==
                                                          null ||
                                                      chathistory[index]
                                                              .message ==
                                                          '' ||
                                                      chathistory[index]
                                                              .message ==
                                                          'null' ||
                                                      chathistory[index]
                                                              .message ==
                                                          Null)
                                                  ? " "
                                                  : chathistory[index].message
                                              : null,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          "\n ${chathistory[index].time}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      // width: 200,
                                      // height: 400,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return imageViewDialogChat(
                                                        context,
                                                        chathistory[index]
                                                            .file);
                                                  },
                                                );
                                              },
                                              child: Image.network(
                                                chathistory[index].file,
                                                width: 200,
                                              ),
                                            ),
                                            Text(
                                              "\n ${chathistory[index].time}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2!
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                            ),
                                          ]),
                                    ),
                            )),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      chooseFileUsingFilePicker(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      // textInputAction: TextInputAction.go,
                      controller: textEditingController,
                      maxLength: 250,
                      onSubmitted: (v) async {
                        if (textEditingController.text.isEmpty) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text("Please type a message"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        } else {
                          var dataPost = {
                            "message": textEditingController.text,
                            "room_id": widget.data['room_id'].toString(),
                            "receiver_id":
                                widget.data['receiver_id'].toString(),
                            "sender_id": widget.data['sender_id'].toString(),
                            "sender_type":
                                widget.data['sender_type'].toString(),
                            "receiver_type":
                                widget.data['receiver_type'].toString(),
                            "time": time,
                            "date": date,
                            "file": '',
                            "message_type": 'text'
                          };

                          var sendMsgDetails =
                              await Providers().sendChatMessage(dataPost);
                          setState(() {
                            getChatHistory();
                            connectToServer();

                            textEditingController.clear();
                          });
                        }

                        print("-=->>> ${widget.data['room_id']}");
                        if (widget.data['room_id'] == 0) {
                          //==========create chat room============
                          DateTime now = DateTime.now();
                          final DateFormat formatter = DateFormat('MM-dd-yyyy');
                          final String formattedDate = formatter.format(now);
                          final String changeTime =
                              DateFormat('HH:mm').format(DateTime.now());

                          var dataPost = {
                            "group_name": widget.data['group_name'].toString(),
                            "time": time.toString(),
                            "date": formattedDate.toString(),
                            "chat_type": "group",
                            "users": widget.data['userList'],
                            "sid": widget.data['sid'].toString(),
                          };

                          var createRoomDetails =
                              await Providers().createChatGroupRoom(dataPost);

                          print(createRoomDetails.data[0].roomId);

                          if (createRoomDetails.status == true) {
                            // print(
                            //     "-=-=-=createRoomDetails ${createRoomDetails.data}");

                            var dataPost = {
                              "message": textEditingController.text,
                              "room_id":
                                  createRoomDetails.data[0].roomId.toString(),
                              "receiver_id":
                                  widget.data['receiver_id'].toString(),
                              "sender_id": widget.data['sender_id'].toString(),
                              "sender_type":
                                  widget.data['sender_type'].toString(),
                              "receiver_type":
                                  widget.data['receiver_type'].toString(),
                              "time": time,
                              "date": date,
                              "file": '',
                              "message_type": 'text'
                            };
                            widget.data['room_id'] =
                                createRoomDetails.data[0].roomId.toString();
                            var sendMsgDetails =
                                await Providers().sendChatMessage(dataPost);
                            connectToServer();

                            textEditingController.clear();
                          }

                          //==========create chat room============
                        } else {
                          var dataPost = {
                            "message": textEditingController.text,
                            "room_id": widget.data['room_id'].toString(),
                            "receiver_id":
                                widget.data['receiver_id'].toString(),
                            "sender_id": widget.data['sender_id'].toString(),
                            "sender_type":
                                widget.data['sender_type'].toString(),
                            "receiver_type":
                                widget.data['receiver_type'].toString(),
                            "time": time,
                            "date": date,
                            "file": '',
                            "message_type": 'text'
                          };

                          var sendMsgDetails =
                              await Providers().sendChatMessage(dataPost);
                          setState(() {
                            connectToServer();

                            textEditingController.clear();
                          });
                        }
                      },
                      // expands: true,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          counterText: '',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (msgType == "text") {
                        if (textEditingController.text.isEmpty) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: const Text("Please type a message"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                      }

                      print("-=->>> ${widget.data['room_id']}");
                      if (widget.data['room_id'] == 0) {
                        //==========create chat room============
                        DateTime now = DateTime.now();
                        final DateFormat formatter = DateFormat('MM-dd-yyyy');
                        final String formattedDate = formatter.format(now);
                        final String changeTime =
                            DateFormat('HH:mm').format(DateTime.now());

                        var dataPost = {
                          "group_name": widget.data['group_name'].toString(),
                          "time": time.toString(),
                          "date": formattedDate.toString(),
                          "chat_type": "group",
                          "users": widget.data['userList'],
                          "sid": widget.data['sid'].toString(),
                          // "userTo": widget.data['userTo'].toString(),
                          // "userBy": widget.data['userBy'].toString(),
                          // "userToRole": widget.data['userToRole'].toString(),
                          // "userByRole": widget.data['userByRole'].toString(),
                          // "time": time.toString(),
                          // "date": formattedDate.toString(),
                          // "file": '',
                          // "message_type": 'text'
                        };

                        var createRoomDetails =
                            await Providers().createChatGroupRoom(dataPost);

                        print(createRoomDetails.data[0].roomId);

                        if (createRoomDetails.status == true) {
                          // print(
                          //     "-=-=-=createRoomDetails ${createRoomDetails.data}");

                          var dataPost = {
                            "message": textEditingController.text,
                            "room_id":
                                createRoomDetails.data[0].roomId.toString(),
                            "receiver_id":
                                widget.data['receiver_id'].toString(),
                            "sender_id": widget.data['sender_id'].toString(),
                            "sender_type":
                                widget.data['sender_type'].toString(),
                            "receiver_type":
                                widget.data['receiver_type'].toString(),
                            "time": time,
                            "date": date,
                            "file": '',
                            "message_type": 'text'
                          };
                          widget.data['room_id'] =
                              createRoomDetails.data[0].roomId.toString();
                          var sendMsgDetails =
                              await Providers().sendChatMessage(dataPost);
                          setState(() {
                            connectToServer();

                            textEditingController.clear();
                          });
                        }

                        //==========create chat room============
                      } else {
                        var dataPost = {
                          "message": textEditingController.text,
                          "room_id": widget.data['room_id'].toString(),
                          "receiver_id": widget.data['receiver_id'].toString(),
                          "sender_id": widget.data['sender_id'].toString(),
                          "sender_type": widget.data['sender_type'].toString(),
                          "receiver_type":
                              widget.data['receiver_type'].toString(),
                          "time": time,
                          "date": date,
                          "file": '',
                          "message_type": 'text'
                          // "message": textEditingController.text,
                          // "room_id": widget.data['room_id'].toString(),
                          // "receiver_id": widget.data['user_id'].toString(),
                          // "sender_id": UserId.toString(),
                          // "sender_type": widget.data['userByRole'].toString(),
                          // "receiver_type":
                          //     widget.data['userToRole'].toString(),
                          // "time": time,
                          // "date": date,
                          // "file": '',
                          // "message_type": 'text'
                        };

                        var sendMsgDetails =
                            await Providers().sendChatMessage(dataPost);
                        setState(() {
                          // print("-=-=-=sendMsgDetails ${sendMsgDetails.status}");
                          getChatHistory();
                          connectToServer();

                          textEditingController.clear();
                        });
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUsers {
  int userId;
  String userRole;

  ChatUsers(this.userId, this.userRole);

  ChatUsers.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userRole = json['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userRole': userRole,
    };
  }
}
