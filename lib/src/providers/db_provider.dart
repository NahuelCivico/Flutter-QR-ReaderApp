import 'dart:io';

import 'package:path/path.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if( _database != null ) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDictionary = await getApplicationDocumentsDirectory();

    final path = join( documentsDictionary.path, 'ScansDB.db' );

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: ( Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  InsertScanRaw( ScanModel model ) async {
    
    final db = await database;

    final resp = await db.rawInsert(
      "INSERT INTO Scans (id, tipo, valor) "
      "VALUES ( ${ model.id }, '${ model.tipo }', '${ model.valor }')"
    );

    return resp;
  }

  InsertScan( ScanModel model ) async {

    final db = await database;

    final resp = await db.insert('Scans', model.toJson());

     return resp;
  } 

  Future<ScanModel> GetScanById( int id ) async {

    final db = await database;

    final resp = await db.query('Scans', where: 'id = ?', whereArgs: [id]);

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;
  }

  Future<List<ScanModel>> GetAllScans() async {

    final db = await database;

    final resp = await db.query('Scans');

    List<ScanModel> list = resp.isNotEmpty 
                              ? resp.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];

    return list;
  }

  Future<List<ScanModel>> GetAllScansByType( String tipo ) async {

    final db = await database;

    final resp = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);

    List<ScanModel> list = resp.isNotEmpty 
                              ? resp.map( (c) => ScanModel.fromJson(c) ).toList()
                              : [];

    return list;
  }

  Future<int> UpdateScan( ScanModel model ) async {

    final db = await database;

    final resp = await db.update('Scans', model.toJson(), where: 'id = ?', whereArgs: [model.id]);

    return resp;
  }

  Future<int> DeleteScan( int id ) async {

    final db = await database;

    final resp = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return resp;
  }

  Future<int> DeleteAll() async {

    final db = await database;

    final resp = await db.delete('Scans');

    return resp;
  }
}