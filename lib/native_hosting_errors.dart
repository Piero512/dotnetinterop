abstract class NativeHostingErrors {
  static const String codeDocumentation =
      'https://github.com/dotnet/runtime/blob/main/docs/design/features/host-error-codes.md';

  NativeHostingErrors._();

  /// bit width of HResults
  static const _bW = 32;

  /// Success error codes.
  static const int success = 0x0;
  static const int successHostAlreadyInitialized = 0x1;
  static const int successDifferentRuntimeProperties = 0x2;

  /// Failure error codes

  static final invalidArgFailure = 0x80008081.toSigned(_bW);
  static final coreHostLibLoadFailure = 0x80008082.toSigned(_bW);
  static final coreHostLibMissingFailure = 0x80008083.toSigned(_bW);
  static final coreHostEntryPointFailure = 0x80008084.toSigned(_bW);
  static final coreHostCurHostFindFailure = 0x80008085.toSigned(_bW);
  static final coreClrResolveFailure = 0x80008087.toSigned(_bW);
  static final coreClrBindFailure = 0x80008088.toSigned(_bW);
  static final coreClrInitFailure = 0x80008089.toSigned(_bW);
  static final coreClrExeFailure = 0x8000808a.toSigned(_bW);
  static final resolverInitFailure = 0x8000808b.toSigned(_bW);
  static final resolverResolveFailure = 0x8000808c.toSigned(_bW);
  static final libHostCurExeFindFailure = 0x8000808d.toSigned(_bW);
  static final libHostInitFailure = 0x8000808e.toSigned(_bW);
  static final libHostSdkFindFailure = 0x80008091.toSigned(_bW);
  static final libHostInvalidArgs = 0x80008092.toSigned(_bW);
  static final invalidConfigFile = 0x80008093.toSigned(_bW);
  static final appArgNotRunnable = 0x80008094.toSigned(_bW);
  static final appHostExeNotBoundFailure = 0x80008095.toSigned(_bW);
  static final frameworkMissingFailure = 0x80008096.toSigned(_bW);
  static final hostApiFailed = 0x80008097.toSigned(_bW);
  static final hostApiBufferTooSmall = 0x80008098.toSigned(_bW);
  static final libHostUnknownCommand = 0x80008099.toSigned(_bW);
  static final libHostAppRootFindFailure = 0x8000809a.toSigned(_bW);
  static final sdkResolverResolveFailure = 0x8000809b.toSigned(_bW);
  static final frameworkCompatFailure = 0x8000809c.toSigned(_bW);
  static final frameworkCompatRetry = 0x8000809d.toSigned(_bW);
  static final appHostExeNotBundle = 0x8000809e.toSigned(_bW);
  static final bundleExtractionFailure = 0x8000809f.toSigned(_bW);
  static final bundleExtractionIOError = 0x800080a0.toSigned(_bW);
  static final libHostDuplicateProperty = 0x800080a1.toSigned(_bW);
  static final hostApiUnsupportedVersion = 0x800080a2.toSigned(_bW);
  static final hostInvalidState = 0x800080a3.toSigned(_bW);
  static final hostPropertyNotFound = 0x800080a4.toSigned(_bW);
  static final coreHostIncompatibleConfig = 0x800080a5.toSigned(_bW);
  static final hostApiUnsupportedScenario = 0x800080a6.toSigned(_bW);
  static final hostFeatureDisabled = 0x800080a7.toSigned(_bW);

  static final Map<int, String> errCodeToString = {
    success: 'Success',
    successHostAlreadyInitialized: 'Success_HostAlreadyInitialized',
    successDifferentRuntimeProperties: 'Success_DifferentRuntimeProperties',
    invalidArgFailure: 'invalidArgFailure',
    coreHostLibLoadFailure: 'coreHostLibLoadFailure',
    coreHostLibMissingFailure: 'coreHostLibMissingFailure',
    coreHostEntryPointFailure: 'coreHostEntryPointFailure',
    coreHostCurHostFindFailure: 'coreHostCurHostFindFailure',
    coreClrResolveFailure: 'coreClrResolveFailure',
    coreClrBindFailure: 'coreClrBindFailure',
    coreClrInitFailure: 'coreClrInitFailure',
    coreClrExeFailure: 'coreClrExeFailure',
    resolverInitFailure: 'resolverInitFailure',
    resolverResolveFailure: 'resolverResolveFailure',
    libHostCurExeFindFailure: 'libHostCurExeFindFailure',
    libHostInitFailure: 'libHostInitFailure',
    libHostSdkFindFailure: 'libHostSdkFindFailure',
    libHostInvalidArgs: 'libHostInvalidArgs',
    invalidConfigFile: 'invalidConfigFile',
    appArgNotRunnable: 'appArgNotRunnable',
    appHostExeNotBoundFailure: 'appHostExeNotBoundFailure',
    frameworkMissingFailure: 'frameworkMissingFailure',
    hostApiFailed: 'hostApiFailed',
    hostApiBufferTooSmall: 'hostApiBufferTooSmall',
    libHostUnknownCommand: 'libHostUnknownCommand',
    libHostAppRootFindFailure: 'libHostAppRootFindFailure',
    sdkResolverResolveFailure: 'sdkResolverResolveFailure',
    frameworkCompatFailure: 'frameworkCompatFailure',
    frameworkCompatRetry: 'frameworkCompatRetry',
    appHostExeNotBundle: 'appHostExeNotBundle',
    bundleExtractionFailure: 'bundleExtractionFailure',
    bundleExtractionIOError: 'bundleExtractionIOError',
    libHostDuplicateProperty: 'libHostDuplicateProperty',
    hostApiUnsupportedVersion: 'hostApiUnsupportedVersion',
    hostInvalidState: 'hostInvalidState',
    hostPropertyNotFound: 'hostPropertyNotFound',
    coreHostIncompatibleConfig: 'coreHostIncompatibleConfig',
    hostApiUnsupportedScenario: 'hostApiUnsupportedScenario',
    hostFeatureDisabled: 'hostFeatureDisabled',
  };

  static String nativeHostErrorToString(int error) {
    return errCodeToString[error] ??
        'Unknown error: ${error.toRadixString(16)}';
  }
}

class NativeHostException {
  final int hResult;

  NativeHostException(this.hResult);

  @override
  String toString() {
    return 'NativeHostException: ${NativeHostingErrors.nativeHostErrorToString(hResult)}';
  }
}
