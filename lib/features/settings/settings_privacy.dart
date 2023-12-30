import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';

class SettingsPrivacy extends StatefulWidget {
  const SettingsPrivacy({super.key});

  @override
  State<SettingsPrivacy> createState() => _SettingsPrivacyState();
}

class _SettingsPrivacyState extends State<SettingsPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(
          16.r,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            sizedBoxWithHeight(40),
            Row(
              children: [
                sizedBoxWithWidth(60),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Center',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Take control of your privacy and learn\nhow we protect it.",
                      style: GoogleFonts.poppins(
                        color: AppColors.colorgrey,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
            sizedBoxWithHeight(40),
            privacytexts(
              title: "Location",
              subtitle: "Update your location sharing preferences.",
            ),
            sizedBoxWithHeight(20),
            privacytexts(
              title: "Emergency data sharing",
              subtitle: "Update your data sharing preferences",
            ),
          ],
        ),
      ),
    );
  }
}

Widget privacytexts({
  required String title,
  required String subtitle,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
            color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w400),
      ),
      sizedBoxWithHeight(10),
      Text(
        subtitle,
        style: GoogleFonts.poppins(
            color: AppColors.greydark,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400),
      )
    ],
  );
}
