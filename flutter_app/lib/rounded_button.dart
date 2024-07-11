import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onBtnPressed;
  final Color color;

  const RoundedButton({
    Key? key,
    required this.btnText,
    required this.onBtnPressed,
    this.color = Colors.blue, // Default color if none is provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onBtnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          btnText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
