import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';
import '../widgets/symptom_card.dart';
import '../widgets/add_symptom_bottom_sheet.dart';
import '../services/api_service.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  State<DiarioScreen> createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  List<Map<String, dynamic>> entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  Future<void> _carregarRegistros() async {
    try {
      final data = await ApiService().get('/sintomas');
      setState(() {
        entries = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Erro ao carregar registros: $e");
    }
  }

  void _addEntry(Map<String, dynamic> dados) async {
    try {
      await ApiService().post('/sintomas', dados);
      _carregarRegistros();
    } catch (e) {
      debugPrint("Erro ao criar: $e");
    }
  }

  void _deletarEntry(int id, int index) async {
    try {
      await ApiService().delete('/sintomas/$id');
      setState(() => entries.removeAt(index));
    } catch (e) {
      debugPrint("Erro ao deletar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: navColor,
        title: Text("SensivApp", style: TextStyle(color: navContentColor)),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            icon: Icon(Icons.person, color: navContentColor),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        builder: (_) =>
                            AddSymptomBottomSheet(onSave: _addEntry),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                              colors: [Color(0xFFD7E3FF), Color(0xFFFFD1E8)])),
                      child: const Text("+ Nova Entrada",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: entries.isEmpty
                        ? const Center(
                            child: Text("Nenhum registro adicionado ainda."))
                        : ListView.builder(
                            itemCount: entries.length,
                            itemBuilder: (_, index) {
                              final entry = entries[index];
                              return SymptomCard(
                                entry: entry,
                                onTap: () => _showOptionsDialog(
                                    context, entry, index, isDark),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showOptionsDialog(BuildContext context, Map<String, dynamic> entry,
      int index, bool isDark) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: isDark ? const Color(0xFF242424) : Colors.white,
              borderRadius: BorderRadius.circular(28)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                entry['nome_sintoma'] ?? 'Sem título',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.textPurpleDark),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_rounded),
                      label: const Text("Editar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete_outline_rounded),
                      label: const Text("Excluir"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
                      onPressed: () {
                        _deletarEntry(entry['id_registro'], index);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
