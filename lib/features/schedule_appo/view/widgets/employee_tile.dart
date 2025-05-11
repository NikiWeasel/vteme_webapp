import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';

class EmployeeTile extends StatelessWidget {
  const EmployeeTile(
      {super.key,
      required this.employee,
      required this.onTap,
      required this.catNames});

  final Employee employee;
  final String catNames;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
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
        leading: CircleAvatar(
            foregroundImage: NetworkImage(employee.imageUrl),
            child: const Icon(Icons.person)),
        title: Text('${employee.name} ${employee.surname}'),
        subtitle: Text(catNames),
        onTap: onTap,
      ),
    );
  }
}
