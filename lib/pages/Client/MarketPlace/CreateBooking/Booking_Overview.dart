// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_web/flutter_google_places_web.dart';
import 'package:shipment/Element/Sidebar.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/validation.dart';
import 'package:shipment/Model/Client/ScheduleItemModel.dart';
import 'package:shipment/Provider/Provider.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_Client_items.dart';
import 'package:shipment/component/Res_Client/ResMarketPlace/Res_pricing.dart';
import 'package:shipment/component/Res_Shipment.dart/Res_Schedule_shipment_item.dart';
import 'package:shipment/constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BookingOverView extends StatefulWidget {
  const BookingOverView({Key? key}) : super(key: key);

  @override
  _BookingOverViewState createState() => _BookingOverViewState();
}

class _BookingOverViewState extends State<BookingOverView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController fromLocation = new TextEditingController();
  TextEditingController toLocation = new TextEditingController();

  GlobalKey<FormState> _pickupGoogleKey = GlobalKey<FormState>();

  GlobalKey<FormState> _dropGoogleKey = GlobalKey<FormState>();

  List<TextEditingController> _QTYcontrollr = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var h, w;
  var check = false;

  var title, pickupLocation, dropoffLocation, numberOfitems;

  int? _radioValue = 0;
  int? _radioValue2 = 0;
  var itemname = [];
  var qty = [];

  void _handleRadioValueChange2(value) {
    setState(() {
      _radioValue2 = value;

      switch (_radioValue2) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
      }
    });
  }

  _requiredField(val, field) {
    final required = requiredField(val, field);
    if (required != null) {
      return required;
    }
  }

  List<Schdule> itemList = [];
  List selectedCategory = [];
  List<TextEditingController> selectedQTY = [];

  List<Items> items = [];

  List<List<Items>> selectedCheckBoxIndex = [];

  Future getItemsList() async {
    var res = await Providers().getItemList();
    if (res.status == true) {
      setState(() {
        itemList = res.data;
      });

      print("fdasfdas");
      print(jsonEncode(itemList));

      for (int i = 0; i < res.data.length; i++) {
        List<bool> addTemp = [];
        for (int j = 0; j < res.data[i].itemName.length; j++) {
          addTemp.add(false);
        }
        temp2.insert(i, addTemp);
      }

      for (int i = 0; i < res.data.length; i++) {
        temp.add(false);
        selectedCheckBoxIndex.insert(i, []);
      }
      for (int i = 0; i < res.data.length; i++) {
        itemname.insert(i, itemList[i]);
      }
      print(jsonEncode(selectedCheckBoxIndex));

      // for (int i = 0; i < itemList.length; i++) {
      //   itemname.add(itemList[i].categoryName);
      // }
    }
  }

  List temp = [];

  List<List<bool>> temp2 = [];
  @override
  void initState() {
    super.initState();
    getItemsList();
    // temp2.add(false);
  }

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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
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

                    processTimeline(),
                    bookingOverView(),
                    // buttons(),
                  ]),
                ),
              )),
        ));
  }

  Widget bookingOverView() {
    var piGcount = 0;
    var drGcount = 0;

    return Container(
      // height: 80,
      width: w,
      margin: EdgeInsets.only(top: 30, bottom: 30, right: 15, left: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 20),
                child: Text(
                  "Booking overview",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
              )),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Title",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Tell the client what you will deliver and how it benefits them.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 10, right: 15, left: 15),
              // width: MediaQuery.of(context).size.width * (15 / 100),
              child: TextFormField(
                // maxLength: 50,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                validator: (val) => _requiredField(val, "Title"),
                onChanged: (v) {
                  setState(() {
                    title = v;
                  });
                },
                style: TextStyle(color: Colors.black, fontSize: 17),
                decoration: InputDecoration(
                    fillColor: Color(0xffF5F6FA),
                    // counterText: '',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1.2, color: Color(0xffF5F6FA)),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                    hintText: "you will get",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Some good example titles",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "• You will get an amazing logo designed for your business",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "• You will get 3 hours of social media marketing consultation",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "• You will get a revamped resume tailored to your next job",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Container(
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
                  "Item",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Select a category so it's easy for clients to find your project.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Here are some suggestions based on your Booking title.",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                )),
          ),
          (Responsive.isDesktop(context))
              ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: itemList.length,
                  shrinkWrap: true,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 1,
                      // crossAxisSpacing: 1,
                      childAspectRatio: 5 / 1),
                  itemBuilder: (context, index) {
                    temp.add(false);
                    return Container(
                      child: CheckboxListTile(
                        value: temp[index],
                        title: Container(
                            // height: w*.10,
                            child: Text(itemList[index].category)),
                        onChanged: (val) {
                          print("-=-=-= ${itemList[index].category}");
                          setState(() {
                            temp[index] = val!;

                            if (!selectedCheckBoxIndex
                                .contains(itemList[index].itemName)) {
                              // selectedCheckBoxIndex.add(itemList[index].items);
                              // itemname.add(itemList[index]);
                              selectedCheckBoxIndex.insert(
                                  index, itemList[index].itemName);
                              // itemname.add(itemList[index]);
                              itemname.insert(index, itemList[index]);
                              print(
                                  "LIST>>>>>>>>>>>>>> ${selectedCheckBoxIndex[index]}");
                            } else {
                              // selectedCheckBoxIndex.remove(itemList[index].items);
                              // itemname.remove(itemList[index]);
                              selectedCheckBoxIndex.remove(index);
                              itemname.remove(index);
                            }
                            for (int i = 0; i < temp2[index].length; i++) {
                              setState(() {
                                temp2[index][i] = false;
                              });
                            }
                            print("jsonEncode(temp2)" +
                                jsonEncode(temp2).toString());
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                )
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: itemList.length,
                  shrinkWrap: true,
                  // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2,
                      // crossAxisSpacing: 1,
                      childAspectRatio: 3 / 1),
                  itemBuilder: (context, index) {
                    temp.add(false);
                    return Container(
                      child: CheckboxListTile(
                        value: temp[index],
                        title: Container(
                            // height: w*.10,
                            child: Text(itemList[index].category)),
                        onChanged: (val) {
                          print("-=-=-= ${itemList[index].category}");
                          setState(() {
                            temp[index] = val!;

                            if (!selectedCheckBoxIndex
                                .contains(itemList[index].itemName)) {
                              // selectedCheckBoxIndex.add(itemList[index].items);
                              // itemname.add(itemList[index]);
                              selectedCheckBoxIndex.insert(
                                  index, itemList[index].itemName);
                              // itemname.add(itemList[index]);
                              itemname.insert(index, itemList[index]);
                              print(
                                  "LIST>>>>>>>>>>>>>> ${selectedCheckBoxIndex[index]}");
                            } else {
                              // selectedCheckBoxIndex.remove(itemList[index].items);
                              // itemname.remove(itemList[index]);
                              selectedCheckBoxIndex.remove(index);
                              itemname.remove(index);
                            }
                            for (int i = 0; i < temp2[index].length; i++) {
                              setState(() {
                                temp2[index][i] = false;
                              });
                            }
                            print("jsonEncode(temp2)" +
                                jsonEncode(temp2).toString());
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResClientItems()));
                }),
                child: Text(
                  "Add a categories",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
              )),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Booking attributes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          for (int i = 0; i < selectedCheckBoxIndex.length; i++)
            temp[i]
                ? vehicleTypeRadios(
                    listOfTypes: selectedCheckBoxIndex[i],
                    vehicleType: itemname[i].category,
                    selectedCategoryIndex: i)
                : Container(),
          Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
                color: Colors.grey,
                height: 36,
              )),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "Pick-up and Drop-off Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Pick-up Location",
                  style: TextStyle(fontSize: 14),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 15, left: 15),
            // width: MediaQuery.of(context).size.width * (15 / 100),
            child: TextFormField(
              maxLength: 100,
              initialValue: "",
              validator: (val) => _requiredField(val, "Pick-up Locaton"),
              onChanged: (v) {
                setState(() {
                  pickupLocation = v;
                });
              },
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
                  hintText:
                      "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Drop-off Location",
                  style: TextStyle(fontSize: 14),
                )),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, right: 10, left: 15),
            // width: MediaQuery.of(context).size.width * (15 / 100),
            child: TextFormField(
              maxLength: 100,
              // initialValue:  "",
              controller: toLocation,
              validator: (val) => _requiredField(val, "Drop-off Location"),
              onChanged: (v) {
                setState(() {
                  dropoffLocation = v;
                });

                if (dropoffLocation != pickupLocation) {
                  dropoffLocation = v;
                } else {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text("Please enter correct value"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            toLocation.clear();
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
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
                  hintText:
                      "Fourwinds, Upper Campsfield Road, Woodstock, OX20 1QG",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
          buttons(),
        ],
      ),
    );
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
            margin: EdgeInsets.only(top: 15, left: 15, bottom: 50),
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
              if (this._formKey.currentState!.validate()) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');

                List<String> listOfAttributes = [];
                for (int i = 0; i < itemList.length; i++) {
                  print("-=-=-= temp[i] ${temp[i]}");

                  if (temp[i] == true) {
                    listOfAttributes = [];

                    {
                      for (int ij = 0; ij < temp2[i].length; ij++) {
                        if (temp2[i][ij] == true) {
                          print("-=-=-= ij $ij");

                          for (int j = 0;
                              j < itemList[i].itemName.length;
                              j++) {
                            // if(andar ki list ka check uncheck)
                            {
                              print(
                                  "-=->>>itemName[j] ${itemList[i].itemName[j].itemName}");
                            }
                          }

                          listOfAttributes
                              .add(itemList[i].itemName[ij].itemName);
                        }
                      }
                    }

                    print("_QTYcontrollr[i]-=-= ${_QTYcontrollr[i].text}");
                    print("listOfAttributes-=-= $listOfAttributes");

                    if (!selectedCategory.contains(itemList[i].category)) {
                      selectedCategory.add({
                        "categoryItem": "${itemList[i].category}",
                        "booking_attribute": listOfAttributes,
                        "quantity": "${_QTYcontrollr[i].text}",
                        "icon": "",
                      });
                    }
                  }
                }

                print("-=-=-selectedCategory $selectedCategory");
                //return;
                if (Responsive.isDesktop(context)) if (selectedCategory
                        .isEmpty ||
                    listOfAttributes.length < 0) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text("Please select All Fields"),
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

                _formKey.currentState!.save();
                var data = {
                  "title": "$title",
                  "Pickuplocation": pickupLocation,
                  "dropofflocation": dropoffLocation,
                  // "category": _radioValue == 0
                  //     ? "car"
                  //     : _radioValue == 1
                  //         ? "box"
                  //         : "Barrel",
                  "category": jsonEncode(selectedCategory)
                };
                print("LIST  ${jsonEncode(selectedCategory)}");
                print("data????????????????????????? $data");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ResPricing(data)));
              }
            },
            child: (Responsive.isDesktop(context))
                ? Container(
                    height: 60,
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 50),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Color(0xff1F2326)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Save & Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        Image.asset(
                          'assets/images/arrow-right.png',
                          height: 20,
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 60,
                    margin: EdgeInsets.only(
                        top: 15, left: 15, right: 15, bottom: 50),
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: Color(0xff1F2326)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Save & Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        Image.asset(
                          'assets/images/arrow-right.png',
                          height: 20,
                        ),
                      ],
                    ),
                  ))
      ],
    );
  }

  Widget processTimeline() {
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
              margin: EdgeInsets.only(left: 15, top: 10),
              child: Text(
                "Overview",
                style: TextStyle(
                    color: Color(0xff4CAF50),
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Color(0xff4CAF50),
              thickness: 2,
              height: 36,
            )),
          ),
          Column(children: [
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
                '2',
                style: TextStyle(color: Colors.grey),
              ))),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "Pricing",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(children: [
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
                '3',
                style: TextStyle(color: Colors.grey),
              ))),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(
                    child: Text(
                  'Gallery',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ))),
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(children: [
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
                child: Center(
                    child: Text(
                  'Description',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ))),
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(children: [
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
                style: TextStyle(color: Colors.grey),
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
          ]),
          Expanded(
            child: Container(
                // margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Divider(
              color: Colors.grey,
              thickness: 2,
              height: 36,
            )),
          ),
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10),
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
                      fontWeight: FontWeight.bold),
                ))),
          ]),
        ],
      ),
    );
  }

  Widget vehicleTypeRadios(
      {vehicleType, List<Items>? listOfTypes, var selectedCategoryIndex}) {
    print("object12" + jsonEncode(temp2).toString());

    listOfTypes!.forEach((str) {
      var textEditingController = new TextEditingController(text: '');
      var itemtextEditingController = TextEditingController(text: '');

      _QTYcontrollr.add(itemtextEditingController);
      // _QTYcontrollr.putIfAbsent(str, () => itemtextEditingController);
    });

    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            child: Text(
              "$vehicleType",
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            )),
      ),
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          height: (Responsive.isDesktop(context)) ? 50 : 100,
          // height: MediaQuery.of(context).size.height * (1 / 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xffFFFFFF),
          ),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: listOfTypes.length,
            shrinkWrap: true,
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (Responsive.isDesktop(context)) ? 5 : 2,
                mainAxisSpacing: 1,
                // crossAxisSpacing: 1,
                childAspectRatio: 4 / 1),
            itemBuilder: (context, index1) {
              // temp2.add(false);
              return CheckboxListTile(
                value: temp2[selectedCategoryIndex][index1],
                title: Text("${listOfTypes[index1].itemName}"),
                onChanged: (val) {
                  setState(() {
                    temp2[selectedCategoryIndex][index1] = val!;
                  });
                  //print("LIST>>>>>>>temp2>>>>>>> $temp2");
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              );
            },
          ),
        ),
      ),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 15),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Number of Items",
                  style: TextStyle(fontSize: 14),
                )),
          ),
          Container(
            margin: EdgeInsets.only(right: 10, left: 30),
            width: MediaQuery.of(context).size.width * (20 / 100),
            child: TextFormField(
              // initialValue: "",
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _QTYcontrollr[selectedCategoryIndex],
              onChanged: (v) {
                print("selectedCategoryIndex $selectedCategoryIndex");
                print("selectedQTY");
                print(selectedQTY);

                var itemtextEditingController = TextEditingController(text: v);
                _QTYcontrollr.add(itemtextEditingController);

                setState(() {
                  //numberOfitems = v;
                  // selectedQTY.add(
                  //   v,
                  // );
                });
              },
              validator: (val) => _requiredField(val, "no of items"),
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
                  hintText: "2",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
            ),
          ),
        ],
      ),
    ]);
  }
}
