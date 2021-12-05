import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/constants/controllers.dart';
import 'package:ujay_app/app/constants/text_style.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

     
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   appBar:AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: IconButton(
        //     onPressed: () {
        //       Get.back();
        //       // Navigator.pop(context);
        //     },
        //     icon: Image(
        //       width: 24,
        //       color: Colors.black,
        //       image: Svg('assets/images/back_arrow.svg'),
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ujbackg.png"),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Register.",
                  style: kHeadline,
                ),
                Text(
                  "Create new account to get started.",
                  style: kBodyText2,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: TextFormField(
                              // ignore: missing_return
                              validator: (input) {
                                if (input!.isEmpty) return 'Enter Name';
                              },
                              controller: authController.nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black87,
                                ),
                              ),
                              onSaved: (input) =>
                                  authController.nameController =
                                      input as TextEditingController,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: TextFormField(
                                // ignore: missing_return
                                validator: (input) {
                                  if (input!.isEmpty) return 'Enter Email';
                                },
                                controller: authController.emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black87,
                                    )),
                                onSaved: (input) =>
                                    authController.emailController =
                                        input as TextEditingController),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            child: TextFormField(
                              // ignore: missing_return
                              validator: (input) {
                                if (input!.length < 6)
                                  return 'Provide Minimum 6 Character';
                              },
                              controller: authController.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black87,
                                ),
                              ),
                              obscureText: true,
                              onSaved: (input) =>
                                  authController.passwordController =
                                      input as TextEditingController,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController.registerWithEmailAndPassword();
                            }
                          },
                          //navigateToLogin,
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.only(left: 30, right: 30),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Colors.blue;
                              })),
                        ),
                        // ignore: deprecated_member_use
                        // RaisedButton(
                        //   padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        //   onPressed: authController
                        //       .registerWithEmailAndPassword(context),
                        //   child: Text('SignUp',
                        //       style: TextStyle(
                        //           color: Colors.white,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold)),
                        //   color: Colors.blue,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20.0),
                        //   ),
                        // ),
                        SizedBox(height: 15.0),
                        GestureDetector(
                          child: Text('Already have an Account? Login'),
                          onTap: () {
                            Get.to(Login());
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
