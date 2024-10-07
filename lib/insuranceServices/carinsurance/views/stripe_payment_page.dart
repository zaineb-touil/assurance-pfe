import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:insurance_pfe/auth/components/color.dart';
import 'package:insurance_pfe/homepage.dart';
import '../controllers/car_insurance_controller.dart';

class StripePaymentPage extends StatelessWidget {
  final int total;
  final CarInsuranceController controller;

  StripePaymentPage({required this.total, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: PaymentDetails(total: total, controller: controller),
    );
  }
}

class PaymentDetails extends StatefulWidget {
  final int total;
  final CarInsuranceController controller;

  PaymentDetails({required this.total, required this.controller});

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cardNumberController1 = TextEditingController();
  final TextEditingController _cardNumberController2 = TextEditingController();
  final TextEditingController _cardNumberController3 = TextEditingController();
  final TextEditingController _cardNumberController4 = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _cardName = 'John Doe';
  String _expiryDate = '02/26';

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      setState(() {
        _cardName =
            _nameController.text.isEmpty ? 'John Doe' : _nameController.text;
      });
    });

    _expiryMonthController.addListener(() {
      setState(() {
        _updateExpiryDate();
      });
    });

    _expiryYearController.addListener(() {
      setState(() {
        _updateExpiryDate();
      });
    });
  }

  void _updateExpiryDate() {
    final month = _expiryMonthController.text.padLeft(2, '0');
    final year = _expiryYearController.text.padLeft(2, '0').substring(2);
    _expiryDate = '$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Payment details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CardDetails(cardName: _cardName, expiryDate: _expiryDate),
          SizedBox(height: 20),
          AddNewCardForm(
            nameController: _nameController,
            expiryMonthController: _expiryMonthController,
            expiryYearController: _expiryYearController,
            cardNumberController1: _cardNumberController1,
            cardNumberController2: _cardNumberController2,
            cardNumberController3: _cardNumberController3,
            cardNumberController4: _cardNumberController4,
            cvvController: _cvvController,
          ),
          SizedBox(height: 20),
          OrderTotal(total: widget.total),
          PayNowButton(total: widget.total, controller: widget.controller),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class CardDetails extends StatelessWidget {
  final String cardName;
  final String expiryDate;

  const CardDetails({required this.cardName, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        gradient: LinearGradient(
          colors: [primaryColor, Color(0xFFD87A0E)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISA',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '**** **** **** 3233',
            style: TextStyle(
                color: Colors.white, fontSize: 18, letterSpacing: 2.0),
          ),
          SizedBox(height: 20),
          Text(
            cardName,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            expiryDate,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class AddNewCardForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController expiryMonthController;
  final TextEditingController expiryYearController;
  final TextEditingController cardNumberController1;
  final TextEditingController cardNumberController2;
  final TextEditingController cardNumberController3;
  final TextEditingController cardNumberController4;
  final TextEditingController cvvController;

  const AddNewCardForm({
    required this.nameController,
    required this.expiryMonthController,
    required this.expiryYearController,
    required this.cardNumberController1,
    required this.cardNumberController2,
    required this.cardNumberController3,
    required this.cardNumberController4,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name on card',
            hintText: 'ex: John Doe',
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            _buildOTPField(context, cardNumberController1,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController2,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController3,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
            SizedBox(width: 10),
            _buildOTPField(context, cardNumberController4,
                nextFocusNode: FocusNode(), inputType: TextInputType.number),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildOTPField(context, expiryMonthController,
                  inputType: TextInputType.number, hintText: 'MM'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: _buildOTPField(context, expiryYearController,
                  inputType: TextInputType.number, hintText: 'YY'),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextField(
          controller: cvvController,
          decoration: InputDecoration(
            labelText: 'CVV/CVC',
            hintText: '3 or 4 digits',
          ),
        ),
      ],
    );
  }

  Widget _buildOTPField(BuildContext context, TextEditingController controller,
      {FocusNode? nextFocusNode,
      TextInputType inputType = TextInputType.text,
      String? hintText}) {
    return Container(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        textAlign: TextAlign.center,
        maxLength: 4,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.length == 4 && nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
        },
      ),
    );
  }
}

class OrderTotal extends StatelessWidget {
  final int total;

  OrderTotal({required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Order total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('\$$total',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class PayNowButton extends StatelessWidget {
  final int total;
  final CarInsuranceController controller;

  PayNowButton({required this.total, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Call the submitData method from CarInsuranceController
        await controller.submitData();

        // Show the success dialog
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Payment Successful',
          desc: 'Your payment of \$$total has been processed successfully.',
          btnOkOnPress: () {
            // Navigate back to the HomePage and refresh data
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      Homepage()), // Replace HomePage with your actual home page widget
              (route) => false,
            );
          },
        )..show();
      },
      child: Text('Pay now', style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      ),
    );
  }
}
