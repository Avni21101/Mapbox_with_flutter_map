import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_box_implementation/map_key.dart';
import 'package:http/http.dart' as http;

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  Future<void> checkPermissionStatus() async {
    late LocationPermission locationPermission;
    emit(state.copyWith(locationStatus: LocationStatus.initial));
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    emit(state.copyWith(isLocationEnabled: isServiceEnabled));
    if (isServiceEnabled == false) {
      emit(
        state.copyWith(
          locationStatus: LocationStatus.failure,
          errorMessage: 'Please enable the location Service',
        ),
      );
      return;
    }
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.always ||
        locationPermission == LocationPermission.whileInUse) {
      try {
        emit(state.copyWith(locationStatus: LocationStatus.loading));
        final position = await Geolocator.getCurrentPosition();
        emit(
          state.copyWith(
            currentLatLong: (position.latitude, position.longitude),
            locationStatus: LocationStatus.success,
            locationPermission: locationPermission,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            locationStatus: LocationStatus.failure,
            errorMessage: e.toString(),
          ),
        );
      }
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      emit(state.copyWith(
          locationPermission: locationPermission,
          locationStatus: LocationStatus.loaded));
    } else {
      emit(state.copyWith(
          locationPermission: locationPermission,
          locationStatus: LocationStatus.loaded));
    }
  }

  void shouldShowDetails(bool shouldShowDetails) {
    emit(state.copyWith(shouldShowDetails: shouldShowDetails));
  }

  void shouldShowCurrentLocation(bool showCurrentLocation) {
    emit(state.copyWith(shouldShowCurrentLocation: showCurrentLocation));
  }

  Future<void> fetchRouteCoordinates() async {
    const startLng = 72.5220; // Thaltej Metro Station Longitude
    const startLat = 23.0500; // Thaltej Metro Station Latitude
    const endLng = 72.6149; // Riverfront Ahmedabad Longitude
    const endLat = 23.0297; // Riverfront Ahmedabad Latitude

    const accessToken = AppConstants.mapBoxAccessToken;

    const url =
        'https://api.mapbox.com/directions/v5/mapbox/driving/$startLng,$startLat;$endLng,$endLat?steps=true&geometries=geojson&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      List<LatLng> list = [];
      // Convert the polyline coordinates to LatLng points
      for (var e in coordinates) {
        list.add(LatLng(e[1], e[0]));
      }
      emit(state.copyWith(listOfCoordinates: list));
    } else {
      emit(
        state.copyWith(
            locationStatus: LocationStatus.failure,
            errorMessage: 'Failed to fetch route'),
      );
    }
  }
}
