import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [cajapurpura(size), personIcon(), loginForm(context),
          ],
        ),
      ),
    );
  }

  // Methods
    Container cajapurpura(Size size) {
      return   Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(63, 63,157, 1),
                  Color.fromRGBO(90, 70, 178, 1),
                ])
              ),
              width: double.infinity,
              height: size.height * 0.4,
              child: Stack(
                children: [
                  Positioned(
                  top: 90,
                  left:90,
                  child:  Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    // color: Color.fromARGB(255, 255, 255, 2)
                  ),
                  
                  )
                  )
                ],
              ),
            );
    }

      SafeArea personIcon() {
        return SafeArea(
         child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: const Icon(
                  Icons.person_pin, 
                  color: Colors.white, 
                  size: 90
                  ),
              ),
        );
      }  

      Column loginForm(BuildContext context){
        return Column(
              children: [
               const SizedBox(height: 250),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0,5)
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                         SizedBox(height: 20),
                          Text(
                            'Login', 
                             style: Theme.of(context).textTheme.headlineMedium),
                             const SizedBox(height: 30),
                             Form( key: key,
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
                autocorrect: false,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                  hintText: 'example@gmail.com',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                    ),
                                  
                                   const SizedBox(height: 30),
                                    TextFormField(
                                     autocorrect: false,
                                     decoration: const InputDecoration(
                                       enabledBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(color: Colors.deepPurple)
                                       ),
                                       focusedBorder: UnderlineInputBorder(
                                         borderSide: BorderSide(
                                           color: Colors.deepPurple, width: 2 )) ,
                                          hintText: "*******",
                                          labelText: "Password",
                                          prefixIcon: Icon(Icons.lock_outline),
                                           ),
                                   ),
                                    SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          // shape: ShapeBorderClipper(shape: shape),
                                          onPressed: () {
                                            if(_formKey.currentState!.validate()){
                                                return;
                                            }
                                          },
                                          child: Text('Login'),
                                          color: Colors.deepPurple,
                                        ),
                                      ],
                                    )
                                 ],
                               ),
                             )
                        ],
                      ),
                    ),
                  )
                ),
               const SizedBox(height: 50),
               
                
              ],
            );
      }   
            
  }
