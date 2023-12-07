part of 'mock_form_bloc.dart';

abstract class MockFormState extends Equatable {
  const MockFormState();
  
  @override
  List<Object> get props => [];
}

class MockFormInitial extends MockFormState {}
