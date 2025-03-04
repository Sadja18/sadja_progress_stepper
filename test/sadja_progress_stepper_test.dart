import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sadja_progress_stepper/sadja_progress_stepper.dart';

void main() {
  testWidgets(
    'SadjaProgressStepper renders correctly and handles interactions',
    (WidgetTester tester) async {
      int tappedStep = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SadjaProgressStepper(
              steps: [
                StepItem(
                    icon: Icons.looks_one,
                    text: "1",
                    label: "Step 1",
                    content: Text("Step 1 Content")),
                StepItem(
                    icon: Icons.looks_two,
                    text: "2",
                    label: "Step 2",
                    content: Text("Step 2 Content")),
                StepItem(
                    icon: Icons.looks_3,
                    text: "3",
                    label: "Step 3",
                    content: Text("Step 3 Content")),
              ],
              activeStepColor: Colors.blue,
              completedStepColor: Colors.green,
              incompleteStepColor: Colors.grey,
              activeIconColor: Colors.white,
              completedIconColor: Colors.white,
              incompleteIconColor: Colors.black,
              activeTextColor: Colors.white,
              completedTextColor: Colors.white,
              incompleteTextColor: Colors.black,
              activeLineColor: Colors.blueAccent,
              completedLineColor: Colors.green,
              incompleteLineColor: Colors.grey,
              activeLineFollowsCompletedColor: true,
              showLabels: true,
              labelColorMode: LabelColorMode.dynamic,
              labelStaticColor: Colors.black,
              completedSteps: [0],
              visibleSteps: 2,
              isLinear: true,
              onStepTapped: (step) {
                tappedStep = step;
                if (kDebugMode) {
                  print("Step $step tapped");
                }
              },
            ),
          ),
        ),
      );

      // Verify the stepper renders
      expect(find.byType(SadjaProgressStepper), findsOneWidget);

      // Verify the first step is rendered correctly
      expect(find.text("1"), findsOneWidget);
      expect(find.text("Step 1"), findsOneWidget);

      // Verify tapping a step calls the callback
      await tester.tap(find.text("2"));
      await tester.pump();
      expect(tappedStep, 1); // Ensure the callback updated the tapped step
    },
  );
}
