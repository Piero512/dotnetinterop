import 'package:equatable/equatable.dart';

class DotnetEnvironment extends Equatable {
  final String hostfxrVersion;
  final String hostfxrCommitHash;
  final List<DotnetSDK> sdks;
  final List<DotnetFramework> frameworks;

  DotnetEnvironment({
    required this.hostfxrVersion,
    required this.hostfxrCommitHash,
    required this.sdks,
    required this.frameworks,
  });

  @override
  List<Object?> get props => [
        hostfxrVersion,
        hostfxrCommitHash,
        sdks,
        frameworks,
      ];
}

class DotnetSDK extends Equatable {
  final String version;
  final String path;

  DotnetSDK({
    required this.version,
    required this.path,
  });

  @override
  List<Object?> get props => [version, path];
}

class DotnetFramework extends Equatable {
  final String name;
  final String version;
  final String path;

  DotnetFramework({
    required this.name,
    required this.version,
    required this.path,
  });

  @override
  List<Object?> get props => [name, version, path];
}
