// EcoGrow con diseño mejorado 🌿
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart'; // Asegúrate de tener esta importación arriba
import 'mis_plantas_screen.dart';



void main() => runApp(const EcoGrowApp());

class EcoGrowApp extends StatelessWidget {
  const EcoGrowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoGrow 🌱',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CategoriaSelector(),
    );
  }
}

class Plant {
  final String nombre;
  final String tipo;
  final String imagen;
  final String descripcion;
  final String humedadIdeal;
 final List<String> curiosidades;


  Plant(this.nombre, this.tipo, this.imagen, this.descripcion, this.humedadIdeal, this.curiosidades);
}

final List<Plant> plantas = [
  Plant('Hierbabuena', 'aromaticas', 'assets/images/hierbabuena.jpeg','Planta medicinal con aroma refrescante.', '60% - 80%',
  [ 'Ahuyenta insectos.',
    'Mejora la digestión.',
    'Crece rápido en macetas.',
    'Buena para dolores estomacales y refrescar bebidas.'
  ],  ),
  Plant('Menta', 'aromaticas', 'assets/images/menta.jpeg','Planta muy usada en tés.', '65% - 85%',
   [
      'Refrescante natural.',
      'Se usa para el mal aliento.',
      'Puede invadir otras plantas si no se controla.',
      'Ayuda a aliviar náuseas y congestión nasal.',
    ],
  ),
  Plant('Romero', 'aromaticas', 'assets/images/romero.jpeg','Hierba aromática para cocinar.', '50% - 70%',
   [
      'Repele plagas.',
      'Mejora la memoria (según estudios).',
      'Crece mejor con poco riego.',
      'Puede mejorar la concentración.',
    ],
  ),
  Plant('Ruda', 'aromaticas', 'assets/images/ruda.jpeg','Planta con propiedades medicinales.', '55% - 75%', 
   [
      'Se cree que protege del "mal de ojo".',
      'Tiene propiedades antiinflamatorias.',
      'Es tóxica en exceso.',
      'Aleja insectos y se usa para limpias.',
    ],
  ),
  Plant('Chile Verde', 'hortalizas', 'assets/images/ChileVerde.jpeg','Hortaliza jugosa para muchas comidas.', '60% - 80%', 
   [
      'Necesita mucho sol.',
      'Hay muchas variedades (jalapeño, serrano, poblano).',
      'El picante proviene de la capsaicina.',
      'Rica en vitamina C.',
    ],
  ),
  Plant('Tomate', 'hortalizas', 'assets/images/Tomate.jpeg','Hortaliza jugosa para muchas comidas.', '60% - 80%', 
  [
      'Aunque se usa como verdura, es una fruta.',
      'Rico en licopeno, un antioxidante.',
      'Requiere tutor o guía para crecer.',
  ],
   ),
  Plant('Cebolla', 'hortalizas', 'assets/images/cebolla.jpeg','Hortaliza jugosa para muchas comidas.', '60% - 80%',
  [
      'Causa lágrimas por compuestos sulfurosos.',
      'Puede crecer a partir de restos.',
      'Ayuda a controlar plagas del huerto.',
  ],     
  ),
  Plant('Cilantro', 'hortalizas', 'assets/images/cilantro.jpeg','Muy usado en salsas y sopas.', '65% - 85%',
   [
      'Algunas personas sienten que sabe a jabón (genética).',
      'Se usa tanto la hoja como la semilla (cilantro y coriandro).',
      'Crece rápido pero se espiga fácil con calor.',
      'Fuente de antioxidantes.',
   ],
  ),
  Plant('Corona de Cristo', 'flores', 'assets/images/coronadecristo.jpeg','Flor ornamental resistente.', '40% - 60%', 
  [
      'Florece casi todo el año.',
      'Tolera el sol directo.',
      'Su savia es irritante.',
      'Se cree que protege el hogar.',
    ],
  ),
  Plant('Periskia', 'flores', 'assets/images/periskia.jpeg','Flor exótica tropical.', '50% - 70%',
   [
      'Es un cactus que sí tiene hojas.',
      'Produce flores llamativas.',
      'Es comestible en algunas regiones.',
      'Atractiva para mariposas.',
   ],
  ), 
  Plant('Cactus Estrella', 'flores', 'assets/images/cactusestrella.jpeg','Cactus de forma estrellada.', '30% - 50%', 
    [
      'Su flor huele a carne podrida (atrae moscas).',
      'Es una planta muy resistente.',
      'No requiere riego frecuente.',
      'Florece en ambientes áridos.',
    ],
  ),
  Plant('Suculenta', 'flores', 'assets/images/suculentas.jpeg','Planta decorativa.', '30% - 60%', 
    [
      'Fácil de cuidar.',
      'Muy resistente.',
      'Almacena agua en sus hojas.',
    ],
  ),
];

class CategoriaSelector extends StatelessWidget {
  const CategoriaSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = ['aromaticas', 'hortalizas', 'flores'];
    final nombres = {
      'aromaticas': 'Aromáticas 🌿',
      'hortalizas': 'Hortalizas 🥬',
      'flores': 'Flores Exóticas 🌸',
    };
    final imagenes = {
      'aromaticas': 'assets/images/aromaticas.jpeg',
      'hortalizas': 'assets/images/hortalizas.jpeg',
      'flores': 'assets/images/flores.jpeg',
    };

    final coloresTarjeta = {
      'aromaticas': const Color(0xFF81C784),   // Verde menta
      'hortalizas': const Color.fromARGB(218, 177, 111, 36),   // Naranja suave
      'flores': const Color(0xFF8E24AA),     // Lila claro
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EcoGrow 🌱',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 10, 177, 85),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 219, 252, 30), Color.fromARGB(255, 168, 34, 34)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.spa_outlined),
                label: const Text("Ver mis plantas 🌿"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal.shade800,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final correoController = TextEditingController();
                      return AlertDialog(
                        title: const Text("🔍 Buscar tus plantas"),
                        content: TextField(
                          controller: correoController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: "Ingresa tu correo"),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () {
                              final correo = correoController.text.trim();
                              if (correo.isNotEmpty) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MisPlantasScreen(correoUsuario: correo),
                                  ),
                                );
                              }
                            },
                            child: const Text("Buscar"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              // 🔽 Tarjetas de categoría
              ...categorias.map((cat) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlantasPorCategoria(tipo: cat, titulo: nombres[cat]!),
                    ),
                  ),
                  child: Card(
                    color: coloresTarjeta[cat],
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: Image.asset(imagenes[cat]!, height: 180, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            nombres[cat]!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class PlantasPorCategoria extends StatelessWidget {
  final String tipo;
  final String titulo;

  const PlantasPorCategoria({super.key, required this.tipo, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final filtradas = plantas.where((p) => p.tipo == tipo).toList();

    // Gradientes de fondo por categoría
    final gradientes = {
      'aromaticas': [Colors.green.shade100, Colors.green.shade600],
      'hortalizas': [Colors.orange.shade200, Colors.red.shade400],
      'flores': [const Color.fromARGB(255, 160, 14, 63), Colors.purple.shade500],
    };

    // Colores personalizados por planta
    final Map<String, Color> colorPorPlanta = {
      'Hierbabuena': const Color.fromARGB(218, 177, 111, 36),  // cafe
      'Menta': const Color.fromARGB(218, 177, 111, 36),  // cafe
      'Romero': const Color.fromARGB(218, 177, 111, 36),      // cafe
      'Ruda': const Color.fromARGB(218, 177, 111, 36),         // cafe
      'Tomate': const Color(0xFFE53935),       // rojo tomate
      'Cilantro': const Color(0xFF66BB6A),     // verde cilantro
      'Corona de Cristo': const Color(0xFFD81B60), // rosa vibrante
      'Periskia': const Color(0xFF8E24AA),     // morado
      'Cactus Estrella': const Color(0xFF795548), // marrón cactus
      'Suculenta': const Color(0xFF00796B),    // verde azulado
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 241, 241, 241),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 66, 189, 76),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientes[tipo] ?? [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtradas.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 600,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            final planta = filtradas[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetallePlanta(planta: planta)),
              ),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: colorPorPlanta[planta.nombre] ?? Colors.teal,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          planta.imagen,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            planta.nombre,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // color del texto
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DetallePlanta extends StatelessWidget {
  final Plant planta;

  const DetallePlanta({super.key, required this.planta});

  @override
  Widget build(BuildContext context) {
    final fondos = {
      'Hierbabuena': [const Color(0xFFA5D6A7), const Color(0xFF66BB6A)],
      'Menta': [const Color(0xFFB2DFDB), const Color(0xFF26A69A)],
      'Romero': [const Color(0xFFDCEDC8), const Color(0xFF9CCC65)],
      'Ruda': [const Color(0xFFF0F4C3), const Color(0xFFD4E157)],
      'Chile Verde': [const Color(0xFFAED581), const Color(0xFF558B2F)],
      'Tomate': [const Color(0xFFFFCDD2), const Color(0xFFE57373)],
      'Cebolla': [const Color(0xFFD1C4E9), const Color.fromARGB(255, 187, 177, 33)],
      'Cilantro': [const Color(0xFFC8E6C9), const Color(0xFF43A047)],
      'Corona de Cristo': [const Color(0xFFFFF9C4), const Color(0xFFD81B60)],
      'Periskia': [const Color(0xFFD1C4E9), const Color.fromARGB(255, 160, 14, 63)],
      'Cactus Estrella': [const Color(0xFFB2EBF2), const Color(0xFF795548)],
      'Suculenta': [const Color(0xFFB2DFDB), const Color(0xFF00796B)],
    };

    final colores = fondos[planta.nombre] ?? [Colors.white, Colors.grey];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const SizedBox.shrink(),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colores,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    planta.imagen,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '🪴 Detalles de la planta (${planta.nombre})',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 16),

                // ✍️ Descripción
                Row(
                  children: const [
                    Text('✍️', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Text('Descripción:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(planta.descripcion),

                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.water_drop, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text('Humedad ideal:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(planta.humedadIdeal),

                const SizedBox(height: 16),
                Row(
                  children: const [
                    Icon(Icons.lightbulb_outline, color: Color(0xFF4E342E)), // Marrón tierra
                    SizedBox(width: 8),
                    Text('Curiosidades:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: planta.curiosidades.map((dato) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 16)),
                          Expanded(child: Text(dato.trim(), style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.spa),
                    label: const Text('Plantar esta planta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(235, 128, 150, 143),
                      foregroundColor: const Color.fromARGB(255, 2, 2, 2),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => PlantarDialog(planta: planta),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlantarDialog extends StatelessWidget {
  final Plant planta;

  const PlantarDialog({super.key, required this.planta});

  @override
  Widget build(BuildContext context) {
    final nombreController = TextEditingController();
    final correoController = TextEditingController();
    final telefonoController = TextEditingController();
    final nombrePersonalizadoController = TextEditingController();

    final apiService = ApiService(); // Instancia del servicio

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('🌱 Registrar "${planta.nombre}"'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: '👤 Tu nombre'),
            ),
            TextField(
              controller: nombrePersonalizadoController,
              decoration: const InputDecoration(labelText: '🌿 Nombre personalizado'),
            ),
            TextField(
              controller: correoController,
              decoration: const InputDecoration(labelText: '📧 Correo electrónico'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: '📱 Teléfono'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final nombre = nombreController.text.trim();
            final correo = correoController.text.trim();
            final telefono = telefonoController.text.trim();
            final personalizado = nombrePersonalizadoController.text.trim();

            if (nombre.isEmpty || correo.isEmpty || telefono.isEmpty || personalizado.isEmpty) {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("⚠️ Campos incompletos"),
                  content: const Text("Por favor, completa todos los campos."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Aceptar"),
                    ),
                  ],
                ),
              );
              return;
            }

            try {
              final respuesta = await apiService.enviarFormulario(
                plantName: planta.nombre,
                plantType: planta.tipo,
                userName: nombre,
                customPlantName: personalizado,
                telefono: telefono,
                correo: correo,
              );

              if (respuesta['success'] == true) {
                final humedad = await apiService.verificarHumedad(
                  plantType: planta.tipo,
                  correo: correo,
                  userName: nombre,
                  customPlantName: personalizado,
                );

                // 🔹 PASO 4: Guardar en el backend
                await apiService.guardarPlanta(
                  plantName: planta.nombre,
                  plantType: planta.tipo,
                  userName: nombre,
                  customPlantName: personalizado,
                  telefono: telefono,
                  correo: correo,
                );

                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("✅ Planta registrada"),
                    content: Text(humedad['mensaje'] ?? "Planta registrada con éxito."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.of(context).pop(); // Cierra el modal de registro
                        },
                        child: const Text("Aceptar"),
                      ),
                    ],
                  ),
                );
              } else {
                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("❌ Error"),
                    content: Text(respuesta['mensaje'] ?? "Error al registrar la planta."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Aceptar"),
                      ),
                    ],
                  ),
                );
              }
            } catch (e) {
              await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("❌ Error de conexión"),
                  content: Text("Ocurrió un error: $e"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Aceptar"),
                    ),
                  ],
                ),
              );
            }
          },
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
