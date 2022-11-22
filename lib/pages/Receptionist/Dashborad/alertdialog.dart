import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/Res_Setting.dart';
import 'package:shipment/component/Res_Receptionist/Res_dashboard.dart';
import 'package:shipment/component/Res_Shipment.dart/ResSchedulShipment.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Shipment_Settings.dart';
import 'package:shipment/helper/routes.dart';
import 'package:shipment/pages/Client/Settings/Profile_Settings.dart';
import 'package:shipment/pages/Client/Settings/Settings.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class CustomDialogBox extends StatefulWidget {
  CustomDialogBox();
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = 'Image Upload';
  var onTap = 0;

  Image? image;
  var resId;

  String imagepath = '';

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

      print(result2);
      var temp3 = ImageModel.fromJson(json.decode(result2));

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

  deactivatedReceptionistFunction() async {
    var receptionistId = {"receptionist_id": resId, "status": 0};

    var response = await Providers().userDeactivated(receptionistId);
  }

  void _openCamera(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    Container(child: image != null ? image : null),
                    Row(
                      children: <Widget>[
                        InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              chooseFileUsingFilePicker(context);
                              setState(() {});
                            },
                            child: const Icon(Icons.camera)),
                        const SizedBox(width: 5),
                        const Text('Take a picture'),
                        const SizedBox(width: 50),
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.cancel)),
                      ],
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
    var pickupData = {
      "booking_id": "3",
      "booking_status": "received at Warehouse",
      "schedule_status": "",
    };

    var login = await Providers().changePickupStatus(pickupData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doChangeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      height: 560,
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
          SizedBox(
            height: 25,
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
            padding: const EdgeInsets.only(top: 20),
            child: Container(
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
                      // : imagepath != ''
                      //     ? ClipRRect(
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(100)),
                      //         child: Container(
                      //             height: 100,
                      //             width: 100,
                      //             child: Image.network((imagepath),
                      //                 fit: BoxFit.cover)))
                      // : ClipRRect(
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(100)),
                      //     child: Container(
                      //         height: 90,
                      //         width: 90,

                      //         // color: Colors.red,
                      //         child: Image.network(profileImage,
                      //             fit: BoxFit.cover))

                      // image == ""
                      //     ? Image.network(profileImage,
                      //         fit: BoxFit.cover)
                      //     : Container()),
                      : ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100)),
                          child: Container(
                              height: 90.0,
                              width: 90.0,
                              child: Image.network((imagepath),
                                  fit: BoxFit.cover)))),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (onTap == 0) {
                        _openCamera(context);
                      } else {
                        print("Api Calliing.........");
                      }
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
                        child: Text(buttonstatus,
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
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Container(
        height: (Responsive.isDesktop(context)) ? 500 : h * 0.5,
        width: (Responsive.isDesktop(context)) ? 700 : w * 1.0,
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
                child: (Responsive.isDesktop(context))
                    ? Text(
                        "Status has been Updated Successfully",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                            fontSize: 30),
                      )
                    : Text(
                        "Status has been Updated Successfully",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade700,
                            fontSize: 12),
                      )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Align(
                    alignment: Alignment.center,
                    child: (Responsive.isDesktop(context))
                        ? Text(
                            "Status has been Changed , Now You Can Proceed For Next Step")
                        : Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              "Status has been Changed , Now You Can Proceed For Next Step",
                              style: TextStyle(fontSize: 12),
                            ),
                          ))),
            SizedBox(
              height: MediaQuery.of(context).size.height * (5 / 100),
            ),
            GestureDetector(
              onTap: () async {
                // Navigator.of(context).pop();
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // var getLocalToken = prefs.get('auth_token');
                // if (getLocalToken != null) {
                //   Navigator.pushNamed(context, Routes.CLIENTSETTINGROUTE);
                // } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PreReceptionistDashboard()));

                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (BuildContext context) => userManagement2(data)));
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
  var onTap = 0;
  var buttonstatus = '';
  // GifController? controller1;

  // @override
  // void initState() {
  //   controller1 = GifController(vsync: this);
  //   super.initState();
  // }
  var name;
  var resId;

  var h, w;
  @override
  void initState() {
    super.initState();

    name = widget.data['name'].toString();
    resId = widget.data['id'].toString();
    buttonstatus = widget.data['status'].toString();
    print('>>>>>   ${widget.data['status']}');
    print("-=-=-=>>> ${widget.data['profileImage']}");
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
    late StateSetter _setState;
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
                    padding: EdgeInsets.only(left: 30, top: 20, right: 20),
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
                    decoration: BoxDecoration(
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
                  Container(
                    margin: EdgeInsets.only(top: 20, right: 20),
                    child: Text(buttonstatus == '' ? 'Active' : 'Deactive',
                        style: TextStyle(
                          color: buttonstatus == '' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
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
                onTap: () async {
                  print("buttonstatus $buttonstatus");
                  print("resId $resId");
                  Navigator.pop(context);
                  //return;
                  var dialogText =
                      buttonstatus == "" ? "Deactivate" : "Activate";
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        StatefulBuilder(builder: (context, setState) {
                      _setState = setState;
                      return AlertDialog(
                        content: Text('Are you sure want to $dialogText'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // Navigator.pop(context);
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var localToken = prefs.get('Shipemnt_auth_token');
                              if (localToken != null) {
                                if (buttonstatus == "") {
                                  var receptionistId = {
                                    "employee_id": resId.toString(),
                                    "status": "0"
                                  };

                                  print("employee_id $receptionistId");

                                  var response = await Providers()
                                      .employeeDeactivated(receptionistId);
                                  if (response.status == true) {
                                    Navigator.pop(context);
                                    _setState(() {
                                      onTap = 1;
                                      buttonstatus = "Deactivate";
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            profileConfirm());
                                  }

                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) => profileConfirm());
                                } else {
                                  var receptionistId = {
                                    "employee_id": resId.toString(),
                                    "status": "1"
                                  };
                                  print("employee_id $receptionistId");
                                  var response = await Providers()
                                      .employeeDeactivated(receptionistId);
                                  if (response.status == true) {
                                    Navigator.pop(context);
                                    _setState(() {
                                      onTap = 0;
                                      buttonstatus = "Activate";
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            profileConfirm());
                                  }
                                }
                              } else {
                                if (buttonstatus == "") {
                                  var receptionistId = {
                                    "receptionist_id": resId.toString(),
                                    "status": "0"
                                  };

                                  print("receptionistId $receptionistId");

                                  var response = await Providers()
                                      .userDeactivated(receptionistId);
                                  if (response.status == true) {
                                    Navigator.pop(context);
                                    _setState(() {
                                      onTap = 1;
                                      buttonstatus = "Deactivate";
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            profileConfirm());
                                  }

                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) => profileConfirm());
                                } else {
                                  var receptionistId = {
                                    "receptionist_id": resId.toString(),
                                    "status": "1"
                                  };
                                  print("receptionistId $receptionistId");
                                  var response = await Providers()
                                      .userDeactivated(receptionistId);
                                  if (response.status == true) {
                                    Navigator.pop(context);
                                    _setState(() {
                                      onTap = 0;
                                      buttonstatus = "Activate";
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            profileConfirm());
                                  }
                                }
                              }
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    }),
                  );
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
                      buttonstatus == '' ? 'Deactivate' : 'Activate',
                      style: TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.bold),
                    ))),
              )
            ],
          )),
    );
  }
}
