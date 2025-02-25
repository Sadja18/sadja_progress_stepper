import 'package:flutter/material.dart';

/// Represents a step in the `SadjaProgressStepper` widget.
/// Each step has an `icon` and `content` widget.
@immutable
class StepItem {
  /// The widget to be displayed as icon in the step.
  final Widget icon;

  /// The content shown when this step is active.
  final Widget content;

  /// Creates a `StepItem` with an icon and content.
  const StepItem({required this.icon, required this.content});
}
