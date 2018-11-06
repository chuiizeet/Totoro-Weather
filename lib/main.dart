import 'package:flutter/material.dart';
import 'package:klimatic/ui/klimatic.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Climita',
      home: new Klimatic(),

    );
    
  }
}
