import 'package:flutter/material.dart';

BoxDecoration linearGradientForWorkspaceAndLogin() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xff2D2C2F).withOpacity(0.9),
        Color(0xff2F2E31).withOpacity(0.9),
        Color(0xff333235).withOpacity(0.9),
        Color(0xff4D4D4E).withOpacity(0.9),
        Color(0xff626363).withOpacity(0.9),
        Color(0xff676869).withOpacity(0.9),
        Color(0xff6A6B6B).withOpacity(0.9),
        Color(0xff737475).withOpacity(0.9),
      ],
    ),
  );
}

BoxDecoration linearGradientForWhiteScreen() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFFFFF),
        Color(0xffDCDEE1),
      ],
    ),
  );
}

BoxDecoration linearGradientForWhiteCard() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFFFFF),
        Color(0xffEEEEEE),
      ],
    ),
  );
}

LinearGradient linearGradientForList() {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffFFFFFF),
      Color(0xffDCDEE1),
    ],
  );
}

BoxDecoration linearGradientForDeficiencyCard() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(25)),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFFFFF),
        Color(0xffEEEEEE),
      ],
    ),
  );
}

BoxDecoration linearGradientForMap() {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25), topRight: Radius.circular(25)),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFFFFF),
        Color(0xffEEEEEE),
      ],
    ),
  );
}

BoxDecoration linearGradientForCameraSettingsCard() {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xffFFFFFF),
        Color(0xffEEEEEE),
      ],
    ),
  );
}
