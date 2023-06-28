import 'package:flutter/material.dart';
import 'package:pimoapp/screens/home_screen.dart';
import 'package:pimoapp/backend_api/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginScreen extends StatefulWidget {
  Color customColor = Color(0xFF3CB371);

  LoginScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void authenticateUser() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    var success = await APIService.authenticateUser(email, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      // Authentication successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged successfully'),
        ),
      );
      print('Login successful');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            email: email,
            displayName: '',
            manageID: 2,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid username or password'),
        ),
      );
      // Authentication failed
      print('Login failed');
    }
  }

  bool _passwordVisible = false;
  Color customColor = Color(0xFF3CB371);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            cajapurpura(size),
            personIcon(),
            SingleChildScrollView(
              child: loginForm(context),
            ),
          ],
        ),
      ),
    );
  }

  // Methods
  Container cajapurpura(Size size) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 52, 148, 44),
            Color.fromARGB(255, 52, 148, 44),
          ],
        ),
      ),
      width: double.infinity,
      height: size.height * 0.4,
      child: Stack(
        children: [
          Positioned(
            top: 90,
            left: 90,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea personIcon() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        width: double.infinity,
        child: const Icon(Icons.person_pin, color: Colors.white, size: 90),
      ),
    );
  }

  Column loginForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 260),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 30),
                Form(
                  key: widget._formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          // Email validation pattern
                          String emailPattern =
                              r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
                          RegExp regExp = RegExp(emailPattern);
                          if (!regExp.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null; // Return null if the email is valid
                        },
                        controller: emailController,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 52, 148, 44)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 52, 148, 44),
                              width: 2,
                            ),
                          ),
                          hintText: 'example@gmail.com',
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          // Password validation pattern
                          String passwordPattern =
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                          RegExp regExp = RegExp(passwordPattern);
                          if (!regExp.hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                          }
                          return null; // Return null if the password is valid
                        },
                        obscureText: !_passwordVisible,
                        controller: passwordController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 52, 148, 44)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 52, 148, 44)),
                          ),
                          hintText: '*******',
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: isLoading ? null : () {
                              if (widget._formKey.currentState!.validate()) {
                                authenticateUser();
                              }
                            },
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text('Login'),
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 52, 148, 44),
                              onPrimary: Color.fromARGB(255, 251, 252, 250),
                              fixedSize: Size(200, 50),
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
        const SizedBox(height: 50),
      ],
    );
  }
}
