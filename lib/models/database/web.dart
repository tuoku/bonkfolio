import 'package:drift/web.dart';

import '../database.dart';

Future<Database> constructDb({bool logStatements = false}) async {
  return Database(WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('db'),
      logStatements: logStatements));
}
