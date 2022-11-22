import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/Element/fullViewImageDialog.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/ArrivalOrderManagement.dart';
import 'package:shipment/pages/Arrival%20Manager/Order/customAlertDialiog.dart';

class ClientPickuDropoffDetails extends StatefulWidget {
  var data;
  ClientPickuDropoffDetails(this.data);

  @override
  _ClientPickuDropoffDetails createState() => _ClientPickuDropoffDetails();
}

class _ClientPickuDropoffDetails extends State<ClientPickuDropoffDetails> {
  var imageList = [];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.data['itemdetail'].length; i++) {
      for (int i1 = 0; i1 < widget.data['itemdetail'][i].itemImage.length; i1++)
        imageList.add(widget.data['itemdetail'][i].itemImage[i1].toString());

      print(":imageList");
      print(imageList);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 30),
      child: (Responsive.isDesktop(context))
          ? Row(
              children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 30),
                    child: Container(
                      child: imageList.length != 0
                          ? CarouselSlider(
                              options: CarouselOptions(
                                enableInfiniteScroll: false,
                                autoPlay: true,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                  //print(_currentIndex);
                                },
                              ),
                              items: imageList
                                  .map<Widget>((item) => InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return imageViewDialog(
                                                  context, item, imageList);
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            child: Image.network(
                                              item,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          : Center(
                              child: Text(
                              "noimageavailable".tr(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 350,
                      width: 350,
                    ),
                  ),
                ]),
                SizedBox(
                  width: 40,
                ),
                Container(
                    child: Container(
                  // height: 350,
                  child: Column(
                    children: [
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Container(
                            width: 120,
                            child: Text(
                              "ordertype".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['pickuptype'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "location".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 80,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.data['pickuplocation'].toString(),
                                  softWrap: true,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "date".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['pickupdate'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "time".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['pickuptime'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "distance".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['pickupdistance'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "estimate".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['pickupestimate'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      // Row(
                      //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.only(top: 10),
                      //         child: Container(
                      //           width: 120,
                      //           child: Text(
                      //             "Transaction Id",
                      //             style: TextStyle(color: Colors.black),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(
                      //           top: 10,
                      //         ),
                      //         child: Container(
                      //           height: 40,
                      //           width: 120,
                      //           decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               borderRadius: BorderRadius.circular(15)),
                      //           child: Center(
                      //             child: Text(
                      //               widget.data['transactionid'].toString(),
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(top: 10, left: 10),
                      //         child: Container(
                      //           width: 120,
                      //           child: Text(
                      //             "Total Amount",
                      //             style: TextStyle(color: Colors.black),
                      //           ),
                      //         ),
                      //       ),
                      //       Padding(
                      //         padding: const EdgeInsets.only(
                      //           top: 10,
                      //         ),
                      //         child: Container(
                      //           height: 40,
                      //           width: 120,
                      //           decoration: BoxDecoration(
                      //               color: Colors.white,
                      //               borderRadius: BorderRadius.circular(15)),
                      //           child: Center(
                      //             child: Text(
                      //               widget.data['totalamount'].toString(),
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ]),
                      Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 120,
                            child: Text(
                              "transactionid".tr(),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Container(
                            height: 50,
                            width: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                widget.data['transactionid'].toString(),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ))
              ],
            )
          : ListView(
              children: [
                Column(children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: imageList.length != 0
                        ? CarouselSlider(
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              autoPlay: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                                //print(_currentIndex);
                              },
                            ),
                            items: imageList
                                .map<Widget>((item) => InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return imageViewDialog(
                                                context, item, imageList);
                                          },
                                        );
                                      },
                                      child: Container(
                                        child: Image.network(
                                          item,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                            "No Image Available",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 250,
                    width: 350,
                  ),
                ]),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "ordertype".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 10,
                        ),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickuptype'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "location".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickuplocation'].toString(),
                            softWrap: true,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "date".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickupdate'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "time".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 20, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickuptime'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "distance".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickupdistance'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "estimate".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['pickupestimate'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          width: 120,
                          child: Text(
                            "transactionid".tr(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15, top: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            widget.data['transactionid'].toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 55,
      width: MediaQuery.of(context).size.width * (95 / 100),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 80,
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              margin: EdgeInsets.only(top: 5),
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Arrival Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: 100,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "Title",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 16),
              child: Text(
                "Company",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     width: 90,
          //     // margin: EdgeInsets.only(right: 90),
          //     child: Text(
          //       "",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //     )),
          // Spacer(),
          // Container(
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //   "Shipment Comapny",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          // Spacer(),
          // Container(
          //     width: 100,
          //     margin: EdgeInsets.only(right: 20),
          //     child: Text(
          //       "Company",
          //       style: TextStyle(fontWeight: FontWeight.bold),
          //
          //
          Container(
              width: 120,
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "Action",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 80,
            width: MediaQuery.of(context).size.width * (98 / 100),
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF).withOpacity(0.5),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 80,
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      widget.data['bid'].toString(),
                      //{widget.data['id']}.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.data['bdate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                Container(
                    width: 100,
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      widget.data['arrivaldate'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                // Container(
                //     width: 100,
                //     // margin: EdgeInsets.only(left: 20),
                //     child: Text(
                //       widget.data['title'].toString(),
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 20),
                    child: Text(
                      widget.data['type'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 120,
                    margin: EdgeInsets.only(right: 15),
                    child: Text(
                      widget.data['company'].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                InkWell(
                  onTap: () {
                    var id = widget.data['bid'].toString();
                    var type = widget.data['type'].toString();
                    var bookingdate = widget.data['bdate'].toString();
                    var status = widget.data['status'].toString();

                    print(id);

                    print(type);
                    print(bookingdate);
                    print(status);
                    print(widget.data['pickuptype']);

                    widget.data['pickuptype'] == "Pick up"
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogBoxx(
                                id,
                                type,
                                bookingdate,
                                status,
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                '',
                                ''))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogBoxArrivalDropOff(
                                    id,
                                    type,
                                    bookingdate,
                                    status,
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    '',
                                    ''));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => SelectAgent(
                    //           pid: shipmentOrder![index].pickupagentId,
                    //           bid: shipmentOrder![index].id)),
                    // );
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 10),
                      height: MediaQuery.of(context).size.height * (5 / 100),
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      // width:
                      child: Center(
                        child: Text(
                          "View Path",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      )),
                ),

                // Container(
                //     width: 80,
                //     // margin: EdgeInsets.only(right: 30),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
                // Spacer(),
                // Container(
                //     margin: EdgeInsets.only(left: 30),
                //     child: Text(
                //       "CMA CGM",
                //       // style: TextStyle(fontWeight: FontWeight.bold),
                //     )),

                // Container(
                //     width: 100,
                //     margin: EdgeInsets.only(right: 20),
                //     child: Text(
                //       "",
                //       style:
                //           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                //     )),
              ],
            ),
          );
        });
  }
}
