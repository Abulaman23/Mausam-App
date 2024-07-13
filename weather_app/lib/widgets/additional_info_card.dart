import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AdditionalInfo extends StatelessWidget {
  String title = '';
  String value = '';
  IconData icon;
  AdditionalInfo(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        elevation: 6,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.white,
              Color.fromARGB(255, 95, 226, 222),
              Color.fromARGB(255, 100, 116, 237),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          width: 98,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
