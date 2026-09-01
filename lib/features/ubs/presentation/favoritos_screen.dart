import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';
import 'package:meu_app/features/ubs/presentation/providers/favorito_controller.dart';
import 'package:provider/provider.dart';


class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late final Stream<List<FavoritoEntity>> _favoritosStream;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthController>().currentUser!.uid;
    _favoritosStream = context.read<FavoritoController>().favoritos(userId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FavoritoEntity>>(
      stream: _favoritosStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("Erro ao buscar favoritos: ${snapshot.error}");
          return const Center(child: Text('Não foi possível carregar seus favoritos.'));
        }
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final favoritos = snapshot.data!;
        if (favoritos.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Você ainda não favoritou nenhuma UBS.', textAlign: TextAlign.center),
            ),
          );
        }

        return ListView.builder(
          itemCount: favoritos.length,
          itemBuilder: (context, i) {
            final f = favoritos[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text(f.ubsNome),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/ubs/${f.ubsId}', extra: f.ubsNome),
              ),
            );
          },
        );
      },
    );
  }
}