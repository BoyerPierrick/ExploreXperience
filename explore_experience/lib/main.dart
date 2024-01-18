import 'view/map.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      

      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const MapScreen(),
    );
  }
}