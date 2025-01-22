import 'package:google_maps_flutter/google_maps_flutter.dart';


class Hospital {
  final String name;
  final String vicinity;
  final double rating;
  final LatLng location;

  Hospital({
    required this.name,
    required this.vicinity,
    required this.rating,
    required this.location,
  });
}