import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:plantify/models/firebaseuser.dart';
import 'package:plantify/models/loginuser.dart';
import 'package:plantify/models/theme.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser? _firebaseUser(User? user) {
    return user != null ? FirebaseUser(uid: user.uid) : null;
  }

  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_firebaseUser);
  }

  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return _firebaseUser(user);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signInEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    }
  }

  Future registerEmailPassword(LoginUser _login) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _login.email.toString(),
              password: _login.password.toString());
      User? user = userCredential.user;
      return _firebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return FirebaseUser(code: e.code, uid: null);
    } catch (e) {
      return FirebaseUser(code: e.toString(), uid: null);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = darkMode;
  ThemeData get themeData => _themeData;

  String _language = "english";
  String get language => _language;

  PersistentTabController _controller = PersistentTabController(initialIndex: 0, );
  PersistentTabController get controller => _controller ;

  void changeIndex(int idx){
    _controller.jumpToTab(idx);
  }

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void changeLanuage(){
    if(_language == "english"){
      _language = "tamil";
    }
    else{
      _language = "english";
    }
    notifyListeners();
  }

  void toggleTheme (){
    if(_themeData == lightMode){
      themeData = darkMode;
    }
    else {
      themeData = lightMode;
    }
  }
}

class URLprovider {
  static var _BaseUrl = "https://75b7-14-139-161-250.ngrok-free.app";

  static String get BaseUrl => _BaseUrl ;
}
