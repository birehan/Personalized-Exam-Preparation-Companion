import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skill_bridge_mobile/core/utils/map_of_location_name.dart';
import 'package:skill_bridge_mobile/core/widgets/floating_button.dart';
import 'package:skill_bridge_mobile/features/question/presentation/bloc/bloc/general_chat_bloc.dart';
import 'package:skill_bridge_mobile/features/question/presentation/pages/general_chat_page.dart';

class DraggableWidget extends StatelessWidget {
  const DraggableWidget({
    super.key,
    required this.router,
    required this.isButtonAvailable,
  });
  final bool isButtonAvailable;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Visibility(
        visible: isButtonAvailable,
        child: InkWell(
          onTap: () {
            final locationInfo = router.location.split('/');
            // print(
            //     'location zero ${locationInfo[0]} locationOne ${locationInfo[1]}');
            final routeName = locationNames[locationInfo[1]] ?? '';
            context.read<GeneralChatBloc>().add(
                  GeneralChatSendEvent(
                    message: '',
                    isFirstChat: true,
                    chatHistory: const [],
                    pageName: routeName,
                  ),
                );
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GeneralChatPage(pageName: routeName),
            ));
          },
          child: const FloatingChatButton(),
        ),
      ),
    );
  }
}
