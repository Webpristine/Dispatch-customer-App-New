import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/account/account_change_password.dart';
import 'package:multitrip_user/features/account/account_email.dart';
import 'package:multitrip_user/features/account/account_name.dart';
import 'package:multitrip_user/features/account/account_phone.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final _profileImage = ValueNotifier<XFile?>(null);
  int selectedtab = 0;
  Widget _createTab(String text) {
    return Tab(
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: AppColors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80.h),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.account,
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      //This is for background color
                      color: Colors.white.withOpacity(0.0),

                      //This is for bottom border that is needed
                      border: Border(
                          bottom: BorderSide(
                              color: AppColors.greylight, width: 6.sp)),
                    ),
                    child: TabBar(
                      // padding: EdgeInsets.only(right: 100.w),
                      indicatorColor: AppColors.green,
                      // indicator: BoxDecoration(
                      //   color: AppColors.greenAccent,
                      // ),

                      indicatorWeight: 6.sp,
                      labelPadding: EdgeInsets.all(0),
                      onTap: (v) {
                        setState(() {
                          selectedtab = v;
                        });
                      },

                      tabs: [
                        Container(
                          width: double.infinity,
                          color: selectedtab == 0
                              ? AppColors.greylight
                              : Colors.transparent,
                          margin: EdgeInsets.only(
                            bottom: 0.h,
                          ),
                          child: _createTab(Strings.accountinfo),
                        ),
                        Container(
                            width: double.infinity,
                            color: selectedtab == 1
                                ? AppColors.greylight
                                : Colors.transparent,
                            margin: EdgeInsets.only(
                              bottom: 0.h,
                            ),
                            child: _createTab(Strings.security)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 0,
          leadingWidth: 40.w,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: [
              Consumer<AccountController>(builder: (context, model, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.accountinfo,
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sizedBoxWithHeight(15),
                    InkWell(
                      onTap: () {
                        _takeProfilePictureFromGallery(context);
                      },
                      child: Stack(
                        children: [
                          ValueListenableBuilder<XFile?>(
                              valueListenable: _profileImage,
                              builder: (context, image, _) {
                                return Container(
                                  height: 80.r,
                                  width: 80.r,
                                  child: image == null
                                      ? (model.userModel?.profilePhoto
                                                  ?.isNotEmpty ??
                                              false)
                                          ? null
                                          : Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 40,
                                            )
                                      : SizedBox(),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    image: (model.userModel?.profilePhoto
                                                ?.isNotEmpty ??
                                            false)
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                model.userModel?.profilePhoto ??
                                                    ''),
                                          )
                                        : image != null
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(
                                                    _profileImage.value!.path)),
                                              )
                                            : null,
                                    color: AppColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }),
                          Positioned(
                            right: 6.0,
                            bottom: .0,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 0,
                                    blurRadius: 4,
                                  )
                                ],
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: AppColors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    sizedBoxWithHeight(15),
                    Text(
                      Strings.basicinfo,
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    sizedBoxWithHeight(20),
                    InkWell(
                      onTap: () {
                        AppEnvironment.navigator.push(
                          MaterialPageRoute(
                            builder: (context) => AccountName(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.name,
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          sizedBoxWithHeight(5),
                          Text(
                            model.userModel?.name ?? 'N/A',
                            style: GoogleFonts.poppins(
                              color: AppColors.colorgrey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Divider(
                            thickness: 1.2,
                            color: AppColors.greylight,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppEnvironment.navigator.push(
                          MaterialPageRoute(
                            builder: (context) => AccountPhone(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone number",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          sizedBoxWithHeight(5),
                          Row(
                            children: [
                              Text(
                                model.userModel?.mobileNumber ?? 'N/A',
                                style: GoogleFonts.poppins(
                                  color: AppColors.colorgrey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: AppColors.green,
                                size: 14,
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1.2,
                            color: AppColors.greylight,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppEnvironment.navigator.push(
                          MaterialPageRoute(
                            builder: (context) => AccountEmail(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: GoogleFonts.poppins(
                              color: AppColors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          sizedBoxWithHeight(5),
                          Row(
                            children: [
                              Text(
                                model.userModel?.email ?? 'N/A',
                                style: GoogleFonts.poppins(
                                  color: AppColors.colorgrey,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: AppColors.green,
                                size: 14,
                              )
                            ],
                          ),
                          Divider(
                            thickness: 1.2,
                            color: AppColors.greylight,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Security",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  sizedBoxWithHeight(40),
                  Text(
                    "Logging in",
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  sizedBoxWithHeight(20),
                  InkWell(
                    onTap: () {
                      AppEnvironment.navigator.push(
                        MaterialPageRoute(
                          builder: (context) => AccountChangePassword(),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            color: AppColors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        sizedBoxWithHeight(5),
                        Text(
                          "*******",
                          style: GoogleFonts.poppins(
                            color: AppColors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Divider(
                          thickness: 1.2,
                          color: AppColors.greylight,
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _takeProfilePictureFromGallery(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.58,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.black,
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      Strings.profilephoto,
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1.2,
                    color: AppColors.greydark,
                  ),
                  Text(
                    Strings.profiledesc,
                    style: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      final croppedFile = await ImageCropper().cropImage(
                        sourcePath: image?.path ?? '',
                        aspectRatioPresets: [
                          CropAspectRatioPreset.square,
                          CropAspectRatioPreset.ratio3x2,
                          CropAspectRatioPreset.original,
                          CropAspectRatioPreset.ratio4x3,
                          CropAspectRatioPreset.ratio16x9
                        ],
                        uiSettings: [
                          AndroidUiSettings(
                              toolbarTitle: 'Cropper',
                              toolbarColor: Colors.deepOrange,
                              toolbarWidgetColor: Colors.white,
                              initAspectRatio: CropAspectRatioPreset.original,
                              lockAspectRatio: false),
                          IOSUiSettings(
                            title: 'Cropper',
                          ),
                          WebUiSettings(
                            context: context,
                          ),
                        ],
                      );
                      if (croppedFile != null) {
                        _profileImage.value = XFile(croppedFile.path);
                        _uploadImage(croppedFile.path);
                      } else {
                        Navigator.pop(context);
                        context.showSnackBar(context,
                            msg: 'Please retry again');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 15.h,
                        bottom: 0.h,
                      ),
                      child: Center(
                        child: Text(
                          Strings.update + ' Photo',
                          style: AppText.text15w500.copyWith(
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
                  sizedBoxWithHeight(15),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 0.h,
                      ),
                      child: Center(
                        child: Text(
                          Strings.cancel,
                          style: AppText.text15w500.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greydark,
                        borderRadius: BorderRadius.circular(
                          10.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: AppColors.greylight,
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        });
  }

  Future<void> _uploadImage(String path) async {
    try {
      Navigator.pop(context);

      Loader.show(context);
      await context.read<AccountController>().updateProfile(
            path: path,
            onFailure: () {
              Loader.hide();
              context.showSnackBar(context,
                  msg: 'Failed to Updated, Please try again');
            },
            onSuccess: () {
              Loader.hide();
              context.showSnackBar(context, msg: 'Successfully Updated');
              AppEnvironment.navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => PagesWidget(
                      currentTab: 2,
                    ),
                  ),
                  (_) => false);
            },
          );
    } catch (e) {
    } finally {}
  }
}
