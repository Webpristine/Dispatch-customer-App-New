// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:multitrip_user/shared/shared.dart';
// import 'package:multitrip_user/shared/ui/common/app_image.dart';
// import 'package:multitrip_user/shared/ui/common/spacing.dart';
// import 'package:multitrip_user/themes/app_text.dart';

// class AskPermissionScreen extends StatefulWidget {
//   const AskPermissionScreen({super.key});

//   @override
//   State<AskPermissionScreen> createState() => _AskPermissionScreenState();
// }

// class _AskPermissionScreenState extends State<AskPermissionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.instance = ScreenUtil()
//       ..init(
//         context,
//       );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 16.w,
//           ),
//           child: Column(
//             children: [
//               sizedBoxWithHeight(40),
//               AppImage(
//                 "assets/logo.png",
//                 height: 200.h,
//                 width: 200.w,
//               ),
//               sizedBoxWithHeight(20),
//               Text(
//                 "Location permission not enabled",
//                 style: GoogleFonts.poppins(
//                   color: Colors.black,
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               sizedBoxWithHeight(10),
//               Text(
//                 "Sharing Location permission help us improve your ride booking and pickup experience",
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.poppins(
//                   color: AppColors.greydark,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 margin: EdgeInsets.only(
//                   bottom: 10.h,
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                 decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.green,
//                         AppColors.yellow,
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(40)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Allow Permission",
//                         style: AppText.text18w400.copyWith(
//                           color: Colors.white,
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
