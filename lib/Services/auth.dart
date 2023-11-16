import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_247/Screens/edit_profile_screen.dart';
import 'package:help_247/Screens/login_Screen.dart';
import 'package:help_247/Screens/main_screen.dart';
import 'package:help_247/toast.dart';

String data = '';

class Auth {
  User? currentUser;
  final postRef = FirebaseFirestore.instance.collection('GoogleUser');
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signInEmail(String email, String password, context) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
      }
      return user;
    } catch (exception) {
      print('Exception : $exception');
      showToast('Exception : $exception');
    }
  }

  Future<User?> signUp(email, password, context) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EditProfileScreen()));
      }
      return user;
    } catch (exception) {
      print('Exception : $exception');
      showToast('Exception : $exception');
    }
  }

  Future<User?> signOut(context) async {
    await auth.signOut().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
