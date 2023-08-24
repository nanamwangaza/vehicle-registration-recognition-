import 'package:flutter/material.dart';

class FormFieldWidget extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController controller; // Added this line

  const FormFieldWidget({
    required this.label,
    required this.validator,
    required this.onSaved,
    required this.controller, // Added this line
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SizedBox(
              height: 60,
              child: TextFormField(
                controller: controller, // Added this line
                validator: validator,
                onSaved: onSaved,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  label: Text(label),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
