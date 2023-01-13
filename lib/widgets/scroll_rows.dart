import 'package:flutter/material.dart';

class ScrollRows extends StatelessWidget {
  const ScrollRows({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 90,
            width: 160,
            // decoration: const BoxDecoration(color: Colors.grey),
            child:
                Image.asset('assets/images/dump1.jpg', fit: BoxFit.fitHeight)),
        const SizedBox(
          width: 20,
        ),
        Container(
            height: 90,
            width: 160,
            // decoration: const BoxDecoration(color: Colors.grey),
            child: Image.asset('assets/images/dump2.jpg', fit: BoxFit.cover)),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
