import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/utils.dart'; 

class MapasPage extends StatelessWidget {

  final scanBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scanBloc.obtenerScans();
    
    return StreamBuilder<List<ScanModel>>(
      stream: scanBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if(scans.length == 0) {
          return Center(
            child: Text('No hay información'),
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
              key: UniqueKey(),
              background: Container( color: Colors.red ),
              onDismissed: ( direction ) => {
                scanBloc.borrarScan( scans[i].id )
              },
              child: ListTile(
              leading: Icon( Icons.map, color: Theme.of(context).primaryColor),
              title: Text( scans[i].valor ),
              subtitle: Text('ID: ${ scans[i].id }'),
              trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey ),
              onTap: () => abrirScan(scans[i], context),
            ),
          ),
        );
      },
    );
  }
}