import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class RegulationTile extends StatelessWidget {
  const RegulationTile(
      {super.key,
      // required this.onDelete,
      required this.regulation,
      required this.onPressed});

  final Regulation regulation;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          1,
        ),
        title: Text(regulation.name),
        subtitle: Text('${regulation.duration.toString()} мин'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${regulation.cost.toString()} руб'),
            const SizedBox(
              width: 24,
            ),
            ElevatedButton(
                onPressed: onPressed, child: const Text('Записаться')),
          ],
        ),
      ),
    );
  }
}
