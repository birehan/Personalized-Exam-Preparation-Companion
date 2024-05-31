// import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:skill_bridge_mobile/core/core.dart';

// class NetworkFailureWidget extends StatefulWidget {
//   const NetworkFailureWidget({
//     super.key,
//     required this.onRefresh,
//     required this.child,
//   });

//   final Function() onRefresh;
//   final Widget child;

//   @override
//   State<NetworkFailureWidget> createState() => _NetworkFailureWidgetState();
// }

// class _NetworkFailureWidgetState extends State<NetworkFailureWidget> {
//   late bool _isConnected;
//   late InternetConnectionChecker _connectionChecker;

//   @override
//   void initState() async {
//     super.initState();
//     _isConnected = true;
//     _connectionChecker = InternetConnectionChecker();
//     // _connectionChecker.onStatusChange.listen((status) {
//     setState(() {
//       _isConnected = await _connectionChecker.isConnected;
//     });
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return !_isConnected
//         ? EmptyListWidget(
//             showImage: false,
//             message: 'Network failure, check your connection',
//             reloadCallBack: widget.onRefresh,
//           )
//         : widget.child;
//   }
// }
