import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/constants/dummydata.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/presentation/widgets/profiles_listing_card.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  final searchContoller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.keyboard_backspace),
        ),
        title: const Text(
          'Add new friends',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchContoller,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
                hintText: 'Name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              cursorHeight: 2.5.h,
            ),
            SizedBox(height: 1.5.h),
            const Divider(),
            SizedBox(height: 2.h),
            const Text(
              'Friend Suggestions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => ProfilesListingCard(
                  data: dummyUsers[index],
                  leftWidget: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFF0072FF),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemCount: 6,
              ),
            )
          ],
        ),
      ),
    );
  }
}
