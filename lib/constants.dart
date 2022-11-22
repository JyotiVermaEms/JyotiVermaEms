import 'dart:math';

import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF366CF6);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kDefaultPadding = 20.0;
const kGoogleApiKey = "AIzaSyC6NMl5VVe0jDn5EYrKqrHa6GZxFFk2AoQ";

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

//https://maps.googleapis.com/maps/api/place/textsearch/json?query=indore

int touchedIndex = -1;

String paymentURL = "https://shipment.engineermaster.in/stripe";
String mobilepaymentURL = "https://shipment.engineermaster.in/stripemob";


// http://44.194.48.17/stripe?order_id=2&uid=753&type=subscription
