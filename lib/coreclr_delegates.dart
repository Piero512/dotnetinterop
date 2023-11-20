// ignore_for_file: camel_case_types

import 'dart:ffi' as ffi;

typedef load_assembly_and_get_function_pointer_dart_fn = int Function(
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Pointer<ffi.Void>>,
);
typedef load_assembly_and_get_function_pointer = ffi.NativeFunction<
    ffi.Int32 Function(
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Pointer<ffi.Void>>,
)>;

typedef load_assembly_and_get_function_pointer_fn
    = ffi.Pointer<load_assembly_and_get_function_pointer>;

typedef get_function_pointer_dart_fn = int Function(
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Pointer<ffi.Void>>,
);

typedef get_function_pointer = ffi.NativeFunction<
    ffi.Int32 Function(
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.WChar>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Void>,
  ffi.Pointer<ffi.Pointer<ffi.Void>>,
)>;

typedef get_function_pointer_fn = ffi.Pointer<get_function_pointer>;
