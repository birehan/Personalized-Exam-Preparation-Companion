import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/bloc/routerBloc/router_bloc.dart';
import 'package:skill_bridge_mobile/core/widgets/dragable.dart';

class AnimatedDraggableWidget extends StatefulWidget {
  const AnimatedDraggableWidget({super.key});

  @override
  State<AnimatedDraggableWidget> createState() =>
      _AnimatedDraggableWidgetState();
}

class _AnimatedDraggableWidgetState extends State<AnimatedDraggableWidget> {
  Offset _fabPosition = Offset(100.w - 35.w, 100.h - 25.h);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouterBloc, RouterState>(
      builder: (context, state) {
        if (state is RouterPopulatedState) {
          final r = state.router;
          return AnimatedPositioned(
            left: _fabPosition.dx,
            top: _fabPosition.dy,
            duration: const Duration(milliseconds: 0),
            curve: Curves.easeInOut,
            child: Draggable<Widget>(
              feedback: Material(
                color: Colors.transparent,
                child: DraggableWidget(
                  router: r,
                  isButtonAvailable: state.buttonVisibiliy,
                ),
              ),
              child: DraggableWidget(
                router: r,
                isButtonAvailable: state.buttonVisibiliy,
              ),
              onDragUpdate: (details) {
                setState(() {
                  // _isDragging = true;
                  final newPosition = Offset(
                    _fabPosition.dx + details.delta.dx,
                    _fabPosition.dy + details.delta.dy,
                  );
                  // Constrain movement within screen boundaries
                  final newX = newPosition.dx.clamp(0.0, 100.w - 56.0);
                  final newY = newPosition.dy.clamp(0.0, 100.h - 56.0);
                  _fabPosition = Offset(newX, newY);
                });
              },
              onDragEnd: (details) {
                setState(() {
                  // _isDragging = false;
                });
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
