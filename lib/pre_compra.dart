import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreCompra extends StatefulWidget {
  const PreCompra({super.key, this.evento, this.direccionParada});
  final String? evento;
  final String? direccionParada;
  

  @override
  State<PreCompra> createState() => _PreCompraState();
}

class _PreCompraState extends State<PreCompra> {
  int cantidad=1;
  double precio=3.99;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 235, 255),
        elevation: 0,
        title: Text('Resumen de la compra',style: GoogleFonts.plusJakartaSans(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
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
                    image: DecorationImage(image: NetworkImage('https://www.autocaresgarciacastro.com/images/linea-autobuses-pontevedra.jpg'),fit: BoxFit.cover),
                  ),
                 ),
                ),
               ),

        Padding( padding:const EdgeInsets.only(top:250), child: 
          Container(
            width: 380,
            height: 500,
            
            decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
              

                 Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${cantidad}x Billete ida y vuelta ${widget.evento} \n \nParada en: ${widget.direccionParada}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                      ),
                ),
                Positioned(
                top: 400,
                left: 20,
                right: 0,
                
                  child: Text(
                    'Total:${cantidad*precio}€',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    
                  ),
                ),
                ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(children: [
                    IconButton(onPressed: () {
                      setState(() {
                        if (cantidad > 1) {
                          cantidad--;
                        }
                      });
                    }, 
                    icon: Icon(Icons.remove_circle_outline)),
                    Text('Añadir más billetes',style: GoogleFonts.plusJakartaSans(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                    IconButton(onPressed: () {
                      setState(() {
                        cantidad++;
                      });
                    }, icon: Icon(Icons.add_circle_outline)),
                ],
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
