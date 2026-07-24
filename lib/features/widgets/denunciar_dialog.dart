import 'package:flutter/material.dart';
import 'package:meu_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart';
import 'package:meu_app/features/avaliacao/presentation/providers/avaliacao_controller.dart';
import 'package:provider/provider.dart';

Future<void> mostrarDialogoDenuncia(BuildContext context, {required String avaliacaoId, required String ubsId}) {
  MotivoDenuncia motivoSelecionado = MotivoDenuncia.conteudoOfensivo;
  final descricaoController = TextEditingController();

  return showDialog(
    context: context,
    builder: (dialogCtx) => StatefulBuilder(
      builder: (dialogCtx, setState) => AlertDialog(
        title: const Text('Denunciar avaliação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...MotivoDenuncia.values.map((m) => RadioListTile<MotivoDenuncia>(
                  value: m,
                  groupValue: motivoSelecionado,
                  title: Text(m.label),
                  onChanged: (v) => setState(() => motivoSelecionado = v!),
                  contentPadding: EdgeInsets.zero,
                )),
            const SizedBox(height: 8),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: 'Detalhes (opcional)'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              final userId = dialogCtx.read<AuthController>().currentUser!.uid;
              final erro = await dialogCtx.read<AvaliacaoController>().denunciar(
                    avaliacaoId: avaliacaoId, ubsId: ubsId, userIdDenunciante: userId,
                    motivo: motivoSelecionado, descricao: descricaoController.text,
                  );
              if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(erro ?? 'Denúncia enviada. Obrigado por ajudar a manter a qualidade das avaliações.'),
                ));
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    ),
  );
}