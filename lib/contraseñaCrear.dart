import 'package:flutter/material.dart';

class Contrasenyacrear extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const Contrasenyacrear({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
  });

  @override
  State<Contrasenyacrear> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<Contrasenyacrear> {
  bool _obscureText = true;

 @override
Widget build(BuildContext context) { 
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch, // Hace que los hijos ocupen todo el ancho
    children: [

      // Campo de texto para la contraseña
      TextFormField( 
        controller: widget.controller,
        obscureText: _obscureText, // Oculta o muestra el texto según _obscureText
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration( 
          filled: true, // Habilita color de fondo
          fillColor: Colors.white, // Color de fondo del TextField
          labelText: 'ej: Paco123@', // Texto de ejemplo dentro del campo
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]), // Icono a la izquierda

          // Botón para mostrar u ocultar la contraseña
          suffixIcon: IconButton( 
            icon: Icon( 
              _obscureText ? Icons.visibility_off : Icons.visibility, // Cambia icono según estado
              color: Colors.grey[400], 
            ), // aqui lo que hace es q encaso de que le de cambia la visibilidad de la contraseña
            onPressed: () { 
              setState(() { 
                _obscureText = !_obscureText; // Cambia el estado de visibilidad
              }); 
            }, 
          ), 
          // Bordes redondeados
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(30), 
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

    ],
  );
}

}
