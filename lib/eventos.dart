import 'dart:convert';
import 'package:app_ride_a_bus/horarioeventos.dart';
import 'package:app_ride_a_bus/misBilletes.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_ride_a_bus/paradas.dart';
import 'package:http/http.dart' as http;

class PantallaEventos extends StatefulWidget {
  final String? email;

  const PantallaEventos({super.key, this.email});

  @override
  State<PantallaEventos> createState() => _PantallaEventosState();
}

class _PantallaEventosState extends State<PantallaEventos> {

  final PageController _pageController =
      PageController(viewportFraction: 0.8);

  int _currentPage = 0;

  // NUEVAS VARIABLES PARA BÚSQUEDA
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _eventosEncontrados = [];
  bool _cargando = false;

  // Función para buscar eventos en la base de datos
  Future<void> _buscarEvento(String query) async {
    if (query.isEmpty) {
      setState(() => _eventosEncontrados = []);
      return;
    }

    setState(() => _cargando = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/buscarEventos?nombre=$query'),
      );

      if (response.statusCode == 200) {
        setState(() {
          _eventosEncontrados = jsonDecode(response.body);
          _cargando = false;
        });
      } else {
        setState(() => _cargando = false);
      }
    } catch (e) {
      setState(() => _cargando = false);
      debugPrint("Error buscando evento: $e");
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

// aqui creamos una lista con los datos de los eventos introducidos para luego imprimirlos por pantalla
  final List<Map<String, String>> eventos = [
    {
      "nombre": "Latin Fest",
      "imagen":
          "https://offloadmedia.feverup.com/valenciasecreta.com/wp-content/uploads/2022/05/04064220/Latin-Fest-1.jpg"
    },
    
    {
      "nombre": "Valencia vs Levante ",
      "imagen":
          "https://valenciacapital.es/wp-content/uploads/2025/11/Captura-de-pantalla-2025-11-24-a-las-10.38.46.png"
    },
  ];

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
Positioned(
              top: 270,
              left: 20,
              right: 20,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: (value) => _buscarEvento(value),
                          style: GoogleFonts.vollkorn(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Busca tu evento',
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
              ),
            ),
            // TEXTO EVENTOS
            Positioned(
              top: 420,
              left: 0,
              right: 70,
              child: Center(
                child: Text(
                  _searchController.text.isEmpty 
                      ? 'Eventos recomendados' 
                      : 'Resultados de búsqueda',
                  style: GoogleFonts.vollkorn(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ),

            // SLIDER O RESULTADOS DE BÚSQUEDA
            Positioned(
              top: 470,
              left: 0,
              right: 0,
              height: 220,
              child: _cargando 
                ? const Center(child: CircularProgressIndicator())
                : _searchController.text.isNotEmpty && _eventosEncontrados.isEmpty
                  ? Center(child: Text("No se encontraron eventos", style: GoogleFonts.lato(color: textColor)))
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: _searchController.text.isEmpty 
                          ? eventos.length 
                          : _eventosEncontrados.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final bool esBusqueda = _searchController.text.isNotEmpty;
                        final evento = esBusqueda 
                            ? _eventosEncontrados[index] 
                            : eventos[index];

                        // Mapeo de nombres de campos según el origen (Local o DB)
                        final String nombre = esBusqueda ? evento["nombre_evento"] : evento["nombre"];
                        final String imagen = esBusqueda ? evento["link_imagen"] : evento["imagen"];
                        final String? fecha = esBusqueda ? evento["fecha_evento"] : null;
                        final String? direccion = esBusqueda ? evento["direccion_evento"] : null;

                        return 
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>HorarioEventos(evento: nombre, email: widget.email)),
                            );
                          },
                        child:Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Imagen de fondo (link_imagen de la DB)
                                Image.network(
                                  imagen,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                      Container(color: Colors.grey, child: const Icon(Icons.broken_image, color: Colors.white)),
                                ),

                                // Degradado para que el texto se vea bien
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black87,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // Información del evento
                                Positioned(
                                  bottom: 15,
                                  left: 15,
                                  right: 15,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        nombre,
                                        style: GoogleFonts.lato(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (esBusqueda && fecha != null)
                                        Text(
                                          fecha,
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      if (esBusqueda && direccion != null)
                                        Text(
                                          direccion,
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.white60,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        );
                      },
                    ),
            ),

            // BOTÓN INICIO
            Positioned(
              bottom: 70,
              left: 20,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pantallamenu(email: widget.email),
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
                        child: Icon(Icons.home_sharp, size: 50),
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

            // BOTÓN PARADAS
            Positioned(
              bottom: 70,
              left: 120,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaParadas(email: widget.email),
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
                        child: Icon(Icons.directions_bus, size: 50),
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



            Positioned(
              bottom: 70,
              left: 220,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PantallaEventos(email: widget.email),
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
                        child: Icon(Icons.celebration, size: 50),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "EVENTOS",
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
Positioned(
              bottom: 70,
              left: 310,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MisBilletes(email: widget.email),
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
                        child: Icon(CupertinoIcons.ticket_fill, size: 50),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "MIS BILLETES",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 0, 0, 0),
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