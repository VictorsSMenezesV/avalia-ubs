// presentation/ubs/screens/ubs_list_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meu_app/features/ubs/presentation/providers/ubs_lista_paginada_controller.dart';
import 'package:provider/provider.dart';

class UbsListScreen extends StatefulWidget {
  const UbsListScreen({super.key});

  @override
  State<UbsListScreen> createState() => _UbsListScreenState();
}

class _UbsListScreenState extends State<UbsListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_aoRolar);
  }

  void _aoRolar() {
    // Dispara quando falta menos de 200px pra chegar ao fim da lista
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<UbsListaPaginadaController>().carregarProximaPagina();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<UbsListaPaginadaController>();
    final itens = controller.itensExibidos;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: "Buscar UBS por nomeww",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (texto) => context.read<UbsListaPaginadaController>().buscarPorNome(texto),
          ),
        ),
        Expanded(
          child: itens.isEmpty && !controller.carregando
              ? const Center(child: Text("Nenhuma UBS encontrada."))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: itens.length + (controller.temMaisParaCarregar ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= itens.length) {
                      // último item da lista = indicador de carregamento
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final ubs = itens[index];
                    return Card(

                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      
                      title: Text(ubs.nome),
                      subtitle: Text(ubs.endereco.logradouro),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        
                        context.push('/ubs/${ubs.id}', extra: ubs.nome);
                      },
                    ),
                  );
                  },
                ),
        ),
      ],
    );
  }
}