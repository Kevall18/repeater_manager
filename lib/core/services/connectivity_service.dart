import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> hasConnection() async {
    try {
      final Object result = await _connectivity.checkConnectivity();
      if (result is List<ConnectivityResult>) {
        return result.isNotEmpty &&
            result.any((item) =>
                item.toString() != ConnectivityResult.none.toString());
      }

      return result.toString() != ConnectivityResult.none.toString();
    } catch (_) {
      return true;
    }
  }
}
