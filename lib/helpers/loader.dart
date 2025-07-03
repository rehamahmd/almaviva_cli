import 'dart:async';
import 'dart:io';

import 'package:almaviva_cli/actions/create_project.dart';

Future<void> showLoader(StreamController<bool> c) async {
  final spinners = ['|', '/', '—', '\\'];
  int i = 0;

  // Listen for the loading state from the stream controller
  await for (final loading in controller.stream) {
    if (loading) {
      while (loading) {
        stdout
            .write('\r${spinners[i % spinners.length]} Processing... $loading');
        i++;
        await Future.delayed(Duration(milliseconds: 100));
        if (!loading) break; // Exit loop if loading stops
      }
    }

    // Cleanup: Clear spinner line after stopping
    stdout.write('\r                    \r'); // Clear line
    stdout.write('Done! ✅\n'); // Final message
  }
}
