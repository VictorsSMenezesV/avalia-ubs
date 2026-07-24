// Arquivo: lib/screens/mock_login_screen.dart
// Adaptado para navegação direta sem rotas nomeadas, conforme protótipo original.

import "package:flutter/material.dart";

class MockLoginScreen extends StatefulWidget {
  static const String routeName =
      "/mock-login"; // Rota removida, usaremos navegação direta

  const MockLoginScreen({Key? key}) : super(key: key);

  @override
  State<MockLoginScreen> createState() => _MockLoginScreenState();
}

class _MockLoginScreenState extends State<MockLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  // Credenciais mockadas (usuário único)
  static const String _mockEmail = "usuario@exemplo.com";
  static const String _mockPassword = "senha123";

  void _performMockLogin() {
    if (_formKey.currentState!.validate()) {
      final enteredEmail = _emailController.text.trim();
      final enteredPassword = _passwordController.text.trim();

      if (enteredEmail == _mockEmail && enteredPassword == _mockPassword) {
        // Login bem-sucedido, navegar para a tela de Pesquisa de UBS
        // Usaremos pushReplacement para que o usuário não possa voltar para a tela de login com o botão "voltar"
       
      } else {
        // Credenciais inválidas
        setState(() {
          _errorMessage = "E-mail ou senha inválidos.";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Simulado - AvaliaUBS")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Acesso ao Protótipo",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  "Use as credenciais: $_mockEmail / $_mockPassword", // Dica para o usuário
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor, insira o e-mail.";
                    }
                    // Validação simples de e-mail
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Por favor, insira um e-mail válido.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Senha",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Por favor, insira a senha.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ElevatedButton(
                  onPressed: _performMockLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("ENTRAR"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
