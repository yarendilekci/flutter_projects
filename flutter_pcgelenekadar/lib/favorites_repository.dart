// favorites_repository.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';

class FavoritesRepository {
  static const _key = 'favoriteProducts';

  SharedPreferences? _preferences;

  Future<void> _initPrefs() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }
Future<void> toggleFavorite(int productId) async {
  await _initPrefs();
  final favorites = _preferences!.getStringList(_key) ?? [];
  if (favorites.contains(productId.toString())) {
    favorites.remove(productId.toString());
  } else {
    favorites.add(productId.toString());
  }
  await _preferences!.setStringList(_key, favorites);
}

  Future<bool> isFavorite(int productId)async {
      await _initPrefs();
    final favorites = _preferences!.getStringList(_key) ?? [];
    return favorites.contains(productId.toString());
  }

  Future<List<Product>> getFavoriteProducts(List<Product> allProducts) async{
    await _initPrefs();
    final favorites = _preferences!.getStringList(_key) ?? [];
    final favoriteProducts = allProducts.where((product) => favorites.contains(product.id.toString())).toList();
    return favoriteProducts;
  }
}
