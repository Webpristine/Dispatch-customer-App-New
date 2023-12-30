import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/features/add_member/add_member.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';

import '../../themes/app_text.dart';

class AccountName extends StatefulWidget {
  const AccountName({super.key});

  @override
  State<AccountName> createState() => _AccountNameState();
}

class _AccountNameState extends State<AccountName> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _firstName.text =
          context.read<AccountController>().userModel?.name?.split(' ').first ??
              '';
      _lastName.text =
          context.read<AccountController>().userModel?.name?.split(' ').last ??
              '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            sizedBoxWithHeight(40),
            Text(
              "Name",
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            sizedBoxWithHeight(10),
            Text(
              "Let us know how to properly address you",
              style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300),
            ),
            sizedBoxWithHeight(20),
            CommonTextField(
              title: "First Name",
              controller: _firstName,
            ),
            sizedBoxWithHeight(15),
            CommonTextField(
              title: "Last Name",
              controller: _lastName,
            ),
            Spacer(),
            GestureDetector(
              onTap: _handleOnTap,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 15.h,
                  bottom: 30.h,
                ),
                child: Center(
                  child: Text(
                    "Update",
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
          ],
        ),
      ),
    );
  }

  Future<void> _handleOnTap() async {
    FocusScope.of(context).unfocus();
    if (_firstName.text.isEmpty || _lastName.text.isEmpty) {
      context.showSnackBar(context, msg: 'Please enter the fields');
      return;
    }
    Loader.show(context);
    await context.read<AccountController>().updateName(
          firstName: _firstName.text,
          LastName: _lastName.text,
          onFailure: () {
            Loader.hide();
            context.showSnackBar(context,
                msg: 'Failed to Updated, Please try again');
          },
          onSuccess: () {
            Loader.hide();
            context.showSnackBar(context, msg: 'Successfully Updated');
            Navigator.pop(context);
          },
        );
  }
}
