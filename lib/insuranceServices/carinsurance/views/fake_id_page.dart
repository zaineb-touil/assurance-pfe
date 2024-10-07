import 'package:flutter/material.dart';

class FakeIdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Payment Information'),
      ),
      body: Center(
        child: Text(
          'Please visit our agency to complete your payment in cash.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
