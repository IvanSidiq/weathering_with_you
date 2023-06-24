import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit() : super(DetailInitial());
  bool isShown = false;

  void showDetail() {
    isShown = !isShown;
    emit(ShowDetailSuccess());
  }
}
