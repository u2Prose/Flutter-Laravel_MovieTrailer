import 'package:flutter/material.dart';

const String baseURL = "http://127.0.0.1:8000/api/"; //emulator localhost
const Map<String, String> headers = {"Content-Type": "application/json"};

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Color.fromARGB(255, 54, 244, 63),
    content: Text(text),
    duration: const Duration(seconds: 1),
  ));
}
