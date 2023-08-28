import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vehicle_registration/pages/forgot_password.dart';
import 'package:vehicle_registration/pages/home_pro.dart';
import 'package:vehicle_registration/pages/signup.dart';
import 'package:vehicle_registration/widgets/form_field_email.dart';
import 'package:vehicle_registration/widgets/form_field_password.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

 void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // final loginData = {
      //   'email': _emailController.text,
      //   'password': _passwordController.text,
      // };

      // final apiUrl = 'https://your-fastapi-backend.com/login';  // Replace with your backend URL for login
      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(loginData),
      // );

      // if (response.statusCode == 200) {
      //   // Login successful, navigate to HomePro page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePro()),
        );
      // } else {
      //   print('Login failed. Status code: ${response.statusCode}');
      // }
    }
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _emailController.dispose();
    _passwordController.dispose();
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
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(height: 50,),
                       
                        FormFieldEmail(
                          label: 'Email',
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            // You can add email format validation here
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
                            // You can add password validation here
                            return null;
                          },
                          onSaved: (value) {
                            _passwordController.text = value!;
                          },
                          controller: _passwordController,
                        ),

                        Row(
                          // to place the 'forgot password' at the end
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),

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
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        SizedBox(height: 10,),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            SizedBox(width: 5),

                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Signup(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
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
