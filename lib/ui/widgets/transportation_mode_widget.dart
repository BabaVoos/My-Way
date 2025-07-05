import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_way/core/home_cubit/home_cubit.dart';

class TransportationModeWidget extends StatefulWidget {
  const TransportationModeWidget({super.key});

  @override
  State<TransportationModeWidget> createState() =>
      _TransportationModeWidgetState();
}


class _TransportationModeWidgetState extends State<TransportationModeWidget> {
  String _selectedMode = '';

  void _onModeSelected(String mode) {
    setState(() {
      _selectedMode = _selectedMode == mode ? '' : mode;
    });

    if (_selectedMode.isNotEmpty) {
      context.read<HomeCubit>().getRoute(_selectedMode);
    } else {
      context.read<HomeCubit>().clearPolylines();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          _buildButton(
            mode: 'walking',
            icon: Icons.directions_walk_rounded,
            selectedMode: _selectedMode,
          ),
          SizedBox(height: 10.h),
          _buildButton(
            mode: 'driving',
            icon: CupertinoIcons.car_detailed,
            selectedMode: _selectedMode,
          ),
          SizedBox(height: 10.h),
          _buildButton(
            mode: 'cycling',
            icon: Icons.directions_bike_sharp,
            selectedMode: _selectedMode,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String mode,
    required IconData icon,
    required String selectedMode,
  }) {
    final isSelected = selectedMode == mode;
    return GestureDetector(
      onTap: () => _onModeSelected(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.black,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white,
          size: isSelected ? 34 : 20,
        ),
      ),
    );
  }
}
