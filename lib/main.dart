import 'package:app_ride_a_bus/PantallaPrimera.dart';
import 'package:flutter/material.dart';

//ESTA ES EL MAIN DESDE INICIAMOS LA PRIMERA PANTALLA I YA DESDE AHI VAMOS VIAJANDO POR TODAS LAS PANTALLAS 
// DONDE TENEMOS EL SOL  PARA CAMBIAR LOS COLORES DE LAS PANTALLAS QUE LOS IREMOS PASANDO DE UNA A OTRA 
// EN EL CUAL CAMBIA ENTRE CLARO O OSCURO
void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key}); 

  @override
  State<MyApp> createState() => _MyAppState(); 
  // Permite acceder al estado desde cualquier pantalla 
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {

  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
  
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 235, 255),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey[900],
      ),

      home: const Pantallaprimera(),
    );
  }
}
