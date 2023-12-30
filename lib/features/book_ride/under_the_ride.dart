import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/features/book_ride/ride_completed.dart';

import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';

class UnderTheRide extends StatefulWidget {
  final LatLng pickuplatlong;
  final LatLng droplatlong;
  final Set<Polyline> polylines;
  const UnderTheRide({
    required this.polylines,
    required this.droplatlong,
    required this.pickuplatlong,
    super.key,
  });

  @override
  State<UnderTheRide> createState() => _UnderTheRideState();
}

class _UnderTheRideState extends State<UnderTheRide> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()
      ..init(
        context,
      );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              polylines: widget.polylines,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: <Marker>{
                Marker(
                  markerId: const MarkerId('marker_1'),
                  draggable: false,
                  position: LatLng(
                    widget.droplatlong.latitude,
                    widget.droplatlong.longitude,
                  ),
                  infoWindow: const InfoWindow(
                    title: 'Marker Title',
                    snippet: 'Marker Snippet',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('marker_2'),
                  draggable: false,
                  position: LatLng(
                    widget.pickuplatlong.latitude,
                    widget.pickuplatlong.longitude,
                  ),
                  infoWindow: const InfoWindow(
                      title: 'Marker Title', snippet: 'Marker Snippet'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              onMapCreated: (controller) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(
                      widget.pickuplatlong.latitude,
                      widget.pickuplatlong.longitude,
                    ),
                    15,
                  ),
                );
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.pickuplatlong.latitude,
                  widget.pickuplatlong.longitude,
                ),
                zoom: 15.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    margin: EdgeInsets.only(
                      top: 10.h,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.sort,
                        color: AppColors.black,
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  sizedBoxWithHeight(
                    20,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      top: 8.h,
                      bottom: 8.h,
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Reaching Destination in",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "16 min",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        sizedBoxWithHeight(5),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                            right: 80.w,
                          ),
                          height: 4.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300.h,
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
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "On Trip",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.share,
                                color: AppColors.green,
                                size: 14,
                              ),
                              Text(
                                "  Share rider details",
                                style: GoogleFonts.poppins(
                                  color: AppColors.green,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
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
                            sizedBoxWithHeight(4),
                          ],
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            AppEnvironment.navigator.push(
                              MaterialPageRoute(
                                  builder: (context) => RideCompleted()),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 10.w,
                            ),
                            child: Icon(
                              Icons.phone_in_talk_sharp,
                              color: AppColors.black,
                              size: 20,
                            ),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: AppColors.greylight,
                                shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
