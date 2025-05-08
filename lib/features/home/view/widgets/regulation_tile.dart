import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/theme.dart';

class RegulationTile extends StatelessWidget {
  const RegulationTile(
      {super.key,
      // required this.onDelete,

      required this.isSecondaryScreen,
      required this.regulation,
      required this.onPressed});

  final bool isSecondaryScreen;
  final Regulation regulation;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        shape: ShapeBorder.lerp(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          1,
        ),
        onTap: isSecondaryScreen ? onPressed : null,
        title: Text(regulation.name),
        subtitle: Text('${regulation.duration.toString()} мин'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${regulation.cost.toString()} руб'),
            SizedBox(
              width: activeWidth >= 800 ? 24 : 12,
            ),
            if (!isSecondaryScreen) ...[
              if (activeWidth >= 800)
                ElevatedButton(
                    onPressed: onPressed, child: const Text('Записаться'))
              else
                ElevatedButton(
                  style: smallButton,
                  onPressed: onPressed,
                  child: const Icon(Icons.chevron_right),
                )
            ]
            // IconButton(onPressed: onPressed, icon: Icon(Icons.chevron_right))
          ],
        ),
      ),
    );
  }
}
