import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import '../enums/trash_size.dart';

class Post {
  final String? description;
  final String? uid;
  final String? username;
  final String? trashSize;
  final String? postId;
  final String? datePublished;
  final String? postUrl;
  final likes;
  final String? latitude;
  final String? longitude;
  final bool? postStatus;
  final String? address;
  final String? postalCode;

  Post(
      {required this.description,
      required this.uid,
      required this.username,
      required this.trashSize,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.likes,
      required this.latitude,
      required this.longitude,
      required this.postStatus,
      required this.address,
      required this.postalCode});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot['postUrl'],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
      postStatus: snapshot['postStatus'],
      trashSize: snapshot['trashSize'],
      address: snapshot['address'],
      postalCode: snapshot['postalCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'uid': uid,
        'likes': likes,
        'username': username,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'trashSize': trashSize,
        'latitude': latitude,
        'longitude': longitude,
        'postStatus': postStatus,
        'address': address,
        'postalCode': postalCode,
      };
}
