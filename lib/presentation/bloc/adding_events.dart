import 'package:flutter_bloc/flutter_bloc.dart';

class AddingEventsCubit extends Cubit<bool>{
  AddingEventsCubit() : super(false);
  void setAdding(bool v) {
    emit(v);
  }
}