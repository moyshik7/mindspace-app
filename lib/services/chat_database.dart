import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/ai_message_model.dart';
import 'package:flutter/foundation.dart';

class ChatDatabase {
  static Database? _database;
  static const String tableName = 'ai_messages';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mindspace_chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            db_id INTEGER PRIMARY KEY AUTOINCREMENT,
            from_role TEXT,
            message TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveMessage(AiMessage message) async {
    try {
      final db = await database;
      await db.insert(
        tableName,
        {
          'from_role': message.from,
          'message': message.message,
          'timestamp': message.timestamp.toIso8601String(),
        },
      );
    } catch (e) {
      debugPrint('Error saving message: $e');
    }
  }

  static Future<List<AiMessage>> getMessages() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        tableName,
        orderBy: 'db_id ASC',
      );

      return List.generate(maps.length, (i) {
        return AiMessage(
          from: maps[i]['from_role'],
          message: maps[i]['message'],
          id: i + 1, // Recalculate IDs for API compliance
          timestamp: DateTime.parse(maps[i]['timestamp']),
        );
      });
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  static Future<void> clearHistory() async {
    try {
      final db = await database;
      await db.delete(tableName);
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }
}
