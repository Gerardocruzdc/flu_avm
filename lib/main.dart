import 'package:flu_avm/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/providers.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp()
      )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool estTenebrisModus = ref.watch(estTenebrisModusProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flu_avm',
      routerConfig: appRouter,
      theme:AppTheme(tenebrisModusEst: estTenebrisModus, electusColor: Colors.pink.shade900).getTheme(),
    );
  }
}

 