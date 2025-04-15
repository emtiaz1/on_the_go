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
  LatLng _movingPoint = const LatLng(23.9986, 90.4193); // Gazipur coordinates
  bool _showMovementAlert = false;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _startMovingPointAnimation();
  }

  void _startMovingPointAnimation() {
    // Simulate movement by updating the point position every 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isMoving = !_isMoving;
          // Move the point in Gazipur area
          _movingPoint = LatLng(
            _movingPoint.latitude + (_isMoving ? 0.0003 : -0.0003),
            _movingPoint.longitude + (_isMoving ? 0.0003 : -0.0003),
          );
          _showMovementAlert = true;
        });
        
        // Show alert for 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showMovementAlert = false;
            });
          }
        });
        
        // Continue animation
        _startMovingPointAnimation();
      }
    });
  }

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
        _currentLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        _isLoading = false;
      });
    });
  }

  Future<void> jumpToCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16);
    } else {
      errorMessage('Current location not available.');
    }
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
              initialZoom: 14.0,
              minZoom: 2.0,
              maxZoom: 19.0,
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
              // Original markers
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(23.8103, 90.4125), // Gulshan
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                  Marker(
                    point: const LatLng(23.7806, 90.2794), // Dhanmondi
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  Marker(
                    point: const LatLng(23.7288, 90.3854), // Motijheel
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  // Moving point marker with M logo
                  Marker(
                    point: _movingPoint,
                    width: 35, // Slightly smaller than before
                    height: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // Smaller font
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Highlight circles for all locations
              CircleLayer(
                circles: [
                  // Original locations
                  CircleMarker(
                    point: const LatLng(23.8103, 90.4125), // Gulshan
                    color: Colors.blue.withOpacity(0.2),
                    borderColor: Colors.blue,
                    borderStrokeWidth: 1,
                    radius: 50,
                  ),
                  CircleMarker(
                    point: const LatLng(23.7806, 90.2794), // Dhanmondi
                    color: Colors.green.withOpacity(0.2),
                    borderColor: Colors.green,
                    borderStrokeWidth: 1,
                    radius: 40,
                  ),
                  CircleMarker(
                    point: const LatLng(23.7288, 90.3854), // Motijheel
                    color: Colors.orange.withOpacity(0.2),
                    borderColor: Colors.orange,
                    borderStrokeWidth: 1,
                    radius: 60,
                  ),
                  // Moving point highlight (smaller radius)
                  CircleMarker(
                    point: _movingPoint,
                    color: Colors.red.withOpacity(0.2),
                    borderColor: Colors.red,
                    borderStrokeWidth: 1, // Thinner border
                    radius: 60, // Reduced from 100 to 60
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_showMovementAlert)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'M',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Movement detected in Gazipur!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
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