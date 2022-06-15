// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/forgot_passowrd.dart';
import 'package:flower_app/pages/register.dart';
import 'package:flower_app/provider/google_signin.dart';

import 'package:flower_app/shared/colors.dart';
import 'package:flower_app/shared/contants.dart';
import 'package:flower_app/shared/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isVisable = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarGreen,
          title: Text("Sign in"),
        ),
        backgroundColor: Color.fromARGB(255, 247, 247, 247),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(33.0),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 64,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Email : ",
                      suffixIcon: Icon(Icons.email))),
              const SizedBox(
                height: 33,
              ),
              TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: isVisable ? false : true,
                  decoration: decorationTextfield.copyWith(
                      hintText: "Enter Your Password : ",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable = !isVisable;
                            });
                          },
                          icon: isVisable
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)))),
              const SizedBox(
                height: 33,
              ),
              ElevatedButton(
                onPressed: () async {
                  await signIn();
                  if (!mounted) return;
                  // showSnackBar(context, "Done ... ");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(BTNgreen),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Sign in",
                        style: TextStyle(fontSize: 19),
                      ),
              ),
              const SizedBox(
                height: 9,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                  );
                },
                child: Text("Forgot password?",
                    style: TextStyle(
                        fontSize: 18, decoration: TextDecoration.underline)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do not have an account?",
                      style: TextStyle(fontSize: 18)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Register()),
                        );
                      },
                      child: Text('sign up',
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.underline))),
                ],
              ),
              SizedBox(
                height: 17,
              ),
              SizedBox(
                width: 299,
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                    )),
                    Text(
                      "OR",
                      style: TextStyle(),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 27),
                child: GestureDetector(
                  onTap: () {
                    googleSignInProvider.googlelogin();
                  },
                  child: Container(
                    padding: EdgeInsets.all(13),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            // color: Colors.purple,
                            color: Color.fromARGB(255, 200, 67, 79),
                            width: 1)),
                    child: SvgPicture.asset(
                      "assets/icons/google.svg",
                      color: Color.fromARGB(255, 200, 67, 79),
                      height: 27,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        )));
  }
}
