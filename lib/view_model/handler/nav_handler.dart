import '../interface/fetch_strategy_interface.dart';

class NavHandler {
  late IFetchStrategy _strategy;

  set strategy(IFetchStrategy strategy) {
    _strategy = strategy;
  }

  Future fetch() async {
    return await _strategy.fetch();
  }
}
