import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/widgets/noInternet.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/changeUsernameBloc/username_event.dart';
import 'package:prep_genie/features/profile/presentation/bloc/changeUsernameBloc/username_state.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_state.dart';

import 'package:prep_genie/features/profile/presentation/widgets/AccountComponent.dart';
import 'package:prep_genie/features/profile/presentation/widgets/changePassword.dart';
import 'package:prep_genie/features/profile/presentation/widgets/changeUsername.dart';
import 'package:prep_genie/features/profile/presentation/widgets/message_display.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../domain/entities/user_leaderboard_entity.dart';
import '../bloc/userProfile/userProfile_event.dart';
import '../bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/user_records_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // context.read<UserProfileBloc>().add(GetUserProfile());
    BlocProvider.of<UserProfileBloc>(context)
        .add(GetUserProfile(isRefreshed: false));
  }

  File? _image;
  final imageUploader = ImageUploader();
  void upload(ImageSource source) async {
    File? uploadedImage = await imageUploader.getImage(source);
    if (uploadedImage == null) return;
    setState(() {
      _image = uploadedImage;
    });
    _imageSubmitPopup(uploadedImage);
  }

  Future chooseOption() => showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            insetPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
            elevation: 1,
            alignment: Alignment.bottomCenter,
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 15.h,
              child: Column(
                children: [
                  CustomTextButtons(
                    source: ImageSource.camera,
                    icon: Icons.photo_camera,
                    text: 'Camera',
                    context: context,
                    upload: upload,
                  ),
                  const Divider(color: Colors.grey, height: 2),
                  CustomTextButtons(
                    source: ImageSource.gallery,
                    icon: Icons.image,
                    text: 'Gallery',
                    context: context,
                    upload: upload,
                  )
                ],
              ),
            ),
          );
        },
      );

  void _imageSubmitPopup(File uploadedImage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.black38,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    fit: BoxFit.cover,
                    height: 45.h,
                    width: 80.w,
                    image: FileImage(uploadedImage),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF0072FF),
                      ),
                      child: TextButton(
                        child: const Text('Cancel',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins')),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF0072FF),
                      ),
                      child: TextButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Poppins'),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                  ],
                )
              ],
            ),
          );
        });
  }

  void navigateToLogin(Completer<void> completer, BuildContext context) async {
    await completer.future;
    // ignore: use_build_context_synchronously
    LoginPageRoute().go(context);
  }

  final NetworkInfo networkInfo =
      NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker());
  @override
  Widget build(BuildContext context) {
    final Finalwidth = MediaQuery.of(context).size.width;
    final Finalheight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<UsernameBloc, UsernameState>(
          listener: (context, state) {
            if (state is Loaded || state is UserProfileUpdatedState) {
              context
                  .read<UserProfileBloc>()
                  .add(GetUserProfile(isRefreshed: true));
              context.read<GetUserBloc>().add(GetUserCredentialEvent());
            }
          },
        ),
        BlocListener<TokenSessionBloc, TokenSessionState>(
          listener: (context, state) {
            if (state is TokenSessionExpiredState) {
              LoginPageRoute().go(context);
            }
          },
        ),
      ],
      child: Scaffold(
          backgroundColor: const Color(0xFFFCFCFC),
          body: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, state) {
              if (state is ProfileEmpty) {
                return const MessageDisplay(
                  message: 'Page Empty!',
                );
              } else if (state is ProfileLoading) {
                return _profilePageShimmer();
              } else if (state is ProfileLoaded) {
                // return _profilePageShimmer();
                return RefreshIndicator(
                  onRefresh: () async {
                    if (await networkInfo.isConnected) {
                      BlocProvider.of<UserProfileBloc>(context)
                          .add(GetUserProfile(isRefreshed: true));
                      return;
                    }
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    const snackBar =
                        SnackBar(content: Text('you are not connected'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Stack(
                        children: [
                          Container(
                            height: 44.h,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFC3EED3),
                                    Color(0xffE1ECE9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 1.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        context.pop();
                                      },
                                      icon: const Icon(Icons.arrow_back)),
                                  Text(
                                    'Profile',
                                    style: GoogleFonts.poppins(
                                        color: const Color(0xFF2E2C2C),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        height: 1.75),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.abc,
                                          color: Colors.transparent))
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Stack(children: [
                                Center(
                                  child: ClipOval(
                                      child: Container(
                                    color: Colors.black26,
                                    child: Image(
                                      width: 129.0,
                                      height: 129.0,
                                      fit: BoxFit
                                          .cover, // You can use BoxFit to control how the image is fitted inside the circle
                                      image: CachedNetworkImageProvider(
                                        state.userProfile.profileImage,
                                      ),
                                    ),
                                  )),
                                ),
                                Center(
                                  child:
                                      BlocBuilder<UsernameBloc, UsernameState>(
                                    builder: (context, state) {
                                      if (state is ProfileUpdateOnProgress) {
                                        return const CustomProgressIndicator(
                                          size: 34,
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 96,
                                  left: 235,
                                  child: GestureDetector(
                                    onTap: () {
                                      chooseOption();
                                    },
                                    child: Image.asset(
                                      'assets/images/edit_Icon.png', // Replace with your local asset path for the edit icon
                                      width:
                                          30.89, // Set the width of the edit icon
                                      height:
                                          30.8, // Set the height of the edit icon
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(height: 2.h),
                              Text(
                                "${state.userProfile.firstName} ${state.userProfile.lastName}",
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF1C1B1B),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5),
                              ),
                              SizedBox(height: .5.h),
                              Text(
                                state.userProfile.email,
                                style: GoogleFonts.poppins(
                                    color: const Color(0xFF343434),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    height: 1.5),
                              ),
                              SizedBox(height: 3.h),
                              Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Container(
                                    padding: EdgeInsets.all(2.h),
                                    height: 18.h,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Colors.black.withOpacity(0.05),
                                        )
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SingleRecordCard(
                                                  imagePath:
                                                      'assets/images/profile_page_Books_Emoji.png',
                                                  number: state.userProfile
                                                      .topicsCompleted,
                                                  text: 'Topics Completed'),
                                            ),
                                            Expanded(
                                              child: SingleRecordCard(
                                                  imagePath:
                                                      'assets/images/profile_page_Test_Passed.png',
                                                  number: state.userProfile
                                                      .questionsSolved,
                                                  text: 'Questions Solved'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SingleRecordCard(
                                                  imagePath:
                                                      'assets/images/profile_page_Literature.png',
                                                  number: state.userProfile
                                                      .chaptersCompleted,
                                                  text: 'Chapters Completed'),
                                            ),
                                            Expanded(
                                              child: SingleRecordCard(
                                                  imagePath:
                                                      'assets/images/StarFilled.png',
                                                  number: state
                                                      .userProfile.totalScore,
                                                  text: 'points'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                ),
                                child: InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.h, horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 12,
                                          color: Colors.black.withOpacity(0.05),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          height: 6.h,
                                          width: 7.w,
                                          'assets/images/Trophy.png',
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Currently  ranked at ${state.userProfile.rank}',
                                                style: const TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const Text(
                                                'Checkout the leaderboard',
                                                style: TextStyle(
                                                    color: Color(0xFF0072FF),
                                                    fontFamily: 'Poppins',
                                                    decoration: TextDecoration
                                                        .underline),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              const SizedBox(
                                height: 180,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AccountComponent(
                                        imageAssetPath:
                                            'assets/images/profile_page_account_icon.png',
                                        title: 'Change Username',
                                        arrowHead:
                                            'assets/images/arrowHead.png',
                                        customWidget: ChangeUsernameDialog(),
                                        icon: Icon(
                                          Icons.chevron_right,
                                        ),
                                      ),
                                      AccountComponent(
                                        imageAssetPath:
                                            'assets/images/profile_page_lock_icon.png',
                                        title: 'Change Password\t',
                                        arrowHead:
                                            'assets/images/arrowHead.png',
                                        customWidget: ChangePasswordDialog(),
                                        icon: Icon(
                                          Icons.chevron_right,
                                        ),
                                      ),
                                      AccountComponent(
                                        imageAssetPath:
                                            'assets/images/profile_page_logout_icon.png',
                                        title: 'Logout',
                                        arrowHead: 'assets/images/empty.png',
                                        customWidget: Placeholder(),
                                      ),
                                    ]),
                              ),
                              SizedBox(height: Finalheight / 18),
                            ],
                          ),
                        ],
                      )),
                );
              } else if (state is ProfileFailedState) {
                if (state.failure is NetworkFailure) {
                  return NoInternet(
                    reloadCallback: () {
                      BlocProvider.of<UserProfileBloc>(context)
                          .add(GetUserProfile(isRefreshed: true));
                    },
                  );
                } else if (state.failure is AuthenticationFailure) {
                  return const Center(child: SessionExpireAlert());
                }
                return const Center(child: Text('Unkown Error happend'));
              } else {
                return const MessageDisplay(
                    message: 'Could not find Profile' //should be errorMessage
                    );
              }
            },
          )),
    );
  }

  Shimmer _profilePageShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          Center(
            child: Container(
              height: 4.h,
              width: 35.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Center(
            child: ClipOval(
                child: Container(
              color: Colors.black54,
              width: 129.0,
              height: 129.0,
            )),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 4.h,
            width: 45.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 3.h,
            width: 55.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
              height: 18.h,
              width: 85.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.05),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              )),
          SizedBox(height: 2.h),
          Container(
              height: 10.h,
              width: 85.w,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.05),
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              )),
          SizedBox(height: 3.h),
          SizedBox(
            width: 80.w,
            child: ListView.separated(
                separatorBuilder: (ctx, idx) => SizedBox(height: 1.h),
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      Container(
                        height: 4.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right,
                          color: Colors.grey, size: 30)
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
