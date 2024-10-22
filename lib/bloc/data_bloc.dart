import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataLoading()) {
    // Register the event handler for FetchData
    on<FetchData>(_onFetchData);
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    emit(DataLoading()); // Emit the loading state
    try {
      final response =
          await http.get(Uri.parse('https://api.restful-api.dev/objects'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        log('Data fetched successfully: $data');
        emit(DataLoaded(data)); // Emit the loaded state with data
      } else {
        log('Error fetching data: ${response.statusCode}');
        emit(DataError()); // Emit the error state
      }
    } catch (e) {
      log('Error fetching data: $e');
      emit(DataError()); // Emit the error state on exception
    }
  }
}
