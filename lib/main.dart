import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meu_app/core/di/locator.dart';
import 'package:meu_app/core/routes/app_route.dart';
import 'package:meu_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/favorito_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_lista_paginada_controller.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // .value: NÃO cria uma instância nova — reaproveita o singleton do get_it.
        // Isso é o que faz a UI continuar reconstruindo via notifyListeners(),
        // já que o Provider ainda está "de olho" nessa instância específica
        ChangeNotifierProvider<AuthController>.value(
          value: locator<AuthController>(),
        ),
        ChangeNotifierProvider<UbsController>.value(
          value: locator<UbsController>(),
        ),
        ChangeNotifierProvider<AvaliacaoController>.value(
          value: locator<AvaliacaoController>(),
        ),
        ChangeNotifierProvider<AdminController>.value(
          value: locator<AdminController>(),
        ),
        ChangeNotifierProvider<UbsListaPaginadaController>.value(
          value: locator<UbsListaPaginadaController>(),
        ), // <- faltava
        ChangeNotifierProvider<FavoritoController>.value(
          value: locator<FavoritoController>(),
        ),
      ],
      child: const AppComRouter(),
    );
  }
}

// Widget separado porque o MultiProvider.builder não expõe seu próprio
// context como consumidor dos providers que ele mesmo declara
class AppComRouter extends StatefulWidget {
  const AppComRouter({super.key});

  @override
  State<AppComRouter> createState() => _AppComRouterState();
}

class _AppComRouterState extends State<AppComRouter> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(locator<AuthController>());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "AvaliaUBS",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _appRouter.router,
    );
  }
}
