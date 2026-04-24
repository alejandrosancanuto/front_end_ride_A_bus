// 👈 Pantalla donde metes el código
import 'package:app_ride_a_bus/cambiarContrasena.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Contrasenyaolvidada extends StatefulWidget {
  const Contrasenyaolvidada({super.key});

  @override
  State<Contrasenyaolvidada> createState() => _ContrasenyaolvidadaState();
}

class _ContrasenyaolvidadaState extends State<Contrasenyaolvidada> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  String _email = '';
  bool _cargando = false; //  Para mostrar loading en el botón

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _esGmailValido(String value) {
    final v = value.trim().toLowerCase();
    return v.endsWith('@gmail.com');
  }

  // ──────────────────────────────────────
  // LLAMADA A LA API - Verifica correo y envía código
  // ──────────────────────────────────────
  Future<void> _enviarCodigo() async {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    _email = _emailController.text.trim();
    setState(() => _cargando = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/recuperar-contrasena'), // localhost del emulador
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo_electronico': _email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        //  Correo enviado correctamente → navega a la pantalla del código
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(' Código enviado a tu correo'),
              backgroundColor: Colors.green,
            ),
          );

          // Navega a la pantalla donde mete el código y la nueva contraseña
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => cambiarContrasena(
                correoElectronico: _email, // Pasa el email a la siguiente pantalla
              ),
            ),
          );
        }
      } else {
        //  Error del servidor
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Error al enviar el correo'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      //  Error de conexión (servidor apagado, sin internet, etc.)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de conexión. Comprueba tu internet'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [

            // Fondo de pantalla
            Container(
              color: const Color.fromARGB(255, 240, 235, 255),
            ),
             Positioned(
              top: 55,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Icono central
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.person_add_alt_1_sharp,
                      size: 80,
                      color: Color.fromARGB(255, 102, 0, 255),
                    ),
                  ),
                ),
              ),
            ),

            // Título principal
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Recupera tu contraseña",
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),

            // Formulario
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      // Label correo
                      Text(
                        "CORREO ELECTRÓNICO:",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // TextField correo
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {
                            _email = value.trim();
                          });
                        },
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Introduce tu correo';
                          if (!_esGmailValido(v)) return 'Debe terminar en @gmail.com';
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ej: pacosanz@gmail.com',
                          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(width: 3),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ─────────────────────────────
                      // BOTÓN ENVIAR CORREO
                      // ─────────────────────────────
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _cargando ? null : _enviarCodigo, // 👈 Desactivado mientras carga
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: _cargando
                              ? const CircularProgressIndicator(color: Colors.white) //  Loading
                              : const Text(
                                  'ENVIAR CORREO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botón iniciar sesión
                      
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
