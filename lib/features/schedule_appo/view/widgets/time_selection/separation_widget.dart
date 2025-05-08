import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SeparationWidget extends StatelessWidget {
  const SeparationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 2,
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondary)),
      ),
    );
  }
}
