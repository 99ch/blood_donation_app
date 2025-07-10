import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

/// Measurement Slider Widget
///
/// A custom slider with glassmorphism effect and real-time value display
class MeasurementSlider extends StatefulWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final Function(double) onChanged;
  final IconData icon;

  const MeasurementSlider({
    Key? key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    required this.icon,
  }) : super(key: key);

  @override
  State<MeasurementSlider> createState() => _MeasurementSliderState();
}

class _MeasurementSliderState extends State<MeasurementSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSliderHeader(),
          SizedBox(height: 16.h),
          _buildSliderTrack(),
        ],
      ),
    );
  }

  Widget _buildSliderHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: appTheme.colorFFF2AB.withAlpha(51),
              borderRadius: BorderRadius.circular(8.h),
            ),
            child: Icon(
              widget.icon,
              color: appTheme.colorFF8808,
              size: 20.h,
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Text(
              widget.label,
              style: TextStyleHelper.instance.headline25RegularLexend.copyWith(
                color: appTheme.colorFF7373,
                fontSize: 16.fSize,
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: appTheme.colorFF8808,
                    borderRadius: BorderRadius.circular(16.h),
                    boxShadow: [
                      BoxShadow(
                        color: appTheme.colorFF8808.withAlpha(77),
                        offset: Offset(0, 2.h),
                        blurRadius: 6.h,
                      ),
                    ],
                  ),
                  child: Text(
                    '${widget.value.toInt()}${widget.unit}',
                    style:
                        TextStyleHelper.instance.body15RegularLexend.copyWith(
                      color: appTheme.whiteCustom,
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderTrack() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      child: Stack(
        children: [
          _buildTrackBackground(),
          _buildActiveTrack(),
          _buildSliderThumb(),
        ],
      ),
    );
  }

  Widget _buildTrackBackground() {
    return Container(
      height: 6.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: appTheme.colorFFD9D9,
        borderRadius: BorderRadius.circular(3.h),
      ),
    );
  }

  Widget _buildActiveTrack() {
    double progress = (widget.value - widget.min) / (widget.max - widget.min);
    return Container(
      height: 6.h,
      width: (MediaQuery.of(context).size.width - 32.h) * progress,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appTheme.colorFFF2AB,
            appTheme.colorFF8808,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(3.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.colorFFF2AB.withAlpha(102),
            offset: Offset(0, 2.h),
            blurRadius: 4.h,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderThumb() {
    double progress = (widget.value - widget.min) / (widget.max - widget.min);
    double thumbPosition =
        (MediaQuery.of(context).size.width - 32.h - 24.h) * progress;

    return Positioned(
      left: thumbPosition,
      top: -9.h,
      child: GestureDetector(
        onPanUpdate: (details) {
          _animationController.forward().then((_) {
            _animationController.reverse();
          });

          RenderBox renderBox = context.findRenderObject() as RenderBox;
          double localPosition =
              renderBox.globalToLocal(details.globalPosition).dx;
          double sliderWidth = MediaQuery.of(context).size.width - 32.h;
          double newProgress = (localPosition / sliderWidth).clamp(0.0, 1.0);
          double newValue =
              widget.min + (widget.max - widget.min) * newProgress;

          widget.onChanged(newValue);
        },
        child: Container(
          width: 24.h,
          height: 24.h,
          decoration: BoxDecoration(
            color: appTheme.whiteCustom,
            borderRadius: BorderRadius.circular(12.h),
            border: Border.all(
              color: appTheme.colorFF8808,
              width: 3.h,
            ),
            boxShadow: [
              BoxShadow(
                color: appTheme.colorFF8808.withAlpha(77),
                offset: Offset(0, 2.h),
                blurRadius: 6.h,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 8.h,
              height: 8.h,
              decoration: BoxDecoration(
                color: appTheme.colorFF8808,
                borderRadius: BorderRadius.circular(4.h),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
