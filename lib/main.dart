import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dotnetinterop/native_hosting_errors.dart';
import 'package:ffi/ffi.dart';

import 'dotnet_interop.dart';
import 'hostfxr_bindings.dart';
import 'models.dart';
import 'nethost_bindings.dart';

extension StringWChar on Pointer<WChar> {
  String toDartString({int? length}) {
    if (Platform.isWindows) {
      return cast<Utf16>().toDartString(length: length);
    } else {
      return cast<Utf8>().toDartString(length: length);
    }
  }
}

Map<int, Function> closureMap = {};

const dotnetRuntimeOptions = {
  'runtimeOptions': {
    'tfm': 'netcoreapp3.1',
    'framework': {'name': 'Microsoft.NETCore.App', 'version': '3.1.0'},
    'rollForward': 'LatestMajor',
    'configProperties': {
      'System.Globalization.UseNls': true,
      'System.Threading.ThreadPool.MinThreads': 4,
    }
  }
};

Future<File> writeRuntimeConfigFile() {
  var f = File('runtimeconfig.json');
  return f.writeAsString(jsonEncode(dotnetRuntimeOptions));
}

Future<Pointer<hostfxr_handle>> initializeRuntime(HostFXR hostfxr) async {
  return using((alloc) async {
    final runtimeHost = calloc.call<hostfxr_handle>();
    final f = await writeRuntimeConfigFile();
    final runtimeOptions = f.absolute.path.toNativeUtf16(allocator: alloc);
    final result = hostfxr.hostfxr_initialize_for_runtime_config(
        runtimeOptions.cast(), nullptr, runtimeHost);
    if (result >= 0) {
      return runtimeHost;
    } else {
      throw NativeHostException(result);
    }
  });
}

void _dotnetEnvCallback(
    Pointer<hostfxr_dotnet_environment_info> info, Pointer<Void> cbNr) {
  final cb = closureMap[cbNr.address];
  if (cb != null) {
    cb.call(info);
  } else {
    print("Method not found!");
  }
}

DotnetEnvironment getDotnetEnvironment(HostFXR hostfxr) {
  final sdks = <DotnetSDK>[];
  final frameworks = <DotnetFramework>[];
  late final String version;
  late final String commitHash;
  void _cb(
    Pointer<hostfxr_dotnet_environment_info> info,
  ) {
    version = info.ref.hostfxr_version.toDartString();
    commitHash = info.ref.hostfxr_commit_hash.toDartString();
    for (var i = 0; i < info.ref.sdk_count; i++) {
      final sdk = info.ref.sdks.elementAt(i);
      final sdkVersion = sdk.ref.version.toDartString();
      final sdkPath = sdk.ref.path.toDartString();
      sdks.add(DotnetSDK(version: sdkVersion, path: sdkPath));
    }

    for (var i = 0; i < info.ref.framework_count; i++) {
      final frameworkPtr = info.ref.frameworks.elementAt(i);
      final fName = frameworkPtr.ref.name.toDartString();
      final fVersion = frameworkPtr.ref.version.toDartString();
      final fPath = frameworkPtr.ref.path.toDartString();
      frameworks.add(
        DotnetFramework(name: fName, version: fVersion, path: fPath),
      );
    }
  }

  final ptr = malloc.call<IntPtr>();
  closureMap[ptr.address] = _cb;
  final retval = hostfxr.hostfxr_get_dotnet_environment_info(
      nullptr, nullptr, Pointer.fromFunction(_dotnetEnvCallback), ptr.cast());
  print(NativeHostingErrors.nativeHostErrorToString(retval));
  closureMap.remove(ptr.address);
  malloc.free(ptr);
  return DotnetEnvironment(
    hostfxrVersion: version,
    hostfxrCommitHash: commitHash,
    sdks: sdks,
    frameworks: frameworks,
  );
}

Future<void> restartableMain() async {
  final dl = DynamicLibrary.open(
      '''C:\\Program Files\\dotnet\\packs\\Microsoft.NETCore.App.Host.win-x64\\6.0.9\\runtimes\\win-x64\\native\\nethost.dll''');
  final pathSize = 1024;
  final nethost = NetHost(dl);
  final path = malloc.call<WChar>(pathSize);
  final sizePtr = malloc.call<Size>();
  sizePtr.value = pathSize;
  final retval = nethost.get_hostfxr_path(path, sizePtr, nullptr);
  if (retval >= 0) {
    final hostfxrPath = path.toDartString(length: sizePtr.value);
    print(
      "HostFXR path: $hostfxrPath",
    );
    final dl2 = DynamicLibrary.open(hostfxrPath);
    final hostfxr = HostFXR(dl2);
    final runtimeHandle = await initializeRuntime(hostfxr);
    final interop = DotnetInterop.fromHostFXR(
      fxr: hostfxr,
      runtimeHandle: runtimeHandle,
    );

    final assemblyPath = File(
            'C:\\Users\\piero\\source\\repos\\DartInterop\\DartInterop\\bin\\Debug\\net6.0\\DartInterop.dll')
        .absolute
        .path;
    final typeName = 'DartInterop.ReflectionService, DartInterop';
    final methodName = 'GetNewInstance';
    final newReflectionService = interop
        .loadAssemblyAndGetFunctionPointer(
          assemblyPath,
          typeName,
          methodName,
          DotnetInterop.unmanagedCallersOnly,
        )
        .cast<NativeFunction<Pointer<Void> Function()>>()
        .asFunction<Pointer<Void> Function()>();
    final freeManagedObject = interop
        .loadAssemblyAndGetFunctionPointer(
          assemblyPath,
          typeName,
          'DeallocInstance',
          DotnetInterop.unmanagedCallersOnly,
        )
        .cast<NativeFunction<Void Function(Pointer<Void>)>>()
        .asFunction<void Function(Pointer<Void>)>();
    // Create new ReflectionService.
    final rfService = newReflectionService();
    // Free the ReflectionService
    freeManagedObject(rfService);
    print("Success!");
  } else {
    throw NativeHostException(retval);
  }
}
