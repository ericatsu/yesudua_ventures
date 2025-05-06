import 'package:flutter/material.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace with actual chart logic if needed
    return Container(
      margin: const EdgeInsets.only(top: 12),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Text('Sales Chart Placeholder')),
    );
  }
}
