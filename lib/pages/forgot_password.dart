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

  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _reenterNewPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_newPasswordController.text == _reenterNewPasswordController.text) {
        // Perform password reset logic using the saved new password
        // For example, you could update the password in a database or API

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePro()), // Navigate to the appropriate page
        // );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Password Mismatch'),
              content: Text('The new passwords do not match. Please reenter.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
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
    // Dispose of the controllers when the widget is removed
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
            padding: EdgeInsets.all(0),
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
                        SizedBox(height: 20),
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),

                        SizedBox(height: 20),

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
                        SizedBox(height: 20),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Remember your password?'),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Login(), // Replace with your actual login page
                                  ),
                                );
                              },
                              child: Text(
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
