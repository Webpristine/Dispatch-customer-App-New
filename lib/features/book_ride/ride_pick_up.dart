// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:multitrip_user/features/book_ride/select_rider.dart';
// import 'package:multitrip_user/shared/shared.dart';
// import 'package:multitrip_user/themes/app_text.dart';
// import 'package:multitrip_user/widgets/app_google_map.dart';

// class RidePickup extends StatefulWidget {
//   const RidePickup({
//     super.key,
//   });

//   @override
//   State<RidePickup> createState() => _RidePickupState();
// }

// class _RidePickupState extends State<RidePickup> {
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AppGoogleMap(),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: 500.h,
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 10.h,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Text(
//                         "Confirm your pickup spot",
//                         style: AppText.text14w400.copyWith(
//                             color: Color(
//                               0xff2222222,
//                             ),
//                             fontSize: 13.sp,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     Divider(
//                       color: AppColors.greylight,
//                       thickness: 1.4,
//                     ),
//                     Spacer(),
//                     Text(
//                       "1217 Islington Ave",
//                       style: GoogleFonts.poppins(
//                         color: AppColors.black,
//                         fontSize: 13.sp,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SelectRider(),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         margin: EdgeInsets.only(
//                           top: 10.h,
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: 15.h,
//                         ),
//                         child: Center(
//                           child: Text(
//                             "Confirm ride",
//                             style: AppText.text15Normal
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.green,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 color: Colors.white,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
