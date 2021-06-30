import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sas_application/models/firebase_model.dart';

class EmergencyContactViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  bool? _hasPermission;
  Contact? contact;

  Future<void> askPermissions(BuildContext context) async {
    PermissionStatus? permissionStatus;
    while (permissionStatus != PermissionStatus.granted) {
      try {
        permissionStatus = await getContactPermission();
        if (permissionStatus != PermissionStatus.granted) {
          _hasPermission = false;
          handleInvalidPermissions(permissionStatus);
        } else {
          _hasPermission = true;
        }
      } catch (e) {
        if (await showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text('Contact Permissions'),
                    content: Text(
                        'We are having problems retrieving permissions.  Would you like to '
                        'open the app settings to fix?'),
                    actions: [
                      BasicDialogAction(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        title: Text('Close'),
                      ),
                      BasicDialogAction(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        title: Text('Settings'),
                      ),
                    ],
                  );
                }) ==
            true) {
          await openAppSettings();
        }
      }
    }
  }

  Future<PermissionStatus> getContactPermission() async {
    final status = await Permission.contacts.status;
    if (!status.isGranted) {
      final result = await Permission.contacts.request();
      return result;
    } else {
      return status;
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to contacts data denied',
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw PlatformException(
          code: 'PERMISSION_DISABLED',
          message: 'Contacts data is not available on device',
          details: null);
    }
  }

  Future<void> getContactDetails(BuildContext context) async {
    try {
      if (_hasPermission == true) {
        contact = await _fireBaseModel.services.contacts();
      } else {
        if (await showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text('Contact Permissions'),
                    content: Text(
                        'We are having problems retrieving permissions.  Would you like to '
                        'open the app settings to fix?'),
                    actions: [
                      BasicDialogAction(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        title: Text('Close'),
                      ),
                      BasicDialogAction(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        title: Text('Settings'),
                      ),
                    ],
                  );
                }) ==
            true) {
          await openAppSettings();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String? validatePhone(phoneValue) {
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);
    if (phoneValue.isEmpty) {
      return 'Please Enter Phone Number';
    } else if (!regExp.hasMatch(phoneValue)) {
      return 'Please Enter Valid Phone Number';
    }
  }

  String? validateName(nameValue) {
    if (nameValue.isEmpty) {
      return 'Please Enter Your Name';
    } else if (nameValue.length >= 20) {
      return 'Name should be less than 20 Characters';
    }
  }
}
