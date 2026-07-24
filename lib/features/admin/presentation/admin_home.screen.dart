import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    return Center(
      child: Column(
        children: [
          const Text(
            'Bem-vindo ao painel administrativo.\nSelecione uma opção no menu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          ElevatedButton(onPressed: auth.signOut, child: const Text("sair"))
        ],
      ),
    );
  }
}