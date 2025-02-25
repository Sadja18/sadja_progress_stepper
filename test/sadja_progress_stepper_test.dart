import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sadja_progress_stepper/sadja_progress_stepper.dart';

void main() {
  testWidgets(
    'SadjaProgressStepper renders correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SadjaProgressStepper(
            steps: [
              StepItem(icon: Icon(Icons.looks_one), content: Text("Step 1")),
              StepItem(icon: Icon(Icons.looks_two), content: Text("Step 2")),
            ],
            activeStepColor: Colors.blue,
            completedStepColor: Colors.green,
            incompleteStepColor: Colors.grey,
            completedSteps: [0],
            onStepTapped: (step) {
              if(kDebugMode){
                print("Step $step tapped");
              }
            },
          ),
        ),
      );

      expect(find.byType(SadjaProgressStepper), findsOneWidget);
    },
  );
}
