import 'package:cloud_firestore/cloud_firestore.dart';

class PickUp {
  final String? pickId;
  final String? trashSize;
  final trashType;
  final String? uid;
  final String? username;
  final String? datePublished;
  final String? latitude;
  final String? longitude;
  final String? address;
  final String? postalCode;

  PickUp(
      {this.pickId,
      this.trashSize,
      this.trashType,
      this.uid,
      this.username,
      this.datePublished,
      this.latitude,
      this.longitude,
      this.address, 
      this.postalCode,
      });

  static PickUp fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PickUp(
      uid: snapshot['uid'],
      username: snapshot['username'],
      trashType: snapshot['trashType'],
      datePublished: snapshot["datePublished"],
      latitude: snapshot['latitude'],
      longitude: snapshot['longitude'],
      trashSize: snapshot['trashSize'],
      pickId: snapshot['pickId'],
      postalCode: snapshot['postalCode'],
      address: snapshot['address'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'trashType': trashType,
        'datePublished': datePublished,
        'latitude': latitude,
        'longitude': longitude,
        'trashSize': trashSize,
        'pickId': pickId,
        'postalCode':postalCode,
        'address': address,
      };
}
