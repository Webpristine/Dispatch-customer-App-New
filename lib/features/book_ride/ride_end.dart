import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:multitrip_user/widgets/app_google_map.dart';

class RideEnd extends StatefulWidget {
  const RideEnd({
    super.key,
  });

  @override
  State<RideEnd> createState() => _RideEndState();
}

class _RideEndState extends State<RideEnd> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          AppGoogleMap(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400.h,
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.only(
                top: 10.h,
                left: 16.w,
                bottom: 10.h,
                right: 16.w,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                    ),
                    child: Text(
                      "Your Trip",
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.circle,
                            color: AppColors.black,
                            size: 10,
                          ),
                          SizedBox(
                            height: 60,
                            child: VerticalDivider(
                              width: 20,
                              indent: 4,
                              endIndent: 4,
                              thickness: 1.6,
                              color: AppColors.black,
                            ),
                          ),
                          Icon(
                            Icons.location_on,
                            color: AppColors.black,
                            size: 15,
                          ),
                        ],
                      ),
                      sizedBoxWithWidth(4),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1217 Islington Ave",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "1217 Islington Ave, Toronto, Ontario",
                            style: GoogleFonts.poppins(
                              color: AppColors.grey500,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "4:00 PM",
                            style: GoogleFonts.poppins(
                              color: AppColors.green,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          sizedBoxWithHeight(10),
                          Text(
                            "618 102nd Avenue",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "618 102nd Avenue, Dawson Creek, British Columbia",
                            style: GoogleFonts.poppins(
                              color: AppColors.grey500,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "4:45 PM",
                            style: GoogleFonts.poppins(
                              color: AppColors.green,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: AppColors.colorgrey,
                  ),
                  Row(
                    children: [
                      AppImage(
                        Images.driver,
                        height: 50.h,
                        width: 50.w,
                      ),
                      sizedBoxWithWidth(15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sam",
                            style: AppText.text14w400.copyWith(
                              color: AppColors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                          RatingBar.builder(
                            initialRating: 3.4,
                            minRating: 1,
                            direction: Axis.horizontal,
                            ignoreGestures: true,
                            allowHalfRating: true,
                            unratedColor: Colors.grey,
                            itemCount: 5,
                            itemSize: 15,
                            itemPadding: EdgeInsets.symmetric(horizontal: .0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 10,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 4.h,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 7.w,
                              vertical: 2.h,
                            ),
                            child: Row(children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 13,
                              ),
                              sizedBoxWithWidth(3),
                              Text(
                                "5.00",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ]),
                            decoration: BoxDecoration(
                                color: AppColors.green,
                                borderRadius: BorderRadius.circular(20)),
                          )
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: AppColors.colorgrey,
                  ),
                  Text(
                    "Payment",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money_outlined,
                        color: AppColors.green,
                        size: 40.h,
                      ),
                      sizedBoxWithWidth(10),
                      Text(
                        "Cash",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "\$50.00",
                        style: GoogleFonts.poppins(
                          color: AppColors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
