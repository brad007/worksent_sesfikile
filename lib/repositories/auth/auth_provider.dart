import 'package:firebase_auth/firebase_auth.dart';
import 'package:worksent_sesfikile/models/user_model.dart';

class AuthProvider {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getFirebaseUser() {
    return _auth.currentUser();
  }


  Future<FirebaseUser> signInUser({String email, String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> createUser({String email, String password}) {
    return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> sendResetPassword({String email}) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() {
    return _auth.signOut();
  }
}
