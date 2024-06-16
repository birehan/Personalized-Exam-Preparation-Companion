import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:prep_genie/core/routes/go_routes.dart';

class SessionExpireAlert extends StatelessWidget {
  const SessionExpireAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 16.h,
              child: Column(
                children: [
                  const Text(
                    'Session Expired',
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 1.h),
                  const Text('Your session has expired. Please log in again.'),
                  const Text('Session Expired'),
                  SizedBox(height: 1.h),
                  TextButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      context
                          .read<TokenSessionBloc>()
                          .add(TokenSessionExpiredEvent());
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        )
        // AlertDialog(
        //   title: const Text('Session Expired'),
        //   content: const Text('Your session has expired. Please log in again.'),
        //   actions: [
        // TextButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //     context.read<TokenSessionBloc>().add(TokenSessionExpiredEvent());
        //   },
        //   child: const Text('OK'),
        // ),
        //   ],
        // ),
        );
  }
}
