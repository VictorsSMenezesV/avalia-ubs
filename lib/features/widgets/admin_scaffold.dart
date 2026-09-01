import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:provider/provider.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  const AdminScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Painel Admin')),
      drawer: const _AdminDrawer(),
      body: body,
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final localAtual = GoRouterState.of(context).matchedLocation;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: const Text("AvaliaUBS — Admin", style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Início"),
            onTap: () {
              Navigator.pop(context);
              if (localAtual != '/admin') context.go('/admin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital_outlined),
            title: const Text("UBS"),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/ubs');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_business_outlined),
            title: const Text("Cadastrar UBS"),
            onTap: () {
              Navigator.pop(context);
              context.push('/admin/ubs/novo');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text("Usuários"),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin/usuarios');
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