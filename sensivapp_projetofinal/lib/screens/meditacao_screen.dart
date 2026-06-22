import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';
import 'home/components/custom_bottom_nav.dart';
import 'meditacao_player_screen.dart';
import '../services/api_service.dart';

class MeditacaoScreen extends StatefulWidget {
  const MeditacaoScreen({super.key});

  @override
  State<MeditacaoScreen> createState() => _MeditacaoScreenState();
}

class _MeditacaoScreenState extends State<MeditacaoScreen> {
  int _currentIndex = 4;
  List<dynamic> _meditacoes = [];
  Set<int> _favoritosIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final meditacoes = await ApiService().get('/meditacoes');
      final favoritos = await ApiService().get('/meditacoes/favoritos');

      setState(() {
        _meditacoes = meditacoes;
        _favoritosIds = Set<int>.from(favoritos.map((f) => f['id_meditacao']));
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint("Erro ao carregar meditações: $e");
    }
  }

  Future<void> _toggleFavorito(int idMeditacao, bool ehFavorito) async {
    try {
      if (ehFavorito) {
        await ApiService().post('/meditacoes/$idMeditacao/desfavoritar', {});
        setState(() => _favoritosIds.remove(idMeditacao));
      } else {
        await ApiService().post('/meditacoes/$idMeditacao/favoritar', {});
        setState(() => _favoritosIds.add(idMeditacao));
      }
    } catch (e) {
      debugPrint("Erro ao atualizar favorito: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFEDF8FA);
    final navContentColor = isDark ? Colors.white : const Color(0xFF2E5B66);
    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF4FAFB);
    final indicatorColor = const Color(0xFF74C2DB);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 24,
        title: Text("SensivApp",
            style: TextStyle(
                color: navContentColor,
                fontSize: 20,
                fontWeight: FontWeight.w400)),
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
          : Column(
              children: [
                const SizedBox(height: 24),
                Text("Meditações Guiadas",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color:
                            isDark ? Colors.white : const Color(0xFF2E5B66))),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: _meditacoes.length,
                    itemBuilder: (context, index) {
                      final sessao = _meditacoes[index];
                      final id = sessao['id_meditacao'];
                      final isFav = _favoritosIds.contains(id);
                      final minutos = (sessao["duracao_segundos"] ?? 0) ~/ 60;

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MeditacaoPlayerScreen(
                                    title: sessao["titulo"],
                                    durationMinutes: minutos,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 40.0, left: 20, right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color:
                                                indicatorColor.withOpacity(0.2),
                                            width: 6)),
                                    child: Center(
                                        child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                                color: navContentColor,
                                                shape: BoxShape.circle))),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(sessao["titulo"],
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? Colors.white
                                              : const Color(0xFF2E5B66))),
                                  const SizedBox(height: 6),
                                  Text("$minutos minutos",
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.grey
                                              : Colors.grey.shade600)),
                                  const SizedBox(height: 10),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Text(sessao["descricao"] ?? "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300,
                                              color: isDark
                                                  ? Colors.grey.shade400
                                                  : const Color(0xFF5A7D87)))),
                                  const SizedBox(height: 24),
                                  Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                          color: indicatorColor,
                                          shape: BoxShape.circle),
                                      child: const Icon(Icons.play_arrow,
                                          color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 30),
                              child: IconButton(
                                icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav
                                        ? Colors.redAccent
                                        : Colors.grey.shade400,
                                    size: 28),
                                onPressed: () => _toggleFavorito(id, isFav),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          if (index == 4) return;
          setState(() => _currentIndex = index);
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
  }
}
