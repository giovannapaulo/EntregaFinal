import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FavoritesListScreen extends StatefulWidget {
  final String category;
  const FavoritesListScreen({super.key, required this.category});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  late Future<List<dynamic>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final endpoint = '/favoritos/${widget.category}';
    _favoritesFuture =
        ApiService.instance.get(endpoint).then((data) => data as List<dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF121212) : const Color(0xFFF9F7FF);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF4A4261);
    final Color accentColor = _getCategoryColor();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Favoritos: ${widget.category}",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              (snapshot.data as List).isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 64, color: textColor.withOpacity(0.3)),
                  const SizedBox(height: 16),
                  Text("Nenhum item em ${widget.category} favoritado.",
                      style: TextStyle(color: textColor.withOpacity(0.6))),
                ],
              ),
            );
          }

          final favorites = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          shape: BoxShape.circle),
                      child: Icon(Icons.favorite, color: accentColor),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        item['nome'] ?? 'Item sem nome',
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 14, color: textColor.withOpacity(0.3)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getCategoryColor() {
    switch (widget.category) {
      case 'sons':
        return const Color(0xFF7553F6);
      case 'meditacao':
        return const Color(0xFF80CBC4);
      case 'artigos':
        return const Color(0xFFFFB0B0);
      default:
        return Colors.grey;
    }
  }
}
