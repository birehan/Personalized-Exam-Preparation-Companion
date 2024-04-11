import 'package:flutter/material.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/core/widgets/animated_dragable_widget.dart';
import 'package:prepgenie/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:prepgenie/injection_container.dart';

class TransitionWithDragableIcon extends StatelessWidget {
  const TransitionWithDragableIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppRouter(
          localDatasource: serviceLocator<AuthenticationLocalDatasource>(),
          context: context,
        ),
        const AnimatedDraggableWidget()
      ],
    );
  }
}
