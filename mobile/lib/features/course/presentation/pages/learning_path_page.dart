import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/progress_indicator.dart';
import '../../../chapter/chapter.dart';
import '../../../chapter/domain/entities/sub_chapters_list.dart';
import '../../../chapter/presentation/bloc/subChapterBloc/sub_chapter_bloc.dart';
import '../widgets/sub_chapter_node.dart';
import '../widgets/vertical_dots.dart';

class LearningPathScreen extends StatefulWidget {
  final UserChapterAnalysis userChapterAnalysis;
  const LearningPathScreen({
    super.key,
    required this.userChapterAnalysis,
  });

  @override
  _LearningPathScreenState createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  @override
  Widget build(BuildContext context) {
    // const subChapterList = [
    //   {
    //     "title": "Sub Chapter 1",
    //     "description":
    //         "Sub chapter one deals with the sub chapter one's topics",
    //     "done": true,
    //   },
    //   {
    //     "title": "Sub Chapter 2",
    //     "description":
    //         "Sub chapter two focuses on the key concepts of sub chapter two",
    //     "done": true,
    //   },
    //   {
    //     "title": "Sub Chapter 3",
    //     "description":
    //         "Sub chapter three explores various aspects related to sub chapter three",
    //     "done": true,
    //   },
    //   {
    //     "title": "Sub Chapter 4",
    //     "description":
    //         "Sub chapter four delves into advanced topics within sub chapter four",
    //     "done": false
    //   },
    //   {
    //     "title": "Sub Chapter 5",
    //     "description":
    //         "Sub chapter five examines practical examples and use cases",
    //     "done": false
    //   },
    //   {
    //     "title": "Sub Chapter 6",
    //     "description":
    //         "Sub chapter six discusses best practices and tips for sub chapter six",
    //     "done": false
    //   },
    //   {
    //     "title": "Sub Chapter 7",
    //     "description":
    //         "Sub chapter seven analyzes case studies and real-world scenarios",
    //     "done": false
    //   },
    //   {
    //     "title": "Sub Chapter 8",
    //     "description":
    //         "Sub chapter eight concludes with a summary and final thoughts",
    //     "done": false
    //   }
    // ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Text(
            widget.userChapterAnalysis.chapter.name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: BlocBuilder<ChapterBloc, ChapterState>(
          builder: (context, state) {
            if (state is SubChaptersLoadingState) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            } else if (state is SubChaptersFailedState) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is SubChaptersLoadedState) {
              List<SubChapterList> subChapters =
                  state.subChapters.subChapterList;
              List<String> completedSubChapters =
                  state.subChapters.completedSubchapters;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: subChapters.length,
                itemBuilder: (context, index) {
                  final String title = subChapters[index].subChapterName;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<SubChapterBloc>().add(
                                GetSubChapterContentsEvent(
                                  subChapterId: subChapters[index].id,
                                ),
                              );
                          context.push(AppRoutes.contentpage,
                              extra: widget.userChapterAnalysis);
                        },
                        child: SubChapterNode(
                          isDone: completedSubChapters
                              .contains(subChapters[index].id),
                          left: index % 2 == 0,
                          number: (index + 1).toString(),
                          title: title,
                          description: '',
                        ),
                      ),
                      if (index < subChapters.length - 1)
                        VerticalDots(
                          color: completedSubChapters
                                  .contains(subChapters[index].id)
                              ? const Color(0xff18786A)
                              : Colors.grey,
                        ),
                    ],
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

//unused code to make
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff18786A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Define the starting and ending points for the line
    final startPoint = Offset(size.width, 0);
    final endPoint = Offset(0, size.height);

    // Add a curved line segment to the path
    final controlPoint = Offset(size.width * .1, size.height * .7);
    final controlPoint2 = Offset(size.width * .1, size.height * .8);

    path.moveTo(startPoint.dx, startPoint.dy);
    path.arcToPoint(Offset(size.width * 0.8, size.height * 0.4),
        radius: const Radius.circular(50));
    path.cubicTo(
      controlPoint.dx,
      controlPoint.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // // Create a dashed path effect
    // final dashPath = Path();
    // dashPath.moveTo(startPoint.dx, startPoint.dy);
    // dashPath.lineTo(endPoint.dx, endPoint.dy);

    // // Define the properties for the dashed line
    // final dashWidth = 5;
    // final dashSpace = 5;
    // final intervals = [dashWidth, dashSpace];

    // // Apply the dashed path effect to the paint
    // paint.pathEffect = DashPathEffect(intervals: intervals);

    // Draw the dashed line on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
