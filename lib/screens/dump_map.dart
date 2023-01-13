import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DumpMap extends StatelessWidget {
  const DumpMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(20.2709646, 85.7640933),
      zoom: 17,))
    );
  }
}
