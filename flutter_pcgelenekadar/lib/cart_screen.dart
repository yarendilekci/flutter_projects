import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';
import 'cart_cubit.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Siparişiniz alındı!',
      'Siparişiniz başarıyla alınmıştır.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sepetim"),
      ),
      body: BlocBuilder<CartCubit, List<Product>>(
        builder: (context, state) {
          // Eğer sepette ürün yoksa
          if (state.isEmpty) {
            return Center(
              child: Text('Sepetiniz boş.'),
            );
          }
          // Sepette ürün varsa
          double totalPrice = 0;
          for (Product product in state) {
            totalPrice += product.price;
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(state[index].image),
                      title: Text(state[index].title), // Ürün adı
                      subtitle:
                          Text('Fiyat: ${state[index].price}'), // Ürün fiyatı
                      trailing: IconButton(
                        icon: Icon(
                            Icons.remove_shopping_cart), // Ürünü sepetten çıkar
                        onPressed: () {
                          BlocProvider.of<CartCubit>(context)
                              .removeFromCart(state[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Toplam Fiyat: \$${totalPrice.toStringAsFixed(2)}', // Toplam fiyatı göster
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await _showNotification();
                        },
                        child: Text("Siparişi Tamamla"))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
