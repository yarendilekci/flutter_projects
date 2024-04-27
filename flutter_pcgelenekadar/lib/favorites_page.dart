// favorites_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';
import 'package:flutter_pcgelenekadar/favorites_repository.dart';

class FavoritesPage extends StatelessWidget {
  final List<Product> allProducts; // Tüm ürünler listesi

  const FavoritesPage({Key? key, required this.allProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('favoriBottomHeader').tr()
      ),
      body: FutureBuilder<List<Product>>(
        future: FavoritesRepository().getFavoriteProducts(allProducts),
        builder: (context, snapshot) {
          if(snapshot.hasData)
          {
final List<Product> favoriteProducts = snapshot.data!;
          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(
                  favoriteProducts[index].image,
                  width: 50,
                  height: 50,
                ),
                title: Text(favoriteProducts[index].title),
                subtitle: Text('\$${favoriteProducts[index].price}'),
              );
            },
          );
          }else{
            return Center(child: CircularProgressIndicator());
          }
       
        }
      ),
    );
  }
}
