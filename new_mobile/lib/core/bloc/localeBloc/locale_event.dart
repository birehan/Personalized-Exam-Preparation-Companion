part of 'locale_bloc.dart';

class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class ChangeLocaleEvent extends LocaleEvent {
  final String locale;

  const ChangeLocaleEvent({required this.locale});
}
