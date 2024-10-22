abstract class DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<dynamic> data;
  DataLoaded(this.data);
}

class DataError extends DataState {}
