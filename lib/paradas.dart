import 'package:app_ride_a_bus/eventos.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PantallaParadas extends StatefulWidget {
  final String? email;

  const PantallaParadas({super.key, this.email});

  @override
  State<PantallaParadas> createState() => _PantallaparadasState();
}

class _PantallaparadasState extends State<PantallaParadas> {

  @override
  Widget build(BuildContext context) {

    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final boxColor = Theme.of(context).cardColor;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SizedBox.expand(
        child: Stack(
          children: [

            // TÍTULO PRINCIPAL
            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'RIDE A BUS',
                  style: GoogleFonts.vollkorn(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            // TEXTO PARADAS
           

            // BOTÓN INICIO
            Positioned(
              bottom: 70,
              left: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Pantallamenu(),
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
                        color: textColor,
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
                      color: Colors.red,
                    ),
                  ),
                ],
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
            ),

          ],
        ),
      ),
    );
  }
}
