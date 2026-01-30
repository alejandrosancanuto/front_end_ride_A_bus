
import 'package:app_ride_a_bus/contrase%C3%B1a.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:app_ride_a_bus/primerInicioSesion.dart';
import 'package:app_ride_a_bus/segundoInicio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Contrasenyaolvidada extends StatelessWidget {
  const Contrasenyaolvidada({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajusta la pantalla cuando aparece el teclado

      body: SizedBox.expand( // Ocupa toda la pantalla disponible
        child: Stack( // Permite superponer widgets: fondo, icono, título y formulario
          children: [

            // Fondo de pantalla
            Container(
              color: const Color.fromARGB(255, 240, 235, 255), // Color de fondo personalizado
            ),

            // Icono central
            Positioned(
              top: 200, // Posición vertical desde la parte superior
              left: 0,
              right: 0,
              child: Center( // Centra el widget horizontalmente
                child: DecoratedBox( // Caja decorativa que envuelve el icono
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco para el icono
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8), // Espacio interno alrededor del icono
                    child: Icon(
                      Icons.person_add_alt_1_sharp, // Icono de usuario
                      size: 80, // Tamaño del icono
                      color: Color.fromARGB(255, 102, 0, 255), // Color púrpura
                    ),
                  ),
                ),
              ),
            ),

            // Título principal
            Positioned(
              top: 300, // Posición vertical
              left: 0,
              right: 0,
              child: Center( // Centra horizontalmente
                child: Text(
                  "Recupera tu contraseña", // Texto del título
                  style: GoogleFonts.lato(
                    fontSize: 30, // Tamaño grande
                    fontWeight: FontWeight.bold, // Negrita
                    color: const Color.fromARGB(255, 0, 0, 0), // Color negro
                  ),
                ),
              ),
            ),

            // Bloque del formulario
            Positioned(
              top: 350, // Posición vertical del formulario
              left: 20, // Margen izquierdo
              right: 20, // Margen derecho
              child: Container(
                padding: const EdgeInsets.all(20), // Espacio interno del bloque
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), // Bordes redondeados
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa todo el ancho disponible
                  children: [

                    // Label para correo
                    Text(
                      "CORREO ELECTRÓNICO:",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 91, 90, 90), // Gris oscuro
                      ),
                    ),
                    const SizedBox(height: 5), // Espacio entre label y TextField

                    // TextField para correo
                    TextField(
                      decoration: InputDecoration(
                        filled: true, // Habilita fondo
                        fillColor: Colors.white, // Color de fondo
                        labelText: 'ej: pacosanz@gmail.com', // Texto de ejemplo
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400]), // Icono a la izquierda
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          borderSide: const BorderSide(width: 3), // Grosor del borde
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Espacio antes del campo de nueva contraseña

                    // Label para nueva contraseña
                    Text(
                      " NUEVA CONTRASEÑA:",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 91, 90, 90),
                      ),
                    ),

                    // TextField para nueva contraseña
                    TextField(
                      decoration: InputDecoration(
                        filled: true, // Fondo blanco
                        fillColor: Colors.white,
                        labelText: 'ej: Paco123@', // Texto de ejemplo
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400]), // Icono a la izquierda
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          borderSide: const BorderSide(width: 3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), // Espacio pequeño debajo del TextField

                    const SizedBox(height: 30), // Espacio antes del botón

                    // Botón para enviar correo
                    ElevatedButton(
                      onPressed: () {
                        // Al presionar, navega a la pantalla principal del menú
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Pantallamenu()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 148, 4, 173), // Color púrpura
                        minimumSize: const Size(double.infinity, 50), // Ancho completo, altura 50
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        ' ENVIAR CORREO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 254, 254), // Texto blanco
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30), // Espacio antes del link de iniciar sesión

                    // Link para iniciar sesión
                    Padding(
                      padding: const EdgeInsets.only(left: 115), // Ajuste horizontal para centrar
                      child: GestureDetector(
                        onTap: () {
                          // Al presionar, navega a la pantalla de inicio de sesión
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InicioSesion(),
                            ),
                          );
                        },
                        child: Text(
                          "Iniciar sesion",
                          style: GoogleFonts.lato(
                            color: const Color.fromARGB(255, 91, 90, 90), // Gris oscuro
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
