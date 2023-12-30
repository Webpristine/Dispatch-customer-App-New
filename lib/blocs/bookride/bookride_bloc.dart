import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/bookrider.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'bookride_event.dart';
part 'bookride_state.dart';

class BookrideBloc extends Bloc<BookrideEvent, BookrideState> {
  BookrideBloc() : super(BookrideInitial()) {
    on<BookrideEvent>((event, emit) async {
      if (event is DoBookRide) {
        emit.call(BookRideLoading());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .bookride(
            accesstoken: prefs.getString(Strings.accesstoken)!,
            booking_number: event.bookingid,
            vehicle_id: event.vehicleid,
            notes: event.notes,
            payment_mode: event.payment_mode,
            user_id: prefs.getString(Strings.userid)!,
          )
              .then((value) {
            if (value["code"] == 200) {
              var _bookride = BookRide.fromJson(value);
              emit.call(
                BookRideLoaded(bookRide: _bookride),
              );
            } else if (value["code"] == 201) {
              emit.call(
                BookRideFail(
                  error: value["message"],
                ),
              );
            } else if (value["code"] == 401) {
            } else {
              emit.call(
                BookRideFail(
                  error: value["message"],
                ),
              );
            }
          });
          ;
        } catch (e) {
          emit.call(
            BookRideFail(
              error: e.toString(),
            ),
          );
        }
      }
    });
  }
}
