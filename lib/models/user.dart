import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String userName;

  const User({
    required this.email,
    required this.uid,
    required this.userName,
  });

  Map<String, dynamic> toJson() =>
    {'username': userName, 'uid': uid, 'email': email};

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      userName: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
    );
  }
}
