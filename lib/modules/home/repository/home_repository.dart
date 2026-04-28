class HomeRepository {
  const HomeRepository();

  Future<String> fetchHomeMessage() async {
    return 'Fresh data loaded for the current route at ${DateTime.now().toIso8601String()}';
  }
}
