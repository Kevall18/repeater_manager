import 'package:equatable/equatable.dart';

class ConnectivityState extends Equatable {
  const ConnectivityState({
    required this.isConnected,
    required this.hasCheckedConnection,
  });

  final bool isConnected;
  final bool hasCheckedConnection;

  factory ConnectivityState.initial() {
    return const ConnectivityState(
      isConnected: true,
      hasCheckedConnection: false,
    );
  }

  ConnectivityState copyWith({
    bool? isConnected,
    bool? hasCheckedConnection,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      hasCheckedConnection: hasCheckedConnection ?? this.hasCheckedConnection,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        isConnected,
        hasCheckedConnection,
      ];
}
