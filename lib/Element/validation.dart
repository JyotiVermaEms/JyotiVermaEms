specialcharacter(val, field) {
  final RegExp nameExp = new RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  if (!nameExp.hasMatch(val))
    return 'Password Should contain Special Charaters.';
}

requiredField(val, field) {
  if (val.isEmpty) {
    return field + ' is required';
  }
}

validEmailField(val, field) {
  final RegExp nameExp =
      new RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z-.]+$');
  if (!nameExp.hasMatch(val)) return 'Please enter valid email address.';
}

phoneNo(val, fieldName) {
  RegExp nameExp = new RegExp(r'^([0-9]{10})$');
  if (val != "") {
    if (val.length != 10)
      return fieldName + " should be 10 charectors long";
    else if (!nameExp.hasMatch(val))
      return fieldName + " should be in correct Indian format";
    return null;
  }
  return null;
}

validpassword(val, fieldavalue) {
  RegExp nameExp = new RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&#])[A-Za-z\d$@$!%*?&]+$');
  if (val != "") {
    if (val.length != 8)
      return fieldavalue +
          " should be 10 charectors long, Must contain at least one lowercase letter,  uppercase letter, one digit, and at least one of the special characters ";
  }
  return null;
}




// validcode(val, fieldcode) {
//   RegExp nameExp = new RegExp(r'^[a-zA-Z0-9_.+-]$');
//   if (val != "") {
//     if (val.length != 6) return fieldcode + " should be 10 charectors long";
//   }
//   return null;
// }
