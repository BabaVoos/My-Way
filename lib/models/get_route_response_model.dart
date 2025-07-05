import 'package:latlong2/latlong.dart';

class GetRouteResponseModel {
  final List<RouteModel> routes;

  GetRouteResponseModel({required this.routes});

  factory GetRouteResponseModel.fromJson(Map<String, dynamic> json) {
    return GetRouteResponseModel(
      routes: (json['routes'] as List)
          .map((e) => RouteModel.fromJson(e))
          .toList(),
    );
  }
}

class RouteModel {
  final Geometry geometry;
  final double weight;
  final double duration;
  final double distance;

  RouteModel({
    required this.geometry,
    required this.weight,
    required this.duration,
    required this.distance,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      geometry: Geometry.fromJson(json['geometry']),
      weight: (json['weight'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );
  }
}

class Geometry {
  final String type;
  final List<LatLng> coordinates;

  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List;
    final points = coords
        .map((point) => LatLng(point[1] as double, point[0] as double))
        .toList();

    return Geometry(
      type: json['type'] as String,
      coordinates: points,
    );
  }
}