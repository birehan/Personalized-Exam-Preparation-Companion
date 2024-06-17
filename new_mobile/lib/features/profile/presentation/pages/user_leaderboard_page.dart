import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'package:prep_genie/features/profile/presentation/widgets/leaderboard_tab.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/user_leaderboard_entity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// class UserLeaderboardPage extends StatefulWidget {
//   const UserLeaderboardPage({super.key});

//   @override
//   State<UserLeaderboardPage> createState() => _UserLeaderboardPageState();
// }

// class _UserLeaderboardPageState extends State<UserLeaderboardPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late String _paragraph = '';
//   late List<String> _keyPoints = [];
//   final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 1, vsync: this);
//     context.read<UsersLeaderboardBloc>().add(const GetTopUsersEvent(
//         pageNumber: 1, leaderboardType: LeaderboardType.allTime));
//     _fetchUserContentRecommendation();
//   }

//   Future<void> _fetchUserContentRecommendation() async {
//     final userCredentialJson = await _flutterSecureStorage.read(key: 'authentication_key');
//     if (userCredentialJson == null) {
//       // Handle the case where userCredential is null


//       return;
//     }
    
//     final userCredential = json.decode(userCredentialJson);
//     final userId = userCredential['id'];




//    final response = await http.get(
//       Uri.parse('https://5ef9-196-188-35-26.ngrok-free.app/get_user_content_recommendation/$userId'),
//     );
  

    
 
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       if (responseData['success'] == true) {
//         setState(() {
//           _paragraph = responseData['data'][0]['content_recommended']['paragraph'];
//           _keyPoints = List<String>.from(responseData['data'][0]['content_recommended']['key_points']);
//         });
//       } else {
//         // Handle the error case
//       }
//     } else {
//       // Handle the error case
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFCFCFC),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'User Recommendations',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               if (_paragraph.isNotEmpty) ...[
//                 Text(
//                   _paragraph,
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ..._keyPoints.map((point) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Text(
//                         '• $point',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                         ),
//                       ),
//                     )),
//               ] else ...[
//                 Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class UserLeaderboardPage extends StatefulWidget {
  const UserLeaderboardPage({super.key});

  @override
  State<UserLeaderboardPage> createState() => _UserLeaderboardPageState();
}

class _UserLeaderboardPageState extends State<UserLeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, dynamic>> _recommendations = [];
  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    context.read<UsersLeaderboardBloc>().add(const GetTopUsersEvent(
        pageNumber: 1, leaderboardType: LeaderboardType.allTime));
    _fetchUserContentRecommendation();
  }

  Future<void> _fetchUserContentRecommendation() async {
    final userCredentialJson = await _flutterSecureStorage.read(key: 'authentication_key');
    if (userCredentialJson == null) {
      // Handle the case where userCredential is null
      return;
    }

    final userCredential = json.decode(userCredentialJson);
    final userId = userCredential['id'];

    final response = await http.get(
      Uri.parse('https://5ef9-196-188-35-26.ngrok-free.app/get_user_content_recommendation/$userId'),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        setState(() {
          _recommendations = List<Map<String, dynamic>>.from(responseData['data']);
        });
      } else {
        // Handle the error case
      }
    } else {
      // Handle the error case
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'User Recommendations',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (_recommendations.isNotEmpty) ...[
                ..._recommendations.map((recommendation) {
                  final courseName = recommendation["course_data"]["course name"];
                  final grade = recommendation["course_data"]["grade"];
                  final paragraph = recommendation['content_recommended']['paragraph'];
                  final keyPoints = List<String>.from(recommendation['content_recommended']['key_points']);
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$courseName - Grade $grade',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            paragraph,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...keyPoints.map((point) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $point',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ] else ...[
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}