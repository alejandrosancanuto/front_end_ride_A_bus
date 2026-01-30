import 'package:app_ride_a_bus/contrase%C3%B1aOlvidada.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:app_ride_a_bus/segundoInicio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Contrasenyacrear extends StatefulWidget {
  const Contrasenyacrear({super.key});

  @override
  State<Contrasenyacrear> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<Contrasenyacrear> {
  bool _obscureText = true;

 @override
Widget build(BuildContext context) { 
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, // Hace que los hijos ocupen todo el ancho
    children: [

      // Campo de texto para la contraseña
      TextField( 
        obscureText: _obscureText, // Oculta o muestra el texto según _obscureText
        decoration: InputDecoration( 
          filled: true, // Habilita color de fondo
          fillColor: Colors.white, // Color de fondo del TextField
          labelText: 'ej: Paco123@', // Texto de ejemplo dentro del campo
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]), // Icono a la izquierda

          // Botón para mostrar u ocultar la contraseña
          suffixIcon: IconButton( 
            icon: Icon( 
              _obscureText ? Icons.visibility_off : Icons.visibility, // Cambia icono según estado
              color: Colors.grey[400], 
            ), 
            onPressed: () { 
              setState(() { 
                _obscureText = !_obscureText; // Cambia el estado de visibilidad
              }); 
            }, 
          ), 

          // Bordes redondeados
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(20), 
          ), 
        ), 
      ),

    ],
  );
}

}
