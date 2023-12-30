import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/listmembers.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'member_event.dart';
part 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  MemberBloc() : super(MemberInitial()) {
    on<MemberEvent>((event, emit) async {
      if (event is FetchMembers) {
        emit.call(MemberLoading());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .getmemberslist(
            accesstoken: prefs.getString(
              Strings.accesstoken,
            )!,
            userid: prefs.getString(
              Strings.userid,
            )!,
          )
              .then((value) {
            if (value['code'] == null) {
              emit.call(
                MembersFail(
                  error: 'Unable to load the member list.Please try again',
                ),
              );
            }
            if (value["code"] == 200) {
              var listMembers = ListMembers.fromJson(
                value,
              );
              listMembers.members.add(Member(
                id: "0",
                fname: "Me",
                lname: "",
                mobileNumber: "",
                email: "",
                address: "",
              ));
              emit.call(
                MemberLoaded(listMembers: listMembers),
              );
            } else if (value["code"] == 401) {
            } else {
              var listMembers = ListMembers(
                code: 200,
                message: "",
                members: [
                  Member(
                    id: "0",
                    fname: "Me",
                    lname: "",
                    mobileNumber: "",
                    email: "",
                    address: "",
                  )
                ],
              );
              emit.call(MemberLoaded(listMembers: listMembers));
            }
          });
        } catch (e) {
          emit.call(
            MembersFail(
              error: e.toString(),
            ),
          );
        }
      }
    });
  }
}
