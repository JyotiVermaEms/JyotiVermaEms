// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();

//   Future<String?> signInwithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await _googleSignIn.signIn();
//       final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount!.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleSignInAuthentication.accessToken,
//         idToken: googleSignInAuthentication.idToken,
//       );
//       print("goole lofin---" + credential.toString());
//       await _auth.signInWithCredential(credential);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.getString('auth_token');
//     } on FirebaseAuthException catch (e) {
//       print(e.message);
//       throw e;
//     }
//   }

//   Future<void> signOutFromGoogle() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }
// }
