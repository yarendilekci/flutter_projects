// products_page.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pcgelenekadar/cart_cubit.dart';
import 'package:flutter_pcgelenekadar/cart_screen.dart';
import 'package:flutter_pcgelenekadar/language_cubit.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';
import 'package:flutter_pcgelenekadar/favorites_repository.dart';
import 'package:flutter_pcgelenekadar/favorites_page.dart'; // Import FavoritesPage
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ProductsPage extends StatefulWidget {
  final List<Product> products;
  BuildContext contextintl;

   ProductsPage({Key? key, required this.products,required this.contextintl}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  @override
void initState() {
  super.initState();
}

String Getlocale(Locale language){
  if(language == Locale('tr','TR'))
  {
    return "tr";
  }else{
    return "en";
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('productTitle').tr(),
        //title: Text(AppLocalizations.of(widget.contextintl)!.productTitle),
        actions: [
          DropdownButton<String>(
                  value: Getlocale(context.locale), // Dropdown'da seçili olan dil
                  onChanged: (String? newValue) async{
                    Locale newLocale = Locale('tr','TR');
                    if(newValue == "tr")
                    {
                      newLocale =Locale('tr','TR');
                    }else{
                      newLocale =Locale('en','US');
                    }
                  context.setLocale(newLocale);
                  print(context.locale.toString());

                  },
                  items: <String>['en', 'tr']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(allProducts: widget.products), // Pass all products
                ),
              );
            },
          ),
                    IconButton(
            icon: Icon(Icons.shopping_basket_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(), // Pass all products
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(widget.products.length, (index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Image.network(
                    widget.products[index].image,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.products[index].title,
                    style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '\$${widget.products[index].price}',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
                SizedBox(height: 3,),
                GestureDetector(
                  onTap: (){
                    BlocProvider.of<CartCubit>(context).addToCart(widget.products[index]);
                    // Sepete eklendi uyarısı göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ürün sepete eklendi.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(width: 2)
                    ),
                    child: Text('addBox').tr(),
                  ),
                ),
                FutureBuilder<bool>(
                  future: FavoritesRepository().isFavorite(widget.products[index].id),
                  builder: (context, snapshot) {
                    return BlocBuilder <CartCubit, List<Product>>(
                      builder: (context, state)  {
                        return IconButton(
                          icon: Icon(
                              snapshot.data ?? false
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () async{
                            await FavoritesRepository().toggleFavorite(widget.products[index].id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  await FavoritesRepository().isFavorite(widget.products[index].id)
                                      ? 'Ürün favorilere eklendi.'
                                      : 'Ürün favorilerden kaldırıldı.',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            setState(() {
                              
                            });
                          },
                        );
                      }
                    );
                  }
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
