import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'exam_date_event.dart';
part 'exam_date_state.dart';

class GetExamDateBloc extends Bloc<GetExamDateEvent, GetExamDateState> {
  final GetExamDateUsecase getExamDateUsecase;

  GetExamDateBloc({
    required this.getExamDateUsecase,
  }) : super(GetExamDateInitial()) {
    on<GetExamDateEvent>(_onGetExamDate);
  }

  void _onGetExamDate(
      GetExamDateEvent event, Emitter<GetExamDateState> emit) async {
    emit(const ExamDateState(status: GetExamDateStatus.loading));
    final failureOrExamDate = await getExamDateUsecase(NoParams());
    emit(_onExamDateOrFailure(failureOrExamDate));
  }

  GetExamDateState _onExamDateOrFailure(
      Either<Failure, List<ExamDate>> failureOrExamDate) {
    return failureOrExamDate.fold(
      (l) => ExamDateState(
          status: GetExamDateStatus.error, errorMessage: l.errorMessage),
      (targetDate) => ExamDateState(
        status: GetExamDateStatus.loaded,
        targetDate: targetDate.isEmpty
            ? ExamDate(
                id: '',
                date: DateTime.now(),
              )
            : targetDate[0],
      ),
    );
  }
}
