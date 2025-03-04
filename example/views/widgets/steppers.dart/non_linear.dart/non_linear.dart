import 'package:flutter/material.dart';
import 'package:sadja_progress_stepper/sadja_progress_stepper.dart';

import '../../Steps/step.dart';

class StepperNonLinear extends StatefulWidget {
  const StepperNonLinear({super.key});

  @override
  State<StepperNonLinear> createState() => _StepperNonLinearState();
}

class _StepperNonLinearState extends State<StepperNonLinear> {
  int _currentStep = 0;
  List<int> _completedSteps = [];
  late List<StepItem> steps;

  isStepCompleted(int index, bool isStepCompleted) {
    if (index < 0 || index > 3) {
    
      return;
    }

    List<int> updatedSteps = List.from(_completedSteps);

    if (!isStepCompleted) {
      var markAsIncomplete = updatedSteps.remove(index);
      if (markAsIncomplete) {
        setState(() {
          _completedSteps = updatedSteps;
        });
        changeCurrentStep(index);
      }
      return;
    }

    if (!updatedSteps.contains(index)) {  
      updatedSteps.add(index);
      updatedSteps.sort();
    }

    int newCurrentStep =
        (updatedSteps.last + 1 < steps.length - 1) && (index >= 0)
            ? updatedSteps.last + 1
            : steps.length - 1;

    setState(() {
      _completedSteps = updatedSteps;
    });

    changeCurrentStep(newCurrentStep);

   }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ Check if all steps are already completed (e.g., from API or DB)
      if (_completedSteps.length == steps.length) {
        Future.delayed(Duration.zero, () => _showUploadDialog());
      }
    });
  }

  void _showUploadDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("All Steps Completed"),
        content: Text("Your information is ready to upload."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void changeCurrentStep(int stepValue) {
    if (stepValue < 0 || stepValue > 3) {
    }
    setState(() {
      _currentStep = stepValue;
    });
  }

  @override
  void initState() {
    super.initState();

    // _currentStep = 0;
    steps = [
      StepItem(
        icon: Icons.looks_one,
        content: StepWidget(
          stepName: "Step 1",
          stepIndex: 0,
          isStepCompleted: isStepCompleted,
        ),
      ),
      StepItem(
        icon: Icons.looks_two,
        content: StepWidget(
          stepName: "Step 2",
          stepIndex: 1,
          isStepCompleted: isStepCompleted,
        ),
      ),
      StepItem(
        icon: Icons.looks_3,
        content: StepWidget(
          stepName: "Step 3",
          stepIndex: 2,
          isStepCompleted: isStepCompleted,
        ),
      ),
      StepItem(
        icon: Icons.looks_4,
        content: StepWidget(
          stepName: "Step 4",
          stepIndex: 3,
          isStepCompleted: isStepCompleted,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SadjaProgressStepper(
      key: ValueKey(
          "$_currentStep $_completedSteps"), // Forces a rebuild when _currentStep changes
      steps: steps,
      currentStep: _currentStep, // Optional, default is 0
      completedSteps: _completedSteps,
      activeStepColor: Colors.blue,
      completedStepColor: Colors.orange,
      incompleteStepColor: Colors.grey,
      onStepTapped: (step) => changeCurrentStep(step), // ✅ Handle step tap,
      isLinear: false,
      activeIconColor: Colors.white,
      completedIconColor: Colors.white,
      incompleteIconColor: Colors.black,
      activeTextColor: Colors.orange,
      completedTextColor: Colors.orange,
      incompleteTextColor: Colors.black, 
    );
  }
}
