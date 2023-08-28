import 'package:flutter/material.dart';

class FormFieldEmail extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController controller; // Added this line

  const FormFieldEmail({
    required this.label,
    required this.validator,
    required this.onSaved,
    required this.controller, // Added this line
  });

  bool _isValidEmail(String input) {
    final RegExp emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegExp.hasMatch(input);
  }

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
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
                keyboardType:TextInputType.emailAddress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
