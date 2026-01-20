import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;

  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 14,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color ?? Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}

