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
    return InkWell(
      onTap: selectEmployee,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
        height: 75,
        width: 250,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24.0, right: 8, top: 8, bottom: 8),
          child:
              // Row(
              //   children: [
              //     CircleAvatar(
              //       foregroundImage: NetworkImage(employee.imageUrl),
              //       child: const Icon(Icons.person),
              //     ),
              //     const SizedBox(width: 4),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('${employee.name} ${employee.surname}'),
              //         Text(
              //           employee.number,
              //           style: Theme.of(context).textTheme.bodySmall,
              //         ),
              //       ],
              //     )
              //   ],
              // ),
              Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 16,
              ),
              CircleAvatar(
                foregroundImage: NetworkImage(employee.imageUrl),
                child: const Icon(Icons.person),
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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    Text(
                      employee.number,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
