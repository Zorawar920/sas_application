class UserModel {
  final String userId;
  final String fullName;
  final String emailAddress;
  final String phoneNumber;
  final String gender;

  UserModel(
      { required this.userId,
      required this.emailAddress,
      required this.fullName,
      required this.phoneNumber,
      required this.gender});

}
