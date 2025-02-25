import 'package:flutter/material.dart';

@immutable
class StepItem {
  final Widget icon;
  final Widget content;

  const StepItem({required this.icon, required this.content});
}
