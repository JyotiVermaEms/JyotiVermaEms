import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/imageModel.dart';
import 'package:http/http.dart' as http;

class CustomDialogBoxShipmentMarket extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status, pickupType;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  var arrivalimage;
  var arrivalcomment;
  var receptionistimage;
  var receptionistcomment;
  CustomDialogBoxShipmentMarket(
    this.id,
    this.type,
    this.bookingdate,
    this.status,
    this.pickupType,
    this.itemimage,
    this.comment,
    this.itemimage1,
    this.comment1,
    this.depatureimage,
    this.depaturecomment,
    this.arrivalimage,
    this.arrivalcomment,
    this.receptionistimage,
    this.receptionistcomment,
  );
  @override
  _CustomDialogBoxShipmentMarket createState() =>
      _CustomDialogBoxShipmentMarket();
}

class _CustomDialogBoxShipmentMarket
    extends State<CustomDialogBoxShipmentMarket> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  // List<ArrivalChangeStatusData> arrivalchangedata = [];
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

  get http => null;

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
      request.files.add(http.MultipartFile(
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
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            Icon(Icons.camera),
                            SizedBox(width: 40),
                            Text('Take a picture'),
                            SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateProfileApi();
    // getProfile();
    print(widget.id);
    print(widget.type);
    print(widget.bookingdate);
    print(widget.status);
    print(widget.id);
    print(imagepath.toString());
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
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                            jsonDecode(widget.itemimage),
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
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                            jsonDecode(widget.itemimage1),
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
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                            jsonDecode(widget.depatureimage),
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
                  child: Text(widget.depaturecomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog4(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                  child: widget.arrivalimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.arrivalimage),
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
                  child: Text(widget.arrivalcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog5(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                  child: widget.receptionistimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.receptionistimage),
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
                  child: Text(widget.receptionistcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  var h, w;
  contentBox(context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.9,
      width: w * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Order tracking" + " " + widget.id,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20,
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    height: 20,
                    width: 20,
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
            ),
          ]),
          Container(
              height: (Responsive.isDesktop(context)) ? 120 : 180,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffE5E5E5),
                // color: Colors.amber
              ),
              child: (Responsive.isDesktop(context))
                  ? Column(
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
                            Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  "Status",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
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
                        ),
                      ],
                    )
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      Column(
                        children: [
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 40, top: 20),
                                        width: 100,
                                        child: Text(
                                          "Shipped VIA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 20),
                                        child: Text(
                                          "Booking Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 20),
                                        width: 100,
                                        child: Text(
                                          "shippedvis".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "status".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(right: 10, top: 20),
                                        child: Text(
                                          "bookingdate".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 40, top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                        ],
                      ),
                    ])),
          SizedBox(
            height: 10,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: (Responsive.isDesktop(context))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/Group 740.png',
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
                            widget.status == "Confirmed" ||
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent"
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
                              // margin: EdgeInsets.only(right: 10),
                              // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Divider(
                            color: Color(0xff4CAF50),
                            height: 36,
                          )),
                        ),
                        Column(
                          children: [
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup"
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
                            widget.status == "Confirmed" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "accepted"
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
                                      _displayShowImageCommentDialog3(context);
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse"
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
                                      _displayShowImageCommentDialog3(context);
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      _displayShowImageCommentDialog4(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 20),
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
                            widget.status == "Confirmed" ||
                                    widget.status == "accepted" ||
                                    widget.status == "Accepted" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status == "Delivered to Receptionist"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    // margin: EdgeInsets.only(right: 20),
                                    // margin: EdgeInsets.only(left: 10, right: 10),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : InkWell(
                                    onTap: () {
                                      _displayShowImageCommentDialog5(context);
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
                      height: h * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              widget.status == "Confirmed"
                                  ? Column(children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        margin: EdgeInsets.only(left: 20),
                                        child: Image.asset(
                                            'assets/images/defaulticon.png',
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
                                    ])
                                  : Column(children: [
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
                                    ])
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
                          widget.status == "Confirmed" ||
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent"
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
                                // margin: EdgeInsets.only(right: 10),
                                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Divider(
                              color: Color(0xff4CAF50),
                              height: 36,
                            )),
                          ),
                          Column(
                            children: [
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup"
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
                                child: Divider(
                              color: Color(0xff4CAF50),
                              height: 36,
                            )),
                          ),
                          Column(
                            children: [
                              widget.status == "Confirmed" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "accepted"
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
                                child: Divider(
                              color: Color(0xff4CAF50),
                              height: 36,
                            )),
                          ),
                          Column(
                            children: [
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status == "delivered to Warehouse"
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
                                            // print("-=-=-=-=-=-=-==-=$itemimage");
                                            // print("-=-=-=-=-=-=-==-=$comment");

                                            _displayShowImageCommentDialog3(
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
                                              "receviedproceedforshipment".tr(),
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
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received"
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
                                              "Delivered to Receptionist",
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
                                            _displayShowImageCommentDialog4(
                                                context);
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered to Receptionist",
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
                                child: Divider(
                              color: Color(0xff4CAF50),
                              height: 36,
                            )),
                          ),
                          Column(
                            children: [
                              widget.status == "Confirmed" ||
                                      widget.status == "accepted" ||
                                      widget.status == "Accepted" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received" ||
                                      widget.status ==
                                          "Delivered to Receptionist"
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
                                              "Received by Receptionist",
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
                                            _displayShowImageCommentDialog5(
                                                context);
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
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Received by Receptionist",
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
                    )),
          if (Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Accepted",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Assign to Agent",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Going to Pickup",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        "Pickup Done",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 30),
                      child: Text(
                        "Delivered to Depature Warehouse",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Recevied & Proceed for Shipment",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Delivered to Receptionist",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "Received by Receptionist",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ======================================Shipment Dropoff Dialog boxes
class CustomDialogBoxShipmentDropOff extends StatefulWidget {
  var id;

  var type;
  var bookingdate;
  var status, pickupType;
  var itemimage;
  var comment;
  var itemimage1;
  var comment1;
  var depatureimage;
  var depaturecomment;
  var arrivalimage;
  var arrivalcomment;
  var receptionistimage;
  var receptionistcomment;
  CustomDialogBoxShipmentDropOff(
    this.id,
    this.type,
    this.bookingdate,
    this.status,
    this.pickupType,
    this.itemimage,
    this.comment,
    this.itemimage1,
    this.comment1,
    this.depatureimage,
    this.depaturecomment,
    this.arrivalimage,
    this.arrivalcomment,
    this.receptionistimage,
    this.receptionistcomment,
  );
  @override
  _CustomDialogBoxShipmentDropOff createState() =>
      _CustomDialogBoxShipmentDropOff();
}

class _CustomDialogBoxShipmentDropOff
    extends State<CustomDialogBoxShipmentDropOff> {
  // List image = [];
  PlatformFile? objFile = null;
  var name, profileImage;
  var buttonstatus = "Assign to Agent";
  var onTap = 0;
  // List<ArrivalChangeStatusData> arrivalchangedata = [];
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
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            Icon(Icons.camera),
                            SizedBox(width: 40),
                            Text('Take a picture'),
                            SizedBox(width: 50),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ],
                ),
              ),
            ));
  }

  doChangeStatus() async {
    var depatureData = {
      "booking_id": widget.id.toString(),
      "booking_status": "received by receptionist",
      "schedule_status": "",
      "pickup_itemimage": jsonEncode(imagepath),
    };

    print(depatureData);
  }

  Future<void> _displayShowImageCommentDialog3(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                            jsonDecode(widget.depatureimage),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: 250,
                          width: 250,
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
                  child: Text(widget.depaturecomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog4(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                  child: widget.arrivalimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.arrivalimage),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          height: 250,
                          width: 250,
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
                  child: Text(widget.arrivalcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  Future<void> _displayShowImageCommentDialog5(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text('Add Your Comment'),
          content: Container(
            height: (Responsive.isDesktop(context)) ? 470.0 : 350,
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
                  child: widget.receptionistimage != null
                      ? Container(
                          child: Image.network(
                            jsonDecode(widget.receptionistimage),
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
                  child: Text(widget.receptionistcomment),
                )),
              ),
            ]),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // updateProfileApi();
    // getProfile();
    print(widget.id);
    print(widget.type);
    print(widget.bookingdate);
    print(widget.status);

    print(imagepath.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: contentBox(context),
    );
  }

  var h, w;
  contentBox(context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.9,
      width: (Responsive.isDesktop(context)) ? w * 0.7 : w * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "ordertracking".tr() + "  " + widget.id,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20,
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
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    height: 20,
                    width: 20,
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
            ),
          ]),
          Container(
              height: (Responsive.isDesktop(context)) ? 120 : 170,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffE5E5E5),
              ),
              child: (Responsive.isDesktop(context))
                  ? Column(
                      children: [
                        Row(
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
                        ),
                        Row(
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
                        ),
                      ],
                    )
                  : ListView(scrollDirection: Axis.horizontal, children: [
                      Column(
                        children: [
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 40, top: 20),
                                        width: 100,
                                        child: Text(
                                          "Shipped VIA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width: 120,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 20),
                                        child: Text(
                                          "Booking Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 10, top: 20),
                                        width: 130,
                                        child: Text(
                                          "shippedvis".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(top: 20, left: 10),
                                        child: Text(
                                          "status".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        margin:
                                            EdgeInsets.only(right: 10, top: 20),
                                        child: Text(
                                          "bookingdate".tr(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                          (Responsive.isDesktop(context))
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 100,
                                        margin:
                                            EdgeInsets.only(left: 40, top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width: 150,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width: 120,
                                        margin:
                                            EdgeInsets.only(right: 40, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          widget.type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 110,
                                    // ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.status,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                    // SizedBox(
                                    //   width: 70,
                                    // ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        margin:
                                            EdgeInsets.only(left: 10, top: 10),
                                        child: Text(
                                          widget.bookingdate,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                )
                        ],
                      ),
                    ])),
          SizedBox(
            height: 25,
          ),
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: (Responsive.isDesktop(context))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            widget.status == "Confirmed"
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/defaulticon.png',
                                        fit: BoxFit.fill),
                                  )
                                : Container(
                                    height: 50,
                                    width: 50,
                                    margin: EdgeInsets.only(left: 20),
                                    child: Image.asset(
                                        'assets/images/Group 740.png',
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
                            widget.status == "Accepted" ||
                                    widget.status == "Confirmed" ||
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
                                    widget.status == "Confirmed" ||
                                    // widget.status == "assigned to agent" ||
                                    // widget.status == "going to pickup" ||
                                    // widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse"
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received"
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
                                      _displayShowImageCommentDialog4(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 20),
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
                                    widget.status == "Confirmed" ||
                                    widget.status == "assigned to agent" ||
                                    widget.status == "going to pickup" ||
                                    widget.status == "pickup done" ||
                                    widget.status == "delivered to Warehouse" ||
                                    widget.status == "pickup item received" ||
                                    widget.status == "Delivered to Receptionist"
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
                                      _displayShowImageCommentDialog5(context);
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
                      height: h * 0.3,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            children: [
                              widget.status == "Confirmed"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(left: 20),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
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
                                      ],
                                    )
                                  : Column(
                                      children: [
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
                                      widget.status == "Confirmed" ||
                                      widget.status == "accepted"
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
                                              "deliveredtodepaturewarehouse"
                                                  .tr(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
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
                                      widget.status == "Confirmed" ||
                                      widget.status == "delivered to Warehouse"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(right: 20),
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
                                            margin: EdgeInsets.only(right: 20),
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
                                      widget.status == "Confirmed" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(right: 20),
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Delivered to Receptionist",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _displayShowImageCommentDialog4(
                                            context);
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(right: 20),
                                            child: Image.asset(
                                                'assets/images/Group 742.png',
                                                fit: BoxFit.fill),
                                          ),
                                          Container(
                                              width: 50,
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Delivered to Receptionist",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
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
                                      widget.status == "Confirmed" ||
                                      widget.status == "assigned to agent" ||
                                      widget.status == "going to pickup" ||
                                      widget.status == "pickup done" ||
                                      widget.status ==
                                          "delivered to Warehouse" ||
                                      widget.status == "pickup item received" ||
                                      widget.status ==
                                          "Delivered to Receptionist"
                                  ? Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: EdgeInsets.only(right: 20),
                                          // margin: EdgeInsets.only(left: 10, right: 10),
                                          child: Image.asset(
                                              'assets/images/defaulticon.png',
                                              fit: BoxFit.fill),
                                        ),
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Received by Receptionist",
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
                                            _displayShowImageCommentDialog5(
                                                context);
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
                                        Container(
                                            width: 50,
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Received by Receptionist",
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
                    )),
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
                  Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "deliveredtoreceptionist".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Spacer(),
                  Container(
                      width: 100,
                      // margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "receivedbyreceptionist".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
