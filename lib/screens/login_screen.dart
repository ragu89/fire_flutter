import 'package:fire_flutter/model/local_auth_credential.dart';
import 'package:fire_flutter/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoaded = false;
  User _user;
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return Center(child: Text("Welcome aboard ${_user.displayName} !"));
    } else if (_isLoaded == false) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(child: _signInWithGoogleButton());
    }
  }

  Future<void> initAsync() async {
    var localAuthCredential = await _authRepository.getLocalAuthCredential();
    User user;
    if (localAuthCredential != null) {
      var userCredential = await _signInWithGoogle(localAuthCredential);
      user = userCredential.user;
    }
    setState(() {
      _user = user;
      _isLoaded = true;
    });
  }

  ElevatedButton _signInWithGoogleButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _isLoaded = true;
        });
        var userCredential = await _signInWithGoogle(null);
        print("Signed id with user: ${userCredential.user}");

        setState(() {
          _user = userCredential?.user;
          _isLoaded = false;
        });
      },
      child: Text("Sign in with Google"),
    );
  }

  Future<UserCredential> _signInWithGoogle(
      LocalAuthCredential localAuthCredential) async {
    print("_signInWithGoogle");
    if (localAuthCredential == null) {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      localAuthCredential =
          new LocalAuthCredential(googleAuth.accessToken, googleAuth.idToken);
      _authRepository.saveLocalAuthCredentials(localAuthCredential);
    }

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: localAuthCredential.accessToken,
      idToken: localAuthCredential.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
