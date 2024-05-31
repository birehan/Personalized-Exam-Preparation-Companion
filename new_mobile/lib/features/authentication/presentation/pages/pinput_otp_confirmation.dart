// import 'package:flutter/material.dart';
// import 'package:pinput/pinput.dart';

// class PinputExample extends StatefulWidget {
//   const PinputExample({Key? key}) : super(key: key);

//   @override
//   State<PinputExample> createState() => _PinputExampleState();
// }

// class _PinputExampleState extends State<PinputExample> {
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();
//   final formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     pinController.dispose();
//     focusNode.dispose();
//     super.dispose();
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     const focusedBorderColor = Color(0xff18786a);
//     const fillColor = Color.fromRGBO(243, 246, 249, 0);
//     final borderColor = const Color(0xff28786a).withOpacity(.5);

//     final defaultPinTheme = PinTheme(
//       width: 50,
//       height: 50,
//       textStyle: const TextStyle(
//         fontSize: 22,
//         color: Color.fromRGBO(30, 60, 87, 1),
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(19),
//         border: Border.all(color: borderColor),
//       ),
//     );

//     /// Optionally you can use form to validate the Pinput
//     return Scaffold(
//       body: FractionallySizedBox(
//         widthFactor: 1,
//         child: Form(
//           key: formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Pinput(
//                 length: 6,
//                 controller: pinController,
//                 focusNode: focusNode,
//                 androidSmsAutofillMethod:
//                     AndroidSmsAutofillMethod.smsUserConsentApi,
//                 listenForMultipleSmsOnAndroid: true,
//                 defaultPinTheme: defaultPinTheme,
//                 separatorBuilder: (index) => const SizedBox(width: 8),
//                 validator: (value) {
//                   return value == '22222' ? null : 'Pin is incorrect';
//                 },
//                 // onClipboardFound: (value) {
//                 //   debugPrint('onClipboardFound: $value');
//                 //   pinController.setText(value);
//                 // },
//                 hapticFeedbackType: HapticFeedbackType.lightImpact,
//                 onCompleted: (pin) {
//                   debugPrint('onCompleted: $pin');
//                 },
//                 onChanged: (value) {
//                   debugPrint('onChanged: $value');
//                 },
//                 cursor: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       margin: const EdgeInsets.only(bottom: 9),
//                       width: 22,
//                       height: 1,
//                       color: focusedBorderColor,
//                     ),
//                   ],
//                 ),
//                 focusedPinTheme: defaultPinTheme.copyWith(
//                   decoration: defaultPinTheme.decoration!.copyWith(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: focusedBorderColor),
//                   ),
//                 ),
//                 submittedPinTheme: defaultPinTheme.copyWith(
//                   decoration: defaultPinTheme.decoration!.copyWith(
//                     color: fillColor,
//                     borderRadius: BorderRadius.circular(19),
//                     border: Border.all(color: focusedBorderColor),
//                   ),
//                 ),
//                 errorPinTheme: defaultPinTheme.copyBorderWith(
//                   border: Border.all(color: Colors.redAccent),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   focusNode.unfocus();
//                   formKey.currentState!.validate();
//                 },
//                 child: const Text('Validate'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
