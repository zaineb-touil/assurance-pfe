import 'package:flutter/material.dart';

class StripePaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment'),
      ),
      body: Center(
        child: Text(
          'Stripe payment integration goes here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
