import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/woocommerce_api.dart';
import '../providers/cart_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _postcode = TextEditingController();

  bool loading = false;
  final api = WooApi();

  @override
  void dispose() {
    _name.dispose(); _phone.dispose(); _email.dispose(); _address.dispose(); _city.dispose(); _postcode.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_form.currentState!.validate()) return;
    final cart = context.read<CartProvider>();
    setState(() => loading = true);
    try {
      final billing = {
        'first_name': _name.text.trim(),
        'last_name': '',
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'address_1': _address.text.trim(),
        'city': _city.text.trim(),
        'postcode': _postcode.text.trim(),
        'country': 'IN'
      };
      final shipping = Map<String, dynamic>.from(billing);
      final order = await api.createOrder(
        lineItems: cart.toOrderLineItems(),
        billing: billing,
        shipping: shipping,
        cod: true,
      );
      cart.clear();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => OrderSuccessScreen(orderId: order['id'].toString()),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              Text('Total: ₹${cart.subtotal().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Name'),
                validator: (v)=> v==null||v.trim().isEmpty ? 'Enter name' : null),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (v)=> v==null||v.trim().length<10 ? 'Enter valid phone' : null),
              TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), keyboardType: TextInputType.emailAddress),
              TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address'),
                validator: (v)=> v==null||v.trim().isEmpty ? 'Enter address' : null),
              TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'),
                validator: (v)=> v==null||v.trim().isEmpty ? 'Enter city' : null),
              TextFormField(controller: _postcode, decoration: const InputDecoration(labelText: 'Pincode'),
                keyboardType: TextInputType.number,
                validator: (v)=> v==null||v.trim().length<4 ? 'Enter pincode' : null),
              const SizedBox(height: 20),
              loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(onPressed: _placeOrder, child: const Text('Place Order (COD)')),
            ],
          ),
        ),
      ),
    );
  }
}
