import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelectorWidget({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Delete icon (decrement)
        GestureDetector(
          onTap: onDecrement,
          child: const Icon(Icons.delete_forever_outlined),
        ),
        // Quantity display
        const SizedBox(width: AppConstants.spacing8),
        Text(
          '$quantity',
          style: const TextStyle(
            fontSize: AppConstants.fontSize22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: AppConstants.spacing8),
        // Add icon (increment)
        GestureDetector(
          onTap: onIncrement,
          child: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
