import 'package:riverpod/riverpod.dart';

extension ContainerX on ProviderContainer {
  ProviderSubscription<State> keepAlive<State>(ProviderListenable<State> provider) => listen(provider, (_, __) {});
  Result readAndKeepAlive<Result>(ProviderListenable<Result> provider) {
    final res = provider.read(this);
    keepAlive(provider);
    return res;
  }
}
