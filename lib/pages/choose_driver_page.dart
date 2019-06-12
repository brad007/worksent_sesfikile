import 'package:flutter/material.dart';
import 'package:worksent_sesfikile/blocs/driver_bloc.dart';
import 'package:worksent_sesfikile/blocs/drivers_bloc.dart';
import 'package:worksent_sesfikile/models/driver_model.dart';
import 'package:worksent_sesfikile/widgets/driver_widget.dart';

class ChooseDriverPage extends StatefulWidget {
  ChooseDriverPage({Key key}) : super(key: key);

  _ChooseDriverPageState createState() => _ChooseDriverPageState();
}

class _ChooseDriverPageState extends State<ChooseDriverPage> {
  final _bloc = DriversBloc();
  
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(title: Text("Choose Driver"),),
       ),
    );
  }

  Widget _buildDrivers(){
    return StreamBuilder(
      initialData: null,
      stream: _bloc.driversStream,
      builder: (BuildContext context, AsyncSnapshot<List<DriverModel>> snapshot){
        ListView(
          children: snapshot.data.map((d){
            return DriverWidget(model: d, onTap: (){
              Navigator.of(context).pop({'selectedDriver': d});
            },);
          }).toList(growable: true),
        );
      },);
  }
}