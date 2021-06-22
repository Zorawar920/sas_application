class UserModel {
  late final int id;
  late final String countryCode;
  late final int phonenumber;
  late final int age;
  late final String firstName;
  late final String lastName;
  late final String emergencyContact1;
  late final String emergencyContact2;
  late final String emergencyContact3;
  late final String gender;
  late final String email;
  late final String password;
  late final String googleSignIn;

  UserModel(this.id,
      {this.countryCode = "+91",
      required this.phonenumber,
      required this.age,
      required this.firstName,
      required this.lastName,
      required this.emergencyContact1,
      required this.emergencyContact2,
      required this.emergencyContact3,
      required this.gender,
      required this.email,
      required this.password,
      this.googleSignIn = "NIL"});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'countryCode': countryCode,
      'phonenumber': phonenumber,
      'age': age,
      'firstName': firstName,
      'lastName': lastName,
      'emergencyContact1': emergencyContact1,
      'emergencyContact2': emergencyContact2,
      'emergencyContact3': emergencyContact3,
      'gender': gender,
      'email': email,
      'password': password,
      'googleSignIn': googleSignIn
    };
    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    countryCode = map['countryCode'];
    phonenumber = map['phonenumber'];
    age = map['age'];
    firstName = map['firstName'];
    lastName = map['lastName'];
    emergencyContact1 = map['emergencyContact1'];
    emergencyContact2 = map['emergencyContact2'];
    emergencyContact3 = map['emergencyContact3'];
    gender = map['gender'];
    email = map['email'];
    password = map['password'];
    googleSignIn = map['googleSignIn'];
  }
}
