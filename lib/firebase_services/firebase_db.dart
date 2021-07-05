import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sas_application/models/user_model.dart';

class FirebaseDbService {
  final instance = FirebaseFirestore.instance;

  Future<void> addUserData(UserModel userModel) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.userId)
        .set({
          'full_name': userModel.fullName,
          'e-mail id': userModel.emailAddress,
          'userId': userModel.userId
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add: $error"));
  }

  Future<void> addEmergencyContact(
      String contactName, String contactNumber, String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("emergencyContacts")
        .doc()
        .set({
          'emergencyContactName': contactName,
          'emergencyContactNumber': contactNumber,
          'userId': uid
        })
        .then((value) => print("Contact Added"))
        .catchError((error) => print("Failed to add: $error"));
  }

  Future<void> updateUserData(UserModel userModel) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.userId)
        .update({
          'full_name': userModel.fullName,
          'e-mail id': userModel.emailAddress,
          'userId': userModel.userId,
          'phone_number': userModel.phoneNumber,
          'gender': userModel.gender,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add: $error"));
  }
}
