import 'package:flutter/material.dart';

class StepWidget extends StatefulWidget {
  final String stepName;
  final int stepIndex;
  final Function(int, bool) isStepCompleted;

  const StepWidget({
    super.key,
    required this.stepName,
    required this.stepIndex,
    required this.isStepCompleted,
  });

  @override
  State<StepWidget> createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  Future<void> showDialogForStep() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Demo ${widget.stepName}"),
        content: const Text("Mark this step as completed or unmark it?"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.isStepCompleted(
                widget.stepIndex,
                false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Set background color here
            ),
            child: const Text(
              "Unmark",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.isStepCompleted(
                widget.stepIndex,
                true,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Set background color here
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${widget.stepName} text"),
          ElevatedButton(
            onPressed: showDialogForStep,
            child: Text(widget.stepName),
          ),
        ],
      ),
    );
  }
}
