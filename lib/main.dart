import 'package:app_ride_a_bus/PantallaPrimera.dart';
import 'package:app_ride_a_bus/primerInicioSesion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  


    

  @override
  Widget build(BuildContext context) {
  
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pantallaprimera(), // primero mostramos el splash
    );
  }
 
}


