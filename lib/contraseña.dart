import 'package:app_ride_a_bus/contraseñaOlvidada.dart';
import 'package:flutter/material.dart'; 


// Widget de campo de contraseña con estado
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Controla si la contraseña se muestra u oculta

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, // Ocupa todo el ancho
      children: [

        // Campo de texto para la contraseña
        TextField(
          obscureText: _obscureText, // Oculta el texto si _obscureText es true
          decoration: InputDecoration(
            filled: true, // Pone fondo blanco
            fillColor: Colors.white, // Color del fondo
            labelText: 'ej: Paco123@', // Texto de ejemplo
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]), // Icono de candado

            // Botón al final del campo para mostrar/ocultar contraseña
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility, // Cambia el icono
                color: Colors.grey[400],
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText; // Cambia el estado al pulsar
                });
              },
            ),

            // Borde redondeado
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        SizedBox(height: 8), // Pequeño espacio entre campo y texto

        // Texto "¿Has olvidado tu contraseña?" alineado a la derecha
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              // Navega a la pantalla de recuperar contraseña al pulsar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Contrasenyaolvidada(),
                ),
              );
            },
            child: Text(
              '¿Has olvidado tu contraseña?', 
              style: TextStyle(
                color: Color.fromARGB(255, 91, 90, 90), // Color gris
                fontSize: 14, // Tamaño de letra
              ),
            ),
          ),
        ),
      ],
    );
  }
}
