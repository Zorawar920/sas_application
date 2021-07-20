import 'package:sas_application/models/firebase_model.dart';

class UserProfileViewModel extends FireBaseModel{

  final FireBaseModel _fireBaseModel = new FireBaseModel();

   Future<String> getCode() async{
    var userDetail = await _fireBaseModel.firebaseDbService.instance
        .collection("users")
        .doc(_fireBaseModel.auth.currentUser!.uid)
        .get();

    var doc = await _fireBaseModel.firebaseDbService.instance
        .collectionGroup("users")
        .where("phone_number", isEqualTo: userDetail["phone_number"])
        .get();
    var phoneNumber = doc.docs.toList();
    var initialCode;
    phoneNumber.forEach((element) {
      var code = element["phone_number"].toString().substring(0, element["phone_number"].toString().length -10);

      if (code == '+91') {
        initialCode = 'IN';

      }
      if (code == '+1') {
        initialCode = 'CA';
      }
    });

    return initialCode;

  }

}