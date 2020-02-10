import 'package:flutter/material.dart';
import 'package:virtual_store/tabs/home_tab.dart';
import 'package:virtual_store/tabs/products_tab.dart';
import 'package:virtual_store/widgets/cart_button.dart';
import 'package:virtual_store/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          floatingActionButton: CartButton(),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Produtos',
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
          body: ProductsTab(),
        ),
        Container(
          color: Colors.blue,
        ),
        Container(
          color: Colors.green,
        ),
      ],
    );
  }
}
