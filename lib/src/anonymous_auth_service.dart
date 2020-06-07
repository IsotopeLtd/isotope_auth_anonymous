import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isotope_auth/isotope_auth.dart';

class AnonymousAuthService extends AuthServiceAdapter {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<IsotopeIdentity> currentIdentity() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return _identityFromFirebase(user);
  }

  @override
  Stream<IsotopeIdentity> get onAuthStateChanged {
    authStateChangedController.stream;
    return _firebaseAuth.onAuthStateChanged.map(_identityFromFirebase);
  }

  @override
  AuthProvider get provider {
    return AuthProvider.anonymous;
  }

  @override
  Future<IsotopeIdentity> signIn(Map<String, dynamic> _credentials) async {
    final AuthResult authResult = await _firebaseAuth.signInAnonymously();
    return _identityFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  IsotopeIdentity _identityFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return IsotopeIdentity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
