import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:insurance_pfe/auth/components/custombuttonauth.dart';
import 'package:insurance_pfe/auth/components/customlogoauth.dart';
import 'package:insurance_pfe/auth/components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> registerUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Create user in Firebase Authentication
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': username.text,
        'email': email.text,
        'role': 'user', // Default role
        'createdAt': Timestamp.now(),
      });

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      // Show success dialog
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Success',
        desc: 'Verification email sent. Please verify your email to continue.',
      ).show();

      // Navigate to login screen
      Navigator.of(context).pushReplacementNamed("login");

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
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
      print(e.toString());
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'An unexpected error occurred. Please try again later.',
      ).show();
    }
  }

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
                          "SignUp",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(height: 10),
                        const Text(
                          "SignUp To Continue Using The App",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(height: 20),
                        const Text(
                          "Username",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(height: 10),
                        CustomTextForm(
                          hinttext: "Enter Your Username",
                          mycontroller: username,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Username cannot be empty";
                            }
                            return null;
                          },
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
                            if (val!.isEmpty) {
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
                            if (val!.isEmpty) {
                              return "Password cannot be empty";
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButtonAuth(
                    title: "SignUp",
                    onPressed: () {
                      if (formState.currentState!.validate()) {
                        registerUser();
                      }
                    },
                  ),
                  Container(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Have An Account? ",
                            ),
                            TextSpan(
                              text: "Login",
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
