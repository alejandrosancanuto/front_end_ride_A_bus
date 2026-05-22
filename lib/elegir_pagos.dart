import 'dart:convert';

import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

enum _MetodoPago { applePay, paypal, visa }

/// Pantalla para elegir método de pago (tras resumen de compra).
class ElegirPagos extends StatefulWidget {
  const ElegirPagos({
    super.key,
    this.cantidad,
    this.precio,
    this.nombreEvento,
    this.horaSalida,
    this.email,
  });

  final int? cantidad;
  final double? precio;
  final String? nombreEvento;
  final DateTime? horaSalida;
  final String? email;

  @override
  State<ElegirPagos> createState() => _ElegirPagosState();
}

class _ElegirPagosState extends State<ElegirPagos> {
  _MetodoPago? _seleccion;
  bool _procesando = false;

  static const _base = 'http://10.0.2.2:3000';

  String _metodoPagoParam(_MetodoPago m) {
    switch (m) {
      case _MetodoPago.applePay:
        return 'Apple Pay';
      case _MetodoPago.paypal:
        return 'PayPal';
      case _MetodoPago.visa:
        return 'Visa';
    }
  }

  String? _horaSalidaStr() {
    final d = widget.horaSalida;
    if (d == null) return null;
    final h = d.hour.toString().padLeft(2, '0');
    final m = d.minute.toString().padLeft(2, '0');
    final s = d.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _confirmarPago() async {
    if (_seleccion == null || _procesando) return;

    final correo = widget.email?.trim();
    if (correo == null || correo.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta el email para enviar los billetes')),
      );
      return;
    }

    final nombre = widget.nombreEvento?.trim();
    if (nombre == null || nombre.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta el evento')),
      );
      return;
    }

    final hora = _horaSalidaStr();
    if (hora == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falta la hora del viaje')),
      );
      return;
    }

    setState(() => _procesando = true);
    try {
      final idUri = Uri.parse('$_base/sacarIdViaje').replace(
        queryParameters: {
          'nombre_evento': nombre,
          'hora_salida': hora,
        },
      );
      final idRes = await http.get(idUri).timeout(const Duration(seconds: 20));
      if (!mounted) return;

      if (idRes.statusCode != 200) {
        String msg = 'No se encontró el viaje';
        try {
          final j = jsonDecode(idRes.body);
          if (j is Map && j['message'] != null) msg = j['message'].toString();
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      dynamic idDecoded = jsonDecode(idRes.body);
      final idViaje = idDecoded is Map ? idDecoded['id_viaje'] : null;
      if (idViaje == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respuesta inválida del servidor (id_viaje)')),
        );
        return;
      }

      final userUri = Uri.parse('$_base/sacarIdusuario').replace(
        queryParameters: {'correo_electronico': correo},
      );
      final userRes = await http.get(userUri).timeout(const Duration(seconds: 20));
      if (!mounted) return;

      if (userRes.statusCode != 200) {
        String msg = 'No se pudo obtener el id de usuario';
        try {
          final j = jsonDecode(userRes.body);
          if (j is Map && j['message'] != null) msg = j['message'].toString();
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      dynamic userDecoded = jsonDecode(userRes.body);
      Object? idUsuario;
      if (userDecoded is List && userDecoded.isNotEmpty && userDecoded.first is Map) {
        final m = userDecoded.first as Map;
        idUsuario = m['id_usuario'] ?? m['id_Usuario'];
      } else if (userDecoded is Map) {
        idUsuario = userDecoded['id_usuario'] ?? userDecoded['id_Usuario'];
      }
      if (idUsuario == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Respuesta inválida del servidor (id_usuario)')),
        );
        return;
      }

      final n = widget.cantidad ?? 1;
      final precio = widget.precio ?? 0;
      final metodo = _metodoPagoParam(_seleccion!);

      for (var i = 0; i < n; i++) {
        final insUri = Uri.parse('$_base/insertarBillete').replace(
          queryParameters: {
            'id_viaje': '$idViaje',
            'montoTotal': '$precio',
            'metodoPago': metodo,
            'id_usuario': '$idUsuario',
          },
        );
        final ins = await http.get(insUri).timeout(const Duration(seconds: 25));
        if (ins.statusCode != 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al insertar billete (${ins.statusCode})')),
          );
          return;
        }

        final mailUri = Uri.parse('$_base/enviarBillete').replace(
          queryParameters: {'correo_electronico': correo},
        );
        final mail = await http.get(mailUri).timeout(const Duration(seconds: 60));
        if (mail.statusCode != 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al enviar correo (${mail.statusCode})')),
          );
          return;
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra completada')),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Pantallamenu(email: widget.email),
        ),
        (route) => false,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error de conexión con el servidor')),
        );
      }
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  Widget _circulo(bool marcado, {required bool sobreFondoOscuro}) {
    final borde = sobreFondoOscuro ? Colors.white70 : Colors.black54;
    final relleno = sobreFondoOscuro ? Colors.white : Colors.black87;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: borde, width: 2)),
      alignment: Alignment.center,
      child: marcado
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: relleno),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 235, 255),
        elevation: 0,
        title: Text(
          'Elegir método de pago',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(20), child: Stack(children: [
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
             Icon(Icons.lock, size: 25, color: Colors.black),
             Text('Pago 100% seguro',style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
          
          ],
          ),
          ),
        ),
        
        Positioned(
          top: 80,
          left: 0,
          right: 0,
          child: Container(
          width: 380,
          height: 400,
          
        child: 
        Center(
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text('Selecciona una opcion:',style: GoogleFonts.plusJakartaSans(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.black),),
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              // Con left+right el ancho es todo el Stack; Center hace que el
              // Container solo ocupe el ancho (y alto) del hijo: el texto.
              
                
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _seleccion = _MetodoPago.applePay),
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _circulo(_seleccion == _MetodoPago.applePay, sobreFondoOscuro: true),
                        const SizedBox(width: 10),
                        Text(
                          'Pagar con Apple Pay',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.apple, size: 20, color: Color.fromARGB(255, 255, 255, 255)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            

            Positioned(
              top: 200,
              left: 0,
              right: 0,
              // Con left+right el ancho es todo el Stack; Center hace que el
              // Container solo ocupe el ancho (y alto) del hijo: el texto.
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _seleccion = _MetodoPago.paypal),
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 131, 196, 232),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _circulo(_seleccion == _MetodoPago.paypal, sobreFondoOscuro: false),
                        const SizedBox(width: 10),
                        Text(
                          'Pagar con PayPal',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.paypal_outlined, size: 20, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),


             Positioned(
              top: 300,
              left: 0,
              right: 0,
              // Con left+right el ancho es todo el Stack; Center hace que el
              // Container solo ocupe el ancho (y alto) del hijo: el texto.
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _seleccion = _MetodoPago.visa),
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFfdbb0a),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _circulo(_seleccion == _MetodoPago.visa, sobreFondoOscuro: false),
                        const SizedBox(width: 10),
                        Text(
                          'Pagar con Visa',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.credit_card, size: 20, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            ),


            
          ],
          
          
          
          ),



          
        ),
        ),),

Positioned(
  top: 550,
  left: 0,
  right: 0,
  child: Center(
    child: Text(
      'Total a pagar: ${((widget.cantidad ?? 1) * (widget.precio ?? 0)).toStringAsFixed(2)}€',
      style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    ),
  ),
),

         Positioned(
              top: 600,
              left: 0,
              right: 0,
              // Con left+right el ancho es todo el Stack; Center hace que el
              // Container solo ocupe el ancho (y alto) del hijo: el texto.
              child: Center(
                child: GestureDetector(
                  onTap: (_seleccion != null && !_procesando) ? _confirmarPago : null,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: (_seleccion != null && !_procesando)
                          ? const Color.fromARGB(255, 131, 196, 232)
                          : const Color.fromARGB(255, 190, 198, 206),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_procesando) ...[
                          const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black54),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          _procesando ? 'Procesando…' : 'Confirmar y pagar',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: (_seleccion != null && !_procesando) ? Colors.black : Colors.black45,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ]
                    ),
                  ),
                ),
              ),
            ),
        
      ],),
      ),
    );
  }
}
