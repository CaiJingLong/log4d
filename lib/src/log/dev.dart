part of '../log.dart';

abstract class Dev {
  static var enabled = false;
  static var prefix = '';

  static enable() => enabled = true;
  static disable() => enabled = false;
  // Only log if enabled is true.
  static message(text) {
    if (enabled) Log.message('$prefix$text');
  }

  static error(text) {
    if (enabled) Log.error('$prefix$text');
  }

  static warning(text) {
    if (enabled) Log.warning('$prefix$text');
  }

  static success(text) {
    if (enabled) Log.success('$prefix$text');
  }
}
