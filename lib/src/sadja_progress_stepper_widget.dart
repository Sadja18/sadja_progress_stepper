import 'package:flutter/material.dart';

import 'step_item.dart';

/// A customizable stepper widget for Flutter that visually represents progress
/// through multiple steps. Supports dynamic colors, icons, text, labels,
/// and linear or non-linear navigation.
///
/// ## Features:
/// - Customizable step indicators with colors, icons, and text.
/// - Supports both **linear** (sequential) and **non-linear** (free) navigation.
/// - Allows horizontal scrolling when steps exceed visible limits.
/// - Optional step labels with static or dynamic color modes.
/// - Configurable colors for steps, icons, text, and connecting lines.
///
/// ## Example Usage:
/// ```dart
/// Center(
///   child: SadjaProgressStepper(
///     key: ValueKey(
///       "$_currentStep $_completedSteps",
///       ), // Forces a rebuild when _currentStep changes
///     steps: steps!,
///     currentStep: _currentStep,
///     completedSteps: _completedSteps,
///     activeStepColor: Colors.blue,
///     completedStepColor: Colors.green,
///     incompleteStepColor: Colors.grey,
///     activeIconColor: Colors.white,
///     completedIconColor: Colors.white,
///     incompleteIconColor: Colors.black,
///     activeTextColor: Colors.white,
///     completedTextColor: Colors.white,
///     incompleteTextColor: Colors.black,
///     onStepTapped: _onStepTapped,
///     showLabels: true,
///   ),
/// )
/// ```
///
/// This widget is useful for onboarding, progress tracking, multi-step forms,
/// and any process requiring step-by-step navigation.
class SadjaProgressStepper extends StatefulWidget {
  /// List of steps in the stepper.
  final List<StepItem> steps;

  /// Index of the currently active step.
  final int currentStep;

  /// List of completed step indices.
  final List<int> completedSteps;

  /// Callback function triggered when a step is tapped.
  final Function(int) onStepTapped;

  /// Determines whether navigation is linear (restricts skipping steps).
  final bool isLinear;

  /// Number of visible steps before scrolling is required.
  final int visibleSteps;

  // --- Step Indicator Customization ---

  /// Background color for the active step.
  /// Active steps only take priority when they are NOT completed.
  final Color activeStepColor;

  /// Background color for completed steps.
  final Color completedStepColor;

  /// Background color for incomplete steps.
  final Color incompleteStepColor;

  // --- Icon & Text Colors ---

  /// Color of the icon in the active step.
  /// Active steps only take priority when they are NOT completed.
  final Color activeIconColor;

  /// Color of the icon in completed steps.
  final Color completedIconColor;

  /// Color of the icon in incomplete steps.
  final Color incompleteIconColor;

  /// Text color for the active step.
  /// Active steps only take priority when they are NOT completed.
  final Color activeTextColor;

  /// Text color for completed steps.
  final Color completedTextColor;

  /// Text color for incomplete steps.
  final Color incompleteTextColor;

  // --- Line Customization ---

  /// Color of the line between the current step and the next step.
  /// Active steps only take priority when they are NOT completed.
  final Color? activeLineColor;

  /// Color of the line between completed steps.
  final Color? completedLineColor;

  /// Color of the line between incomplete steps.
  final Color? incompleteLineColor;

  /// Whether the active step’s line should match the completed step color.
  final bool activeLineFollowsCompletedColor;

  // --- Label Customization ---

  /// Determines whether labels should be shown below steps.
  final bool showLabels;

  /// Determines how label colors behave.
  final LabelColorMode labelColorMode;

  /// Static color for labels when `labelColorMode` is set to `LabelColorMode.static`.
  final Color labelStaticColor;

  /// Constructor for `SadjaProgressStepper`.
  ///
  /// The `steps` and `onStepTapped` are required, while `currentStep` defaults to `0`.
  ///
  /// Example:
  /// ```dart
  /// SadjaProgressStepper(
  ///   steps: [...],
  ///   currentStep: 2,
  ///   completedSteps: [0, 1],
  ///   onStepTapped: (index) => print(index),
  ///   activeStepColor: Colors.blue,
  ///   completedStepColor: Colors.green,
  ///   incompleteStepColor: Colors.grey,
  ///   activeIconColor: Colors.white,
  ///   completedIconColor: Colors.white,
  ///   incompleteIconColor: Colors.black,
  ///   activeTextColor: Colors.white,
  ///   completedTextColor: Colors.white,
  ///   incompleteTextColor: Colors.black,
  /// )
  /// ```
  const SadjaProgressStepper({
    super.key,
    required this.steps,
    this.currentStep = 0,
    required this.completedSteps,
    required this.onStepTapped,
    this.isLinear = true,
    this.visibleSteps = 3,

    // Step Indicator Colors
    required this.activeStepColor,
    required this.completedStepColor,
    required this.incompleteStepColor,

    // Icon & Text Colors
    required this.activeIconColor,
    required this.completedIconColor,
    required this.incompleteIconColor,
    required this.activeTextColor,
    required this.completedTextColor,
    required this.incompleteTextColor,

    // Line Colors
    this.activeLineColor,
    this.completedLineColor,
    this.incompleteLineColor,
    this.activeLineFollowsCompletedColor = false,

    // Label Customization
    this.showLabels = false,
    this.labelColorMode = LabelColorMode.static,
    this.labelStaticColor = Colors.grey,
  });

  @override
  State<SadjaProgressStepper> createState() => _SadjaProgressStepperState();
}

/// Enum for controlling label color behavior
enum LabelColorMode { static, dynamic }

class _SadjaProgressStepperState extends State<SadjaProgressStepper> {
  late int _currentStep;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Initialize the current step with the provided widget value
    _currentStep = widget.currentStep;

    // Ensure scrolling is adjusted after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentStep());
  }

  /// Scrolls the stepper to ensure the current step is visible.
  ///
  /// This function calculates the required scroll offset based on the number
  /// of visible steps, dynamically adjusts the line width between steps, and
  /// smoothly scrolls to bring the current step into view if needed.
  void _scrollToCurrentStep() {
    // Ensure the widget is still mounted before proceeding
    if (!mounted) return;

    // Get the constraints of the widget to determine its width
    final constraints = context.findRenderObject() as RenderBox?;
    if (constraints == null) return;

    // Determine the total width available for the stepper
    double stepperWidth =
        constraints.size.width * 0.9; // 90% of available width
    double stepWidth = 60; // Fixed width for each step
    int numVisibleSteps =
        widget.visibleSteps; // Number of steps visible at once

    // Calculate the dynamic width of the lines connecting the steps
    double totalStepWidth = stepWidth * numVisibleSteps;
    double remainingWidth = stepperWidth - totalStepWidth;
    double lineWidth = remainingWidth / (numVisibleSteps - 1);

    // Determine if scrolling is needed when the current step is beyond the visible range
    if (widget.currentStep >= numVisibleSteps - 1) {
      // Compute the scroll offset to bring the current step into view
      double offset = (stepWidth + lineWidth) *
          (widget.currentStep - (numVisibleSteps - 1));

      // Smoothly animate scrolling to the calculated offset
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Determines the background color of the step based on its state
  /// Returns the background color of a step based on its state.
  /// - Active step: Uses `activeStepColor`
  /// - Completed steps: Uses `completedStepColor`
  /// - Incomplete steps: Uses `incompleteStepColor`
  /// if a step is completed, it keeps its completed color even when active.
  Color _getStepColor(int index) {
    if (widget.completedSteps.contains(index)) {
      return widget.completedStepColor; // Completed steps always take priority
    } else if (index == _currentStep) {
      return widget.activeStepColor;
    } else {
      return widget.incompleteStepColor;
    }
  }

  /// Determines the icon color based on step state
  /// Returns the icon color inside a step based on its state.
  /// - Active step: Uses `activeIconColor`
  /// - Completed steps: Uses `completedIconColor`
  /// - Incomplete steps: Uses `incompleteIconColor`
  Color _getIconColor(int index) {
    if (widget.completedSteps.contains(index)) {
      return widget.completedIconColor; // Completed steps always take priority
    } else if (index == _currentStep) {
      return widget.activeIconColor;
    } else {
      return widget.incompleteIconColor;
    }
  }

  /// Determines the text color based on step state
  /// Returns the text color inside a step based on its state.
  /// - Active step: Uses `activeTextColor`
  /// - Completed steps: Uses `completedTextColor`
  /// - Incomplete steps: Uses `incompleteTextColor`
  Color _getTextColor(int index) {
    if (widget.completedSteps.contains(index)) {
      return widget.completedTextColor; // Completed steps always take priority
    } else if (index == _currentStep) {
      return widget.activeTextColor;
    } else {
      return widget.incompleteTextColor;
    }
  }

  /// Determines the line color between steps
  /// - If one of the steps is the current step, uses `activeLineColor` (or defaults to `completedStepColor`).
  /// - If both steps are completed, uses `completedLineColor` (or defaults to `completedStepColor`).
  /// - Otherwise, uses `incompleteLineColor` (or defaults to `incompleteStepColor`).
  ///  Lines between two completed steps will always be marked as completed.
  Color _getLineColor(int prevStep, int nextStep) {
    bool isPrevCompleted = widget.completedSteps.contains(prevStep);
    bool isNextCompleted = widget.completedSteps.contains(nextStep);

    if (isPrevCompleted && isNextCompleted) {
      return widget.completedLineColor ??
          widget.completedStepColor; // Completed steps take priority
    } else if (prevStep == _currentStep || nextStep == _currentStep) {
      return widget.activeLineColor ?? widget.completedStepColor;
    } else {
      return widget.incompleteLineColor ?? widget.incompleteStepColor;
    }
  }

  /// Builds a single step indicator, which consists of:
  /// - A circular step container that changes color based on step status.
  /// - An icon or text inside the step.
  /// - An optional label displayed below the step (if `showLabels` is enabled).
  Widget _buildStepIndicator(int index) {
    final StepItem step = widget.steps[index];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _goToStep(index),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStepColor(index),
            ),
            child: Center(
              child: step.text != null && step.text!.trim().isNotEmpty
                  ? Text(
                      step.text!.trim(),
                      style: TextStyle(
                        color: _getTextColor(index),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Icon(
                      step.icon, // Always non-null
                      color: _getIconColor(index),
                      size: 30,
                    ),
            ),
          ),
        ),

        // Show label if enabled
        if (widget.showLabels && step.label != null) ...[
          const SizedBox(height: 4),
          Text(
            step.label!.trim(),
            style: TextStyle(
              color: widget.labelColorMode == LabelColorMode.static
                  ? widget.labelStaticColor
                  : _getStepColor(index),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the stepper layout with horizontal scrolling when necessary.
  /// - Each step is displayed in sequence with a connecting line in between.
  /// - Uses `SingleChildScrollView` to allow scrolling if the steps exceed the visible limit.
  /// - Calculates dynamic spacing for steps and lines based on available width.
  Widget _buildScrollableStepper() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double stepperWidth =
            constraints.maxWidth * 0.9; // 90% of available width
        double stepWidth = 60; // Width of each step
        int numVisibleSteps = widget.visibleSteps;

        // Calculate dynamic line width based on available space
        double totalStepWidth = stepWidth * numVisibleSteps;
        double remainingWidth = stepperWidth - totalStepWidth;
        double lineWidth = remainingWidth / (numVisibleSteps - 1);

        return SizedBox(
          width: stepperWidth,
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.steps.length * 2 - 1,
                (index) {
                  if (index.isEven) {
                    int stepIndex = index ~/ 2;
                    return Container(
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      width: stepWidth,
                      child: _buildStepIndicator(stepIndex),
                    );
                  } else {
                    return Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: lineWidth > 0 ? lineWidth : 10,
                        height: 4,
                        color:
                            _getLineColor((index - 1) ~/ 2, (index + 1) ~/ 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// Handles navigation when a step is tapped.
  /// - If `isLinear` is enabled, prevents skipping steps.
  /// - Updates `_currentStep` and triggers `onStepTapped` callback.
  void _goToStep(int step) {
    // Restrict navigation if `isLinear` is enabled
    if (widget.isLinear &&
        step > 0 &&
        !widget.completedSteps.contains(step - 1)) {
      debugPrint("Step $step is locked! Complete previous steps first.");
      return;
    }

    setState(() {
      _currentStep = step;
    });

    // Notify parent about step change
    widget.onStepTapped(step);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stepper Header (Step Indicators + Connecting Lines)
        _buildScrollableStepper(),

        const SizedBox(height: 16),

        // Step Content (Widget that appears when a step is selected)
        Expanded(
          child: widget.steps[_currentStep].content,
        ),
      ],
    );
  }
}
