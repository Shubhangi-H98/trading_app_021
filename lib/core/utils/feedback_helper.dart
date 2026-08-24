import 'package:flutter/services.dart';

class FeedbackHelper {
  const FeedbackHelper._();

  /// Subtle click feel for tab switches, chips, and small UI actions
  static void lightClick() {
    HapticFeedback.lightImpact();
  }

  /// Distinct vibrational bump when swiping to delete or removing a stock
  static void deleteImpact() {
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  /// Pronounced confirmation haptic & sound when an order executes successfully
  static void orderSuccess() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.click);
  }
}