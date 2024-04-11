import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/usecase/usecase.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/presentation/bloc/logout/logout_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'logout_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProfileLogoutUsecase>()])
void main() {
  late MockProfileLogoutUsecase mockProfileLogoutUsecase;

  setUp(() {
    mockProfileLogoutUsecase = MockProfileLogoutUsecase();
  });
  blocTest<LogoutBloc, LogoutState>(
    'emits [LoadingOutState, LoggedOutState] when DispatchLogoutEvent is added and logout successful',
    build: () => LogoutBloc(logoutUsecase: mockProfileLogoutUsecase),
    act: (bloc) => bloc.add(DispatchLogoutEvent()),
    setUp: () => when(mockProfileLogoutUsecase(any))
        .thenAnswer((_) async => const Right(true)),
    expect: () => [
      LoagingOutState(),
      LogedOutState(),
    ],
    verify: (_) {
      verify(mockProfileLogoutUsecase(any)).called(1);
    },
  );
}
