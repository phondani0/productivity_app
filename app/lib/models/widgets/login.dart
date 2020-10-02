import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoapp/models/classes/task.dart';
import 'package:todoapp/models/global.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  bool isUserSignedIn = false;
  String userAuthToken;
  @override
  void initState() {
    super.initState();
    initApp();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    // immediately check whether the user is signed in
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  void onGoogleSignIn(BuildContext context) async {
    print(isUserSignedIn);
    User user = await _handleSignIn();
    print(user);

    var idToken = await user.getIdToken();
    // print(idToken);

    // var userSignedIn = Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => WelcomeUserWidget(user, _googleSignIn)));
    // taskAlbum = fetchTask();
    setState(() {
      // isUserSignedIn = userSignedIn == null ? true : false;
      isUserSignedIn = true;
      userAuthToken = idToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.orange,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                onGoogleSignIn(context);
              },
              color: Colors.blueAccent,
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.account_circle, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Login with Google',
                          style: TextStyle(color: Colors.white)),
                    ],
                  )),
            ),
            Container(child: Text("Logged In"))
          ],
        ),
      ),
    );
  }

  Future<User> _handleSignIn() async {
    // hold the instance of the authenticated user
    User user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    // setState(() {
    //   isUserSignedIn = userSignedIn;
    // });
    if (isSignedIn) {
      // if so, return the current user
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      user = (await _auth.signInWithCredential(credential)).user;
      var userSignedIn = await _googleSignIn.isSignedIn();
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }

    return user;
  }
}
