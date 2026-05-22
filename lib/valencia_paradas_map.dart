import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';


const List<ParadaEnMapa> paradasValenciaCoordenadas = [
  ParadaEnMapa(' Marques del Turia 137', LatLng(39.4685737, -0.3646564)),
  ParadaEnMapa("Avenida de las Cortes Valencianas 3", LatLng(39.4949, -0.4010)),
  ParadaEnMapa('Av de Francia 279', LatLng(39.4589, -0.3317)),
  ParadaEnMapa('Av dr. Tomas Sala 279', LatLng(39.4476, -0.3866)),
 
];

class ParadaEnMapa {
  final String nombre;
  final LatLng punto;

  const ParadaEnMapa(this.nombre, this.punto);
}

/// Mapa interactivo centrado en Valencia con paradas marcadas.
class ValenciaParadasMap extends StatelessWidget {
  const ValenciaParadasMap({super.key});

  static final LatLng _centroValencia = LatLng(39.4699, -0.3763);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlutterMap(
      options: MapOptions(
        initialCenter: _centroValencia,
        initialZoom: 11.8,
        minZoom: 10,
        maxZoom: 18,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app_ride_a_bus',
        ),
        MarkerLayer(
          alignment: Alignment.topCenter,
          markers: [
            for (final p in paradasValenciaCoordenadas)
              Marker(
                point: p.punto,
                width: 44,
                height: 44,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(p.nombre),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.directions_bus_rounded,
                    size: 36,
                    color: theme.colorScheme.primary,
                    shadows: const [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        SimpleAttributionWidget(
          source: const Text('OpenStreetMap'),
          onTap: () => launchUrl(
            Uri.parse('https://www.openstreetmap.org/copyright'),
            mode: LaunchMode.externalApplication,
          ),
          backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.92),
        ),
      ],
    );
  }
}
