import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/routes/go_routes.dart';
import 'package:prep_genie/features/contest/presentation/bloc/fetch_upcoming_user_contest/fetch_upcoming_user_contest_bloc.dart';
import 'package:prep_genie/features/home/presentation/widgets/time_count_down_for_national_exams.dart';

class CarouselSliderForUpcommingEvents extends StatefulWidget {
  const CarouselSliderForUpcommingEvents({Key? key}) : super(key: key);

  @override
  _CarouselSliderForUpcommingEventsState createState() =>
      _CarouselSliderForUpcommingEventsState();
}

class _CarouselSliderForUpcommingEventsState
    extends State<CarouselSliderForUpcommingEvents> {
  final List<Widget> _carouselItems = [];
  @override
  void initState() {
    super.initState();
    //add contest card if available
    final state = context.read<FetchUpcomingUserContestBloc>().state;
    if (state is UpcomingContestFetchedState &&
        state.upcomingContes != null &&
        state.upcomingContes!.hasRegistered == false) {
      _carouselItems.add(contestCard(contestId: state.upcomingContes!.id));
    }

    //add national exam card
    _carouselItems.add(nationalExamsCard());
  }

  Widget nationalExamsCard() {
    return UpcommingEventsCard(
      title: 'National Exam',
      date: DateTime.now(),
      leftWidget: const CountDownCardForNationalExams(timeLeft: 100),
    );
  }

  Widget contestCard({required String contestId}) {
    final leftWidget = InkWell(
      onTap: () {
        ContestDetailPageRoute(id: contestId).go(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .5.h),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: const Text(
          'Register',
          style: TextStyle(
            color: Color(0xff306496),
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
    return UpcommingEventsCard(
      title: 'SkillBridge Contest 5',
      date: DateTime.now(),
      leftWidget: leftWidget,
    );
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            items: _carouselItems,
            options: CarouselOptions(
              height: 10.h,
              enlargeCenterPage: true,

              viewportFraction: 1.006,
              // enableInfiniteScroll: true,
              autoPlay: _carouselItems.length > 1,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 1.h),
          Container(
              alignment: Alignment.center,
              width: 10.w,
              height: 2.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? const Color(0xff18786a)
                        : Colors.grey.shade300,
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(
                  width: 1.5.w,
                ),
                itemCount: _carouselItems.length,
              )),
        ],
      ),
    );
  }
}

class UpcommingEventsCard extends StatelessWidget {
  const UpcommingEventsCard({
    super.key,
    required this.title,
    required this.date,
    required this.leftWidget,
  });
  final String title;
  final DateTime date;
  final Widget leftWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: const Color(0xff306496),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_on_rounded,
                color: Colors.white,
                size: 25,
              ),
              SizedBox(width: 3.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 45.w,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    DateFormat('EEEE MMMM d, y').format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ],
          ),
          leftWidget,
        ],
      ),
    );
  }
}
