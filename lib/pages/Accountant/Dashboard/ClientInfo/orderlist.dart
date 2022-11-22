import 'package:flutter/material.dart';
import 'package:shipment/Model/Shipment/showClientBookingModel.dart';
import 'package:shipment/Provider/Provider.dart';

class OrderList extends StatefulWidget {
  final String Id;
  const OrderList({Key? key, required this.Id}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderList> {
  List<DataResponse>? data1;
  int? index;

  String? client, orderId, bookingdate, title, from, to, type;
  List<Client>? clientinfo;
  List<Item>? item;
  String? name,
      lname,
      email,
      country1,
      address1,
      language1,
      aboutme1,
      status,
      mobilenumber;

  clientbookingsApi() async {
    var data = {"schedule_id": widget.Id};

    var res = await Providers().shipmentClientBooking(data);
    if (res.status == true) {
      setState(() {
        data1 = res.data;
      });
      for (int i = 0; i < data1!.length; i++) {
        clientinfo = data1![i].client;
        item = data1![i].item;
        for (int j = 0; j < item!.length; j++) {
          orderId = item![j].id.toString();
        }
        for (int j = 0; j < clientinfo!.length; j++) {
          name = clientinfo![j].name;
          lname = clientinfo![j].lname;
          email = clientinfo![j].email;
          language1 = clientinfo![j].language;
          country1 = clientinfo![j].country.toString();
          aboutme1 = clientinfo![j].about_me.toString();
          status = clientinfo![j].status;
          mobilenumber = clientinfo![j].phone;
          address1 = clientinfo![j].address.toString();
        }
        title = data1![i].title.toString();
        type = data1![i].bookingType.toString();
        from = data1![i].from.toString();
        to = data1![i].to.toString();
        bookingdate = data1![i].bookingDate.toString();
      }
      print("""""" """""" """object""" """""" """""" + orderId.toString());
      print("""""" """""" """object""" """""" """""" + name.toString());
      print("""""" """""" """object""" """""" """""" + address1.toString());
      print("""""" """""" """object""" """""" """""" + aboutme1.toString());
      print("""""" """""" """object""" """""" """""" + country1.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clientbookingsApi();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      orderTemplate(),
      data1 != null
          ? Container(height: 800, child: orderDetails())
          : Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text("No More Bookings "),
            )
    ]));
  }

  Widget orderTemplate() {
    return Container(
      // height: (!Responsive.isDesktop(context))
      //     ? MediaQuery.of(context).size.height * (10 / 100)
      //     : MediaQuery.of(context).size.height * (45 / 100),
      height: 28,
      width: MediaQuery.of(context).size.width * (90 / 100),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffFFFFFF),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: 100,
              // margin: EdgeInsets.only(left: 10),
              child: Text(
                "Order ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 70),
              child: Text(
                "Booking Date",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "From",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 90),
              child: Text(
                "To",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          // Spacer(),
          // Container(
          //     // margin: EdgeInsets.only(left: 20),
          //     child: Text(
          //   "Shipment Comapny",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // )),
          // Spacer(),
          Container(
              width: 100,
              // margin: EdgeInsets.only(right: 30),
              child: Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget orderDetails() {
    return ListView.builder(
        itemCount: data1!.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            // height: (!Responsive.isDesktop(context))
            //     ? MediaQuery.of(context).size.height * (10 / 100)
            //     : MediaQuery.of(context).size.height * (45 / 100),
            height: 40,
            width: MediaQuery.of(context).size.width * (90 / 100),
            margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffFFFFFF),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 100,
                    // margin: EdgeInsets.only(left: 20),
                    child: Text(
                      data1![index].id.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(left: 10),
                    child: Text(
                      data1![index].bookingDate,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(left: 20),
                    child: Text(
                      data1![index].title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 20),
                    child: Text(
                      data1![index].bookingType,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      data1![index].from,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 30),
                    child: Text(
                      data1![index].to,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
                // Spacer(),
                // Container(
                //     margin: EdgeInsets.only(left: 30),
                //     child: Text(
                //       "CMA CGM",
                //       // style: TextStyle(fontWeight: FontWeight.bold),
                //     )),

                Container(
                    width: 100,
                    // margin: EdgeInsets.only(right: 5),
                    child: Text(
                      data1![index].status,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    )),
              ],
            ),
          );
        });
  }
}
