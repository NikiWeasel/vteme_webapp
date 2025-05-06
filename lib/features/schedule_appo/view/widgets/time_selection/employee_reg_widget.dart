import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';

class EmployeeRegWidget extends StatelessWidget {
  const EmployeeRegWidget({super.key, required this.emp, required this.reg});

  final Employee emp;
  final Regulation reg;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
                foregroundImage: NetworkImage(emp.imageUrl),
                child: const Icon(Icons.person)),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${emp.name} ${emp.surname}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Text(reg.name)
      ],
    );
  }
}
