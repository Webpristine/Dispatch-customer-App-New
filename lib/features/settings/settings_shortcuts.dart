import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';

class SettingsShortCuts extends StatefulWidget {
  const SettingsShortCuts({super.key});

  @override
  State<SettingsShortCuts> createState() => _SettingsShortCutsState();
}

class _SettingsShortCutsState extends State<SettingsShortCuts> {
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
              "Saved Places",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            settingsshortcuts(icon: Icon(Icons.home), text: "Add Home"),
            settingsshortcuts(
              icon: Icon(Icons.work),
              text: "Add Work",
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxWithHeight(15),
                Row(
                  children: [
                    Container(
                      child: Icon(Icons.star),
                      padding: EdgeInsets.all(
                        5.r,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.greylight, shape: BoxShape.circle),
                    ),
                    sizedBoxWithWidth(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1217 Islington Ave",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          "1217 Islington Ave, Toronto, Ontario",
                          style: GoogleFonts.poppins(
                            color: AppColors.grey500,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider()
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sizedBoxWithHeight(15),
                Row(
                  children: [
                    Container(
                      child: Icon(Icons.add),
                      padding: EdgeInsets.all(
                        5.r,
                      ),
                      decoration: BoxDecoration(
                          color: AppColors.greylight, shape: BoxShape.circle),
                    ),
                    sizedBoxWithWidth(10),
                    Text(
                      "Add a new Place",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsshortcuts({
  required Widget icon,
  required String text,
}) {
  return Column(
    children: [
      sizedBoxWithHeight(15),
      Row(
        children: [
          Container(
            child: icon,
            padding: EdgeInsets.all(
              5.r,
            ),
            decoration: BoxDecoration(
                color: AppColors.greylight, shape: BoxShape.circle),
          ),
          sizedBoxWithWidth(10),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 14.h,
          )
        ],
      ),
      Divider()
    ],
  );
}
