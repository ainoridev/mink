import "package:flutter_riverpod/flutter_riverpod.dart";

/// Example state: replace with notifiers/use-cases wired from domain as features grow.
final homeCounterProvider = StateProvider<int>((ref) => 0);
