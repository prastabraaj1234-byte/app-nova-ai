import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final Color? borderColor;
  final double borderWidth;
  final Color? glowColor;
  final double glowIntensity;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 12.0,
    this.opacity = 0.1,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.borderWidth = 1.0,
    this.glowColor,
    this.glowIntensity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? (glowColor != null ? glowColor!.withOpacity(0.5) : Colors.white.withOpacity(0.08));

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: glowColor != null && glowIntensity > 0
            ? [
                BoxShadow(
                  color: glowColor!.withOpacity(glowIntensity * 0.4),
                  blurRadius: 16 * glowIntensity,
                  spreadRadius: 2 * glowIntensity,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (color ?? Colors.white).withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: effectiveBorderColor,
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
