import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/blocs/address/address_bloc.dart';
import 'package:multitrip_user/blocs/locationbloc/location_bloc_bloc.dart';
import 'package:multitrip_user/models/address.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddHomeAndWork extends StatefulWidget {
  const AddHomeAndWork({super.key});

  @override
  State<AddHomeAndWork> createState() => _AddHomeAndWorkState();
}

class _AddHomeAndWorkState extends State<AddHomeAndWork> {
  final controller = TextEditingController();
  late GoogleMapController googleMapController;
  Position? position;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(FetchAddress());
    context.read<LocationBlocBloc>().add(ClearSuggestionList());
    fetchlocation();
  }

  Future<void> fetchlocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppRepository().storeuserlatlong(
      accesstoken: prefs.getString(
        Strings.accesstoken,
      )!,
      user: prefs.getString(
        Strings.userid,
      )!,
      lat: position!.latitude.toString(),
      long: position!.longitude.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
          backgroundColor: AppColors.appColor,
          elevation: 0,
          title: Text(
            'Saved Places',
            style: AppText.text16w400.copyWith(color: Colors.black),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )),
      body: Padding(
        padding: EdgeInsets.all(
          16.r,
        ),
        child: BlocConsumer<LocationBlocBloc, LocationBlocState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Container(
                  color: Colors.grey.shade300,
                  child: TextFormField(
                    controller: controller,
                    onTap: () {
                      context
                          .read<LocationBlocBloc>()
                          .add(ClearSuggestionList());
                    },
                    onChanged: (value) {
                      BlocProvider.of<LocationBlocBloc>(context).add(
                        FetchSuggestions(query: value),
                      );
                    },
                    cursorColor: AppColors.grey500,
                    decoration: InputDecoration(
                      hintText: "Enter location",
                      hintStyle: AppText.text14w400.copyWith(
                        color: AppColors.grey500,
                      ),
                      contentPadding: EdgeInsets.all(8.w),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                sizedBoxWithHeight(10),
                // sizedBoxWithHeight(40),
                BlocConsumer<AddressBloc, AddressState>(
                  listener: (context, state) {
                    Loader.show(context);
                    if (state is AddressLoaded) {
                      Loader.hide();
                    } else {
                      Loader.hide();
                    }
                    if (state is AddAddressSucess) {
                      context.showSnackBar(context, msg: ' Successfully');
                    }
                  },
                  builder: (context, state) {
                    if (state is AddressLoaded) {
                      return ExpansionTile(
                        title: Text(
                          "Saved Places",
                          style: AppText.text16w400.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                        children: List.generate(
                            state.address.address.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    PanaraConfirmDialog.show(context,
                                        title: "Delete",
                                        color: AppColors.green,
                                        message:
                                            "Do you want to delete this place?",
                                        onTapCancel: () {
                                      Navigator.pop(context);
                                    }, onTapConfirm: () async {
                                      Navigator.pop(context);

                                      context.read<AddressBloc>().add(
                                          RemoveAddress(
                                              element: state.address
                                                  .address[index].placeId));
                                    },
                                        panaraDialogType:
                                            PanaraDialogType.custom,
                                        barrierDismissible: false,
                                        cancelButtonText: 'No',
                                        confirmButtonText: 'yes'
                                        // optional parameter (default is true)
                                        );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 32.h,
                                          width: 32.w,
                                          child: Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.greydark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.address.address[index]
                                                    .addressLine1,
                                                style:
                                                    AppText.text16w400.copyWith(
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              Text(
                                                state.address.address[index]
                                                    .addressLine2,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    AppText.text14w400.copyWith(
                                                  color: AppColors.grey500,
                                                  fontSize: 13.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      );
                    }
                    return SizedBox();
                  },
                ),
                sizedBoxWithHeight(10),
                if (state is SuggestionsLoaded) ...{
                  // Loader.hide();
                  ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.predictions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          LatLng latLng = await getPlaceLatLng(
                              state.predictions.elementAt(index).placeId);
                          context.read<AddressBloc>().add(
                                AddAddress(
                                  element: AddressElement(
                                    placeId: state.predictions
                                        .elementAt(index)
                                        .placeId,
                                    addressLine1: state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .mainText,
                                    latitude: latLng.latitude.toString(),
                                    longitude: latLng.longitude.toString(),
                                    addressLine2: state.predictions
                                        .elementAt(index)
                                        .structuredFormatting
                                        .secondaryText,
                                  ),
                                ),
                              );
                          context.read<AddressBloc>().add(FetchAddress());
                          context
                              .read<LocationBlocBloc>()
                              .add(ClearSuggestionList());
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 12.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50.h,
                                width: 50.w,
                                child: Icon(
                                  Icons.access_time_filled_sharp,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                decoration: BoxDecoration(
                                    color: AppColors.greydark,
                                    shape: BoxShape.circle),
                              ),
                              sizedBoxWithWidth(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.predictions
                                          .elementAt(index)
                                          .structuredFormatting
                                          .mainText,
                                      style: AppText.text16w400.copyWith(
                                        color: AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      state.predictions
                                          .elementAt(index)
                                          .structuredFormatting
                                          .secondaryText,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppText.text14w400.copyWith(
                                        color: AppColors.grey500,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                },
              ],
            );
          },
        ),
      ),
    );
  }
}
