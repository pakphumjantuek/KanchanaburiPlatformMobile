import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('รายการสินค้า')),
      body: const Center(child: Text('หน้ารายการสินค้า')),
    );
  }
}
