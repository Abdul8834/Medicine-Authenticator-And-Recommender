import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Future<Database> initDb() async {
    try {
      // Get the path for the database file
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, "medicine_database2.db");

      // Print the database path for debugging
      print("Database path: $path");

      // Check if the database file already exists
      final exist = await databaseExists(path);

      if (!exist) {
        // If the database file doesn't exist, copy it from assets
        print("Copying database from assets...");

        // Ensure the directory structure exists
        await Directory(dirname(path)).create(recursive: true);

        // Load the database file from assets
        ByteData data = await rootBundle.load(
            join("assets", "medicine_database2.db"));
        List<int> bytes = data.buffer.asUint8List(
            data.offsetInBytes, data.lengthInBytes);

        // Write the database file to the device storage
        await File(path).writeAsBytes(bytes, flush: true);

        print("Database copied successfully!");
      } else {
        print("Database already exists.");
      }

      // Open the database
      final database = await openDatabase(path);

      // Return the database instance
      return database;
    } catch (e) {
      print("Error initializing database: $e");
      // Handle the error gracefully, possibly inform the user
      throw Exception("Failed to initialize database: $e");
    }
  }

  Future<Map<String, dynamic>> getMedicineInfo(String serialNumber) async {
    final database = await initDb();

    // Define your SQL query to select medicine information based on the serial number
    String query = '''
    SELECT * 
    FROM medicines 
    WHERE serial_number = ?
  ''';

    // Print the SQL query for debugging
    print("SQL Query: $query");

    // Execute the query using the database's rawQuery method
    List<Map<String, dynamic>> result = await database.rawQuery(
        query, [serialNumber]);

    // Print the query result for debugging
    print("Query Result: $result");

    // Check if any rows were returned
    if (result.isNotEmpty) {
      // Return the first row of the result as a Map<String, dynamic>
      return result.first;
    } else {
      // If no rows were returned, return an empty map
      return {};
    }
  }
}
