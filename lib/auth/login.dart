import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:insurance_pfe/auth/components/custombuttonauth.dart';
import 'package:insurance_pfe/auth/components/customlogoauth.dart';
import 'package:insurance_pfe/auth/components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 50),
                        const CustomLogoAuth(),
                        Container(height: 20),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(height: 10),
                        const Text(
                          "Login To Continue Using The App",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(height: 20),
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(height: 10),
                        CustomTextForm(
                          hinttext: "Enter Your Email",
                          mycontroller: email,
                          validator: (val) {
                            if (val == "") {
                              return "Email cannot be empty";
                            }
                            return null;
                          },
                        ),
                        Container(height: 10),
                        const Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(height: 10),
                        CustomTextForm(
                          hinttext: "Enter Your Password",
                          mycontroller: password,
                          validator: (val) {
                            if (val == "") {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text.isEmpty) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    "Please enter your email address before clicking on Forgot Password",
                              ).show();
                              return;
                            }

                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Success',
                                desc:
                                    'A password reset link has been sent to your email address. Please check your email.',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: e.toString(),
                              ).show();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 20),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonAuth(
                    title: "Login",
                    onPressed: () async {
                      if (formState.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          final UserCredential credential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                          setState(() {
                            isLoading = false;
                          });

                          if (credential.user != null) {
                            if (credential.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
                            } else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'Please verify your email to login. Check your inbox for the verification link.',
                              ).show();
                            }
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: 'User not found.',
                            ).show();
                          }
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          String errorMessage;
                          if (e.code == 'user-not-found') {
                            errorMessage = 'No user found for that email.';
                          } else if (e.code == 'wrong-password') {
                            errorMessage = 'Wrong password provided.';
                          } else {
                            errorMessage = 'Error: ${e.message}';
                          }

                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: errorMessage,
                          ).show();
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'An error occurred. Please try again later.',
                          ).show();
                        }
                      }
                    },
                  ),
                  Container(height: 20),
                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.red[700],
                    textColor: Colors.white,
                    onPressed: () {
                      // Implement signInWithGoogle method as needed
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Login With Google  "),
                        Image.asset(
                          "images/4.png",
                          width: 20,
                        )
                      ],
                    ),
                  ),
                  Container(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't Have An Account? ",
                            ),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
