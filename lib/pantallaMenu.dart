import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Pantallamenu extends StatelessWidget {
  const Pantallamenu({super.key});

  // Función para abrir Google Maps en el navegador o aplicación externa
  Future<void> _abrirGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=My+Location', // URL de búsqueda en Google Maps
    );

    // Intentar abrir la URL con la aplicación externa
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir Google Maps'; // Error si no se puede abrir
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajusta la pantalla cuando aparece el teclado

      body: SizedBox.expand( // Ocupa toda la pantalla
        child: Stack( // Permite superponer widgets: fondo, título, barra de búsqueda e imagen
          children: [

            // Fondo de la pantalla
            Container(
              color: const Color.fromARGB(255, 240, 235, 255), // Color de fondo personalizado
            ),

            // Título principal
            Positioned(
              top: 110, // Posición vertical desde arriba
              left: 0,
              right: 0,
              child: Center( // Centra el widget horizontalmente
                child: Text(
                  'RIDE A BUS', // Texto del título
                  style: GoogleFonts.vollkorn( // Fuente Vollkorn
                    fontSize: 40, // Tamaño grande
                    fontWeight: FontWeight.bold, // Negrita
                    color: Colors.black, // Color negro
                  ),
                ),
              ),
            ),

            // Barra de búsqueda
            Positioned(
              top: 200, // Posición vertical
              left: 30, // Margen izquierdo
              right: 30, // Margen derecho
              child: TextField(
                decoration: InputDecoration(
                  filled: true, // Fondo habilitado
                  fillColor: Colors.white, // Fondo blanco
                  labelText: 'ej: Busca tu evento', // Texto de ejemplo
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]), // Icono de búsqueda
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Bordes redondeados
                    borderSide: BorderSide.none, // Sin borde visible
                  ),
                ),
              ),
            ),

            // Imagen clickeable
            Positioned(
              top: 350, // Posición vertical
              left: 0,
              right: 0,
              child: Center( // Centra horizontalmente
                child: InkWell(
                  onTap: _abrirGoogleMaps, // Ejecuta función para abrir Google Maps
                  child: Image.asset(
                    'assets/images/IMAGENESPAÑA.png', // Imagen mostrada
                    width: 330, // Ancho de la imagen
                    fit: BoxFit.cover, // Ajuste de la imagen para cubrir área
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
