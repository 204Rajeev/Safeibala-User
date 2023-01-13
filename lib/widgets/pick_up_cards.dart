import 'package:flutter/material.dart';

class PickUpCard extends StatelessWidget {
  final imageUrl;
  final text;
  final hei;
  final wid;
  const PickUpCard({super.key, this.imageUrl, this.text, this.hei, this.wid});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            height: hei,
            width: wid,
            padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
