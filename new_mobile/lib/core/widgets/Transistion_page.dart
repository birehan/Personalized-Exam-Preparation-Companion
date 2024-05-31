import 'package:flutter/material.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/core/widgets/animated_dragable_widget.dart';
import 'package:skill_bridge_mobile/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:skill_bridge_mobile/injection_container.dart';

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
