import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:sadja_progress_stepper/sadja_progress_stepper.dart';

import 'views/widgets/Steps/step.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentStep = 0;
  final List<int> _completedSteps = [];

  late List<StepItem>? steps;

  void _onStepTapped(int stepIndex) {
    debugPrint("Step $stepIndex tapped");
    setState(() {
      _currentStep = stepIndex;
    });
  }

  void _toggleStepCompletion(int stepIndex, bool isCompleted) {
    debugPrint("toggle completion step $stepIndex $isCompleted");
    setState(() {
      if (isCompleted) {
        if (!_completedSteps.contains(stepIndex)) {
          _completedSteps.add(stepIndex);

          // move to next step if possible
          if (steps != null &&
              _currentStep >= 0 &&
              _currentStep < steps!.length - 1) {
            _currentStep++;
          }
        }
      } else {
        _completedSteps.remove(stepIndex);
      }
    });

    if (kDebugMode) {
      print(_completedSteps);
    }
  }

  @override
  void initState() {
    steps = List.generate(
      5,
      (index) => StepItem(
        content: StepWidget(
          stepName: "Step $index",
          stepIndex: index,
          isStepCompleted: _toggleStepCompletion,
        ),
        icon: index % 2 == 0
            ? Icons.check_circle_outline
            : Icons.list_alt_rounded,
        label: "Step $index",
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SadjaProgressStepper(
          key: ValueKey(
            "$_currentStep $_completedSteps",
          ), // Forces a rebuild when _currentStep changes
          steps: steps!,
          currentStep: _currentStep,
          completedSteps: _completedSteps,
          activeStepColor: Colors.blue,
          completedStepColor: Colors.green,
          incompleteStepColor: Colors.grey,
          activeIconColor: Colors.white,
          completedIconColor: Colors.white,
          incompleteIconColor: Colors.black,
          activeTextColor: Colors.white,
          completedTextColor: Colors.white,
          incompleteTextColor: Colors.black,
          onStepTapped: _onStepTapped,
          showLabels: true,
        ),
      ),
    );
  }
}
