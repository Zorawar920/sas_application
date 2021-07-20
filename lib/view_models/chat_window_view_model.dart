import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sas_application/models/firebase_model.dart';

class ChatWindowViewModel extends FireBaseModel {


  getEmergencyContactName() async {
    var data = await _fireBaseModel.firebaseDbService.instance
        .collectionGroup("emergencyContacts")
        .where("userId", isEqualTo: _fireBaseModel.auth.currentUser!.uid)
        .get();
    return data.docs.map((e) => e.data()).toList();
  }

  Future<List> getWhoAddedMeList() async {
    
    var userPhone = await _fireBaseModel.firebaseDbService.instance
        .collection("users")
        .doc(_fireBaseModel.auth.currentUser!.uid)
        .get(GetOptions(source: Source.cache));

    var snapshots = await _fireBaseModel.firebaseDbService.instance
        .collectionGroup("emergencyContacts")
        .where("emergencyContactNumber", isEqualTo: userPhone['phone_number'])
        .get();

    final allData = snapshots.docs.map((doc) => doc.data()).toList();
    List whoAddedMe = [];
    for (Map map in allData) {
      var snapshot = await _fireBaseModel.firebaseDbService.instance
          .collection("users")
          .doc(map['userId'])
          .get();
      var userData = snapshot.data();
      whoAddedMe.add({
        'Name': userData!["full_name"],
        'Phone': userData['phone_number'],
        'userId': userData['userId']
      });
    }
    return whoAddedMe;
  }
}
