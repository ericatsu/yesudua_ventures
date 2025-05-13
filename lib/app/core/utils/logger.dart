import 'package:flutter/foundation.dart';

/// A utility class for logging messages in the application.
class Logger {
  /// Logs a debug message to the console.
  ///
  /// Only prints in debug mode.
  static void d(String tag, String message) {
    if (kDebugMode) {
      print('DEBUG | $tag | $message');
    }
  }

  /// Logs an info message to the console.
  ///
  /// Only prints in debug mode.
  static void i(String tag, String message) {
    if (kDebugMode) {
      print('INFO | $tag | $message');
    }
  }

  /// Logs a warning message to the console.
  ///
  /// Only prints in debug mode.
  static void w(String tag, String message) {
    if (kDebugMode) {
      print('WARNING | $tag | $message');
    }
  }

  /// Logs an error message to the console.
  ///
  /// Only prints in debug mode.
  static void e(
    String tag,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      print('ERROR | $tag | $message');
      if (error != null) {
        print('ERROR | $tag | Error: $error');
      }
      if (stackTrace != null) {
        print('ERROR | $tag | Stack Trace: $stackTrace');
      }
    }
  }
}