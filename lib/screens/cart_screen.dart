import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(children: [
              Expanded(
                child: ListView(
                  children: cart.items.values.map((it) => ListTile(
                    leading: it.product.image!=null ? Image.network(it.product.image!, width: 56, height: 56, fit: BoxFit.cover) : null,
                    title: Text(it.product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text('₹${it.product.price} x ${it.qty} = ₹${it.total.toStringAsFixed(2)}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: ()=> cart.dec(it.product.id)),
                      Text('${it.qty}'),
                      IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: ()=> cart.add(it.product)),
                    ]),
                  )).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text('Subtotal: ₹${cart.subtotal().toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                    child: const Text('Checkout'),
                  ),
                ]),
              )
            ]),
    );
  }
}
