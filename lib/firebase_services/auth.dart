import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sas_application/firebase_services/firebase_db.dart';
import 'package:sas_application/models/user_model.dart';

abstract class AuthBase {
  User? get currentUser;
  Future<User?> signInAnonymously();
  Future<User?> signOut();
  Stream<User?> authStateChanges();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future forgotPasswordWithEmail(String email);
  Future<void>VerifyNumber(TextEditingController phoneController, BuildContext context);
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
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = new UserModel(
              userId: userCredential.user!.uid,
              emailAddress: userCredential.user!.email.toString(),
              fullName: userCredential.user!.displayName.toString(),
              phoneNumber: "",
              gender: "");
          await FirebaseDbService().addUserData(userModel);
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
    // TODO: implement forgotPasswordWithEmail

    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> VerifyNumber( TextEditingController phoneController, context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(

        phoneNumber: phoneController.text,
        timeout: Duration(seconds: 10),
        verificationCompleted: (AuthCredential credential) async
        {
          Navigator.of(context).pop();
          final result = await _auth.signInWithCredential(credential);
          final user = result.user;
          if(user != null){
            await FirebaseAuth.instance.currentUser!.delete();
            print('Number Verified');
            showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text("Phone Verification"),
                    content: Text("Your phone Number is verified"),
                    actions: [
                      BasicDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          title: Text("OK"))
                    ],
                  );
                });
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },

        verificationFailed: (FirebaseAuthException e){
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

        codeSent: (String verificationId, [int? forceResendingToken])
        {
          showPlatformDialog(
              context: context,
              builder: (context) {
                return BasicDialogAlert(
                  title: Text("Phone Verification"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[Text('Enter the verification code:'),
                      SizedBox(height: 5.0),
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: [
                    BasicDialogAction(
                      onPressed: ()async {
                        final code = _codeController.text.trim();
                        AuthCredential authCredential = PhoneAuthProvider
                            .credential(
                            verificationId: verificationId, smsCode: code);
                        print(authCredential.providerId.toString());
                        UserCredential result = await _auth
                            .signInWithCredential(authCredential);
                        User? user = result.user;


                        if (user != null) {
                          await FirebaseAuth.instance.currentUser!.delete();
                          print('Number Verified');
                          numberVerified(context);
                        }
                        else{
                          print("Error");
                          showPlatformDialog(
                              context: context,
                              builder: (context) {
                                return BasicDialogAlert(
                                  title: Text("Phone Verification"),
                                  content: Text("Phone number not verified. Please try again."),
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
                        //Navigator.of(context).pop();
                      },
                      title: Text("Confirm")
                    ),
                    BasicDialogAction(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      title: Text("Close"),
                    )
                  ],
                );
              }
          );
        },

      codeAutoRetrievalTimeout: (String verificationId) {  },
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
                },
                title: Text("OK"))
          ],
        );
      });
}
}

