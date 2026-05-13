import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:mink/app.dart";
import "package:mink/core/config/env.dart";
import "package:mink/core/supabase/supabase_bootstrap.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();
  await initSupabase();
  runApp(const ProviderScope(child: MinkApp()));
}
