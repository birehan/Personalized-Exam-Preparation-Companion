import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverviewComponent extends StatelessWidget {
  final String imageAssetPath;
  final int number;
  final String text;

  const OverviewComponent({super.key, 
    required this.imageAssetPath,
    required this.number,
    required this.text,});

  @override
  Widget build(BuildContext context) {
    return 
    
    Center(
        child: Column(
          children: [
   
        SizedBox(height: 16.0),
        Container(
              width: 64.0, // Set the width of the container
              height: 64.0, // Set the height of the container
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Color(0xFFE4E2E2), // Set the border color
                  width: 1.0, // Set the border width
                ),
              
              ),
              child: Center(
                child: Image.asset(
                  imageAssetPath,
                  width: 31.0, // Set the width of the image
                  height: 31.0, // Set the height of the image
                  fit: BoxFit.cover, // You can adjust the BoxFit as needed
                ),
              ),
            ),

            SizedBox(height: 16.0), // Add spacing between image and number
           
            Text(
            '$number',
            style: GoogleFonts.poppins(
            
              color: Color(0xFF4B4747),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.5,
              letterSpacing: -0.02,
            ),
          ),
            
            SizedBox(height: 6.0), // Add spacing between number and text
            Text(
              text,
              style: GoogleFonts.poppins(
          
                color: Color(0xFF6A6868),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.5,
                letterSpacing: -0.02,
            ),
          ),
          ],
        ),
      );
  
  }
}