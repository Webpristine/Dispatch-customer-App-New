import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/models/address.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressInitial()) {
    on<AddressEvent>((event, emit) async {
      if (event is AddAddress) {
        print("Event is $emit");

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .addAddress(
                  userid: prefs.getString(
                    Strings.userid,
                  )!,
                  accesstoken: prefs.getString(
                    Strings.accesstoken,
                  )!,
                  element: event.element)
              .then((value) {
            if (value["code"] == 200) {
              emit.call(
                AddAddressSucess(),
              );
              add(
                FetchAddress(),
              );
            } else if (value["code"] == 201) {
              emit.call(
                AddAddressSucess(),
              );
            } else if (value["code"] == 401) {
            } else {
              emit.call(
                AddressFailed(
                  error: value["message"],
                ),
              );
            }
          });
        } catch (e) {
          emit.call(
            AddressFailed(
              error: e.toString(),
            ),
          );
        }
      }
      if (event is RemoveAddress) {
        print("Event is $emit");

        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .removeAddress(
            userid: prefs.getString(
              Strings.userid,
            )!,
            accesstoken: prefs.getString(
              Strings.accesstoken,
            )!,
            element: event.element!,
          )
              .then((value) {
            if (value["code"] == 200) {
              emit.call(
                AddAddressSucess(),
              );
              add(
                FetchAddress(),
              );
            } else if (value["code"] == 201) {
              emit.call(
                AddAddressSucess(),
              );
            } else if (value["code"] == 401) {
            } else {
              emit.call(
                AddressFailed(
                  error: value["message"],
                ),
              );
            }
          });
        } catch (e) {
          emit.call(
            AddressFailed(
              error: e.toString(),
            ),
          );
        }
      }
      if (event is FetchAddress) {
        print("Event is $emit");
        emit.call(AddressLoading());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .fetchaddress(
            userid: prefs.getString(
              Strings.userid,
            )!,
            accesstoken: prefs.getString(
              Strings.accesstoken,
            )!,
          )
              .then((value) {
            if (value["code"] == 200) {
              var _address = Address.fromJson(
                value,
              );
              emit.call(
                AddressLoaded(
                  address: _address,
                ),
              );
            } else if (value["code"] == 201) {
              emit.call(
                AddressNotFound(),
              );
            } else if (value["code"] == 401) {
            } else {
              emit.call(
                AddressFailed(
                  error: value["message"],
                ),
              );
            }
          });
        } catch (e) {
          emit.call(
            AddressFailed(
              error: e.toString(),
            ),
          );
        }
      } else if (event is InitBloc) {
        emit.call(AddressInitial());
      }
    });
  }
}
