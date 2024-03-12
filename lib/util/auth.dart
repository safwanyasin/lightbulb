import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    return user;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<dynamic> signInWithEmailPass(String email, String pass) async {
    try {
      final uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return uc;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return e.message ?? 'E-mail and/or Password not found';
      } else if (e.code == 'wrong-password') {
        return e.message ?? 'Password is not correct';
      } else if (e.code == 'user-disabled') {
        return e.message ?? 'User has been disabled';
      } else if (e.code == 'invalid-email') {
        return e.message ?? 'Invalid email';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> registerUserWithEmailPass(
      String email, String pass, String username, String Name) async {
    try {
      UserCredential uc = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      String? userid = uc.user!.uid;
      final userData = {
        "bio": "bio",
        "email": email,
        "followReq": [],
        "followersList": [],
        "followingList": [],
        "location": "location",
        "name": Name,
        "notifsList": [],
        "posts": 0,
        "profPic":
            "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png",
        "sentReq": [],
        "state": true,
        "username": username,
        "uid": uc.user!.uid,
        "private": false,
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uc.user!.uid)
          .set(userData);
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      prefs!.setBool('isLoggedIn', true);
      prefs!.setString('userID', uc.user!.uid);
      return uc;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return e.message ?? 'E-mail already in use';
      } else if (e.code == 'weak-password') {
        return e.message ?? 'Your password is weak';
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    // UserCredential uc =
    //     await FirebaseAuth.instance.signInWithCredential(credential);
    //     uc.user.
    //return _userFromFirebase(uc.user);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<User?> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential uc = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    return _userFromFirebase(uc.user);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}

Future thirdPartyAuth(dynamic user) async {
  // print("-------------------------------------------------");
  // print(user.user.uid);
  DocumentSnapshot documentSnapshotUser = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.user.uid)
      .get();
  if (!documentSnapshotUser.exists) {
    final userData = {
      "bio": "bio",
      "email": user.user.email,
      "followReq": [],
      "followersList": [],
      "followingList": [],
      "location": "location",
      "name": "John Doe",
      "notifsList": [],
      "posts": 0,
      "profPic":
          "https://www.tenforums.com/geek/gars/images/2/types/thumb_15951118880user.png",
      "sentReq": [],
      "state": true,
      "username": user.user.uid,
      "uid": user.user.uid,
      "private": false,
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.user.uid)
        .set(userData);
  }
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  prefs!.setBool('isLoggedIn', true);
  prefs!.setString('userID', user.user.uid);
}
