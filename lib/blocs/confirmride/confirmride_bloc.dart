import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/confirmride.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'confirmride_event.dart';
part 'confirmride_state.dart';

class ConfirmrideBloc extends Bloc<ConfirmrideEvent, ConfirmrideState> {
  ConfirmrideBloc() : super(ConfirmrideInitial()) {
    String data = "";
    on<ConfirmrideEvent>((event, emit) async {
      if (event is DoConfirmRide) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        emit.call(ConfirmLoading());
        try {
          await AppRepository()
              .confirmuseride(
            accesstoken: prefs.getString(Strings.accesstoken)!,
            pickuplocation: event.pickuplocation,
            droplocation: event.droplocation,
            userid: prefs.getString(Strings.userid)!,
          )
              .then((value) {
            if (value['code'] == null) {
              emit.call(ConfirmFail(
                  error:
                      'Invalid requested location. Please reselect the locations '));
            }
            if (value["code"] == 200) {
              var _confirmRide = ConfirmRide.fromJson(value);
              emit.call(
                ConfirmLoaded(confirmRide: _confirmRide),
              );
            } else if (value["code"] == 201) {
              emit.call(ConfirmFail(error: value["message"]));
            } else if (value["code"] == 401) {
            } else {
              emit.call(ConfirmFail(error: value["message"]));
            }
          });
        } catch (e) {
          emit.call(ConfirmFail(
              error:
                  'Invalid requested location. Please reselect the locations'));
        }
      }
    });
  }
}
