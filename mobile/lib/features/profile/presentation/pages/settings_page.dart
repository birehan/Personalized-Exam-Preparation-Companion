// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import '../../../../core/core.dart';
// import '../../../authentication/presentation/bloc/get_user_bloc/get_user_bloc.dart';
// import '../../../features.dart';
// import '../../domain/entities/user_profile_entity.dart';
// import '../bloc/logout/logout_bloc.dart';
// import '../bloc/profileBloc/profile_bloc.dart';

// import '../../../../core/constants/app_keys.dart';
// import '../widgets/custom_input_field.dart';
// import '../widgets/custom_text_button.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // context.read<AuthenticationBloc>().add(AuthenticatedWithGoogleEvent());
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     lastNameController.dispose();
//     emailController.dispose();
//     super.dispose();
//   }

  // File? _image;
  // final imageUploader = ImageUploader();
  // void upload(ImageSource source) async {
  //   File? uploadedImage = await imageUploader.getImage(source);
  //   if (uploadedImage == null) return;
  //   setState(() {
  //     _image = uploadedImage;
  //   });
  // }

  // Future chooseOption() => showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           insetPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
  //           elevation: 1,
  //           alignment: Alignment.bottomCenter,
  //           backgroundColor: Colors.white,
  //           child: SizedBox(
  //             height: 15.h,
  //             child: Column(
  //               children: [
  //                 CustomTextButtons(
  //                   source: ImageSource.camera,
  //                   icon: Icons.photo_camera,
  //                   text: 'Camera',
  //                   context: context,
  //                   upload: upload,
  //                 ),
  //                 const Divider(color: Colors.grey, height: 2),
  //                 CustomTextButtons(
  //                   source: ImageSource.gallery,
  //                   icon: Icons.image,
  //                   text: 'Gallery',
  //                   context: context,
  //                   upload: upload,
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     );

  // void _showProfileImageDialog(BuildContext context, String image) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         child: SizedBox(
  //           height: 40.h,
  //           width: 80.w,
  //           child: Image.network(image, fit: BoxFit.cover),
  //         ),
  //       );
  //     },
  //   );
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         MultiBlocListener(
//           listeners: [
//             BlocListener<LogoutBloc, LogoutState>(
//                 listener: (context, logoutState) {
//               if (logoutState is LogedOutState) {
//                 context.go(AppRoutes.login);
//               } else if (logoutState is LogOutFailedState) {
//                 final snackBar =
//                     SnackBar(content: Text(logoutState.errorMessage));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             }),
//             BlocListener<ProfileBloc, ProfileState>(
//                 listener: (context, profofileState) {
//               if (profofileState is ProfileUpdatedState) {
//                 const snackBar = SnackBar(
//                     content: Text(
//                   'Successfully Updated',
//                   style: TextStyle(color: Colors.green),
//                 ));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                 context.read<GetUserBloc>().add(GetUserCredentialEvent());
//                 context.go(AppRoutes.myhomePage);
//               } else if (profofileState is ProfileUpdateFailedState) {
//                 const snackBar = SnackBar(
//                     content: Text('Somethings went wrong, try again!'));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               }
//             })
//           ],
//           child: Scaffold(
//               // bottomNavigationBar: const MyBottomNavigation(
//               //   index: 2,
//               // ),
//               appBar: AppBar(
//                 toolbarHeight: 10.h,
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 title: const Text(
//                   'Profile',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Poppins'),
//                 ),
//                 centerTitle: true,
//               ),
//               body: FutureBuilder<String>(
//                 future: _getUserModel(),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<String> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator(); // or any other loading indicator
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     var userModel = json.decode(snapshot.data!);

//                     firstNameController.text = userModel['firstName'] ?? 'Jon';
//                     lastNameController.text = userModel['lastName'] ?? 'Doe';
//                     emailController.text =
//                         userModel['email'] ?? 'jon@gmail.com';

//                     String? imageAdress = userModel['profileAvatar'];

//                     return Padding(
//                       padding: EdgeInsets.only(
//                           left: 10.w, right: 10.w, top: 10.w, bottom: 2.w),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 Stack(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
                                        // _showProfileImageDialog(context, imageAdress!);
//                                       },
//                                       child: Container(
//                                           height: 17.h,
//                                           width: 17.h,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(17.h),
//                                             // boxShadow: const [
//                                             //   BoxShadow(
//                                             //       blurRadius: 2,
//                                             //       color: Colors.grey,
//                                             //       offset: Offset(1, 5)),
//                                             // ],
//                                             image: DecorationImage(
//                                                 fit: BoxFit.cover,
//                                                 image: _image != null
//                                                     ? FileImage(_image!)
//                                                     : imageAdress != null
//                                                         ? NetworkImage(
//                                                             imageAdress)
//                                                         : const AssetImage(
//                                                                 'assets/images/profile_avatar.jpg')
//                                                             as ImageProvider<
//                                                                 Object>),
//                                           )),
//                                     ),
//                                     Positioned(
//                                       bottom: 0,
//                                       right: 0,
//                                       child: InkWell(
//                                         onTap: () {
//                                           chooseOption();
//                                         },
//                                         child: Container(
//                                           padding: EdgeInsets.all(1.h),
//                                           decoration: BoxDecoration(
//                                               color: const Color(0XFF18786A),
//                                               borderRadius:
//                                                   BorderRadius.circular(8)),
//                                           child: const Icon(
//                                             Icons.edit,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 5.h,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       'First Name',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(
//                                       height: 1.5.h,
//                                     ),
//                                     CustomInputFieldProfile(
//                                       controller: firstNameController,
//                                       filled: false,
//                                       visibleBorder: true,
//                                       enabled: true,
//                                       hintText: firstNameController.text,
//                                     ),
//                                     SizedBox(height: 3.h),
//                                     const Text(
//                                       'Last Name',
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(
//                                       height: 1.5.h,
//                                     ),
//                                     CustomInputFieldProfile(
//                                       controller: lastNameController,
//                                       filled: false,
//                                       visibleBorder: true,
//                                       enabled: true,
//                                       hintText: lastNameController.text,
//                                     ),
//                                     SizedBox(height: 3.h),
//                                     const Text(
//                                       'Email Address',
//                                       style: TextStyle(
//                                           fontFamily: 'Poppins',
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     SizedBox(height: 1.5.h),
//                                     CustomInputFieldProfile(
//                                       filled: true,
//                                       visibleBorder: true,
//                                       enabled: false,
//                                       hintText: emailController.text,
//                                       controller: emailController,
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 12.h,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       final UserProfile editedProfile =
//                                           UserProfile(
//                                         email: emailController.text,
//                                         firstName: firstNameController.text,
//                                         lastName: lastNameController.text,
//                                         imagePath: _image,
//                                       );

//                                       context.read<ProfileBloc>().add(
//                                             UpdateUserProfileEvent(
//                                                 userProfile: editedProfile),
//                                           );
//                                       context.go(AppRoutes.myhomePage);
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.edit,
//                                             size: 18.sp,
//                                             color: Colors.blue,
//                                           ),
//                                           SizedBox(width: 2.w),
//                                           Text(
//                                             'Save',
//                                             style: TextStyle(
//                                                 color: Colors.blue,
//                                                 fontSize: 16.sp,
//                                                 fontWeight: FontWeight.w500),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: InkWell(
//                                     onTap: () {
//                                       // BlocListener<AuthenticationBloc,
//                                       //     AuthenticationState>(
//                                       //   listener: (context, state) {
//                                       //     if (state
//                                       //             is AuthenticatedWithGoogleState &&
//                                       //         state.status ==
//                                       //             AuthStatus.loaded &&
//                                       //         state.isAuthenticated == true) {
//                                       //       print(
//                                       //           'Google Authentication Active...');
//                                       //       context
//                                       //           .read<AuthenticationBloc>()
//                                       //           .add(SignOutWithGoogleEvent());
//                                       //     }
//                                       //   },
//                                       // );
//                                       context
//                                           .read<LogoutBloc>()
//                                           .add(DispatchLogoutEvent());
//                                     },
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Icon(
//                                             Icons.logout,
//                                             color: const Color.fromARGB(
//                                                 255, 255, 94, 0),
//                                             size: 18.sp,
//                                           ),
//                                           SizedBox(width: 2.w),
//                                           Text(
//                                             'LogOut',
//                                             style: TextStyle(
//                                                 color: const Color.fromARGB(
//                                                     255, 255, 94, 0),
//                                                 fontSize: 16.sp,
//                                                 fontWeight: FontWeight.w500),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   }
//                 },
//               )),
//         ),
//         BlocBuilder<ProfileBloc, ProfileState>(
//           builder: (context, state) {
//             if (state is ProfileUpdatingState) {
//               return Positioned(
//                   top: 0,
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     alignment: Alignment.center,
//                     color: Colors.black12,
//                     child: const CustomProgressIndicator(),
//                   ));
//             }
//             return Container();
//           },
//         ),
//         BlocBuilder<LogoutBloc, LogoutState>(
//           builder: (context, state) {
//             if (state is LoagingOutState) {
//               return Positioned(
//                   top: 0,
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     alignment: Alignment.center,
//                     color: Colors.black12,
//                     child: const CustomProgressIndicator(),
//                   ));
//             }
//             return Container();
//           },
//         )
//       ],
//     );
//   }

//   Future<String> _getUserModel() async {
//     var flutterSecureStorage = const FlutterSecureStorage();
//     var userModelString =
//         await flutterSecureStorage.read(key: authenticationKey);
//     return userModelString!;
//   }
// }
