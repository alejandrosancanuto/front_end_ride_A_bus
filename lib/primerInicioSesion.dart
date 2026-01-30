
import 'package:app_ride_a_bus/contrase%C3%B1a.dart';
import 'package:app_ride_a_bus/contrase%C3%B1aOlvidada.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:app_ride_a_bus/segundoInicio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class InicioSesion extends StatelessWidget {
  const InicioSesion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajusta la pantalla cuando aparece el teclado

      body: SizedBox.expand( // Ocupa toda la pantalla
        child: Stack( // Permite superponer widgets: fondo, icono, título y formulario
          children: [

            // Fondo de pantalla
            Container(
              color: const Color.fromARGB(255, 240, 235, 255), // Color de fondo personalizado
            ),

            // Icono o logo
            Positioned(
              top: 200, // Posición vertical desde arriba
              left: 0,
              right: 0,
              child: Center( // Centra horizontalmente
                child: DecoratedBox( // Caja decorativa que envuelve el icono
                  decoration: BoxDecoration(
                    color: Colors.white, // Fondo blanco
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
              child: Center(
                child: Text(
                  "Inicio de sesión", // Texto del título
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
                        filled: true, // Fondo habilitado
                        fillColor: Colors.white, // Fondo blanco
                        labelText: 'ej: pacosanz@gmail.com', // Texto de ejemplo
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400]), // Icono a la izquierda
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          borderSide: const BorderSide(width: 3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40), // Espacio antes del campo de contraseña

                    // Label para contraseña
                    Text(
                      "CONTRASEÑA:",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 91, 90, 90),
                      ),
                    ),
                    const SizedBox(height: 5), // Espacio pequeño

                    // TextField para contraseña usando el widget PasswordField
                    const PasswordField(),

                    const SizedBox(height: 30), // Espacio antes del botón

                    // Botón para iniciar sesión
                    ElevatedButton(
                      onPressed: () {
                        // Al presionar, navega a la pantalla del menú principal
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
                        ' INICIAR SESION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 254, 254), // Texto blanco
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30), // Espacio antes del link de registro

                    // Link para crear cuenta
                    Padding(
                      padding: const EdgeInsets.only(left: 50), // Ajuste horizontal
                      child: GestureDetector(
                        onTap: () {
                          // Navega a la pantalla de registro o segundo inicio
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SegundoInicio(),
                            ),
                          );
                        },
                        child: Text(
                          "¿No tienes cuenta? Creala aqui", // Texto del enlace
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
