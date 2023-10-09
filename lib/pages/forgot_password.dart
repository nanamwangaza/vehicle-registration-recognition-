import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/login_page.dart';
import '../widgets/form_field_password.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reenterNewPasswordController =TextEditingController();
      

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_newPasswordController.text == _reenterNewPasswordController.text) {
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Password Mismatch'),
              content:
                  const Text('The new passwords do not match. Please reenter.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _reenterNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FormFieldPassword(
                          label: 'New Password',
                          onSaved: (value) {
                            _newPasswordController.text = value!;
                          },
                          controller: _newPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your new password';
                            }

                            return null;
                          },
                        ),
                        FormFieldPassword(
                          label: 'Reenter New Password',
                          onSaved: (value) {
                            _reenterNewPasswordController.text = value!;
                          },
                          controller: _reenterNewPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please reenter your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: _submitForm,
                            child: const Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Remember your password?'),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const Login(), // Replace with your actual login page
                                  ),
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
