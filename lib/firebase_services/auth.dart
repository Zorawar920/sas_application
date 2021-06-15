import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInAnonymously();
  Future<User?> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future forgotPasswordWithEmail(String email);
}

class Auth implements AuthBase {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Stream<User?> authStateChanges() => FirebaseAuth.instance.authStateChanges();

  Future<User?> signInAnonymously() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user;
  }

  Future<User?> signOut() async {
    await FirebaseAuth.instance.signOut();

    final signInApi = GoogleSignIn();
    await signInApi.signOut();
  }

  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await FirebaseAuth.instance
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'Error missing google id token',
          message: 'Missing Google Id token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'Error Aborted by User',
        message: 'Sign In aborted by the user',
      );
    }
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    return userCredential.user;
  }

  @override
  Future forgotPasswordWithEmail(String email) async {
    // TODO: implement forgotPasswordWithEmail

    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
