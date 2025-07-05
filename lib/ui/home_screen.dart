import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_way/core/home_cubit/home_cubit.dart';
import 'package:my_way/ui/widgets/custom_map.dart';
import 'package:my_way/ui/widgets/transportation_mode_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final MapController mapController;
  final List<Marker> markers = [];
  final List<CircleMarker> circles = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getUserLocation();
    });
  }

  void _drawUserAndTarget(LatLng user, LatLng? target) {
    markers.clear();
    circles.clear();

    // Add user circle
    circles.add(
      CircleMarker(
        point: user,
        color: Colors.blue.withOpacity(0.5),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
        radius: 10.r,
      ),
    );

    // Add target marker
    if (target != null) {
      markers.add(
        Marker(
          point: target,
          width: 120,
          height: 120,
          child: Icon(
            CupertinoIcons.location_solid,
            color: Colors.red,
            size: 40.r,
          ),
        ),
      );
    }
  }

  void smoothMoveTo(LatLng from, LatLng to, double zoom) {
    final latTween = Tween<double>(begin: from.latitude, end: to.latitude);
    final lngTween = Tween<double>(begin: from.longitude, end: to.longitude);
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    final animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    controller.addListener(() {
      final lat = latTween.evaluate(animation);
      final lng = lngTween.evaluate(animation);
      mapController.move(LatLng(lat, lng), zoom);
    });

    controller.forward().whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == BaseStatus.getPolylineLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          } else if (state.status == BaseStatus.getPolylineSuccess ||
              state.status == BaseStatus.getPolylineError) {
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
              final points =
                  state.polylines != null && state.polylines!.isNotEmpty
                  ? state.polylines![0].points
                  : [];
              if (points.isNotEmpty) {
                final bounds = LatLngBounds.fromPoints(points.cast<LatLng>());
                final center = bounds.center;
                final zoom = mapController.camera.zoom;
                mapController.move(center, zoom);
              }
            }

            if (state.status == BaseStatus.getPolylineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Center(
                    child: Text(
                      'We have encountered an error, please try again',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
        builder: (context, state) {
          if (state.status == BaseStatus.loading ||
              state.userLocation == null) {
            return const Center(child: CircularProgressIndicator());
          }

          _drawUserAndTarget(state.userLocation!, state.targetLocation);

          return Stack(
            children: [
              CustomMap(
                mapController: mapController,
                center: state.userLocation!,
                markers: markers,
                circles: circles,
                polylines: state.polylines ?? [],
                onTap: (latLng) =>
                    context.read<HomeCubit>().selectTargetLocation(latLng),
              ),
              if (state.distance != null)
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '${state.distance!.toStringAsFixed(2)} KM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TransportationModeWidget(),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.userLocation == null) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () => smoothMoveTo(
              mapController.camera.center,
              state.userLocation!,
              17,
            ),
            child: const Icon(
              CupertinoIcons.map_pin_ellipse,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}
