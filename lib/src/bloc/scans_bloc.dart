import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validator {

  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //Obtener Scans de la Base de datos.
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);


  dispose() {
    _scansController?.close();
  }

  obtenerScans() async{
    _scansController.sink.add( await DBProvider.db.GetAllScans() );
  }

  agregarScan( ScanModel scan) async {
    await DBProvider.db.InsertScan(scan);
    obtenerScans();
  }

  borrarScan( int id ) async {
    await DBProvider.db.DeleteScan(id);
    obtenerScans();
  }

  borrarScans() async {
    await DBProvider.db.DeleteAll();
    obtenerScans();
  }


}