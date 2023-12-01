import 'package:flutter/material.dart';

class SocialLoginBtn extends StatelessWidget {
  final Color fillColor;
  final Widget icon;
  final bool isSignIn;
  final String name;
  final Color textColor;
  final Function() onTap;

  const SocialLoginBtn({
    super.key,
    required this.fillColor,
    required this.icon,
    required this.isSignIn,
    required this.name,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(color: fillColor, boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              offset: Offset(0, 1),
              blurRadius: 4,
            )
          ]),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            icon,
            const SizedBox(width: 20),
            Text(
              "${isSignIn ? "Sign In" : "Sign Up"} with $name",
              style: TextStyle(color: textColor, fontSize: 12),
            )
          ]),
        ),
      ),
    );
  }
}
