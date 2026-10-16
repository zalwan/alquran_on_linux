import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:xdg_directories/xdg_directories.dart' as xdg;

/// Application data locations on Linux.
///
/// Replaces `path_provider` (whose Android backend dragged the `jni` native
/// plugin — and its libjvm link requirement — into Linux desktop builds).
/// Behavior matches `path_provider_linux.getApplicationSupportPath`
/// exactly, including the legacy executable-name fallback, so existing
/// installs keep their database: `~/.var/app/<id>/` in Flatpak, else
/// `$XDG_DATA_HOME/<id>/`.
///
/// Must equal `APPLICATION_ID` in `linux/CMakeLists.txt`. Reintroduce
/// `path_provider` (not this file) when Android work begins — see ADR-0005.
class AppDirectories {
  const AppDirectories({
    this.applicationId = 'org.alquran.Reader',
    this.legacyName = 'alquran_on_linux',
  });

  final String applicationId;
  final String legacyName;

  /// Pure path selection, unit-tested. Prefers [dataHome]/[applicationId],
  /// falls back to an existing [legacyName] dir, else returns the
  /// application-id path for creation.
  String supportPath({
    required String dataHome,
    required bool idDirExists,
    required bool legacyDirExists,
  }) {
    if (idDirExists) {
      return p.join(dataHome, applicationId);
    }
    if (legacyDirExists) {
      return p.join(dataHome, legacyName);
    }
    return p.join(dataHome, applicationId);
  }

  Future<Directory> ensureSupportDir() async {
    final String home = xdg.dataHome.path;
    final Directory idDir = Directory(p.join(home, applicationId));
    final Directory legacyDir = Directory(p.join(home, legacyName));
    final String selected = supportPath(
      dataHome: home,
      idDirExists: idDir.existsSync(),
      legacyDirExists: legacyDir.existsSync(),
    );
    return Directory(selected).create(recursive: true);
  }
}
