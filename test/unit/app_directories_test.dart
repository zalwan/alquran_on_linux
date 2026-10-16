import 'package:alquran_on_linux/core/platform/app_directories.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prefers the application-id directory', () {
    const AppDirectories dirs = AppDirectories();
    expect(
      dirs.supportPath(
        dataHome: '/home/u/.local/share',
        idDirExists: true,
        legacyDirExists: true,
      ),
      '/home/u/.local/share/org.alquran.Reader',
    );
  });

  test('falls back to the legacy executable-name directory', () {
    const AppDirectories dirs = AppDirectories();
    expect(
      dirs.supportPath(
        dataHome: '/home/u/.local/share',
        idDirExists: false,
        legacyDirExists: true,
      ),
      '/home/u/.local/share/alquran_on_linux',
    );
  });

  test('fresh installs use the application-id path', () {
    const AppDirectories dirs = AppDirectories();
    expect(
      dirs.supportPath(
        dataHome: '/home/u/.local/share',
        idDirExists: false,
        legacyDirExists: false,
      ),
      '/home/u/.local/share/org.alquran.Reader',
    );
  });
}
