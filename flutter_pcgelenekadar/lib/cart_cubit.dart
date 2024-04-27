import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';

class CartCubit extends Cubit<List<Product>> {
 List<Product> _cartItems = []; // Sepetteki ürünlerin listesi
  int _cartItemCount = 0; // Sepetteki ürün sayısı
  bool _isDarkTheme = false; // Tema durumu

  CartCubit() : super([]);

  // Tema durumunu getir
  bool get isDarkTheme => _isDarkTheme;

  // Tema durumunu değiştir
  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    print(_isDarkTheme);
    emit(List.from(state)); // State'i güncelle
  }

  // Sepetteki ürün sayısını getir
  int get cartItemCount => _cartItemCount;

  // Ürünü sepete ekle
  void addToCart(Product product) {
    state.add(product);
    _cartItems.add(product); // Sepetteki ürünlere ekle
    _cartItemCount++; // Sepet ürün sayısını artır
    emitCartItemCount();
    emit(List.from(state)); // State'i güncelle
  }

  // Sepetten ürünü çıkar
  void removeFromCart(Product product) {
    state.remove(product);
    _cartItems.remove(product); // Sepetteki ürünleri çıkar
    _cartItemCount--; // Sepet ürün sayısını azalt
    emit(List.from(state)); // State'i güncelle
  }

  void emitCartItemCount() {
  emit(List.from(state));
}
}
