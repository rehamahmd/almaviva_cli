import 'dart:io';

import 'package:cli_spinner/cli_spinner.dart';
void createFeature(List<String> args) async {
  if (args.isEmpty) {
    print( 'Please provide a feature name.');
    exit(1);
  }
  final featureName = args[0];
  print('Creating feature: $featureName');
  await createModule(featureName);
  // Call function to create feature here (like initProject())
}

Future<void> createModule(String name) async {
  final stopwatch = Stopwatch()..start();
  final spinner = Spinner('🚀 Creating $name module structure');
  spinner.start();

  try {
    // Define all directory and file creations
    final creations = [
      // Directories
      _CreationItem.dir('lib/src/features/$name'),
      _CreationItem.dir('lib/src/features/$name/data'),
      _CreationItem.dir('lib/src/features/$name/data/source'),
      _CreationItem.dir('lib/src/features/$name/data/source/remote'),
      _CreationItem.dir('lib/src/features/$name/data/source/local'),
      _CreationItem.dir('lib/src/features/$name/data/repositories'),
      _CreationItem.dir('lib/src/features/$name/domain'),
      _CreationItem.dir('lib/src/features/$name/domain/entities'),
      _CreationItem.dir('lib/src/features/$name/domain/repositories'),
      _CreationItem.dir('lib/src/features/$name/domain/use_cases'),
      _CreationItem.dir('lib/src/features/$name/presentation'),
      _CreationItem.dir('lib/src/features/$name/presentation/cubit'),
      _CreationItem.dir('lib/src/features/$name/presentation/widgets'),

      // Files
      _CreationItem.file(
        'lib/src/features/$name/data/source/remote/${name}_remote_data_source.dart',
        _generateRemoteDataSourceContent(name),
      ),
      _CreationItem.file(
        'lib/src/features/$name/data/source/local/${name}_local_data_source.dart',
        _generateLocalDataSourceContent(name),
      ),
      _CreationItem.file(
        'lib/src/features/$name/data/repositories/${name}_repository_impl.dart',
        _generateRepositoryContent(name),
      ),
    
      _CreationItem.file(
        'lib/src/features/$name/domain/entities/${name}_entity.dart',
        _generateEntityContent(name),
      ),
      _CreationItem.file(
        'lib/src/features/$name/domain/repositories/${name}_repository.dart',
        _generateRepositoryInterfaceContent(name),
      ),
    ];

    // Execute all creations
    int successCount = 0;
    for (final creation in creations) {
      try {
        if (creation.isDirectory) {
          await _createDirectory(creation.path);
        } else {
          await _createFile(creation.path, creation.content!);
        }
        successCount++;
      } catch (e) {
        print("Failed to create ${creation.path.split('/').last}");
        spinner.stop();
        rethrow;
      }
    }

    stopwatch.stop();
    print('✅ $name module created ($successCount items, ${stopwatch.elapsedMilliseconds}ms)');
    spinner.stop();

    // Print summary
    _printCreationSummary(name, creations.length, stopwatch.elapsed);

  } catch (e) {
    stopwatch.stop();
    print('❌ Failed to create $name module');
    spinner.stop();
    print('\nError details: ${e.toString()}');
    exit(1);
  }
}

class _CreationItem {
  final String path;
  final String? content;
  final bool isDirectory;

  _CreationItem.dir(this.path) : content = null, isDirectory = true;
  _CreationItem.file(this.path, this.content) : isDirectory = false;
}

Future<void> _createDirectory(String path) async {
  final dir = Directory(path);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
}

Future<void> _createFile(String path, String content) async {
  final file = File(path);
  await file.writeAsString(content);
}

void _printCreationSummary(String moduleName, int totalItems, Duration elapsed) {
  print('\n📦 Module Creation Summary');
  print('┌──────────────────────────────────────────────┐');
  print('│ 🏗️  $moduleName Module Structure           │');
  print('├──────────────────────────────┬───────────────┤');
  print('│ Total Items Created          │ ${totalItems.toString().padLeft(14)} │');
  print('│ Execution Time               │ ${_formatDuration(elapsed).padLeft(14)} │');
  print('└──────────────────────────────┴───────────────┘');
  print('\n🌐 Module can now be imported as:');
  print('   import \'package:your_project/src/features/$moduleName/$moduleName.dart\';');
}

String _formatDuration(Duration duration) {
  if (duration.inMilliseconds < 1000) {
    return '${duration.inMilliseconds}ms';
  }
  return '${(duration.inMilliseconds / 1000).toStringAsFixed(2)}s';
}

// Template generators
String _generateRemoteDataSourceContent(String name) {
  final className = '${name.capitalize()}RemoteDataSource';
  return '''
import 'package:injectable/injectable.dart';

@injectable
class $className {
  // Add your remote data source methods here
}
''';
}

String _generateLocalDataSourceContent(String name) {
  final className = '${name.capitalize()}LocalDataSource';
  return '''
import 'package:injectable/injectable.dart';

@injectable
class $className {
  // Add your local data source methods here
}
''';
}

String _generateRepositoryContent(String moduleName) {
  final className = '${moduleName.capitalize()}RepositoryImpl';
    final interfaceName = '${moduleName.capitalize()}Repository';

  return '''
import 'package:injectable/injectable.dart';
import '../source/local/${moduleName}_local_data_source.dart';
import '../source/remote/${moduleName}_remote_data_source.dart';
import '../../domain/repositories/${moduleName}_repository.dart';

@Injectable(as: $interfaceName)
class $className implements $interfaceName {
  final ${moduleName.capitalize()}RemoteDataSource remoteDataSource;
  final ${moduleName.capitalize()}LocalDataSource localDataSource;

  $className(this.remoteDataSource, this.localDataSource);

  // Implement your repository methods here
  @override
  Future<void> someMethod() async {
    // Implementation goes here
  }
}
''';
}

String _generateRepositoryInterfaceContent(String moduleName) {
  final interfaceName = '${moduleName.capitalize()}Repository';
  
  return '''

abstract interface class $interfaceName {
  Future<void> someMethod();
}
''';
}
// ... [similar generators for other files] ...
String _generateEntityContent(String moduleName) {
  final className = '${moduleName.capitalize()}Entity';
  
  return '''
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:equatable/equatable.dart';

part '${moduleName}_entity.freezed.dart';
part '${moduleName}_entity.g.dart';

@freezed
abstract class $className with _\$$className, EquatableMixin {
  const $className._();
  
  const factory $className({
    String? id,
    @Default('') String name,
  }) = _$className;

  factory $className.fromJson(Map<String, dynamic> json) =>
      _\$${className}FromJson(json);

  @override
  List<Object?> get props => [id, name];
  
}
''';
}

extension _StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    
    // Split by underscore and process each word
    final parts = split('_');
    var result = parts[0].isNotEmpty 
        ? "${parts[0][0].toUpperCase()}${parts[0].substring(1).toLowerCase()}"
        : "";

    for (var i = 1; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        result += "${parts[i][0].toUpperCase()}${parts[i].substring(1).toLowerCase()}";
      }
    }

    return result;
  }
}