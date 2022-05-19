import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sacre_memento_app/ui/component/more_select_menu.dart';

import '../ui/component/more_menu.dart';

class SelectModeCubit extends Cubit<Widget> {
  SelectModeCubit() : super(const MoreMenu());

  void selectMode(bool yes) {
    if (yes) {
      return emit(const MoreSelectMenu());
    } else {
      return emit(const MoreMenu());
    }
  }
}
