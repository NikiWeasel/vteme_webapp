import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:vteme_tg_miniapp/core/models/employee.dart';

class EmployeeProfileWidget extends StatelessWidget {
  const EmployeeProfileWidget(
      {super.key,
      required this.employee,
      required this.isSelected,
      required this.selectEmployee});

  final Employee employee;
  final bool isSelected;
  final void Function() selectEmployee;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.secondary,
      child: ListTile(
        leading: CircleAvatar(
          foregroundImage: NetworkImage(employee.imageUrl),
          child: const Icon(Icons.person),
        ),
        title: Text(
          '${employee.name} ${employee.surname}',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
        subtitle: Text(
          employee.number,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
        onTap: selectEmployee,
      ),
    );
  }
}
