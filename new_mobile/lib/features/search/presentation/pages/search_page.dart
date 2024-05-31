import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/course/presentation/widgets/mycourses_card.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class SearchCoursePage extends StatefulWidget {
  const SearchCoursePage({super.key});

  @override
  State<SearchCoursePage> createState() => _SearchCoursePageState();
}

class _SearchCoursePageState extends State<SearchCoursePage> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // context.read<SearchCourseBloc>().add(SearchPageStartEvent());
    context
        .read<SearchCourseBloc>()
        .add(const UserSearchCourseEvent(query: ''));
    super.initState();
  }

  void _startSearchDebounce(String input) {
    // Cancel any existing debounce timer
    _debounceTimer?.cancel();
    // Start a new debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // _makeSearchAPICall;

      context.read<SearchCourseBloc>().add(UserSearchCourseEvent(query: input));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFf),
      // bottomNavigationBar: const MyBottomNavigation(index: 0),
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Search Course',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchTextField(
                    onSearchFieldChanged: _startSearchDebounce,
                    autoFocus: true,
                    controller: _searchController,
                    hintText: 'Find Course',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Expanded(
              child: BlocListener<SearchCourseBloc, SearchCourseState>(
                listener: (context, state) {
                  if (state is SearchCourseErrorState) {
                    if (state.failure is RequestOverloadFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar(state.failure.errorMessage));
                    }
                  }
                },
                child: BlocBuilder<SearchCourseBloc, SearchCourseState>(
                  builder: (context, state) {
                    if (state is SearchCourseErrorState) {
                      return const Center(child: Text("Error loading courses"));
                    } else if (state is SearchCourseLoadedState) {
                      if (state.courses.isEmpty) {
                        return const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(
                                color: Color(0xff18786A), fontSize: 22),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.courses.length,
                        itemBuilder: ((context, index) {
                          return MyCoursesCard(
                              userCourse: UserCourse(
                                  completedChapters: 0,
                                  course: state.courses[index],
                                  id: '',
                                  userId: ''));
                        }),
                      );
                    } else if (state is SearchCourseLoadingState) {
                      return const Center(child: CustomProgressIndicator());
                    }
                    return Container();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
