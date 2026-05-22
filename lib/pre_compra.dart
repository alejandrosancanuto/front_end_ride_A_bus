import 'dart:async';
import 'dart:convert';

import 'package:app_ride_a_bus/elegir_pagos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PreCompra extends StatefulWidget {
  const PreCompra({
    super.key,
    this.evento,
    this.direccionParada,
    this.horaSalida,
    this.email,
  });
  final String? evento;
  final String? direccionParada;
  final DateTime? horaSalida;
  final String? email;

  @override
  State<PreCompra> createState() => _PreCompraState();
}

class _PreCompraState extends State<PreCompra> {
  int cantidad=1;
  double precio=3.99;
  String _idLinea = '…';
  String _plazasTxt = '…';

  /// Email del usuario (trim); úsalo en toda esta pantalla en lugar de [widget.email] crudo.
  String? get email {
    final t = widget.email?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  /// Varias cadenas TIME compatibles con CAST(? AS TIME) en el servidor.
  List<String> _horasParaMySql() {
    final d = widget.horaSalida;
    if (d == null) return [];
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    final s = d.second.toString().padLeft(2, '0');
    return ['$h:$m:$s', '$h:$m:00', '$h:$m'];
  }

  String? _extraerPlazas(dynamic decoded) {
    if (decoded is List) {
      for (final item in decoded) {
        if (item is Map) {
          for (final k in item.keys) {
            if (k.toString().toLowerCase() == 'plazas_disponibles') {
              final v = item[k];
              if (v != null) return v.toString();
            }
          }
        }
      }
    }
    if (decoded is Map) {
      for (final k in decoded.keys) {
        if (k.toString().toLowerCase() == 'plazas_disponibles') {
          final v = decoded[k];
          if (v != null) return v.toString();
        }
      }
    }
    return null;
  }

  Future<void> _cargarPlazasBus(String idLineaStr) async {
    if (mounted) setState(() => _plazasTxt = '…');
    final horas = _horasParaMySql();
    if (horas.isEmpty) {
      if (mounted) setState(() => _plazasTxt = '—');
      return;
    }
    for (final hora in horas) {
      if (!mounted) return;
      try {
        final uri = Uri.parse(
          'http://10.0.2.2:3000/mostrarPlazasBus?id_linea=${Uri.encodeQueryComponent(idLineaStr)}&hora_salida=${Uri.encodeQueryComponent(hora)}',
        );
        final r = await http.get(uri).timeout(const Duration(seconds: 12));
        if (!mounted) return;
        if (r.statusCode != 200) continue;
        dynamic decoded;
        try {
          decoded = jsonDecode(r.body);
        } catch (_) {
          continue;
        }
        final valor = _extraerPlazas(decoded);
        if (valor != null) {
          if (mounted) setState(() => _plazasTxt = valor);
          return;
        }
      } on TimeoutException {
        break;
      } catch (_) {
        continue;
      }
    }
    if (mounted) setState(() => _plazasTxt = '—');
  }

  @override
  void initState() {
    super.initState();
    _cargarIdLinea();
  }

  Future<void> _cargarIdLinea() async {
    final nombre = widget.evento?.trim();
    if (nombre == null || nombre.isEmpty) {
      if (mounted) {
        setState(() {
          _idLinea = '—';
          _plazasTxt = '—';
        });
      }
      return;
    }
    try {
      final uri = Uri.parse(
        'http://10.0.2.2:3000/sacaridLinea?nombre_evento=${Uri.encodeQueryComponent(nombre)}',
      );
      final r = await http.get(uri).timeout(const Duration(seconds: 12));
      if (!mounted) return;
      if (r.statusCode != 200) {
        setState(() {
          _idLinea = '—';
          _plazasTxt = '—';
        });
        return;
      }
      final decoded = jsonDecode(r.body);
      String txt = '—';
      if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
        final raw = (decoded.first as Map)['id_linea'];
        if (raw != null) txt = raw.toString();
      }
      setState(() => _idLinea = txt);
      if (txt != '—' && txt != '…') {
        await _cargarPlazasBus(txt);
      } else {
        if (mounted) setState(() => _plazasTxt = '—');
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _idLinea = '—';
          _plazasTxt = '—';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _idLinea = '—';
          _plazasTxt = '—';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 235, 255),
        elevation: 0,
        title: Text('Pre compra',style: GoogleFonts.plusJakartaSans(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        
      ),
      body:Padding(padding: EdgeInsets.all(20), 
      child: Column(
        children: [Stack(children: [
 Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                 child: Container(
                  width: 380,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(image: AssetImage('assets/images/imagenAutobus.png'),fit: BoxFit.cover),
                  ),
                 ),
                ),
               ),
Positioned(
  top: 230,
  left: 0,
  right: 0,
  child: Center(
    child: Text('Resumen de la compra',style: GoogleFonts.plusJakartaSans(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.black),),
  ),
),
        Padding( padding:const EdgeInsets.only(top:340), child: 
          Container(
            width: 380,
            height: 400,
            
            decoration: BoxDecoration(
            color: const Color.fromARGB(174, 232, 230, 230),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
              

                 Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10), 
                      child: Text(
                      '${cantidad}x Billete ida y vuelta ${widget.evento}\n\nParada en: ${widget.direccionParada}\nPlazas disponibles: $_plazasTxt',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                     
                    ),
                      ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 290,
                  right: 0,
                 child: Icon(CupertinoIcons.tickets, size: 30, color: Colors.black),
                ),
                Positioned(
                top: 300,
                left: 20,
                right: 0,
                
                  child: Text(
                    'Total:${(cantidad*precio).toStringAsFixed(2)}€',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    
                  ),
                ),
                ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                // Con left+right el hijo se estira a todo el ancho; Center + Row(min)
                // hacen que el Container solo ocupe el ancho (y alto) del contenido.
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 217, 218, 216),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (cantidad > 1) {
                                cantidad--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          'Añadir más billetes',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              final plazas = int.tryParse(_plazasTxt.trim());
                              if (plazas != null && cantidad < plazas) {
                                cantidad++;
                              }
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                ),
              ),



              Positioned(
                top: 350,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ElegirPagos(
                            cantidad: cantidad,
                            precio: precio,
                            nombreEvento: widget.evento,
                            horaSalida: widget.horaSalida,
                            email: email,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pagar',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                             Icon(
                              Icons.arrow_forward_sharp,
                              size: 22,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
        ]
      ),
        ],
      ),
      ),
    );
  }
}
