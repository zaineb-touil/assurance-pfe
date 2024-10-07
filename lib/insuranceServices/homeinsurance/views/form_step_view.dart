import 'package:flutter/material.dart';
import '../controllers/home_insurance_controller.dart';

class FormStepView extends StatelessWidget {
  final HomeInsuranceController controller;

  FormStepView({required this.controller});

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
                controller: controller.nameController,
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
                controller: controller.ageController,
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
                value: controller.selectedOption,
                style: const TextStyle(color: Colors.orange),
                hint: Text('Situation Sociale'),
                items: ['Mariee', 'Celibataire']
                    .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.selectedOption = value!;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
