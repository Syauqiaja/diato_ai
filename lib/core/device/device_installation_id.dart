import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// A stable identifier for this installation.
///
/// The diatom calculator saves readings without ever asking anyone to sign in,
/// so the server needs some way to tell one device's readings from another's.
/// A random value minted on first use and kept in local storage does that
/// without touching a hardware identifier: it identifies the installation, not
/// the person, and it disappears when the app is uninstalled.
class DeviceInstallationId {
  static const String _key = 'device_installation_id';

  String? _cached;

  /// The identifier for this installation, minting one on first call.
  Future<String> get() async {
    final cached = _cached;
    if (cached != null) return cached;

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored != null && stored.isNotEmpty) {
      _cached = stored;
      return stored;
    }

    final generated = _generate();
    await prefs.setString(_key, generated);
    _cached = generated;
    return generated;
  }

  /// 32 hex characters from the platform's secure random source.
  String _generate() {
    final random = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      buffer.write(random.nextInt(256).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
