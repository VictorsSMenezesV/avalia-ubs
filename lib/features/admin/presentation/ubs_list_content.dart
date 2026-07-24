import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meu_app/features/admin/presentation/providers/admin_provider.dart';
import 'package:meu_app/features/admin/presentation/ubs_detalhe_screen.dart';
import 'package:provider/provider.dart';

class UbsListScreen extends StatefulWidget {
  const UbsListScreen({super.key});

  @override
  State<UbsListScreen> createState() => _UbsListScreenState();
}

class _UbsListScreenState extends State<UbsListScreen> {
  @override
  Widget build(BuildContext context) {
    final admin = context.read<AdminController>();
    

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: admin.streamUbs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Erro: ${snapshot.error}'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('Nenhuma UBS cadastrada.'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final nome = doc.data()['nome'] as String? ?? '(sem nome)';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(nome),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UbsDetalhesScreen(ubsId: doc.id),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


