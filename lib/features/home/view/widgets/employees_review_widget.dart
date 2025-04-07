import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/employee_details.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employee_review_related/employee_profile_widget.dart';

class EmployeesReviewWidget extends StatefulWidget {
  const EmployeesReviewWidget(
      {super.key, required this.emps, required this.portfolioUrls});

  final List<Employee> emps;
  final Map<String, List<String>> portfolioUrls;

  @override
  State<EmployeesReviewWidget> createState() => _EmployeesReviewWidgetState();
}

class _EmployeesReviewWidgetState extends State<EmployeesReviewWidget> {
  late List<bool> empBoolList;
  late Employee activeEmployeeDetails;

  @override
  void initState() {
    empBoolList = List.generate(
      widget.emps.length,
      (index) => (index == 0) ? true : false,
    );
    activeEmployeeDetails = widget.emps.isNotEmpty
        ? widget.emps[0]
        : const Employee(
            employeeId: 'employeeId',
            name: 'name',
            surname: 'surname',
            isAdmin: false,
            description: 'description',
            email: 'email',
            number: 'number',
            imageUrl: 'imageUrl',
            categoryIds: []);
    super.initState();
  }

  void selectEmployee(int index) {
    setState(() {
      empBoolList = List.generate(
        widget.emps.length,
        (index) => false,
      );
      empBoolList[index] = true;
    });
    activeEmployeeDetails = widget.emps[index];
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;
    var widgetHeight = 83.0 * widget.emps.length;

    var height = 0.0;
    if (activeWidth < 800) {
      height = widgetHeight < 407.0 ? 407.0 : widgetHeight - 8 + 100;
    } else {
      height = widgetHeight < 407.0 ? 407.0 : widgetHeight - 8;
    }
    // height = widgetHeight < 407.0 ? 407.0 : widgetHeight - 8;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
          ),
          child: EmployeeDetails(
            height: height,
            width: activeWidth < 800 ? activeWidth - 80 : activeWidth * 2 / 3,
            employee: activeEmployeeDetails,
            photoUrls:
                widget.portfolioUrls[activeEmployeeDetails.employeeId] ?? [],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.emps.length; i++) ...[
                SizedBox(
                  width: activeWidth < 800 ? 64 : activeWidth / 3 - 8,
                  child: EmployeeProfileWidget(
                    employee: widget.emps[i],
                    isSelected: empBoolList[i],
                    selectEmployee: () {
                      selectEmployee(i);
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                )
              ],
            ],
          ),
        ),
      ],
    );
  }
}
