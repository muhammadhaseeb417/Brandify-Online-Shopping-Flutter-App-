import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;

  AuthService() {
    _firebaseAuth.authStateChanges().listen(userStateChangesListner);
  }

  User? get user {
    return _user;
  }

  Future<bool> checkUserLogin(email, password) async {
    final crediantial = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (crediantial.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> registerNewUser({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> SignOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void userStateChangesListner(User? user) {
    _user = user;
  }
}
