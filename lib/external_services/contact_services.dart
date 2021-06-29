// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';

class Services{
  Future<Contact> contacts()  async {
    final ContactPicker _contactPicker =  new ContactPicker();
    return await _contactPicker.selectContact();
  }
  }