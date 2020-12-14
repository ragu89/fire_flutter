import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User _user;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Center(child: _signInWithGoogleButton());
    } else {
      return Center(child: Text("Welcome aboard ${_user.displayName} !"));
    }
  }

  ElevatedButton _signInWithGoogleButton() {
    return ElevatedButton(
      onPressed: () async {
        var userCredential = await signInWithGoogle();
        print("Signed id with user: ${userCredential.user}");

        setState(() {
          _user = userCredential?.user;
        });
      },
      child: Text("Sign in with Google"),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
