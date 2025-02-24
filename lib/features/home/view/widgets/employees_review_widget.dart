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
            imageUrl: 'imageUrl');
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
    var width = MediaQuery.of(context).size.width / 2;
    var widgetHeight = 83.0 * widget.emps.length;
    var height = widgetHeight < 407.0 ? 407.0 : widgetHeight - 8;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EmployeeDetails(
          height: height,
          width: width * 2 / 3,
          employee: activeEmployeeDetails,
          photoUrls:
              widget.portfolioUrls[activeEmployeeDetails.employeeId] ?? [],
        ),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: width / 3,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.emps.length; i++) ...[
                  SizedBox(
                    width: double.infinity,
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
        ),
      ],
    );
  }
}
