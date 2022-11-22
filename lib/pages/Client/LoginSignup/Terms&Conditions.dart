import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../Element/Responsive.dart';

class TermsConditon extends StatefulWidget {
  const TermsConditon({Key? key}) : super(key: key);

  @override
  State<TermsConditon> createState() => _TermsConditonState();
}

class _TermsConditonState extends State<TermsConditon> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.disabled_by_default,
                          size: (Responsive.isDesktop(context)) ? 42 : 28,
                        )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12),
                // color: Colors.red,
                padding: const EdgeInsets.only(top: 2),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.9,

                child: Html(
                  data:
                      "<p>. <b>Our Privacy Policy also governs your use of our Service and explains how we collect, safeguard and disclose information that results from your use of our web pages.</b> Your agreement with us includes these Terms and our Privacy Policy (“Agreements”). You acknowledge that you have read and understood Agreements, and agree to be bound of them.</b>By using our Service, you agree to subscribe to newsletters, marketing or promotional materials and other information we may send. However, you may opt out of receiving any, or all, of these communications from us by following the unsubscribe link or by emailing at ankitakushwahemasterr@gmail.com</p>, ",
                  shrinkWrap: true,
                  style: {
                    "body": Style(
                        // margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        color: Colors.black,
                        fontSize: FontSize(16),
                        fontWeight: FontWeight.w400),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
