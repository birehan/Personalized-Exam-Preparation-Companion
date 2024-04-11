import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/core/widgets/noInternet.dart';
import 'package:prepgenie/features/contest/presentation/bloc/contest_ranking_bloc/contest_ranking_bloc.dart';
import '../../../features.dart';

class ContestRankingSection extends StatelessWidget {
  const ContestRankingSection({
    super.key,
    required this.contestId,
  });

  final String contestId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContestRankingBloc, ContestRankingState>(
      builder: (context, state) {
        if (state is ContestRankingFailedState) {
          if (state.failureType.errorMessage != "No internet connection") {
            return Text(state.failureType.errorMessage);
          }
          return NoInternet(
            reloadCallback: () {
              context
                  .read<ContestRankingBloc>()
                  .add(GetContestRankingEvent(contestId: contestId));
            },
          );
        } else if (state is ContestRankingLoadingState) {
          return const Center(
            child: CustomProgressIndicator(),
          );
        } else if (state is ContestRankingLoadedState) {
          final rankings = state.ranking;
          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<ContestRankingBloc>()
                  .add(GetContestRankingEvent(contestId: contestId));
            },
            child: rankings.contestRankEntities.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EmptyListWidget(
                        showImage: false,
                        message: 'No rank for the contest yet...',
                        reloadCallBack: () {
                          context.read<ContestRankingBloc>().add(
                              GetContestRankingEvent(contestId: contestId));
                        },
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (rankings.userRank != null &&
                            rankings.userRank!.rank != -1)
                          Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF1A7A6C).withOpacity(0.13),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                    bottom: Radius.circular(0),
                                  ),
                                ),
                                child: UserRankCard(
                                  contestRankEntity:
                                      rankings.userRank!.contestRankEntity,
                                  rank: rankings.userRank!.rank,
                                ),
                              ),
                              Container(
                                height: 1,
                                color: const Color(0xFFE4E4E4),
                              ),
                            ],
                          ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rankings.contestRankEntities.length,
                          separatorBuilder: (context, index) => Container(
                            height: 1,
                            color: const Color(0xFFE4E4E4),
                          ),
                          itemBuilder: (context, index) => Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(index == 0 ? 4 : 0),
                                bottom: Radius.circular(index == 4 ? 4 : 0),
                              ),
                            ),
                            child: UserRankCard(
                                contestRankEntity:
                                    rankings.contestRankEntities[index],
                                rank: index + 1),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }
        return Container();
      },
    );
  }
}

class UserRankCard extends StatelessWidget {
  const UserRankCard({
    super.key,
    required this.contestRankEntity,
    required this.rank,
  });

  final ContestRankEntity contestRankEntity;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$rank',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(contestRankEntity.avatar),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: Text(
                '${contestRankEntity.firstName} ${contestRankEntity.lastName}',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.5,
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    timeFormatCalculate(contestRankEntity.endsAt
                        .difference(contestRankEntity.startsAt)),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Color(0xFFE5E5E5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.star_rounded,
            color: Color(0xFF8F8F8F),
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          contestRankEntity.score.toString(),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
