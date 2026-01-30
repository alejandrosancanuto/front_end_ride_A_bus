import 'package:app_ride_a_bus/contrase%C3%B1a.dart';
import 'package:app_ride_a_bus/contrase%C3%B1aCrear.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SegundoInicio extends StatelessWidget {
  const SegundoInicio({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox( // Ocupa todo el espacio disponible
        child: Stack( // Permite superponer elementos: fondo, icono, título y formulario
          children: [

            // Fondo de pantalla
            Container(
              color: const Color.fromARGB(255, 240, 235, 255), // Color de fondo personalizado
            ),

            // Icono central
            Positioned(
              top: 150, // Posición vertical desde arriba
              left: 0,
              right: 0,
              child: Center( // Centra horizontalmente
                child: DecoratedBox( // Caja decorativa alrededor del icono
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

            // Título principal "Crear cuenta"
            Positioned(
              top: 250, // Posición vertical
              left: 118, // Ajuste horizontal
              child: Text(
                'Crear cuenta',
                style: GoogleFonts.lato(
                  fontSize: 30, // Tamaño grande
                  color: Color.fromARGB(255, 0, 0, 0), // Color negro
                  fontWeight: FontWeight.bold, // Negrita
                ),
              ),
            ),

            // Bloque del formulario
            Positioned(
              top: 300, // Posición vertical del formulario
              left: 20, // Margen izquierdo
              right: 20, // Margen derecho
              bottom: 20, // Margen inferior para scroll
              child: Container(
                padding: const EdgeInsets.all(20), // Espacio interno del formulario
                child: SingleChildScrollView( // Permite scroll si la pantalla es pequeña
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa todo el ancho disponible
                    children: [

                      // Label correo electrónico
                      Text(
                        "CORREO ELECTRÓNICO:",
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90), // Gris oscuro
                        ),
                      ),
                      const SizedBox(height: 5), // Espacio entre label y campo

                      // TextField correo
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Fondo blanco
                          labelText: 'ej: pacosanz@gmail.com', // Ejemplo de correo
                          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400]), // Icono a la izquierda
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Bordes redondeados
                            borderSide: const BorderSide(width: 3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Espacio antes de la contraseña

                      // Label contraseña
                      Text(
                        "CONTRASEÑA:",
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // TextField contraseña personalizado
                      const Contrasenyacrear(), // Widget que oculta/mostrar contraseña

                      const SizedBox(height: 20), // Espacio antes de fecha de nacimiento

                      // Label fecha de nacimiento
                      Text(
                        "FECHA DE NACIMIENTO:",
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // TextField fecha de nacimiento
                      TextField(
                        obscureText: true, // Para que el contenido no se vea (puede quitarse)
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ej: DD/MM/AAAA', // Ejemplo de formato
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[400]), // Icono calendario
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Label DNI
                      Text(
                        "DNI:",
                        style: GoogleFonts.bricolageGrotesque(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // TextField DNI
                      TextField(
                        obscureText: true, // Para que los datos no se vean (opcional)
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ej: 00000000A', // Ejemplo de DNI
                          prefixIcon: Icon(Icons.badge_outlined, color: Colors.grey[400]), // Icono a la izquierda
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30), // Espacio antes del botón

                      // Botón crear cuenta
                      ElevatedButton(
                        onPressed: () {
                          // Navega al menú principal
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Pantallamenu()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50), // Ancho completo y altura 50
                          backgroundColor: Color.fromARGB(255, 148, 4, 173), // Color púrpura
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Bordes redondeados
                          ),
                        ),
                        child: const Text(
                          'CREAR CUENTA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 254, 254), // Texto blanco
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
