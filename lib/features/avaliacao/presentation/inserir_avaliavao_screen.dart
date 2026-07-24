import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:provider/provider.dart';

class InserirAvaliacaoScreen extends StatefulWidget {
  final String ubsId;
  final String ubsNome;
  final AvaliacaoEntity? avaliacaoExistente;
  const InserirAvaliacaoScreen({
    super.key,
    required this.ubsId,
    required this.ubsNome,
    this.avaliacaoExistente,
  });

  @override
  State<InserirAvaliacaoScreen> createState() => _InserirAvaliacaoScreenState();
}

class _InserirAvaliacaoScreenState extends State<InserirAvaliacaoScreen> {
  late int _nota;
  bool? _teveMedicamento;
  TempoEspera? _tempoEspera;
  Lotacao? _lotacao;
  late final TextEditingController _comentarioController;
  bool _enviando = false;
  String? _erro;

  bool get _editando => widget.avaliacaoExistente != null;

  @override
  void initState() {
    super.initState();
    final existente = widget.avaliacaoExistente;
    _nota = existente?.nota ?? 5;
    _teveMedicamento = existente?.teveMedicamentoDisponivel;
    _tempoEspera = existente?.tempoEspera;
    _lotacao = existente?.lotacao;
    _comentarioController = TextEditingController(
      text: existente?.comentario ?? '',
    );
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _erro = null;
    });

    final auth = context.read<AuthController>();
    final avaliacaoController = context.read<AvaliacaoController>();

    final erro = _editando
        ? await avaliacaoController.editarAvaliacao(
            avaliacaoId: widget.avaliacaoExistente!.id,
            ubsId: widget.ubsId,
            ubsNome: widget.ubsNome,
            userId: auth.currentUser!.uid,
            nota: _nota,
            comentario: _comentarioController.text,
            teveMedicamentoDisponivel: _teveMedicamento!,
            tempoEspera: _tempoEspera!,
            lotacao: _lotacao!,
          )
        : await avaliacaoController.criarAvaliacao(
            ubsId: widget.ubsId,
            ubsNome: widget.ubsNome,
            userId: auth.currentUser!.uid,
            nota: _nota,
            comentario: _comentarioController.text,
            teveMedicamentoDisponivel: _teveMedicamento,
            tempoEspera: _tempoEspera,
            lotacao: _lotacao,
          );

    if (!mounted) return;
    setState(() => _enviando = false);

    if (erro != null) {
      setState(() => _erro = erro);
      return;
    }

    final foiDireto = _comentarioController.text.trim().isEmpty;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            foiDireto ? 'Avaliação salva!' : 'Avaliação enviada para análise.',
          ),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar avaliação' : 'Avaliar ${widget.ubsNome}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Nota', style: TextStyle(fontWeight: FontWeight.w600)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final valor = i + 1;
              return IconButton(
                iconSize: 36,
                icon: Icon(
                  valor <= _nota ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _nota = valor),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text(
            'Havia medicamento disponível?',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Sim'),
                selected: _teveMedicamento == true,
                onSelected: (_) => setState(() => _teveMedicamento = true),
              ),
              ChoiceChip(
                label: const Text('Não'),
                selected: _teveMedicamento == false,
                onSelected: (_) => setState(() => _teveMedicamento = false),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tempo de espera',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: TempoEspera.values
                .map(
                  (t) => ChoiceChip(
                    label: Text(t.label), // agora
                    selected: _tempoEspera == t,
                    onSelected: (_) => setState(() => _tempoEspera = t),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Lotação no momento',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 8,
            children: Lotacao.values
                .map(
                  (l) => ChoiceChip(
                    label: Text(l.label),
                    selected: _lotacao == l,
                    onSelected: (_) => setState(() => _lotacao = l),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comentário (opcional)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const Text(
            'Avaliações com comentário passam por uma revisão antes de aparecer publicamente.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comentarioController,
            maxLines: 3,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Opcional',
            ),
          ),
          const SizedBox(height: 24),
          if (_erro != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _erro!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          _enviando
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _enviar,
                  child: const Text('Enviar avaliação'),
                ),
        ],
      ),
    );
  }
}
