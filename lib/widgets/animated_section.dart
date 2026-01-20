import 'package:flutter/material.dart';

class AnimatedSection extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double dy;
  final double dx;
  final double beginOpacity;

  const AnimatedSection({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
    this.curve = Curves.easeOutCubic,
    this.dy = 0.08,
    this.dx = 0,
    this.beginOpacity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      child: child,
      builder: (context, t, child) {
        final eased = CurvedAnimation(parent: AlwaysStoppedAnimation(t), curve: curve).value;
        return Opacity(
          opacity: (beginOpacity + (1 - beginOpacity) * eased).clamp(0, 1),
          child: Transform.translate(
            offset: Offset(dx * (1 - eased) * 100, dy * (1 - eased) * 100),
            child: child,
          ),
        );
      },
    );
  }
}


