import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../features.dart';

class ChooseDepartmentPage extends StatefulWidget {
  const ChooseDepartmentPage({super.key});

  @override
  State<ChooseDepartmentPage> createState() => _ChooseDepartmentPageState();
}

class _ChooseDepartmentPageState extends State<ChooseDepartmentPage> {
  String examType = '';

  @override
  void initState() {
    super.initState();
    context.read<SelectDepartmentBloc>().add(GetAllDepartmentsEvent());
    context.read<GetUserBloc>().add(GetUserCredentialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUserBloc, GetUserState>(
      listener: (context, state) {
        if (state is GetUserCredentialState &&
            state.status == GetUserStatus.loaded) {
          setState(() {
            examType = state.userCredential!.examType!;
          });
        }
      },
      child: chooseDepartmentWidget(context),
    );
  }

  Scaffold chooseDepartmentWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 3.h, left: 5.w, right: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your department',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 1.5.h,
            ),
            const Text(
              'Browse from available departments',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Expanded(
              child: BlocBuilder<SelectDepartmentBloc, SelectDepartmentState>(
                builder: (context, state) {
                  if (state is AllDepartmentsFailedState) {
                    return const Center(
                      child: Text('Error happened'),
                    );
                  } else if (state is AllDepartmentsLoadingState) {
                    return ListView.separated(
                      itemCount: 5,
                      itemBuilder: (context, index) => _departmentListShimmer(),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 1.h,
                      ),
                    );
                  } else if (state is AllDepartmentsLoadedState) {
                    List<GeneralDepartment> allDepartments =
                        state.generalDepartments
                            .where(
                              (department) {
                                if (examType == 'University Entrance Exam') {
                                  return department.isForListing == false &&
                                      department.name != 'University Exit Exam';
                                }
                                return department.isForListing == true;
                              },
                            )
                            .map((department) => department)
                            .toList();

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: allDepartments.length,
                      itemBuilder: (context, index) {
                        return ExpandableWidget(
                            generalDepartmentName: allDepartments[index].name,
                            departmments: allDepartments[index].departments);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Shimmer _departmentListShimmer() {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(255, 236, 235, 235),
        highlightColor: const Color(0xffF9F8F8),
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 2.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    height: 3.h,
                    width: 75.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              const Divider(
                color: Colors.white,
                height: 2,
                indent: 10,
              )
            ],
          ),
        ));
  }
}
