import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:provider/provider.dart';

class HistoricoAvaliacoesScreen extends StatefulWidget {
  const HistoricoAvaliacoesScreen({super.key});

  @override
  State<HistoricoAvaliacoesScreen> createState() =>
      _HistoricoAvaliacoesScreenState();
}

class _HistoricoAvaliacoesScreenState extends State<HistoricoAvaliacoesScreen> {
  late final Stream<List<AvaliacaoEntity>> _minhasAvaliacoesStream;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthController>().currentUser!.uid;
    _minhasAvaliacoesStream = context
        .read<AvaliacaoController>()
        .minhasAvaliacoes(userId);
  }

  void _confirmarExclusao(BuildContext context, String avaliacaoId) {
  showDialog(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: const Text('Excluir avaliação'),
      content: const Text('Essa ação não pode ser desfeita.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancelar')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            final erro = await dialogCtx.read<AvaliacaoController>().excluirAvaliacao(avaliacaoId);
            if (dialogCtx.mounted) Navigator.pop(dialogCtx);
            if (context.mounted && erro != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro.toString())));
            }
          },
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AvaliacaoEntity>>(
      stream: _minhasAvaliacoesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint("Erro ao buscar minhas avaliações: ${snapshot.error}");
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Não foi possível carregar suas avaliações no momento.',
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
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Você ainda não avaliou nenhuma UBS.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: avaliacoes.length,
          itemBuilder: (context, i) {
            final a = avaliacoes[i];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            a.ubsNome,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _StatusBadge(status: a.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < a.nota ? Icons.star : Icons.star_border,
                          size: 18,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    if (a.comentario != null && a.comentario!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(a.comentario!),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      _formatarData(a.criadaEm),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Editar'),
                          onPressed: () => context.push(
                            '/ubs/${a.ubsId}/avaliar',
                            extra: {'ubsNome': a.ubsNome, 'avaliacao': a},
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Excluir'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () => _confirmarExclusao(context, a.id),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final StatusAvaliacao status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (cor, texto) = switch (status) {
      StatusAvaliacao.aprovada => (Colors.green, 'Publicada'),
      StatusAvaliacao.analise => (Colors.orange, 'Em análise'),
      StatusAvaliacao.rejeitada => (Colors.red, 'Não aprovada'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
