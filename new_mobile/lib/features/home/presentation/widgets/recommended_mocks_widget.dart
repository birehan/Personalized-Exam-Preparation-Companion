import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/constants/constants.dart';
import 'package:skill_bridge_mobile/features/home/presentation/widgets/recommended_empty_list.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecommendedMocksWidget extends StatelessWidget {
  final String stream;
  const RecommendedMocksWidget({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.science_outlined,
      Icons.coronavirus,
      Icons.all_inclusive
    ];
    List<Color> colors = const [
      Color(0xFF4ECDC4),
      Color(0xFF34495E),
      Color(0xFF3497DA),
    ];

    return Column(
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.recommended_model_exams,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.help_outline_outlined,
              color: Color(0xFF646262),
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is GetHomeState && state.status == HomeStatus.loaded) {
                if (state.recommendedMocks!.isEmpty) {
                  return const RecommendedEmptyListWidget();
                }
                return Row(
                  children:
                      List.generate(state.recommendedMocks!.length, (index) {
                    String subject = state.recommendedMocks![index].subject;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: RecommendedMockCard(
                        examId: state.recommendedMocks![index].id,
                        examYear: state.recommendedMocks![index].examYear,
                        subject: state.recommendedMocks![index].subject,
                        numberOfQuestions:
                            state.recommendedMocks![index].numberOfQuestions,
                        icon: icons[index % 3],
                        //! change the implementation
                        image: stream == "Natural Science"
                            ? naturalSubjectImagesMap
                                    .containsKey(subject.toLowerCase())
                                ? naturalSubjectImagesMap[
                                    subject.toLowerCase()]!
                                : 'assets/images/robot.png'
                            : socialSubjectImagesMap
                                    .containsKey(subject.toLowerCase())
                                ? socialSubjectImagesMap[subject.toLowerCase()]!
                                : 'assets/images/robot.png',
                        iconBackgroundColor: colors[index % 3],
                      ),
                    );
                  }),
                );
              } else if (state is GetHomeState &&
                  state.status == HomeStatus.loading) {
                return _shimmerRecommendedCard();
              } else if (state is GetHomeState &&
                  state.status == HomeStatus.error) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.error_loading),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  _shimmerRecommendedCard() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 25.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 2.h,
                        height: 2.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Container(
                        width: 20.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
