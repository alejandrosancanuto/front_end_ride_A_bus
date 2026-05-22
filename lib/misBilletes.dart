import 'dart:async';
import 'dart:convert';

import 'package:app_ride_a_bus/eventos.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:app_ride_a_bus/paradas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MisBilletes extends StatefulWidget {
  const MisBilletes({super.key, this.email});
  final String? email;

  @override
  State<MisBilletes> createState() => _MisBilletesState();
}

class _MisBilletesState extends State<MisBilletes> {
  /// Obtenido con `GET /sacarIdusuario` y el correo del usuario.
  int? _idUsuario;

  int? get idUsuario => _idUsuario;

  static const _apiBase = 'http://10.0.2.2:3000';

  final PageController _pageController =
      PageController(viewportFraction: 0.8);
  final TextEditingController _searchController = TextEditingController();

  List<dynamic> _billetes = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _cargarIdUsuario();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Devuelve el id en memoria o lo pide al servidor una vez.
  Future<int?> _cargarIdUsuario() async {
    final correo = widget.email?.trim();
    if (correo == null || correo.isEmpty) {
      if (mounted) setState(() => _idUsuario = null);
      return null;
    }
    if (_idUsuario != null) return _idUsuario;

    try {
      final uri = Uri.parse('$_apiBase/sacarIdusuario').replace(
        queryParameters: {'correo_electronico': correo},
      );
      final r = await http.get(uri).timeout(const Duration(seconds: 15));
      if (!mounted || r.statusCode != 200) return _idUsuario;

      dynamic decoded = jsonDecode(r.body);
      Object? raw;
      if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
        final m = decoded.first as Map;
        raw = m['id_usuario'] ?? m['id_Usuario'];
      } else if (decoded is Map) {
        raw = decoded['id_usuario'] ?? decoded['id_Usuario'];
      }
      final id = raw != null ? int.tryParse(raw.toString()) : null;
      if (mounted) setState(() => _idUsuario = id);
    } on TimeoutException {
      return _idUsuario;
    } catch (_) {
      return _idUsuario;
    }
  }

  /// Resuelve el nombre del evento con `buscarEventos` (como en eventos) y pide billetes con ese nombre exacto.
  Future<void> _buscarBilletes(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _billetes = [];
        _cargando = false;
      });
      return;
    }

    final correo = widget.email?.trim();
    if (correo == null || correo.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicia sesión para ver tus billetes.'),
          ),
        );
      }
      return;
    }

    setState(() => _cargando = true);
    final id = _idUsuario ?? await _cargarIdUsuario();
    if (!mounted) return;

    if (id == null) {
      setState(() => _cargando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se pudo obtener tu usuario. Comprueba que el servidor esté en marcha.',
            ),
          ),
        );
      }
      return;
    }

    try {
      final evUri = Uri.parse('$_apiBase/buscarEventos').replace(
        queryParameters: {'nombre': q},
      );
      final evRes =
          await http.get(evUri).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (evRes.statusCode != 200) {
        setState(() {
          _billetes = [];
          _cargando = false;
        });
        return;
      }

      final decoded = jsonDecode(evRes.body);
      if (decoded is! List || decoded.isEmpty) {
        setState(() {
          _billetes = [];
          _cargando = false;
        });
        return;
      }

      final primer = decoded.first as Map<String, dynamic>;
      final nombreEvento =
          primer['nombre_evento']?.toString() ?? '';
      if (nombreEvento.isEmpty) {
        setState(() {
          _billetes = [];
          _cargando = false;
        });
        return;
      }

      final bilUri = Uri.parse('$_apiBase/sacarBilletes').replace(
        queryParameters: {
          'id_usuario': id.toString(),
          'evento': nombreEvento,
        },
      );
      final bilRes =
          await http.get(bilUri).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (bilRes.statusCode == 200) {
        final list = jsonDecode(bilRes.body);
        final items = list is List ? list : <dynamic>[];
        setState(() {
          _billetes = items;
          _cargando = false;
        });
        if (_pageController.hasClients && items.isNotEmpty) {
          _pageController.jumpToPage(0);
        }
      } else {
        setState(() {
          _billetes = [];
          _cargando = false;
        });
      }
    } on TimeoutException {
      if (mounted) setState(() => _cargando = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _billetes = [];
          _cargando = false;
        });
      }
      debugPrint('Error buscando billetes: $e');
    }
  }

  String _str(dynamic v) => v?.toString() ?? '—';

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final boxColor = Theme.of(context).cardColor;

    final busquedaActiva = _searchController.text.trim().isNotEmpty;

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
                        onSubmitted: _buscarBilletes,
                        style: GoogleFonts.vollkorn(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Busca el evento de tu billete',
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
              top: 420,
              left: 0,
              right: 70,
              child: Center(
                child: Text(
                  busquedaActiva
                      ? 'Tus billetes'
                      : 'Busca tus billetes',
                  style: GoogleFonts.vollkorn(
                    
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    
                  ),
                ),
              ),
            ),

            Positioned(
              top: 470,
              left: 0,
              right: 0,
              height: 220,
              child: _cargando
                  ? const Center(child: CircularProgressIndicator())
                  : !busquedaActiva
                      ? const SizedBox.shrink()
                      : _billetes.isEmpty
                          ? Center(
                              child: Text(
                                'No hay billetes para mostrar',
                                style: GoogleFonts.lato(color: textColor),
                              ),
                            )
                          : PageView.builder(
                              controller: _pageController,
                              itemCount: _billetes.length,
                              itemBuilder: (context, index) {
                                final b = _billetes[index] as Map<String, dynamic>;
                                final nombre =
                                    _str(b['nombre_evento']);
                                final fecha = _str(b['fecha_evento']);
                                final hora = _str(b['hora_salida']);
                                final monto = _str(b['montoTotal']);
                                final pago = _str(b['metodoPago']);

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                        Image.asset(
                                          'assets/images/imagenAutobus.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, st) =>
                                              Container(
                                            color: Colors.blueGrey,
                                            child: const Icon(
                                              Icons.directions_bus,
                                              color: Colors.white70,
                                              size: 64,
                                            ),
                                          ),
                                        ),
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
                                        Positioned(
                                          bottom: 15,
                                          left: 15,
                                          right: 15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                              Text(
                                                fecha,
                                                style: GoogleFonts.lato(
                                                  fontSize: 14,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              Text(
                                                'Salida: $hora',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                  color: Colors.white60,
                                                ),
                                              ),
                                              Text(
                                                '$monto € · $pago',
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
                                );
                              },
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
                      builder: (context) =>
                          Pantallamenu(email: widget.email),
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
                        color: Colors.red,
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
