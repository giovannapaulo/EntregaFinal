class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final Map<String, List<String>> _favorites = {
    'sons': [],
    'artigos': [],
    'meditacao': [],
  };

  List<String> getAllFavorites(String category) {
    return _favorites[category] ?? [];
  }

  bool isFavorited(String category, String title) {
    return _favorites[category]?.contains(title) ?? false;
  }

  void toggleFavorite(String category, String title) {
    if (_favorites[category] == null) {
      _favorites[category] = [];
    }

    if (_favorites[category]!.contains(title)) {
      _favorites[category]!.remove(title);
    } else {
      _favorites[category]!.add(title);
    }
  }
}

final FavoriteService favoriteService = FavoriteService();
