import 'package:car_yatri1/MapField/model/entry.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:stop_watch_timer/stop_watch_timer.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Polyline> _polylines = {};
  final loc.Location _location = loc.Location();
  late GoogleMapController _mapController;
  final List<LatLng> _route = [];

  double _distance = 0;
  String _displayTime = '00:00:00';
  int _currentTime = 0;
  int _lastTime = 0;
  double _speed = 0;
  double _totalSpeed = 0;
  int _speedCounter = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _stopWatchTimer.onStartTimer();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    loc.PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return;
    }

    await _location.changeSettings(accuracy: loc.LocationAccuracy.high, interval: 1000);
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _location.onLocationChanged.listen(_onLocationChanged);
  }

  void _onLocationChanged(loc.LocationData event) {
    final LatLng newLocation = LatLng(event.latitude!, event.longitude!);
    _currentTime = _stopWatchTimer.rawTime.value;
    _updateMapCamera(newLocation);
    _updateRouteAndStats(newLocation);
    _updatePolyline();
    setState(() {});
  }

  void _updateMapCamera(LatLng location) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 15)));
  }

  void _updateRouteAndStats(LatLng newLocation) {
    if (_route.isNotEmpty) {
      double appendDist = geo.Geolocator.distanceBetween(
        _route.last.latitude,
        _route.last.longitude,
        newLocation.latitude,
        newLocation.longitude,
      );
      _distance += appendDist;

      if (_lastTime != 0 && (_currentTime - _lastTime) != 0) {
        _speed = (appendDist / ((_currentTime - _lastTime) / 1000)) * 3.6;
        if (_speed != 0) {
          _totalSpeed += _speed;
          _speedCounter++;
        }
      }
    }

    _lastTime = _currentTime;
    _route.add(newLocation);
  }

  void _updatePolyline() {
    _polylines.add(Polyline(
      polylineId: PolylineId(_route.length.toString()),
      visible: true,
      points: _route,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      color: Colors.blue,
    ));
  }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: _polylines,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 11),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: _buildInfoCard(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow(Icons.speed, "Speed", "${_speed.toStringAsFixed(2)} km/h"),
            const SizedBox(height: 8),
            _buildTimeRow(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.straighten, "Distance", "${(_distance / 1000).toStringAsFixed(2)} km"),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return StreamBuilder<int>(
      stream: _stopWatchTimer.rawTime, // Listen to the rawTime stream
      initialData: 0,
      builder: (context, snapshot) {
        final time = snapshot.data ?? 0;
        _displayTime = StopWatchTimer.getDisplayTime(time, hours: true); // Format the time
        return _buildInfoRow(Icons.timer, "Time", _displayTime);
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.blue),
        const SizedBox(width: 8),
        Text("$label: ", style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        Text(value, style: GoogleFonts.montserrat()),
      ],
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.stop),
        label: Text('Stop Tracking', style: GoogleFonts.montserrat()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _onStopPressed,
      ),
    );
  }

  void _onStopPressed() {
    _stopWatchTimer.onStopTimer();
    final entry = Entry(
      date: DateFormat.yMMMMd('en_US').format(DateTime.now()),
      duration: _displayTime,
      speed: _speedCounter == 0 ? 0 : _totalSpeed / _speedCounter,
      distance: _distance,
    );
    Navigator.pop(context, entry);
  }
}
