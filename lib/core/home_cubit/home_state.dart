part of 'home_cubit.dart';

enum BaseStatus {
  loading,
  success,
  error,
  getPolylineLoading,
  getPolylineSuccess,
  getPolylineError,
}

class HomeState extends Equatable {
  final BaseStatus status;
  final LatLng? userLocation;
  final LatLng? targetLocation;
  final double? distance;
  final List<Polyline>? polylines;
  final List<Marker>? markers;
  final List<CircleMarker>? circles;

  const HomeState({
    required this.status,
    this.userLocation,
    this.targetLocation,
    this.distance,
    this.polylines,
    this.markers,
    this.circles,
  });

  factory HomeState.initial() => const HomeState(status: BaseStatus.loading);

  HomeState copyWith({
    BaseStatus? status,
    LatLng? userLocation,
    LatLng? targetLocation,
    double? distance,
    List<Polyline>? polylines,
    List<Marker>? markers,
    List<CircleMarker>? circles,
  }) {
    return HomeState(
      status: status ?? this.status,
      userLocation: userLocation ?? this.userLocation,
      targetLocation: targetLocation ?? this.targetLocation,
      distance: distance ?? this.distance,
      polylines: polylines ?? this.polylines,
      markers: markers ?? this.markers,
      circles: circles ?? this.circles,
    );
  }

  @override
  List<Object?> get props => [status, userLocation, targetLocation, distance, polylines, markers, circles];
}
