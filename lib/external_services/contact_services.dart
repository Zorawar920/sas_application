import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class Services {
  Future<PhoneContact?> contacts() async {
    final PhoneContact contact = await FlutterContactPicker.pickPhoneContact();
    return contact;
  }
}
