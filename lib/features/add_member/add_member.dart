import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:multitrip_user/logic/add_member/member_controller.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';

class AddMember extends StatefulWidget {
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  Country country = Country(
    phoneCode: "+1",
    countryCode: "CA",
    e164Sc: 1,
    geographic: false,
    level: 1,
    name: "CANADA",
    example: "",
    displayName: "Canada",
    displayNameNoCountryCode: "",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    final membercontroller = Provider.of<MembersController>(
      context,
      listen: true,
    );
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          "New member",
          style: AppText.text15w500.copyWith(
            color: AppColors.black,
          ),
        ),
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
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "This contact won't be saved in your device's\naddress book",
                style: AppText.text14w400.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              sizedBoxWithHeight(
                25,
              ),
              CommonTextField(
                controller: membercontroller.firstnamecontroller,
                title: "Full Name",
              ),
              sizedBoxWithHeight(
                15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Phone Number",
                    style: AppText.text15Normal.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                  sizedBoxWithHeight(
                    5,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print("fkf");
                          showCountryPicker(
                            context: context,
                            showPhoneCode:
                                true, // optional. Shows phone code before the country name.
                            onSelect: (Country scountry) {
                              setState(() {
                                country = scountry;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: 65.w,
                          height: 50.h,
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                country.flagEmoji,
                                style: TextStyle(
                                  fontSize: 25.sp,
                                ),
                              ),
                              sizedBoxWithWidth(5),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.black,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedBoxWithWidth(10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10.w,
                          ),
                          child: Row(
                            children: [
                              Text(country.phoneCode,
                                  style: AppText.text15Normal.copyWith(
                                    color: AppColors.black,
                                  )),
                              sizedBoxWithWidth(
                                10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  maxLength: 11,
                                  controller: membercontroller.phoneController,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: "Mobile Number",
                                    hintStyle: AppText.text15Normal.copyWith(
                                      color: AppColors.hintColor,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              )
                            ],
                          ),
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              sizedBoxWithHeight(
                30,
              ),
              Text(
                  "By tapping Add member, you confirm that your friend aggreed to share their contact information with us and to recieve SMS about this trip.",
                  style: AppText.text15w400.copyWith(
                    color: AppColors.grey500,
                  )),
              InkWell(
                onTap: () {
                  if (membercontroller.firstnamecontroller.text.isEmpty) {
                    context.showSnackBar(
                      context,
                      msg: 'Please Enter First Name',
                    );
                  } else if (membercontroller.phoneController.text.isEmpty) {
                    context.showSnackBar(
                      context,
                      msg: "Please enter mobile number",
                    );
                  } else {
                    membercontroller.addmember(context: context);
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    top: 15.h,
                  ),
                  child: Center(
                    child: Text(
                      "Add member",
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
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final int? maxLines;
  const CommonTextField({
    super.key,
    required this.title,
    this.maxLines,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxWithHeight(
          15,
        ),
        Text(
          title,
          style: AppText.text15Normal.copyWith(
            color: AppColors.black,
          ),
        ),
        sizedBoxWithHeight(5),
        Container(
          color: Colors.grey.shade300,
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            cursorColor: AppColors.grey500,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: 10.w,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
