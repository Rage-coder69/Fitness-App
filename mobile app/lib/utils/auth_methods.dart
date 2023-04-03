import 'dart:typed_data';

import 'package:app/utils/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String?> signUpUser(
      {required String email,
      required String password,
      required String name,
      required Uint8List file}) async {
    String? res = 'Some error occurred!';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty ||
          file.length > 0) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;

        //uploading profile pic to firebase storage
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //creating a user in the firebase database
        await _fireStore.collection('users').doc(user!.uid).set({
          'email': email,
          'name': name,
          'profile_pic': file,
          'photoUrl': photoUrl,
        });

        res = 'success';
      } else {
        res = 'Please fill all the fields';
      }
    }
    //another way we can handle errors
    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        res = 'The email is invalid.';
      }
    }
    return res;
  }

  Future<String?> signInUser(
      {required String email, required String password}) async {
    String? res = 'Some error occurred!';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter email and password';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Wrong password provided for that user.';
      } else {
        res = e.message;
      }
    }
    return res;
  }
}
