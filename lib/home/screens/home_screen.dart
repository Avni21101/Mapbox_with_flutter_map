import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_box_implementation/map_key.dart';
import 'package:map_box_implementation/models/map_marker.dart';
import 'package:map_box_implementation/home/cubit/home_cubit.dart';
import 'package:map_box_implementation/widgets/loading_widget.dart';
import 'package:map_box_implementation/widgets/marker_detail_cards.dart';

@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchRouteCoordinates(),
      child: this,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _pageController = PageController();
  late AnimatedMapController _mapController;
  final locationStream = Geolocator.getPositionStream();

  @override
  void initState() {
    super.initState();
    _mapController = AnimatedMapController(vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    await context.read<HomeCubit>().fetchRouteCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) async {
        if (state.locationPermission == LocationPermission.deniedForever) {
          await Geolocator.openAppSettings();
        } else if (state.locationStatus == LocationStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state.locationStatus == LocationStatus.success) {
          context.read<HomeCubit>().shouldShowCurrentLocation(true);
          _mapController.animateTo(
              dest: LatLng(state.currentLatLong.$1, state.currentLatLong.$2),
              zoom: 8,
              curve: Curves.easeInOut,
              duration: const Duration(seconds: 3));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('💙 Mapbox Flutter'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController.mapController,
                options: const MapOptions(
                  initialCenter: LatLng(20.5937, 78.9629),
                  minZoom: 3,
                  maxZoom: 18,
                  initialZoom: 4,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                    additionalOptions: const {
                      'accessToken': AppConstants.mapBoxAccessToken,
                      'id': 'mapbox/streets-v11',
                      // You can change this to your custom style ID if needed
                    },
                  ),
                  if (state.shouldShowCurrentLocation) CurrentLocationLayer(),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: state.listOfCoordinates,
                        color: Colors.blue,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: List.generate(
                      mapMarkers.length,
                      (index) => Marker(
                        height: 40,
                        width: 40,
                        point: mapMarkers[index].location ??
                            AppConstants.myLocation,
                        child: GestureDetector(
                          onTap: () {
                            context.read<HomeCubit>().shouldShowDetails(true);
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                            _mapController.animateTo(
                              dest: mapMarkers[index].location,
                              zoom: 4,
                              duration: const Duration(seconds: 2),
                            );
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const MarkerLayer(markers: [
                    Marker(
                      height: 40,
                      width: 40,
                      point: LatLng(23.0500, 72.5220),
                      child: Icon(
                        Icons.directions_car_filled,
                      ),
                    )
                  ])
                ],
              ),
              if (state.shouldShowDetails)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 2,
                  height: size.height / 3.2,
                  child: MarkerDetailCards(
                    mapMarkerList: mapMarkers,
                    pageController: _pageController,
                    onBackTap: () {
                      context.read<HomeCubit>().shouldShowDetails(false);
                    },
                  ),
                ),
              if (state.locationStatus == LocationStatus.loading)
                const LoadingWidget(),
            ],
          ),
          floatingActionButton: state.shouldShowDetails
              ? Container()
              : FloatingActionButton(
                  backgroundColor: Colors.blue.withOpacity(0.7),
                  onPressed: () {
                    context.read<HomeCubit>().checkPermissionStatus();
                  },
                  child: const Icon(
                    Icons.my_location,
                    size: 30,
                  ),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
