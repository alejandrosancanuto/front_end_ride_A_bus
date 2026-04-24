import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'primerInicioSesion.dart';

// EN ESTE PANTALLA LO QUE TENEMOS ES UNA SPLASH SCREEN, QUE LA TENGO PARA SIMULAR COMO UNA PANTALLA DE CARGA
//

import 'dart:async';
import 'package:flutter/material.dart';
// tu pantalla de login

class Pantallaprimera extends StatefulWidget {
  const Pantallaprimera({super.key});

  @override
  State<Pantallaprimera> createState() => _PantallaprimeraState();
}

class _PantallaprimeraState extends State<Pantallaprimera> {
  double _opacity = 1.0; // Opacidad inicial de la pantalla (totalmente visible)

  @override
  void initState() {
    super.initState();

    // Espera 1.5 segundos antes de iniciar el efecto de desvanecimiento
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _opacity = 0.0; // Cambia la opacidad a 0 para iniciar fade out
      });

      // Después de 0.5 segundos más (duración del fade), navega a la pantalla de inicio de sesión
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InicioSesion()), // Reemplaza la pantalla actual
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Color de fondo de la pantalla
      backgroundColor: const Color.fromARGB(255, 240, 235, 255),

      body: AnimatedOpacity(
        opacity: _opacity, // Controla la visibilidad del contenido
        duration: const Duration(milliseconds: 1500), // Tiempo del efecto de fade
        child: Stack(
          fit: StackFit.expand, // Hace que los hijos ocupen toda la pantalla
          children: [

            // Fondo de color (opcional si quieres imagen de fondo más adelante)
            Container(
              color: const Color.fromARGB(255, 240, 235, 255), // Color de fondo
            ),

            // Posición del logo
            Positioned(
              top: 150, // Posición vertical desde arriba
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente los hijos del column
                children: [

                  // Imagen del logo
                  Image.asset(
                    'assets/images/imagen_logo.png', // Ruta de la imagen
                    width: MediaQuery.of(context).size.width * 100, // Ajusta el tamaño del logo según el ancho de pantalla
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
