import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String pizzaId;

  const ProductDetailsScreen({super.key, required this.pizzaId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: const Center(child: Text('Product Details Screen')),
    );
  }
}
