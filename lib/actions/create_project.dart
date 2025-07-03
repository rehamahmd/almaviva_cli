import 'dart:async';
import 'dart:io';

import 'package:almaviva_cli/helpers/loader.dart';

final controller = StreamController<bool>();

class FlutterProject {
  FlutterProject._();

  static Future<void> createProject(String projectName) async {
    if (projectName.isEmpty) {
      print('Error: Please provide a valid project name.');
      return;
    }

    print('Creating a new Flutter project: $projectName');

    // Create a stream controller for the loader
    // Start the loader
    await showLoader(controller);
    controller.add(true); // Signal that loading has started

    try {
      // Run the Flutter create command
      final result = await Process.run(
        'flutter',
        ['create', projectName],
        runInShell: false, // Ensure it works across platforms
      ).then((v) async {
        await showLoader(controller);

        // if (v.exitCode == 0) {
        //   print('Project "$projectName" created successfully.');
        //   print('Navigate to the project directory with: cd $projectName');
        // } else {
        //   print('Failed to create the Flutter project.');
        // }
        print("object");
        print(v.hashCode);
        print(v.exitCode);
      });
    } catch (e) {
      // Handle errors gracefully
      controller.add(false);
      await controller.close();
      print('An error occurred while creating the project: $e');
    }
    // Cleanup: Clear spinner line after stopping
    stdout.write('\r                    \r'); // Clear line
    stdout.write('Done! ✅\n'); // Final message
  }
}
