// core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/presentation/avaliacao_ubs_screen.dart';
import 'package:meu_app/features/avaliacao/presentation/inserir_avaliavao_screen.dart';
import 'package:meu_app/features/auth/presentation/login_screen.dart';
import 'package:meu_app/features/auth/presentation/password_reset_screen.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/auth/presentation/signup_screen.dart';
import 'package:meu_app/features/avaliacao/presentation/historico_avaliacoes_screen.dart';
import 'package:meu_app/features/admin/presentation/admin_home.screen.dart';
import 'package:meu_app/features/ubs/presentation/favoritos_screen.dart';
import 'package:meu_app/features/ubs/presentation/pesquisa_ubs.dart';
import 'package:meu_app/features/ubs/presentation/ubs_proximas_scree.dart';
import 'package:meu_app/features/widgets/admin_scaffold.dart';
import 'package:meu_app/features/widgets/user_area_scaffold.dart';
import 'package:meu_app/features/ubs/presentation/insercao_ubs_screen.dart';

class AppRouter {
  final AuthController authController;
  AppRouter(this.authController);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: authController,
    redirect: _guardarRotas,
    routes: [

      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/reset-senha',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: '/ubs/:ubsId',
        builder: (c, s) {
          final extra = s.extra as String?;
          return AvaliacoesUbsScreen(
            ubsId: s.pathParameters['ubsId']!,
            ubsNome: extra ?? '',
          );
        },
      ),

      
      GoRoute(
  path: '/ubs/:ubsId/avaliar',
  builder: (c, s) {
    final extra = s.extra;
    final ubsId = s.pathParameters['ubsId']!;

    if (extra is Map) {
      return InserirAvaliacaoScreen(
        ubsId: ubsId,
        ubsNome: extra['ubsNome'] as String? ?? '',
        avaliacaoExistente: extra['avaliacao'] as AvaliacaoEntity?,
      );
    }

    
    return InserirAvaliacaoScreen(
      ubsId: ubsId,
      ubsNome: extra as String? ?? '',
    );
  },
),
      GoRoute(
        path: '/admin/ubs/novo',
        builder: (context, state) => const InsercaoUbsScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => UserAreaScaffold(body: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => UbsListScreen()),
          GoRoute(
            path: '/historico-avaliacoes',
            builder: (context, state) => const HistoricoAvaliacoesScreen(),
          ),
          GoRoute(
            path: '/favoritos',
            builder: (context, state) => const FavoritosScreen(),
          ),
           GoRoute(
            path: '/ubs-proximas',
            builder: (context, state) => const UnidadesProximasScreen(),
          ),
        ],
      ),

      ShellRoute(
        builder: (context, state, child) => AdminScaffold(body: child),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminHomeScreen(),
          ),
          GoRoute(
            path: '/admin/ubs',
            builder: (context, state) => const UbsListScreen(),
          ),
          GoRoute(
            path: '/admin/usuarios',
            builder: (context, state) => const UbsListScreen(),
          ),
          GoRoute(
            path: '/admin/esta',
            builder: (context, state) => const UbsListScreen(),
          ),
        ],
      ),
    ],
  );

  String? _guardarRotas(BuildContext context, GoRouterState state) {
    debugPrint(
      "Redirect avaliando: loc=${state.matchedLocation}, isLoading=${authController.isLoading}, isAdmin=${authController.isAdmin}",
    );

    if (authController.isLoading) return null;
    debugPrint(
      "Redirect avaliando: loc=${state.matchedLocation}, isLoading=${authController.isLoading}, isAdmin=${authController.isAdmin}",
    );

    final loc = state.matchedLocation;
    final isRotaAuth =
        loc == '/login' || loc == '/signup' || loc == '/reset-senha';
    final estaLogadoOuVisitante =
        authController.currentUser != null || authController.isVisitor;
    debugPrint(
      "Redirect avaliando: loc=${state.matchedLocation}, isLoading=${authController.isLoading}, isAdmin=${authController.isAdmin}",
    );

    if (!estaLogadoOuVisitante) {
      return isRotaAuth ? null : '/login';
    }
    debugPrint(
      "Redirect avaliando: loc=${state.matchedLocation}, isLoading=${authController.isLoading}, isAdmin=${authController.isAdmin}",
    );

    if (isRotaAuth) {
      return authController.isAdmin ? '/admin' : '/';
    }
    debugPrint(
      "Redirect avaliando: loc=${state.matchedLocation}, isLoading=${authController.isLoading}, isAdmin=${authController.isAdmin}",
    );

    final isRotaAdmin = loc.startsWith('/admin');

    if (isRotaAdmin && !authController.isAdmin) {
      return '/';
    }

    if (loc == '/historico-avaliacoes' && authController.isVisitor) {
      return '/';
    }

    return null;
  }
}
