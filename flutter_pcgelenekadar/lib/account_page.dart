import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pcgelenekadar/cart_cubit.dart';
import 'package:flutter_pcgelenekadar/product_model.dart';


class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('account').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 20),
            Text(
              'username',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ).tr(),
            SizedBox(height: 10),
            Text(
              'kullanici@mail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),
            BlocBuilder<CartCubit, List<Product>>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Darktheme').tr(),
                    Switch(
                      value: BlocProvider.of<CartCubit>(context).isDarkTheme,
                      onChanged: (newValue) {
                        BlocProvider.of<CartCubit>(context).toggleTheme();
                      },
                    ),
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Hesap bilgilerini düzenleme ekranına yönlendirme işlemi eklenebilir
              },
              child: Text('editAccountInfo').tr(),
            ),
            ElevatedButton(
              onPressed: () {
                // Çıkış yapma işlemi eklenebilir
              },
              child: Text('logOut').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
