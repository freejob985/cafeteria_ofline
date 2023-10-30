import 'dart:io' as io;
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Sqldb {
  static final Sqldb _instance = Sqldb._internal();

  factory Sqldb() => _instance;

  Sqldb._internal();

  Database? _database;

  Future<void> initializeDatabase() async {
    try {
      if (_database == null) {
        final io.Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        String dbDirectoryPath = p.join(appDocumentsDir.path, "databases");

        var dbDirectory = io.Directory(dbDirectoryPath);
        if (!(await dbDirectory.exists())) {
          await dbDirectory.create(recursive: true);
        } else {
          print('المجلد موجود مسبقًا');
        }

        String dbPath = p.join(dbDirectoryPath, "myDb.db");

        _database = await databaseFactoryFfi.openDatabase(dbPath);

        // استعلامات للتحقق من وجود الجداول
        final List<String> tableCheckQueries = [
          "SELECT name FROM sqlite_master WHERE type='table' AND name='seat'",
          "SELECT name FROM sqlite_master WHERE type='table' AND name='Category'"
        ];

        // قائمة لتخزين نتائج التحقق من الجداول
        final List<bool> tableExists = [];

        // التحقق من وجود الجداول
        for (final query in tableCheckQueries) {
          List<Map<String, dynamic>> result = await _database!.rawQuery(query);
          tableExists.add(result.isNotEmpty);
        }

        // إنشاء الجداول في حالة عدم وجودها
        if (!tableExists.every((exists) => exists)) {
          final List<String> tableCreationQueries = [
            '''
        CREATE TABLE IF NOT EXISTS 'seat' (
       'id' INTEGER PRIMARY KEY AUTOINCREMENT,
          'seat' TEXT NOT NULL,
          'Product' TEXT,
          'Quantity' TEXT,
          'Total' TEXT,
          'Check' TEXT,
          'TIME' TEXT,
          'Section' TEXT
        )
        ''',
            '''
        CREATE TABLE IF NOT EXISTS 'Category' (
       'id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'Categoryx' TEXT,
        'price' TEXT,
        'ranking' TEXT,
        'ty' TEXT
        )
        ''',
          ];


          for (final query in tableCreationQueries) {
            await _database!.execute(query);
          }

          print("تم إنشاء الجداول");
        } else {
          print("الجداول موجودة مسبقًا");
        }

        print("====================================");
        print("**نقطة توقف للنتائج المحددة**");
        print("تم الاتصال");
        print("====================================");
      }
    } catch (e) {
      print('Error executing SQL: $e');
      throw Exception('Database initialization error: $e');
    }
  }

/*
اضافة بيانات
*/
  Future<int?> insertData(String tableName, Map<String, dynamic> data) async {
    await initializeDatabase();
    return await _database!.insert(tableName, data);
  }

/*
عرض اسماء الجداول في قاعدة البيانات
*/
  Future<List<String>> getTableNames() async {
    await initializeDatabase();
    // استعلم عن جميع الجداول المتاحة في قاعدة البيانات
    final List<Map<String, dynamic>> tables = await _database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table';",
    );

    // قائمة لتخزين أسماء الجداول
    final List<String> tableNames =
        tables.map((table) => table['name'] as String).toList();

    // إرجاع أسماء الداول
    return tableNames;
  }

/*
عرض بيانات الجدول
*/
  Future<List<T>> getAllDataFromTable<T>(
      String tableName, T Function(Map<String, dynamic>) fromMap) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(tableName);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<List<T>> retrieveDataWithFilter<T>(
      String tableName, T Function(Map<String, dynamic>) fromMap,
      {String? where, List<dynamic>? whereArgs, String? orderBy}) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<List<T>?> searchItems<T>(
    String tableName,
    Map<String, dynamic> conditions,
    T Function(Map<String, dynamic>) fromMap,
  ) async {
    try {
      await initializeDatabase();
      // تحضير الجدول والشروط
      final StringBuffer queryBuffer = StringBuffer();
      queryBuffer.write('SELECT * FROM $tableName');

      // إضافة الشروط إذا كانت موجودة
      if (conditions.isNotEmpty) {
        queryBuffer.write(' WHERE ');
        int index = 0;
        conditions.forEach((key, value) {
          queryBuffer.write('$key LIKE ?');
          if (index < conditions.length - 1) {
            queryBuffer.write(' OR ');
          }
          index++;
        });
      }

      final List<dynamic> arguments =
          conditions.values.map((value) => '%$value%').toList();

      final List<Map<String, dynamic>> maps = await _database!.rawQuery(
        queryBuffer.toString(),
        arguments,
      );

      return List.generate(maps.length, (i) {
        return fromMap(maps[i]);
      });
    } catch (e) {
      print("searchItems::::::::: $e");
    }
    return null;
  }

/*
انشاء الجداول 
*/
  String createTableSQL(String tableName, List<Map<String, String>> fields) {
    // تجميع الجدول باستخدام اسم الجدول والحقول
    final StringBuffer queryBuffer = StringBuffer();
    queryBuffer.write('CREATE TABLE IF NOT EXISTS $tableName (');

    // إضافة الحقل "id INTEGER PRIMARY KEY AUTOINCREMENT" كأول حقل
    queryBuffer.write('id INTEGER PRIMARY KEY AUTOINCREMENT, ');

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final fieldName = field['name'];
      final fieldType =
          field['type'] ?? 'TEXT'; // استخدام 'TEXT' كقيمة افتراضية
      final fieldOptions = field['options'] ?? ''; // الخيارات الإضافية للحقل

      queryBuffer.write("'$fieldName' $fieldType $fieldOptions");

      if (i < fields.length - 1) {
        queryBuffer.write(', ');
      }
    }

    queryBuffer.write(');');

    return queryBuffer.toString();
  }

  Future<void> closeDatabase() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
    }
  }

  Future<int> deleteRecord({
    required String tableName,
    required String primaryKey,
    required int id,
  }) async {
    await initializeDatabase();

    return await _database!.delete(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateRecord(String tableName, Map<String, dynamic> values,
      String primaryKey, int id) async {
    await initializeDatabase();
    return await _database!.update(
      tableName,
      values,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
  }

  Future<int> sumFieldWithCondition(String tableName, String fieldToSum,
      {String? conditionField, String? conditionValue}) async {
    int? total;

    final result = await _database!.rawQuery(
      'SELECT SUM($fieldToSum) as total FROM $tableName WHERE $conditionField = ?',
      [conditionValue],
    );

    if (conditionField != null && conditionField.isNotEmpty) {
      final result = await _database!.rawQuery(
        'SELECT SUM($fieldToSum) as total FROM $tableName WHERE $conditionField = ?',
        [conditionValue],
      );
    } else {
      final result = await _database!.rawQuery(
        'SELECT SUM($fieldToSum) as total FROM $tableName',
      );
      total = result.first['total'] as int?;
    }

    if (result.isNotEmpty) {
      final total = result.first['total'] as int?;
      if (total != null) {
        return total;
      }
    }

    return total ?? 0;
  }

  Future<List<T>> getDataWithCustomQuery<T>(
      String customQuery, T Function(Map<String, dynamic>) fromMap) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps =
        await _database!.rawQuery(customQuery);
    return List.generate(maps.length, (i) {
      return fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> executeSqlAndGetList(String sql) async {
    try {
      if (_database == null) {
        final io.Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();

        // Create path for database
        String dbPath = p.join(appDocumentsDir.path, "databases", "myDb.db");
        _database = await openDatabase(dbPath);
      }

      final List<Map<String, dynamic>> results = await _database!.rawQuery(sql);
      return results;
    } catch (e) {
      print('Error executing SQL: $e');
      return [];
    }
  }

// التحقق من وجود صفوف في جدول معين
  Future<bool> tableHasRows(String tableName) async {
    if (_database == null) {
      // يمكنك إما التعامل مع القاعدة البيانات المفقودة هنا أو رفع استثناء
      return false;
    }

    final List<Map<String, dynamic>> result =
        await _database!.rawQuery('SELECT COUNT(*) as count FROM $tableName');
    if (result.isNotEmpty) {
      final int rowCount = result[0]['count'] as int;
      return rowCount > 0;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getRowById(String tableName, int id) async {
    final List<Map<String, dynamic>> result = await _database!.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<void> updateRow(
      String tableName, Map<String, dynamic> dataToUpdate, int id) async {
    // استبدال 'database' بمتغير قاعدة البيانات الخاص بك

    try {
      await _database!.update(
        tableName,
        dataToUpdate,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('تم تحديث الصف بنجاح.');
    } catch (e) {
      print('حدث خطأ أثناء تحديث الصف: $e');
    }
  }

  Future<void> createTablesFromQueries(
      List<String> tableCreationQueries) async {
    await initializeDatabase();
    for (final query in tableCreationQueries) {
      await _database!.execute(query);
    }
  }

  Future<List<String>> getColumnValues(
      String tableName, String columnName) async {
    final List<Map<String, dynamic>> maps =
        await _database!.query(tableName, columns: [columnName]);
    return List.generate(maps.length, (i) {
      return maps[i][columnName].toString();
    });
  }

  Future<List<Map<String, dynamic>>> executeQuery(String query,
      [List<dynamic>? params]) async {
    await initializeDatabase();
    if (params != null && params.isNotEmpty) {
      final List<Map<String, dynamic>> results =
          await _database!.rawQuery(query, params);
      return results;
    } else {
      // قائمة الباراميترز فارغة أو غير معرفة، لذلك يمكنك تنفيذ الاستعلام بدون باراميترز.
      final List<Map<String, dynamic>> results =
          await _database!.rawQuery(query);
      return results;
    }
  }

  Future<int> executeUpdateQuery(
      String updateQuery, List<dynamic> updateValues) async {
    // تأكد من تهيئة قاعدة البيانات أو فتحها
    await initializeDatabase();

    // قم بتنفيذ الاستعلام لتحديث البيانات في الجدول
    int rowsUpdated = await _database!.rawUpdate(updateQuery, updateValues);

    return rowsUpdated; // إرجاع عدد الصفوف التي تم تحديثها
  }

  Future<int> executeDeleteQuery(String deleteQuery,
      [List<dynamic>? deleteValues]) async {
    // تأكد من تهيئة قاعدة البيانات أو فتحها
    await initializeDatabase();

    if (deleteValues != null) {
      // قم بتنفيذ الاستعلام لحذف البيانات من الجدول مع القيم الممررة
      int rowsDeleted = await _database!.rawDelete(deleteQuery, deleteValues);
      return rowsDeleted; // إرجاع عدد الصفوف التي تم حذفها
    } else {
      // قم بتنفيذ الاستعلام لحذف البيانات من الجدول بدون قيم
      int rowsDeleted = await _database!.rawDelete(deleteQuery);
      return rowsDeleted; // إرجاع عدد الصفوف التي تم حذفها
    }
  }
}
