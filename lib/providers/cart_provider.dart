import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
  double get total => double.tryParse(product.price) != null ? qty * double.parse(product.price) : 0.0;
}

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};
  Map<int, CartItem> get items => _items;

  void add(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.qty += 1;
    } else {
      _items[p.id] = CartItem(product: p, qty: 1);
    }
    notifyListeners();
  }

  void dec(int id) {
    if (!_items.containsKey(id)) return;
    _items[id]!.qty -= 1;
    if (_items[id]!.qty <= 0) _items.remove(id);
    notifyListeners();
  }

  void remove(int id) { _items.remove(id); notifyListeners(); }

  int count() => _items.values.fold(0, (s, it) => s + it.qty);
  double subtotal() => _items.values.fold(0.0, (s, it) => s + it.total);
  List<Map<String, dynamic>> toOrderLineItems() =>
      _items.values.map((it) => {'product_id': it.product.id, 'quantity': it.qty}).toList();

  void clear() { _items.clear(); notifyListeners(); }
}
