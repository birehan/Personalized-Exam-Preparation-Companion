import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'mock_question_event.dart';
part 'mock_question_state.dart';

class MockQuestionBloc extends Bloc<MockQuestionEvent, MockQuestionState> {
  final GetMockExamByIdUsecase getMockExamByIdUsecase;

  MockQuestionBloc({
    required this.getMockExamByIdUsecase,
  }) : super(MockQuestionInitial()) {
    on<GetMockByIdEvent>(_onGetMockById);
    on<GetMockAnalysisEvent>(_onGetMockAnalysis);
    on<LoadMockPageEvent>(_onLoadMockPage);
  }

  void _onGetMockById(
      GetMockByIdEvent event, Emitter<MockQuestionState> emit) async {
    emit(const GetMockExamByIdState(status: MockQuestionStatus.loading));
    final failureOrMockQuestion = await getMockExamByIdUsecase(
      MockExamParams(id: event.id, pageNumber: 1),
    );

    emit(_onMockExamByIdOrFailure(
        failureOrMockQuestion, event.numberOfQuestions));
  }

  MockQuestionState _onMockExamByIdOrFailure(
      Either<Failure, Mock> failureOrMockQuestion, int numOfQuestions) {
    return failureOrMockQuestion.fold(
        (failure) => GetMockExamByIdState(status: MockQuestionStatus.error, failure: failure),
        (mock) {
      int totalAvailableCount = numOfQuestions; // should be taken from backend
      int currentLoadedAmmount = mock.mockQuestions.length;
      //dummy data
      const dummyMock = MockQuestion(
        question: Question(
            isLiked: true,
            id: 'dummyData',
            courseId: 'dummyData',
            chapterId: 'dummyData',
            subChapterId: 'dummyData',
            description: 'dummyData',
            choiceA: 'dummyData',
            choiceB: 'dummyData',
            choiceC: 'dummyData',
            choiceD: 'dummyData',
            answer: 'dummyData',
            explanation: 'dummyData',
            isForQuiz: false),
        userAnswer: UserAnswer(
            userId: 'dummyData',
            questionId: 'dummyData',
            userAnswer: 'dummyData'),
      );
      // populate the rest of the fields with dummy data
      List<MockQuestion> dummyMockQuestionItems = List.generate(
          totalAvailableCount - currentLoadedAmmount, (index) => dummyMock);
      // append on top the fetched mock items
      mock.mockQuestions.addAll(dummyMockQuestionItems);
      return GetMockExamByIdState(
        status: MockQuestionStatus.loaded,
        mock: mock,
      );
    });
  }

  void _onLoadMockPage(
      LoadMockPageEvent event, Emitter<MockQuestionState> emit) async {
    final priviousState = state;
    if (priviousState is GetMockExamByIdState &&
        priviousState.status == MockQuestionStatus.loaded) {
      Mock privousMock = priviousState.mock!;
      emit(const GetMockExamByIdState(status: MockQuestionStatus.loading));

      //load the next 10 items from backend
      final failureOrMockQuestion = await getMockExamByIdUsecase(
        MockExamParams(id: event.id, pageNumber: event.pageNumber),
      );

      //fold
      failureOrMockQuestion.fold(
          (l) => emit(
              const GetMockExamByIdState(status: MockQuestionStatus.error)),
          (mock) {
        //here replace dummy section of the mocks with loaded content
        List<MockQuestion> priviousMocksQuestions = privousMock.mockQuestions;
        // this handles the last page index issues
        if (mock.mockQuestions.length < 10) {
          priviousMocksQuestions.replaceRange(((event.pageNumber - 1) * 10),
              priviousMocksQuestions.length, mock.mockQuestions);
        } else {
          priviousMocksQuestions.replaceRange(((event.pageNumber - 1) * 10),
              event.pageNumber * 10, mock.mockQuestions);
        }

        Mock updatedMock = Mock(
            id: privousMock.id,
            name: privousMock.name,
            userId: privousMock.userId,
            mockQuestions: priviousMocksQuestions);
        emit(GetMockExamByIdState(
            status: MockQuestionStatus.loaded, mock: updatedMock));
      });
    }
  }

  void _onGetMockAnalysis(
      GetMockAnalysisEvent event, Emitter<MockQuestionState> emit) async {
    emit(const GetMockAnalysisState(status: MockQuestionStatus.loading));
    final failureOrMockQuestion = await getMockExamByIdUsecase(
      MockExamParams(id: event.id, pageNumber: 1),
    );
    emit(_onMockAnalysisOrFailure(failureOrMockQuestion));
  }

  MockQuestionState _onMockAnalysisOrFailure(
      Either<Failure, Mock> failureOrMockQuestion) {
    return failureOrMockQuestion.fold(
      (l) => const GetMockAnalysisState(status: MockQuestionStatus.error),
      (mock) => GetMockAnalysisState(
        status: MockQuestionStatus.loaded,
        mock: mock,
      ),
    );
  }
}
