import 'dart:async';
import 'dart:convert';

import 'package:app_ride_a_bus/eventos.dart';
import 'package:app_ride_a_bus/misBilletes.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PantallaParadas extends StatefulWidget {
  final String? email;

  const PantallaParadas({super.key, this.email});

  @override
  State<PantallaParadas> createState() => _PantallaparadasState();
}

class _PantallaparadasState extends State<PantallaParadas> {
  static const _apiBase = 'http://10.0.2.2:3000';

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _paradas = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _ubicacion(Map<String, dynamic> row) {
    final v = row['ubicacion_parada'] ?? row['Ubicacion_parada'];
    return v?.toString() ?? '—';
  }

  /// Solo `GET /mostrarParadas?nombre_evento=...` (el nombre debe coincidir con el de la BD).
  Future<void> _mostrarParadas(String query) async {
    final nombreEvento = query.trim();
    if (nombreEvento.isEmpty) {
      setState(() {
        _paradas = [];
        _cargando = false;
      });
      return;
    }

    setState(() => _cargando = true);

    try {
      final uri = Uri.parse('$_apiBase/mostrarParadas').replace(
        queryParameters: {'nombre_evento': nombreEvento},
      );
      final res =
          await http.get(uri).timeout(const Duration(seconds: 15));
      if (!mounted) return;

      if (res.statusCode != 200) {
        setState(() {
          _paradas = [];
          _cargando = false;
        });
        return;
      }

      final raw = jsonDecode(res.body);
      final items = <Map<String, dynamic>>[];
      if (raw is List) {
        for (final e in raw) {
          if (e is Map) {
            items.add(Map<String, dynamic>.from(
              e.map((k, v) => MapEntry(k.toString(), v)),
            ));
          }
        }
      }

      setState(() {
        _paradas = items;
        _cargando = false;
      });
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _paradas = [];
          _cargando = false;
        });
      }
    } catch (e, st) {
      debugPrint('mostrarParadas: $e\n$st');
      if (mounted) {
        setState(() {
          _paradas = [];
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final boxColor = Theme.of(context).cardColor;
    final hayBusqueda = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: Stack(
          children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
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
                        onSubmitted: _mostrarParadas,
                        style: GoogleFonts.vollkorn(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Nombre del evento (como en la base de datos)',
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

            Positioned(
              top: 400,
              left: 20,
              right: 20,
              bottom: 170,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      hayBusqueda ? 'Paradas' : 'Tus paradas',
                      style: GoogleFonts.vollkorn(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _cargando
                          ? const Center(child: CircularProgressIndicator())
                          : !hayBusqueda
                              ? Center(
                                  child: Text(
                                    'Escribe el nombre del evento y pulsa buscar en el teclado',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: textColor?.withOpacity(0.7) ??
                                          Colors.grey,
                                    ),
                                  ),
                                )
                              : _paradas.isEmpty
                                  ? Center(
                                      child: Text(
                                        'No hay paradas para ese evento',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      itemCount: _paradas.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, i) {
                                        final u = _ubicacion(_paradas[i]);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 4,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.place_outlined,
                                                color: textColor
                                                    ?.withOpacity(0.7),
                                                size: 26,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  u,
                                                  style: GoogleFonts.lato(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ),

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

            Positioned(
              bottom: 70,
              left: 220,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PantallaEventos(email: widget.email),
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
