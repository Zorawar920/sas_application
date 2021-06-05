import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  // ignore: unused_field
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  //Stream<User> get authStateChanges => _firebaseAuth.instance.idTokenChanges();
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn() async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: "email", password: "password");
      return "User Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp() async {
    try {} on FirebaseAuthException catch (e) {}
  }
}
