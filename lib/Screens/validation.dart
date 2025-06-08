bool isValidEmail(String? text) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(text!);
}
bool isValidPass(String? text) {
  return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~-]).{8,16}$')
      .hasMatch(text!);
}
bool isValidContact(String? text) {
  return text!.startsWith("20")&&text.length==12?true:false;
}