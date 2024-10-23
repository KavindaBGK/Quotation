import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'ItemModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('item_details.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> deleteExistingDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'item_details.db');
    await deleteDatabase(path);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Item_Details(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item_name TEXT NOT NULL,
        price REAL NOT NULL
      )
    ''');

    // Create the Quotations table
    await db.execute('''
      CREATE TABLE Quotation(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        qty INTEGER NOT NULL,
        discount REAL NOT NULL,
        total REAL NOT NULL
      )
    ''');

    await db.insert('Item_Details', {'item_name': 'Item 1', 'price': 50.00});
    await db.insert('Item_Details', {'item_name': 'Item 2', 'price': 60.00});
    await db.insert('Item_Details', {'item_name': 'Item 3', 'price': 70.00});

    print('Tables created: Item_Details and Quotation'); // Debug print
  }

  Future<List<Item>> getItems() async {
    final db = await instance.database;
    final result = await db.query('Item_Details');
    return result
        .map((json) => Item(
              id: json['id'] as int,
              name: json['item_name'] as String,
              price: json['price'] as double,
            ))
        .toList();
  }

  Future<List<Quotation>> getItems1() async {
    final db = await instance.database;
    final result1 = await db.query('Quotation');
    return result1.map((json) => Quotation.fromMap(json)).toList();
  }

  Future<void> saveQuotation(List<Map<String, dynamic>> items) async {
    print(items);
    final db = await instance.database;
    print(db);

    for (var item in items) {
      try {
        await db.insert('Quotation', item);
      } catch (e) {
        print('Error inserting item: $e');
      }
    }
  }
}
