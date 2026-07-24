
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meu_app/features/ubs/domain/entites/endereco_entity.dart';

class UbsDetalhesScreen extends StatelessWidget {
  final String ubsId;


  const UbsDetalhesScreen({super.key, required this.ubsId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da UBS')),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // Busca só o documento específico dessa UBS
        future: FirebaseFirestore.instance.collection('ubs').doc(ubsId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('UBS não encontrada.'));
          }

          final data = snapshot.data!.data()!;

          final nome = data['nome'];
          final endereco = data['endereco'] as Map<String, dynamic>;
          final distritoAdministrativo = data['distritoAdministrativo'];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(nome, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              _InfoTile(icon: Icons.location_on, label: 'Endereço', value: endereco['logradouro']),
              _InfoTile(icon: Icons.map, label: 'Bairro', value: endereco['bairro']),
               _InfoTile(icon: Icons.map, label: 'CEP', value: endereco['cep']),
              _InfoTile(icon: Icons.phone, label: 'Telefone', value: distritoAdministrativo),
              const Divider(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      titulo: 'Nota média',
                      valor: '0',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.reviews,
                      titulo: 'Avaliações',
                      valor: '0',
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;

  const _StatCard({required this.icon, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
