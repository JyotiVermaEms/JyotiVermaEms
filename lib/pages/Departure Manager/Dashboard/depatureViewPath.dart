import 'dart:convert';

import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/PickupAgent/pickupChangstatusmodel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Order.dart';
import 'package:shipment/component/Departure%20Manager/Select_Agent.dart';
import 'package:shipment/constants.dart';

import 'package:shipment/pages/Pickup%20Agent/Order/successfullyCustomAlertdialog.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class CustomDialogBox1 extends StatefulWidget {
  var data;
  CustomDialogBox1(this.data);
  @override
  _CustomDialogBox1 createState() => _CustomDialogBox1();
}

class _CustomDialogBox1 extends State<CustomDialogBox1> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  List<DepatureStatusData> changedata = [];
  Image? image;
  String getImage = '';

  String imagepath = '';
  var updatedNumber,
      updatedProfile,
      updatedName,
      updatedLastName,
      updatedEmail,
      updatedPhone,
      updatedCountry,
      updatedAddress,
      updatedAboutMe,
      updatedLName,
      updateLanguauge;
  var amount;
  var email, mobileNumber, languages, country, lname, username, aboutMe;
  Future getProfile() async {
    var response = await Providers().getpickupAgentProfile();
    // log("get profile data" + jsonEncode(response));
    if (response.status == true) {
      setState(() {
        aboutMe = response.data[0].about_me;
        name = response.data[0].name;
        lname = response.data[0].lname;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
        username = response.data[0].username;
      });

      // log("REPONSE" + jsonEncode(response.data));
    }

    // id =   response.user[universityList.indexOf(name)].id
  }

  Future updateProfileApi() async {
    var udpateData = {
      "name": updatedName == null ? "$name" : "$updatedName",
      "file": imagepath != '' ? "$imagepath" : "$profileImage",
      "lname": updatedLName == null ? "$lname" : "$updatedLName",
      "email": "$email",
      "phone": updatedNumber == null ? mobileNumber : updatedNumber,
      "country": updatedCountry == null ? "$country" : "$updatedCountry",
      "address": " ",
      "about_me": updatedAboutMe == null ? "$aboutMe" : "$updatedAboutMe",
      "language": updateLanguauge == null ? "$languages" : "$updateLanguauge"
    };
    var response = await Providers().updatepickupAgentProfile(udpateData);
    if (response.status == true) {
      setState(() {
        name = response.data[0].name;
        lname = response.data[0].lname;
        aboutMe = response.data[0].aboutMe;
        print("Name $name");
        email = response.data[0].email;
        mobileNumber = response.data[0].phone;
        languages = response.data[0].language;
        country = response.data[0].country;
        profileImage = response.data[0].profileimage;
      });

      // log("REPONSE" + jsonEncode(response.data));

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(response.message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                var id, pid, type, bookingdate, status;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => CustomDialogBox1(
                //             id, pid, type, bookingdate, status)));
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
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

    // id =   response.user[universityList.indexOf(name)].id
  }

  void chooseFileUsingFilePicker(BuildContext context) async {
    //-----pick file by file picker,

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

      getImage = result2;
      var temp3 = ImageModel.fromJson(json.decode(result2));
      print("--=---=-= $result2");
      // temp2!.add(temp3);
      print("object  ${json.encode(temp3)}");
      setState(() {
        imagepath = temp3.data[0].image;
        buttonstatus = "Update Status";
        onTap = 1;
        // updateProfileApi();
      });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imagepath");
      // itemList[index].imageList!.add(result2.toString());

      //-------Your response
      // print(result2);
      // });
    }
  }

  void _openCamera(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        chooseFileUsingFilePicker(context);
                        setState(() {});
                      },
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            const Icon(Icons.camera),
                            const SizedBox(width: 40),
                            const Text('Take a picture'),
                            const SizedBox(width: 50),
                            // InkWell(
                            //     onTap: () {
                            //       Navigator.pop(context);
                            //     },
                            //     child: const Icon(Icons.cancel)),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.data['bid'].toString(),
      "booking_status": "pickup item received",
      "schedule_status": "InProgress",
      "pickup_itemimage": jsonEncode(imagepath),
    };

    print(depatureData);
    //return;

    var response = await Providers().changeDepatureStatus(depatureData);
    if (response.status == true) {
      setState(() {
        changedata = response.data;
        // Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => profileConfirm(),
            ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateProfileApi();
    // getProfile();
    print(widget.data['bid']);
    print(widget.data['bdate']);
    print(widget.data['bdate']);
    print(widget.data['bdate']);
    print(widget.data['bdate']);
    print(widget.data['bdate']);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      height: 600,
      width: 900,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Order tracking" + "  " + widget.data['bid'],
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffE5E5E5),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 40, top: 20),
                        width: 100,
                        child: Text(
                          "Shipped VIA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 40, top: 20),
                        child: Text(
                          "Booking Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 40, top: 10),
                        child: Text(
                          widget.data['type'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 110,
                    // ),
                    Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          widget.data['type'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 40, top: 10),
                        child: Text(
                          widget.data['bdate'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(left: 20),
                      child: Image.asset('assets/images/Group 740.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     child: Text(
                    //       "Order Recieved",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.data['status'] == "Accepted"
                        ? Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          )
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.data['status'] == "Accepted" ||
                            widget.data['status'] == "assigned to agent"
                        ? Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          ),
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: EdgeInsets.only(right: 10),
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.data['status'] == "Accepted" ||
                            widget.data['status'] == "assigned to agent" ||
                            widget.data['status'] == "going to pickup"
                        ? Container(
                            height: 50,
                            width: 50,

                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          ),
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.data['status'] == "Accepted" ||
                            widget.data['status'] == "assigned to agent" ||
                            widget.data['status'] == "going to pickup" ||
                            widget.data['status'] == "pickup done"
                        ? Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/Group 742.png',
                                fit: BoxFit.fill),
                          ),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    widget.data['status'] == "Accepted" ||
                            widget.data['status'] == "assigned to agent" ||
                            widget.data['status'] == "going to pickup" ||
                            widget.data['status'] == "pickup done" ||
                            widget.data['status'] == "delivered to Warehouse"
                        ? Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 20),
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            child: Image.asset('assets/images/defaulticon.png',
                                fit: BoxFit.fill),
                          )
                        : Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 20),
                            child: Image.asset('assets/images/Group 743.png',
                                fit: BoxFit.fill),
                          ),
                    // Container(
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Text(
                    //       "Close",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Accepted",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Assign to Agent",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Going to Pickup",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Pickup Done",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      "Delivered to Depature Warehouse",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 5),
                    child: Text(
                      "Recevied & Proceed for Shipment",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          (widget.data['status'] == "Accepted" ||
                  widget.data['status'] == "assigned to agent" ||
                  widget.data['status'] == "going to pickup" ||
                  widget.data['status'] == "pickup done" ||
                  widget.data['status'] == "delivered to Warehouse")
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Stack(children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Material(
                          borderRadius: BorderRadius.circular(200),
                          elevation: 10,
                          child: imagepath == ''
                              ? Center(child: Icon(Icons.person))
                              : ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  child: Container(
                                      height: 90.0,
                                      width: 90.0,
                                      child: Image.network((imagepath),
                                          fit: BoxFit.cover)))),
                    ),
                    Positioned(
                      left: 50,
                      top: 5,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            imagepath = "";
                            onTap = 0;
                            print('removes $imagepath');
                          });
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ]),
                )
              : SizedBox(),
          (widget.data['status'] == "Accepted" ||
                  widget.data['status'] == "assigned to agent" ||
                  widget.data['status'] == "going to pickup" ||
                  widget.data['status'] == "pickup done" ||
                  widget.data['status'] == "delivered to Warehouse")
              ? Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.data['status'] != "Accepted") {
                            if (widget.data['status'] !=
                                "going to pickup") if (widget
                                    .data['status'] !=
                                "pickup done") if (widget
                                    .data['status'] ==
                                "delivered to Warehouse") if (onTap == 0) {
                              _openCamera(context);
                            } else {
                              doChangeStatus();
                            }
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectAgent(
                                      pid: widget.data[''],
                                      bid: widget.data['bid'])),
                            );

                            // doChangeStatus();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 15,
                            top: 15,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: widget.data['status'] == "Accepted"
                                  ? Color(0xff4CAF50)
                                  : widget.data['status'] == "going to pickup"
                                      ? Colors.grey
                                      : widget.data['status'] == "pickup done"
                                          ? Colors.grey
                                          : widget.data['status'] ==
                                                  "delivered to Warehouse"
                                              ? Color(0xff4CAF50)
                                              : Colors.grey),
                          height: 45,
                          width: (!Responsive.isDesktop(context))
                              ? MediaQuery.of(context).size.width * (30 / 100)
                              : MediaQuery.of(context).size.width * (15 / 100),
                          child: Center(
                              child: widget.data['status'] == "Accepted"
                                  ? Text("Assign To Agent",
                                      style: TextStyle(color: Colors.white))
                                  : widget.data['status'] == "going to pickup"
                                      ? Text("Update Status",
                                          style: TextStyle(color: Colors.black))
                                      : widget.data['status'] == "pickup done"
                                          ? Text("Update Status",
                                              style: TextStyle(
                                                  color: Colors.black))
                                          : widget.data['status'] ==
                                                  "delivered to Warehouse"
                                              ? Text("Update Status",
                                                  style: TextStyle(
                                                      color: Colors.white))
                                              : Text("Update Status",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: 25,
                            top: 15,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.black),
                          height: 45,
                          width: (!Responsive.isDesktop(context))
                              ? MediaQuery.of(context).size.width * (30 / 100)
                              : MediaQuery.of(context).size.width * (15 / 100),
                          child: Center(
                            child: Text("Close",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ))
              : SizedBox()
        ],
      ),
    );
  }

  Widget shipmentDelivery() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = _data(index + 1);
        return Center(
          child: Container(
            width: 360.0,
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _OrderTitle(
                      orderInfo: data,
                    ),
                  ),
                  Divider(height: 1.0),
                  _DeliveryProcesses(processes: data.deliveryProcesses),
                  Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _OnTimeBar(driver: data.driverInfo),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrderTitle extends StatelessWidget {
  const _OrderTitle({
    Key? key,
    required this.orderInfo,
  }) : super(key: key);

  final _OrderInfo orderInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Delivery #${orderInfo.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
          style: TextStyle(
            color: Color(0xffb6b2b2),
          ),
        ),
      ],
    );
  }
}

class _InnerTimeline extends StatelessWidget {
  const _InnerTimeline({
    required this.messages,
  });

  final List<_DeliveryMessage> messages;

  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == messages.length + 1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
                thickness: 1.0,
              ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
                size: 10.0,
                position: 0.5,
              ),
        ),
        builder: TimelineTileBuilder(
          indicatorBuilder: (_, index) =>
              !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
          startConnectorBuilder: (_, index) => Connector.solidLine(),
          endConnectorBuilder: (_, index) => Connector.solidLine(),
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(messages[index - 1].toString()),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
          nodeItemOverlapBuilder: (_, index) =>
              isEdgeIndex(index) ? true : null,
          itemCount: messages.length + 2,
        ),
      ),
    );
  }
}

class _DeliveryProcesses extends StatelessWidget {
  const _DeliveryProcesses({Key? key, required this.processes})
      : super(key: key);

  final List<_DeliveryProcess> processes;
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: Color(0xff9b9b9b),
        fontSize: 12.5,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: Color(0xff989898),
            indicatorTheme: IndicatorThemeData(
              position: 0,
              size: 20.0,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: processes.length,
            contentsBuilder: (_, index) {
              if (processes[index].isCompleted) return null;

              return Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      processes[index].name,
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18.0,
                          ),
                    ),
                    _InnerTimeline(messages: processes[index].messages),
                  ],
                ),
              );
            },
            indicatorBuilder: (_, index) {
              if (processes[index].isCompleted) {
                return DotIndicator(
                  color: Color(0xff66c97f),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 12.0,
                  ),
                );
              } else {
                return OutlinedDotIndicator(
                  borderWidth: 2.5,
                );
              }
            },
            connectorBuilder: (_, index, ___) => SolidLineConnector(
              color: processes[index].isCompleted ? Color(0xff66c97f) : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _OnTimeBar extends StatelessWidget {
  const _OnTimeBar({Key? key, required this.driver}) : super(key: key);

  final _DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('On-time!'),
              ),
            );
          },
          elevation: 0,
          shape: StadiumBorder(),
          color: Color(0xff66c97f),
          textColor: Colors.white,
          child: Text('On-time'),
        ),
        Spacer(),
        Text(
          'Driver\n${driver.name}',
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 12.0),
        Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: NetworkImage(
                driver.thumbnailUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_OrderInfo _data(int id) => _OrderInfo(
      id: id,
      date: DateTime.now(),
      driverInfo: _DriverInfo(
        name: 'Philipe',
        thumbnailUrl:
            'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
      ),
      deliveryProcesses: [
        _DeliveryProcess(
          'Package Process',
          messages: [
            _DeliveryMessage('8:30am', 'Package received by driver'),
            _DeliveryMessage('11:30am', 'Reached halfway mark'),
          ],
        ),
        _DeliveryProcess(
          'In Transit',
          messages: [
            _DeliveryMessage('13:00pm', 'Driver arrived at destination'),
            _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
          ],
        ),
        _DeliveryProcess.complete(),
      ],
    );

class _OrderInfo {
  const _OrderInfo({
    required this.id,
    required this.date,
    required this.driverInfo,
    required this.deliveryProcesses,
  });

  final int id;
  final DateTime date;
  final _DriverInfo driverInfo;
  final List<_DeliveryProcess> deliveryProcesses;
}

class _DriverInfo {
  const _DriverInfo({
    required this.name,
    required this.thumbnailUrl,
  });

  final String name;
  final String thumbnailUrl;
}

class _DeliveryProcess {
  const _DeliveryProcess(
    this.name, {
    this.messages = const [],
  });

  const _DeliveryProcess.complete()
      : this.name = 'Done',
        this.messages = const [];

  final String name;
  final List<_DeliveryMessage> messages;

  bool get isCompleted => name == 'Done';
}

class _DeliveryMessage {
  const _DeliveryMessage(this.createdAt, this.message);

  final String createdAt; // final DateTime createdAt;
  final String message;

  @override
  String toString() {
    return '$createdAt $message';
  }
}

class PriceSumaryDialog extends StatefulWidget {
  const PriceSumaryDialog({Key? key}) : super(key: key);

  @override
  _PriceSumaryDialogState createState() => _PriceSumaryDialogState();
}

class _PriceSumaryDialogState extends State<PriceSumaryDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: summaryBox(context),
    );
  }

  summaryBox(context) {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      height: MediaQuery.of(context).size.height * (80 / 100),
      // height: 100,
      width: (Responsive.isDesktop(context))
          ? MediaQuery.of(context).size.width * (38 / 100)
          : MediaQuery.of(context).size.width * (90 / 100),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Price summary",
                  style: TextStyle(fontSize: 20),
                )),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Item 1",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "BMW Cars",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "QTY",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "3",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Car Price",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "210.00",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Item 2",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  "Boxes",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "QTY",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "4",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Box Price",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "210.00",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Pick Up fee",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "17",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Shiping Fee",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "250",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Price",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "687",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15, right: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Amet minim mollit non deserunt ullamco.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Discount",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "-40.00",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 15, right: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Amet minim mollit non deserunt ullamco.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Tax",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 15,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "20.00",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 30,
              color: Colors.black,
              thickness: 2,
            ),
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, right: 10, left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Total Amount",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    )),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(
                  top: 10,
                  right: 30,
                ),
                child: Align(
                    child: Text(
                  String.fromCharCodes(new Runes('\u0024')) + "667.00",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDialogBox2 extends StatefulWidget {
  @override
  _CustomDialogBox2State createState() => _CustomDialogBox2State();
}

class _CustomDialogBox2State extends State<CustomDialogBox2> {
  List image = [];

  _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      image.add(_image);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      height: 400,
      width: 900,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Order tracking - #123456",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 80,
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffE5E5E5),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 15, top: 20),
                        width: 100,
                        child: Text(
                          "Shipped VIA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // Spacer(),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 0, top: 20),
                        child: Text(
                          "Expected",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "UPS",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 110,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "In Transit",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    // SizedBox(
                    //   width: 70,
                    // ),
                    Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 0, top: 10),
                        child: Text(
                          "Friday, Oct 25",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(left: 10),
                      child: Image.asset('assets/images/Group 740.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     child: Text(
                    //       "Order Recieved",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset('assets/images/Group 742.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset('assets/images/Group 742.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      // margin: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset('assets/images/Group 742.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     // margin: EdgeInsets.only(right: 30),
                    //     child: Text(
                    //   "Delivered to warehouse",
                    //   style: TextStyle(fontWeight: FontWeight.bold),
                    // )),
                  ],
                ),
                Expanded(
                  child: Container(
                      // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                    color: Color(0xff4CAF50),
                    height: 36,
                  )),
                ),
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset('assets/images/Group 743.png',
                          fit: BoxFit.fill),
                    ),
                    // Container(
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Text(
                    //       "Close",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "Order Recieved",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Spacer(),
                Container(
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                  "Asign to agent",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Spacer(),
                Container(
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                  "Pick-up done",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Spacer(),
                Container(
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                  "Delivered to warehouse",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Spacer(),
                Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      "Close",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _openCamera(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 15,
                        top: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xff4CAF50)),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                        child: Text("Image Upload",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 25,
                        top: 15,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.black),
                      height: 45,
                      width: (!Responsive.isDesktop(context))
                          ? MediaQuery.of(context).size.width * (30 / 100)
                          : MediaQuery.of(context).size.width * (15 / 100),
                      child: Center(
                        child: Text("Close",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget shipmentDelivery() {
    return ListView.builder(
      itemBuilder: (context, index) {
        final data = _data(index + 1);
        return Center(
          child: Container(
            width: 360.0,
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _OrderTitle(
                      orderInfo: data,
                    ),
                  ),
                  Divider(height: 1.0),
                  _DeliveryProcesses(processes: data.deliveryProcesses),
                  Divider(height: 1.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _OnTimeBar(driver: data.driverInfo),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompanyAlertDialog extends StatefulWidget {
  const CompanyAlertDialog({Key? key}) : super(key: key);

  @override
  _CompanyAlertDialogState createState() => _CompanyAlertDialogState();
}

class _CompanyAlertDialogState extends State<CompanyAlertDialog> {
  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
        height: 400,
        width: 900,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(children: [
                  Text(
                    "COSCO – China Ocean Shipping Company",
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(
                  //   width: 400,
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 370),
                        child: Icon(
                          Icons.close,
                          color: Color(0xffC4C4C4),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                margin: EdgeInsets.only(left: 24, top: 15, right: 10),
                height: h * 0.15,
                width: w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                          ),
                          height: 15,
                          width: 15,
                          child: ImageIcon(
                            AssetImage(
                              'assets/images/rightdropdown.png',
                            ),
                            size: 10,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("MSC – Mediterranean Shipping Company",
                                style: headingStyleNormal())),
                        // Container(
                        //   margin:
                        //       EdgeInsets.only(left: 15),
                        //   height: 50,
                        //   width: 50,
                        //   child: Image.asset(
                        //     'assets/images/ratings.png',
                        //   ),
                        // ),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Departure date:",
                                style: headingStyleNormal())),
                        Container(
                            margin:
                                EdgeInsets.only(right: 15, top: 10, left: 5),
                            child: Text("21.08.2021")),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 45, top: 10),
                            child: Text("Total Container: ",
                                style: headingStyleNormal())),
                        Container(
                            margin: EdgeInsets.only(left: 5, top: 10),
                            child: Text("10")),
                        Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Text("available Container:: ",
                                style: headingStyleNormal())),
                        Container(
                            margin: EdgeInsets.only(left: 5, top: 10),
                            child: Text("4")),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Departure to:",
                                style: headingStyleNormal())),
                        Container(
                            margin:
                                EdgeInsets.only(right: 15, top: 10, left: 5),
                            child: Text("india")),
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Goods info",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // _openCamera(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          top: 15,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(0xff4CAF50)),
                        height: 45,
                        width: (!Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (30 / 100)
                            : MediaQuery.of(context).size.width * (15 / 100),
                        child: Center(
                          child: Text("Approve",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 25,
                          top: 15,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.black),
                        height: 45,
                        width: (!Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (30 / 100)
                            : MediaQuery.of(context).size.width * (15 / 100),
                        child: Center(
                          child: Text("Reject",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}

class paymentReview extends StatefulWidget {
  const paymentReview({Key? key}) : super(key: key);

  @override
  _paymentReviewState createState() => _paymentReviewState();
}

class _paymentReviewState extends State<paymentReview> {
  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
        height: 600,
        width: 900,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    child: Column(
                  children: [],
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "COSCO – China Ocean Shipping Company",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xffFFFFFF),
                ),
                margin: EdgeInsets.only(left: 24, top: 15, right: 10),
                height: h * 0.15,
                width: w,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 15,
                          ),
                          height: 15,
                          width: 15,
                          child: ImageIcon(
                            AssetImage(
                              'assets/images/rightdropdown.png',
                            ),
                            size: 10,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 15),
                            child: Text("MSC – Mediterranean Shipping Company",
                                style: headingStyleNormal())),
                        // Container(
                        //   margin:
                        //       EdgeInsets.only(left: 15),
                        //   height: 50,
                        //   width: 50,
                        //   child: Image.asset(
                        //     'assets/images/ratings.png',
                        //   ),
                        // ),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Departure date:",
                                style: headingStyleNormal())),
                        Container(
                            margin:
                                EdgeInsets.only(right: 15, top: 10, left: 5),
                            child: Text("21.08.2021")),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 45, top: 10),
                            child: Text("Total Container: ",
                                style: headingStyleNormal())),
                        Container(
                            margin: EdgeInsets.only(left: 5, top: 10),
                            child: Text("10")),
                        Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Text("available Container:: ",
                                style: headingStyleNormal())),
                        Container(
                            margin: EdgeInsets.only(left: 5, top: 10),
                            child: Text("4")),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(left: 15, top: 10),
                            child: Text("Departure to:",
                                style: headingStyleNormal())),
                        Container(
                            margin:
                                EdgeInsets.only(right: 15, top: 10, left: 5),
                            child: Text("india")),
                      ],
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Goods info",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // _openCamera(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          top: 15,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(0xff4CAF50)),
                        height: 45,
                        width: (!Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (30 / 100)
                            : MediaQuery.of(context).size.width * (15 / 100),
                        child: Center(
                          child: Text("Approve",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 25,
                          top: 15,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.black),
                        height: 45,
                        width: (!Responsive.isDesktop(context))
                            ? MediaQuery.of(context).size.width * (30 / 100)
                            : MediaQuery.of(context).size.width * (15 / 100),
                        child: Center(
                          child: Text("Reject",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}

class BackendService {
  static Future<List<Map<String, String>>> getSuggestions(String query) async {
    await Future<void>.delayed(Duration(seconds: 1));

    return List.generate(3, (index) {
      return {
        'name': query + index.toString(),
        // 'price': Random().nextInt(100).toString()
      };
    });
  }
}

class profileConfirm extends StatefulWidget {
  const profileConfirm({Key? key}) : super(key: key);

  @override
  _profileConfirmtate createState() => _profileConfirmtate();
}

class _profileConfirmtate extends State<profileConfirm>
    with TickerProviderStateMixin {
  // GifController? controller1;

  // @override
  // void initState() {
  //   controller1 = GifController(vsync: this);
  //   super.initState();
  // }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox2(context),
    );
  }

  contentBox2(context) {
    return Container(
        height: 500,
        width: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: Column(
          children: [
            Container(
                child: Image.asset(
                  "assets/images/success.gif",
                ),
                height: MediaQuery.of(context).size.height * (20 / 100),
                width: MediaQuery.of(context).size.width * (20 / 100)),
            Center(
              child: Text(
                "Status has been Updated Successfully",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey.shade700,
                    fontSize: 30),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                        "Status has been Changed , Now You Can Proceed For Next Step"))),
            // Center(
            //     child: Align(
            //         alignment: Alignment.center,
            //         child:
            //             Text("Ask Shishank to Reset password before login"))),
            SizedBox(
              height: MediaQuery.of(context).size.height * (5 / 100),
            ),
            GestureDetector(
              onTap: () async {
                // Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Orders()));
              },
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xff1A494F)),
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.4,
                  // color: Colors.lime,
                  child: Center(
                      child: Text(
                    "Close",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ))),
            ),
          ],
        ));
  }
}

class userManagement2 extends StatefulWidget {
  var data;

  userManagement2(this.data);

  @override
  _userManagement2tstate createState() => _userManagement2tstate();
}

class _userManagement2tstate extends State<userManagement2>
    with TickerProviderStateMixin {
  // GifController? controller1;

  // @override
  // void initState() {
  //   controller1 = GifController(vsync: this);
  //   super.initState();
  // }
  var name;

  var h, w;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      name = widget.data['name'].toString();
      print('>>>>>   $name');
    });
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Dialog(
      child: contentBox3(context),
    );
  }

  contentBox3(context) {
    return Container(
      height: h,
      width: w * 0.40,
      child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffFFFFFF).withOpacity(0.6),
                Color(0xffF3F3F3).withOpacity(0.36),
              ],
            ),
            // color: Colors.red,
          ),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Icon(
                      Icons.close,
                      color: Color(0xffC4C4C4),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    margin: EdgeInsets.only(top: 12, left: 5),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(200),
                      elevation: 10,
                      child: Stack(
                        children: [
                          widget.data['profileImage'].toString() == ''
                              ? Center(child: Icon(Icons.person))
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image.network(
                                          (widget.data['profileImage']
                                              .toString()),
                                          fit: BoxFit.cover)))

                          // Positioned(
                          //   bottom: 4,
                          //   right: 0,
                          //   child: Container(
                          //     decoration: new BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Color(0xff43A047)),
                          //     child: InkWell(
                          //         onTap: () {
                          //           _showPicker(context);
                          //         },
                          //         child: Icon(Icons.add,
                          //             color: Colors.black)),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 10),
                            child: Text(widget.data['name'].toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10, left: 10),
                            child: Text(widget.data['email'].toString(),
                                style: TextStyle(
                                  color: Color(0xff90A0B7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 5.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2,
                    height: 36,
                  )),
              Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                width: 500,
                child: TextFormField(
                  initialValue:
                      widget.data['name'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "First Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                width: 500,
                child: TextFormField(
                  initialValue:
                      widget.data['lname'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "Last Name",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              Container(
                width: 500,
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                child: TextFormField(
                  initialValue:
                      widget.data['email'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                width: 500,
                child: TextFormField(
                  initialValue:
                      widget.data['phone'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                width: 500,
                child: TextFormField(
                  initialValue:
                      widget.data['country'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "Country",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              Container(
                width: 500,
                margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                child: TextFormField(
                  initialValue:
                      widget.data['address'].toString(), // autofocus: false,
                  // maxLines: 3,
                  onChanged: (v) {},
                  style: TextStyle(color: Colors.black54, fontSize: 17),
                  decoration: InputDecoration(
                      fillColor: Color(0xffF5F6FA),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        // borderRadius: new BorderRadius.circular(25.0),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide:
                            BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                      ),
                      // border: InputBorder.none,
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => profileConfirm());
                },
                child: Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xff1F2326)),
                    margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Center(
                      child: Text(
                        "Deactivate account",
                        style: TextStyle(
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          )),
    );
  }
}

// class _ViewPath extends State<ViewPath> {
//   var imageList = [];
//   @override
//   void initState() {
//     super.initState();
//     // print("ioioioioioioi${widget.data['itemimage1']}");
//     for (int i = 0; i < widget.data['itemimage1'].length; i++) {
//       //   imageList.add(widget.data['itemimage1'][i].toString());
//       print(widget.data['itemimage1'][i].length);
//       //   // for (int i = 0; i < widget.data['itemimage1'].length; i++) {
//       //   //   print("in loop");
//       //   //   print(widget.data['itemimage1'][i].booking);
//       //   //   for (int i1 = 0; i1 < widget.data['itemimage1'][i].booking.length; i1++) {
//       //   //     print("in loop 2");
//       //   //     print(widget.data['itemimage1'][i].booking[i1]);
//       //   //     for (int i2 = 0;
//       //   //         i2 < widget.data['itemimage1'][i].booking[i1].itemImage.length;
//       //   //         i2++) {
//       //   //       imageList.add(widget.data['itemimage1'][i].booking[i1].itemImage[i2]);
//       //   //     }
//       //   //   }
//       //   print(":imageList");
//       //   print(imageList);
//       //   // }
//     }
//   }
var h, w;
@override
Widget build(BuildContext context) {
  h = MediaQuery.of(context).size.height;
  w = MediaQuery.of(context).size.width;
  var _currentIndex = 0;
  return Container(
    margin: EdgeInsets.fromLTRB(5, 0, 5, 30),
    child: Column(children: [
      // orderTemplate(),
      // orderDetails(),
      Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Divider(
          height: 30,
          color: Colors.black,
          thickness: 2,
        ),
      ),
      Expanded(
        child: Container(
            // margin: EdgeInsets.only(top: 10, bottom: 10),
            width: w * 0.75,
            height: h * 0.48,
            // color: Color(0xffE5E5E5),
            // decoration: BoxDecoration(
            //     border: Border.all(width: 0.5, color: Colors.black),
            //     borderRadius: BorderRadius.circular(10.0),
            //     color: Colors.white),
            child: ListView.builder(
                itemCount: 1,
                reverse: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child:
                                      //  widget.data['itemimage1'][index]
                                      //             .itemImage.length ==
                                      //         0
                                      //     ? CarouselSlider(
                                      //         options: CarouselOptions(
                                      //           enableInfiniteScroll: false,
                                      //           autoPlay: true,
                                      //           onPageChanged: (index, reason) {
                                      //             setState(() {
                                      //               _currentIndex = index;
                                      //             });
                                      //             //print(_currentIndex);
                                      //           },
                                      //         ),
                                      //         items: widget
                                      //             .data['itemimage1'][index]
                                      //             .itemImage
                                      //             .map<Widget>((item) => InkWell(
                                      //                   onTap: () {
                                      //                     showDialog(
                                      //                       context: context,
                                      //                       builder: (BuildContext
                                      //                           context) {
                                      //                         return imageViewDialog(
                                      //                             context, item);
                                      //                       },
                                      //                     );
                                      //                   },
                                      //                   child: Image.network(
                                      //                     item,
                                      //                     fit: BoxFit.cover,
                                      //                   ),
                                      //                 ))
                                      //             .toList(),
                                      //       )
                                      Center(
                                          child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "No Image Available",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  height: 150,
                                  width: 150,
                                ),
                                // Container(
                                //     height: 100,
                                //     width: 150,
                                //     child: Image.asset(
                                //       "assets/images/BMW.png",
                                //       fit: BoxFit.cover,
                                //     )
                                //     // CircleAvatar(
                                //     //   backgroundColor: Colors.transparent,
                                //     //   backgroundImage: AssetImage(
                                //     //       "assets/images/Ellipse7.png"),
                                //     // ),
                                //     ),
                                SizedBox(width: kDefaultPadding / 2),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        // style: Theme.of(context)
                                        //     .textTheme
                                        //     .caption!
                                        //     .copyWith(
                                        //       color: Colors.black,
                                        //     ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 5),
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        // style: Theme.of(context)
                                        //     .textTheme
                                        //     .caption!
                                        //     .copyWith(
                                        //       color: Colors.black,
                                        //     ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 5),
                                      child: Container(
                                        height: 50,
                                        width: 800,
                                        child: Text("",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)
                                            // style: Theme.of(context)
                                            //     .textTheme
                                            //     .caption!
                                            //     .copyWith(
                                            //       color: Colors.black,
                                            //     ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Text.rich(
                                //   TextSpan(
                                //     text: "jsdkjksjf",
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w500,
                                //       color: kTextColor,
                                //     ),

                                //   ),
                                // ),
                                Spacer(),
                                Column(
                                  children: [
                                    // Text(
                                    //   notificationData[index]
                                    //       .createdAt
                                    //       .substring(0, 10),
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .caption!
                                    //       .copyWith(
                                    //         color: Colors.black,
                                    //       ),
                                    // ),
                                    // Text(
                                    //   notificationData[index]
                                    //       .createdAt
                                    //       .substring(11, 19),
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .caption!
                                    //       .copyWith(
                                    //         color: Colors.black,
                                    //       ),
                                    // ),
                                    // Text(
                                    //   notificationData[index]
                                    //       .createdAt
                                    //       .substring(0, 10),
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .caption!
                                    //       .copyWith(
                                    //         color: Colors.black,
                                    //       ),
                                    // ),
                                    // SizedBox(height: 5),
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
                      ),
                    ),
                  );
                })),
      ),
      // SingleChildScrollView(
      //   child: Row(
      //     children: [
      //       Column(children: [
      //         Padding(
      //           padding: const EdgeInsets.only(left: 20),
      //           child: Container(
      //             child: imageList.isNotEmpty
      //                 ? CarouselSlider(
      //                     options: CarouselOptions(
      //                       enableInfiniteScroll: false,
      //                       autoPlay: true,
      //                       onPageChanged: (index, reason) {
      //                         setState(() {
      //                           _currentIndex = index;
      //                         });
      //                         //print(_currentIndex);
      //                       },
      //                     ),
      //                     items: imageList
      //                         .map((item) => InkWell(
      //                               onTap: () {
      //                                 showDialog(
      //                                   context: context,
      //                                   builder: (BuildContext context) {
      //                                     return imageViewDialog(
      //                                         context, item);
      //                                   },
      //                                 );
      //                               },
      //                               child: Image.network(
      //                                 item,
      //                                 fit: BoxFit.cover,
      //                               ),
      //                             ))
      //                         .toList(),
      //                   )
      //                 : Center(
      //                     child: Text(
      //                     "No Image Available",
      //                     style: TextStyle(
      //                         color: Colors.black,
      //                         fontSize: 16,
      //                         fontWeight: FontWeight.bold),
      //                   )),
      //             decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.circular(15)),
      //             height: 350,
      //             width: 500,
      //           ),
      //         ),
      //         // Row(children: [
      //         //   Padding(
      //         //     padding: const EdgeInsets.only(top: 20),
      //         //     child: Container(
      //         //       width: 120,
      //         //       child: Text(
      //         //         "Total Amount",
      //         //         style: TextStyle(color: Colors.black),
      //         //       ),
      //         //     ),
      //         //   ),
      //         //   Padding(
      //         //     padding: const EdgeInsets.only(
      //         //       top: 10,
      //         //     ),
      //         //     child: Container(
      //         //       height: 50,
      //         //       width: 200,
      //         //       decoration: BoxDecoration(
      //         //           color: Colors.white,
      //         //           borderRadius: BorderRadius.circular(15)),
      //         //       child: Center(
      //         //         child: Text(
      //         //           widget.data['totalamount'].toString(),
      //         //           style: TextStyle(color: Colors.black),
      //         //         ),
      //         //       ),
      //         //     ),
      //         //   ),
      //         // ]),
      //       ]),
      //       SizedBox(
      //         width: 40,
      //       ),
      //       Container(
      //           child: Container(
      //         // height: 350,
      //         child: Column(
      //           children: [
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Order Type",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickuptype'],
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Pickup Location",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickuplocation'],
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Pickup Date",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickupdate'].toString(),
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Pickup Time",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickuptime'].toString(),
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Pickup Distance",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickupdistance'].toString(),
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Pickup Estimate",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['pickupestimate'].toString(),
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //             // Row(
      //             //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             //     children: [
      //             //       Padding(
      //             //         padding: const EdgeInsets.only(top: 10),
      //             //         child: Container(
      //             //           width: 120,
      //             //           child: Text(
      //             //             "Transaction Id",
      //             //             style: TextStyle(color: Colors.black),
      //             //           ),
      //             //         ),
      //             //       ),
      //             //       Padding(
      //             //         padding: const EdgeInsets.only(
      //             //           top: 10,
      //             //         ),
      //             //         child: Container(
      //             //           height: 40,
      //             //           width: 120,
      //             //           decoration: BoxDecoration(
      //             //               color: Colors.white,
      //             //               borderRadius: BorderRadius.circular(15)),
      //             //           child: Center(
      //             //             child: Text(
      //             //               widget.data['transactionid'].toString(),
      //             //               style: TextStyle(color: Colors.black),
      //             //             ),
      //             //           ),
      //             //         ),
      //             //       ),
      //             //       Padding(
      //             //         padding: const EdgeInsets.only(top: 10, left: 10),
      //             //         child: Container(
      //             //           width: 120,
      //             //           child: Text(
      //             //             "Total Amount",
      //             //             style: TextStyle(color: Colors.black),
      //             //           ),
      //             //         ),
      //             //       ),
      //             //       Padding(
      //             //         padding: const EdgeInsets.only(
      //             //           top: 10,
      //             //         ),
      //             //         child: Container(
      //             //           height: 40,
      //             //           width: 120,
      //             //           decoration: BoxDecoration(
      //             //               color: Colors.white,
      //             //               borderRadius: BorderRadius.circular(15)),
      //             //           child: Center(
      //             //             child: Text(
      //             //               widget.data['totalamount'].toString(),
      //             //               style: TextStyle(color: Colors.black),
      //             //             ),
      //             //           ),
      //             //         ),
      //             //       ),
      //             //     ]),
      //             Row(children: [
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10),
      //                 child: Container(
      //                   width: 120,
      //                   child: Text(
      //                     "Transaction Id",
      //                     style: TextStyle(color: Colors.black),
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                   top: 10,
      //                 ),
      //                 child: Container(
      //                   height: 50,
      //                   width: 400,
      //                   decoration: BoxDecoration(
      //                       color: Colors.white,
      //                       borderRadius: BorderRadius.circular(15)),
      //                   child: Center(
      //                     child: Text(
      //                       widget.data['transactionid'].toString(),
      //                       style: TextStyle(color: Colors.black),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //             ]),
      //           ],
      //         ),
      //       ))
      //     ],
      //   ),
      // )
    ]),
  );
}

 

//   Widget orderDetails() {
//     return ListView.builder(
//         itemCount: 1,
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return Container(
//             // height: (!Responsive.isDesktop(context))
//             //     ? MediaQuery.of(context).size.height * (10 / 100)
//             //     : MediaQuery.of(context).size.height * (45 / 100),
//             height: 80,
//             width: MediaQuery.of(context).size.width * (98 / 100),
//             margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
//             decoration: BoxDecoration(
//               // borderRadius: BorderRadius.circular(10.0),
//               color: Color(0xffFFFFFF).withOpacity(0.5),
//             ),

//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                     width: 80,
//                     margin: EdgeInsets.only(left: 20),
//                     child: Text(
//                       widget.data['bid'].toString(),
//                       //{widget.data['id']}.toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),

//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(top: 10),
//                     child: Text(
//                       widget.data['bdate'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(top: 5),
//                     child: Text(
//                       widget.data['depaturedate'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),
//                 Container(
//                     width: 100,
//                     margin: EdgeInsets.only(top: 5),
//                     child: Text(
//                       widget.data['arrivaldate'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),

//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(left: 20),
//                     child: Text(
//                       widget.data['title'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),

//                 Container(
//                     width: 100,
//                     // margin: EdgeInsets.only(right: 20),
//                     child: Text(
//                       widget.data['type'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),

//                 Container(
//                     width: 120,
//                     margin: EdgeInsets.only(right: 15),
//                     child: Text(
//                       widget.data['company'].toString(),
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                     )),

//                 // Container(
//                 //     width: 80,
//                 //     // margin: EdgeInsets.only(right: 30),
//                 //     child: Text(
//                 //       "",
//                 //       style:
//                 //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                 //     )),
//                 // Spacer(),
//                 // Container(
//                 //     margin: EdgeInsets.only(left: 30),
//                 //     child: Text(
//                 //       "CMA CGM",
//                 //       // style: TextStyle(fontWeight: FontWeight.bold),
//                 //     )),

//                 // Container(
//                 //     width: 100,
//                 //     margin: EdgeInsets.only(right: 20),
//                 //     child: Text(
//                 //       "",
//                 //       style:
//                 //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                 //     )),
//                 Container(
//                     margin: EdgeInsets.only(right: 5),
//                     height: MediaQuery.of(context).size.height * (5 / 100),
//                     width: w * 0.09,
//                     decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.all(Radius.circular(20))),
//                     // width:
//                     child: Center(
//                       child: Text(
//                         "View Path",
//                         style: TextStyle(fontSize: 14, color: Colors.white),
//                       ),
//                     )),
//               ],
//             ),
//           );
//         });
//   }
 
