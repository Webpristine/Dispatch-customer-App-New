import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/blocs/address/address_bloc.dart' as ad;
import 'package:multitrip_user/blocs/dashboard/dashboard_controller.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/book_ride/booking_otp.dart';
import 'package:multitrip_user/features/book_ride/pickupdropaddress.dart';
import 'package:multitrip_user/features/book_ride/schedule_ride.dart';
import 'package:multitrip_user/features/permission_page.dart';
import 'package:multitrip_user/logic/after_booking_controller.dart';
import 'package:multitrip_user/shared/globles.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:multitrip_user/widgets/app_google_map.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? parentScaffoldKey;

  const HomeScreen({
    super.key,
    this.parentScaffoldKey,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Position currentPosition;
  late String fullAddress;

  ad.AddressBloc addressBloc = ad.AddressBloc();
  Widget? errorPermssionWidget;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchlocatiocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        const error =
            PermissionDeniedException("Location Permission is denied");
        // context.showSnackBar(context, msg: error.message!);
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => NoPermission()));
          return Future.error(error);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        const error =
            PermissionDeniedException("Location Permission is denied forever");
        context.showSnackBar(context,
            msg: error
                .message!); // Permissions are denied forever, handle appropriately.
        context.read<DashBoardController>().callDashboardApi(LatLng(0.0, 0.0));

        Navigator.push(
            context, MaterialPageRoute(builder: (_) => NoPermission()));
        return Future.error(error);
      }

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();

        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        while (!await Geolocator.isLocationServiceEnabled()) {}
      }

      var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print(" Location is ${position.latitude}");
      setState(() {
        currentPosition = position;
      });
      getAddressFromLatLng(position.latitude, position.longitude).then((value) {
        // setState(() {
        fullAddress = value;
        // });
      }).whenComplete(() {
        if (mounted) {
          context.read<DashBoardController>().fullAddress = fullAddress;
          context.read<DashBoardController>().saveCurrentLocatoin(
              LatLng(
                position.latitude,
                position.longitude,
              ),
              fulladdress: fullAddress);
        }
      });

      context.read<DashBoardController>().callDashboardApi(
          LatLng(currentPosition.latitude, currentPosition.longitude));
    } catch (e) {
      context.showSnackBar(context, msg: e.toString());
    } finally {}
  }

  @override
  void initState() {
    super.initState();

    addressBloc = BlocProvider.of<ad.AddressBloc>(context);

    addressBloc.add(ad.FetchAddress());
    fetchlocatiocation().onError((error, stackTrace) => {errorPermssionWidget});
    Provider.of<AccountController>(context, listen: false)
        .getPofileData(isEnableLoading: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      handleCurrentBooking();
    });
  }

  Future<void> handleCurrentBooking() async {
    await Provider.of<AfterBookingController>(context, listen: false)
        .currentBooking();
    if (!mounted) {
      return;
    }
    final resultant = context.read<AfterBookingController>().booking;
    if (resultant?.bookingId?.isNotEmpty ?? false) {
      if (resultant?.status == 'payment done' ||
          resultant?.status == 'payment received') {
        return;
      }
      AppEnvironment.navigator.push(
        MaterialPageRoute(
          builder: (context) => BookingOTP(
            droplatlong: LatLng(
                double.parse(resultant?.dropLocation?.last.lat ?? '0.0'),
                double.parse(resultant?.dropLocation?.last.long ?? '0.0')),
            pickuplatlong: LatLng(
                double.parse(resultant?.pickupLocation?.lat ?? '0.0'),
                double.parse(resultant?.pickupLocation?.long ?? '0.0')),
            bookingId: resultant!.bookingId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(animated: true);
        // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        // return false;
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: _renderbody(),
      ),
    );
  }

  Widget _renderbody() {
    return RefreshIndicator(
      onRefresh: () async {
        addressBloc.add(ad.FetchAddress());
        fetchlocatiocation()
            .onError((error, stackTrace) => {errorPermssionWidget});
      },
      child: HomeScreenData(),
    );
  }
}

final List<Widget> imageSliders = drivers
    .map((item) => Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Text(
                  "Book drivers by hours",
                  style: AppText.text15w400
                      .copyWith(color: AppColors.black, fontSize: 14.sp),
                ),
              ),
              AppImage(
                Images.driverslider,
                // width: 130.w,
                // height: 130.h,
              )
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.greylight,
            borderRadius: BorderRadius.circular(20),
          ),
        ))
    .toList();

class HomeScreenData extends StatefulWidget {
  const HomeScreenData({
    super.key,
  });

  @override
  State<HomeScreenData> createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
  final CarouselController controller = CarouselController();
  int _current = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashBoardController>(builder: (context, model, _) {
      if (model.isLoading || model.dashboard == null) {
        return Center(child: CircularProgressIndicator());
      }
      if (model.dashboard != null) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ) +
                EdgeInsets.only(
                  top: 10.h,
                ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locationtextfield(model),
                  sizedBoxWithHeight(10),
                  _addresslistview(),
                  sizedBoxWithHeight(10),
                  Text(
                    "Online drivers",
                    style: AppText.text18w400.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                  sizedBoxWithHeight(10),
                  SizedBox(
                    height: 130.h,
                    child: ListView.separated(
                            padding: EdgeInsets.only(
                              left: 20.w,
                            ),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (model.dashboard?.topRatedDrivers[index].id ==
                                  null) {
                                return SizedBox();
                              }
                              return _driverview(
                                  driverImage: model.dashboard
                                          ?.topRatedDrivers[index].photo ??
                                      '',
                                  driverName: model.dashboard
                                          ?.topRatedDrivers[index].fname ??
                                      '',
                                  driverRating: model.dashboard
                                          ?.topRatedDrivers[index].rating ??
                                      '0');
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 50.w,
                              );
                            },
                            itemCount:
                                model.dashboard?.topRatedDrivers.length ?? 0)
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .then(delay: 00.ms) // baseline=800ms
                        .scale(),
                  ),
                  Stack(
                    children: [
                      CarouselSlider(
                        items: imageSliders,
                        carouselController: controller,
                        options: CarouselOptions(
                            height: 120.h,
                            viewportFraction: 1.0,
                            autoPlay: true,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                      ),
                      Positioned(
                        top: 90.h,
                        left: MediaQuery.of(context).size.width / 2.4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: drivers.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => controller.animateToPage(entry.key),
                              child: Container(
                                width: 6.0,
                                height: 6.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : AppColors.black)
                                        .withOpacity(
                                            _current == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                  sizedBoxWithHeight(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        thickness: 2,
                        color: AppColors.greydark,
                      ),
                      sizedBoxWithHeight(10),
                      Text(
                        "Previous drivers",
                        style: AppText.text18w400.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.black,
                        ),
                      ),
                      sizedBoxWithHeight(10),
                      SizedBox(
                        height: 130.h,
                        child: (model.dashboard?.previousDrivers.length ?? 0) >
                                0
                            ? ListView.separated(
                                padding: EdgeInsets.only(
                                  left: 20.w,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return _driverview(
                                      driverImage: "",
                                      driverName: "Sugam",
                                      driverRating: "0.0");
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 50.w,
                                  );
                                },
                                itemCount:
                                    model.dashboard?.nearbyDrivers.length ?? 0)
                            : Center(
                                child: Text(
                                  'No Previous drivers Found',
                                  style: AppText.text16w400.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                      ),
                      Divider(
                        thickness: 5,
                        color: AppColors.greydark,
                      ),
                    ],
                  ),
                  sizedBoxWithHeight(10),
                  Text(
                    "Drivers Nearby",
                    style: AppText.text18w400.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                  sizedBoxWithHeight(10),
                  Container(
                    height: 170.h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AppGoogleMap()),
                    decoration: BoxDecoration(
                      color: AppColors.greylight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  sizedBoxWithHeight(10),
                  Divider(
                    thickness: .5,
                    color: AppColors.greydark,
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (model.error != null) {
        return Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Something Went Wrong!!!'),
              SizedBox(
                height: 16.h,
              ),
              GestureDetector(
                onTap: () async {
                  var position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.best)
                      .catchError((e) {
                    print("error is $e");
                  });
                  getAddressFromLatLng(position.latitude, position.longitude)
                      .then((value) {
                    setState(() {
                      var fullAddress = value;
                    });
                  });

                  context.read<DashBoardController>().callDashboardApi(
                        LatLng(position.latitude, position.longitude),
                      );
                },
                child: Container(
                  width: 180.w,
                  child: Center(
                    child: Text(
                      "Retry",
                      style: AppText.text15w400.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return SizedBox();
    });
  }

  Widget _addresslistview() {
    return BlocConsumer<ad.AddressBloc, ad.AddressState>(
      builder: (context, state) {
        if (state is ad.AddressLoaded) {
          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemCount: state.address.address.length > 4
                    ? 3
                    : state.address.address.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final dbBoard = context.read<DashBoardController>();
                      if (dbBoard.currentLocation != null) {
                        AppEnvironment.navigator.push(MaterialPageRoute(
                          builder: (context) => PickupDropAddress(
                            lat: dbBoard.currentLocation!.latitude,
                            long: dbBoard.currentLocation!.longitude,
                            pickupaddess: dbBoard.fullAddress ?? '',
                            dropLocation: state.address.address[index],
                          ),
                        ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50.h,
                          width: 50.w,
                          child: Icon(
                            Icons.location_on_sharp,
                            color: AppColors.black,
                            size: 30,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.greylight,
                              shape: BoxShape.circle),
                        ),
                        sizedBoxWithWidth(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              state.address.address
                                  .elementAt(index)
                                  .addressLine1,
                              style: AppText.text16w400.copyWith(
                                color: AppColors.black,
                              ),
                            ),
                            Container(
                              width: 280.w,
                              child: Text(
                                state.address.address
                                    .elementAt(index)
                                    .addressLine2,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.text14w400.copyWith(
                                  color: AppColors.grey500,
                                  fontSize: 13.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.black,
                          size: 15,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (c, i) {
                  return Divider(
                    thickness: 0.6,
                    color: AppColors.greylight,
                  );
                },
              ),
              sizedBoxWithHeight(10),
              Divider(
                thickness: 2,
                color: AppColors.greydark,
              ),
            ],
          );
        }
        return SizedBox();
      },
      listener: (context, state) {
        if (state is ad.AddressLoading) {
        } else if (state is ad.AddressFailed) {
        } else if (state is ad.AddressNotFound) {
        } else if (state is TokenExpired) {}
      },
    );
  }

  Widget _driverview({
    required String driverImage,
    required String driverName,
    required String driverRating,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundImage: driverImage == ""
              ? Svg(
                  Images.driver,
                )
              : NetworkImage(
                  driverImage,
                ) as ImageProvider,
        ),
        Text(
          driverName,
          style: AppText.text14w400.copyWith(
            color: AppColors.black,
            fontSize: 14.sp,
          ),
        ),
        RatingBar.builder(
          initialRating: double.parse(driverRating),
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
      ],
    );
  }

  Widget _locationtextfield(model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        onTap: () {
          AppEnvironment.navigator.push(MaterialPageRoute(
            builder: (context) => PickupDropAddress(
              lat: context
                      .read<DashBoardController>()
                      .currentLocation
                      ?.latitude ??
                  0.0,
              long: context
                      .read<DashBoardController>()
                      .currentLocation
                      ?.longitude ??
                  0.0,
              pickupaddess:
                  context.read<DashBoardController>().fullAddress ?? '',
            ),
          ));
        },
        cursorColor: AppColors.grey500,
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: InkWell(
            onTap: () {
              AppEnvironment.navigator.push(
                MaterialPageRoute(
                  builder: (context) => ScheduleRide(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_filled_outlined,
                    color: AppColors.black,
                  ),
                  sizedBoxWithWidth(3),
                  Text(
                    "Now",
                    style: AppText.text14w400.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.black,
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          hintText: "Where to?",
          hintStyle: AppText.text18w400.copyWith(
            color: AppColors.black,
            height:
                1.6, //                                <----- this was the key
          ),
          isDense: true,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.black,
            size: 25,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
