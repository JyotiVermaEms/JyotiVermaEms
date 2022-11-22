import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Model/imageModel.dart';

import 'package:shipment/component/Res_Client/ResMarketPlace/Res_Booking_Des.dart';
import 'package:shipment/constants.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;

class Gallery extends StatefulWidget {
  var data;
  Gallery(this.data);
  // const Gallery({Key? key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;

  List temp = [];
  @override
  void initState() {
// TODO: implement initState
    super.initState();
    // DateTime? selectedDate = DateTime.now();
    temp.add(widget.data['category']);
  }

  File? imagefile;
  // var images = new List(3);

  List images = [];
  _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imagefile = File(_image!.path);
      images.add(_image.path);

      // _uploadImage();

      print("image $imagefile");
      // Navigator.of(context).pop();
    });
  }

  var imageURL;
  PlatformFile? objFile = null;

  void chooseFileUsingFilePicker(BuildContext context, index) async {
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

      imageURL = temp3.data[0].image;

      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>$imageURL");
      setState(() {
        // itemList[index].imageList!.add(imageURL.toString());
        imageURL = temp3.data[0].image;
        images.add(imageURL);
      });

      //-------Your response
      // print(result2);
      // });
    }
  }

  List<String> temp5 = [];

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: SideBar(),
        ),
        body: Container(
          padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
          color: Color(0xffF5F6F8),
          child: SafeArea(
              right: false,
              child: Column(children: [
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
                      // if (Responsive.isDesktop(context)) SizedBox(width: 5),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 5, 0),
                        child: Text(
                          'Market Place > Project overview',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                processTimeline3(),
                gallary(),
                // buttons(),
              ])),
        ));
  }

  Widget buttons() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 100,
            height: 60,
            margin: EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Colors.black),
                color: Color(0xffFFFFFF)),
            child: Center(
                child: Text("Back",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ))),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            if (images.isEmpty) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  content: Text("Please Upload Image"),
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
            print("fffff" + jsonEncode(images));
            var data = {
              "title": widget.data['title'],
              "Pickuplocation": widget.data['Pickuplocation'],
              "dropofflocation": widget.data['dropofflocation'],
              "category": widget.data['category'],
              "deliverdays": widget.data['deliverdays'],
              "numberItems": widget.data['numberItems'],
              "bookingPrice": widget.data['bookingPrice'],
              "pickup_dropoff": widget.data['pickup_dropoff'],
              "image": jsonEncode(images)
            };
            print("datatatatatat   ${json.encode(data)}");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResBookingDescription(data)));
          },
          child: (Responsive.isDesktop(context))
              ? Container(
                  margin:
                      EdgeInsets.only(top: 15, left: 15, right: 20, bottom: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Color(0xff1F2326)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                          // width: MediaQuery.of(context).size.width * 0.8,
                          // color: Colors.lime,
                          child: Center(
                              child: Text("Save & Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )))),
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 10, left: 30),
                        height: 30,
                        // width: 300,
                        child: Image.asset('assets/images/arrow-right.png'),
                      ),
                    ],
                  ),
                )
              : Container(
                  margin:
                      EdgeInsets.only(top: 15, left: 5, right: 0, bottom: 50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Color(0xff1F2326)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(15, 15, 0, 15),

                          // width: MediaQuery.of(context).size.width * 0.8,
                          // color: Colors.lime,
                          child: Center(
                              child: Text("Save & Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  )))),
                      Container(
                        margin: EdgeInsets.only(top: 15, right: 5, left: 5),
                        height: 30,
                        // width: 300,
                        child: Image.asset('assets/images/arrow-right.png'),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget gallary() {
    return Expanded(
      child: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var gestureDetector = GestureDetector(
              onTap: () {
                if (images.length < 5) {
                  chooseFileUsingFilePicker(context, index);
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      // title: Text("Alert Dialog Box"),
                      content: Text("Only 5 images upload "),
                      actions: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Text("okay"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Align(
                  alignment: Alignment.topLeft,
                  child: (Responsive.isDesktop(context))
                      ? Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffF5F6FA),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.black,
                                size: 40,
                              ),
                              Container(
                                  // margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(
                                "Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8,
                                    color: Colors.grey),
                              )),
                            ],
                          ),
                        )
                      : Container(
                          height: 90,
                          width: 50,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xffF5F6FA),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                color: Colors.black,
                                size: 40,
                              ),
                              Container(
                                  // margin: EdgeInsets.only(left: 15, top: 10),
                                  child: Text(
                                "Browse",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8,
                                    color: Colors.grey),
                              )),
                            ],
                          ),
                        )),
            );
            return Container(
              // height: 80,
              width: w,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffFFFFFF),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Create a stunning booking gallery",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.grey,
                        height: 36,
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Text(
                          "Item Images",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Container(
                  //       margin: EdgeInsets.only(left: 15, top: 10),
                  //       child: Text(
                  //         "Upload up to 5 images (.jpg or .png), up to 10MB each and less than 4000 pixels, in width or height.",
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w500, color: Colors.grey),
                  //       )),
                  // ),
                  Row(
                    children: [
                      gestureDetector,
                      Container(
                        height: h * .10,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: EdgeInsets.only(left: 10),
                                  height: MediaQuery.of(context).size.height *
                                      (40 / 100),
                                  width: MediaQuery.of(context).size.width *
                                      (10 / 100),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.0),
                                    color: Color(0xffE5E5E5),
                                  ),
                                  child:
                                      //  kIsWeb
                                      //     ?
                                      Image.network(
                                    images[index],
                                  )
                                  // : Image.file(File(
                                  //     itemList[index].imageList![index]!,
                                  //   )),
                                  // Image.file(
                                  //   image[index],
                                  //   fit: BoxFit.fill,
                                  // ),
                                  );
                            }),
                      ),
                    ],
                  ),
                  new Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.grey,
                        height: 36,
                      )),
                  buttons(),
                ],
              ),
            );
          }),
    );
  }

  Widget processTimeline3() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(left: 15, top: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
                color: Color(0xff4CAF50),
              ),
              child: Container(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Overview",
                style: TextStyle(
                  color: Color(0xff4CAF50),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Color(0xff4CAF50),
              thickness: 2,
              height: 30,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Pricing",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Color(0xff4CAF50),
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xff4CAF50)),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                  child: Icon(
                    Icons.edit,
                    color: Color(0xff4CAF50),
                    size: 20,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '4',
                  style: TextStyle(color: Colors.grey),
                ))),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '5',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ))),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Center(
                      child: Text(
                    'Requirement',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
            ],
          ),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                  // color: Color(0xff4CAF50),
                ),
                child: Container(
                    child: Center(
                        child: Text(
                  '6',
                  style: TextStyle(color: Colors.grey),
                ))),
              ),
              Container(
                  margin: EdgeInsets.only(top: 10, right: 10),
                  child: Center(
                      child: Text(
                    'Review',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
            ],
          ),
        ],
      ),
    );
  }
}
