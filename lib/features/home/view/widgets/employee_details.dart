import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_details_related/photo_slider.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_details_related/square_avatar.dart';

class EmployeeDetails extends StatelessWidget {
  const EmployeeDetails(
      {super.key,
      required this.height,
      required this.width,
      required this.employee,
      required this.photoUrls});

  final double height;
  final double width;
  final Employee employee;
  final List<String> photoUrls;

  @override
  Widget build(BuildContext context) {
    print(width);
    print('width');
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.secondaryContainer),
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width * 2 / 3 - 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SquareAvatar(
                                size: 70,
                                foregroundImage:
                                    NetworkImage(employee.imageUrl),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    ),
                                    Text(
                                      employee.number,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface),
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
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Записаться'))
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        employee.description,
                        // maxLines: false,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: height, maxWidth: width / 3),
                  child: PhotoSlider(photoUrls: photoUrls, height: height)),
            )
          ],
        ),
      ),
    );
  }
}
