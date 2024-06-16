import 'package:flutter/material.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/widgets/animated_dragable_widget.dart';
import 'package:prep_genie/features/authentication/data/datasources/authentication_local_datasource.dart';
import 'package:prep_genie/injection_container.dart';

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
