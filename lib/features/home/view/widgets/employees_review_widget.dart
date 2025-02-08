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
    print(height);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: width - 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < widget.emps.length; i++) ...[
                EmployeeProfileWidget(
                  employee: widget.emps[i],
                  isSelected: empBoolList[i],
                  selectEmployee: () {
                    selectEmployee(i);
                  },
                ),
                const SizedBox(
                  height: 8,
                )
              ],
              SizedBox(
                height: height,
              )
            ],
          ),
        ),
        Positioned(
            top: 0,
            left: 0,
            child: EmployeeDetails(
              height: height,
              width: width,
              employee: activeEmployeeDetails,
              photoUrls:
                  widget.portfolioUrls[activeEmployeeDetails.employeeId] ?? [],
            )),
      ],
    );
  }
}
