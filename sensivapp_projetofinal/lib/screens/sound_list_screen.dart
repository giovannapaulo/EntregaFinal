import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';
import 'sound_player_screen.dart';
import '../services/api_service.dart';

class SoundListScreen extends StatefulWidget {
  const SoundListScreen({super.key});

  @override
  State<SoundListScreen> createState() => _SoundListScreenState();
}

class _SoundListScreenState extends State<SoundListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<dynamic>> _sonsFuture;
  List<dynamic> _allSons = [];
  List<dynamic> _filteredSons = [];

  final List<Color> _pastelColors = [
    const Color(0xFFFFE5E5),
    const Color(0xFFE5F9FF),
    const Color(0xFFF0FFE5),
    const Color(0xFFFFF9E5),
    const Color(0xFFF3E5FF),
    const Color(0xFFE5FFF7),
  ];

  @override
  void initState() {
    super.initState();
    _sonsFuture = _fetchSons();
  }

  Future<List<dynamic>> _fetchSons() async {
    final data = await ApiService().get('/sons');
    setState(() {
      _allSons = data;
      _filteredSons = data;
    });
    return data;
  }

  void _filterSounds(String query) {
    setState(() {
      _filteredSons = _allSons
          .where((s) =>
              s['nome'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFEFE4FF);
    final textColor = isDark ? Colors.white : const Color(0xFF4A4261);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Sons Relaxantes",
            style: TextStyle(
                color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Padding(
              padding: EdgeInsets.only(right: 8.0), child: ThemeToggleButton())
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _sonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text("Erro ao carregar"));

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterSounds,
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: "O que quer ouvir?",
                    hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF7553F6)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: _filteredSons.isEmpty
                    ? Center(
                        child: Text("Nenhum som encontrado",
                            style: TextStyle(color: textColor)))
                    : GridView.builder(
                        padding: const EdgeInsets.all(18),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: _filteredSons.length,
                        itemBuilder: (context, index) {
                          final sound = _filteredSons[index];
                          final color =
                              _pastelColors[index % _pastelColors.length];
                          return _buildSoundCard(
                              context, sound, color, textColor, isDark);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSoundCard(BuildContext context, dynamic sound, Color color,
      Color textColor, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SoundPlayerScreen(title: sound['nome'], imageUrl: ""),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: isDark ? color.withOpacity(0.2) : color,
                  shape: BoxShape.circle),
              child: Icon(Icons.music_note,
                  size: 35,
                  color: isDark
                      ? color
                      : const Color(0xFF7553F6).withOpacity(0.8)),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(sound['nome'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }
}
