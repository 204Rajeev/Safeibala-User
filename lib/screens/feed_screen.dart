import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:saf_user/widgets/post_tile.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Post').snapshots(),
        builder: ((context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: PostTile(
                    snap: snapshot.data!.docs[index].data(),
                  )));
        }),
      ),
    );
  }
}
