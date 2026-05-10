import "package:flutter_riverpod/flutter_riverpod.dart";

/// Ejemplo de estado mutable: en features reales, preferir casos de uso en domain.
final homeCounterProvider =
    NotifierProvider<HomeCounterNotifier, int>(HomeCounterNotifier.new);

class HomeCounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}
