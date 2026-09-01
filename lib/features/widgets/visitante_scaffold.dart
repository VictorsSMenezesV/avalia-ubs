import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:provider/provider.dart';

class VisitanteAreaScaffold extends StatelessWidget {
  final Widget body;
  const VisitanteAreaScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AvaliaUBS')),
      drawer: const _UserDrawer(),
      body: body,
    );
  }
}

class _UserDrawer extends StatelessWidget {
  const _UserDrawer();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final localAtual = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("AvaliaUBS", style: TextStyle(color: Colors.white, fontSize: 24)),
                const SizedBox(height: 8),
                Text(
                  auth.isVisitor ? "Modo Visitante" : "Logado como: ${auth.currentUser?.email}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Início"),
            onTap: () {
              Navigator.pop(context); // fecha o Drawer
              if (localAtual != '/') context.go('/');
            },
          ),
          if (auth.isVisitor)
            ListTile(
              leading: const Icon(Icons.person_add_alt_1_outlined),
              title: const Text("Fazer Cadastro"),
              onTap: () {
                Navigator.pop(context);
                context.push('/signup'); 
              },
            ),
          if (!auth.isVisitor && auth.currentUser != null)
            ListTile(
              leading: const Icon(Icons.history_edu_outlined),
              title: const Text("Meu Histórico de Avaliações"),
              onTap: () {
                Navigator.pop(context);
                context.go('/historico-avaliacoes');
              },
            ),
            ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text("Favoritos"),
            onTap: () {
              Navigator.pop(context);
              context.go('/favoritos');  
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text("Unidades Próximas de Você"),
            onTap: () {
              Navigator.pop(context);
              context.go('/favoritos');  
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text("Sair"),
            onTap: () async {
              Navigator.pop(context);
              await auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}