import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:cafeteria_ofline/sqldb.dart';
import 'package:flutter/material.dart';

void showNotification(BuildContext context,
    {required String title, required String message, bool success = true}) {
  Flushbar(
    messageText: Text(
      message,
      style: const TextStyle(
        fontSize: 16, // تغيير حجم الخط
        color: Colors.white, // تغيير لون النص
        fontWeight: FontWeight.bold,
        // fontFamily: Jazeera, // تغيير وزن الخط
      ),
    ),
    icon: success ? const Icon(Icons.check) : const Icon(Icons.error),
    backgroundColor: success ? Colors.green : Colors.red,
    duration: success ? Duration(seconds: 6) : Duration(seconds: 6),
  ).show(context);
}

void navigateToPage(BuildContext context, Widget page) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
    return Scaffold(
      body: page,
    );
  }));
}

String generateRandomNumber(int length) {
  final random = Random();
  final max = pow(10, length) as int; // تحويل max إلى int

  int randomInt = random.nextInt(max); // توليد رقم عشوائي

  // تحويل الرقم إلى نص
  String randomString = randomInt.toString();
  String n = "check:$randomString";
  return n;
}

void greet() {
  Sqldb sqldb = Sqldb();
// sqldb.insertData('Category', data)
}
