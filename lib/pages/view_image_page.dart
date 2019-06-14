import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewImagePage extends StatelessWidget {
  final String url;
  const ViewImagePage(this.url,{Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _portraitModeOnly();
    return Scaffold(
  
      body:Center(child: RotatedBox(quarterTurns: 1,child:Image.network(url, fit: BoxFit.fill, gaplessPlayback: true,) ,) ,) ,
    );
  }


  void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
}