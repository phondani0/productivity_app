import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoapp/models/classes/storage.dart';
import 'package:todoapp/models/classes/user.dart';
import 'package:todoapp/models/global.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;
  bool isUserSignedIn = false;
  static LocalUser localUser;
  var storage = Storage();

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
    // var userSignedIn = await _googleSignIn.isSignedIn();
    // var user = _googleSignIn.currentUser;

    var jsonData = await storage.readAll();

    if (jsonData == null || jsonData['user'] == null) return;

    var user = json.decode(jsonData['user']);

    // print(user);

    setState(() {
      isUserSignedIn = user['isAuth'];
      localUser = LocalUser(
        id: user['id'],
        displayName: user['displayName'],
        photoUrl: user['photoUrl'],
        email: user['email'],
        idToken: user['idToken'],
        isAuth: true,
      );
    });
  }

  void onGoogleSignIn(BuildContext context) async {
    print(isUserSignedIn);
    User user = await _handleSignIn();
    print(user);
    var idToken = await user.getIdToken();
    // print(idToken);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => WelcomeUserWidget(user, _googleSignIn),
    //   ),
    // );

    // taskAlbum = fetchTask();
    setState(() {
      // isUserSignedIn = userSign;edIn == null ? true : false;
      isUserSignedIn = true;
      localUser = LocalUser(
        id: user.uid,
        displayName: user.displayName,
        photoUrl: user.photoURL,
        email: user.email,
        idToken: idToken,
        isAuth: true,
      );
    });
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
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      user = (await _auth.signInWithCredential(credential)).user;

      // add user to storage
      storage.addNewItem(
        "user",
        json.encode({
          "id": user.uid,
          "displayName": user.displayName,
          "photoUrl": user.photoURL,
          "email": user.email,
          "idToken": await user.getIdToken(),
          "isAuth": await _googleSignIn.isSignedIn()
        }),
      );

      var userSignedIn = await _googleSignIn.isSignedIn();

      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // var user1 = _googleSignIn.currentUser;

    // setState(() {
    //   user = user1;
    // });
    // print('user ${user}');
    return new Container(
      color: Colors.orange,
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isUserSignedIn && localUser != null
                ? Container(
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(localUser.photoUrl,
                              width: 100, height: 100, fit: BoxFit.cover),
                        ),
                        Text(
                          localUser.displayName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text("Logout"),
                          color: primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            _googleSignIn.signOut();
                            setState(() {
                              isUserSignedIn = false;
                              localUser = null;
                              storage.deleteAll();
                            });
                          },
                        ),
                      ],
                    ),
                  )
                : FlatButton(
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
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// class WelcomeUserWidget extends StatelessWidget {
//   GoogleSignIn _googleSignIn;
//   User _user;
//   WelcomeUserWidget(User user, GoogleSignIn signIn) {
//     _user = user;
//     _googleSignIn = signIn;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           ClipOval(
//             child: Image.network(_user.photoURL,
//                 width: 100, height: 100, fit: BoxFit.cover),
//           ),
//           Text(
//             _user.displayName,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
//           ),
//           FlatButton(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text("Logout"),
//               onPressed: () {
//                 _googleSignIn.signOut();
//                 Navigator.pop(context);
//               }),
//         ],
//       ),
//     );
//   }
// }
