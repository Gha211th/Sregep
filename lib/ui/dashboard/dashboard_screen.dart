// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'widgets/subject_picker.dart';
// import 'widgets/timer_circle.dart';

// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 75),
//               Text(
//                 "Hello Student",
//                 style: GoogleFonts.outfit(
//                   color: Color(0xFF34A0D3),
//                   fontWeight: FontWeight.w500,
//                   fontSize: 40,
//                   height: 1,
//                 ),
//               ),
//               Text(
//                 "Ready to be productive?",
//                 style: GoogleFonts.outfit(
//                   fontSize: 15,
//                   color: Color(0xffB3B3B3),
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               SizedBox(height: 30),
//               SubjectPicker(),
//               Expanded(child: Center(child: TimerCircle())),
//               _buildControlButtons(),
//               SizedBox(height: 50),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildControlButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Color(0xFF0077B6),
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           child: Text("Mulai", style: GoogleFonts.outfit(color: Colors.white)),
//         ),
//         OutlinedButton(
//           onPressed: () {},
//           style: OutlinedButton.styleFrom(
//             padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//             side: BorderSide(color: Color(0xFF0077B6)),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//             ),
//           ),
//           child: Text(
//             "Mandheg",
//             style: GoogleFonts.outfit(color: Color(0xFF0077B6)),
//           ),
//         ),
//       ],
//     );
//   }
// }
