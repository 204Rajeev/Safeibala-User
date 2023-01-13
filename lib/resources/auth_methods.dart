import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/semantics.dart';
import '../models/user.dart' as model;
import '../resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<model.User> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return model.User.fromSnap(snap);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
