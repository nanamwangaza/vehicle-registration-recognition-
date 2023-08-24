import 'package:flutter/material.dart';
import 'package:vehicle_registration/pages/home.dart';
import 'package:vehicle_registration/pages/login_page.dart';
import 'package:vehicle_registration/widgets/form_field_cofirm_password.dart';
import 'package:vehicle_registration/widgets/form_field_email.dart';
import 'package:vehicle_registration/widgets/form_field_password.dart';
import 'package:vehicle_registration/widgets/form_fields.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Trim password strings before comparing
      final trimmedPassword = _passwordController.text.trim();
      final trimmedConfirmPassword = _confirmPasswordController.text.trim();

      if (trimmedPassword != trimmedConfirmPassword) {
        print("Passwords don't match");
        return;
      }

      // Perform signup logic using the saved values
      // For example, you could save the data to a database or API

      // Navigate to the Home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'SIGNUP',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        FormFieldWidget(
                          label: "First name",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _firstNameController.text = value!;
                          },
                          controller: _firstNameController,
                        ),
                        FormFieldWidget(
                          label: "Last Name",
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _lastNameController.text = value!;
                          },
                          controller: _lastNameController,
                        ),
                        FormFieldEmail(
                          label: 'Email',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _emailController.text = value!;
                          },
                          controller: _emailController,
                        ),
                        FormFieldPassword(
                          label: 'Password',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _passwordController.text = value!;
                          },
                          controller: _passwordController,
                        ),
                        FormFieldConfirmPassword(
                          label: "Confirm password",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _confirmPasswordController.text = value!;
                          },
                          password: _passwordController.text,
                          controller: _confirmPasswordController,
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Login(), // Replace LoginPage with your actual login page
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
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
