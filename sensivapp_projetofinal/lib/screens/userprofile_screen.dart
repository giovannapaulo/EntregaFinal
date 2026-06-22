import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../core/app_theme.dart';
import 'favorites_list_screen.dart';
import '../../services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic>? _contatoEmergencia;
  List<dynamic> _tarefas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    try {
      final contatos = await ApiService().get('/contatos-emergencia');
      final sessoes = await ApiService().get('/sessoes-diario');

      setState(() {
        _contatoEmergencia =
            (contatos as List).isNotEmpty ? contatos.first : null;
        _tarefas = sessoes;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _salvarEmergencia(String nome, String telefone) async {
    try {
      if (_contatoEmergencia == null) {
        await ApiService()
            .post('/contatos-emergencia', {'nome': nome, 'telefone': telefone});
      } else {
        await ApiService().put(
            '/contatos-emergencia/${_contatoEmergencia!['id_contato']}',
            {'nome': nome, 'telefone': telefone});
      }
      _carregarDadosIniciais();
    } catch (e) {
      debugPrint("Erro ao salvar: $e");
    }
  }

  final List<Map<String, dynamic>> _sensibilidades = [
    {'name': 'Luz Forte', 'selected': false},
    {'name': 'Sons Agudos', 'selected': true},
    {'name': 'Multidões', 'selected': false},
    {'name': 'Perfumes', 'selected': true},
    {'name': 'Texturas', 'selected': false},
    {'name': 'Temperaturas', 'selected': true},
    {'name': 'Movimentos Repetitivos', 'selected': false},
  ];

  final List<Map<String, dynamic>> _profissionais = [
    {'name': 'Dr. Silva', 'score': 4.8, 'img': Icons.person},
    {'name': 'Dra. Ana', 'score': 4.9, 'img': Icons.person_3},
    {'name': 'Dr. Marcos', 'score': 4.7, 'img': Icons.person_outline},
    {'name': 'Dra. Julia', 'score': 5.0, 'img': Icons.face},
    {'name': 'Dr. Roberto', 'score': 4.6, 'img': Icons.account_circle},
  ];

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) setState(() => _imageFile = pickedFile);
  }

  void _showSensibilidadesDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("Minhas Sensibilidades"),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _sensibilidades.length,
              itemBuilder: (context, index) => CheckboxListTile(
                title: Text(_sensibilidades[index]['name']),
                value: _sensibilidades[index]['selected'],
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (val) => setDialogState(
                    () => _sensibilidades[index]['selected'] = val),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Salvar"))
          ],
        );
      }),
    );
  }

  void _showProfissionaisDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Profissionais Recomendados"),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _profissionais.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(child: Icon(_profissionais[index]['img'])),
              title: Text(_profissionais[index]['name']),
              trailing: Text("★ ${_profissionais[index]['score']}"),
            ),
          ),
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    final nameController =
        TextEditingController(text: _contatoEmergencia?['nome'] ?? "");
    final phoneController =
        TextEditingController(text: _contatoEmergencia?['telefone'] ?? "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contato de Emergência"),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nome")),
          TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Telefone"),
              keyboardType: TextInputType.phone),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              _salvarEmergencia(nameController.text, phoneController.text);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;
    final backgroundColor =
        isDark ? const Color(0xFF000000) : const Color(0xFFEFE4FF);
    final textColor = isDark ? Colors.white : const Color(0xFF4A4261);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("SensivApp",
            style:
                TextStyle(color: navContentColor, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {}),
          const ThemeToggleButton()
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (ctx) => Wrap(children: [
                                ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Câmera"),
                                    onTap: () {
                                      _pickImage(ImageSource.camera);
                                      Navigator.pop(ctx);
                                    }),
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Galeria"),
                                    onTap: () {
                                      _pickImage(ImageSource.gallery);
                                      Navigator.pop(ctx);
                                    }),
                              ])),
                      child: CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFAEE6EA),
                          backgroundImage: _imageFile != null
                              ? (kIsWeb
                                      ? NetworkImage(_imageFile!.path)
                                      : FileImage(io.File(_imageFile!.path)))
                                  as ImageProvider
                              : null,
                          child: _imageFile == null
                              ? const Icon(Icons.person,
                                  size: 50, color: Colors.white)
                              : null),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(children: [
                    Expanded(
                        child: HoverCard(
                            child: _gridContent(Icons.favorite, "Meus Sons",
                                textColor, cardColor),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FavoritesListScreen(
                                            category: 'sons'))))),
                    const SizedBox(width: 15),
                    Expanded(
                        child: HoverCard(
                            child: _gridContent(Icons.spa,
                                "Minhas\nSensibilidades", textColor, cardColor),
                            onTap: _showSensibilidadesDialog)),
                  ]),
                  const SizedBox(height: 15),
                  Row(children: [
                    Expanded(
                        child: HoverCard(
                            child: _gridContent(Icons.medical_services,
                                "Profissional", textColor, cardColor),
                            onTap: _showProfissionaisDialog)),
                    const SizedBox(width: 15),
                    Expanded(
                        child: HoverCard(
                            child: _gridContent(Icons.article, "Meus Artigos",
                                textColor, cardColor),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FavoritesListScreen(
                                            category: 'artigos'))))),
                  ]),
                  const SizedBox(height: 30),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Tarefas Diárias (Lição de Casa)",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor))),
                  const SizedBox(height: 10),
                  _tarefas.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Nenhuma tarefa pendente.",
                              style:
                                  TextStyle(color: textColor.withOpacity(0.6))))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _tarefas.length,
                          itemBuilder: (context, i) => Card(
                              color: cardColor,
                              child: ListTile(
                                  title: Text(_tarefas[i]['licao_de_casa'] ??
                                      'Sem descrição'))),
                        ),
                  const SizedBox(height: 40),
                  HoverCard(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoritesListScreen(
                                category: 'meditacao'))),
                    child: _specialActionCard(
                        Icons.self_improvement,
                        "Meditação",
                        isDark
                            ? const Color(0xFF2D3B36)
                            : const Color(0xFFE0F2F1),
                        isDark
                            ? const Color(0xFF80CBC4)
                            : const Color(0xFF00796B)),
                  ),
                  const SizedBox(height: 12),
                  HoverCard(
                    onTap: _showEmergencyDialog,
                    child: _specialActionCard(
                        Icons.emergency_outlined,
                        _contatoEmergencia?['nome'] ?? "Emergência",
                        isDark
                            ? const Color(0xFF422222)
                            : const Color(0xFFFFE0E0),
                        const Color(0xFFE53935)),
                  ),
                  if (_contatoEmergencia != null) ...[
                    const SizedBox(height: 12),
                    HoverCard(
                        onTap: () => launchUrl(Uri(
                            scheme: 'tel',
                            path: _contatoEmergencia!['telefone'])),
                        child: _specialActionCard(
                            Icons.phone,
                            "Ligar para Emergência",
                            isDark
                                ? const Color(0xFF2D2A4A)
                                : const Color(0xFFEFE4FF),
                            isDark
                                ? const Color(0xFFB39DDB)
                                : const Color(0xFF7553F6))),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  Widget _specialActionCard(
      IconData icon, String title, Color bgColor, Color contentColor) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(32)),
        child: Row(children: [
          Icon(icon, color: contentColor, size: 26),
          const SizedBox(width: 15),
          Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                      fontSize: 16))),
          Icon(Icons.arrow_forward_ios_rounded,
              color: contentColor.withOpacity(0.5), size: 16)
        ]));
  }

  Widget _gridContent(IconData icon, String title, Color tColor, Color bColor) {
    return Container(
        height: 100,
        decoration: BoxDecoration(
            color: bColor, borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 26, color: const Color(0xFF7553F6)),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: tColor, fontWeight: FontWeight.bold))
        ]));
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const HoverCard({super.key, required this.child, this.onTap});
  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: isHovered
                    ? (Matrix4.identity()..translate(0, -4, 0))
                    : Matrix4.identity(),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(32)),
                child: widget.child)));
  }
}
