part of 'locale_bloc.dart';

class LocaleState extends Equatable {
  final String currentLocale;
  const LocaleState({this.currentLocale = 'en'});

  @override
  List<Object> get props => [
        currentLocale,
      ];
}
