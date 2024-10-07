import 'package:flutter/material.dart';
import '../controllers/home_insurance_controller.dart';
import 'yes_no_step_view.dart';
import 'yes_no_married_view.dart';
import 'date_step_view.dart';
import 'form_step_view.dart';
import 'summary_step_view.dart';

class HomeInsuranceView extends StatefulWidget {
  @override
  _HomeInsuranceViewState createState() => _HomeInsuranceViewState();
}

class _HomeInsuranceViewState extends State<HomeInsuranceView> {
  late HomeInsuranceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeInsuranceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assurance Maladie'),
      ),
      body: Container(
        decoration:
            BoxDecoration(color: const Color.fromARGB(255, 255, 255, 255)),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_controller.currentPage + 1) / 5,
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
                    stepKey: 'qcmStep1',
                    onOptionSelected: (value) =>
                        _controller.formData['qcmStep1'] = value,
                  ),
                  YesNoMarriedView(
                    question: 'Avez Vous des Enfants ?',
                    stepKey: 'qcmStep2',
                    onOptionSelected: (value) =>
                        _controller.formData['qcmStep2'] = value,
                  ),
                  DateStepView(
                    question: 'Entrer votre date de Naissance',
                    controller: _controller,
                  ),
                  FormStepView(controller: _controller),
                  SummaryStepView(controller: _controller),
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                        onPressed: () => setState(() => _controller.nextPage()),
                        child: Text(
                            _controller.currentPage < 4 ? 'Next' : 'Submit'),
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
