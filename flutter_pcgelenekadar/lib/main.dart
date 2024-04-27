import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_pcgelenekadar/account_page.dart';
import 'package:flutter_pcgelenekadar/cart_cubit.dart';
import 'package:flutter_pcgelenekadar/favorites_page.dart';
import 'package:flutter_pcgelenekadar/language_cubit.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';
import 'package:flutter_pcgelenekadar/products_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

  Locale _locale = Locale('tr','TR');
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await EasyLocalization.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // Android için bildirim kanalını oluştur
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: null,
    macOS: null,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: Locale('en', 'US'),
      child: BlocProvider(
        create: (context) => CartCubit(), // CartCubit'i oluştur
        child: MyApp(),)
    ),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
        return   MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
        title: 'Gece ve Gündüz Modu',
        home: BlocProvider(
          create: (context) => CartCubit(), // CartCubit'i oluştur
          child: HomeScreen(),
        ),
      );   
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Başlangıçta varsayılan olarak açık tema kullanılır
  Brightness _currentBrightness = Brightness.light;
  int _selectedIndex = 0;
  List<Product> _products = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _products = data.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Widget _buildBody(int index, BuildContext context) {
    switch (index) {
      case 0:
        return ProductsPage(products: _products, contextintl: context);
      case 1:
        return FavoritesPage(allProducts: _products);
      case 2:
        return AccountPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, List<Product>>(builder: (context, cartItems) {
      return MaterialApp(
        theme: ThemeData(
          brightness: BlocProvider.of<CartCubit>(context).isDarkTheme
              ? Brightness.dark
              : Brightness.light,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'productBottomHeader'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'favoriBottomHeader'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'accountBottomHeader'.tr(),
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
            body: _buildBody(_selectedIndex, context)),
      );
    });
  }
}
