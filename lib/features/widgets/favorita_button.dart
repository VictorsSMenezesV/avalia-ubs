import 'package:flutter/material.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/ubs/presentation/providers/favorito_controller.dart';
import 'package:provider/provider.dart';
class FavoritoButton extends StatelessWidget {
  final String ubsId;
  final String ubsNome;
  const FavoritoButton({super.key, required this.ubsId, required this.ubsNome});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (!auth.isLoggedUser || auth.currentUser == null) return const SizedBox.shrink();

    final userId = auth.currentUser!.uid;
    final favoritoController = context.read<FavoritoController>();

    return StreamBuilder<bool>(
      stream: favoritoController.isFavorito(userId: userId, ubsId: ubsId),
      builder: (context, snapshot) {
        final jaEhFavorito = snapshot.data ?? false;
        return IconButton(
          icon: Icon(
            jaEhFavorito ? Icons.favorite : Icons.favorite_border,
            color: jaEhFavorito ? Colors.red : null,
          ),
          onPressed: () => favoritoController.toggle(
            userId: userId, ubsId: ubsId, ubsNome: ubsNome, jaEhFavorito: jaEhFavorito,
          ),
        );
      },
    );
  }
}