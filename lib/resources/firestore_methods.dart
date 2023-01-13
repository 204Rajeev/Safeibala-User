import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:saf_user/models/pick_up.dart';
import 'package:saf_user/models/post.dart';
import 'package:saf_user/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String lat, String lon, String trashSize,String address,String postalCode) async {
    String res = 'some error occurred while uploading';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('Posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          datePublished: DateTime.now().toString(),
          description: description,
          latitude: lat,
          likes: [],
          longitude: lon,
          postId: postId,
          postStatus: false,
          postUrl: photoUrl,
          trashSize: trashSize,
          uid: uid,
          username: username,
          address: address,
          postalCode: postalCode

          );

      _firestore.collection('Post').doc(postId).set(post.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> requestPickUp(final trashType, String uid,
      String username, String lat, String lon, String trashSize,String address,String postalCode) async {
    String res = 'some error occurred while uploading';
    try {
     
      String pickId = const Uuid().v1();
      PickUp pickUp = PickUp(
          datePublished: DateTime.now().toString(),
          pickId: pickId,
          latitude: lat,
          trashType:trashType,
          longitude: lon,
          trashSize: trashSize,
          uid: uid,
          username: username,
          address: address,
          postalCode: postalCode,
          );

      _firestore.collection('Pick').doc(pickId).set(pickUp.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }




  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('Post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('Post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }
}
