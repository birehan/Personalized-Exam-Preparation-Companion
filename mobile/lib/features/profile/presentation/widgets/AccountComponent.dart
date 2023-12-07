import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/authentication/authentication.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/logout/logout_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/changePassword.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/changeUsername.dart';

class AccountComponent extends StatelessWidget {
  final String imageAssetPath;
  final String title;
  final String arrowHead;
  final Widget customWidget;
  final Icon? icon;

  const AccountComponent({
    super.key,
    required this.imageAssetPath,
    required this.title,
    required this.arrowHead,
    required this.customWidget,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<LogoutBloc, LogoutState>(
    //   builder: (context, state) {
    final Finalwidth = MediaQuery.of(context).size.width;
    final Finalheight = MediaQuery.of(context).size.height;
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogedOutState) {
                LoginPageRoute().go(context);
              }
      },
      child: InkWell(
        onTap: () {
          if (title != 'Logout') {
            showDialog(
              context: context,
              builder: (BuildContext context) => customWidget,
            );
          } else {
            //  BlocProvider.of<LogoutBloc>(context).add(DispatchLogoutEvent());
            context.read<LogoutBloc>().add(DispatchLogoutEvent());
          }

  
        },
        child: Container(
          // color: Colors.red,
          child: Row(
            children: [
              SizedBox(
                width: Finalwidth / 11.18,
              ),

              Container(
                width: 49.0, // Set the width of the container
                height: 49.0, // Set the height of the container
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(5.0), // Set the border-radius
                    border: Border.all(
                      color:   Color(0xFFE4E2E2), // Set the border color
                      width: 1.0, // Set the border width
                    ),
                    color: Color(0xFFE4E2E2)),
                child: title == "Change Password\t" ? Icon(Icons.lock, size: 26,) :
                  Center(
                        child: Image.asset(
                          imageAssetPath,
                          width: 20.0, // Set the width of the image
                          height: 20.0, // Set the height of the image
                          fit: BoxFit.cover, // You can adjust the BoxFit as needed
                        ),
                     ),
          
                 


              ),

              SizedBox(width: Finalwidth / 49.2),
              // Add spacing between icon and text
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Color(0xFF242222),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
              ),
              SizedBox(width:  Finalwidth/6  ), // Push the arrow icon to the right 82.0
              // Icon(Icons.arrow_forward),
              Align(
                alignment: Alignment.centerRight,
                child:  icon,
              ),
            ],
          ),
        ),
      ),
    );
    //   },
    // );
  }
}
