import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String authError = '';

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required Function(String) onFail(String errorMessage)}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
      email: userData['email'],
      password: password,
    )
        .then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      switch (e.code) {
        case 'ERROR_INVALID_EMAIL':
          authError = 'O E-mail é inválido!';
          break;
        case 'ERROR_USER_NOT_FOUND':
          authError = 'Usuário não foi encontrado!';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          authError = 'O E-mail já está sendo usado!';
          break;
        case 'ERROR_WRONG_PASSWORD':
          authError = 'Senha incorreta!';
          break;
        default:
          authError = 'Error not yet handled! ${e.code}';
          break;
      }
      onFail(authError);
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      firebaseUser = user;
      await _loadCurrentUser();
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void passwordRecovery(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) {
      firebaseUser = await _auth.currentUser();
    }
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }
}
