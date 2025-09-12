import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(
    -23.5505,
    -46.6333,
  ); // Posição padrão (São Paulo)
  final Set<Marker> _markers = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    Location location = Location();

    // Verifica se o serviço está habilitado
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) serviceEnabled = await location.requestService();

    // Verifica permissões
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (permissionGranted == PermissionStatus.granted) {
      final locData = await location.getLocation();
      setState(() {
        _initialPosition = LatLng(
          locData.latitude ?? -23.5505,
          locData.longitude ?? -46.6333,
        );
        _markers.add(
          Marker(
            markerId: const MarkerId('user'),
            position: _initialPosition,
            infoWindow: const InfoWindow(title: 'Você'),
          ),
        );
        _loading = false;
      });
    } else {
      // Permissão negada, usa posição padrão
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Atividades'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }
}
