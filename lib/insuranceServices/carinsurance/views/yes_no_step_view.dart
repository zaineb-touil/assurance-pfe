import 'package:flutter/material.dart';

class YesNoStepView extends StatefulWidget {
  final String question;
  final String stepKey;
  final Function(String, int) onOptionSelected;

  YesNoStepView({
    required this.question,
    required this.stepKey,
    required this.onOptionSelected,
  });

  @override
  _YesNoStepViewState createState() => _YesNoStepViewState();
}

class _YesNoStepViewState extends State<YesNoStepView> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildOption('Oui', 100),
          _buildOption('Non', 50),
        ],
      ),
    );
  }

  Widget _buildOption(String option, int score) {
    bool isSelected = option == selectedOption;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = option;
          });
          widget.onOptionSelected(option, score);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.check_circle,
                  color: isSelected ? Colors.white : Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
