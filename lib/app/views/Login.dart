import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/constants/controllers.dart';
import 'package:ujay_app/app/constants/text_style.dart';
import 'SignUp.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String _email, _password;

  // checkAuthentification() async {
  //   _auth.authStateChanges().listen((user) {
  //     if (user != null) {
  //       print(user);

  //       Navigator.pushReplacementNamed(context, "/");
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   this.checkAuthentification();
  // }

  // login() async {
  //   if (_formKey.currentState.validate()) {
  //     _formKey.currentState.save();

  //     try {
  //       await _auth.signInWithEmailAndPassword(
  //           email: _email, password: _password);
  //     } catch (e) {
  //       showError(e.message);
  //       print(e);
  //     }
  //   }
  // }

  // showError(String errormessage) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('ERROR'),
  //           content: Text(errormessage),
  //           actions: <Widget>[
  //             // ignore: deprecated_member_use
  //             FlatButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('OK'))
  //           ],
  //         );
  //       });
  // }

  // navigateToSignUp() async {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //   appBar:  AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   leading: IconButton(
        //     onPressed: () {
        //       Get.back();
        //       //Navigator.pop(context);
        //     },
        //     icon: Image(
        //       width: 24,
        //       color: Colors.black,
        //       //image: Svg('assets/images/back_arrow.svg'),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome back.",
                    style: kHeadline,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "You've been missed!",
                    style: kBodyText2,
                  ),
                  Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
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
                                onSaved: (input) => authController
                                    .emailController.text = (input) as String,
                                //!input as TextEditingController
                              ),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: authController.passwordController,
                                // ignore: missing_return
                                validator: (input) {
                                  if (input!.length < 6)
                                    return 'Provide Minimum 6 Character';
                                },
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.black87,
                                  ),
                                ),
                                obscureText: true,
                                onSaved: (input) => authController
                                    .passwordController.text = input!,
                                maxLines: 1,
                                //input as TextEditingController
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authController.signInWithEmailAndPassword();
                              }
                            },
                            //navigateToLogin,
                            child: Text(
                              'Login',
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
                          //   onPressed:
                          //   authController
                          //       .signInWithEmailAndPassword(context),
                          //   child: Text('LOGIN',
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 20.0,
                          //           fontWeight: FontWeight.bold)),
                          //   color: Colors.blue,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(20.0),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  GestureDetector(
                    child:
                        Center(child: Text("Dont't have an account? Register")),
                    onTap: () {
                      Get.to(SignUp());
                    },
                    //navigateToSignUp,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
