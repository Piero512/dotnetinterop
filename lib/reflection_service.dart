import 'dart:ffi';

import 'package:ffi/ffi.dart';

abstract class CLRObject {
  final Pointer<Void> _gcRef;
  final Pointer<T> Function<T extends NativeType>(
      Pointer<Void> gcRef, String symbolName) _lookup;
  Pointer<void> get me => _gcRef;
  CLRObject(this._gcRef, this._lookup);

  @override
  String toString() {
    //TODO: Resolve toString method of this instance and serialize it back to Dart.
    return 'CLRObject: 0x${_gcRef.address.toRadixString(16).padLeft(16, '0')}';
  }
}

// typedef _addAssemblyToCache =

class ReflectionService extends CLRObject {
  ReflectionService(super._gcRef, super._lookup);

  late final _addAssemblyToCachePtr =
      _lookup<NativeFunction<Bool Function(Pointer<WChar>, Pointer<WChar>)>>(
          _gcRef, 'AddAssemblyToCache');
  late final _addAssemblyToCache = _addAssemblyToCachePtr
      .asFunction<bool Function(Pointer<WChar>, Pointer<WChar>)>();

  bool addAssemblyToCache(String assemblyPath, String assemblyName) {
    return using((a) {
      return _addAssemblyToCache(
        assemblyPath.toNativeUtf16(allocator: a).cast(),
        assemblyName.toNativeUtf16(allocator: a).cast(),
      );
    });
  }
}
