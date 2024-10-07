import 'package:flutter/material.dart';
import '../controllers/car_insurance_controller.dart';

class FormStepView extends StatefulWidget {
  final CarInsuranceController controller;

  FormStepView({required this.controller});

  @override
  _FormStepViewState createState() => _FormStepViewState();
}

class _FormStepViewState extends State<FormStepView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Step 3: Entrer vos donnees supplimentaires'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: widget.controller.nameController,
                decoration: InputDecoration(
                  labelText: "Numero de Carte d'identite",
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: widget.controller.ageController,
                decoration: InputDecoration(
                  labelText: 'Entrez Votre Adresse',
                  labelStyle: TextStyle(color: Colors.orange),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: widget.controller.selectedOption,
                style: const TextStyle(color: Colors.orange),
                hint: Text('Agence'),
                items: ['Sfax', 'Gabes', 'Mednine', 'Tunis', 'Kairouan']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      widget.controller.updateSelectedOption(value);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
