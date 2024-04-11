import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_bridge_mobile/core/constants/app_keys.dart';

part 'locale_event.dart';
part 'locale_state.dart';

// class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
//   final FlutterSecureStorage flutterSecureStorage;

//   LocaleBloc({required this.flutterSecureStorage})
//       : super(
//           const LocaleState(currentLocale: 'en'),
//         ) {
//     on<ChangeLocaleEvent>((event, emit) {
//       emit(LocaleState(currentLocale: event.locale));
//     });
//   }
// }
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final FlutterSecureStorage flutterSecureStorage;

  LocaleBloc({required this.flutterSecureStorage})
      : super(
          const LocaleState(currentLocale: 'en'),
        ) {
    _initializeLocale();
    on<ChangeLocaleEvent>(
      (event, emit) {
        emit(LocaleState(currentLocale: event.locale));
        // update the chache
        flutterSecureStorage.write(
          key: languageKey,
          value: json.encode({'locale': event.locale}),
        );
      },
    );
  }

  // Helper method to initialize the locale from flutterSecureStorage
  void _initializeLocale() async {
    final cachedLanguage = await flutterSecureStorage.read(key: languageKey);
    if (cachedLanguage != null) {
      final language = json.decode(cachedLanguage);
      add(ChangeLocaleEvent(locale: language['locale']));
    }
  }
}
