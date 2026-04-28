import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    required this.message,
  });

  final HomeStatus status;
  final String message;

  factory HomeState.initial() {
    return const HomeState(
      status: HomeStatus.initial,
      message: 'Module scaffold is ready.',
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        message,
      ];
}
