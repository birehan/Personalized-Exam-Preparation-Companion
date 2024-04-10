import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
// import '../bloc/selectCourseBloc/select_course_bloc.dart';
import '../../../features.dart';

class ExpandableWidget extends StatefulWidget {
  const ExpandableWidget({
    super.key,
    required this.generalDepartmentName,
    required this.departmments,
  });
  final String generalDepartmentName;
  final List<Department> departmments;
  @override
  
  _ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 0,
          iconColor: Colors.black,
          leading: Icon(
            isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            size: 30,
          ),
          trailing: Text(
            '${widget.departmments.length}',
            style: const TextStyle(
                fontSize: 18, color: Color.fromARGB(255, 88, 88, 88)),
          ),
          title: Text(
            widget.generalDepartmentName,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),
        if (isExpanded)
          ListView.builder(
              padding: EdgeInsets.only(left: 3.w),
              shrinkWrap: true,
              itemCount: widget.departmments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing:
                      Text('${widget.departmments[index].numberOfCourses}'),
                  contentPadding: const EdgeInsets.only(left: 10),
                  horizontalTitleGap: 0,
                  dense: true,
                  leading: const Icon(
                    Icons.lens,
                    size: 10,
                    color: Colors.black45,
                  ),
                  title: Text(
                    widget.departmments[index].name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    context
                        .read<SelectCourseBloc>()
                        .add(GetDepartmentCoursesEvent(
                          id: widget.departmments[index].id,
                        ));
                    context.push(AppRoutes.selectCourse);
                  },
                );
              }),
        const Divider(
          indent: 10,
          height: 2,
          color: Colors.grey,
        ),
      ],
    );
  }
}
