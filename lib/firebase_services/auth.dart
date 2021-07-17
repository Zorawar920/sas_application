import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sas_application/firebase_services/firebase_db.dart';
import 'package:sas_application/models/user_model.dart';


abstract class AuthBase {
  User? get currentUser;
  bool isPhoneVerified = false;

  Future<User?> signInAnonymously();
  Future<User?> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithGoogle(UserModel usermodel);
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future forgotPasswordWithEmail(String email);
  Future<void> verifyNumber(
      String phone, BuildContext context, String docId, String uid);
}

class Auth implements AuthBase {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  var _codeController = TextEditingController();
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

  @override
  bool isPhoneVerified = false;

  Future<User?> signInWithGoogle(UserModel usermodel) async {
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
        if (userCredential.additionalUserInfo!.isNewUser) {
          usermodel.userId = currentUser!.uid;
          usermodel.emailAddress = currentUser!.email.toString();
          usermodel.fullName = currentUser!.displayName.toString();
          await FirebaseDbService().addUserData(usermodel);
        }
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
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      user!.sendEmailVerification();
      return user;
    } catch (e) {
      print(e.toString());
    }
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
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> verifyNumber(
      String phone, context, String docId, String uid) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 120),

      verificationCompleted: (AuthCredential credential) async {},

      verificationFailed: (FirebaseAuthException e) {
        isPhoneVerified = false;
        showPlatformDialog(
            context: context,
            builder: (context) {
              return BasicDialogAlert(
                title: Text("Phone Verification"),
                content: Text(e.message.toString()),
                actions: [
                  BasicDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      title: Text("OK"))
                ],
              );
            });
        print(e);
      },

      codeSent: (String verificationId, [int? forceResendingToken]) {
        showPlatformDialog(
            context: context,
            builder: (context) {
              return BasicDialogAlert(
                title: Text("Phone Verification"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Enter the verification code:'),
                    SizedBox(height: 5.0),
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: [
                  BasicDialogAction(
                      onPressed: () async {
                        final code = _codeController.text.trim();

                        try {
                          AuthCredential authCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          UserCredential result = await _auth.currentUser!
                              .linkWithCredential(authCredential);
                          User? user = result.user;

                          if (user != null) {
                            print('Number Verified');
                            isPhoneVerified = true;
                            if (docId.isNotEmpty) {
                              FirebaseDbService fdb = new FirebaseDbService();
                              fdb.updateEmergencyContact(uid, docId, true);
                            }
                            numberVerified(context);
                            unLinkContact();
                          } else {
                            print("Error");
                            isPhoneVerified = false;
                            showPlatformDialog(
                                context: context,
                                builder: (context) {
                                  return BasicDialogAlert(
                                    title: Text("Phone Verification"),
                                    content: Text(
                                        "Phone number not verified. Please try again."),
                                    actions: [
                                      BasicDialogAction(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          title: Text("OK"))
                                    ],
                                  );
                                });
                          }
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "invalid-verification-code":
                              isPhoneVerified = false;
                              showPlatformDialog(
                                  context: context,
                                  builder: (context) {
                                    return BasicDialogAlert(
                                      title: Text("Phone Verification"),
                                      content: Text(
                                          "OTP entered is not correct. Please enter correct OTP"),
                                      actions: [
                                        BasicDialogAction(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            title: Text("OK"))
                                      ],
                                    );
                                  });
                          }
                        }
                        //Navigator.of(context).pop();
                      },
                      title: Text("Confirm")),
                  BasicDialogAction(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    title: Text("Close"),
                  )
                ],
              );
            });
      },

      codeAutoRetrievalTimeout: (String verificationId) {},
      //codeAutoRetrievalTimeout: null
    );
  }

  void numberVerified(BuildContext context) {
    showPlatformDialog(
        context: context,
        builder: (context) {
          return BasicDialogAlert(
            title: Text("Phone Verification"),
            content: Text("Phone number is verified"),
            actions: [
              BasicDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    _codeController.text = "";
                  },
                  title: Text("OK"))
            ],
          );
        });
  }

  void unLinkContact() async {
    try {
      List<UserInfo> list = FirebaseAuth.instance.currentUser!.providerData;
      print(PhoneAuthProvider.PROVIDER_ID + " PROVIDER ID");
      list.forEach((element) async => {
            if (element.providerId == PhoneAuthProvider.PROVIDER_ID)
              {
                await FirebaseAuth.instance.currentUser!
                    .unlink(element.providerId)
              }
          });
    } on FirebaseAuthException catch (e) {
      print("Error $e");
    }
  }
}
