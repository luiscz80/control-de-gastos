import 'package:control_gastos/models/categories.dart';
import 'package:control_gastos/models/users.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final _databaseName = "gastos.db";
  static final _databaseVersion = 1;

  static final tableExpense = 'expenses';
  static final tableUser = 'users';
  static final tableCategory = 'categories';

  static final columnExpenseId = 'id';
  static final columnTitle = 'title';
  static final columnAmount = 'amount';
  static final columnDate = 'date';
  static final columnCategory = 'categoryId';
  static final columnImagePath = 'imagePath';

  static final columnUserId = 'id';
  static final columnName = 'name';
  static final columnCedula = 'cedula';
  static final columnAddress = 'address';
  static final columnCode = 'code';
  static final columnPhoneNumber = 'phoneNumber';
  static final columnSentAt = 'sentAt';

  static final columnCategoryId = 'id';
  static final columnCategoryName = 'name';

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    print("Creating database version: $version");
    await db.execute('''
      CREATE TABLE $tableExpense (
        $columnExpenseId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnCategory INTEGER,
        $columnDate TEXT NOT NULL,
        $columnImagePath TEXT NOT NULL,
        FOREIGN KEY ($columnCategory) REFERENCES $tableCategory ($columnCategoryId)
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableUser (
        $columnUserId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnCedula TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnCode TEXT NOT NULL,
        $columnPhoneNumber TEXT NOT NULL,
        $columnSentAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableCategory (
        $columnCategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnCategoryName TEXT NOT NULL
      )
    ''');
    // Insertar default categories
    await insertDefaultCategories(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading database from version $oldVersion to $newVersion");
    if (oldVersion < 5) {
      await db.execute('''
        CREATE TABLE ${tableExpense}_temp (
          $columnExpenseId INTEGER PRIMARY KEY,
          $columnTitle TEXT NOT NULL,
          $columnAmount REAL NOT NULL,
          $columnCategory TEXT NOT NULL,
          $columnDate TEXT NOT NULL,
          $columnImagePath TEXT NOT NULL DEFAULT ''
        )
      ''');

      await db.execute('''
        INSERT INTO ${tableExpense}_temp (
          $columnExpenseId, $columnTitle, $columnAmount, $columnCategory, $columnDate, $columnImagePath
        )
        SELECT $columnExpenseId, $columnTitle, $columnAmount, $columnCategory, $columnDate, $columnImagePath
        FROM $tableExpense
      ''');

      await db.execute('DROP TABLE $tableExpense');
      await db
          .execute('ALTER TABLE ${tableExpense}_temp RENAME TO $tableExpense');
    }
  }

  Future<void> insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {columnCategoryName: 'Otros'},
      {columnCategoryName: 'Extras'},
      {columnCategoryName: 'Promociones'},
      {columnCategoryName: 'Viajes'},
      {columnCategoryName: 'Ropa'},
      {columnCategoryName: 'Deporte'},
      {columnCategoryName: 'Educación'},
      {columnCategoryName: 'Servicios'},
      {columnCategoryName: 'Transporte'},
      {columnCategoryName: 'Refrescos'},
      {columnCategoryName: 'Agua'},
      {columnCategoryName: 'Té'},
      {columnCategoryName: 'Café'},
      {columnCategoryName: 'Batidos'},
      {columnCategoryName: 'Jugos'},
      {columnCategoryName: 'Cenas'},
      {columnCategoryName: 'Almuerzos'},
      {columnCategoryName: 'Desayunos'},
      {columnCategoryName: 'Bebidas'},
      {columnCategoryName: 'Comidas'},
    ];

    for (var category in defaultCategories) {
      await db.insert(
        tableCategory,
        category,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print('Categorías insertadas');
    }
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await instance.database;
    try {
      return await db.insert(tableExpense, expense.toMap());
    } catch (e) {
      print('Error al insertar gasto: $e');
      return -1;
    }
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await instance.database;
    try {
      return await db.update(
        tableExpense,
        expense.toMap(),
        where: '$columnExpenseId = ?',
        whereArgs: [expense.id],
      );
    } catch (e) {
      print('Error al actualizar gasto: $e');
      return -1;
    }
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      tableExpense,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllExpenses() async {
    final db = await database;
    await db.delete(tableExpense);
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableExpense);
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  // Método para obtener los gastos semanales
  Future<List<Map<String, dynamic>>> getWeeklyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
      SELECT 
        strftime('%Y-%W', $columnDate) AS week,
        SUM($columnAmount) AS total_amount
      FROM $tableExpense
      GROUP BY week
      ORDER BY week DESC
    ''');
    } catch (e) {
      print('Error al consultar los gastos semanales: $e');
      return [];
    }
  }

  // Método para obtener los gastos mensuales
  Future<List<Map<String, dynamic>>> getMonthlyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
        SELECT 
          strftime('%Y-%m', $columnDate) AS month,
          SUM($columnAmount) AS total_amount
        FROM $tableExpense
        GROUP BY month
        ORDER BY month DESC
      ''');
    } catch (e) {
      print('Error al consultar los gastos mensuales: $e');
      return [];
    }
  }

  // Método para obtener los gastos anuales
  Future<List<Map<String, dynamic>>> getYearlyExpenses() async {
    Database db = await instance.database;
    try {
      return await db.rawQuery('''
        SELECT 
          strftime('%Y', $columnDate) AS year,
          SUM($columnAmount) AS total_amount
        FROM $tableExpense
        GROUP BY year
        ORDER BY year DESC
      ''');
    } catch (e) {
      print('Error al consultar los gastos anuales: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDailyExpenses(DateTime date) async {
    Database db = await instance.database;
    try {
      // Formatear la fecha seleccionada en el formato de la base de datos (YYYY-MM-DD)
      String formattedDate =
          "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      // Consulta para obtener los gastos de la fecha seleccionada
      return await db.query(
        tableExpense,
        where: "$columnDate LIKE ?",
        whereArgs: ['$formattedDate%'],
        columns: [
          columnExpenseId,
          columnTitle,
          columnAmount,
          columnDate,
          columnCategory
        ],
      );
    } catch (e) {
      print('Error al consultar los gastos diarios: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getTotalExpenseAmount() async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM($columnAmount) AS total_amount FROM $tableExpense
    ''');
      return result.isNotEmpty ? result.first : {'total_amount': 0.0};
    } catch (e) {
      print('Error al obtener el monto total de los gastos: $e');
      return {'total_amount': 0.0};
    }
  }

  // Método para buscar gastos
  Future<List<Expense>> searchExpenses(String query) async {
    final db = await database;
    var result = await db.rawQuery('''
      SELECT exp.*, cat.$columnCategoryName AS category_name
      FROM $tableExpense as exp
      LEFT JOIN $tableCategory as cat ON exp.$columnCategory = cat.$columnCategoryId
      WHERE exp.$columnTitle LIKE ? OR exp.$columnAmount LIKE ?
    ''', ['%$query%', '%$query%']);
    List<Expense> expenses =
        result.isNotEmpty ? result.map((e) => Expense.fromMap(e)).toList() : [];
    return expenses;
  }

  // Método para insertar user
  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    try {
      print('Insertando usuario en la base de datos: ${user.toMap()}');
      int id = await db.insert(tableUser, user.toMap());
      print('Usuario insertado con ID: $id');
      return id;
    } catch (e) {
      print('Error al insertar datos de usuario: $e');
      return -1;
    }
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      tableUser,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      tableUser,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<User>> getUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableUser);
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  // Función para actualizar el PIN de seguridad
  Future<void> updatePin(int userId, String newPin) async {
    final db = await database;
    await db.update(
      tableUser,
      {columnCode: newPin},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> result = await db.query(tableUser);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  Future<String?> queryPin(String pin) async {
    Database db = await instance.database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        tableUser,
        where: '$columnCode = ?',
        whereArgs: [pin],
      );
      if (result.isNotEmpty) {
        return result.first[columnCode].toString();
      } else {
        return null;
      }
    } catch (e) {
      print('Error al verificar código: $e');
      return null;
    }
  }

  Future<void> updateVerificationCode(
      {required String phoneNumber, required String code}) async {
    final db = await instance.database;
    await db.update(
      tableUser,
      {columnCode: code},
      where: '$columnPhoneNumber = ?',
      whereArgs: [phoneNumber],
    );
  }

  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert(tableCategory, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateCategory(Category category) async {
    final db = await database;
    await db.update(
      tableCategory,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete(
      tableCategory,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableCategory);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
}
