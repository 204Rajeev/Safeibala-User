import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PostScrollRows extends StatelessWidget {
  final snap;
  const PostScrollRows({super.key, this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 160,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: snap['postUrl'],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
