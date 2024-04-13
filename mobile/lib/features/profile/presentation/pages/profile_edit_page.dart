import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/domain/entities/department_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/profile_update_entity.dart';

import 'package:prepgenie/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';
import 'package:prepgenie/features/profile/presentation/bloc/changeUsernameBloc/username_event.dart';

import 'package:prepgenie/features/profile/presentation/bloc/changeUsernameBloc/username_state.dart';
import 'package:prepgenie/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';
import 'package:prepgenie/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'package:prepgenie/features/profile/presentation/bloc/userProfile/userProfile_event.dart';
import 'package:prepgenie/features/profile/presentation/widgets/dropdown_with_userinput.dart';

import 'package:prepgenie/features/profile/presentation/widgets/name_editing_field.dart';
import 'package:prepgenie/features/profile/presentation/widgets/profile_dropdown_selection.dart';
import '../widgets/custom_text_button.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late String? selectedSchool;
  late int? selectedGrade;
  late String? selectedStream;

  @override
  void initState() {
    super.initState();
    // context.read<SchoolBloc>().add(GetSchoolInformationEvent());
  }

  File? _image;
  final imageUploader = ImageUploader();
  void upload(ImageSource source) async {
    File? uploadedImage = await imageUploader.getImage(source);
    if (uploadedImage == null) return;

    _imageConfirmationPopup(uploadedImage);
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

  void _imageConfirmationPopup(File uploadedImage) {
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
                        setState(() {
                          _image = uploadedImage;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void navigateToLogin(Completer<void> completer, BuildContext context) async {
    await completer.future;
    // ignore: use_build_context_synchronously
    LoginPageRoute().go(context);
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: BlocListener<UsernameBloc, UsernameState>(
        listener: (context, state) {
          if (state is UserProfileUpdatedState) {
            BlocProvider.of<UserProfileBloc>(context).add(
              GetUserProfile(isRefreshed: true),
            );
            context.read<GetUserBloc>().add(GetUserCredentialEvent());
            context.pop();
          } else if (state is UpdateProfileFailedState) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      "update is Not successful \n Please try again"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
            // if (state.failureType is NetworkFailure) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(content: Text('Please check your internet')));
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //       content: Text('Something went wrong. Try again.')));
            // }
          }
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_sharp),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      BlocBuilder<GetUserBloc, GetUserState>(
                        builder: (context, state) {
                          if (state is GetUserCredentialState &&
                              state.status == GetUserStatus.loaded) {
                            firstNameController.text =
                                state.userCredential!.firstName;
                            lastNameController.text =
                                state.userCredential!.lastName;
                            selectedGrade = state.userCredential!.grade;
                            selectedSchool = state.userCredential!.school;
                            selectedStream = state.userCredential!.departmentId;

                            return Column(
                              children: [
                                Stack(
                                  children: [
                                    ClipOval(
                                        child: Container(
                                      color: Colors.black26,
                                      child: Image(
                                        width: 129.0,
                                        height: 129.0,
                                        fit: BoxFit.cover,
                                        image: _image != null
                                            ? FileImage(_image!)
                                                as ImageProvider
                                            : CachedNetworkImageProvider(state
                                                .userCredential!
                                                .profileAvatar!),
                                      ),
                                    )),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
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
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  '${state.userCredential!.firstName} ${state.userCredential!.lastName}',
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF1C1B1B),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5),
                                ),
                                SizedBox(height: .5.h),
                                Text(
                                  state.userCredential!.email,
                                  style: GoogleFonts.poppins(
                                      color: const Color(0xFF343434),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic,
                                      height: 1.5),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    Expanded(
                                      child: NameEditingField(
                                        controller: firstNameController,
                                        hintText:
                                            state.userCredential!.firstName,
                                        title: 'First Name',
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: NameEditingField(
                                        controller: lastNameController,
                                        hintText:
                                            state.userCredential!.lastName,
                                        title: 'Last Name',
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 2.h),
                          BlocBuilder<SchoolBloc, SchoolState>(
                            builder: (context, state) {
                              // if (state is SchoolFailedState) {
                              //   return const Text(
                              //       'Could not load school information');
                              // } else if (state is SchoolLoadingState) {
                              //   return const CustomProgressIndicator();
                              // } else

                              if (state is SchoolLoadedState) {
                                final schoolInfo =
                                    state.schoolDepartmentInfo.schoolInfo;
                                final departmentInfo =
                                    state.schoolDepartmentInfo.departmentInfo;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropDownWithUserInput(
                                      lable: '',
                                      selectedCallback: (val) {
                                        for (var school in schoolInfo) {
                                          if (school.schoolName == val) {
                                            selectedSchool = school.schoolName;
                                          }
                                        }
                                      },
                                      title: 'School',
                                      items: schoolInfo
                                          .map((e) => e.schoolName)
                                          .toList(),
                                      hintText: selectedSchool != null
                                          ? selectedSchool!
                                          : 'Select your schoool',
                                    ),
                                    SizedBox(height: 2.h),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ProfileDropdownOptions(
                                            selectedCallback: (val) {
                                              if (val != null) {
                                                selectedGrade = int.parse(val);
                                              }
                                            },
                                            hintText: selectedGrade != null
                                                ? 'Grade ${selectedGrade.toString()}'
                                                : 'Grade',
                                            title: 'Grade',
                                            lable: 'Grade',
                                            items: const [
                                              '9',
                                              '10',
                                              '11',
                                              '12',
                                            ],
                                            width: 44.w,
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        Expanded(
                                          child: ProfileDropdownOptions(
                                            selectedCallback: (val) {
                                              if (val ==
                                                  departmentInfo[0]
                                                      .departmentName) {
                                                selectedStream =
                                                    departmentInfo[0]
                                                        .departmentId;
                                              } else if (val ==
                                                  departmentInfo[1]
                                                      .departmentName) {
                                                selectedStream =
                                                    departmentInfo[1]
                                                        .departmentId;
                                              } else if (val ==
                                                  departmentInfo[2]
                                                      .departmentName) {
                                                selectedStream =
                                                    departmentInfo[2]
                                                        .departmentId;
                                              }
                                            },
                                            hintText: selectedStream != null
                                                ? getStreamName(
                                                    department: departmentInfo,
                                                    depId: selectedStream!)
                                                : 'Stream',
                                            lable: '',
                                            title: 'Stream',
                                            width: 44.w,
                                            items: departmentInfo
                                                .map((department) =>
                                                    department.departmentName)
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  context.read<UsernameBloc>().add(
                                        UpdateProfileEvent(
                                          updateEntity: ProfileUpdateEntity(
                                            imagePath: _image,
                                            firstName: firstNameController.text,
                                            lastName: lastNameController.text,
                                            grade: selectedGrade,
                                            school: selectedSchool,
                                            departmentId: selectedStream,
                                          ),
                                        ),
                                      );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 10.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0072FF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child:
                                      BlocBuilder<UsernameBloc, UsernameState>(
                                    builder: (context, state) {
                                      if (state is ProfileUpdateOnProgress) {
                                        return const CustomProgressIndicator(
                                          color: Colors.white,
                                          size: 20,
                                        );
                                      }
                                      return const Text(
                                        'Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Poppins'),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  String getStreamName(
      {required List<DepartmentEntity> department, required String depId}) {
    for (var d in department) {
      if (d.departmentId == depId) {
        return d.departmentName;
      }
    }
    return '';
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
