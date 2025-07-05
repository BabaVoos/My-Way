import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatelessWidget {
  final MapController mapController;
  final List<Marker> markers;
  final List<CircleMarker> circles;
  final LatLng center;
  final void Function(LatLng)? onTap;
  final List<Polyline> polylines;

  const CustomMap({
    super.key,
    required this.mapController,
    required this.markers,
    required this.circles,
    required this.center,
    required this.polylines,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 17.0,
        onMapReady: () => mapController.move(center, 17),
        onTap: (tapPosition, latLng) => onTap?.call(latLng),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.myapp',
        ),
        PolylineLayer(polylines: polylines),
        CircleLayer(circles: circles),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
