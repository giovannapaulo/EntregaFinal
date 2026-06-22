import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../screens/userprofile_screen.dart';
import 'artigo_detalhe_screen.dart';
import '../services/api_service.dart';

class ArtigosScreen extends StatefulWidget {
  const ArtigosScreen({super.key});

  @override
  State<ArtigosScreen> createState() => _ArtigosScreenState();
}

class _ArtigosScreenState extends State<ArtigosScreen> {
  List<dynamic> _artigos = [];
  Set<int> _favoritosIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final artigos = await ApiService().get('/artigos');
      final favoritos = await ApiService().get('/artigos/favoritos');

      setState(() {
        _artigos = artigos;
        _favoritosIds = Set<int>.from(favoritos.map((f) => f['id']));
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleFavorito(int idArtigo, bool ehFavorito) async {
    try {
      if (ehFavorito) {
        await ApiService().post('/artigos/$idArtigo/desfavoritar', {});
        setState(() => _favoritosIds.remove(idArtigo));
      } else {
        await ApiService().post('/artigos/$idArtigo/favoritar', {});
        setState(() => _favoritosIds.add(idArtigo));
      }
    } catch (e) {
      debugPrint("Erro ao favoritar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navColor = isDark ? const Color(0xFF7553F6) : AppTheme.pastelPurple;
    final navContentColor = isDark ? Colors.white : AppTheme.textPurpleDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: navColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: navContentColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("SensivApp",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: navContentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Artigos Recentes",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: isDark ? Colors.white : const Color(0xFF333333),
                      )),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _artigos.length,
                    itemBuilder: (context, index) {
                      final artigo = _artigos[index];
                      final id = artigo['id'];
                      final isFav = _favoritosIds.contains(id);

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ArtigoDetalheScreen(artigo: artigo)));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E1E1E)
                                    : const Color(0xFFFAFAFC),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                    child: Image.network(
                                        artigo['imageUrl'] ??
                                            'https://via.placeholder.com/500',
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(artigo['titulo'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF2D3142))),
                                        const SizedBox(height: 8),
                                        Text(
                                            artigo['fonte'] ??
                                                'Fonte desconhecida',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade500)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isFav ? Colors.redAccent : Colors.white,
                                  size: 28),
                              onPressed: () => _toggleFavorito(id, isFav),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
