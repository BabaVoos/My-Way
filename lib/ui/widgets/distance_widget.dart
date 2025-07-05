import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_way/core/utils/location_service.dart';

class DistanceWidget extends StatelessWidget {
  final LatLng from;
  final LatLng to;

  const DistanceWidget({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: LocationService.getDistance(from, to),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final distance = snapshot.data!;
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          child: Text(
            '${distance.toStringAsFixed(2)} KM',
            style: TextStyle(color: Colors.white, fontSize: 20.sp),
          ),
        );
      },
    );
  }
}
