import 'package:alquran_on_linux/data/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('database opens in memory with schema version 1', () async {
    final AppDatabase db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    expect(db.schemaVersion, 1);
    final rows = await db.customSelect('SELECT 1 AS one').get();
    expect(rows.single.read<int>('one'), 1);
  });
}
