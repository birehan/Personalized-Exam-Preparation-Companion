import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

class CubeAnimationPage extends StatefulWidget {
  const CubeAnimationPage({super.key});

  @override
  State<CubeAnimationPage> createState() => _CubeAnimationPageState();
}

class _CubeAnimationPageState extends State<CubeAnimationPage>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late AnimationController _rotationController;
  late AnimationController _fillController;

  double _sizeValue = 0;
  double _rotationValue = 0;
  final double _fillValue = 100;

  void navigateToHomePage() {
    HomePageRoute().go(context);
  }

  @override
  void initState() {
    super.initState();

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fillController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _sizeController.addListener(() {
      setState(() {
        _sizeValue = _sizeController.value;
      });

      if (_sizeController.status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _fillController.forward().then((_) {
            if (_fillController.isCompleted) {
              Future.delayed(const Duration(milliseconds: 300), () {
                navigateToHomePage();
              });
            }
          });
        });
      }
    });

    _sizeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _sizeController.reverse();
        _rotationController.reverse();
      }
    });

    _fillController.addListener(() {
      setState(() {
        _sizeValue =
            (MediaQuery.of(context).size.height * -_fillController.value) / 8;
      });
    });

    _sizeController.forward();
    _rotationController.forward();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _rotationController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFF1A7A6C)),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: Text(
                  AppLocalizations.of(context)!.setting_up_your_learning_path,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _fillController,
            builder: (context, child) {
              final growSize = _fillValue + 50 * -_sizeValue;

              _rotationValue = -_rotationController.value * 2 * pi;

              //  100 * _growController.value
              return Center(
                child: Transform.rotate(
                  angle: _rotationValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: growSize,
                    height: growSize,
                    child: const SizedBox.shrink(),
                    // child: _fillController.isCompleted
                    //     ? lessonContentWidget()
                    //     : const SizedBox.shrink(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget lessonContentWidget() {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Text(
              AppLocalizations.of(context)!.are_you_ready_for_your_first_lesson,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color(0xFF403D3D),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.let_us_start_learning,
            style: GoogleFonts.poppins(
              color: const Color(0xFF575656),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Image.asset('assets/images/are_you_ready_for_learning.png'),
          const Spacer(),
          InkWell(
            onTap: () {
              // Get department id and fetch all courses there
              context.go(AppRoutes.chooseSubjectPage, extra: false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A7A6C),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                AppLocalizations.of(context)!.start_learning,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Go to home page
              context.go(AppRoutes.myhomePage);
            },
            child: Text(
              AppLocalizations.of(context)!.not_now,
              style: GoogleFonts.poppins(
                color: const Color(0xFF3F3F3F),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
