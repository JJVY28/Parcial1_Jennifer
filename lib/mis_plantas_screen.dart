import 'package:flutter/material.dart';
import 'api_service.dart';

class MisPlantasScreen extends StatefulWidget {
  final String correoUsuario;

  const MisPlantasScreen({super.key, required this.correoUsuario});

  @override
  State<MisPlantasScreen> createState() => _MisPlantasScreenState();
}

class _MisPlantasScreenState extends State<MisPlantasScreen> {
  List<dynamic> plantas = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarPlantas();
  }

  Future<void> cargarPlantas() async {
    final api = ApiService();
    try {
      // Ajustado: obtenerMisPlantas recibe solo String correo sin parámetro nombrado
      final respuesta = await api.obtenerMisPlantas(widget.correoUsuario);
      // respuesta es List<Map<String,dynamic>>, no un mapa con 'success' y 'plantas'
      setState(() {
        plantas = respuesta;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      mostrarError("Error al cargar tus plantas: $e");
    }
  }

  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🌿 Mis Plantas")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : plantas.isEmpty
              ? const Center(child: Text("Aún no tienes plantas registradas"))
              : ListView.builder(
                  itemCount: plantas.length,
                  itemBuilder: (context, index) {
                    final planta = plantas[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(planta['customPlantName'] ?? 'Sin nombre personalizado'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🌱 Tipo: ${planta['plantType'] ?? 'Desconocido'}"),
                            Text("🪴 Planta base: ${planta['plantName'] ?? 'Desconocida'}"),
                            Text("📅 Registrada: ${planta['fecha'] != null ? planta['fecha'].substring(0, 10) : 'Sin fecha'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
