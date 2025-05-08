import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/square_avatar.dart';

class RectangleProfileHeader extends StatelessWidget {
  const RectangleProfileHeader({super.key, required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SquareAvatar(
            size: 70,
            foregroundImage: NetworkImage(employee.imageUrl),
            child: const Icon(
              Icons.person,
              size: 70,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${employee.name} ${employee.surname}',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(
                  employee.number,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
