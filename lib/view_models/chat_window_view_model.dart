import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/models/firebase_model.dart';

class ChatWindowViewModel extends FireBaseModel {
  final FireBaseModel _fireBaseModel = new FireBaseModel();

  getEmergencyContactName() async {
    var data = await _fireBaseModel.firebaseDbService.instance
        .collectionGroup("emergencyContacts")
        .where("userId", isEqualTo: _fireBaseModel.auth.currentUser!.uid)
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  Future<List> getWhoAddedMeList() async {
    List whoAddedMe = [];

    var emergencyContactsPresent = await _fireBaseModel
        .firebaseDbService.instance
        .collectionGroup("emergencyContacts")
        .get();

    if (emergencyContactsPresent.docs.isNotEmpty) {
      var userPhone = await _fireBaseModel.firebaseDbService.instance
          .collection("users")
          .doc(_fireBaseModel.auth.currentUser!.uid)
          .get(GetOptions(source: Source.serverAndCache));

      var phoneNumberList = emergencyContactsPresent.docs.where((element) =>
          element['emergencyContactNumber'] == userPhone['phone_number']);

      if (phoneNumberList.isNotEmpty) {
        for (var phoneNumber in phoneNumberList) {
          var userDetails = await _fireBaseModel.firebaseDbService.instance
              .collection("users")
              .doc(phoneNumber['userId'])
              .get();

          var userDetailsData = userDetails.data();
          whoAddedMe.add({
            'Name': userDetailsData!["full_name"],
            'Phone': userDetailsData['phone_number'],
            'userId': userDetailsData['userId']
          });
        }
      }
    }
    return whoAddedMe;
  }

  Future<List> getUsers() async {
    List users = [];

    var dataShots = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("emergencyContacts")
        .get(GetOptions(source: Source.cache));

    var data = dataShots.docs;
    for (var map in data) {
      users.add({
        "emergencyContactName": map['emergencyContactName'],
        "emergencyContactNumber": map['emergencyContactNumber'],
        "userId": map['emergencyContactUserId'],
        "color": map['emergencyContactUserId'] == ""
            ? Colors.redAccent
            : Colors.grey,
        "color2":
            map['emergencyContactUserId'] == "" ? Colors.grey : Colors.green,
        "color3": Colors.grey
      });
    }

    var whoAddedMeList = await getWhoAddedMeList();

    for (var whoAddedMeListDetails in whoAddedMeList) {
      if (users.isEmpty) {
        users.add({
          "emergencyContactName": whoAddedMeListDetails['Name'],
          "emergencyContactNumber": whoAddedMeListDetails['Phone'],
          "userId": whoAddedMeListDetails['userId'],
          "color": Colors.grey,
          "color2": Colors.grey,
          "color3": Colors.orangeAccent
        });
      } else if (users.isNotEmpty) {
        int counter = 0;
        List id = [];
        try {
          for (Map user in users) {
            counter += 1;
            id.add(user['userId']);
            if (user['userId'] == whoAddedMeListDetails['userId']) {
              user['color3'] = Colors.orangeAccent;
            } else if (user['userId'] != whoAddedMeListDetails['userId'] &&
                users.length == counter &&
                !id.contains(whoAddedMeListDetails['userId'])) {
              users.add({
                "emergencyContactName": whoAddedMeListDetails['Name'],
                "emergencyContactNumber": whoAddedMeListDetails['Phone'],
                "userId": whoAddedMeListDetails['userId'],
                "color": Colors.grey,
                "color2": Colors.grey,
                "color3": Colors.orangeAccent
              });
            }
          }
        } catch (error) {
          print("Error while adding WhoAddedMeList $error");
        }
      }
    }
    print(users);
    return users;
  }
}
