import 'dart:convert';
import 'package:app_ride_a_bus/contrase%C3%B1a.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:app_ride_a_bus/segundoInicio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = '';
// el dispose lo que hace es que cuando dejan de usuarse , se liberar espacio
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _esGmailValido(String value) {
    final v = value.trim().toLowerCase();
    return v.endsWith('@gmail.com');
  }

  String? _validarPassword(String? value) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Introduce tu contraseña';
    if (v.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Debe tener 1 mayúscula';
    if (!RegExp(r'\d').hasMatch(v)) return 'Debe tener 1 número';
    return null;
  }

  // Función para llamar a la API de login, aqui lo que hace es guardar ahi los  valores
  Future<void> _loginUsuario() async {
    final body = {
      "correo_electronico": _emailController.text.trim(),
      "contrasena": _passwordController.text,
    };
// aqui conectamos la app por decirlo de alguna manera
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/login'), // IP del emulador Android
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
// qui lo que hace es que si responde en ese tiempo me manda a la pantalla menu, sino lanza el error
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${data['message']} ")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pantallamenu(email: _emailController.text.trim()),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${data['message']} ")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo conectar al servidor ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(color: const Color.fromARGB(255, 240, 235, 255)),
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
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
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Inicio de sesión",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "CORREO ELECTRÓNICO:",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          final v = (value ?? '').trim();
                          if (v.isEmpty) return 'Introduce tu correo';
                          if (!_esGmailValido(v)) return 'Debe contener @gmail.com';
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'ej: pacosanz@gmail.com',
                          prefixIcon:
                              Icon(Icons.mail_outline, color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "CONTRASEÑA:",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 91, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 5),
                      PasswordField(
                        controller: _passwordController,
                        validator: _validarPassword,
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          final ok = _formKey.currentState?.validate() ?? false;
                          if (!ok) return;
                          _loginUsuario();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          'INICIAR SESION',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SegundoInicio(),
                              ),
                            );
                          },
                          child: Text(
                            "¿No tienes cuenta? Creala aqui",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color.fromARGB(255, 91, 90, 90),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
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