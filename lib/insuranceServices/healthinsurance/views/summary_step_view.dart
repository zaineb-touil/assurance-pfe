import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/health_insurance_controller.dart';

class SummaryStepView extends StatelessWidget {
  final HealthInsuranceController controller;
  final void Function(String option) onChoosePaymentOption;

  SummaryStepView(
      {required this.controller, required this.onChoosePaymentOption});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching user data'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('No user data found'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var dobController = userData['birthdate'] ?? '';
          var fullnameController = userData['fullname'] ?? '';
          var nationalIdController = userData['nationalId'] ?? '';
          var phoneController = userData['phone'] ?? '';
          var selectedCountry = userData['country'] ?? 'Tunis';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Summary',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                _buildSummaryItem('Name:', fullnameController),
                _buildSummaryItem('National ID:', nationalIdController),
                _buildSummaryItem('Phone:', phoneController),
                _buildSummaryItem('Country:', selectedCountry),
                _buildSummaryItem(
                    'Student:', controller.formData['is_student'] ?? 'N/A'),
                _buildSummaryItem(
                    'Children:', controller.formData['has_children'] ?? 'N/A'),
                _buildSummaryItem('Date de Naissance:', dobController),
                _buildSummaryItem('Agence:', controller.selectedOption),
                _buildSummaryItem(
                    'Total:', controller.calculateTotal().toString()),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showPaymentOptionDialog(context),
                  child: Text('Next'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showPaymentOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Payment Option'),
          content: Text('Would you like to pay online or get an invoice?'),
          actions: <Widget>[
            TextButton(
              child: Text('Pay Online'),
              onPressed: () {
                Navigator.of(context).pop();
                onChoosePaymentOption('pay_online');
              },
            ),
            TextButton(
              child: Text('Get Invoice'),
              onPressed: () {
                Navigator.of(context).pop();
                onChoosePaymentOption('get_invoice');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
