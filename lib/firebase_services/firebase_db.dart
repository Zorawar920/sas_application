import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sas_application/models/user_model.dart';

class FirebaseDbService {
  final instance = FirebaseFirestore.instance;
  String emergencyContactUserId = "";
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

  Future<void> addEmergencyContact(String contactName, String contactNumber,
      String uid, bool verified) async {
    emergencyContactUserId = "";
    var dataIdSnapshot = await FirebaseFirestore.instance
        .collectionGroup("users")
        .where("phone_number", isEqualTo: contactNumber)
        .get();

    if (dataIdSnapshot.docs.isNotEmpty) {
      var data = dataIdSnapshot.docs.single;
      emergencyContactUserId = data['userId'];
    }

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("emergencyContacts")
        .doc()
        .set({
          'emergencyContactName': contactName,
          'emergencyContactNumber': contactNumber,
          'userId': uid,
          'verified': verified,
          'emergencyContactUserId': emergencyContactUserId
        })
        .then((value) => print("Contact Added"))
        .catchError((error) => print("Failed to add: $error"));
  }

  Future<void> updateUserData(_userId, phoneNumber, gender, code) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(_userId)
        .update({
          'phone_number': phoneNumber,
          'gender': gender,
          'country code': code,
        })
        .then((value) => print("Additional User Details Added"))
        .catchError((error) => print("Failed to add: $error"));
  }

  Future<void> updateUserProfileData(UserModel userModel, details) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.userId)
        .update({
          'full_name': userModel.fullName,
          'phone_number': userModel.phoneNumber,
          'gender': userModel.gender,
          'e-mail id': userModel.emailAddress
        })
        .then((value) => print(" User Details Updated"))
        .catchError((error) => print("Failed to add: $error"));
  }

  Future<void> updateEmergencyContact(
      String uid, String docId, bool verified) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("emergencyContacts")
        .doc(docId)
        .update({'verified': verified})
        .then((value) => print("Emergency Contact Updated"))
        .catchError((e) => print(e));
  }

  Future<void> addTimeStamp(String uid, int timeStamp) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({'timeStamp': timeStamp})
        .then((value) => print("TimeStamp Added"))
        .catchError(
            (onError) => print("Error while adding timeStamp $onError"));
  }
}
