import 'dart:ffi';

class MethodInvokeArgs extends Struct {
  external Pointer<WChar> methodName;
  external Pointer<Void> target;
  external Pointer<Void> arguments;
  @Int32()
  external int argumentCount;
}
