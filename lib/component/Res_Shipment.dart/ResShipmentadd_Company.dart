// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shipment/Element/Responsive.dart';
import 'package:shipment/component/Res_Shipment.dart/Shipment_Sidebar.dart';
import 'package:shipment/pages/Shipment/ShipmentProfile/addCompany_details.dart';

class ResShipmentAdd_Company extends StatefulWidget {
  const ResShipmentAdd_Company({Key? key}) : super(key: key);

  @override
  State<ResShipmentAdd_Company> createState() => _ResShipmentAdd_CompanyState();
}

class _ResShipmentAdd_CompanyState extends State<ResShipmentAdd_Company> {
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: AddCompanyDetails(),
        tablet: AddCompanyDetails(),
        desktop: Row(
          children: [
            // Once our width is less then 1300 then it start showing errors
            // Now there is no error if our width is less then 1340
            Expanded(
              flex: _size.width > 1340 ? 1 : 2,
              child: ShipmentSidebar(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 4 : 5,
              child: AddCompanyDetails(),
            ),
            // Expanded(
            //   flex: _size.width > 1340 ? 8 : 10,
            //   child: EmailScreen(),
            // ),
          ],
        ),
      ),
    );
  }
}
