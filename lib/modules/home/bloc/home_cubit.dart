import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required this.repository}) : super(HomeState.initial());

  final HomeRepository repository;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final message = await repository.fetchHomeMessage();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          message: message,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          message: 'Unable to load module data: $error',
        ),
      );
    }
  }
}
