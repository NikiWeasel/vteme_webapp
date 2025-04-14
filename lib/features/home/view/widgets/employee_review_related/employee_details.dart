import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/photo_slider.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/rectangle_profile_header.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/square_avatar.dart';

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
    var descriptionWidth = width * 2 / 3 - 32;

    void onTap(Employee e) {
      context.go('/schedule_appo', extra: {'employee': e});
    }

    return LayoutBuilder(builder: (context, constrains) {
      double activeWidth = MediaQuery.of(context).size.width <= 800
          ? MediaQuery.of(context).size.width
          : 800;

      if (activeWidth < 800) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Theme.of(context).colorScheme.secondaryContainer),
          width: width,
          // height: height * 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: descriptionWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: RectangleProfileHeader(
                      employee: employee,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (employee.description != '')
                    SizedBox(
                      height: 250,
                      child: Card(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: employee.description == ''
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 100),
                                    child: Center(child: Text('Нет описания')),
                                  )
                                : Text(
                                    employee.description,
                                    // maxLines: false,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                    overflow: TextOverflow.fade,
                                    softWrap: true,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: height, maxWidth: double.infinity),
                      child: PhotoSlider(photoUrls: photoUrls, height: height)),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ElevatedButton(
                        onPressed: () {
                          onTap(employee);
                        },
                        child: const Text('Записаться')),
                  )
                ],
              ),
            ),
          ),
        );
      } else {
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
                  width: descriptionWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RectangleProfileHeader(
                            employee: employee,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: descriptionWidth,
                          child: Card(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: employee.description == ''
                                    ? const Padding(
                                        padding: EdgeInsets.only(top: 100),
                                        child:
                                            Center(child: Text('Нет описания')),
                                      )
                                    : Text(
                                        employee.description,
                                        // maxLines: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface),
                                        overflow: TextOverflow.fade,
                                        softWrap: true,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ElevatedButton(
                            onPressed: () {
                              onTap(employee);
                            },
                            child: const Text('Записаться')),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: height, maxWidth: width / 3),
                      child: PhotoSlider(photoUrls: photoUrls, height: height)),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
