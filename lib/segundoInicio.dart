import 'dart:convert';
import 'package:app_ride_a_bus/contrase%C3%B1aCrear.dart';
import 'package:app_ride_a_bus/pantallaMenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SegundoInicio extends StatefulWidget {
  const SegundoInicio({super.key});

  @override
  State<SegundoInicio> createState() => _SegundoInicioState();
}

class _SegundoInicioState extends State<SegundoInicio> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();

  DateTime? _fechaNacimiento;
// aqui lo mismo cuando ya no se utilizan, libera el espacio que ocupan
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _dniController.dispose();
    super.dispose();
  }
// aqui las verificaciones de que el correo sea valido, y que sea de gmail.com
  bool _esGmailValido(String value) {
    final v = value.trim().toLowerCase();
    return v.endsWith('@gmail.com');
  }
// aqui las verificaciones de que la contraseña sea valida, y que sea de 8 caracteres, 1 mayuscula y 1 numero
  String? _validarPassword(String? value) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Introduce tu contraseña';
    if (v.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Debe tener 1 mayúscula';
    if (!RegExp(r'\d').hasMatch(v)) return 'Debe tener 1 número';
    return null;
  }
// verificacion de que el dni sea valido, y que sea de 8 numeros y 1 letra
// aqui hare tambien la formula para saber la letra del dni que le corresponde
  String? _validarDni(String? value) {
    final v = (value ?? '').toUpperCase().trim();
    if (v.isEmpty) return 'Introduce tu DNI';
    if (!RegExp(r'^\d{8}[A-Z]$').hasMatch(v)) {
      return 'Formato: 8 números y 1 letra (ej: 12345678A)';
    }
    return null;
  }
// aqui para poner la edad sale un calendario con el datepicker, para seleccionar fechas que existan
  Future<void> _seleccionarFecha(BuildContext context) async {
    final hoy = DateTime.now();
    final primeraFecha = DateTime(hoy.year - 100);
    final ultimaFecha = hoy;

    final DateTime? seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(hoy.year - 18, hoy.month, hoy.day),
      firstDate: primeraFecha,
      lastDate: ultimaFecha,
    );

    if (seleccionada != null) {
      setState(() {
        _fechaNacimiento = seleccionada;
        final d = seleccionada.day.toString().padLeft(2, '0');
        final m = seleccionada.month.toString().padLeft(2, '0');
        final y = seleccionada.year.toString();
        _dobController.text = '$d/$m/$y';
      });
    }
  }
// aqui lo que hacemos es despues de las verificaciones, nos conectamos a la api
// i manda los datos a la api  para que se manden a la base de datos y se cree el usuario
// y si todo va bien, nos manda a la pantalla menu
// y si no, nos muestra el error
  Future<void> _registrarUsuario() async {
    if (_fechaNacimiento == null) return;

    final fechaStr =
        "${_fechaNacimiento!.year}-${_fechaNacimiento!.month.toString().padLeft(2,'0')}-${_fechaNacimiento!.day.toString().padLeft(2,'0')}";

    final body = {
      "correo_electronico": _emailController.text.trim(),
      "contrasena": _passwordController.text,
      "dni": _dniController.text.toUpperCase().trim(),
      "fecha_nacimiento": fechaStr,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuario registrado correctamente ")),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Pantallamenu(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${data['message']}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo conectar al servidor ")),
      );
    }
  }


// aqui lo que hacemos es crear la interfaz de la pantalla de registro de usuario
// aqui tenemos todo lo visual de la pantalla de registro de usuario
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // aqui tenemos el icono de la persona con el + para crear la cuenta
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
            Positioned(
              top: 250,
              left: 110,
              child: Text(
                'Crear cuenta',
                style: GoogleFonts.lato(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),// aqui lo tenemos todo el formulario para crear la cuenta 
            Positioned(
              top: 300,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "CORREO ELECTRÓNICO:",
                          style: GoogleFonts.bricolageGrotesque(
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
                            if (!_esGmailValido(v)) return 'Debe terminar en @gmail.com';
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
                        const SizedBox(height: 20),
                        Text(
                          "CONTRASEÑA:",
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Contrasenyacrear(
                          controller: _passwordController,
                          validator: _validarPassword,
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "FECHA DE NACIMIENTO:",
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: () => _seleccionarFecha(context),
                          validator: (value) {
                            if ((value ?? '').isEmpty) {
                              return 'Selecciona tu fecha de nacimiento';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'ej: DD/MM/AAAA',
                            prefixIcon:
                                Icon(Icons.calendar_today, color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "DNI:",
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 91, 90, 90),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _dniController,
                          textInputAction: TextInputAction.done,
                          validator: _validarDni,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'ej: 00000000A',
                            prefixIcon:
                                Icon(Icons.badge_outlined, color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            final ok = _formKey.currentState?.validate() ?? false;
                            if (!ok) return;

                            _registrarUsuario();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF4A90E2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'CREAR CUENTA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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