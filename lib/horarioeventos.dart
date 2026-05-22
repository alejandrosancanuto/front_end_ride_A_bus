import 'package:app_ride_a_bus/pre_compra.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorarioEventos extends StatefulWidget {
  
  const HorarioEventos({super.key, this.evento, this.email});
  final String? evento;
  final String? email;
  

  @override
  State<HorarioEventos> createState() => _HorarioEventosState();
}
late final String direccion;

class _HorarioEventosState extends State<HorarioEventos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 235, 255),
      // La flecha de volver aquí usa el Navigator de esta pantalla:
      // al abrir con Navigator.push, Navigator.pop cierra esta ruta y vuelve a la anterior.
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 235, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: SizedBox(
              height: 900,
              width: constraints.maxWidth,
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 0,
                right: 41,
                child: Center(
                child: Text(
                  'Horario de autobuses',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ),
              ),
            

              Positioned(
                top: 120,
                left: 0,
                right: 200,
                child: Center(
                  child: Text(
                    widget.evento!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                     fontWeight: FontWeight.bold,
                    ),
                    
                ),
                  
              ),
                  
              ),

              
              

              Positioned(
                top: 180,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(children: [
                     

                    const SizedBox(height: 12),
GestureDetector(
  onTap:(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreCompra(evento: widget.evento,direccionParada: 'Marques del Turia 137', horaSalida: DateTime(2024, 1, 1, 19, 0), email: widget.email)),
    );
  },
  child:
                    Container(
                      width: 380,
                      height: 120, 
                        decoration:BoxDecoration(
                        color: const Color.fromARGB(106, 255, 255, 255),
                        borderRadius: BorderRadius.circular(40),
                      
                      
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(30), child: 
                      Align(
                            alignment: Alignment.centerLeft,
                            
                            child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 91, 90, 90),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                          'Salida \n 19:00',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                          ),
                          
                      ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color.fromARGB(255, 98, 97, 97),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Marques del Turia 137',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                    ),
                    
                    ),
                    ),
                  ],
              ),
              ),
              ),


              Positioned(
                top: 330,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(children: [
                     

                    const SizedBox(height: 12),
GestureDetector(
  onTap:(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreCompra(evento: widget.evento,direccionParada: 'Marques del Turia 137', horaSalida: DateTime(2024, 1, 1, 19, 30), email: widget.email)),
    );
  },
  child:
                    Container(
                      width: 380,
                      height: 120, 
                        decoration:BoxDecoration(
                        color: const Color.fromARGB(106, 255, 255, 255),
                        borderRadius: BorderRadius.circular(40),
                      
                      
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(30), child: 
                      Align(
                          alignment: Alignment.centerLeft,
                            
                          child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 91, 90, 90),
                            borderRadius: BorderRadius.circular(23),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                        'Salida \n 19:30',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                        ),
                        
                    ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color.fromARGB(255, 98, 97, 97),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Marques del Turia 137',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                    ),
                    
                    ),
                    ),
                  ],
              ),
              ),
              ),

        Positioned(
                top: 480,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(children: [
                     

                    const SizedBox(height: 12),
GestureDetector(
  onTap:(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreCompra(evento: widget.evento,direccionParada: 'Avenida de las Cortes Valencianas 3', horaSalida: DateTime(2024, 1, 1, 20, 0), email: widget.email)),
    );
  },
  child:
                    Container(
                      width: 380,
                      height: 120, 
                        decoration:BoxDecoration(
                        color: const Color.fromARGB(106, 255, 255, 255),
                        borderRadius: BorderRadius.circular(40),
                      
                      
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(30), child: 
                      Align(
                            alignment: Alignment.centerLeft,
                            
                            child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 91, 90, 90),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                          'Salida \n 20:00',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                          ),
                          
                      ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color.fromARGB(255, 98, 97, 97),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Avenida de las Cortes Valencianas 3',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                    ),
                    
                    ),
                    ),
                  ],
              ),
              ),
              ),
              

             Positioned(
                top: 630,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(children: [
                     

                    const SizedBox(height: 12),
GestureDetector(
  onTap:(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreCompra(evento: widget.evento,direccionParada: ' Av De Francia 279', horaSalida: DateTime(2024, 1, 1, 20, 30), email: widget.email)),
    );
  },
  child:
                    Container(
                      width: 380,
                      height: 120, 
                        decoration:BoxDecoration(
                        color: const Color.fromARGB(106, 255, 255, 255),
                        borderRadius: BorderRadius.circular(40),
                      
                      
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(30), child: 
                      Align(
                            alignment: Alignment.centerLeft,
                            
                            child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 91, 90, 90),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                          'Salida \n 20:30',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                          ),
                          
                      ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color.fromARGB(255, 98, 97, 97),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Av De Francia 279',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                
                                ],
                              ),
                            ),
                          ),
                    ],
                    ),
                    
                    ),
                    ),
                  ],
              ),
              ),
              ),

              Positioned(
                top: 780,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(children: [
                     

                    const SizedBox(height: 12),
GestureDetector(
  onTap:(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PreCompra(evento: widget.evento,direccionParada: 'Av Dr.Tomas Sala 279', horaSalida: DateTime(2024, 1, 1, 21, 0), email: widget.email)),
    );
  },
  child:
                    Container(
                      width: 380,
                      height: 120, 
                        decoration:BoxDecoration(
                        color: const Color.fromARGB(106, 255, 255, 255),
                        borderRadius: BorderRadius.circular(40),
                      
                      
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(30), child: 
                      Align(
                            alignment: Alignment.centerLeft,
                            
                            child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 91, 90, 90),
                              borderRadius: BorderRadius.circular(23),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                          'Salida \n 21:00',
                          style: GoogleFonts.plusJakartaSans(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                          ),
                          
                      ),
                          ),
                          
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: const Color.fromARGB(255, 98, 97, 97),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Av Dr.Tomas Sala 279',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                    ),
                    
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
        },
      ),
    );
  }
}
