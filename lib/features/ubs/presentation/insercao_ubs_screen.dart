// Arquivo: lib/screens/insercao_ubs_screen.dart
// Atualizado para usar UbsService e UbsModel

import "package:flutter/material.dart";
import "package:meu_app/features/ubs/data/models/ubs_model.dart";
import "package:meu_app/features/ubs/domain/entites/endereco_entity.dart";
import "package:meu_app/features/ubs/presentation/providers/ubs_controller.dart";
import "package:provider/provider.dart";

class InsercaoUbsScreen extends StatefulWidget {
  const InsercaoUbsScreen({Key? key}) : super(key: key);

  @override
  State<InsercaoUbsScreen> createState() => _InsercaoUbsScreenState();
}

class _InsercaoUbsScreenState extends State<InsercaoUbsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _municipioController = TextEditingController();
  final _estadoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cepController = TextEditingController();
  final _horarioController = TextEditingController();

  bool _isLoading = false;

  Future<void> _salvarUbs() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

  
      final novaUbs = UbsModel(
        id: "", // O ID será gerado pelo Firestore ao adicionar
        nome: _nomeController.text.trim(),
        endereco: EnderecoEntity(
          bairro: 'bairro',
          cep: 'cep',
          completo: 'completo',
          logradouro: 'logradouro',
          numero: 'numero',
        ),
        cnes: _municipioController.text.trim(),
        criadoEm: DateTime.now(),
        crs: _estadoController.text.trim(),
        distritoAdministrativo: '',
        latitude: 1,
        localizacaoPrecisao: '',
        longitude: 1,
        sts: '', nomeNormalizado: '',
      );

      final ubsService = Provider.of<UbsController>(context, listen: false);
      final error = await ubsService.cadastrarUbs(novaUbs);

      if (mounted) {
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("UBS cadastrada com sucesso!")),
          );
          _formKey.currentState!.reset();
          _nomeController.clear();
          _enderecoController.clear();
          _municipioController.clear();
          _estadoController.clear();
          _telefoneController.clear();
          _cepController.clear();
          _horarioController.clear();
          // Opcional: Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao cadastrar UBS: $error")),
          );
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _enderecoController.dispose();
    _municipioController.dispose();
    _estadoController.dispose();
    _telefoneController.dispose();
    _cepController.dispose();
    _horarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastrar Nova UBS")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTextFormField(
                controller: _nomeController,
                labelText: "Nome da UBS",
                icon: Icons.local_hospital,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              _buildTextFormField(
                controller: _enderecoController,
                labelText: "Endereço Completo",
                icon: Icons.location_on,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              _buildTextFormField(
                controller: _municipioController,
                labelText: "Município",
                icon: Icons.location_city,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
              ),
              _buildTextFormField(
                controller: _estadoController,
                labelText: "Estado (UF)",
                icon: Icons.map,
                validator: (value) => (value == null || value.isEmpty)
                    ? "Campo obrigatório"
                    : null,
                maxLength: 2,
              ),
              _buildTextFormField(
                controller: _cepController,
                labelText: "CEP",
                icon: Icons.markunread_mailbox,
                keyboardType: TextInputType.number,
              ),
              _buildTextFormField(
                controller: _telefoneController,
                labelText: "Telefone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextFormField(
                controller: _horarioController,
                labelText: "Horário de Funcionamento",
                icon: Icons.access_time,
                hintText: "Ex: Seg-Sex: 08h-17h",
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("SALVAR UBS"),
                      onPressed: _salvarUbs,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: const TextStyle(fontSize: 16.0),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    String? hintText,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          counterText: "",
        ),
        validator: validator,
        keyboardType: keyboardType,
        maxLength: maxLength,
      ),
    );
  }
}
