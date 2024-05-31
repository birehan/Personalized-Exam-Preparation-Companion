import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/constants/app_enums.dart';
import '../../domain/entities/feedback_messages.dart';
import '../../domain/entities/feedback_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bloc/feedbackBloc/feedback_bloc.dart';

import 'flag_options.dart';

class FlagDialog extends StatefulWidget {
  final String id;
  final FeedbackType feedbackType;
  final int index;
  final BuildContext originalContext;

  const FlagDialog({
    super.key,
    required this.id,
    required this.feedbackType,
    required this.index,
    required this.originalContext
  });

  @override
  _FlagDialogState createState() => _FlagDialogState();
}

class _FlagDialogState extends State<FlagDialog> {
  String selectedOption = '';
  String comment = '';

  final TextEditingController _otherOptionController = TextEditingController();

  @override
  void dispose() {
    _otherOptionController.dispose();
    super.dispose();
  }

  void submitResponse() {
    if (comment == '') return;

    FeedbackEntity feedback = FeedbackEntity(
        id: widget.id, message: comment, feedbackType: widget.feedbackType);
    context
        .read<FeedbackBloc>()
        .add(FeedbackSubmittedEvent(feedback: feedback));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
        // const List<FeedbackMessages> feedbackMessages = [

    List<FeedbackMessages> feedbackMessages = [
      FeedbackMessages(
        type: 'Content',
        messages: [
          AppLocalizations.of(widget.originalContext!)!.inaccurate,
          AppLocalizations.of(widget.originalContext!)!.out_of_Scope,
          AppLocalizations.of(widget.originalContext!)!.too_wide,
          AppLocalizations.of(widget.originalContext!)!.other
        ],
                // messages: ["Inaccurate", "Out of Scope", "Too wide", "Other"],

      ),
      FeedbackMessages(
        type: 'questions',
        messages: [
          AppLocalizations.of(widget.originalContext!)!.no_answers,
          AppLocalizations.of(widget.originalContext!)!.out_of_Scope,
          AppLocalizations.of(widget.originalContext!)!.unrelated_choice,
          AppLocalizations.of(widget.originalContext!)!.other
        ],
                // messages: ["No Answers", "Out of Scope", "Unrelated choice", "Other"],

      ),
      FeedbackMessages(
        type: 'analysis',
        messages: [
          AppLocalizations.of(widget.originalContext!)!.wrong_answer,
          AppLocalizations.of(widget.originalContext!)!.irrelevant,
          AppLocalizations.of(widget.originalContext!)!.wrong_explanation,
          AppLocalizations.of(widget.originalContext!)!.other
        ],
                // messages: ["Wrong Answer", "Irelevant", "wrong Explanation", "Other"],

      )
    ];
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: Theme(
        data: ThemeData(
          dialogBackgroundColor: Colors.white,
          hintColor: Colors.black38,
          primaryColor: Colors.black,
        ),
        child: AlertDialog(
          scrollable: true,
          contentPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                height: 100,
                width: 100,
                image: AssetImage('assets/images/attention.png'),
              ),
              Text(
                AppLocalizations.of(widget.originalContext!)!
                    .do_you_want_to_flag_this_as_inappropriate,
                                    // 'Do you want to flag this as inappropriate?',

                textAlign: TextAlign.center,
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.0,
                  children: feedbackMessages[widget.index].messages.map(
                    (message) {
                      return FlagingChips(
                        isSelected: selectedOption == message,
                        title: message,
                        onSelect: (selected) {
                          setState(() {
                            selectedOption = selected ? message : '';
                            comment = selected ? message : '';
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (selectedOption ==
                    AppLocalizations.of(widget.originalContext!)!.other)
                                    // if (selectedOption == 'Other')

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: TextField(
                      controller: _otherOptionController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                              color: Color(0xff18786A), width: 1),
                        ),
                        hintText: AppLocalizations.of(widget.originalContext!)!
                            .please_mention_other_reason,
                                                // hintText: 'please mention other reason',

                        hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 207, 207, 207)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 1)),
                        // labelText: 'please mention other reason',
                      ),
                      onChanged: (value) {
                        setState(() {
                          comment = value;
                        });
                      },
                      minLines: 5,
                      maxLines: 7,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(2),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                backgroundColor: comment == ''
                    ? MaterialStateProperty.all<Color>(
                        const Color(0xff18786A).withOpacity(.5),
                      )
                    : MaterialStateProperty.all<Color>(
                        const Color(0xff18786A),
                      ),
              ),
              onPressed: submitResponse,
              child: Text(
                // "Submit",
                AppLocalizations.of(widget.originalContext!)!.submit,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
