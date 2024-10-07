import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            "images/splash.png",
            height: 100,
            // fit: BoxFit.fill,
          )),
    );
  }
}
