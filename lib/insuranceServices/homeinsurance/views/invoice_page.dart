import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: Center(
        child: Text(
          'This is a sample invoice.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
