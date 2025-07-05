import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_way/core/utils/api_service.dart';
import 'package:my_way/core/utils/location_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.initial());

  final ApiService _apiService = ApiService();

  void setTarget(LatLng latLng) {
    emit(state.copyWith(targetLocation: latLng));
  }

  void clearPolylines() {
    emit(state.copyWith(polylines: []));
  }

  void setPolyline(List<LatLng> coords) {
    emit(
      state.copyWith(
        polylines: [
          Polyline(points: coords, strokeWidth: 4, color: Colors.blue),
        ],
      ),
    );
  }

  Future<void> getUserLocation() async {
    emit(state.copyWith(status: BaseStatus.loading));
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);
      emit(state.copyWith(status: BaseStatus.success, userLocation: latLng));
    } else {
      emit(state.copyWith(status: BaseStatus.error));
    }
  }

  Future<void> selectTargetLocation(LatLng latLng) async {
    if (state.userLocation == null) return;

    final distance = await LocationService.getDistance(
      state.userLocation!,
      latLng,
    );

    emit(
      state.copyWith(targetLocation: latLng, distance: distance, polylines: []),
    );
  }

  Future<void> getRoute(String profile) async {
    if (state.userLocation == null || state.targetLocation == null) return;

    emit(state.copyWith(status: BaseStatus.getPolylineLoading));

    try {
      final route = await _apiService.getRoute(
        state.userLocation!,
        state.targetLocation!,
        profile,
      );

      final coordinates = route.routes[0].geometry.coordinates;
      final latLngPoints = coordinates
          .map((coord) => LatLng(coord.latitude, coord.longitude))
          .toList();

      emit(
        state.copyWith(
          status: BaseStatus.getPolylineSuccess,
          polylines: [
            Polyline(points: latLngPoints, strokeWidth: 4, color: Colors.black),
          ],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BaseStatus.getPolylineError));
    }
  }
}
