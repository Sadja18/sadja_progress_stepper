import 'package:flutter/material.dart';

import 'views/widgets/steppers.dart/linear.dart/linear.dart';
import 'views/widgets/steppers.dart/linear_with_steps_reset.dart/linear_with_steps_reset.dart';
import 'views/widgets/steppers.dart/non_linear.dart/non_linear.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedTabIndex = 0;

  void _onTabChanged(int selectedTabIndex) {
    setState(() {
      _selectedTabIndex = selectedTabIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: ThemeData,
          title: Text("Sadja Progress"),
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.0,
            horizontal: 2.0,
          ),
          // child:
          child: _selectedTabIndex == 0
              ? StepperLinear()
              : _selectedTabIndex == 1
                  ? StepperNonLinear()
                  : StepperLinearWithStepsReset(),
        ), // This trailing comma makes auto-formatting nicer for build methods.
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _onTabChanged,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Linear',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Non-Linear',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Steps Reset',
            ),
          ],
        ),
      ),
    );
  }
}
