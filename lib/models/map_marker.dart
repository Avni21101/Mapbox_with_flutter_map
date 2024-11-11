import 'package:latlong2/latlong.dart';

class MapMarker {
  final String? image;
  final String? title;
  final String? address;
  final LatLng? location;
  final int? rating;

  MapMarker({
    required this.image,
    required this.title,
    required this.address,
    required this.location,
    required this.rating,
  });
}

final mapMarkers = [
  MapMarker(
    image: 'assets/gir.jpeg',
    title: 'Sasan Gir National Park',
    address: 'Sasan Gir, Junagadh District, Gujarat',
    location: const LatLng(21.1240, 70.8240),
    rating: 5,
  ),
  MapMarker(
    image: 'assets/madumalai.jpeg',
    title: 'Mudumalai Tiger Reserve',
    address: 'Mudumalai Wildlife Sanctuary, Nilgiri District, Tamil Nadu',
    location: const LatLng(11.4994, 76.6299),
    rating: 3,
  ),
  MapMarker(
    image: 'assets/kaziranga.jpeg',
    title: 'Kaziranga National Park',
    address: 'Kaziranga National Park, Kanchanjuri, Nagaon District, Assam',
    location: const LatLng(26.5775, 93.1711),
    rating: 4,
  ),
];
