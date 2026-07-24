// Arquivo: lib/screens/detalhes_ubs_screen.dart
// Atualizado para usar AvaliacaoService e AvaliacaoModel


import "package:flutter/material.dart";
import "package:meu_app/features/avaliacao/presentation/historico_avaliacoes_screen.dart";
import "package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart";
import "package:provider/provider.dart";
import "../../avaliacao/domain/entities/avaliacao_entity.dart";

import "../../avaliacao/presentation/avaliacao_ubs_screen.dart";

class DetalhesUbsScreen extends StatefulWidget {
  final String ubsId;
  final String ubsNome;

  const DetalhesUbsScreen({
    Key? key,
    required this.ubsId,
    required this.ubsNome,
    bool? isVisitor
  }) : super(key: key);

  @override
  State<DetalhesUbsScreen> createState() => _DetalhesUbsScreenState();
}

class _DetalhesUbsScreenState extends State<DetalhesUbsScreen> {
  // O Stream agora virá do AvaliacaoService

  @override
  Widget build(BuildContext context) {
    final avaliacaoService = Provider.of<AvaliacaoController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.ubsNome)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detalhes da UBS: ${widget.ubsNome}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16.0),
                Text(
                  "Avaliações dos Usuários:",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<AvaliacaoEntity>>(
              stream: avaliacaoService.avaliacoesPorUbs(widget.ubsId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print("Erro ao buscar avaliações: ${snapshot.error}");
                  return const Center(
                    child: Text("Erro ao carregar avaliações."),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhuma avaliação encontrada para esta UBS ainda.",
                    ),
                  );
                }

                final avaliacoesList = snapshot.data!;

                return ListView.builder(
                  itemCount: avaliacoesList.length,
                  itemBuilder: (context, index) {
                    final avaliacao =
                        avaliacoesList[index]; // Agora é um AvaliacaoModel

                    String dataAvaliacao = "Data não disponível";
                    // O timestamp já é um Timestamp do Firestore no AvaliacaoModel
                    final dateTime = avaliacao.criadaEm;
                    dataAvaliacao =
                        "${dateTime.day}/${dateTime.month}/${dateTime.year}";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            avaliacao.nota.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          backgroundColor:
                              avaliacao.nota >= 4
                                  ? Colors.green[100]
                                  : (avaliacao.nota >= 2
                                      ? Colors.orange[100]
                                      : Colors.red[100]),
                          foregroundColor:
                              avaliacao.nota >= 4
                                  ? Colors.green[800]
                                  : (avaliacao.nota >= 2
                                      ? Colors.orange[800]
                                      : Colors.red[800]),
                        ),
                        title: Text(
                          avaliacao.comentario ?? "Sem comentário",
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          "Avaliado em: $dataAvaliacao por Usuário ID: ${avaliacao.userId.substring(0, 5)}...",
                        ), // Exemplo de como mostrar parte do ID
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text("Avaliar esta UBS"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => HistoricoAvaliacoesScreen(
                            
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
