import 'package:flutter/material.dart';
import 'package:sadja_progress_stepper/src/step_item.dart';

class SadjaProgressStepper extends StatefulWidget {
  final List<StepItem> steps;
  final int currentStep;
  final List<int> completedSteps;
  final Color activeStepColor;
  final Color completedStepColor;
  final Color incompleteStepColor;
  final Function(int) onStepTapped; // ✅ Add callback
  final bool isLinear;

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

  Color _getStepColor(int index) {
    if (index == widget.currentStep) {
      return widget.activeStepColor;
    } else if (widget.completedSteps.contains(index)) {
      return widget.completedStepColor;
    } else {
      return widget.incompleteStepColor;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;
  }

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
