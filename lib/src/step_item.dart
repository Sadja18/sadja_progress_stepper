import 'package:flutter/material.dart';

/// Represents a step in the [SadjaProgressStepper].
///
/// Each step contains a required [content] widget, which is displayed
/// when the step is active. Optionally, a [label] and an [icon] (or text)
/// can be displayed inside the step indicator.
///
/// **Priority Rule:**
/// - If both [icon] and [text] are provided, the [icon] is used.
/// - If only [text] is provided, it is displayed inside the step indicator.
/// - If neither [icon] nor [text] is provided, a default icon (`Icons.list`)
///   is used and a warning is logged.
@immutable
class StepItem {
  /// The widget displayed when this step is selected.
  ///
  /// This is required because each step should have an associated content,
  /// such as a form, an information panel, or another UI component.
  final Widget content;

  /// An optional label displayed **below** the step indicator.
  ///
  /// If [SadjaProgressStepper.showLabels] is `true`, this text will be displayed.
  final String? label;

  /// The icon displayed inside the step indicator.
  ///
  /// Defaults to `Icons.list` if not provided.
  final IconData? icon;

  /// An optional text displayed inside the step indicator.
  ///
  /// If both [icon] and [text] are provided, the [icon] takes priority.
  final String? text;

  // Private constructor to enforce immutability
  const StepItem._({
    required this.content,
    this.label,
    required this.icon,
    this.text,
  });

  /// Factory constructor to ensure correct usage and logging.
  ///
  /// - If both [icon] and [text] are provided, [icon] takes priority.
  /// - If neither is provided, defaults to `Icons.list` and logs a warning.
  factory StepItem({
    required Widget content,
    String? label,
    IconData? icon,
    String? text,
  }) {
    // ✅ Prioritize icon over text if both are provided
    if (text != null && icon != null) {
      debugPrint("Both text and icon provided. Prioritizing icon.");
      text = null; // Reset text
    }

    // ✅ Warn the developer if they did not provide an icon or text
    if (text == null && icon == null) {
      debugPrint(
        "Neither icon nor text provided.",
      );
      throw AssertionError("Neither icon nor text provided.");
    }

    // ✅ Set a default icon if none is provided
    icon ??= Icons.list;

    return StepItem._(
      content: content,
      label: label,
      icon: icon,
      text: text,
    );
  }
}
