import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

class PreviousRides extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const PreviousRides({super.key, this.parentScaffoldKey});

  @override
  State<PreviousRides> createState() => _PreviousRidesState();
}

class _PreviousRidesState extends State<PreviousRides> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _apiCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AppEnvironment.navigator.push(
          MaterialPageRoute(
            builder: (context) => PagesWidget(
              currentTab: 0,
            ),
          ),
        );

        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leadingWidth: 40.w,
          leading: InkWell(
            onTap: () {
              AppEnvironment.navigator.push(
                MaterialPageRoute(
                  builder: (context) => PagesWidget(
                    currentTab: 0,
                  ),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Previous rides",
                style: AppText.text18w400.copyWith(
                  color: AppColors.black,
                ),
              ),
              sizedBoxWithHeight(30),
              Consumer<AccountController>(
                builder: (context, model, __) {
                  if (model.history?.bookings?.isEmpty ?? true) {
                    return Center(
                      child: Text(
                        'No Booking History',
                        style: AppText.text16w400,
                      ),
                    );
                  }
                  return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                AppImage(
                                  (model.history?.bookings
                                              ?.elementAt(index)
                                              .driverProfilePhoto
                                              .isEmpty ??
                                          true)
                                      ? Images.driver
                                      : model.history!.bookings!
                                          .elementAt(index)
                                          .driverProfilePhoto,
                                  height: 50.h,
                                  width: 50.w,
                                ),
                                sizedBoxWithWidth(15),
                                if (model.history?.bookings
                                        ?.elementAt(index)
                                        .driverMobileNumber
                                        .isNotEmpty ??
                                    false) ...{
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.history!.bookings!
                                            .elementAt(index)
                                            .driverName,
                                        style: AppText.text14w400.copyWith(
                                          color: AppColors.black,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      IgnorePointer(
                                        child: RatingBar.builder(
                                          initialRating: (model
                                                  .history!.bookings!
                                                  .elementAt(index)
                                                  .driverRating
                                                  .isEmpty)
                                              ? 0.0
                                              : double.tryParse(model
                                                      .history!.bookings!
                                                      .elementAt(index)
                                                      .driverRating
                                                      .toString()) ??
                                                  0.0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          ignoreGestures: true,
                                          allowHalfRating: true,
                                          unratedColor: Colors.grey,
                                          itemCount: 5,
                                          itemSize: 15,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: .0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 10,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                } else ...{
                                  Text(
                                    'Driver is not assigned',
                                    style: AppText.text14w400.copyWith(
                                      color: AppColors.black,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                },
                                Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      "\$ ${model.history!.bookings!.elementAt(index).amount.toString()}",
                                      style: AppText.text14w400.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                          color: AppColors.greylight,
                                          borderRadius:
                                              BorderRadius.circular(4.r)),
                                      child: Text(
                                        (model.history!.bookings!
                                            .elementAt(index)
                                            .status
                                            .toUpperCase()),
                                        style: AppText.text14w400
                                            .copyWith(fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                                sizedBoxWithWidth(10),
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Timeline.tileBuilder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              theme: TimelineThemeData(
                                  indicatorTheme: IndicatorThemeData(
                                      size: 12.r, color: Colors.green),
                                  connectorTheme: ConnectorThemeData(
                                      color: AppColors.greydark),
                                  indicatorPosition: 0,
                                  nodePosition: 0),
                              builder: TimelineTileBuilder.connectedFromStyle(
                                contentsAlign: ContentsAlign.basic,
                                indicatorStyleBuilder: (_, __) => __ == 0
                                    ? IndicatorStyle.outlined
                                    : IndicatorStyle.dot,
                                lastConnectorStyle: ConnectorStyle.transparent,
                                connectorStyleBuilder: (__, v) => v ==
                                        ((model.history!.bookings!
                                                .elementAt(index)
                                                .dropLocation
                                                .length) -
                                            1)
                                    ? ConnectorStyle.transparent
                                    : ConnectorStyle.solidLine,
                                contentsBuilder: (context, _index) => Padding(
                                  padding:
                                      EdgeInsets.only(left: 4.w, bottom: 10.h),
                                  child: Text(
                                    model.history!.bookings!
                                            .elementAt(index)
                                            .dropLocation[_index]
                                            .address ??
                                        'NA',
                                    style: AppText.text14w400,
                                  ),
                                ),
                                itemCount: model.history!.bookings!
                                    .elementAt(index)
                                    .dropLocation
                                    .length,
                              ),
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Booking Date',
                                  style: AppText.text14w400,
                                ),
                                Text(
                                  model.history!.bookings!
                                      .elementAt(index)
                                      .bookingDate,
                                  style: AppText.text14w400
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        )
                            .animate()
                            .fadeIn(duration: 600.ms)
                            .then(delay: 200.ms) // baseline=800ms
                            .scale();
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 0.9,
                          color: AppColors.greylight,
                        );
                      },
                      itemCount: model.history!.bookings!.length);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _apiCall() {
    context.read<AccountController>().getBookingHistory(onFailure: () {});
  }
}
