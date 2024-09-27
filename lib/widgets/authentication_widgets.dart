import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.label,
      required this.placeholder,
      required this.controller,
      required this.isPassword});

  final TextEditingController controller;
  final String placeholder;
  final bool isPassword;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: isPassword,
            controller: controller,
            decoration: InputDecoration(
              fillColor: const Color.fromARGB(255, 40, 31, 31),
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: placeholder,
              hintStyle: TextStyle(
                  color: Colors.grey[500], fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key, required this.child, required this.onClick});

  final Widget child;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            CupertinoColors.activeOrange,
            Color.fromARGB(255, 140, 20, 20),
          ], stops: [
            0,
            0.9
          ]),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(child: child),
      ),
    );
  }
}
