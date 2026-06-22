import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/app_theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';
import 'home/components/custom_bottom_nav.dart';
import '../services/api_service.dart';

class MapaConfortoScreen extends StatefulWidget {
  const MapaConfortoScreen({super.key});

  @override
  State<MapaConfortoScreen> createState() => _MapaConfortoScreenState();
}

class _MapaConfortoScreenState extends State<MapaConfortoScreen> {
  final MapController _mapController = MapController();
  int _currentIndex = 4;
  String _mapLabel = "Mapa de Conforto - Selecione um local";
  LatLng? _localTemporario;
  List<Map<String, dynamic>> pontosConforto = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarLocais();
  }

  Future<void> _carregarLocais() async {
    try {
      final data = await ApiService().get('/locais');
      setState(() {
        pontosConforto = (data as List).map((item) {
          return {
            "id": item['id_local'].toString(),
            "title": item['nome_local'] ?? "Sem título",
            "subtitle": item['anotacoes'] ?? "",
            "coordenadas": LatLng(
                double.tryParse(item['latitude'].toString()) ?? 0.0,
                double.tryParse(item['longitude'].toString()) ?? 0.0),
            "tags":
                (item['Tags'] as List?)?.map((t) => t['nome_tag']).toList() ??
                    [],
          };
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Erro ao carregar: $e");
    }
  }

  Future<void> _salvarNoBanco(Map<String, dynamic> dados, {int? id}) async {
    try {
      if (id == null) {
        await ApiService().post('/locais', dados);
      } else {
        await ApiService().put('/locais/$id', dados);
      }
      _carregarLocais();
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

  Future<void> _deletarNoBanco(int id) async {
    try {
      await ApiService().delete('/locais/$id');
      _carregarLocais();
    } catch (e) {
      debugPrint("Erro ao deletar: $e");
    }
  }

  Future<void> _buscarEndereco(String query) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          setState(() {
            _localTemporario = LatLng(lat, lon);
            _mapController.move(_localTemporario!, 16.0);
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao buscar: $e");
    }
  }

  void _centralizarMapa(Map<String, dynamic> ponto) {
    _mapController.move(ponto["coordenadas"], 16.0);
    setState(() => _mapLabel = ponto["title"]);
  }

  void _abrirDialogoPonto({Map<String, dynamic>? pontoExistente}) {
    final titleController =
        TextEditingController(text: pontoExistente?["title"] ?? "");
    final descController =
        TextEditingController(text: pontoExistente?["subtitle"] ?? "");
    final searchController = TextEditingController();
    final tagsController = TextEditingController(
        text: pontoExistente != null
            ? (pontoExistente["tags"] as List).join(", ")
            : "");

    _localTemporario = pontoExistente?["coordenadas"];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title:
              Text(pontoExistente == null ? "Adicionar Local" : "Editar Local"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Nome")),
                TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Notas")),
                TextField(
                    controller: tagsController,
                    decoration: const InputDecoration(
                        labelText: "Tags (separadas por vírgula)")),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                labelText: "Buscar Endereço"))),
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          await _buscarEndereco(searchController.text);
                          setDialogState(() {});
                        }),
                  ],
                ),
                Text(
                    _localTemporario == null
                        ? "Toque no mapa ou busque acima"
                        : "Local marcado!",
                    style: TextStyle(
                        color: _localTemporario == null
                            ? Colors.red
                            : Colors.green,
                        fontSize: 12)),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar")),
            ElevatedButton(
              onPressed: _localTemporario == null
                  ? null
                  : () {
                      final tags = tagsController.text
                          .split(',')
                          .map((t) => t.trim())
                          .where((t) => t.isNotEmpty)
                          .toList();

                      final payload = {
                        "nome_local": titleController.text,
                        "anotacoes": descController.text,
                        "latitude": 0.0,
                        "longitude": 0.0,
                        "tipo_local": "geral",
                        "tags": tags,
                      };

                      _salvarNoBanco(payload,
                          id: pontoExistente != null
                              ? int.parse(pontoExistente["id"])
                              : null);
                      Navigator.pop(context);
                    },
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final corFundoApp = isDark ? const Color(0xFF121212) : Colors.white;
    final corCardAzul =
        isDark ? const Color(0xFF2D2D3D) : const Color(0xFFE0F2FE);
    final corTexto = isDark ? Colors.white : const Color(0xFF3F3D56);
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      backgroundColor: corFundoApp,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: Text("SensivApp",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: navContentColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400) ??
                const TextStyle(color: Colors.white)),
        actions: [
          const ThemeToggleButton(),
          IconButton(
              icon: Icon(Icons.person, color: navContentColor),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const UserProfileScreen()))),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 10),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Você está em: Atibaia, SP",
                            style:
                                TextStyle(fontSize: 12, color: Colors.grey)))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text("Mapa de Conforto",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: corTexto))),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(-23.119, -46.554),
                            initialZoom: 14,
                            onTap: (tapPosition, point) =>
                                setState(() => _localTemporario = point),
                          ),
                          children: [
                            TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'),
                            MarkerLayer(markers: [
                              ...pontosConforto.map((p) => Marker(
                                    point: p["coordenadas"],
                                    child: GestureDetector(
                                      onTap: () => _centralizarMapa(p),
                                      child: const Icon(Icons.location_on,
                                          color: Colors.red, size: 35),
                                    ),
                                  )),
                              if (_localTemporario != null)
                                Marker(
                                    point: _localTemporario!,
                                    child: const Icon(Icons.add_location,
                                        color: Colors.blue, size: 40))
                            ]),
                          ],
                        ),
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Column(children: [
                            FloatingActionButton.small(
                                onPressed: () => _mapController.move(
                                    _mapController.camera.center,
                                    _mapController.camera.zoom + 1),
                                child: const Icon(Icons.add)),
                            const SizedBox(height: 5),
                            FloatingActionButton.small(
                                onPressed: () => _mapController.move(
                                    _mapController.camera.center,
                                    _mapController.camera.zoom - 1),
                                child: const Icon(Icons.remove)),
                          ]),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(_mapLabel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pontosConforto.length,
                    itemBuilder: (context, index) {
                      final p = pontosConforto[index];
                      return GestureDetector(
                        onTap: () => _centralizarMapa(p),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: corCardAzul,
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                    child: Text(p["title"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: corTexto))),
                                IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () =>
                                        _abrirDialogoPonto(pontoExistente: p)),
                                IconButton(
                                    icon: const Icon(Icons.delete,
                                        size: 18, color: Colors.red),
                                    onPressed: () =>
                                        _deletarNoBanco(int.parse(p['id']))),
                              ]),
                              Text(p["subtitle"],
                                  style:
                                      TextStyle(fontSize: 13, color: corTexto)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: (p["tags"] as List)
                                    .map((t) => Chip(
                                        label: Text(t,
                                            style:
                                                const TextStyle(fontSize: 10)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB39DDB),
        onPressed: () {
          _localTemporario = null;
          _abrirDialogoPonto();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
