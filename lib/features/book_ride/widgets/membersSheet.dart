import 'package:flutter/material.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/features/add_member/add_member.dart';
import 'package:multitrip_user/models/listmembers.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';

class MembersSheet extends StatefulWidget {
  final List<Member> members;

  const MembersSheet({
    super.key,
    required this.members,
  });

  @override
  State<MembersSheet> createState() => _MembersSheetState();
}

class _MembersSheetState extends State<MembersSheet> {
  int selectedvalue = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.members.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 20.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                  size: 20,
                ),
              ),
              widget.members.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 5.h,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedvalue = index;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.black,
                                  ),
                                ),
                                sizedBoxWithWidth(10),
                                Text(
                                  widget.members.elementAt(index).fname,
                                  style: AppText.text14w400.copyWith(
                                    fontSize: 12.sp,
                                    color: AppColors.black,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 20.h,
                                  width: 20.w,
                                  child: Icon(
                                    Icons.circle,
                                    color: selectedvalue == index
                                        ? Colors.white
                                        : AppColors.black,
                                    size: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.black,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1.9,
                          color: AppColors.greylight,
                        );
                      },
                      itemCount: widget.members.length,
                    )
                  : SizedBox(),
              sizedBoxWithHeight(
                10,
              ),
              Divider(
                thickness: 1.9,
                color: AppColors.greylight,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  AppEnvironment.navigator.push(
                    MaterialPageRoute(
                      builder: (context) => AddMember(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.person_add_alt_rounded,
                      color: AppColors.black,
                    ),
                    sizedBoxWithWidth(
                      10,
                    ),
                    Text(
                      "Add a member",
                      style: AppText.text14w400.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
