import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppoTypeWidget extends StatelessWidget {
  const AppoTypeWidget({super.key, required this.text, required this.onTap});

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 120,
        width: 120,
        child: Card(
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
