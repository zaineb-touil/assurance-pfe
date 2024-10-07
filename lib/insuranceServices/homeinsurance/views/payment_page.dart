import 'package:flutter/material.dart';
import 'package:insurance_pfe/insuranceServices/homeinsurance/views/cash_payment_page.dart';
import 'stripe_payment_page.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Cash Payment Info
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CashPaymentPage()),
                );
              },
              child: Text('Pay in Cash at the Agency'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Stripe Payment Page
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StripePaymentPage()),
                );
              },
              child: Text('Pay Online with Stripe'),
            ),
          ],
        ),
      ),
    );
  }
}
