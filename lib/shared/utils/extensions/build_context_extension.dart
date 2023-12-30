import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension BuildContextExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get inset => MediaQuery.of(this).viewInsets.bottom;

  bool get isIOS => Platform.isIOS;

  void showSnackBar(
    BuildContext context, {
    required String msg,
  }) {
    Fluttertoast.showToast(
      msg: msg,
    );
    // final snackBar = SnackBar(
    //   padding: EdgeInsets.symmetric(),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10),
    //   ),
    //   content: Container(
    //     padding: EdgeInsets.symmetric(
    //       vertical: 12.h,
    //     ),
    //     margin: EdgeInsets.only(
    //       left: 10.w,
    //     ),
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.only(
    //         topRight: Radius.circular(10),
    //         bottomRight: Radius.circular(10),
    //       ),
    //       color: Colors.white,
    //     ),
    //     child: Padding(
    //       padding: EdgeInsets.only(
    //         left: 16.w,
    //       ),
    //       child: Text(
    //         msg,
    //         style: AppText.text15Normal.copyWith(
    //           color: Colors.black,
    //           fontWeight: FontWeight.w600,
    //         ),
    //       ),
    //     ),
    //   ),
    //   backgroundColor: Colors.green,
    //   margin: EdgeInsets.only(
    //     right: 16.w,
    //     left: 16.w,
    //     bottom: 70.h,
    //   ),
    //   behavior: SnackBarBehavior.floating,
    // );
    // ScaffoldMessenger.of(
    //   context,
    // ).showSnackBar(
    //   snackBar,
    // );
  }

  void showSnackBarError(
    BuildContext context, {
    required String msg,
  }) {
    //   final snackBar = SnackBar(
    //     padding: EdgeInsets.symmetric(),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     content: Container(
    //       padding: EdgeInsets.symmetric(
    //         vertical: 12.h,
    //       ),
    //       margin: EdgeInsets.only(
    //         left: 10.w,
    //       ),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //           topRight: Radius.circular(10),
    //           bottomRight: Radius.circular(10),
    //         ),
    //         color: Colors.white,
    //       ),
    //       child: Padding(
    //         padding: EdgeInsets.only(
    //           left: 16.w,
    //         ),
    //         child: Text(
    //           msg,
    //           style: AppText.text15Normal.copyWith(
    //             color: Colors.black,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //       ),
    //     ),
    //     backgroundColor: Colors.red,
    //     margin: EdgeInsets.only(
    //       right: 16.w,
    //       left: 16.w,
    //       bottom: 70.h,
    //     ),
    //     behavior: SnackBarBehavior.floating,
    //   );
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(
    //     snackBar,
    //   );
    // }
    Fluttertoast.showToast(
      msg: msg,
    );
  }
// extension HexColor on Color {
//   /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
//   String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
//       '${alpha.toRadixString(16).padLeft(2, '0')}'
//       '${red.toRadixString(16).padLeft(2, '0')}'
//       '${green.toRadixString(16).padLeft(2, '0')}'
//       '${blue.toRadixString(16).padLeft(2, '0')}';
// }
}
