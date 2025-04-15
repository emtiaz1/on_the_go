import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  bool _isLoading = true;
  LatLng? _currentLocation;

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<bool> _checkRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
    }
    return permissionStatus == PermissionStatus.granted;
  }

  Future<void> _initializeLocation() async {
    if (!await _checkRequestPermission()) return;
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _isLoading = false;
      });
    });
  }

  Future<void> jumpToCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16); // Higher zoom level
    } else {
      errorMessage('Current location not available.');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(23.8103, 90.4125),
              initialZoom: 16.0, // Higher zoom level for smaller areas
              minZoom: 2.0,
              maxZoom: 40.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              CurrentLocationLayer(
                style: const LocationMarkerStyle(
                  marker: DefaultLocationMarker(
                    child: Icon(Icons.location_pin, color: Colors.white, size: 16),
                  ),
                  markerSize: Size(20, 20),
                  markerDirection: MarkerDirection.heading,
                ),
              ),
              // Smaller marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(23.8103, 90.4125),
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
              // Smaller polygon
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: [
                      const LatLng(23.8103, 90.4125),
                      const LatLng(23.8105, 90.4127),
                      const LatLng(23.8101, 90.4127),
                      const LatLng(23.8103, 90.4125),
                    ],
                    color: Colors.red.withOpacity(0.3),
                    borderColor: Colors.red,
                    borderStrokeWidth: 1,
                  ),
                ],
              ),
              // Much smaller circles
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: const LatLng(23.8103, 90.4125),
                    color: Colors.blue.withOpacity(0.3),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 1,
                    radius: 50, // Very small radius (50m)
                  ),
                  CircleMarker(
                    point: const LatLng(23.7806, 90.2794),
                    color: Colors.green.withOpacity(0.3),
                    borderColor: Colors.green,
                    borderStrokeWidth: 1,
                    radius: 40, // Very small radius (40m)
                  ),
                  CircleMarker(
                    point: const LatLng(23.7288, 90.3854),
                    color: Colors.orange.withOpacity(0.3),
                    borderColor: Colors.orange,
                    borderStrokeWidth: 1,
                    radius: 60, // Very small radius (60m)
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 119, 82, 223),
        foregroundColor: Colors.white,
        mini: true,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        onPressed: jumpToCurrentLocation,
        child: const Icon(Icons.my_location, size: 20),
      ),
    );
  }
}