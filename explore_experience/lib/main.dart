import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'test',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context)
              .textTheme, 
        ),
      ),
      
    );
  }
}


