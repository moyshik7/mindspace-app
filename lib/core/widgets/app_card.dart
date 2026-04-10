import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? backgroundColor;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.gradient,
    this.boxShadow,
    this.onTap,
    this.borderRadius = AppConstants.radiusXL,
    this.backgroundColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: AppConstants.spacingLG),
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingLG),
        decoration: BoxDecoration(
          color: gradient == null
              ? (backgroundColor ?? AppColors.surface)
              : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              Border.all(
                color: AppColors.surfaceBorder,
                width: AppConstants.cardBorderWidth,
              ),
          boxShadow: boxShadow ?? AppColors.subtleGlow,
        ),
        child: child,
      ),
    );
  }
}
