import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'survey_data.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'survey_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE surveys(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        nationalId TEXT,
        dateOfBirth TEXT,
        phone TEXT,
        chronicDisease TEXT,
        allergy TEXT,
        medication TEXT,
        familyHistory TEXT
      )
    ''');
  }

  Future<int> insertSurvey(SurveyData survey) async {
    final db = await database;
    return await db.insert('surveys', {
      'name': survey.name,
      'nationalId': survey.nationalId,
      'dateOfBirth': survey.dateOfBirth.toIso8601String(),
      'phone': survey.phone,
      'chronicDisease': survey.chronicDisease,
      'allergy': survey.allergy,
      'medication': survey.medication,
      'familyHistory': survey.familyHistory,
    });
  }

  Future<List<SurveyData>> getSurveys() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('surveys');

    return List.generate(maps.length, (i) {
      return SurveyData(
        name: maps[i]['name'],
        nationalId: maps[i]['nationalId'],
        dateOfBirth: DateTime.parse(maps[i]['dateOfBirth']),
        phone: maps[i]['phone'],
        chronicDisease: maps[i]['chronicDisease'],
        allergy: maps[i]['allergy'],
        medication: maps[i]['medication'],
        familyHistory: maps[i]['familyHistory'],
      );
    });
  }

  Future<int> deleteSurvey(String nationalId) async {
    final db = await database;
    return await db.delete(
      'surveys',
      where: 'nationalId = ?',
      whereArgs: [nationalId],
    );
  }
}
