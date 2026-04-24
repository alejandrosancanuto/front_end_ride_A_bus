import 'package:app_ride_a_bus/eventos.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_ride_a_bus/paradas.dart';
import 'main.dart'; // IMPORTANTE para acceder a MyApp


// ESTE ES LA PRIMERA PANTALLA DE LA APP UNA VEZ INICIADA LA SESION, EN EL CUAL TENEMOS EL SOL O LA LUNA 
// PARA CAMBIAR EL MODO DE LA APP ENTRE CLARO O OSCURO, EL MAPA PARA BUSCAR CUAL ES LA PARADA MAS CERCANA A NUESTRA UBICACION,
// Y LOS BOTONES PARA NAVEGAR POR LAS DISTINTAS PANTALLAS DE LA APP.
class Pantallamenu extends StatefulWidget {
  final String? email;

  const Pantallamenu({super.key, this.email});

  @override
  State<Pantallamenu> createState() => _PantallamenuState();
}

class _PantallamenuState extends State<Pantallamenu> {

  Future<void> _abrirGoogleMaps() async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=Current+Location',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    
    final boxColor = Theme.of(context).cardColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SizedBox.expand(
        child: Stack(
          children: [

            //  Botón modo oscuro global
            Positioned(
              top: 60,
              right: 20,
              child: IconButton(
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                onPressed: () {
                  MyApp.of(context).toggleTheme();
                },
              ),
            ),

            // TÍTULO
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'RIDE A BUS',
                      style: GoogleFonts.vollkorn(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.email != null &&
                        widget.email!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Usuario: ${widget.email!.trim()}',
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // IMAGEN
            Positioned(
              top: 350,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: _abrirGoogleMaps,
                  child: Image.asset(
                    'assets/images/MAPA.png',
                    width: 330,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // BOTÓN INICIO
           

            // BOTÓN INICIO
            Positioned(
              bottom: 70,
              left: 20,
              child: InkWell(
                
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.home_sharp,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "INICIO",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // BOTÓN PARADAS (pantalla actual)
            Positioned(
              bottom: 70,
              left: 120,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaParadas(),
                    ),
                  );
                },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.directions_bus,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "PARADAS",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            ),

            // BOTÓN EVENTOS
            Positioned(
              bottom: 70,
              left: 220,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PantallaEventos(),
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.celebration_sharp,
                          size: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "EVENTOS",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

 
}