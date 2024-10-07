import 'package:flutter/material.dart';
import '../controllers/home_insurance_controller.dart';
import 'invoice_page.dart';
import 'payment_page.dart';

class SummaryStepView extends StatelessWidget {
  final HomeInsuranceController controller;

  SummaryStepView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        margin: const EdgeInsets.all(10.0),
        width: 300.0, // Increase width for more content space
        padding: const EdgeInsets.all(16.0), // Add padding for inner content
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Summary: Review Your Data',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${controller.nameController.text}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Age: ${controller.ageController.text}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Selected Option: ${controller.selectedOption}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'QCM Step 1: ${controller.formData['qcmStep1']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'QCM Step 2: ${controller.formData['qcmStep2']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Birth Date: ${controller.birthDateController.text}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showPaymentDialog(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.orange,
                backgroundColor: Colors.white, // Text color
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Text("Would you like to pay now or receive an invoice?"),
          actions: [
            TextButton(
              child: Text("Invoice"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
            ),
            TextButton(
              child: Text("Pay"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymentPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
