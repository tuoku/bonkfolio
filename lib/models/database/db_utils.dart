import 'package:drift/drift.dart';
import 'package:undo/undo.dart';

extension TableUtils on GeneratedDatabase {
  Future<void> deleteRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final _change = Change(
      val,
      () async => await delete(table as TableInfo).delete(val),
      (dynamic old) async => await into(table as TableInfo).insert(old),
    );
    cs.add(_change);
  }

  Future<void> insertRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final _change = Change(
      val,
      () async => await into(table as TableInfo).insert(val),
      (dynamic val) async => await delete(table as TableInfo).delete(val),
    );
    cs.add(_change);
  }

  Future<void> updateRow(
    ChangeStack cs,
    Table table,
    Insertable val,
  ) async {
    final oldVal = await (select(table as TableInfo)..whereSamePrimaryKey(val))
        .getSingle();
    final _change = Change(
      oldVal,
      () async => await update(table).replace(val),
      (dynamic old) async => await update(table).replace(old),
    );
    cs.add(_change);
  }
}

Value<T> addField<T>(T? val, {T? fallback}) {
  Value<T>? _fallback;

  if (fallback != null) {
    _fallback = Value<T>(fallback);
  }

  if (val == null) {
    return _fallback ?? const Value.absent();
  }

  if (val is String && (val == 'null' || val == 'Null')) {
    return _fallback ?? const Value.absent();
  }

  return Value(val);
}
