import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_exceptions.dart';
import 'package:multitrip_user/models/locationsuggestion.dart' as lc;
import 'package:http/http.dart' as client;
import 'package:multitrip_user/models/locationsuggestion.dart';

part 'location_bloc_event.dart';

part 'location_bloc_state.dart';

GoogleMapsPlaces places =
    GoogleMapsPlaces(apiKey: 'AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY');

class LocationBlocBloc extends Bloc<LocationBlocEvent, LocationBlocState> {
  LocationBlocBloc() : super(LocationBlocInitial()) {
    on<LocationBlocEvent>((event, emit) async {
      if (event is FetchSuggestions) {
        emit.call(SuggestionsLoading());
        try {
          LocationSuggestion suggestions = await fetchSuggestions(event.query);
          emit.call(SuggestionsLoaded(predictions: suggestions.predictions));
        } catch (e) {
          emit.call(
            SuggestionError(
              error: e.toString(),
            ),
          );
        }
      } else if (event is InitBloc) {
        emit.call(LocationBlocInitial());
      } else if (event is FetchDropLatlong) {
        emit.call(DropLatLongLoading());
        try {
          LatLng latLng = await getPlaceLatLng(event.placeId);
          emit.call(
            DropLatLongLoaded(latLng: latLng),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid Drop Location Location.');
        }
      } else if (event is FetchSecondDropLatlong) {
        emit.call(DropLatLongLoading());
        try {
          final latLng = await getPlaceLatLng(event.placeId);
          emit.call(
            DropSecondaryLatLongLoaded(latLng: latLng),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid Drop Location Location.');
        }
      } else if (event is FetchThirdDropLatlong) {
        emit.call(DropLatLongLoading());
        try {
          final latLng = await getPlaceLatLng(event.placeId);
          emit.call(
            DropThirdLatLongLoaded(latLng: latLng),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid Drop Location Location.');
        }
      } else if (event is FetchForthDropLatlong) {
        emit.call(DropLatLongLoading());
        try {
          final latLng = await getPlaceLatLng(event.placeId);
          emit.call(
            DropForthLatLongLoaded(latLng: latLng),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid Drop Location Location.');
        }
      } else if (event is FetchPickupLatLong) {
        emit.call(PickupLatLongLoading());
        try {
          LatLng latLng = await getPlaceLatLng(event.placeId);
          emit.call(
            PickupLatLongLoaded(picklatlong: latLng),
          );
        } catch (e) {
          Fluttertoast.showToast(msg: 'Invalid Pickup Location Location.');
        }
      } else if (event is ClearSuggestionList) {
        emit.call(SuggestionsLoaded(predictions: []));
      }
    });
  }
}

Future<LatLng> getPlaceLatLng(String placeId) async {
  final placeDetails = await places.getDetailsByPlaceId(placeId);

  if (placeDetails.hasNoResults) {
    return LatLng(placeDetails.result.geometry!.location.lat,
        placeDetails.result.geometry!.location.lng);
  }

  return LatLng(placeDetails.result.geometry!.location.lat,
      placeDetails.result.geometry!.location.lng);
}

Future<LocationSuggestion> fetchSuggestions(String query) async {
  final request =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=address&key=AIzaSyD6MRqmdjtnIHn7tyDLX-qsjreaTkuzSCY&region=IN';
  final response = await client.get(Uri.parse(request));

  print(response.body);
  if (response.statusCode == 200) {
    final result = json.decode(response.body);
    if (result['status'] == 'OK') {
      return LocationSuggestion.fromJson(result);
    }
    if (result['status'] == 'ZERO_RESULTS') {
      throw NotFoundException();
    }
  } else {
    throw Exception('Failed to fetch suggestion');
  }
  throw UnimplementedError();
}
