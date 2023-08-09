import 'dart:developer';

import 'package:get/get.dart';
import 'package:login/Models/postModel.dart';
// import 'package:mongo_dart/mongo_dart.dart';

import 'dbcreds.dart';

// class slDatabase {
//   static var userCollection;
//   static connect() async {
//     // final db = await Db.create('mongodb://user44:user4412@cluster0.ka6dgk0.mongodb.net/SocialLink?retryWrites=true&w=majority');
//     Db db = await Db('mongodb://localhost:27017');
//     try {
//       await db.open();
//       print('Connected to MongoDB Atlas!');
//       inspect(db);

//       // Perform operations on the database
//     } catch (e) {
//       print('Connection error: $e');
//     } finally {
//       await db.close();
//     }
//     // userCollection = db.collections["Posts"];
//   }

//   static Future<String> insert(postModel data) async {
//     try {
//       var result = await userCollection.insertOne(data.toJson());
//       if (result.isSuccess) {
//         return 'Data Inserted';
//       } else {
//         return 'Something Went Wrong';
//       }
//     } catch (e) {
//       print(e.toString());
//       return e.toString();
//     }
//   }
// }

import 'package:mongo_dart/mongo_dart.dart' show Db, DbCollection;

class DBConnection {
  static DBConnection? _instance;

  final String _host = "localhost";
  final String _port = "27017";
  final String _dbName = "SocialLink";
  Db? _db;

  static getInstance() {
    if (_instance == null) {
      _instance = DBConnection();
    }
    return _instance;
  }

  Future<Db?> getConnection() async {
    if (_db == null) {
      try {
        _db = Db(_getConnectionString());
        await _db!.open();
      } catch (e) {
        print(e);
      }
    }
    return _db;
  }

  _getConnectionString() {
    return "mongodb://$_host:$_port/$_dbName";
  }

  closeConnection() {
    _db!.close();
  }
}
