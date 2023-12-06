import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key , required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6342E8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}

class CustomButtonOutline extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  const CustomButtonOutline({super.key , required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            width: 2,
            color: Color(0xFF6342E8)
          )
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF6342E8),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}