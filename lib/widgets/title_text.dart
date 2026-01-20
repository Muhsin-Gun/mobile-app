import 'package:flutter/material.dart';

class TitlesTextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final int? maxLines;
  final Color? color;

  const TitlesTextWidget({
    super.key,
    required this.label,
    this.fontSize = 18,
    this.maxLines,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).textTheme.titleMedium?.color,
      ),
    );
  }
}

