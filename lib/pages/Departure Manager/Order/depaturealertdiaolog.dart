import 'dart:convert';

import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/DepatureWareHouseManager/depaturechangestatusmodel.dart';
import 'package:shipment/Model/PickupAgent/pickupChangstatusmodel.dart';
import 'package:shipment/Model/PickupAgent/pickupchangeStatusModel.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Departure%20Manager/Dashboard/Order.dart';
import 'package:shipment/component/Departure%20Manager/Select_Agent.dart';
import 'package:shipment/component/Departure%20Manager/Select_Market_Agent.dart';

import 'package:shipment/pages/Pickup%20Agent/Order/successfullyCustomAlertdialog.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;

class CustomDialogBox1 extends StatefulWidget {
  var bid;
  var pid;
  var type;
  var bookingdate;
  var status;
  var btype;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  CustomDialogBox1(
    this.bid,
    this.pid,
    this.type,
    this.bookingdate,
    this.status,
    this.btype,
    this.itemimage,
    this.comment,
    this.itemimage1,
    this.comment1,
    this.depatureimage,
    this.depaturecomment,
  );
  @override
  _CustomDialogBox1 createState() => _CustomDialogBox1();
}

class _CustomDialogBox1 extends State<CustomDialogBox1> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var buttonstatus = "Assign to Agent";
  // var onTap = 0;
  List<DepatureStatusData> changedata = [];
  Image? image;
  String getImage = '';
  TextEditingController _textFieldController = TextEditingController();

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomDialogBox1(id, pid, type,
                            bookingdate, status, '', '', '', '', '', '', '')));
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
        // onTap = 1;
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
              content: SingleChildScrollView(
                child: ListBody(
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
                            Icon(Icons.camera),
                            SizedBox(width: 40),
                            Text('Take a picture'),
                            SizedBox(width: 50),
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Your Comment'),
          content: Container(
            height: 200.0,
            width: 400.0,
            child: Container(
              height: 200,
              width: 100,
              child: TextField(
                maxLength: 150,
                maxLines: 6,
                controller: _textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Enter Comment",
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.black),
                  child: Center(
                      child: Text('CANCEL',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12)))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Container(
                  height: 30,
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      'Add Comment',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )),
              onPressed: () {
                print(_textFieldController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog1(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        print("first face-----${widget.itemimage}");
        print("first face commet-----${widget.comment}");
        print("second google-----${widget.itemimage1}");
        print("second google comment-----${widget.comment1}");
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 500.0 : 350,
            width: 550.0,
            child: Column(children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.only(left: 370)
                        : const EdgeInsets.only(left: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black)),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: widget.itemimage != null
                      ? Container(
                          child: Image.network(
                            widget.itemimage,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )
                      : Container(
                          child: Icon(
                            Icons.person,
                            size: 200.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )),
              (Responsive.isDesktop(context))
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 410, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )))
                  : Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
              Container(
                height: 130,
                width: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.comment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog2(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 500.0 : 350,
            width: 550.0,
            child: Column(children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.only(left: 370)
                        : const EdgeInsets.only(left: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black)),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: widget.itemimage1 != null
                      ? Container(
                          child: Image.network(
                            widget.itemimage1,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )
                      : Container(
                          child: Icon(
                            Icons.person,
                            size: 200.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: 300,
                          width: 300,
                        )),
              (Responsive.isDesktop(context))
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 410, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )))
                  : Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
              Container(
                height: 130,
                width: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.comment1),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog3(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 500.0 : 350,
            width: 550.0,
            child: Column(children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: (Responsive.isDesktop(context))
                        ? const EdgeInsets.only(left: 370)
                        : const EdgeInsets.only(left: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black)),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                  ),
                  child: widget.depatureimage != null
                      ? Container(
                          child: Image.network(
                            widget.depatureimage,
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: (Responsive.isDesktop(context)) ? 300 : 100,
                          width: (Responsive.isDesktop(context)) ? 300 : 100,
                        )
                      : Container(
                          child: Icon(
                            Icons.person,
                            size: 200.0,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: 300,
                          width: 300,
                        )),
              (Responsive.isDesktop(context))
                  ? Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 410, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )))
                  : Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                      child: Text('Comment',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ))),
              Container(
                height: 130,
                width: 550,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                ),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(widget.depaturecomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.bid.toString(),
      "booking_status": "pickup item received",
      "schedule_status": "InProgress",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeDepatureStatus(depatureData);
    if (response.status == true) {
      // setState(() {
      //   changedata = response.data;
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
    }
  }

  List<MarketStatusData> mrkchangedata = [];
  doMarketChangeStatus() async {
    var depatureData = {
      "market_id": widget.bid.toString(),
      "market_status": "pickup item received",
      "pickup_itemimage": jsonEncode(imagepath),
      "comment": _textFieldController.text
    };

    print(depatureData);
    //return;

    var response = await Providers().changeMarketDepatureStatus(depatureData);
    if (response.status == true) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => profileConfirm());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateProfileApi();
    // getProfile();
    print(widget.bid);
    print(widget.type);
    print(widget.bookingdate);
    print(widget.status);
    print(widget.bid);
    print(imagepath.toString());
  }

  @override
  Widget build(BuildContext context) {
    print("first face-----${widget.itemimage}");
    print("first face commet-----${widget.comment}");
    print("second google-----${widget.itemimage1}");
    print("second google comment-----${widget.comment1}");
    return Dialog(
      child: contentBox(context),
    );
  }

  var h, w;
  contentBox(context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Form(
      key: _formkey,
      child: Container(
        height: (Responsive.isDesktop(context)) ? h * 0.9 : h * 1.7,
        width: w * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Color(0xffFFFFFF),
        ),
        child: ListView(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "ordertracking".tr() + "  " + widget.bid,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: (Responsive.isDesktop(context)) ? 20 : 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 290,
              // ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(right: 10),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Container(
              height: (Responsive.isDesktop(context)) ? 120 : 157,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffE5E5E5),
              ),
              child: Column(
                children: [
                  (Responsive.isDesktop(context))
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 40, top: 20),
                                width: 100,
                                child: Text(
                                  "shippedvis".tr(),
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
                                  "status".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 40, top: 20),
                                child: Text(
                                  "bookingdate".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10, top: 20),
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Text(
                                  "shippedvis".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // Spacer(),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "status".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(right: 10, top: 20),
                                child: Text(
                                  "bookingdate".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                  (Responsive.isDesktop(context))
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: 100,
                                margin: EdgeInsets.only(left: 40, top: 10),
                                child: Text(
                                  widget.type,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 110,
                            // ),
                            Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.status,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 40, top: 10),
                                child: Text(
                                  widget.bookingdate,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  widget.type,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 110,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.status,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            // SizedBox(
                            //   width: 70,
                            // ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                margin: EdgeInsets.only(right: 10, top: 10),
                                child: Text(
                                  widget.bookingdate,
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
              padding: (Responsive.isDesktop(context))
                  ? const EdgeInsets.only(top: 15)
                  : const EdgeInsets.only(top: 5),
              child: (Responsive.isDesktop(context))
                  ? Row(
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
                          ],
                        ),
                        Expanded(
                          child: Container(
                              child: Divider(
                            color: Color(0xff4CAF50),
                            height: 36,
                          )),
                        ),
                        Column(
                          children: [
                            widget.status == "Accepted" ||
                                    widget.status == "accepted"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/Group 742.png',
                                        fit: BoxFit.fill),
                                  )
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
                            widget.status == "Accepted" ||
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "Assign To Agent"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/Group 742.png',
                                        fit: BoxFit.fill),
                                  ),
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
                            widget.status == "Accepted" ||
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "Assign To Agent"
                                ? Container(
                                    height: 50,
                                    width: 50,

                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog1(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      // margin: EdgeInsets.only(left: 10, right: 10),
                                      child: Image.asset(
                                          'assets/images/Group 742.png',
                                          fit: BoxFit.fill),
                                    ),
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
                            widget.status == "Accepted" ||
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "Assign To Agent"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      // print("-=-=-=-=-=-=-==-=$itemimage");
                                      // print("-=-=-=-=-=-=-==-=$comment");

                                      _displayShowImageCommentDialog2(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      // margin: EdgeInsets.only(left: 10, right: 10),
                                      child: Image.asset(
                                          'assets/images/Group 742.png',
                                          fit: BoxFit.fill),
                                    ),
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
                            widget.status == "Accepted" ||
                                    widget.status == "accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "Assign To Agent"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      _displayShowImageCommentDialog3(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 20),
                                      child: Image.asset(
                                          'assets/images/Group 743.png',
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      height: h * 0.2,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              Column(children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Image.asset(
                                      'assets/images/Group 740.png',
                                      fit: BoxFit.fill),
                                ),
                                Container(
                                    width: 50,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "accepted".tr(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ]),
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
                              widget.status == "Accepted" ||
                                      widget.status == "accepted"
                                  ? Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
                                            fit: BoxFit.fill),
                                      ),
                                      // Spacer(),
                                      Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "assigntoagent".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ])
                                  : Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                                      Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "assigntoagent".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ]),
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
                              widget.status == "Accepted" ||
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "goingtopickup".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        // margin: EdgeInsets.only(left: 10, right: 10),
                                        child: Image.asset(
                                            'assets/images/Group 742.png',
                                            fit: BoxFit.fill),
                                      ),
                                      Container(
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(
                                            "goingtopickup".tr(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ]),
                            ],
                          ),
                          Expanded(
                            child: Container(
                                child: Divider(
                              color: Color(0xff4CAF50),
                              height: 36,
                            )),
                          ),
                          Column(
                            children: [
                              widget.status == "Accepted" ||
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(left: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "pickupdone".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog1(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(left: 20),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "pickupdone".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
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
                              widget.status == "Accepted" ||
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog2(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            // margin: EdgeInsets.only(left: 10, right: 10),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
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
                              widget.status == "Accepted" ||
                                      widget.status == "accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "Assign To Agent"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "receviedproceedforshipment".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _displayShowImageCommentDialog3(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "receviedproceedforshipment".tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
            if (Responsive.isDesktop(context))
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
                            "accepted".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "assigntoagent".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "goingtopickup".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "pickupdone".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 30),
                          child: Text(
                            "deliveredtodepaturewarehouse".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      Spacer(),
                      Container(
                          width: 100,
                          // margin: EdgeInsets.only(right: 5),
                          child: Text(
                            "receviedproceedforshipment".tr(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )),
            widget.status == "accepted" ||
                    widget.status == "Accepted" ||
                    widget.status == "delivered to Warehouse"
                ? Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Stack(children: [
                      InkWell(
                        onTap: () {
                          _openCamera(context);
                        },
                        child: Center(
                          child: Container(
                            width: 90.0,
                            height: 90.0,
                            margin: (Responsive.isDesktop(context))
                                ? const EdgeInsets.only(top: 12)
                                : const EdgeInsets.only(top: 5),
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
                        ),
                      ),
                      Positioned(
                        left: (Responsive.isDesktop(context)) ? 480.0 : 150,
                        top: 5,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              imagepath = "";
                              // onTap = 0;
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
            widget.status == "accepted" ||
                    widget.status == "Accepted" ||
                    widget.status == "delivered to Warehouse"
                ? Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            print("in ontap ${widget.btype}");
                            if (widget.btype.toString() == "1") {
                              if (widget.status != "accepted") {
                                if (widget.status !=
                                    "going to pickup") if (widget
                                        .status !=
                                    "pickup done") if (widget
                                        .status ==
                                    "delivered to Warehouse") {
                                  //      if (onTap == 0) {
                                  //   _openCamera(context);
                                  // } else {
                                  if (_formkey.currentState!.validate()) {
                                    if (imagepath.isEmpty) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    if (_textFieldController.text.isEmpty) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: Text("Please Add Comment"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                  _formkey.currentState!.save();
                                  doMarketChangeStatus();
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectMarketAgent(
                                          pid: widget.pid, bid: widget.bid)),
                                );

                                // doChangeStatus();
                              }
                            } else {
                              if (widget.status != "Accepted") {
                                if (widget.status !=
                                    "going to pickup") if (widget
                                        .status !=
                                    "pickup done") if (widget
                                        .status ==
                                    "delivered to Warehouse") {
                                  if (_formkey.currentState!.validate()) {
                                    if (imagepath.isEmpty) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content:
                                              Text("Please upload the image"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    if (_textFieldController.text.isEmpty) {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          content: Text("Please Add Comment"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                  }
                                  _formkey.currentState!.save();

                                  doChangeStatus();
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectAgent(
                                          pid: widget.pid, bid: widget.bid)),
                                );

                                // doChangeStatus();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 15,
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: widget.status == "Accepted" ||
                                        widget.status == "accepted"
                                    ? Color(0xff4CAF50)
                                    : widget.status == "going to pickup"
                                        ? Colors.grey
                                        : widget.status == "pickup done"
                                            ? Colors.grey
                                            : widget.status ==
                                                    "delivered to Warehouse"
                                                ? Color(0xff4CAF50)
                                                : Colors.grey),
                            height: (Responsive.isDesktop(context)) ? 45 : 35,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (30 / 100)
                                : MediaQuery.of(context).size.width *
                                    (15 / 100),
                            child: Center(
                                child: widget.status == "Accepted" ||
                                        widget.status == "accepted"
                                    ? (Responsive.isDesktop(context))
                                        ? Text("Assign To Agent",
                                            style:
                                                TextStyle(color: Colors.white))
                                        : Text("Assign To Agent",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10))
                                    : widget.status == "going to pickup"
                                        ? (Responsive.isDesktop(context))
                                            ? Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black))
                                            : Text("Update Status",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10))
                                        : widget.status == "pickup done"
                                            ? (Responsive.isDesktop(context))
                                                ? Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black))
                                                : Text("Update Status",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10))
                                            : widget.status ==
                                                    "delivered to Warehouse"
                                                ? (Responsive.isDesktop(
                                                        context))
                                                    ? Text("Update Status",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))
                                                    : Text("Update Status",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10))
                                                : (Responsive.isDesktop(
                                                        context))
                                                    ? Text("Update Status",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))
                                                    : Text("Update Status",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10))),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _displayTextInputDialog(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 25,
                              top: 5,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: Color(0xff1A494F)),
                            height: (Responsive.isDesktop(context)) ? 45 : 35,
                            width: (!Responsive.isDesktop(context))
                                ? MediaQuery.of(context).size.width * (30 / 100)
                                : MediaQuery.of(context).size.width *
                                    (15 / 100),
                            child: Center(
                              child: (Responsive.isDesktop(context))
                                  ? Text("Add Comment",
                                      style: TextStyle(color: Colors.white))
                                  : Text("Add Comment",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10)),
                            ),
                          ),
                        ),
                      ],
                    ))
                : SizedBox()
          ],
        ),
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
