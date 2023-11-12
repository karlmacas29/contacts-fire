import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //create new acc using email and pass method firebase

  Future<String> createAccountWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //log in with email pass method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  //logout
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  //check if user sign in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

//google api login
  Future<String> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //send auth request
      final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

      //obtain a new creditional
      final creds = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      //sign in with the credentials
      await FirebaseAuth.instance.signInWithCredential(creds);

      return "Google Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
