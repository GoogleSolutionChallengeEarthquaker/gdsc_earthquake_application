import "dart:io";

import 'package:flutter/material.dart';
import "package:workmanager/workmanager.dart";

class WorkManagerTest extends StatefulWidget {
  const WorkManagerTest({super.key});

  @override
  State<WorkManagerTest> createState() => _WorkManagerTestState();
}

const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simplePeriodicTask:
        break;
      case simplePeriodic1HourTask:
        break;
    }

    return Future.value(true);
  });
}

class _WorkManagerTestState extends State<WorkManagerTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Workmanager().initialize(
                  callbackDispatcher,
                  isInDebugMode: true,
                );
              },
              child: const Text("start")),
          ElevatedButton(
              onPressed: Platform.isAndroid
                  ? () {
                      Workmanager().registerPeriodicTask(
                        simplePeriodicTask,
                        simplePeriodicTask,
                        initialDelay: const Duration(seconds: 10),
                      );
                    }
                  : null,
              child: const Text("stop")),
        ],
      ),
    );
  }
}
