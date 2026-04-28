import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit() : super(ConnectivityState.initial()) {
    _initialize();
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  Future<void> _initialize() async {
    try {
      await _updateStatus(await _connectivity.checkConnectivity());
      _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
    } catch (_) {
      emit(
        state.copyWith(
          isConnected: true,
          hasCheckedConnection: true,
        ),
      );
    }
  }

  Future<void> _updateStatus(Object? result) async {
    emit(
      state.copyWith(
        isConnected: _isConnected(result),
        hasCheckedConnection: true,
      ),
    );
  }

  bool _isConnected(Object? result) {
    if (result is List) {
      return result.isNotEmpty &&
          result.any(
              (item) => item.toString() != ConnectivityResult.none.toString());
    }

    return result != null &&
        result.toString() != ConnectivityResult.none.toString();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
