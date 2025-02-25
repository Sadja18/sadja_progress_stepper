import 'package:flutter/material.dart';
import 'package:sadja_progress_stepper/src/step_item.dart';

/// A customizable stepper widget that supports linear and non-linear navigation.
///
/// This widget displays steps in a horizontal layout, allowing users to navigate
/// through different steps by tapping on them. It supports:
/// - **Linear Mode**: Steps must be completed in order.
/// - **Non-Linear Mode**: Users can jump to any step freely.
///
/// Example:
/// ```dart
/// SadjaProgressStepper(
///   steps: [
///     StepItem(icon: Icon(Icons.looks_one), content: Text("Step 1")),
///     StepItem(icon: Icon(Icons.looks_two), content: Text("Step 2")),
///   ],
///   activeStepColor: Colors.blue,
///   completedStepColor: Colors.green,
///   incompleteStepColor: Colors.grey,
///   completedSteps: [0],
///   onStepTapped: (step) => print("Step $step tapped"),
/// )
/// ```
class SadjaProgressStepper extends StatefulWidget {
  /// List of steps to be displayed in the stepper.
  final List<StepItem> steps;

  /// The index of the currently active step.
  final int currentStep;

  /// List of completed step indices.
  final List<int> completedSteps;

  /// Color of the active step.
  final Color activeStepColor;

  /// Color of the completed steps.
  final Color completedStepColor;

  /// Color of the incomplete steps.
  final Color incompleteStepColor;

  /// Callback function triggered when a step is tapped.
  /// It provides the index of the selected step.
  final Function(int) onStepTapped;

  /// Determines whether navigation should be **linear** (restricting access to future steps)
  /// or **non-linear** (allowing free navigation).
  final bool isLinear;

  /// Creates a `SadjaProgressStepper`.
  ///
  /// - `steps`: A list of `StepItem` widgets.
  /// - `currentStep`: The active step index (default is 0).
  /// - `completedSteps`: List of completed step indices.
  /// - `activeStepColor`: The color of the currently active step.
  /// - `completedStepColor`: The color of completed steps.
  /// - `incompleteStepColor`: The color of incomplete steps.
  /// - `onStepTapped`: Callback triggered when a step is tapped.
  /// - `isLinear`: If `true`, users must complete steps in order.
  const SadjaProgressStepper({
    super.key,
    required this.steps,
    this.currentStep = 0,
    required this.completedSteps,
    required this.activeStepColor,
    required this.completedStepColor,
    required this.incompleteStepColor,
    required this.onStepTapped,
    this.isLinear = true,
  });

  @override
  SadjaProgressStepperState createState() => SadjaProgressStepperState();
}

class SadjaProgressStepperState extends State<SadjaProgressStepper> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;
  }

  /// Determines the color of a step based on its status.
  Color _getStepColor(int index) {
    if (index == widget.currentStep) {
      return widget.activeStepColor;
    } else if (widget.completedSteps.contains(index)) {
      return widget.completedStepColor;
    } else {
      return widget.incompleteStepColor;
    }
  }

  /// Handles navigation between steps.
  ///
  /// If `isLinear` is enabled, users cannot skip to an incomplete step.
  void _goToStep(int step) {
    // ✅ Restrict navigation if `isLinear` is enabled
    if (widget.isLinear &&
        step > 0 &&
        !widget.completedSteps.contains(step - 1)) {
      return;
    }

    setState(() {
      _currentStep = step;
    });
    widget.onStepTapped(step); // ✅ Notify parent
  }

  /// Builds an individual step indicator (circle with an icon).
  Widget _buildStepIndicator(int index) {
    return GestureDetector(
      onTap: () => _goToStep(index),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getStepColor(index),
        ),
        child: Center(child: widget.steps[index].icon),
      ),
    );
  }

  /// Builds the horizontal stepper layout.
  /// with scrollable row in case of overflow
  Widget _buildScrollableStepper() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int minVisibleSteps = 4; // Ensure at least 4 steps are always visible
        double stepWidth = 50; // Width of each step including padding
        double lineWidth = 40; // Space between steps

        double minRequiredWidth =
            (stepWidth * minVisibleSteps) + (lineWidth * (minVisibleSteps - 1));

        bool needsScrolling = (widget.steps.length > minVisibleSteps) &&
            (minRequiredWidth > screenWidth);

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.steps.length * 2 - 1, (index) {
              if (index.isEven) {
                // Step Indicator
                int stepIndex = index ~/ 2;
                return SizedBox(
                  width: stepWidth,
                  child: _buildStepIndicator(stepIndex),
                );
              } else {
                // Line between steps
                int prevStepIndex = (index - 1) ~/ 2;
                int nextStepIndex = prevStepIndex + 1;

                bool isPrevCompleted =
                    widget.completedSteps.contains(prevStepIndex);
                bool isNextCompleted =
                    widget.completedSteps.contains(nextStepIndex);

                Color lineColor = (isPrevCompleted && isNextCompleted)
                    ? widget.completedStepColor
                    : widget.incompleteStepColor;

                return SizedBox(
                  width: needsScrolling
                      ? lineWidth
                      : (screenWidth - stepWidth * widget.steps.length) /
                          (widget.steps.length - 1),
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: lineColor),
                  ),
                );
              }
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      color: Colors.white10,
      child: Column(
        children: [
          // ✅ Use scrollable stepper instead of a fixed row
          _buildScrollableStepper(),

          // ✅ Display the content of the currently active step
          Expanded(
            child: widget.steps[_currentStep].content,
          ),
        ],
      ),
    );
  }
}
