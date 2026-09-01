import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:meu_app/features/widgets/denunciar_dialog.dart';
import 'package:meu_app/features/widgets/favorita_button.dart';
import 'package:provider/provider.dart';

class AvaliacoesUbsScreen extends StatefulWidget {
  final String ubsId;
  final String ubsNome;
  const AvaliacoesUbsScreen({
    super.key,
    required this.ubsId,
    required this.ubsNome,
  });

  @override
  State<AvaliacoesUbsScreen> createState() => _AvaliacoesUbsScreenState();
}

class _AvaliacoesUbsScreenState extends State<AvaliacoesUbsScreen> {
  late final Stream<List<AvaliacaoEntity>> _avaliacoesStream;

  @override
  void initState() {
    super.initState();
    debugPrint("initState chamado — criando o Stream");
    _avaliacoesStream = context.read<AvaliacaoController>().avaliacoesPorUbs(
      widget.ubsId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context
        .watch<
          AuthController
        >(); 
        

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ubsNome),
        actions: [FavoritoButton(ubsId: widget.ubsId, ubsNome: widget.ubsNome)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.rate_review_outlined),
        label: const Text('Avaliar'),
        onPressed: () {
          if (auth.isVisitor) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Para fazer avaliações é preciso se cadastrar'),
              ),
            );
            return;
          }
          context.push('/ubs/${widget.ubsId}/avaliar', extra: widget.ubsNome);
        },
      ),
      body: StreamBuilder<List<AvaliacaoEntity>>(
        stream:
            _avaliacoesStream, // <- sempre a mesma instância, nunca recriado
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint("Erro ao carregar avaliações: ${snapshot.error}");
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Não foi possível carregar as avaliações no momento.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final avaliacoes = snapshot.data!;
          if (avaliacoes.isEmpty) {
            return const Center(
              child: Text('Ainda não há avaliações públicas para essa UBS.'),
            );
          }
          return ListView.builder(
            itemCount: avaliacoes.length,
            itemBuilder: (context, i) {
              final a = avaliacoes[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  trailing: IconButton(
                    icon: const Icon(Icons.flag_outlined, size: 20),
                    tooltip: 'Denunciar',
                    onPressed: () {
                      if (auth.isVisitor) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Para fazer denunciar uma avaliação é preciso se cadastrar',
                            ),
                          ),
                        );
                        return;
                      }
                      mostrarDialogoDenuncia(
                        context,
                        avaliacaoId: a.id,
                        ubsId: widget.ubsId,
                      );
                    },
                  ),
                  leading: CircleAvatar(child: Text('${a.nota}')),
                  title: Text(a.comentario ?? '(avaliação sem comentário)'),
                  subtitle: Text(_resumoCondicoes(a)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _resumoCondicoes(AvaliacaoEntity a) {
    final partes = <String>[];
    if (a.teveMedicamentoDisponivel != null) {
      partes.add(
        a.teveMedicamentoDisponivel! ? 'Tinha medicamento' : 'Sem medicamento',
      );
    }
    if (a.tempoEspera != null) partes.add(a.tempoEspera!.label);
    if (a.lotacao != null) partes.add(a.lotacao!.label);
    return partes.join(' • ');
  }
}
