import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacre_memento_app/ui/home.dart';

class SelectModeCubit extends Cubit<bool> {
  SelectModeCubit() : super(false);

  void selectMode(bool yes) {
    if (yes) {
      return emit(true);
    } else {
      for (var i = 0; i < Home.count; i++) {
        Home.isChecked[i] = false;
      }
      return emit(false);
    }
  }
}
