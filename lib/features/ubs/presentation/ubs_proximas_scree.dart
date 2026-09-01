
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_proxima_controller.dart';
import 'package:meu_app/features/widgets/favorita_button.dart';
import 'package:provider/provider.dart';


class UnidadesProximasScreen extends StatelessWidget {
  const UnidadesProximasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UbsProximasController>();

    switch (controller.estado) {
      case EstadoUbsProximas.carregando:
        return const Center(child: Column(
          children: [
            CircularProgressIndicator(),
            Text("Estamos buscando as UBS proxímas de você, aguarde...")
          ],
        ));

      case EstadoUbsProximas.semPermissao:
        return _EstadoVazio(
          icone: Icons.location_off,
          mensagem: 'Não conseguimos acessar sua localização. '
              'Verifique se o GPS está ativado e a permissão foi concedida.',
          onTentarNovamente: controller.carregar,
        );

      case EstadoUbsProximas.semDados:
        return _EstadoVazio(
          icone: Icons.location_searching,
          mensagem: 'Nenhuma UBS com localização cadastrada foi encontrada.',
          onTentarNovamente: controller.carregar,
        );

      case EstadoUbsProximas.sucesso:
        return RefreshIndicator(
          onRefresh: controller.carregar,
          child: ListView.builder(
            itemCount: controller.ubsProximas.length,
            itemBuilder: (context, i) {
              final ubs = controller.ubsProximas[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(ubs.nome),
                  subtitle: Text('${ubs.distanciaKm!.toStringAsFixed(1)} km de você'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FavoritoButton(ubsId: ubs.id, ubsNome: ubs.nome),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.push('/ubs/${ubs.id}', extra: ubs.nome),
                ),
              );
            },
          ),
        );
    }
  }
}

class _EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String mensagem;
  final VoidCallback onTentarNovamente;
  const _EstadoVazio({required this.icone, required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(mensagem, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onTentarNovamente, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }
}