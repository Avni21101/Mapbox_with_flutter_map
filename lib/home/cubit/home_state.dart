part of 'home_cubit.dart';

enum LocationStatus { initial, loading, loaded, failure, success }

class HomeState extends Equatable {
  const HomeState({
    this.locationStatus = LocationStatus.initial,
    this.isLocationEnabled = false,
    this.errorMessage = '',
    this.locationPermission = LocationPermission.unableToDetermine,
    this.currentLatLong = (0, 0),
    this.shouldShowDetails = false,
    this.shouldShowCurrentLocation = false,
    this.listOfCoordinates = const [],
  });

  final LocationPermission locationPermission;
  final LocationStatus locationStatus;
  final bool isLocationEnabled;
  final String errorMessage;
  final (double, double) currentLatLong;
  final bool shouldShowDetails;
  final bool shouldShowCurrentLocation;
  final List<LatLng> listOfCoordinates;

  @override
  List<Object?> get props => [
        locationStatus,
        isLocationEnabled,
        errorMessage,
        locationPermission,
        currentLatLong,
        shouldShowDetails,
        shouldShowCurrentLocation,
        listOfCoordinates
      ];

  HomeState copyWith({
    LocationPermission? locationPermission,
    LocationStatus? locationStatus,
    bool? isLocationEnabled,
    String? errorMessage,
    (double, double)? currentLatLong,
    bool? shouldShowDetails,
    bool? shouldShowCurrentLocation,
    List<LatLng>? listOfCoordinates,
  }) {
    return HomeState(
      locationPermission: locationPermission ?? this.locationPermission,
      locationStatus: locationStatus ?? this.locationStatus,
      isLocationEnabled: isLocationEnabled ?? this.isLocationEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLatLong: currentLatLong ?? this.currentLatLong,
      shouldShowDetails: shouldShowDetails ?? this.shouldShowDetails,
      shouldShowCurrentLocation:
          shouldShowCurrentLocation ?? this.shouldShowCurrentLocation,
      listOfCoordinates: listOfCoordinates ?? this.listOfCoordinates,
    );
  }
}
