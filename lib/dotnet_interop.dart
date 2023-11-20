import 'dart:ffi';

import 'package:dotnetinterop/hostfxr_bindings.dart';
import 'package:dotnetinterop/native_hosting_errors.dart';
import 'package:ffi/ffi.dart';

import 'coreclr_delegates.dart';
import 'dart:ffi' as ffi;

/// Assumed delegate type if delegateType is null when getting function pointers.
typedef ComponentEntryPoint = ffi.Int32 Function(
  ffi.Pointer<ffi.Void>,
  ffi.Int32,
);

/// Dart translation of [ComponentEntryPoint], for ease of use when casting function pointers
typedef ComponentEntryPointDart = int Function(
  ffi.Pointer<ffi.Void>,
  int,
);

class DotnetInterop {
  final load_assembly_and_get_function_pointer_dart_fn loadAsmCb;
  final get_function_pointer_dart_fn getFunctionPtr;
  static const unmanagedCallersOnly = 'UNMANAGED_CALLERS_ONLY';
  DotnetInterop._(this.loadAsmCb, this.getFunctionPtr);

  factory DotnetInterop.fromHostFXR({
    required HostFXR fxr,
    required Pointer<hostfxr_handle> runtimeHandle,
  }) {
    final loadAsmFN = calloc.call<load_assembly_and_get_function_pointer_fn>();
    final getFunctionPointerFN = calloc.call<get_function_pointer_fn>();
    final rv = fxr.hostfxr_get_runtime_delegate(
      runtimeHandle.value.cast(),
      hostfxr_delegate_type.hdt_load_assembly_and_get_function_pointer,
      loadAsmFN.cast(),
    );
    if (rv < 0) {
      throw NativeHostException(rv);
    }
    final rv2 = fxr.hostfxr_get_runtime_delegate(
      runtimeHandle.value.cast(),
      hostfxr_delegate_type.hdt_get_function_pointer,
      getFunctionPointerFN.cast(),
    );
    if (rv2 < 0) {
      throw NativeHostException(rv2);
    }
    final loadAsmAndGetFP = loadAsmFN.value
        .asFunction<load_assembly_and_get_function_pointer_dart_fn>();
    final getFunctionPointerFP =
        getFunctionPointerFN.value.asFunction<get_function_pointer_dart_fn>();
    return DotnetInterop._(loadAsmAndGetFP, getFunctionPointerFP);
  }

  /// This function allows you to find static functions on the assembly
  /// at [assemblyPath], with the [typename] as an AssemblyQualifiedTypeName
  /// and a [methodName] with the name of the static method.
  /// You can optionally set a compatible delegate name in [delegateType],
  /// if you don't, the delegate will be generated with a default type of
  /// int MethodName(IntPtr args, int sizeInBytes)
  /// (Link to docs)[https://source.dot.net/#System.Private.CoreLib/src/libraries/System.Private.CoreLib/src/Internal/Runtime/InteropServices/ComponentActivator.cs,35]
  /// or if your function already has the UNMANAGED_CALLERS_ONLY annotation,
  /// use [DotnetInterop.unmanagedCallersOnly] and otherwise call it as usual.

  ffi.Pointer<ffi.NativeFunction> loadAssemblyAndGetFunctionPointer(
    String assemblyPath,
    String typename,
    String methodName, [
    String? delegateType,
  ]) {
    return using((a) {
      final asmPathPtr = assemblyPath.toNativeUtf16(allocator: a);
      final typeNamePtr = typename.toNativeUtf16(allocator: a);
      final methodNamePtr = methodName.toNativeUtf16(allocator: a);
      final ffi.Pointer<Utf16> delegateTypePtr;
      if (delegateType != null) {
        if (delegateType == unmanagedCallersOnly) {
          delegateTypePtr = ffi.Pointer.fromAddress(-1).cast();
        } else {
          delegateTypePtr = delegateType.toNativeUtf16(allocator: a);
        }
      } else {
        delegateTypePtr = ffi.nullptr;
      }
      final reserved = ffi.nullptr; // Reserved parameter
      final outDelegate =
          a.call<ffi.Pointer>().cast<ffi.Pointer<ffi.NativeFunction>>();
      final rv3 = loadAsmCb(
        asmPathPtr.cast(),
        typeNamePtr.cast(),
        methodNamePtr.cast(),
        delegateTypePtr.cast(),
        reserved,
        outDelegate.cast(),
      );
      if (rv3 >= 0) {
        return outDelegate.value;
      }
      throw NativeHostException(rv3);
    });
  }
}
