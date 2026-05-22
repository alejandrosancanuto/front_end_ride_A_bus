import 'package:app_ride_a_bus/primerInicioSesion.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class cambiarContrasena extends StatefulWidget {
  final String correoElectronico; // El email del usuario que viene de la pantalla anterior

  const cambiarContrasena({
    super.key,
    required this.correoElectronico,
  });

  @override
  State<cambiarContrasena> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<cambiarContrasena> {
  // Controllers para cada campo de la contraseña
  final _codigoController = TextEditingController();
  final _nuevaPassController = TextEditingController();
  final _repetirPassController = TextEditingController();

  // Visibilidad individual de cada campo contraseña
  bool _obscureNueva = true;
  bool _obscureRepetir = true;

  // Para mostrar loading en el botón mientras llama a la API
  bool _cargando = false;

  // Para validar el formulario
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codigoController.dispose();
    _nuevaPassController.dispose();
    _repetirPassController.dispose();
    super.dispose();
  }

  
  // LLAMADA A LA API
  
  Future<void> _cambiarContrasena() async {
    // Primero valida el formulario
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/cambiar-contrasena'), // localhost del emulador
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo_electronico': widget.correoElectronico,
          'codigo': _codigoController.text.trim(),
          'nueva_contrasena': _nuevaPassController.text,
        }),
      );

      final data = jsonDecode(response.body);
// aqui con la respuesta que le da la accion , si se ejecuta dentro del tiempo puesto da okey, contraseña cambiada
      if (response.statusCode == 200) {
        //  Éxito
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(' Contraseña cambiada correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          // Vuelve al login (quita todas las pantallas anteriores)
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else {
        //  Error del servidor (código incorrecto, expirado, etc.), en caso de que no de que pase cualquier fallo
        // da error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Error al cambiar la contraseña'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      //  Error de conexión
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
//aqui ellogito del icono y el texto de cambiar contraseña 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Stack(
          children: [
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
            Positioned(
              top: 130,
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
                      Icons.lock_reset_rounded,
                      size: 80,
                      color: Color.fromARGB(255, 102, 0, 255),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Cambiar contraseña',
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 285,
              left: 20,
              right: 20,
              bottom: 20,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Introduce el código de verificación:",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _codigoController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'ej: 123456',
                            counterText: '',
                            prefixIcon: Icon(Icons.pin_outlined, color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Introduce el código';
                            if (value.length != 6) return 'El código debe tener 6 dígitos';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Introduce tu nueva contraseña:",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nuevaPassController,
                          obscureText: _obscureNueva,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'ej: Paco123@',
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNueva ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[400],
                              ),
                              onPressed: () => setState(() => _obscureNueva = !_obscureNueva),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Introduce una contraseña';
                            if (value.length < 6) return 'Mínimo 6 caracteres';
                            if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Debe tener 1 mayúscula';
                            if (!RegExp(r'\d').hasMatch(value)) return 'Debe tener 1 número';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Introduce otra vez tu nueva contraseña:",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _repetirPassController,
                          obscureText: _obscureRepetir,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'ej: Paco123@',
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureRepetir ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[400],
                              ),
                              onPressed: () => setState(() => _obscureRepetir = !_obscureRepetir),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Repite la contraseña';
                            if (value != _nuevaPassController.text) return 'Las contraseñas no coinciden';
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _cargando ? null : _cambiarContrasena,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90E2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: _cargando
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Confirmar cambio',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        
                      ],
                    ),
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