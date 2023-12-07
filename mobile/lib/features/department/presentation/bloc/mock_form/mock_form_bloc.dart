import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'mock_form_event.dart';
part 'mock_form_state.dart';

class MockFormBloc extends Bloc<MockFormEvent, MockFormState> {
  MockFormBloc() : super(MockFormInitial()) {
    on<MockFormEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
