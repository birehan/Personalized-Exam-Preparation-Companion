import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityService with ChangeNotifier {
  final InternetConnectionChecker _connectivity = InternetConnectionChecker();
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  ConnectivityService() {
    _initialize();
  }

  void _initialize() async {
    _connectivity.onStatusChange.listen((status) {
      bool previousStatus = _isOnline;
      // _isOnline = !result.contains(ConnectivityResult.none);
      _isOnline = status == InternetConnectionStatus.connected;

      if (previousStatus != _isOnline) {
        notifyListeners();
      }
    });

    _isOnline = await _connectivity.hasConnection;
  }
}
