import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/woocommerce_api.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_list_screen.dart'; // safe self-import for route typing

class ProductListScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;
  const ProductListScreen({super.key, this.categoryId, this.categoryName});

  @override State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final api = WooApi();
  List<Product> items = [];
  int page = 1;
  bool loading = true;
  bool more = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load([bool next=false]) async {
    if (next && !more) return;
    setState(() { loading = true; });
    final res = await api.products(perPage: 20, page: page, category: widget.categoryId?.toString());
    final mapped = res.map((e) => Product.fromJson(e)).toList().cast<Product>();
    setState(() {
      if (next) { items.addAll(mapped); } else { items = mapped; }
      loading = false; more = mapped.isNotEmpty; if (mapped.isNotEmpty) page += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName ?? 'Products')),
      body: loading && items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.pixels >= n.metrics.maxScrollExtent - 200 && !loading) {
                _load(true);
              }
              return false;
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: .72),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                return Card(
                  child: Column(
                    children: [
                      Expanded(child: p.image!=null ? Image.network(p.image!, fit: BoxFit.cover, width: double.infinity) : const SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('₹${p.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => context.read<CartProvider>().add(p),
                              child: const Text('Add'),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }
}
