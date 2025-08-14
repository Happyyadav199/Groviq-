import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Placed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_circle, size: 88),
            const SizedBox(height: 12),
            Text('Thank you!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Your order #$orderId has been placed.'),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: (){
              Navigator.popUntil(context, (route) => route.isFirst);
            }, child: const Text('Back to Home'))
          ]),
        ),
      ),
    );
  }
}
