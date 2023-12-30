import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/rate/rate_driver_controller.dart';
import 'package:multitrip_user/models/booking_history.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:provider/provider.dart';

import '../../shared/ui/common/app_image.dart';
import '../../themes/app_text.dart';

class RateDriver extends StatefulWidget {
  const RateDriver({super.key, required this.model});
  final Bookings model;

  @override
  State<RateDriver> createState() => _RateDriverState();
}

class _RateDriverState extends State<RateDriver> {
  double rating = 0;
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () => _handleRating(),
        child: Container(
          height: 48,
          margin: EdgeInsets.only(top: 100.h, bottom: 20.h) +
              EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          child: Center(
            child: Text(
              "Submit",
              style: AppText.text15Normal.copyWith(color: Colors.white),
            ),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.green,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => PagesWidget(
                      currentTab: 0,
                    ),
                  ),
                  (_) => false);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            width: double.infinity,
            color: AppColors.green,
            height: 260.h,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Thank You",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  sizedBoxWithHeight(15),
                  AppImage(
                    Images.driver,
                    height: 70.h,
                    width: 70.w,
                  ),
                  sizedBoxWithHeight(15),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    unratedColor: Colors.white,
                    itemCount: 5,
                    itemSize: 19,
                    itemPadding: EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 10,
                    ),
                    onRatingUpdate: (value) {
                      rating = value;
                      setState(() {});
                    },
                  ),
                  sizedBoxWithHeight(15),
                  Text(
                    "We are glad you liked the trip!",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  sizedBoxWithHeight(15),
                  Text(
                    "Any comments?",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  sizedBoxWithHeight(20),
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, 210),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.greylight,
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4))
                  ]),
              clipBehavior: Clip.antiAlias,
              child: TextFormField(
                controller: _textController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: "Type your message hear ...",
                  hintStyle: GoogleFonts.poppins(
                    color: AppColors.hintColor,
                    fontSize: 12.sp,
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleRating() async {
    // if (_textController.text.isEmpty) {
    //   context.showSnackBar(context, msg: 'Review is missing');
    //   return;
    // }
    Loader.show(context);
    await context.read<RateDriverController>().rateRider(
        rating: rating,
        comment: _textController.text.isEmpty ? "null" : _textController.text,
        bookingId: widget.model.bookingId,
        onFailure: () {
          Loader.hide();

          context.showSnackBar(context, msg: 'Something went wrong');
          _navigateHome();
        },
        onSuccess: () {
          Loader.hide();
          context.showSnackBar(context, msg: 'Thank for rating');
          _navigateHome();
        });
  }

  void _navigateHome() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PagesWidget(
            currentTab: 0,
          ),
        ),
        (_) => false);
  }
}
