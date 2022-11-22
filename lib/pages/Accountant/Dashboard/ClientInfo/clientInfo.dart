import 'package:flutter/material.dart';
import 'package:shipment/Element/TextStyle.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';

class ClientInfo extends StatefulWidget {
  final String id;

  const ClientInfo({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ClientInfo> {
  var id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      id = widget.id.toString();
      print('>>>>>   $id');
      clientbookingsApi();
    });
  }

  List<DataResponse>? data1 = [];
  String? client, bookingId, bookingdate, scheduleId;
  List<Client>? clientinfo;
  List<Item>? item;

  clientbookingsApi() async {
    var data = {"schedule_id": id.toString()};

    var res = await Providers().shipmentClientBooking(data);
    if (res.status == true) {
      setState(() {
        data1 = res.data;
      });
      for (int i = 0; i < data1!.length; i++) {
        clientinfo = data1![i].client;
        item = data1![i].item;
        for (int j = 0; j < item!.length; j++) {
          bookingId = item![j].bookingId.toString();
          scheduleId = item![j].scheduleId.toString();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("shffffffffff" + widget.aboutme.toString());
    return Container(
        child: Column(children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Credentials",
          style: headingStyle16blackw600(),
        ),
      ),
      Row(children: [
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Language",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Address",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Country",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                  ],
                )),
            // Padding(
            //   padding: const EdgeInsets.only(top: 30),
            //   child: Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(
            //             // top: 40,

            //             ),
            //         child: Text(
            //           clientinfo![0].language.toString(),
            //           style: headingStyle14blackw500(),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 20),
            //         child: Text(
            //           clientinfo![0].address.toString(),
            //           style: headingStyle14blackw500(),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(
            //           top: 20,
            //         ),
            //         child: Text(
            //           clientinfo![0].country.toString(),
            //           style: headingStyle14blackw500(),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 70, top: 38),
            //   child: Column(
            //     children: [
            //       Row(
            //         children: [
            //           Padding(
            //             padding: EdgeInsets.only(left: 40),
            //             child: Container(
            //               child: Text(
            //                 "Status",
            //                 style: headingStyle14greyw500(),
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             width: 130,
            //           ),
            //           Container(
            //             child: Text(
            //               clientinfo![0].status.toString(),
            //               style: headingStyle14blackw500(),
            //             ),
            //           ),
            //         ],
            //       ),
            //       Row(
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(left: 30),
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   padding:
            //                       const EdgeInsets.only(right: 33, top: 20),
            //                   child: Text(
            //                     "MobileNumber",
            //                     style: headingStyle14greyw500(),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding:
            //                       const EdgeInsets.only(right: 75, top: 20),
            //                   child: Text(
            //                     "AboutMe",
            //                     style: headingStyle14greyw500(),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(left: 10, top: 20),
            //             child: Column(
            //               children: [
            //                 Padding(
            //                   padding:
            //                       const EdgeInsets.only(left: 30, bottom: 10),
            //                   child: Text(
            //                     clientinfo![0].phone.toString(),
            //                     style: headingStyle14blackw500(),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.only(
            //                     left: 30,
            //                     top: 10,
            //                   ),
            //                   child: Text(
            //                     clientinfo![0].about_me.toString(),
            //                     style: headingStyle14blackw500(),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60, top: 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    // top: 40,

                    ),
                child: Text(
                  clientinfo![0].language.toString(),
                  style: headingStyle14blackw500(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  clientinfo![0].address.toString(),
                  style: headingStyle14blackw500(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  clientinfo![0].country.toString(),
                  style: headingStyle14blackw500(),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 70, top: 38),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 100,
                    child: Text(
                      "Status",
                      style: headingStyle14greyw500(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Text(
                    "MobileNumber",
                    style: headingStyle14greyw500(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Container(
                    width: 100,
                    child: Text(
                      "aboutme",
                      style: headingStyle14greyw500(),
                    ),
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.only(
            top: 38,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                ),
                child: Container(
                  width: 500,
                  child: Text(
                    clientinfo![0].status.toString(),
                    style: headingStyle14blackw500(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 20,
                ),
                child: Container(
                  width: 500,
                  child: Text(
                    clientinfo![0].phone.toString(),
                    // widget.aboutme,
                    style: headingStyle14blackw500(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50,
                  top: 20,
                ),
                child: Container(
                  width: 500,
                  child: Text(
                    clientinfo![0].about_me.toString(),
                    style: headingStyle14blackw500(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    ]));
  }
}
