import 'package:flutter_bloc/flutter_bloc.dart';

class SelectModeCubit extends Cubit<bool> {
  SelectModeCubit() : super(false);

  void selectMode(bool yes) {
    return yes ? emit(true) : emit(false);
  }
}

