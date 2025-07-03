import 'dart:async';
import 'dart:io';

import 'package:almaviva_cli/helpers/loader.dart';

class CloneProject {
  CloneProject._();

  static Future<void> cloneProject(List<String> args) async {
    final repoUrl = "https://github.com/rehamahmd/flutter_starter_kit.git";
    final repoName =
        args.last; // ?? repoUrl.split('/').last.replaceAll('.git', '');
    print('Cloning repository: $repoUrl');
    // Create a stream controller to manage the loader
    final controller = StreamController<bool>();

    // Start the loader
    showLoader(controller);
    controller.add(true); // Signal that loading has started

    try {
      final result = await Process.run('git', ['clone', repoUrl]);

      // Print output and error from the process
      stdout.write(result.stdout);
      stderr.write(result.stderr);

      if (result.exitCode == 0) {
        print('Repo cloned successfully.');
        print('Navigate to "$repoName" and run "flutter pub get".');
      } else {
        print('Failed to clone the repository.');
      }
    } catch (e) {
      // Handle errors gracefully

      print('An error occurred while cloning the repository: $e');
    }
    controller.add(false);
    await controller.close();
    stdout.write('\r \r');
    stdout.write('\r END \r');
  }
}
