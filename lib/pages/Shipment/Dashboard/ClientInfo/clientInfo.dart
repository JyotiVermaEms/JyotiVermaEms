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
  List<ReceptionistInfo>? receptionistInfo;

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

        receptionistInfo = data1![i].receptionistInfo;

        for (int j = 0; j < item!.length; j++) {
          bookingId = item![j].bookingId.toString();
          scheduleId = item![j].scheduleId.toString();
        }
      }
    }
  }

  var h, w;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
          child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Credentials",
            style: headingStyle16blackw600(),
          ),
        ),
        Container(
          height: h * 0.35,
          child: Scrollbar(
            isAlwaysShown: true,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Row(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 30),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Language",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 10),
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Text(
                          "Address",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Country",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          width: 300,
                          child: Text(
                            clientinfo![0].language.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 10),
                        child: Container(
                          height: 50,
                          width: 300,
                          child: Text(
                            clientinfo![0].address.toString(),
                            style: headingStyle14blackw500(),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Container(
                          width: 300,
                          child: Text(
                            clientinfo![0].country.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 30),
                      child: Container(
                        width: 100,
                        child: Text(
                          "Status",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 10),
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Text(
                          "MobileNumber",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, right: 10),
                      child: Container(
                        width: 100,
                        child: Text(
                          "aboutme",
                          style: headingStyle14greyw500(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Container(
                          width: 300,
                          child: Text(
                            clientinfo![0].status.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 10),
                        child: Container(
                          height: 50,
                          width: 300,
                          child: Text(
                            clientinfo![0].phone.toString(),
                            style: headingStyle14blackw500(),
                            softWrap: true,
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 500,
                        child: SingleChildScrollView(
                          child: Text(
                            clientinfo![0].about_me.toString(),
                            softWrap: true,
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ]),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          color: Colors.black,
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Receptionist Details",
              style: headingStyle16blackw600(),
            ),
          ),
          Container(
            height: h * 0.35,
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView(scrollDirection: Axis.horizontal, children: [
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
                                    "Name",
                                    style: headingStyle14greyw500(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    "Email",
                                    style: headingStyle14greyw500(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    "Phone number",
                                    style: headingStyle14greyw500(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: Container(
                                  width: 100,
                                  child: Text(
                                    "Address",
                                    style: headingStyle14greyw500(),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, top: 38),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              // top: 40,

                              ),
                          child: Text(
                            receptionistInfo![0].receptionistName.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            receptionistInfo![0].receptionistEmail.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            receptionistInfo![0].receptionistPhone.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Text(
                            receptionistInfo![0].receptionistAddress.toString(),
                            style: headingStyle14blackw500(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ]))
      ])),
    );
  }
}
