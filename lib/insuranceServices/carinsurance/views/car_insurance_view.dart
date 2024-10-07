import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/car_insurance_controller.dart';
import 'yes_no_step_view.dart';
import 'yes_no_married_view.dart';
import 'date_step_view.dart';
import 'form_step_view.dart';
import 'summary_step_view.dart';
import 'stripe_payment_page.dart';

class CarInsuranceView extends StatefulWidget {
  @override
  _CarInsuranceViewState createState() => _CarInsuranceViewState();
}

class _CarInsuranceViewState extends State<CarInsuranceView> {
  late CarInsuranceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CarInsuranceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePaymentOption(String option) {
    if (option == 'pay_online') {
      setState(() {
        _controller.nextPage();
      });
    } else if (option == 'get_invoice') {
      _storeInvoiceData();
      _showInvoiceDialog();
    }
  }

  Future<void> _storeInvoiceData() async {
    final user = FirebaseAuth.instance.currentUser;

    final formData = _controller.formData;
    final data = {
      'age': formData['age'] ?? '',
      'birthDate': formData['birthDate'] ?? '',
      'has_children': formData['has_children'] ?? 'N/A',
      'is_student': formData['is_student'] ?? 'N/A',
      'name': formData['name'] ?? '',
      'agency': formData['selectedOption'] ?? 'Gabes',
      'total': _controller.calculateTotal(),
      'expiryDate': Timestamp.fromDate(DateTime.now().add(Duration(days: 365))),
      'price': _controller.calculateTotal(),
      'timestamp': Timestamp.fromDate(DateTime.now()),
      'type': 'auto',
      'userId': user?.uid,
      'approve_status': 'waiting',
    };

    await FirebaseFirestore.instance.collection('responses').add(data);
  }

  void _showInvoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice Number'),
          content: Text('Your invoice number is: INV123456789'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void _showPaymentOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Payment Option'),
          content: Text('How would you like to proceed with the payment?'),
          actions: <Widget>[
            TextButton(
              child: Text('Pay Online'),
              onPressed: () {
                Navigator.of(context).pop();
                _handlePaymentOption('pay_online');
              },
            ),
            TextButton(
              child: Text('Get Invoice'),
              onPressed: () {
                Navigator.of(context).pop();
                _handlePaymentOption('get_invoice');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assurance Auto'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_controller.currentPage + 1) / 6,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  YesNoStepView(
                    question: 'Etes Vous un etudiant ?',
                    stepKey: 'is_student',
                    onOptionSelected: (value, score) {
                      _controller.formData['is_student'] = value;
                      _controller.formData['is_student_score'] = score;
                    },
                  ),
                  YesNoMarriedView(
                    question: 'Avez Vous des Enfants ?',
                    stepKey: 'has_children',
                    onOptionSelected: (value, score) {
                      _controller.formData['has_children'] = value;
                      _controller.formData['has_children_score'] = score;
                    },
                  ),
                  DateStepView(
                    question: 'Entrer votre date de Naissance',
                    controller: _controller,
                  ),
                  FormStepView(controller: _controller),
                  SummaryStepView(
                    controller: _controller,
                    onChoosePaymentOption: _handlePaymentOption,
                  ),
                  StripePaymentPage(
                    total: _controller.calculateTotal(),
                    controller: _controller,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_controller.currentPage > 0)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                          ),
                          onPressed: () =>
                              setState(() => _controller.previousPage()),
                          child: Text('Previous'),
                        ),
                      ),
                    ),
                  if (_controller.currentPage ==
                      4) // Show the Next button only on the summary page
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                          ),
                          onPressed: () => _showPaymentOptionDialog(),
                          child: Text('Next'),
                        ),
                      ),
                    ),
                  if (_controller.currentPage <
                      4) // Show the Next button on all pages except the summary page and the payment page
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                          ),
                          onPressed: () =>
                              setState(() => _controller.nextPage()),
                          child: Text('Next'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
