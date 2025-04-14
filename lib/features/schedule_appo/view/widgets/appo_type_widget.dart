import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppoTypeWidget extends StatelessWidget {
  const AppoTypeWidget({super.key, required this.text, required this.onTap});

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    List<String> fragmentedText = text.split(' ');

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: SizedBox(
        height: 130,
        width: 130,
        child: Card(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [for (var t in fragmentedText) Text(t)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
