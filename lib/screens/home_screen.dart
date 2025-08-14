import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/woocommerce_api.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  final api = WooApi();
  List<WCCategory> cats = [];
  List<Product> popular = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final c = await api.categories();
      final catsParsed = c.map((e) => WCCategory.fromJson(e)).toList().cast<WCCategory>();
      final p = await api.products(perPage: 12);
      final popParsed = p.map((e) => Product.fromJson(e)).toList().cast<Product>();
      setState(() { cats = catsParsed; popular = popParsed; loading = false; });
    } catch (e) {
      setState(() { loading = false; });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Load error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groviq'),
        actions: [
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_cart), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
            }),
            if (cart.count() > 0)
              Positioned(right: 6, top: 6, child: CircleAvatar(radius: 9, child: Text('${cart.count()}', style: const TextStyle(fontSize: 11))))
          ])
        ],
      ),
      body: loading ? const Center(child: CircularProgressIndicator()) :
      RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.all(12), child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: cats.length,
                  itemBuilder: (_, i) {
                    final c = cats[i];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListScreen(categoryId: c.id, categoryName: c.name)));
                      },
                      child: Column(children: [
                        Container(
                          width: 70, height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: c.image != null ? DecorationImage(image: NetworkImage(c.image!), fit: BoxFit.cover) : null,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(width: 80, child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis))
                      ]),
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.all(12), child: Text('Popular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: .72),
                itemCount: popular.length,
                itemBuilder: (_, i) {
                  final p = popular[i];
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              child: ElevatedButton(onPressed: (){
                                context.read<CartProvider>().add(p);
                              }, child: const Text('Add')),
                            )
                          ]),
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
